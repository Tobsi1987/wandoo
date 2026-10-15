// Bestimmt aus der Lage der Knochen eines Meshy-Rigs, welche Knochen
// Beine, Arme, Flügel, Ohren, Schwanz und Kopf sind. Wesen schauen nach +z,
// +x ist ihre linke Seite. Alle Maße sind Anteile der Körperhöhe.
import * as THREE from 'three';

const CENTRAL = 0.03;

/// Die Mitte des Körpers in x: meist die Mitte der Box. Ragt etwas weit zur
/// Seite (ein Schwanz nach links), liegt sie dort, wo der Wurzelknochen
/// steht, also auf der Wirbelsäule.
export function centerX(root, bounds) {
  const box = (bounds.max[0] + bounds.min[0]) / 2;
  const joints = root.listSkins()[0].listJoints();
  const kids = new Set(joints.flatMap((j) => j.listChildren()));
  const spine = joints.find((j) => !kids.has(j))?.getWorldTranslation()[0] ?? box;
  return Math.abs(spine - box) > CENTRAL * (bounds.max[1] - bounds.min[1]) ? spine : box;
}

export function findRoles(root, bounds) {
  const joints = root.listSkins()[0].listJoints();
  const isJoint = new Set(joints);
  const height = bounds.max[1] - bounds.min[1];
  const mid = [centerX(root, bounds), bounds.min[1], (bounds.max[2] + bounds.min[2]) / 2];
  const pos = new Map(joints.map((j) => {
    const w = j.getWorldTranslation();
    return [j, new THREE.Vector3(...w.map((v, i) => (v - mid[i]) / height))];
  }));
  const kids = (j) => j.listChildren().filter((c) => isJoint.has(c));
  const parent = new Map();
  for (const j of joints) for (const c of kids(j)) parent.set(c, j);
  const rootJoint = joints.find((j) => !parent.has(j));
  const below = (j) => [j, ...kids(j).flatMap(below)];
  const central = (j) => Math.abs(pos.get(j).x) < CENTRAL;
  const tip = (j) => below(j).reduce((a, b) => (pos.get(b).distanceTo(pos.get(j)) > pos.get(a).distanceTo(pos.get(j)) ? b : a));
  const dir = (j) => pos.get(tip(j)).clone().sub(pos.get(j));
  const chain = (j) => [j, ...(kids(j).length ? chain(kids(j)[0]) : [])];

  // Kopf: auf dem Weg zum höchsten Knochen der letzte unter halber Höhe
  // (sonst unter 0,65), der keine Füße mitdreht.
  const top = joints.reduce((a, b) => (pos.get(b).y > pos.get(a).y ? b : a));
  const path = [];
  for (let j = top; j; j = parent.get(j)) path.unshift(j);
  const footless = (j) => below(j).every((b) => pos.get(b).y > 0.06);
  const pick = (limit) => path.slice(0, -1).filter((j) => pos.get(j).y < limit && footless(j)).pop();
  let head = pick(0.5) ?? pick(0.65) ?? null;
  if (head === rootJoint || (parent.get(head) === rootJoint && pos.get(head).y < 0.2)) head = null;
  const headY = head ? pos.get(head).y : 1;
  const inHead = new Set(head ? below(head) : []);

  const limbs = {legs: [], arms: [], wings: [], ears: [], tails: []};
  const holdsHead = (j) => head && below(j).includes(head);
  const isTail = (j) => {
    const d = dir(j);
    const thin = below(j).every((b) => kids(b).length <= 1) || below(j).every((b) => Math.abs(pos.get(b).x) < 0.06);
    return j !== rootJoint && kids(j).length && thin && !holdsHead(j) && Math.abs(pos.get(j).x) < 0.06 &&
      d.z < -0.3 * d.length() && pos.get(j).y < Math.min(headY + 0.1, 0.5);
  };
  const visit = (j) => {
    const p = pos.get(j);
    if (isTail(j)) {
      limbs.tails.push({bone: j, chain: chain(j)});
      return;
    }
    if (!central(j)) {
      const d = dir(j);
      const side = Math.sign(p.x);
      const limb = {bone: j, side, dir: d, chain: chain(j)};
      const lowest = Math.min(...below(j).map((b) => pos.get(b).y));
      if (lowest < 0.12 && p.y < 0.3) limbs.legs.push(limb);
      else if (p.y > 0.55 || (inHead.has(j) && p.y > headY + 0.1)) limbs.ears.push(limb);
      else if (d.z < -0.4 * d.length() || d.y > 0.04) limbs.wings.push(limb);
      else limbs.arms.push(limb);
      return;
    }
    kids(j).forEach(visit);
  };
  visit(rootJoint);

  // Vierbeiner: vordere Beine stehen deutlich weiter vorn.
  const legZ = limbs.legs.map((l) => pos.get(l.bone).z);
  const midZ = (Math.max(...legZ) + Math.min(...legZ)) / 2;
  const quad = legZ.length >= 4 && Math.max(...legZ) - Math.min(...legZ) > 0.12;
  for (const l of limbs.legs) l.front = quad ? (pos.get(l.bone).z > midZ ? 1 : -1) : 1;

  const name = (l) => l.bone.getName().replace('Bone_', '');
  const summary = Object.entries(limbs).map(([k, v]) => `${k}:${v.map(name).join('/')}`).join(' ') +
    ` head:${head ? name({bone: head}) : '-'}`;
  return {root: rootJoint, height, head, ...limbs, summary};
}
