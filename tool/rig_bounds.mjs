// Die Box eines geriggten Modells in Ruhehaltung, so wie es zu sehen ist.
// Gepackte Modelle (EXT_meshopt_compression) speichern die Punkte auf
// −1…1 gestaucht und gleichen das in den Knochen aus; getBounds sähe dann
// die gestauchte Form. Deshalb wird hier jeder Punkt über seine Knochen
// gerechnet.
import * as THREE from 'three';

export function skinnedBounds(doc) {
  const box = new THREE.Box3();
  const v = new THREE.Vector3(), p = new THREE.Vector3();
  for (const node of doc.getRoot().listNodes()) {
    const mesh = node.getMesh();
    if (!mesh) continue;
    const skin = node.getSkin();
    const m4 = (a) => new THREE.Matrix4().fromArray(a);
    const joints = skin?.listJoints().map((j, i) =>
      m4(j.getWorldMatrix()).multiply(m4(skin.getInverseBindMatrices().getElement(i, []))));
    const world = m4(node.getWorldMatrix());
    for (const prim of mesh.listPrimitives()) {
      const pos = prim.getAttribute('POSITION');
      const js = prim.getAttribute('JOINTS_0'), ws = prim.getAttribute('WEIGHTS_0');
      for (let i = 0; i < pos.getCount(); i++) {
        v.fromArray(pos.getElement(i, []));
        if (!joints || !js) {
          box.expandByPoint(p.copy(v).applyMatrix4(world));
          continue;
        }
        const j = js.getElement(i, []), w = ws.getElement(i, []);
        const out = new THREE.Vector3();
        j.forEach((k, n) => w[n] && out.addScaledVector(p.copy(v).applyMatrix4(joints[k]), w[n]));
        box.expandByPoint(out);
      }
    }
  }
  return {min: box.min.toArray(), max: box.max.toArray()};
}
