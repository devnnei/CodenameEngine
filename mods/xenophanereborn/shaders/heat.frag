#pragma header

uniform float uSpeed;    
uniform float uStrength;
uniform float uTime;     

float rand(vec2 co){
    return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453);
}

void main()
{
    vec2 uv = openfl_TextureCoordv.xy;
    float heightFade = 1.0 - uv.y;
    float noise = rand(vec2(uv.y * 50.0, uTime * uSpeed));
    float wave = sin(uv.y * 120.0 + uTime * uSpeed * 2.0) * 0.5 + 0.5;
    float offset = (noise * 0.6 + wave * 0.4 - 0.5) * uStrength * heightFade;
    uv.x += offset; 
    vec4 color = flixel_texture2D(bitmap, uv);
    gl_FragColor = color; 
}