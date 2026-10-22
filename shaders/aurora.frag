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
    float t = ubuf.time * 0.15;
    float band = 0.5 + 0.5 * sin(uv.x * 6.0 + t * 2.0 + sin(uv.y * 3.0 + t));
    float glow = smoothstep(0.35, 0.9, band) * (0.6 + 0.4 * sin(t + uv.y * 4.0));
    vec3 col = mix(vec3(0.02, 0.03, 0.08), vec3(0.15, 0.9, 0.7), glow);
    col += vec3(0.6, 0.2, 0.9) * pow(glow, 3.0) * 0.4;
    fragColor = vec4(col, 1.0) * ubuf.qt_Opacity;
}
