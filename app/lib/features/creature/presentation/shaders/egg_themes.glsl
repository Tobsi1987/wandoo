// Ei-Muster je Jahreszeit oder Fest (uEggTheme, EggTheme-Index + 1):
// 1 Frühling, 2 Sommer, 3 Herbst, 4 Winter, 5 Ostern, 6 Halloween,
// 7 Weihnachten. q ist die Richtung vom Ei-Mittelpunkt.

float dots(vec3 q, float count, float size, out float which) {
  float hit = 0.0;
  which = 0.0;
  for (int i = 0; i < 14; i++) {
    float fi = float(i);
    if (fi >= count) break;
    vec3 dir = normalize(vec3(sin(fi * 2.4), cos(fi * 1.3) * 0.9,
                              cos(fi * 2.4)));
    float s = smoothstep(1.0 - size, 1.0 - size * 0.6, dot(q, dir));
    if (s > hit) {
      hit = s;
      which = mod(fi, 3.0);
    }
  }
  return hit;
}

vec3 pick3(float which, vec3 a, vec3 b, vec3 c) {
  return which < 0.5 ? a : (which < 1.5 ? b : c);
}

vec3 themedEgg(vec3 q) {
  float which;
  if (uEggTheme < 1.5) {
    vec3 col = vec3(0.9, 0.97, 0.85);
    float d = dots(q, 10.0, 0.035, which);
    return mix(col, pick3(which, PINK, GLOW, vec3(0.75, 0.6, 0.95)), d);
  }
  if (uEggTheme < 2.5) {
    vec3 col = vec3(1.0, 0.96, 0.8);
    float zig = abs(fract(atan(q.x, q.z) * 1.9) - 0.5) * 0.15;
    float band = smoothstep(0.06, 0.04, abs(q.y - zig));
    float band2 = smoothstep(0.05, 0.03, abs(q.y - 0.4 + zig));
    col = mix(col, vec3(1.0, 0.62, 0.3), band);
    return mix(col, vec3(0.45, 0.75, 0.95), band2);
  }
  if (uEggTheme < 3.5) {
    vec3 col = vec3(0.98, 0.9, 0.8);
    float d = dots(q, 9.0, 0.05, which);
    vec3 leaf = pick3(which, vec3(0.95, 0.55, 0.2), vec3(0.85, 0.3, 0.2),
                      vec3(0.65, 0.45, 0.25));
    return mix(col, leaf, d);
  }
  if (uEggTheme < 4.5) {
    vec3 col = vec3(0.86, 0.93, 1.0);
    float band = smoothstep(0.05, 0.03, abs(q.y + 0.1));
    col = mix(col, vec3(0.55, 0.75, 0.95), band);
    return mix(col, WHITE, dots(q, 14.0, 0.02, which));
  }
  if (uEggTheme < 5.5) {
    float s = floor((q.y + 1.0) * 4.0);
    vec3 col = pick3(mod(s, 3.0), vec3(1.0, 0.8, 0.86), vec3(0.75, 0.95, 0.85),
                     vec3(0.85, 0.8, 1.0));
    float edge = smoothstep(0.42, 0.47, abs(fract((q.y + 1.0) * 4.0) - 0.5));
    return mix(col, GLOW, edge);
  }
  if (uEggTheme < 6.5) {
    float ribs = 0.5 + 0.5 * cos(atan(q.x, q.z) * 8.0);
    vec3 col = mix(vec3(1.0, 0.62, 0.25), vec3(0.92, 0.5, 0.18), ribs * 0.6);
    float cap = smoothstep(0.85, 0.9, q.y);
    return mix(col, LEAF, cap);
  }
  vec3 col = vec3(0.88, 0.28, 0.3);
  float band = smoothstep(0.05, 0.03, abs(q.y));
  col = mix(col, vec3(1.0, 0.82, 0.3), band);
  return mix(col, WHITE, dots(q, 12.0, 0.022, which));
}
