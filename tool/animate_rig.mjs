// Macht ein Meshy-Rig (.glb mit Skelett) app-tauglich und gibt ihm die fünf
// Animationen idle, walk, happy, wave und sleep (siehe `Motion` in der App).
//
//   node tool/animate_rig.mjs rig.glb app/assets/creatures/<id>.glb [anteil]
//   (anteil < 1 vereinfacht das Netz auf diesen Anteil der Dreiecke)
//   (Pakete wie bei prepare_model.mjs, dazu three@0.169.0 und
//   @gltf-transform/extensions)
//
// Meshy-Skelette sind je Wesen anders gebaut und haben nur Nummern als Namen.
// Welche Knochen Beine, Arme, Flügel, Ohren, Schwanz und Kopf sind, ergibt
// sich deshalb aus ihrer Lage (siehe rig_roles.mjs). Das Modell steht danach
// wie bei prepare_model.mjs mit den Füßen auf y = 0 in einer 1×1-Box.
import {NodeIO} from '@gltf-transform/core';
import {ALL_EXTENSIONS} from '@gltf-transform/extensions';
import {getBounds, meshopt, simplify, textureCompress, weld} from '@gltf-transform/functions';
import {MeshoptEncoder, MeshoptSimplifier} from 'meshoptimizer';
import sharp from 'sharp';
import * as THREE from 'three';
import {centerX, findRoles} from './rig_roles.mjs';
import {motions} from './rig_motions.mjs';

const [,, inp, out, ratio = '1'] = process.argv;
await MeshoptEncoder.ready;
const io = new NodeIO().registerExtensions(ALL_EXTENSIONS)
  .registerDependencies({'meshopt.encoder': MeshoptEncoder});
const doc = await io.read(inp);
await doc.transform(textureCompress({encoder: sharp, targetFormat: 'jpeg', resize: [1024, 1024]}));
if (+ratio < 1) await doc.transform(weld(), simplify({simplifier: MeshoptSimplifier, ratio: +ratio, error: 0.01, lockBorder: true}));
const root = doc.getRoot();
const scene = root.getDefaultScene();
const bounds = getBounds(scene);
const roles = findRoles(root, bounds);

const parentOf = new Map();
for (const n of root.listNodes()) for (const c of n.listChildren()) parentOf.set(c, n);
const local = (n) => new THREE.Quaternion(...n.getRotation());
function worldRot(n) {
  let q = new THREE.Quaternion();
  for (let p = n; p; p = parentOf.get(p)) q = local(p).multiply(q);
  return q;
}

// Drehungen kommen als [Achse, Winkel] in Weltachsen und werden in die
// lokale Drehung des Knochens umgerechnet: L' = P⁻¹·D·P·L.
function addAnim({name, dur, bones, lift}, fps = 24) {
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

for (const m of motions(roles)) addAnim(m);

// Füße auf y = 0, mittig (Wirbelsäule auf x = 0), größte Seite = 1.
const cx = centerX(root, bounds), cz = (bounds.max[2] + bounds.min[2]) / 2;
const halfWidth = Math.max(bounds.max[0] - cx, cx - bounds.min[0]);
const k = 1 / Math.max(bounds.max[1] - bounds.min[1], 2 * halfWidth);
for (const n of scene.listChildren()) {
  const [x, y, z] = n.getTranslation();
  n.setScale(n.getScale().map((v) => v * k));
  n.setTranslation([(x - cx) * k, (y - bounds.min[1]) * k, (z - cz) * k]);
}
// Netz und Animationen gepackt (EXT_meshopt_compression, flutter_scene
// entpackt das): ein Drittel der Größe, ohne Dreiecke wegzulassen.
await doc.transform(meshopt({encoder: MeshoptEncoder, level: 'medium'}));
await io.write(out, doc);
console.log(out, roles.summary);
