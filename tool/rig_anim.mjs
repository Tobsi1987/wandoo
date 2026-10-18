// Schreibt die Bewegungen aus rig_motions.mjs als glTF-Animationen in ein
// Dokument. Drehungen kommen als [Achse, Winkel] in Weltachsen und werden
// in die lokale Drehung des Knochens umgerechnet: L' = P⁻¹·D·P·L.
import * as THREE from 'three';
import {motions} from './rig_motions.mjs';

export function parents(root) {
  const parentOf = new Map();
  for (const n of root.listNodes()) for (const c of n.listChildren()) parentOf.set(c, n);
  const local = (n) => new THREE.Quaternion(...n.getRotation());
  const worldRot = (n) => {
    let q = new THREE.Quaternion();
    for (let p = n; p; p = parentOf.get(p)) q = local(p).multiply(q);
    return q;
  };
  return {parentOf, local, worldRot};
}

/// Alle fünf Animationen für [roles] anlegen.
export function addMotions(doc, roles, fps = 24) {
  const ctx = {doc, roles, fps, ...parents(doc.getRoot())};
  for (const m of motions(roles)) addAnim(ctx, m);
}

function addAnim({doc, roles, fps, parentOf, local, worldRot}, {name, dur, bones, lift}) {
  const root = doc.getRoot();
  const anim = doc.createAnimation(name);
  const buf = root.listBuffers()[0];
  const frames = Math.round(dur * fps);
  const times = Array.from({length: frames + 1}, (_, i) => (i / frames) * dur);
  const input = doc.createAccessor().setType('SCALAR').setArray(new Float32Array(times)).setBuffer(buf);
  const channel = (node, path, type, vals) => {
    const output = doc.createAccessor().setType(type).setArray(new Float32Array(vals)).setBuffer(buf);
    const s = doc.createAnimationSampler().setInput(input).setOutput(output).setInterpolation('LINEAR');
    anim.addSampler(s).addChannel(doc.createAnimationChannel().setTargetNode(node).setTargetPath(path).setSampler(s));
  };
  const merged = new Map();
  for (const [node, fn] of bones) {
    const before = merged.get(node);
    merged.set(node, before ? (t) => [...before(t), ...fn(t)] : fn);
  }
  for (const [node, fn] of merged) {
    const P = parentOf.get(node) ? worldRot(parentOf.get(node)) : new THREE.Quaternion();
    const Pi = P.clone().invert();
    const rest = local(node);
    const vals = [];
    for (const t of times) {
      let D = new THREE.Quaternion();
      for (const [axis, a] of fn(t)) D = new THREE.Quaternion().setFromAxisAngle(axis, a).multiply(D);
      const q = Pi.clone().multiply(D).multiply(P).multiply(rest);
      vals.push(q.x, q.y, q.z, q.w);
    }
    channel(node, 'rotation', 'VEC4', vals);
  }
  if (lift && roles.root) {
    const [x, y, z] = roles.root.getTranslation();
    const vals = [];
    for (const t of times) vals.push(x, y + lift(t) * roles.height, z);
    channel(roles.root, 'translation', 'VEC3', vals);
  }
}
