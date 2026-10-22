#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float time;
} ubuf;

void main() {
    vec2 uv = qt_TexCoord0;
    float t = ubuf.time * 0.1;
    vec3 a = vec3(0.05, 0.08, 0.18);
    vec3 b = vec3(0.85, 0.25, 0.45);
    float m = smoothstep(0.0, 1.0, uv.y + 0.15 * sin(uv.x * 3.0 + t));
    vec3 col = mix(a, b, m);
    fragColor = vec4(col, 1.0) * ubuf.qt_Opacity;
}
