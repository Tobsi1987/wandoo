// Die fünf Animationen für ein Rig, dessen Knochenrollen rig_roles.mjs
// gefunden hat (Gehen steht in rig_gait.mjs).
//
// Regeln, damit es lebendig statt mechanisch aussieht:
// - Linke und rechte Seite bewegen sich nie genau gleich (kein "Zwilling"),
//   sondern versetzt und verschieden weit.
// - Jede Animation läuft ohne Sprung in sich weiter; das Überblenden in der
//   App (ModelMotions) sorgt für den weichen Anfang. Nichts reißt hoch.
// - Schwanz, Ohren und Flügelspitzen folgen der Bewegung später.
// - Füße bleiben am Boden; Vierbeiner heben höchstens eine Pfote an.
// - Der Kopf bewegt sich nur wenig und im Schlaf gar nicht: Hut, Schal und
//   Schlaf-Lider sitzen in der App fest am Modell, nicht am Knochen.
import {walk} from './rig_gait.mjs';
import {C, S, TAU, X, Y, Z, chainOf, droopAxis, each, lean, lift, raiseAxis, twitch} from './rig_kit.mjs';

const soft = (v) => Math.max(0, v) ** 2;
const fronts = (r) => (r.legs.some((l) => l.front < 0) ? r.legs.filter((l) => l.front > 0) : []);
const knee = (l, fn) => (l.chain.length > 2 ? [[l.chain[1], fn]] : []);

export function motions(r) {
  const head = (fn) => (r.head ? [[r.head, fn]] : []);
  return [idle(r, head), walk(r), happy(r, head), wave(r, head), sleep(r)];
}

/// Stehen: atmen, Gewicht leicht verlagern, Schwanz pendelt ruhig, ab und
/// zu zuckt ein Ohr.
function idle(r, head) {
  const d = 4, w = (t) => (TAU * t) / d;
  return {name: 'idle', dur: d, bones: [
    [r.root, (t) => [lean(1, 0.012 * S(w(t))), [X, 0.008 * S(2 * w(t))]]],
    ...head((t) => [[Z, 0.03 * S(w(t) - 0.6)], [Y, 0.04 * S(w(t) + 1)]]),
    ...chainOf(r.tails, (t, l, i) => [[Y, 0.07 * S(2 * w(t) - i * 0.5)]]),
    ...chainOf(r.wings, (t, l, i) => [[raiseAxis(l.dir), 0.04 * S(2 * w(t) - i * 0.5)]]),
    ...each(r.arms, (t, l) => [[raiseAxis(l.dir), 0.04 * S(2 * w(t) + 0.3 + l.side * 0.4)]]),
    ...each(r.ears, (t, l, i) => [[droopAxis(l), 0.12 * twitch(t, d, 0.15 + 0.5 * (i % 2) + 0.07 * i)]]),
  ]};
}

/// Freuen: Arme jubeln versetzt, Flügel schlagen, Schwanz wedelt,
/// Vierbeiner trippeln abwechselnd mit den Vorderpfoten und wackeln.
function happy(r, head) {
  const d = 1.6, w = (t) => (TAU * t) / d;
  const legged = r.legs.length > 0;
  const tap = (t, l) => soft(S(2 * w(t) + (l.side > 0 ? 0 : Math.PI)));
  return {name: 'happy', dur: d, bones: [
    ...each(r.arms, (t, l) => [[raiseAxis(l.dir), lift(l, l.side > 0 ? 0.45 : 0.3) + 0.15 * S(2 * w(t) + (l.side > 0 ? 0 : 1.3))]]),
    ...chainOf(r.wings, (t, l, i) => [[raiseAxis(l.dir), 0.1 + 0.25 * S(2 * w(t) - i * 0.6)]]),
    ...head((t) => [[Z, 0.06 * S(w(t))]]),
    ...chainOf(r.tails, (t, l, i) => [[Y, 0.28 * S(4 * w(t) - i * 0.7)]]),
    ...each(r.ears, (t, l) => [[droopAxis(l), -0.1 + 0.05 * S(4 * w(t) - 1 + l.side)]]),
    ...fronts(r).flatMap((l) => [[l.bone, (t) => [[X, -0.45 * tap(t, l)]]], ...knee(l, (t) => [[X, 0.35 * tap(t, l)]])]),
    [r.root, (t) => [[Y, 0.04 * S(2 * w(t))], lean(1, legged ? 0 : 0.05 * S(2 * w(t)))]],
  ], lift: (t) => (legged ? 0 : 0.025 * (1 - C(2 * w(t))) / 2)};
}

/// Winken: Vierbeiner heben eine Vorderpfote, sonst winkt ein Arm (oder
/// Flügel). Der Körper lehnt sich auf die andere Seite, der Kopf neigt
/// sich zur winkenden.
function wave(r, head) {
  const d = 1.6, w = (t) => (TAU * t) / d;
  const paw = fronts(r).find((l) => l.side > 0) ?? fronts(r)[0];
  const arm = paw ? null : (r.arms.find((a) => a.side > 0) ?? r.arms[0] ?? r.wings.find((a) => a.side > 0) ?? r.wings[0]);
  const side = (paw ?? arm)?.side ?? 1;
  const bones = [
    ...head(() => [lean(side, 0.05)]),
    ...chainOf(r.tails, (t, l, i) => [[Y, 0.2 * S(2 * w(t) - i * 0.6)]]),
    ...each(r.ears, (t, l) => [[droopAxis(l), 0.05 * S(2 * w(t) + l.side)]]),
    [r.root, (t) => [lean(-side, paw || arm ? 0.025 : 0.06 * S(2 * w(t)))]],
  ];
  if (paw) {
    bones.push([paw.bone, (t) => [[X, -1 - 0.12 * S(3 * w(t))]]], ...knee(paw, (t) => [[X, 0.4 + 0.15 * S(3 * w(t) - 0.8)]]));
  } else if (arm) {
    const fore = arm.chain[1];
    bones.push([arm.bone, (t) => [[raiseAxis(arm.dir), lift(arm, 1.1)], ...(fore ? [] : [[Z, 0.3 * S(3 * w(t))]])]]);
    if (fore) bones.push([fore, (t) => [[Z, 0.55 * arm.side * S(3 * w(t))]]]);
  }
  return {name: 'wave', dur: d, bones};
}

/// Schlafen: ruhig atmen, Flügel angelegt, Ohren hängen, Schwanz eingerollt.
function sleep(r) {
  const d = 5, w = (t) => (TAU * t) / d;
  return {name: 'sleep', dur: d, bones: [
    [r.root, (t) => [[X, 0.012 * S(w(t))]]],
    ...chainOf(r.wings, (t, l, i) => [[raiseAxis(l.dir), -0.25 + 0.015 * S(w(t) - i * 0.4)]]),
    ...each(r.arms, (t, l) => [[raiseAxis(l.dir), -0.15 + 0.02 * S(w(t))]]),
    ...each(r.ears, (t, l) => [[droopAxis(l), 0.35]]),
    ...chainOf(r.tails, (t, l, i) => [[Y, 0.22 + 0.025 * S(w(t) - i * 0.5)]]),
  ]};
}
