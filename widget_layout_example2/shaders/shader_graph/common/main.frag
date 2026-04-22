void main() {
    float keepAlive = iFrame + iMouse.x + iTime + iResolution.x
        + iChannelWrap.x
        + iChannelFilter.x
        + iChannelResolution0.x + iChannelResolution0.y
        + iChannelResolution1.x + iChannelResolution1.y
        + iChannelResolution2.x + iChannelResolution2.y
        + iChannelResolution3.x + iChannelResolution3.y;

    vec2 fragCoord = FlutterFragCoord().xy;
    mainImage(fragColor, fragCoord);

    if (keepAlive < -1e20) {
        fragColor += vec4(keepAlive);
    }
}
