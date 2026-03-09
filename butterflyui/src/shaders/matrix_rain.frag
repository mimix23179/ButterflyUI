#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;
uniform vec4 uColor;
uniform vec4 uAccent;
uniform float uIntensity;

out vec4 fragColor;

float random(vec2 st) {
  return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void main() {
  vec2 uv = FlutterFragCoord().xy / max(uSize, vec2(1.0));
  float columns = mix(24.0, 72.0, clamp(uIntensity, 0.0, 1.0));
  float col = floor(uv.x * columns);
  float seed = random(vec2(col, 0.17));
  float speed = mix(0.25, 1.2, clamp(uIntensity, 0.0, 1.0));
  float trail = fract(uv.y * 2.4 - uTime * speed - seed);
  float glow = smoothstep(0.0, 0.08, trail) * (1.0 - smoothstep(0.08, 0.34, trail));
  vec3 tint = mix(uColor.rgb, uAccent.rgb, smoothstep(0.0, 0.12, trail));
  float scan = 0.04 * sin((uv.y + uTime * 0.3) * 120.0);
  fragColor = vec4(tint, (glow + scan) * uColor.a);
}
