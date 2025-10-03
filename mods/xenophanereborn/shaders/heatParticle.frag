#pragma header

#ifdef GL_ES
precision highp float;
#endif

uniform float intensity;
uniform int amount;        
uniform float time;

vec2 uv;

float hash(float n) {
    return fract(sin(n) * 43758.5453);
}

float drawCircle(vec2 center, float radius) {
    return 1.0 - smoothstep(0.0, radius, length(uv - center));
}

void main()
{
    uv = vec2(openfl_TextureCoordv.x * 2.0, openfl_TextureCoordv.y);
    vec4 baseColor = texture2D(bitmap, openfl_TextureCoordv);
    vec4 color = baseColor;

    int maxCircles = amount;
    if (maxCircles > 64) {
        maxCircles = 64;
    }

    for (int i = 0; i < 64; i++) {
        if (i >= maxCircles) continue;

        float j = float(i) * 2.0;
        float speed = 0.3 + hash(j) * (0.7 + 0.5 * cos(j / 16.0));
        vec2 center = vec2(
            ((0.5 - uv.y) * intensity + hash(j) + 0.1 * cos(time + sin(j))) * 2.0,
            mod(sin(j) + speed * (time * 1.5 * (0.1 + intensity)), 1.0)
        );

        float weight = float(amount) / float(maxCircles);
        float glow = drawCircle(center, 0.001 + speed * (intensity * 7.5) * 0.012);

        vec3 emberColor = mix(
            vec3(1.0, 0.2, 0.0),   // deep red
            vec3(1.0, 0.9, 0.3),   // bright yellow
            fract(hash(j) + sin(time + j) * 0.5 + 0.5) // vary over time
        );
        color += vec4(emberColor * weight * 0.6 * glow, weight * 0.45 * glow);
    }

    gl_FragColor = color;
}