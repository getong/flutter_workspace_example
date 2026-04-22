#include <common/header.frag>

uniform float pulseStrength;
uniform vec4 accentColor;

void mainImage(out vec4 color, in vec2 fragCoord) {
    vec2 uv = fragCoord / max(iResolution, vec2(1.0));
    vec2 p = uv * 2.0 - 1.0;
    p.x *= iResolution.x / max(iResolution.y, 1.0);

    vec2 pointer = vec2(
        0.45 * sin(iTime * 0.55),
        0.28 * cos(iTime * 0.35)
    );
    if (iMouse.z >= 0.0) {
        pointer = (iMouse.xy / max(iResolution, vec2(1.0))) * 2.0 - 1.0;
        pointer.x *= iResolution.x / max(iResolution.y, 1.0);
    }

    vec2 swirl = sgRotation(0.35 * sin(iTime * 0.3)) * p;
    float ribbons = sin(swirl.x * 4.3 + iTime * 1.2);
    ribbons += cos(swirl.y * 6.1 - iTime * 0.95);
    ribbons += sin((swirl.x + swirl.y) * 3.4 + iTime * 0.75);

    float glow = exp(-4.8 * length(p - pointer));
    float halo = exp(-2.3 * length(p + vec2(0.3, -0.25)));
    float mesh = smoothstep(0.92, 1.0, abs(sin(p.x * 10.0) * sin(p.y * 10.0)));

    vec3 base = mix(
        vec3(0.03, 0.04, 0.10),
        accentColor.rgb,
        0.18 + 0.12 * sin(iTime * 0.5)
    );
    vec3 spectrum = 0.5 + 0.5 * cos(
        vec3(0.0, 2.2, 4.4) + ribbons * 0.9 + iTime + vec3(p.x, p.y, p.x + p.y)
    );

    vec3 composed = base;
    composed += spectrum * (0.18 + pulseStrength * 0.28);
    composed += accentColor.rgb * glow * (0.32 + pulseStrength * 0.9);
    composed += vec3(0.35, 0.18, 0.42) * halo * 0.25;
    composed += vec3(0.08, 0.10, 0.16) * mesh;

    color = vec4(composed, 1.0);
}

#include <common/main.frag>
