// Was jede Tierfamilie ausmacht: Ohren, Schwanz, Kiemen, Blatt.
// q ist im Körper-Raum (toLocal); Material-Nummern siehe creature_colors.

void bearParts(vec3 q, inout float d, inout float m) {
  vec3 e = vec3(abs(q.x) - gRadius.x * 0.62, q.y - gRadius.y * 0.78, q.z);
  d = smin(d, length(e) - 0.12 * gScale, 0.05);
  pick(d, m, length(q - vec3(0.0, -0.16, -gRadius.z)) - 0.1 * gScale, 1.0);
  vec3 stem = vec3(0.0, gRadius.y * 0.95, 0.0);
  pick(d, m, sdCapsule(q, stem, stem + vec3(0.03, 0.1, 0.0), 0.012), 4.0);
  vec3 l = q - stem - vec3(0.09, 0.12, 0.0) * gScale;
  l.xy = rot(0.9 + 0.15 * sin(uTime * 2.0)) * l.xy;
  pick(d, m, sdEllipsoid(l, vec3(0.1, 0.045, 0.012) * gScale), 4.0);
}

void axolotlParts(vec3 q, inout float d, inout float m) {
  vec3 g = vec3(abs(q.x) - gRadius.x * 0.88, q.y - gRadius.y * 0.35, q.z);
  for (int i = 0; i < 3; i++) {
    float fi = float(i) - 1.0;
    vec3 h = g;
    h.xy = rot(-0.9 - fi * 0.55 + 0.12 * sin(uTime * 4.0 + fi)) * h.xy;
    h.y -= 0.12 * gScale;
    pick(d, m, sdEllipsoid(h, vec3(0.035, 0.13, 0.025) * gScale), 3.0);
  }
  vec3 t = q - vec3(gRadius.x * 0.55, -0.14, -gRadius.z * 0.75);
  t.xz = rot(-0.7 + 0.3 * sin(uTime * 3.0)) * t.xz;
  t.z += 0.18 * gScale;
  pick(d, m, sdEllipsoid(t, vec3(0.03, 0.13, 0.24) * gScale), 3.0);
}

void raccoonParts(vec3 q, inout float d, inout float m) {
  vec3 e = vec3(abs(q.x) - gRadius.x * 0.55, q.y - gRadius.y * 0.85, q.z);
  e.xy = rot(-0.35) * e.xy;
  d = smin(d, sdEllipsoid(e, vec3(0.09, 0.14, 0.06) * gScale), 0.04);
  vec3 a = vec3(gRadius.x * 0.4, -0.15, -gRadius.z * 0.7);
  vec3 b = a + vec3(0.46, 0.36 + 0.04 * sin(uTime * 2.0), 0.02) * gScale;
  pick(d, m, sdCapsule(q, a, b, 0.09 * gScale), 7.0);
  float tip = length(q - b) - 0.1 * gScale;
  gGlow = min(gGlow, tip);
  pick(d, m, tip, 6.0);
}

void bunnyParts(vec3 q, inout float d, inout float m) {
  float len = 0.24 * gScale * (uStage > 1.5 ? 1.15 : 1.0);
  vec3 e = vec3(abs(q.x) - gRadius.x * 0.32, q.y - gRadius.y * 0.9, q.z);
  e.xy = rot(-0.25 - 0.08 * sin(uTime * 3.0)) * e.xy;
  e.y -= len * 0.8;
  pick(d, m, sdEllipsoid(e, vec3(0.075 * gScale, len, 0.04 * gScale)), 1.0);
  pick(d, m, length(q - vec3(0.0, -0.18, -gRadius.z)) - 0.12 * gScale, 5.0);
  vec3 nose = q - vec3(0.0, gRadius.y * 0.02, gRadius.z * 0.98);
  pick(d, m, sdEllipsoid(nose, vec3(0.035, 0.025, 0.02) * gScale), 3.0);
}

void familyParts(vec3 q, inout float d, inout float m) {
  if (uFamily < 0.5) {
    bearParts(q, d, m);
  } else if (uFamily < 1.5) {
    axolotlParts(q, d, m);
  } else if (uFamily < 2.5) {
    raccoonParts(q, d, m);
  } else {
    bunnyParts(q, d, m);
  }
}
