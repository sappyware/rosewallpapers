#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float time;
    float width;
    float height;
} ubuf;

vec3 palette(float x) {
    vec3 a = vec3(0.025, 0.012, 0.04);
    vec3 b = vec3(0.12, 0.055, 0.16);
    vec3 c = vec3(0.08, 0.13, 0.22);
    return clamp(a + b * cos(6.28318 * (x + c)), 0.0, 0.9);
}

void main() {
    vec2 uv = qt_TexCoord0;
    vec2 p = (uv - 0.5) * vec2(ubuf.width / ubuf.height, 1.0);
    float t = ubuf.time * 0.12;

    vec2 q = p;
    q.x += 0.18 * sin(p.y * 2.4 + t);
    q.y += 0.13 * sin(p.x * 2.0 - t * 0.8);

    float a = sin(q.x * 2.7 + sin(q.y * 1.8 + t) * 0.8);
    float b = cos(q.y * 2.3 + sin(q.x * 1.7 - t) * 0.7);
    float flow = 0.5 + 0.25 * a + 0.25 * b;

    float glow1 = exp(-length(q - vec2(0.28 * sin(t), 0.12 * cos(t))) * 2.4);
    float glow2 = exp(-length(q + vec2(0.3 * cos(t * 0.7), 0.2 * sin(t * 0.8))) * 2.0);

    float shade = smoothstep(-0.65, 0.8, flow) * 0.8;
    shade += glow1 * 0.12 + glow2 * 0.08;

    vec3 col = palette(flow * 0.35 + t * 0.025) * shade;
    col += vec3(0.025, 0.008, 0.035) * (1.0 - smoothstep(0.05, 0.9, length(p)));
    col = clamp(col, 0.0, 0.72);

    fragColor = vec4(col, 1.0) * ubuf.qt_Opacity;
}
