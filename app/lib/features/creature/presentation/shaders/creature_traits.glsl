// Merkmale am Körper: Moos, Flossen, Laternen, Ähren (Stufe 1 bis 3).
// Nutzt gCenter, gRadius, gBulb und uTime aus creature.frag.

void moss(vec3 p, float level, inout float d, inout float m) {
  float n = 3.0 + 2.0 * level;
  for (int i = 0; i < 9; i++) {
    float fi = float(i);
    if (fi >= n) break;
    float phi = -1.3 + 2.6 * fi / (n - 1.0);
    vec3 dir = normalize(vec3(sin(phi) * 0.9, 0.85, cos(phi) * 0.35 - 0.15));
    float r = 0.07 + 0.02 * level + 0.02 * sin(fi * 2.3);
    pick(d, m, length(p - gCenter - dir * gRadius * 0.98) - r, 4.0);
  }
}

void fins(vec3 p, float level, inout float d, inout float m) {
  vec3 q = p - gCenter;
  q.x = abs(q.x) - gRadius.x * 0.98;
  q.y += 0.02;
  q.xy = rot(0.35 + 0.25 * sin(uTime * 5.0)) * q.xy;
  vec3 r = vec3(0.1 + 0.035 * level, 0.07 + 0.02 * level, 0.03);
  pick(d, m, sdEllipsoid(q - vec3(r.x * 0.7, 0.0, 0.0), r), 5.0);
}

void lanterns(vec3 p, float level, inout float d, inout float m) {
  for (int i = 0; i < 3; i++) {
    float fi = float(i);
    if (fi >= level) break;
    float x = fi == 0.0 ? 0.0 : (fi == 1.0 ? -0.16 : 0.16);
    float sway = 0.05 * sin(uTime * 2.0 + fi * 1.7);
    vec3 a = gCenter + vec3(x, gRadius.y * 0.9, 0.0);
    vec3 b = a + vec3(x * 0.6 + sway, 0.28 + 0.05 * fi, 0.04);
    pick(d, m, sdCapsule(p, a, b, 0.014), 6.0);
    float bulb = length(p - b - vec3(0.0, 0.05, 0.0)) - 0.065;
    gBulb = min(gBulb, bulb);
    pick(d, m, bulb, 7.0);
  }
}

void wheat(vec3 p, float level, inout float d, inout float m) {
  for (int i = 0; i < 4; i++) {
    float fi = float(i);
    if (fi > level) break;
    float s = mod(fi, 2.0) == 0.0 ? -1.0 : 1.0;
    float x = s * (0.24 + 0.1 * floor(fi / 2.0));
    vec3 a = gCenter + vec3(x, gRadius.y * 0.8, -0.05);
    vec3 b = a + vec3(s * 0.16, 0.34, 0.0);
    pick(d, m, sdCapsule(p, a, b, 0.012), 8.0);
    for (int g = 0; g < 4; g++) {
      float t = 0.45 + 0.17 * float(g);
      vec3 c = mix(a, b, t) + vec3(s * 0.02, 0.0, 0.0);
      pick(d, m, sdEllipsoid(p - c, vec3(0.028, 0.045, 0.028)), 8.0);
    }
  }
}
