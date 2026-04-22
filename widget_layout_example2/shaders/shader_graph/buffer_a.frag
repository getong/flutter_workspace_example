#include <common/header.frag>

uniform float energy;

void mainImage(out vec4 color, in vec2 fragCoord) {
    vec2 uv = fragCoord / max(iResolution, vec2(1.0));
    vec2 p = uv * 2.0 - 1.0;
    p.x *= iResolution.x / max(iResolution.y, 1.0);

    vec2 center = vec2(
        0.32 * sin(iTime * 0.45),
        0.26 * cos(iTime * 0.72)
    );
    float rings = sin(18.0 * length(p - center) - iTime * 2.1);
    float stripes = sin(p.x * 7.5 + iTime * 1.2);
    stripes += cos(p.y * 9.0 - iTime * 1.0);
    stripes += sin((p.x + p.y) * 4.5 + iTime * 0.8);

    float mask = 0.5 + 0.5 * sin(stripes + rings * 0.7);
    vec3 paletteA = vec3(0.03, 0.05, 0.10);
    vec3 paletteB = vec3(0.08, 0.92, 0.76);
    vec3 paletteC = vec3(0.54, 0.24, 0.96);

    vec3 composed = mix(paletteA, paletteB, mask);
    composed += paletteC * pow(max(rings, 0.0), 2.0) * (0.25 + energy * 0.9);
    composed += vec3(0.14, 0.18, 0.22) * smoothstep(0.94, 1.0, abs(sin(p.x * 16.0)));

    color = vec4(composed, 1.0);
}

#include <common/main.frag>
