#include <common/header.frag>

uniform sampler2D iChannel0;
uniform float warpAmount;

void mainImage(out vec4 color, in vec2 fragCoord) {
    vec2 uv = fragCoord / max(iResolution, vec2(1.0));
    vec2 p = uv * 2.0 - 1.0;
    p.x *= iResolution.x / max(iResolution.y, 1.0);

    vec2 wobble = vec2(
        sin(uv.y * 10.0 + iTime * 1.35),
        cos(uv.x * 12.0 - iTime * 1.1)
    ) * (0.025 + warpAmount * 0.04);
    vec2 sampleUv = clamp(uv + wobble, 0.0, 1.0);

    vec4 source = texture(iChannel0, sampleUv);

    float frame = smoothstep(1.08, 0.70, max(abs(p.x), abs(p.y)));
    float sheen = exp(-16.0 * length(p - vec2(0.55 * sin(iTime * 0.6), -0.3)));
    float vignette = smoothstep(1.25, 0.2, dot(p, p));

    vec3 tinted = mix(
        source.rgb,
        source.rgb * vec3(0.8, 1.05, 1.25) + vec3(0.03, 0.04, 0.08),
        0.35
    );
    tinted += vec3(0.10, 0.15, 0.24) * sheen;
    tinted *= frame * vignette;

    color = vec4(tinted, source.a);
}

#include <common/main.frag>
