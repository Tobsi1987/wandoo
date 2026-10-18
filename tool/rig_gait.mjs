// Gehen, nach dem Vorbild echter Tiere:
// - Zweibeiner setzen die Beine im Wechsel (halber Takt versetzt), die Arme
//   schwingen gegen das Bein derselben Seite.
// - Vierbeiner gehen im Viertakt: hinten links, vorn links, hinten rechts,
//   vorn rechts, je eine Vierteltakt später. Nie sind alle Füße in der Luft.
// - Ein Fuß bleibt länger am Boden als in der Luft. Im Schwung beugt sich
//   das Knie, damit der Fuß nicht schleift.
// - Der Körper springt nicht: Er senkt sich nur so weit, dass die Füße am
//   Boden bleiben, verlagert das Gewicht aufs Standbein und dreht die Hüfte.
// - Kopf, Ohren, Schwanz und Flügel folgen etwas später (Nachschwingen).
import {C, S, TAU, X, Y, chainOf, droopAxis, each, lean, raiseAxis, stride} from './rig_kit.mjs';

export function walk(r) {
  const quad = r.legs.some((l) => l.front < 0);
  const legged = r.legs.length > 0;
  const d = quad ? 1.1 : 0.9, duty = quad ? 0.65 : 0.6, A = quad ? 0.3 : 0.36;
  const w = (t) => (TAU * t) / d;
  const offset = (l) => (l.side > 0 ? 0 : 0.5) + (quad && l.front > 0 ? 0.25 : 0);
  const at = (l, t) => stride(t / d - offset(l), duty);
  // Mitte des linken Standbeins (für die Gewichtsverlagerung).
  const leftStance = duty / 2;
  const sway = legged ? (quad ? 0.012 : 0.03) : 0.06;
  return {name: 'walk', dur: d, bones: [
    ...each(r.legs, (t, l) => [[X, -A * at(l, t).reach]]),
    ...r.legs.filter((l) => l.chain.length > 2).map((l) => [l.chain[1], (t) => [[X, 0.6 * at(l, t).swing]]]),
    ...each(r.arms, (t, l) => [[X, (quad ? 0.15 : 0.3) * C(TAU * (t / d - offset(l) - 0.06))]]),
    [r.root, (t) => [[Y, 0.035 * S(w(t))], lean(1, sway * C(TAU * (t / d - leftStance)))]],
    ...(r.head ? [[r.head, (t) => [[Y, -0.025 * S(w(t))], [X, 0.02 * S(2 * w(t) - 0.9)],
      lean(1, -0.6 * sway * C(TAU * (t / d - leftStance) - 0.5))]]] : []),
    ...chainOf(r.tails, (t, l, i) => [[Y, 0.05 * S(w(t) - 0.7 - i * 0.5)]]),
    ...chainOf(r.wings, (t, l, i) => [[raiseAxis(l.dir), (i ? 0 : -0.1) + 0.035 * S(2 * w(t) - 1 - i * 0.5)]]),
    ...each(r.ears, (t, l) => [[droopAxis(l), 0.05 * S(2 * w(t) - 1.2)]]),
  ], lift: (t) => (legged ? -drop(r.legs, (l) => at(l, t), A) : 0.012 * (1 - C(2 * w(t))) / 2)};
}

/// So weit sinkt der Körper, damit schräg stehende Beine den Boden
/// berühren: ein gestrecktes Bein der Länge h unter dem Winkel a hebt den
/// Fuß um h·(1 − cos a). Am tiefsten ist er, wenn die Beine am weitesten
/// gespreizt sind, am höchsten, wenn sie sich kreuzen. Der Mittelwert
/// aller Beine verläuft ohne Ruck.
function drop(legs, step, A) {
  const down = legs.map((l) => Math.max(0, l.hip) * (1 - C(A * step(l).reach)));
  return down.reduce((a, b) => a + b, 0) / legs.length;
}
