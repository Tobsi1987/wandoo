// Deko aus der Schatzkiste: Hüte (uHat) und Halsschmuck (uNeck).
// q ist im Körper-Raum (toLocal). Material: 10 Eichelkappe, 11 Blüten,
// 12 Gold, 13 Muscheln, 14 Schal; Sternspitze leuchtet (6).

float sdTorus(vec3 p, float big, float small) {
  return length(vec2(length(p.xz) - big, p.y)) - small;
}

// Abstand zur Körperoberfläche auf Höhe y (Anteil von gRadius.y).
float ringRadius(float y) {
  return 0.5 * (gRadius.x + gRadius.z) * sqrt(1.0 - y * y);
}

void acornCap(vec3 q, inout float d, inout float m) {
  vec3 c = q - vec3(0.03, gRadius.y * 0.8, 0.0);
  c.xy = rot(0.22) * c.xy;
  float cap = max(sdEllipsoid(c, vec3(0.27, 0.15, 0.26) * gScale), -c.y);
  pick(d, m, cap, 10.0);
  vec3 s = vec3(0.0, 0.13, 0.0) * gScale;
  pick(d, m, sdCapsule(c, s, s + vec3(0.03, 0.07, 0.0) * gScale, 0.022), 10.0);
}

void flowerCrown(vec3 q, inout float d, inout float m) {
  float y = 0.72;
  vec3 c = q - vec3(0.0, gRadius.y * y, 0.0);
  float ring = ringRadius(y) + 0.02;
  for (int i = 0; i < 7; i++) {
    float a = float(i) / 7.0 * 6.2832 + 0.4;
    vec3 f = c - vec3(cos(a) * ring, 0.0, sin(a) * ring);
    pick(d, m, length(f) - 0.055 * gScale, 11.0);
  }
}

void starCrown(vec3 q, inout float d, inout float m) {
  float y = 0.8;
  vec3 c = q - vec3(0.0, gRadius.y * y, 0.0);
  float ring = ringRadius(y) * 0.95;
  pick(d, m, sdTorus(c, ring, 0.018 * gScale), 12.0);
  for (int i = -1; i <= 1; i++) {
    float a = 1.5708 + float(i) * 0.55;
    vec3 base = vec3(cos(a) * ring, 0.0, sin(a) * ring);
    vec3 tip = base + vec3(0.0, (i == 0 ? 0.14 : 0.09) * gScale, 0.0);
    pick(d, m, sdCapsule(c, base, tip, 0.016 * gScale), 12.0);
    float star = length(c - tip) - (i == 0 ? 0.05 : 0.035) * gScale;
    gGlow = min(gGlow, star);
    pick(d, m, star, 6.0);
  }
}

void shellNecklace(vec3 q, inout float d, inout float m) {
  float y = -0.42;
  vec3 c = q - vec3(0.0, gRadius.y * y, 0.0);
  float ring = ringRadius(y) + 0.015;
  for (int i = 0; i < 9; i++) {
    float a = 0.35 + float(i) / 8.0 * 2.44;
    vec3 b = c - vec3(cos(a) * ring, 0.0, sin(a) * ring);
    float r = (i == 4 ? 0.05 : 0.032) * gScale;
    pick(d, m, sdEllipsoid(b, vec3(r, r * 0.85, r * 0.7)), 13.0);
  }
}

void sparkleScarf(vec3 q, inout float d, inout float m) {
  float y = -0.4;
  vec3 c = q - vec3(0.0, gRadius.y * y, 0.0);
  float ring = ringRadius(y) + 0.01;
  vec3 s = c;
  s.y *= 1.6;
  pick(d, m, sdTorus(s, ring, 0.065 * gScale) / 1.6, 14.0);
  vec3 a = vec3(gRadius.x * 0.3, 0.0, ring * 0.95);
  vec3 b = a + vec3(0.03, -0.18 + 0.02 * sin(uTime * 2.0), 0.05) * gScale;
  pick(d, m, sdCapsule(c, a, b, 0.045 * gScale), 14.0);
}

void accessories(vec3 q, inout float d, inout float m) {
  if (uHat > 2.5) {
    starCrown(q, d, m);
  } else if (uHat > 1.5) {
    flowerCrown(q, d, m);
  } else if (uHat > 0.5) {
    acornCap(q, d, m);
  }
  if (uNeck > 1.5) {
    sparkleScarf(q, d, m);
  } else if (uNeck > 0.5) {
    shellNecklace(q, d, m);
  }
}

vec3 accessoryColor(vec3 q, float m) {
  if (m < 10.5) {
    float grid = step(0.5, fract(q.x * 28.0)) * step(0.5, fract(q.z * 28.0));
    return mix(vec3(0.55, 0.36, 0.2), vec3(0.45, 0.28, 0.15), grid);
  }
  if (m < 11.5) {
    float k = fract(atan(q.z, q.x) / 6.2832 * 7.0 * 0.5);
    return k < 0.5 ? vec3(1.0, 0.45, 0.5) : vec3(1.0, 0.85, 0.35);
  }
  if (m < 12.5) return vec3(1.0, 0.8, 0.3);
  if (m < 13.5) return vec3(1.0, 0.88, 0.86);
  float n = dot(floor(q * 40.0), vec3(12.9, 78.2, 37.7));
  float dots = step(0.93, fract(sin(n) * 43758.5));
  return mix(vec3(0.62, 0.48, 0.9), vec3(1.0, 0.95, 0.7), dots);
}
