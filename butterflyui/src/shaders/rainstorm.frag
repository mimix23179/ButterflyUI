#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;
uniform vec4 uColor;
uniform vec4 uAccent;
uniform float uIntensity;

out vec4 fragColor;

float hash(float n) {
  return fract(sin(n) * 43758.5453123);
}

void main() {
  vec2 uv = FlutterFragCoord().xy / max(uSize, vec2(1.0));
  float density = mix(18.0, 64.0, clamp(uIntensity, 0.0, 1.0));
  float column = floor(uv.x * density);
  float seed = hash(column * 17.0);
  float speed = mix(0.5, 2.0, clamp(uIntensity, 0.0, 1.0));
  float drop = fract(uv.y * 2.2 + seed - uTime * speed);
  float streak = smoothstep(0.0, 0.035, drop) * (1.0 - smoothstep(0.035, 0.18, drop));
  vec3 tint = mix(uColor.rgb, uAccent.rgb, 0.45 + 0.25 * sin(uTime + column));
  fragColor = vec4(tint, streak * uColor.a);
}
