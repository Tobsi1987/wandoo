// Farben: Fell je Familie, Bauch, Wangen, Mund, Muster, Ei.
// Material: 1 Körper, 2 Auge, 3 Rüschen, 4 Blatt, 5 Weiß, 6 Leuchten,
// 7 Ringelschwanz, 9 Ei, ab 10 Deko (accessories.glsl).

vec3 furColor() {
  if (uFamily < 0.5) return vec3(0.76, 0.58, 0.42);
  if (uFamily < 1.5) return vec3(0.62, 0.82, 0.96);
  if (uFamily < 2.5) return vec3(0.7, 0.7, 0.77);
  return vec3(0.98, 0.9, 0.78);
}

vec3 bodyColor(vec3 q, vec3 n) {
  vec3 col = furColor();
  if (uFamily < 0.5) {
    col = mix(col, LEAF, smoothstep(0.55, 0.8, q.y / gRadius.y) * 0.8);
  }
  vec3 dir = normalize(q);
  for (int i = 0; i < 5; i++) {
    float fi = float(i);
    if (fi >= uAccentLevel * 2.0) break;
    float side = mod(fi, 2.0) < 0.5 ? -1.0 : 1.0;
    vec3 sp = normalize(vec3(side * (0.75 - 0.12 * fi), 0.55 - 0.3 * fi,
                             0.35 + 0.05 * fi));
    col = mix(col, uAccent, smoothstep(0.955, 0.975, dot(dir, sp)) * 0.85);
  }
  float belly = smoothstep(0.2, 0.6, n.z) * smoothstep(0.1, -0.3, q.y);
  col = mix(col, WHITE, belly * 0.45);
  if (uFamily > 1.5 && uFamily < 2.5) {
    vec2 e = vec2(abs(q.x) - gRadius.x * 0.38, q.y - gRadius.y * 0.1);
    float mask = smoothstep(0.15, 0.13, length(e * vec2(0.9, 1.25))) *
                 step(0.0, q.z);
    col = mix(col, vec3(0.42, 0.41, 0.5), mask);
  }
  vec2 cheek = vec2(abs(q.x) - gRadius.x * 0.56, q.y + gRadius.y * 0.1);
  float blush = smoothstep(0.09, 0.03, length(cheek)) * step(0.0, q.z);
  col = mix(col, PINK, blush * 0.75);
  vec2 mo = vec2(q.x, q.y + gRadius.y * 0.06);
  float ring = abs(length(mo) - 0.06 * gScale);
  float mouth = smoothstep(0.014, 0.006, ring) * step(mo.y, -0.02) *
                step(0.0, q.z);
  return mix(col, EYE, mouth);
}

vec3 tailColor(vec3 q) {
  float band = step(0.5, fract((q.y + q.z * 0.5) * 9.0));
  return mix(furColor(), vec3(0.32, 0.31, 0.38), band);
}

vec3 eggColor(vec3 p) {
  vec3 q = normalize(p - gCenter);
  vec3 col = SHELL;
  if (uEggTheme > 0.5) col = themedEgg(q);
  for (int i = 0; i < 6; i++) {
    if (uEggTheme > 0.5) break;
    float fi = float(i);
    vec3 dir = normalize(vec3(sin(fi * 2.4), cos(fi * 1.7) * 0.8, cos(fi * 2.4)));
    col = mix(col, uAccent, smoothstep(0.95, 0.97, dot(q, dir)));
  }
  float zig = abs(fract(atan(q.x, q.z) * 1.6) - 0.5) * 0.12;
  float crack = smoothstep(0.012, 0.004, abs(q.y - 0.05 - zig)) * uCrack;
  return mix(col, EYE, crack);
}

vec3 materialColor(vec3 p, vec3 n, float m) {
  if (m > 8.5 && m < 9.5) return eggColor(p);
  vec3 q = toLocal(p);
  if (m > 9.5) return accessoryColor(q, m);
  vec3 nl = n;
  nl.xz = rot(gYaw) * nl.xz;
  if (m < 1.5) return bodyColor(q, nl);
  if (m < 2.5) return EYE;
  if (m < 3.5) return PINK;
  if (m < 4.5) return LEAF;
  if (m < 5.5) return WHITE;
  return tailColor(q);
}
