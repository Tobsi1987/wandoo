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
import {addMotions, parents} from './rig_anim.mjs';

// still=arms,ears: diese Glieder bleiben ruhig (z. B. wenn sie am Körper festgewachsen sind).
// turn=90: ein quer stehendes Wesen um so viele Grad (um y) nach vorne drehen;
// der Kopf dreht sich dabei zurück zur Kamera. head=15: nur den Kopf so weit drehen.
// center=head: den Kopf statt der Wirbelsäule auf x = 0 stellen.
// wide=1.5: so viel breiter als hoch darf das Wesen sein (große Flügel).
const [,, inp, out, ...rest] = process.argv;
const opt = Object.fromEntries(rest.filter((a) => a.includes('=')).map((a) => a.split('=')));
const ratio = rest.find((a) => !a.includes('=')) ?? '1';
const still = opt.still ?? '';
await MeshoptEncoder.ready;
const io = new NodeIO().registerExtensions(ALL_EXTENSIONS)
  .registerDependencies({'meshopt.encoder': MeshoptEncoder});
const doc = await io.read(inp);
await doc.transform(textureCompress({encoder: sharp, targetFormat: 'jpeg', resize: [1024, 1024]}));
if (+ratio < 1) await doc.transform(weld(), simplify({simplifier: MeshoptSimplifier, ratio: +ratio, error: 0.01, lockBorder: true}));
const root = doc.getRoot();
const scene = root.getDefaultScene();
const Y = new THREE.Vector3(0, 1, 0);
const turn = new THREE.Quaternion().setFromAxisAngle(Y, ((+opt.turn || 0) * Math.PI) / 180);
const bounds = turned(getBounds(scene), turn);
for (const n of scene.listChildren()) n.setRotation(turn.clone().multiply(new THREE.Quaternion(...n.getRotation())).toArray());
let roles = findRoles(root, bounds);

const {parentOf, local, worldRot} = parents(root);

// Kopf und Hals drehen je zur Hälfte zurück, damit der Kopf zur Kamera schaut.
const twist = +(opt.head ?? -(opt.turn ?? 0));
if (twist && roles.head) {
  for (const n of [roles.head, roles.head.listChildren().find((c) => parentOf.get(c) === roles.head && c.listChildren().length)]) {
    const P = worldRot(parentOf.get(n));
    const D = new THREE.Quaternion().setFromAxisAngle(Y, (twist * Math.PI) / 360);
    n.setRotation(P.clone().invert().multiply(D).multiply(P).multiply(local(n)).toArray());
  }
  roles = findRoles(root, bounds);
}
for (const k of still.split(',').filter(Boolean)) roles[k] = [];

addMotions(doc, roles);

// Füße auf y = 0, mittig (Wirbelsäule auf x = 0), größte Seite = 1.
const cx = opt.center === 'head' && roles.head ? roles.head.getWorldTranslation()[0] : centerX(root, bounds);
const cz = (bounds.max[2] + bounds.min[2]) / 2;
const halfWidth = Math.max(bounds.max[0] - cx, cx - bounds.min[0]);
const k = 1 / Math.max(bounds.max[1] - bounds.min[1], (2 * halfWidth) / (+opt.wide || 1));
for (const n of scene.listChildren()) {
  const [x, y, z] = n.getTranslation();
  n.setScale(n.getScale().map((v) => v * k));
  n.setTranslation([(x - cx) * k, (y - bounds.min[1]) * k, (z - cz) * k]);
}
// Netz und Animationen gepackt (EXT_meshopt_compression, flutter_scene
// entpackt das): ein Drittel der Größe, ohne Dreiecke wegzulassen.
await doc.transform(meshopt({encoder: MeshoptEncoder, level: 'medium'}));
await io.write(out, doc);

/// Die Box nach der Drehung (um y) als neue achsenparallele Box.
function turned({min, max}, q) {
  const pts = [0, 1, 2, 3, 4, 5, 6, 7].map((i) =>
    new THREE.Vector3(i & 1 ? max[0] : min[0], i & 2 ? max[1] : min[1], i & 4 ? max[2] : min[2]).applyQuaternion(q));
  return {min: [0, 1, 2].map((a) => Math.min(...pts.map((p) => p.getComponent(a)))),
    max: [0, 1, 2].map((a) => Math.max(...pts.map((p) => p.getComponent(a))))};
}
console.log(out, roles.summary);
