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

const vec3 MANTLE  = vec3(0.094, 0.094, 0.145);
const vec3 BASE    = vec3(0.118, 0.118, 0.180);
const vec3 SURFACE = vec3(0.192, 0.196, 0.267);
const vec3 PINK    = vec3(0.961, 0.761, 0.906);
const vec3 MAUVE   = vec3(0.796, 0.651, 0.969);
const vec3 ROSEW   = vec3(0.961, 0.878, 0.863);
const vec3 RED     = vec3(0.953, 0.545, 0.659);

float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

float fbm(vec2 p) {
    float v = 0.0;
    float a = 0.5;
    for (int i = 0; i < 4; i++) {
        v += a * noise(p);
        p = p * 2.03 + vec2(3.7, 1.3);
        a *= 0.5;
    }
    return v;
}

void main() {
    vec2 uv = qt_TexCoord0;
    vec2 p = (uv - 0.5) * vec2(ubuf.width / ubuf.height, 1.0) * 2.0;
    float t = ubuf.time * 0.055;

    vec2 q = vec2(fbm(p + vec2(0.0, t * 0.7)),
                  fbm(p + vec2(5.2, 1.3) - t * 0.6));
    vec2 r = vec2(fbm(p + 2.2 * q + vec2(1.7, 9.2) + t * 0.4),
                  fbm(p + 2.2 * q + vec2(8.3, 2.8) - t * 0.35));
    float h = fbm(p + 1.8 * r);

    float bands = 10.0;
    float fb = fract(h * bands);
    float e0 = smoothstep(0.0, 0.16, fb);
    float e1 = 1.0 - smoothstep(0.84, 1.0, fb);
    float line = 1.0 - e0 * e1;
    line = smoothstep(0.25, 0.9, line);

    float fb2 = fract(h * bands * 2.0);
    float f0 = smoothstep(0.0, 0.22, fb2);
    float f1 = 1.0 - smoothstep(0.78, 1.0, fb2);
    float line2 = 1.0 - f0 * f1;
    line2 = smoothstep(0.35, 0.9, line2);

    vec3 col = MANTLE;
    col = mix(col, BASE, smoothstep(0.15, 0.45, h));
    col = mix(col, SURFACE, smoothstep(0.4, 0.7, h) * 0.65);

    vec3 lineCol = mix(PINK, MAUVE, smoothstep(0.25, 0.75, h));
    col = mix(col, lineCol, line * 0.7);

    col = mix(col, MAUVE * 0.65, line2 * 0.22);

    float peak = pow(smoothstep(0.55, 0.85, h), 3.0);
    col += RED * peak * 0.15;
    col += PINK * peak * 0.08;

    float depth = smoothstep(0.1, 0.6, h);
    col = mix(col, ROSEW * 0.5, depth * 0.06);

    float vig = 1.0 - smoothstep(0.9, 1.8, length(p));
    col *= 0.55 + 0.45 * vig;

    fragColor = vec4(col, 1.0) * ubuf.qt_Opacity;
}
