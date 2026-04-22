#version 460 core
#include <flutter/runtime_effect.glsl>
precision highp float;
precision highp int;

uniform vec2 iResolution;
uniform float iTime;
uniform float iFrame;
uniform vec4 iMouse;
uniform vec4 iChannelWrap;
uniform vec4 iChannelFilter;
uniform vec2 iChannelResolution0;
uniform vec2 iChannelResolution1;
uniform vec2 iChannelResolution2;
uniform vec2 iChannelResolution3;

out vec4 fragColor;

mat2 sgRotation(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}

float sgRoundedBox(vec2 p, vec2 halfSize, float radius) {
    vec2 q = abs(p) - halfSize + vec2(radius);
    return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - radius;
}
