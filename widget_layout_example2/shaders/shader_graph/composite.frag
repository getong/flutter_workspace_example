#include <common/header.frag>

uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform float blendAmount;

void mainImage(out vec4 color, in vec2 fragCoord) {
    vec2 uv = fragCoord / max(iResolution, vec2(1.0));
    vec2 motion = vec2(
        sin(iTime + uv.y * 11.0),
        cos(iTime * 0.9 + uv.x * 9.0)
    ) * 0.018;

    vec4 passTexture = texture(iChannel0, clamp(uv + motion, 0.0, 1.0));
    vec4 widgetTexture = texture(iChannel1, clamp(uv - motion * 0.65, 0.0, 1.0));

    float scan = 0.93 + 0.07 * sin((uv.y + iTime * 0.35) * iResolution.y * 0.36);
    float rim = smoothstep(1.15, 0.35, length(uv * 2.0 - 1.0));

    vec3 composed = mix(passTexture.rgb, widgetTexture.rgb, blendAmount);
    composed *= scan;
    composed += vec3(0.08, 0.10, 0.14) * rim;

    color = vec4(composed, 1.0);
}

#include <common/main.frag>
