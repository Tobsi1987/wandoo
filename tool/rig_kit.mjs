// Bausteine für rig_motions.mjs und rig_gait.mjs: Achsen, Hilfen, um ein
// Glied in seiner eigenen Richtung zu heben, und Listen von Knochen mit
// ihrer Bewegung. Jede Bewegung ist eine Drehung um Weltachsen; Wesen
// schauen nach +z, +x ist ihre linke Seite.
import * as THREE from 'three';

export const X = new THREE.Vector3(1, 0, 0), Y = new THREE.Vector3(0, 1, 0), Z = new THREE.Vector3(0, 0, 1);
export const S = Math.sin, C = Math.cos, TAU = Math.PI * 2;

/// Achse, um die ein Glied nach oben schwenkt (positiver Winkel hebt es).
export function raiseAxis(dir) {
  const a = dir.clone().cross(Y);
  return a.lengthSq() < 1e-6 ? X.clone() : a.normalize();
}
const elevation = (dir) => Math.asin(Math.max(-1, Math.min(1, dir.clone().normalize().y)));
/// Winkel, um ein Glied auf die Höhe [target] zu heben (nie nach unten).
export const lift = (l, target) => Math.max(0, Math.min(2.2, target - elevation(l.dir)));
/// Ohren kippen nach außen, mittige nach vorn.
export const droopAxis = (l) => (l.side ? Z.clone().multiplyScalar(-l.side) : X.clone());

/// Kippen um z, sodass die Oberseite zur Seite [side] (+1 = links) geht.
export const lean = (side, a) => [Z, -side * a];

export const each = (list, fn) => list.map((l, i) => [l.bone, (t) => fn(t, l, i)]);
export const chainOf = (list, fn) => list.flatMap((l) => l.chain.map((b, i) => [b, (t) => fn(t, l, i)]));

/// Ein Bein im Schritt. [p] = 0: der Fuß setzt vorn auf. Im Stand (Anteil
/// [duty]) bleibt er am Boden und das Bein schiebt gleichmäßig nach hinten
/// (reach 1 → -1). Im Schwung hebt er sich (swing 0 → 1 → 0, das Knie
/// beugt sich) und schwingt weich wieder nach vorn.
export function stride(p, duty) {
  const q = ((p % 1) + 1) % 1;
  if (q < duty) return {reach: 1 - (2 * q) / duty, swing: 0, stance: true};
  const u = (q - duty) / (1 - duty);
  return {reach: -C(Math.PI * u), swing: S(Math.PI * u), stance: false};
}

/// Einmal pro Durchlauf kurz zucken, bei [at] (0 bis 1) im Durchlauf.
export function twitch(t, d, at, width = 0.08) {
  const q = (((t / d - at) % 1) + 1) % 1;
  return q < width ? S((Math.PI * q) / width) : 0;
}
