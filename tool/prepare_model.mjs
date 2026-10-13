// Macht ein Meshy-Modell (.glb, oft 10–60 MB) app-tauglich:
// Punkte verschmelzen, auf ~5 % der Dreiecke vereinfachen, Texturen auf
// 1024 px JPEG, Füße auf y = 0 und in eine 1×1-Box skaliert (~1–3 MB).
//
//   npm i @gltf-transform/core@4.1.1 @gltf-transform/functions@4.1.1 \
//     meshoptimizer@0.22.0 sharp@0.33.5
//   node tool/prepare_model.mjs meshy.glb app/assets/creatures/<id>.glb [anteil]
//
// Danach die Art in `species_looks.dart` mit `_model('<id>', …)` eintragen.
import {NodeIO} from '@gltf-transform/core';
import {weld, simplify, textureCompress, center, getBounds, prune, dedup} from '@gltf-transform/functions';
import {MeshoptSimplifier} from 'meshoptimizer';
import sharp from 'sharp';

const [,, inp, out, ratio = '0.05'] = process.argv;
const io = new NodeIO();
const doc = await io.read(inp);
await doc.transform(
  weld(),
  simplify({simplifier: MeshoptSimplifier, ratio: +ratio, error: 0.001}),
  textureCompress({encoder: sharp, targetFormat: 'jpeg', resize: [1024, 1024]}),
  center({pivot: 'below'}),
  prune(),
  dedup(),
);
const scene = doc.getRoot().getDefaultScene();
const b = getBounds(scene);
const k = 1 / Math.max(b.max[1] - b.min[1], b.max[0] - b.min[0]);
for (const n of scene.listChildren()) {
  n.setScale(n.getScale().map((v) => v * k));
  n.setTranslation(n.getTranslation().map((v) => v * k));
}
await io.write(out, doc);
console.log(`${out}: Faktor ${k.toFixed(3)}`);
