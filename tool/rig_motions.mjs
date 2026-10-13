// Die fünf Animationen für ein Rig, dessen Knochenrollen rig_roles.mjs
// gefunden hat. Jede Bewegung ist eine Drehung um Weltachsen.
//
// Der Kopf bewegt sich nur wenig und im Schlaf gar nicht: Hut, Schal und
// Schlaf-Lider sitzen in der App fest am Modell, nicht am Knochen.
import * as THREE from 'three';

const X = new THREE.Vector3(1, 0, 0), Y = new THREE.Vector3(0, 1, 0), Z = new THREE.Vector3(0, 0, 1);
const S = Math.sin, TAU = Math.PI * 2;

/// Achse, um die ein Glied nach oben schwenkt (positiver Winkel hebt es).
function raiseAxis(dir) {
  const a = dir.clone().cross(Y);
  return a.lengthSq() < 1e-6 ? X.clone() : a.normalize();
}
const elevation = (dir) => Math.asin(Math.max(-1, Math.min(1, dir.clone().normalize().y)));
/// Winkel, um ein Glied auf die Höhe [target] zu heben (nie nach unten).
const lift = (l, target) => Math.max(0, Math.min(2.2, target - elevation(l.dir)));
/// Ohren kippen nach außen, mittige nach vorn.
const droopAxis = (l) => (l.side ? Z.clone().multiplyScalar(-l.side) : X.clone());

const each = (list, fn) => list.map((l, i) => [l.bone, (t) => fn(t, l, i)]);
const chainOf = (list, fn) => list.flatMap((l) => l.chain.map((b, i) => [b, (t) => fn(t, l, i)]));
const ramp = (t, d, edge) => Math.min(1, t / edge, (d - t) / edge);

export function motions(r) {
  const head = (fn) => (r.head ? [[r.head, fn]] : []);
  const legged = r.legs.length > 0;
  const waver = r.arms.find((a) => a.side > 0) ?? r.arms[0];
  const out = [];
  {
    // Stehen: Schwanz pendelt, Flügel und Ohren bewegen sich sanft.
    const d = 2.4, w = (t) => TAU * t / d;
    out.push({name: 'idle', dur: d, bones: [
      ...head((t) => [[Z, 0.04 * S(w(t) * 0.5)]]),
      ...chainOf(r.tails, (t, l, i) => [[Y, 0.12 * S(w(t) - i * 0.6)]]),
      ...chainOf(r.wings, (t, l, i) => [[raiseAxis(l.dir), 0.08 * S(w(t)) * (i ? 0.5 : 1)]]),
      ...each(r.arms, (t, l) => [[raiseAxis(l.dir), 0.05 * S(w(t))]]),
      ...each(r.ears, (t, l, i) => [[droopAxis(l), 0.06 * Math.max(0, S(w(t) * 2 + i)) ** 8]]),
    ]});
  }
  {
    // Gehen: Beine und Arme gegengleich, Körper wippt; ohne Beine hüpfen.
    const d = 0.8, w = (t) => TAU * t / d;
    out.push({name: 'walk', dur: d, bones: [
      ...each(r.legs, (t, l) => [[X, 0.42 * l.side * l.front * S(w(t))]]),
      ...r.legs.filter((l) => l.chain.length > 2).map((l) =>
        [l.chain[1], (t) => [[X, -0.22 * Math.max(0, l.side * l.front * S(w(t) + 1))]]]),
      ...each(r.arms, (t, l) => [[X, -0.32 * l.side * S(w(t))]]),
      ...[[r.root, (t) => [[Y, 0.05 * S(w(t))], [Z, legged ? 0 : 0.06 * S(w(t))]]]],
      ...head((t) => [[Y, -0.04 * S(w(t))]]),
      ...chainOf(r.tails, (t, l, i) => [[Y, 0.2 * S(w(t) - i * 0.7)]]),
      ...chainOf(r.wings, (t, l) => [[raiseAxis(l.dir), -0.12 + 0.05 * S(w(t) * 2)]]),
      ...each(r.ears, (t, l) => [[droopAxis(l), 0.08 * Math.abs(S(w(t)))]]),
    ], lift: (t) => (legged ? 0.015 : 0.06) * Math.abs(S(w(t)))});
  }
  {
    // Freuen: Arme hoch, Flügel schlagen, Schwanz wedelt, Ohren stellen sich auf.
    const d = 1.2, w = (t) => TAU * t / d, up = (t) => ramp(t, d, 0.2);
    out.push({name: 'happy', dur: d, bones: [
      ...each(r.arms, (t, l) => [[raiseAxis(l.dir), (lift(l, 0.5) + 0.2 * S(w(t) * 3)) * up(t)]]),
      ...chainOf(r.wings, (t, l, i) => [[raiseAxis(l.dir), 0.8 * S(w(t) * 3) * (i ? 0.6 : 1) * up(t)]]),
      ...head((t) => [[Z, 0.08 * S(w(t) * 2) * up(t)]]),
      ...chainOf(r.tails, (t, l, i) => [[Y, 0.4 * S(w(t) * 4 - i * 0.6) * up(t)]]),
      ...each(r.ears, (t, l) => [[droopAxis(l), (-0.12 + 0.08 * S(w(t) * 4)) * up(t)]]),
    ], lift: (t) => (legged ? 0.02 : 0.05) * Math.abs(S(w(t) * 2)) * up(t)});
  }
  {
    // Winken: ein Arm (oder Flügel) hoch, der Unterarm schwingt hin und her.
    const d = 1.6, w = (t) => TAU * t / d, up = (t) => ramp(t, d, 0.25);
    const arm = waver ?? r.wings.find((a) => a.side > 0) ?? r.wings[0];
    const bones = [
      ...head((t) => [[Z, 0.08 * up(t)]]),
      ...chainOf(r.tails, (t, l, i) => [[Y, 0.25 * S(w(t) * 2 - i * 0.6)]]),
      ...each(r.ears, (t, l) => [[droopAxis(l), 0.06 * S(w(t) * 2)]]),
    ];
    if (arm) {
      const fore = arm.chain[1];
      bones.push([arm.bone, (t) => [[raiseAxis(arm.dir), lift(arm, 1.1) * up(t)],
        ...(fore ? [] : [[Z, 0.35 * S(w(t) * 3) * up(t)]])]]);
      if (fore) bones.push([fore, (t) => [[Z, 0.6 * arm.side * S(w(t) * 3) * up(t)]]]);
    }
    out.push({name: 'wave', dur: d, bones, lift: (t) => (arm ? 0 : 0.04 * Math.abs(S(w(t) * 2)) * up(t))});
  }
  {
    // Schlafen: Flügel angelegt, Ohren hängen, Schwanz eingerollt.
    const d = 4, w = (t) => TAU * t / d;
    out.push({name: 'sleep', dur: d, bones: [
      ...chainOf(r.wings, (t, l) => [[raiseAxis(l.dir), -0.25]]),
      ...each(r.arms, (t, l) => [[raiseAxis(l.dir), -0.15 + 0.02 * S(w(t))]]),
      ...each(r.ears, (t, l) => [[droopAxis(l), 0.35]]),
      ...chainOf(r.tails, (t, l, i) => [[Y, 0.22 + 0.03 * S(w(t) - i)]]),
    ]});
  }
  return out;
}
