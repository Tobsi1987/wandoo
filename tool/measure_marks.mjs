// Misst, wo auf jedem Wesen die Spuren der Welt sitzen (Moos, Schuppen,
// Blumenkranz, Lichter, Matsch): Strahlen treffen das Modell in Ruhehaltung,
// jeder Treffer wird ein Punkt mit Normale. Ergebnis:
// app/assets/creatures/marks.json.
//
//   npm i @gltf-transform/core@4.1.1
//   node tool/measure_marks.mjs
//
// Neu nötig, wenn ein Modell oder `model_anchors.dart` sich ändert.
import {NodeIO} from '@gltf-transform/core';
import fs from 'node:fs';

const dir = 'app/assets/creatures';
const anchorsDart = fs.readFileSync(
  'app/lib/features/creature/presentation/model/model_anchors.dart', 'utf8');
const anchors = {};
for (const m of anchorsDart.matchAll(/'(\w+)': ModelAnchors\.measured\(([^)]*)\)/g)) {
  const [hatY, hatZ, r, neckY, neckR, neckZ] = m[2].split(',').map(Number);
  anchors[m[1]] = {hatY, hatZ, r, neckY, neckR, neckZ: neckZ ?? hatZ * 0.7};
}

const mul = (a, b) => {
  const o = new Array(16).fill(0);
  for (let c = 0; c < 4; c++) for (let r = 0; r < 4; r++)
    for (let k = 0; k < 4; k++) o[c * 4 + r] += a[k * 4 + r] * b[c * 4 + k];
  return o;
};
const apply = (m, v, w = 1) => [0, 1, 2].map(
  (r) => m[r] * v[0] + m[4 + r] * v[1] + m[8 + r] * v[2] + m[12 + r] * w);

/// Alle Dreiecke des Modells in Ruhehaltung, in Modell-Einheiten.
function triangles(doc) {
  const tris = [];
  for (const node of doc.getRoot().listNodes()) {
    const mesh = node.getMesh();
    if (!mesh) continue;
    const skin = node.getSkin();
    const joints = skin?.listJoints().map((j, i) =>
      mul(j.getWorldMatrix(), skin.getInverseBindMatrices().getElement(i, [])));
    const world = node.getWorldMatrix();
    for (const prim of mesh.listPrimitives()) {
      const pos = prim.getAttribute('POSITION');
      const jw = [prim.getAttribute('JOINTS_0'), prim.getAttribute('WEIGHTS_0')];
      const pts = [];
      for (let i = 0; i < pos.getCount(); i++) {
        const v = pos.getElement(i, []);
        if (!skin || !jw[0]) { pts.push(apply(world, v)); continue; }
        const js = jw[0].getElement(i, []), ws = jw[1].getElement(i, []);
        const out = [0, 0, 0];
        js.forEach((j, k) => {
          if (!ws[k]) return;
          const p = apply(joints[j], v);
          for (let a = 0; a < 3; a++) out[a] += p[a] * ws[k];
        });
        pts.push(out);
      }
      const idx = prim.getIndices();
      const n = idx ? idx.getCount() : pts.length;
      for (let i = 0; i < n; i += 3) {
        const at = (k) => pts[idx ? idx.getScalar(i + k) : i + k];
        tris.push([at(0), at(1), at(2)]);
      }
    }
  }
  return tris;
}

const sub = (a, b) => [a[0] - b[0], a[1] - b[1], a[2] - b[2]];
const cross = (a, b) => [a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0]];
const dot = (a, b) => a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
const norm = (a) => { const l = Math.hypot(...a) || 1; return a.map((x) => x / l); };

/// Erster Treffer eines Strahls: Punkt und zum Strahl zeigende Normale.
function hit(tris, from, dir, outward = false) {
  let best = Infinity, bestN = null;
  for (const [a, b, c] of tris) {
    const e1 = sub(b, a), e2 = sub(c, a), p = cross(dir, e2), det = dot(e1, p);
    if (Math.abs(det) < 1e-12) continue;
    const t0 = sub(from, a), u = dot(t0, p) / det;
    if (u < 0 || u > 1) continue;
    const q = cross(t0, e1), v = dot(dir, q) / det;
    if (v < 0 || u + v > 1) continue;
    const t = dot(e2, q) / det;
    if (t > 1e-6 && t < best) { best = t; bestN = norm(cross(e1, e2)); }
  }
  if (!bestN) return null;
  if ((dot(bestN, dir) > 0) !== outward) bestN = bestN.map((x) => -x);
  return [...from.map((f, i) => f + dir[i] * best), ...bestN];
}

/// Punkte auf einer Scheibe, von innen nach außen.
function disc(radius, step) {
  const out = [];
  for (let u = -radius; u <= radius + 1e-9; u += step)
    for (let v = -radius; v <= radius + 1e-9; v += step)
      if (Math.hypot(u, v) <= radius) out.push([u, v]);
  return out.sort((p, q) => Math.hypot(...p) - Math.hypot(...q));
}

function measure(tris, a) {
  const top = disc(a.r * 0.85, 0.034)
    .map(([u, v]) => hit(tris, [u, 3, a.hatZ + v], [0, -1, 0]))
    .filter((h) => h && h[1] > a.hatY - a.r * 0.55 && h[1] < a.hatY + 0.04)
    .slice(0, 90);
  const backY = a.neckY + (a.hatY - a.neckY) * 0.35;
  const back = disc(0.17, 0.034)
    // Von innen nach hinten: so stört kein Schwanz hinter dem Rücken.
    .map(([u, v]) => hit(tris, [u, backY + v, 0], [0, 0, -1], true))
    .filter((h) => h && h[5] < -0.3)
    .slice(0, 60);
  const ringY = a.hatY - a.r * 0.3;
  const ring = [...Array(12).keys()].map((i) => {
    const t = (i / 12) * 2 * Math.PI, d = [-Math.sin(t), 0, -Math.cos(t)];
    return hit(tris, [3 * Math.sin(t), ringY, a.hatZ * 0.5 + 3 * Math.cos(t)], d);
  }).filter(Boolean);
  const shoulders = [1, -1]
    .map((s) => hit(tris, [3 * s, a.neckY, a.neckZ], [-s, 0, 0]))
    .filter(Boolean);
  // Untere Hälfte vorne und hinten, für Matsch an Beinen und Bauch.
  const low = [1, -1].flatMap((s) => disc(0.2, 0.04)
    .map(([u, v]) => hit(tris, [u, 0.24 + v, 3 * s], [0, 0, -s]))
    .filter((h) => h && h[1] > 0.03 && h[5] * s > 0.2));
  const flat = (hs) => hs.flat().map((x) => Math.round(x * 100) / 100);
  return {top: flat(top), back: flat(back), ring: flat(ring), shoulders: flat(shoulders), low: flat(low)};
}

const io = new NodeIO();
const out = {};
for (const id of Object.keys(anchors).sort()) {
  const doc = await io.read(`${dir}/${id}.glb`);
  out[id] = measure(triangles(doc), anchors[id]);
  const n = Object.fromEntries(Object.entries(out[id]).map(([k, v]) => [k, v.length / 6]));
  console.log(id, JSON.stringify(n));
}
fs.writeFileSync(`${dir}/marks.json`, JSON.stringify(out));
