// Erneuert nur die Animationen fertiger App-Modelle (aus animate_rig.mjs):
// Netz, Texturen, Drehung und Größe bleiben, wie sie sind. So braucht eine
// Änderung an rig_motions.mjs keine Meshy-Rigs und keine Umbau-Flags.
//
//   node tool/reanimate.mjs app/assets/creatures/<id>.glb … [still=<id>:arms]
//   (Pakete wie bei animate_rig.mjs)
import {NodeIO} from '@gltf-transform/core';
import {ALL_EXTENSIONS} from '@gltf-transform/extensions';
import {MeshoptDecoder, MeshoptEncoder} from 'meshoptimizer';
import path from 'node:path';
import {addMotions} from './rig_anim.mjs';
import {skinnedBounds} from './rig_bounds.mjs';
import {findRoles} from './rig_roles.mjs';

const args = process.argv.slice(2);
// still=brummli3:arms+ears – diese Glieder bleiben ruhig (festgewachsen).
const still = new Map(args.filter((a) => a.startsWith('still=')).flatMap((a) =>
  a.slice(6).split(',').map((s) => s.split(':')).map(([id, k]) => [id, k.split('+')])));
await Promise.all([MeshoptDecoder.ready, MeshoptEncoder.ready]);
const io = new NodeIO().registerExtensions(ALL_EXTENSIONS)
  .registerDependencies({'meshopt.decoder': MeshoptDecoder, 'meshopt.encoder': MeshoptEncoder});

for (const file of args.filter((a) => !a.includes('='))) {
  const doc = await io.read(file);
  const root = doc.getRoot();
  for (const anim of root.listAnimations()) {
    for (const s of anim.listSamplers()) {
      for (const a of [s.getInput(), s.getOutput()]) if (a && !a.isDisposed()) a.dispose();
    }
    anim.dispose();
  }
  const roles = findRoles(root, skinnedBounds(doc));
  for (const k of still.get(path.basename(file, '.glb')) ?? []) roles[k] = [];
  addMotions(doc, roles);
  await io.write(file, doc);
  console.log(path.basename(file), roles.summary);
}
