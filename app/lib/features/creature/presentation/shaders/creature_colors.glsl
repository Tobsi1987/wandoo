// Farben auf Körper und Ei: Bauch, Wangen, Mund, Sprenkel, Risse.
// Nutzt gCenter, gRadius und die Uniforms aus creature.frag.

vec3 bodyColor(vec3 p, vec3 n) {
  vec3 q = p - gCenter;
  vec3 col = uBody;
  float belly = smoothstep(0.2, 0.6, n.z) * smoothstep(0.1, -0.3, q.y);
  col = mix(col, vec3(1.0), belly * 0.35);
  vec2 cheek = vec2(abs(q.x) - gRadius.x * 0.55, q.y + gRadius.y * 0.12);
  float blush = smoothstep(0.09, 0.03, length(cheek)) * step(0.0, q.z);
  col = mix(col, vec3(1.0, 0.55, 0.62), blush * 0.7);
  vec2 mo = vec2(q.x, q.y + gRadius.y * 0.08);
  float ring = abs(length(mo) - 0.06);
  float mouth = smoothstep(0.014, 0.006, ring) * step(mo.y, -0.02) *
                step(0.0, q.z);
  return mix(col, EYE, mouth);
}

vec3 eggColor(vec3 p) {
  vec3 q = normalize(p - gCenter);
  vec3 col = SHELL;
  for (int i = 0; i < 6; i++) {
    float fi = float(i);
    vec3 dir = normalize(vec3(sin(fi * 2.4), cos(fi * 1.7) * 0.8, cos(fi * 2.4)));
    col = mix(col, uBody, smoothstep(0.95, 0.97, dot(q, dir)));
  }
  float zig = abs(fract(atan(q.x, q.z) * 1.6) - 0.5) * 0.12;
  float crack = smoothstep(0.012, 0.004, abs(q.y - 0.05 - zig)) * uCrack;
  return mix(col, EYE, crack);
}
