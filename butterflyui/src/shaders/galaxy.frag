#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;
uniform vec4 uColor;
uniform vec4 uAccent;
uniform float uIntensity;

out vec4 fragColor;

float hash(vec2 p) {
  return fract(sin(dot(p, vec2(41.3, 289.7))) * 43758.5453);
}

void main() {
  vec2 uv = (FlutterFragCoord().xy / max(uSize, vec2(1.0))) * 2.0 - 1.0;
  float r = length(uv);
  float angle = atan(uv.y, uv.x);
  float swirl = sin(angle * 3.0 - uTime * 0.8 + r * 8.0);
  float nebula = smoothstep(1.15, 0.15, r) * (0.55 + 0.45 * swirl);
  float stars = step(0.9975, hash(floor((uv + 1.0) * 140.0 + uTime * 8.0)));
  vec3 color = mix(uColor.rgb, uAccent.rgb, clamp(nebula, 0.0, 1.0));
  color += vec3(stars) * (0.45 + uIntensity * 0.35);
  fragColor = vec4(color, clamp(nebula * 0.85 + stars, 0.0, 1.0) * uColor.a);
}
