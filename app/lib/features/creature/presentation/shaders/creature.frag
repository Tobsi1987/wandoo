// Das Wesen als weiche 3D-Figur, per Raymarching aus Kugeln berechnet.
// Uniform-Reihenfolge muss zu creature_shader_uniforms.dart passen.
#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;
uniform float uStage;   // 0 Ei, 1 Jungtier, 2 ausgewachsen
uniform vec3 uBody;     // Körperfarbe
uniform vec4 uTraits;   // Stufe 0..3: Moos, Flossen, Laternen, Ähren
uniform float uSleepy;  // 1 = träge
uniform float uCrack;   // 1 = Ei kurz vor dem Schlüpfen

out vec4 fragColor;

const float GROUND = -0.62;
const vec3 EYE = vec3(0.13, 0.1, 0.16);
const vec3 MOSS = vec3(0.33, 0.6, 0.27);
const vec3 FIN = vec3(0.32, 0.62, 0.86);
const vec3 STEM = vec3(0.42, 0.33, 0.26);
const vec3 GLOW = vec3(1.0, 0.85, 0.35);
const vec3 WHEAT = vec3(0.88, 0.7, 0.3);
const vec3 SHELL = vec3(0.98, 0.95, 0.88);

// Werte für map(), einmal pro Pixel berechnet.
vec3 gCenter;
vec3 gRadius;
float gBlink;
float gBulb;

#include "sdf.glsl"

float egg(vec3 p) {
  vec3 q = p - gCenter;
  float wobble = sin(uTime * (2.0 + 6.0 * uCrack)) * (0.04 + 0.1 * uCrack);
  q.xy = rot(wobble) * (q.xy + vec2(0.0, 0.5)) - vec2(0.0, 0.5);
  float taper = 1.0 + 0.22 * q.y;
  return sdEllipsoid(vec3(q.x * taper, q.y, q.z * taper), vec3(0.4, 0.52, 0.4));
}

float body(vec3 p) {
  vec3 q = p - gCenter;
  float d = sdEllipsoid(q, gRadius);
  float foot = gRadius.x * 0.32;
  vec3 f = vec3(abs(q.x) - gRadius.x * 0.45, q.y + gRadius.y * 0.88, q.z - 0.08);
  d = smin(d, sdEllipsoid(f, vec3(foot, foot * 0.6, foot * 1.2)), 0.08);
  vec3 a = vec3(abs(q.x) - gRadius.x * 0.95, q.y + 0.1, q.z - 0.05);
  a.xy = rot(-0.6) * a.xy;
  return smin(d, sdEllipsoid(a, vec3(0.08, 0.14, 0.08)), 0.06);
}

float eyes(vec3 p) {
  vec3 q = p - gCenter;
  float open = mix(1.0, 0.25, uSleepy) * (1.0 - gBlink);
  vec3 e = vec3(abs(q.x) - gRadius.x * 0.36, q.y - gRadius.y * 0.12,
                q.z - gRadius.z * 0.86);
  float r = gRadius.x * 0.2;
  return sdEllipsoid(e, vec3(r * 0.85, r * max(open, 0.08), r * 0.55));
}

#include "creature_traits.glsl"

float map(vec3 p, out float m) {
  float d;
  if (uStage < 0.5) {
    m = 9.0;
    return egg(p);
  }
  d = body(p);
  m = 1.0;
  pick(d, m, eyes(p), 2.0);
  if (uTraits.x > 0.0) moss(p, uTraits.x, d, m);
  if (uTraits.y > 0.0) fins(p, uTraits.y, d, m);
  if (uTraits.z > 0.0) lanterns(p, uTraits.z, d, m);
  if (uTraits.w > 0.0) wheat(p, uTraits.w, d, m);
  return d;
}

