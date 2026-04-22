#include <common/header.frag>

uniform sampler2D iChannel0;

float keyDown(float keyCode) {
    return texture(iChannel0, (vec2(keyCode, 0.0) + 0.5) / vec2(256.0, 3.0)).r;
}

void paintKey(
    inout vec3 scene,
    vec2 fragCoord,
    vec2 center,
    vec2 halfSize,
    float radius,
    float isPressed,
    vec3 idleColor,
    vec3 activeColor
) {
    float distance = sgRoundedBox(fragCoord - center, halfSize, radius);
    float fill = 1.0 - smoothstep(0.0, 1.5, distance);
    float outline = 1.0 - smoothstep(1.5, 4.0, abs(distance));

    vec3 keyColor = mix(idleColor, activeColor, isPressed);
    scene = mix(scene, keyColor, fill);
    scene = mix(scene, vec3(1.0), fill * isPressed * 0.14);
    scene = mix(scene, vec3(0.05, 0.06, 0.09), outline * 0.32);
}

void mainImage(out vec4 color, in vec2 fragCoord) {
    vec2 uv = fragCoord / max(iResolution, vec2(1.0));
    vec3 scene = mix(vec3(0.04, 0.05, 0.08), vec3(0.08, 0.09, 0.14), uv.y);

    float w = max(keyDown(87.0), keyDown(119.0));
    float a = max(keyDown(65.0), keyDown(97.0));
    float s = max(keyDown(83.0), keyDown(115.0));
    float d = max(keyDown(68.0), keyDown(100.0));
    float left = keyDown(37.0);
    float up = keyDown(38.0);
    float right = keyDown(39.0);
    float down = keyDown(40.0);
    float space = keyDown(32.0);

    vec2 center = iResolution * 0.5;
    float unit = clamp(min(iResolution.x, iResolution.y) * 0.115, 28.0, 48.0);
    vec2 keyHalf = vec2(unit * 0.72, unit * 0.54);
    float radius = unit * 0.30;
    float gapX = keyHalf.x * 2.0 + unit * 0.30;
    float gapY = keyHalf.y * 2.0 + unit * 0.36;
    float clusterOffset = unit * 2.7;

    vec3 idleWasd = vec3(0.14, 0.17, 0.25);
    vec3 idleArrow = vec3(0.14, 0.17, 0.25);
    vec3 idleSpace = vec3(0.16, 0.18, 0.26);

    paintKey(
        scene,
        fragCoord,
        center + vec2(-clusterOffset, gapY),
        keyHalf,
        radius,
        w,
        idleWasd,
        vec3(0.18, 0.84, 0.62)
    );
    paintKey(
        scene,
        fragCoord,
        center + vec2(-clusterOffset - gapX, 0.0),
        keyHalf,
        radius,
        a,
        idleWasd,
        vec3(0.18, 0.84, 0.62)
    );
    paintKey(
        scene,
        fragCoord,
        center + vec2(-clusterOffset, 0.0),
        keyHalf,
        radius,
        s,
        idleWasd,
        vec3(0.18, 0.84, 0.62)
    );
    paintKey(
        scene,
        fragCoord,
        center + vec2(-clusterOffset + gapX, 0.0),
        keyHalf,
        radius,
        d,
        idleWasd,
        vec3(0.18, 0.84, 0.62)
    );

    paintKey(
        scene,
        fragCoord,
        center + vec2(clusterOffset, gapY),
        keyHalf,
        radius,
        up,
        idleArrow,
        vec3(0.22, 0.55, 0.96)
    );
    paintKey(
        scene,
        fragCoord,
        center + vec2(clusterOffset - gapX, 0.0),
        keyHalf,
        radius,
        left,
        idleArrow,
        vec3(0.22, 0.55, 0.96)
    );
    paintKey(
        scene,
        fragCoord,
        center + vec2(clusterOffset, 0.0),
        keyHalf,
        radius,
        down,
        idleArrow,
        vec3(0.22, 0.55, 0.96)
    );
    paintKey(
        scene,
        fragCoord,
        center + vec2(clusterOffset + gapX, 0.0),
        keyHalf,
        radius,
        right,
        idleArrow,
        vec3(0.22, 0.55, 0.96)
    );

    paintKey(
        scene,
        fragCoord,
        center + vec2(0.0, -unit * 2.0),
        vec2(unit * 2.1, keyHalf.y),
        radius,
        space,
        idleSpace,
        vec3(0.97, 0.63, 0.28)
    );

    float activity = max(
        max(max(w, a), max(s, d)),
        max(max(left, up), max(right, max(down, space)))
    );
    vec2 glowCenter = center + vec2(0.0, -unit * 0.3);
    float glow = exp(-0.00009 * dot(fragCoord - glowCenter, fragCoord - glowCenter));
    scene += vec3(0.18, 0.22, 0.34) * glow * (0.2 + activity * 0.9);

    color = vec4(scene, 1.0);
}

#include <common/main.frag>
