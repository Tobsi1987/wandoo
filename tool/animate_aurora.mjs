// Fügt dem Meshy-Rig von Aurora Animationen hinzu (idle, walk, happy,
// wave, sleep) und skaliert es auf 1 Einheit Höhe, Füße auf y = 0.
//   node tool/animate_aurora.mjs rig.glb app/assets/creatures/aurora.glb
// (Pakete wie bei prepare_model.mjs, dazu three@0.169.0)
import {NodeIO} from '@gltf-transform/core';
import {textureCompress} from '@gltf-transform/functions';
import sharp from 'sharp';
import * as THREE from 'three';

const [,, inp, out] = process.argv;
const io = new NodeIO();
const doc = await io.read(inp);
await doc.transform(textureCompress({encoder: sharp, targetFormat: 'jpeg', resize: [1024, 1024]}));
const root = doc.getRoot();
const nodes = root.listNodes();
const byName = (n) => nodes.find((x) => x.getName() === n);
const B = (i) => byName('Bone_' + String(i).padStart(3, '0'));

// Rollen der Knochen (aus Lage im Raum bestimmt).
const R = {
  hips: B(0), pelvis: B(1),
  legA: [6, 5, 4].map(B), legB: [11, 10, 9].map(B),
  spine: [14, 13, 12].map(B),
  armA: [25, 24, 23].map(B), armB: [30, 29, 28].map(B),
  neck: B(32), head: B(31),
  earA: [39, 38].map(B), earB: [42, 41].map(B),
  wingA: [45, 44].map(B), wingB: [48, 47].map(B),
  tail: [20, 19, 18, 17, 16].map(B),
};

const parentOf = new Map();
for (const n of nodes) for (const c of n.listChildren()) parentOf.set(c, n);
const local = (n) => new THREE.Quaternion(...n.getRotation());
function worldRot(n) {
  let q = new THREE.Quaternion();
  for (let p = n; p; p = parentOf.get(p)) q = local(p).multiply(q);
  return q;
}
const rest = new Map(nodes.map((n) => [n, local(n)]));
const restT = new Map(nodes.map((n) => [n, n.getTranslation().slice()]));
const parentW = new Map(nodes.map((n) => [n, parentOf.get(n) ? worldRot(parentOf.get(n)) : new THREE.Quaternion()]));

const X = new THREE.Vector3(1, 0, 0), Y = new THREE.Vector3(0, 1, 0), Z = new THREE.Vector3(0, 0, 1);
const S = Math.sin, TAU = Math.PI * 2;

// Eine Animation: für jeden Knochen eine Funktion t -> Liste [Achse, Winkel]
// in Weltachsen; dazu optional Hüft-Verschiebung.
function addAnim(name, dur, rot, lift = null, fps = 24) {
  const anim = doc.createAnimation(name);
  const buf = root.listBuffers()[0];
  const frames = Math.round(dur * fps);
  const times = Array.from({length: frames + 1}, (_, i) => (i / frames) * dur);
  const input = doc.createAccessor().setType('SCALAR').setArray(new Float32Array(times)).setBuffer(buf);
  for (const [node, fn] of rot) {
    const vals = [];
    const P = parentW.get(node), Pi = P.clone().invert();
    for (const t of times) {
      let D = new THREE.Quaternion();
      for (const [axis, a] of fn(t)) D = new THREE.Quaternion().setFromAxisAngle(axis, a).multiply(D);
      const q = Pi.clone().multiply(D).multiply(P).multiply(rest.get(node));
      vals.push(q.x, q.y, q.z, q.w);
    }
    const output = doc.createAccessor().setType('VEC4').setArray(new Float32Array(vals)).setBuffer(buf);
    const s = doc.createAnimationSampler().setInput(input).setOutput(output).setInterpolation('LINEAR');
    anim.addSampler(s).addChannel(doc.createAnimationChannel().setTargetNode(node).setTargetPath('rotation').setSampler(s));
  }
  if (lift) {
    const vals = [];
    const [x, y, z] = restT.get(R.hips);
    for (const t of times) vals.push(x, y + lift(t), z);
    const output = doc.createAccessor().setType('VEC3').setArray(new Float32Array(vals)).setBuffer(buf);
    const s = doc.createAnimationSampler().setInput(input).setOutput(output).setInterpolation('LINEAR');
    anim.addSampler(s).addChannel(doc.createAnimationChannel().setTargetNode(R.hips).setTargetPath('translation').setSampler(s));
  }
}

const chain = (bones, fn) => bones.map((b, i) => [b, (t) => fn(t, i)]);

