#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float time;
} ubuf;

vec3 palette(float t) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.0, 0.33, 0.67);
    return a + b * cos(6.28318 * (c * t + d));
}

void main() {
    vec2 uv = qt_TexCoord0;
    vec2 p = (uv - 0.5) * 3.0;
    float t = ubuf.time * 0.3;
    float v = sin(p.x * 2.0 + t)
            + sin(p.y * 2.5 + t * 1.3)
            + sin((p.x + p.y) * 1.5 + t * 0.7)
            + sin(length(p) * 3.0 - t);
    vec3 col = palette(v * 0.15 + t * 0.05);
    fragColor = vec4(col, 1.0) * ubuf.qt_Opacity;
}
