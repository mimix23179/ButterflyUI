// Simple liquid-glow field for ButterflyUI Styling.
#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;
uniform vec4 uBaseColor;
uniform vec4 uAccentColor;
uniform float uIntensity;

out vec4 fragColor;

float hash(vec2 p) {
  return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  vec2 u = f * f * (3.0 - 2.0 * f);

  float a = hash(i);
  float b = hash(i + vec2(1.0, 0.0));
  float c = hash(i + vec2(0.0, 1.0));
  float d = hash(i + vec2(1.0, 1.0));

  return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

void main() {
  vec2 uv = FlutterFragCoord().xy / uSize.xy;
  vec2 p = uv * 3.5;
  float t = uTime * 0.08;

  float n1 = noise(p + vec2(t, -t * 0.7));
  float n2 = noise(p * 1.8 - vec2(t * 1.3, t * 0.6));
  float field = smoothstep(0.2, 0.95, mix(n1, n2, 0.5));

  float glow = smoothstep(0.45, 1.0, field) * (0.55 + uIntensity * 0.45);
  vec4 color = mix(uBaseColor, uAccentColor, field);
  color.rgb += uAccentColor.rgb * glow * 0.55;
  color.a = clamp(max(uBaseColor.a, uAccentColor.a) * (0.38 + glow * 0.62), 0.0, 1.0);

  fragColor = color;
}