// Ruhig atmen, Schwanz und Flügel bewegen sich sanft (2,4 s Schleife).
{
  const d = 2.4, w = (t) => TAU * t / d;
  addAnim('idle', d, [
    [R.spine[0], (t) => [[X, 0.015 * S(w(t))]]],
    [R.head, (t) => [[Z, 0.04 * S(w(t) * 0.5)]]],
    ...chain(R.tail, (t, i) => [[Y, 0.12 * S(w(t) - i * 0.6)]]),
    ...chain(R.wingA, (t, i) => [[Z, 0.08 * S(w(t)) * (i ? 0.5 : 1)]]),
    ...chain(R.wingB, (t, i) => [[Z, -0.08 * S(w(t)) * (i ? 0.5 : 1)]]),
    [R.earA[0], (t) => [[Z, -0.05 * Math.max(0, S(w(t) * 2)) ** 8]]],
    [R.earB[0], (t) => [[Z, 0.05 * Math.max(0, S(w(t) * 2 + 1)) ** 8]]],
  ]);
}
// Gehen (0,8 s Schleife): Beine und Arme gegengleich, leichtes Wippen.
{
  const d = 0.8, w = (t) => TAU * t / d;
  addAnim('walk', d, [
    [R.legA[0], (t) => [[X, 0.45 * S(w(t))]]],
    [R.legB[0], (t) => [[X, -0.45 * S(w(t))]]],
    [R.legA[1], (t) => [[X, -0.25 * Math.max(0, S(w(t) + 1))]]],
    [R.legB[1], (t) => [[X, -0.25 * Math.max(0, -S(w(t) + 1))]]],
    [R.armA[0], (t) => [[X, -0.35 * S(w(t))]]],
    [R.armB[0], (t) => [[X, 0.35 * S(w(t))]]],
    [R.spine[0], (t) => [[Y, 0.06 * S(w(t))]]],
    [R.head, (t) => [[Y, -0.05 * S(w(t))]]],
    ...chain(R.tail, (t, i) => [[Y, 0.2 * S(w(t) - i * 0.7)]]),
    ...chain(R.wingA, (t, i) => [[Z, -0.15 + 0.05 * S(w(t) * 2)]]),
    ...chain(R.wingB, (t, i) => [[Z, 0.15 - 0.05 * S(w(t) * 2)]]),
  ], (t) => 0.025 * Math.abs(S(w(t))));
}
// Freuen (1,2 s): Flügel schlagen, Arme hoch, Schwanz wedelt.
{
  const d = 1.2, w = (t) => TAU * t / d;
  const up = (t) => Math.min(1, t / 0.2, (d - t) / 0.2);
  addAnim('happy', d, [
    [R.armA[0], (t) => [[Z, 1.4 * up(t) + 0.2 * S(w(t) * 3)]]],
    [R.armB[0], (t) => [[Z, -1.4 * up(t) - 0.2 * S(w(t) * 3)]]],
    ...chain(R.wingA, (t, i) => [[Z, (0.9 * S(w(t) * 3)) * (i ? 0.6 : 1) * up(t)]]),
    ...chain(R.wingB, (t, i) => [[Z, (-0.9 * S(w(t) * 3)) * (i ? 0.6 : 1) * up(t)]]),
    [R.head, (t) => [[Z, 0.15 * S(w(t) * 2) * up(t)], [X, -0.12 * up(t)]]],
    ...chain(R.tail, (t, i) => [[Y, 0.4 * S(w(t) * 4 - i * 0.6) * up(t)]]),
    [R.earA[0], (t) => [[Z, 0.15 * up(t)]]],
    [R.earB[0], (t) => [[Z, -0.15 * up(t)]]],
  ]);
}
// Winken (1,6 s): ein Arm hoch, Unterarm schwingt.
{
  const d = 1.6, w = (t) => TAU * t / d;
  const up = (t) => Math.min(1, t / 0.25, (d - t) / 0.25);
  addAnim('wave', d, [
    [R.armA[0], (t) => [[Z, 2.2 * up(t)]]],
    [R.armA[1], (t) => [[Z, 0.7 * S(w(t) * 3) * up(t)]]],
    ...chain(R.wingA, (t, i) => [[Z, 0.25 * S(w(t) * 2) * up(t)]]),
    [R.head, (t) => [[Z, 0.12 * up(t)]]],
    ...chain(R.tail, (t, i) => [[Y, 0.25 * S(w(t) * 2 - i * 0.6)]]),
  ]);
}
// Schlafen (4 s Schleife): Flügel angelegt, Ohren hängen, langsam atmen.
{
  const d = 4, w = (t) => TAU * t / d;
  addAnim('sleep', d, [
    // Kopf bleibt still: Schlaf-Lider und Hut sitzen fest am Modell.
    [R.spine[0], (t) => [[X, 0.015 * S(w(t))]]],
    ...chain(R.wingA, (t, i) => [[Z, -0.3]]),
    ...chain(R.wingB, (t, i) => [[Z, 0.3]]),
    [R.armA[0], (t) => [[Z, -0.2]]],
    [R.armB[0], (t) => [[Z, 0.2]]],
    [R.earA[0], (t) => [[Z, -0.35]]],
    [R.earB[0], (t) => [[Z, 0.35]]],
    ...chain(R.tail, (t, i) => [[Y, 0.25 + 0.03 * S(w(t) - i)]]),
  ]);
}

// Auf 1 Einheit Höhe bringen (Füße stehen schon auf y = 0).
const top = root.getDefaultScene().listChildren()[0];
top.setScale([1 / 1.7, 1 / 1.7, 1 / 1.7]);
await io.write(out, doc);
console.log('ok', root.listAnimations().map((a) => a.getName()));