vec3 normalAt(vec3 p) {
  float m;
  vec2 e = vec2(0.002, -0.002);
  return normalize(e.xyy * map(p + e.xyy, m) + e.yyx * map(p + e.yyx, m) +
                   e.yxy * map(p + e.yxy, m) + e.xxx * map(p + e.xxx, m));
}

#include "creature_colors.glsl"

vec3 shade(vec3 p, vec3 rd, float m) {
  vec3 n = normalAt(p);
  vec3 light = normalize(vec3(-0.5, 0.8, 0.6));
  float diff = clamp(dot(n, light), 0.0, 1.0);
  float rim = pow(1.0 - clamp(dot(n, -rd), 0.0, 1.0), 3.0);
  float spec = pow(clamp(dot(reflect(rd, n), light), 0.0, 1.0), 24.0);
  vec3 base = m < 1.5 ? bodyColor(p, n)
            : m < 2.5 ? EYE
            : m < 4.5 ? MOSS
            : m < 5.5 ? FIN
            : m < 6.5 ? STEM
            : m < 7.5 ? GLOW
            : m < 8.5 ? WHEAT
                      : eggColor(p);
  if (m > 6.5 && m < 7.5) return GLOW * 1.15;
  vec3 col = base * (0.6 + 0.5 * diff) + rim * 0.18;
  float shine = m > 1.5 && m < 2.5 ? 0.9 : 0.25;
  if (m > 1.5 && m < 2.5) {
    vec3 sparkle = normalize(vec3(-0.35, 0.45, 1.0));
    shine += smoothstep(0.93, 0.96, dot(n, sparkle)) * 4.0;
  }
  return col + spec * shine;
}

void setup() {
  float t = uTime;
  float speed = mix(1.0, 0.4, uSleepy);
  float breath = 1.0 + 0.03 * sin(t * 2.4 * speed);
  float hop = uStage > 0.5 ? max(0.0, sin(t * 3.0)) * 0.05 * (1.0 - uSleepy) : 0.0;
  vec3 r = uStage > 1.5 ? vec3(0.56, 0.5, 0.5) : vec3(0.46, 0.42, 0.42);
  if (uStage < 0.5) r = vec3(0.4, 0.52, 0.4);
  gRadius = r * vec3(1.0 / sqrt(breath), breath, 1.0 / sqrt(breath));
  gCenter = vec3(0.0, GROUND + gRadius.y + 0.04 + hop, 0.0);
  float cycle = mod(t, 3.7);
  gBlink = smoothstep(0.0, 0.06, cycle) * smoothstep(0.18, 0.1, cycle);
  gBulb = 1e3;
}

void main() {
  vec2 frag = FlutterFragCoord().xy;
  vec2 uv = (frag - 0.5 * uSize) / uSize.y;
  uv.y = -uv.y;
  setup();
  vec3 ro = vec3(0.0, 0.05, 3.2);
  vec3 rd = normalize(vec3(uv, -1.7));
  float t = 1.6;
  float m = 0.0;
  bool hit = false;
  float glow = 1e3;
  for (int i = 0; i < 64; i++) {
    vec3 p = ro + rd * t;
    float d = map(p, m);
    glow = min(glow, gBulb);
    if (d < 0.002) {
      hit = true;
      break;
    }
    t += d;
    if (t > 4.6) break;
  }
  vec4 col = vec4(0.0);
  if (hit) {
    col = vec4(shade(ro + rd * t, rd, m), 1.0);
  } else if (rd.y < 0.0) {
    vec3 g = ro + rd * ((GROUND - ro.y) / rd.y);
    float s = smoothstep(0.55, 0.0, length(g.xz * vec2(1.0, 1.8)));
    col = vec4(vec3(0.0), s * 0.18);
  }
  float halo = exp(-max(glow, 0.0) * 18.0) * step(0.5, uTraits.z) * 0.6;
  col.rgb = col.rgb * col.a + GLOW * halo;
  col.a = clamp(col.a + halo, 0.0, 1.0);
  fragColor = col;
}
