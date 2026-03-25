#version 150
#define FSH
#define RENDERTYPE_TEXT

#moj_import <fog.glsl>

uniform sampler2D Sampler0;
uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform float GameTime;
uniform vec2 ScreenSize;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec4 baseColor;
in vec4 lightColor;

out vec4 fragColor;

#moj_import <spheya_packs_impl.glsl>

struct Gradient {
    ivec3 trigger;
    vec3 colors[4];
    int colorCount;
    float speed;
    float angle;
    float glossSpeed;
    float glossIntensity;
};

vec3 hexToRgb(int hex) {
    return vec3(
        float((hex >> 16) & 0xFF)/255.0,
        float((hex >> 8) & 0xFF)/255.0,
        float(hex & 0xFF)/255.0
    );
}

float getAngleFactor(vec2 pos, float angle) {
    float rad = radians(angle);
    return pos.x * cos(rad) + pos.y * sin(rad);
}

vec4 getGradientColor(Gradient grad, float t) {
    float mixVal = 0.5+0.5*sin(GameTime*grad.speed+t*5.0);
    
    if(grad.colorCount == 2) {
        return vec4(mix(grad.colors[0], grad.colors[1], mixVal), 1.0);
    } else if(grad.colorCount == 3) {
        float pos = mod(mixVal * 3.0, 3.0);
        if(pos < 1.0) {
            return vec4(mix(grad.colors[0], grad.colors[1], pos), 1.0);
        } else if(pos < 2.0) {
            return vec4(mix(grad.colors[1], grad.colors[2], pos - 1.0), 1.0);
        } else {
            return vec4(mix(grad.colors[2], grad.colors[0], pos - 2.0), 1.0);
        }
    } else {
        float pos = mod(mixVal * 4.0, 4.0);
        if(pos < 1.0) {
            return vec4(mix(grad.colors[0], grad.colors[1], pos), 1.0);
        } else if(pos < 2.0) {
            return vec4(mix(grad.colors[1], grad.colors[2], pos - 1.0), 1.0);
        } else if(pos < 3.0) {
            return vec4(mix(grad.colors[2], grad.colors[3], pos - 2.0), 1.0);
        } else {
            return vec4(mix(grad.colors[3], grad.colors[0], pos - 3.0), 1.0);
        }
    }
}

vec4 applyGlossToGradient(Gradient grad, vec4 gradColor) {
    vec2 pos = gl_FragCoord.xy / 100.0;
    float f = pos.x + pos.y - GameTime * 6400.0 * grad.glossSpeed;
    
    if(mod(f, 5.0) < 0.5) {
        return mix(gradColor, vec4(1.0, 1.0, 1.0, 1.0), grad.glossIntensity);
    }
    return gradColor;
}

void main() {
    if(applySpheyaPacks()) return;

    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;

    if (color.a < 0.1) {
        discard;
    }

    ivec3 iColor = ivec3(baseColor.xyz*255.0+vec3(0.5));
    
    Gradient grad;
    bool foundGradient = false;
    
    if(iColor == ivec3(224,48,9)) {
        grad.trigger = ivec3(224,48,9);
        grad.colors[0] = hexToRgb(0xC90238);
        grad.colors[1] = hexToRgb(0x600026);
        grad.colors[2] = hexToRgb(0xE03009);
        grad.colorCount = 3;
        grad.speed = 5000.0;
        grad.angle = 45.0;
        grad.glossSpeed = 0.55;
        grad.glossIntensity = 0.45;
        foundGradient = true;
    } else if(iColor == ivec3(31,122,254)) {
        grad.colors[0] = hexToRgb(0x002EFD);
        grad.colors[1] = hexToRgb(0x5644FC);
        grad.colors[2] = hexToRgb(0x0AB1FF);
        grad.colorCount = 3;
        grad.speed = 4500.0;
        grad.angle = 90.0;
        grad.glossSpeed = 0.45;
        grad.glossIntensity = 0.35;
        foundGradient = true;
    } else if(iColor == ivec3(190,26,245)) {
        grad.colors[0] = hexToRgb(0x6600A1);
        grad.colors[1] = hexToRgb(0x9C23FF);
        grad.colors[2] = hexToRgb(0xE00AF3);
        grad.colorCount = 3;
        grad.speed = 5500.0;
        grad.angle = 135.0;
        grad.glossSpeed = 0.55;
        grad.glossIntensity = 0.45;
        foundGradient = true;
    } else if(iColor == ivec3(255,165,0)) {
        grad.colors[0] = hexToRgb(0xFFD700);
        grad.colors[1] = hexToRgb(0xFF8C00);
        grad.colors[2] = hexToRgb(0xDAA520);
        grad.colorCount = 3;
        grad.speed = 4000.0;
        grad.angle = 0.0;
        grad.glossSpeed = 0.5;
        grad.glossIntensity = 0.4;
        foundGradient = true;
    } else if(iColor == ivec3(0,255,127)) {
        grad.colors[0] = hexToRgb(0x00FF7F);
        grad.colors[1] = hexToRgb(0x228B22);
        grad.colors[2] = hexToRgb(0x32CD32);
        grad.colorCount = 3;
        grad.speed = 3500.0;
        grad.angle = 45.0;
        grad.glossSpeed = 0.0;
        grad.glossIntensity = 0.0;
        foundGradient = true;
    } else if(iColor == ivec3(255,20,147)) {
        grad.colors[0] = hexToRgb(0xFF1493);
        grad.colors[1] = hexToRgb(0xDB2777);
        grad.colors[2] = hexToRgb(0xFF69B4);
        grad.colorCount = 3;
        grad.speed = 6000.0;
        grad.angle = 180.0;
        grad.glossSpeed = 0.6;
        grad.glossIntensity = 0.45;
        foundGradient = true;
    } else if(iColor == ivec3(30,144,255)) {
        grad.colors[0] = hexToRgb(0x1E90FF);
        grad.colors[1] = hexToRgb(0x4169E1);
        grad.colors[2] = hexToRgb(0x00BFFF);
        grad.colorCount = 3;
        grad.speed = 4800.0;
        grad.angle = 22.5;
        grad.glossSpeed = 0.45;
        grad.glossIntensity = 0.35;
        foundGradient = true;
    } else if(iColor == ivec3(255,69,0)) {
        grad.colors[0] = hexToRgb(0xFF4500);
        grad.colors[1] = hexToRgb(0xFF8C00);
        grad.colors[2] = hexToRgb(0xFF6347);
        grad.colorCount = 3;
        grad.speed = 5200.0;
        grad.angle = 67.5;
        grad.glossSpeed = 0.0;
        grad.glossIntensity = 0.0;
        foundGradient = true;
    } else if(iColor == ivec3(138,43,226)) {
        grad.colors[0] = hexToRgb(0x8A2BE2);
        grad.colors[1] = hexToRgb(0x4B0082);
        grad.colors[2] = hexToRgb(0xBA55D3);
        grad.colorCount = 3;
        grad.speed = 5800.0;
        grad.angle = 112.5;
        grad.glossSpeed = 0.55;
        grad.glossIntensity = 0.4;
        foundGradient = true;
    } else if(iColor == ivec3(0,206,209)) {
        grad.colors[0] = hexToRgb(0x00CED1);
        grad.colors[1] = hexToRgb(0x40E0D0);
        grad.colors[2] = hexToRgb(0x48D1CC);
        grad.colorCount = 3;
        grad.speed = 3800.0;
        grad.angle = 157.5;
        grad.glossSpeed = 0.0;
        grad.glossIntensity = 0.0;
        foundGradient = true;
    } else if(iColor == ivec3(220,20,60)) {
        grad.colors[0] = hexToRgb(0xDC143C);
        grad.colors[1] = hexToRgb(0xB22222);
        grad.colors[2] = hexToRgb(0xFF0000);
        grad.colorCount = 3;
        grad.speed = 5300.0;
        grad.angle = 30.0;
        grad.glossSpeed = 0.5;
        grad.glossIntensity = 0.45;
        foundGradient = true;
    } else if(iColor == ivec3(255,215,0)) {
        grad.colors[0] = hexToRgb(0xFFFF00);
        grad.colors[1] = hexToRgb(0xFFD700);
        grad.colors[2] = hexToRgb(0xDAA520);
        grad.colorCount = 3;
        grad.speed = 4200.0;
        grad.angle = 60.0;
        grad.glossSpeed = 0.65;
        grad.glossIntensity = 0.5;
        foundGradient = true;
    } else if(iColor == ivec3(50,205,50)) {
        grad.colors[0] = hexToRgb(0x32CD32);
        grad.colors[1] = hexToRgb(0x228B22);
        grad.colors[2] = hexToRgb(0x00FF00);
        grad.colorCount = 3;
        grad.speed = 3600.0;
        grad.angle = 75.0;
        grad.glossSpeed = 0.0;
        grad.glossIntensity = 0.0;
        foundGradient = true;
    } else if(iColor == ivec3(255,105,180)) {
        grad.colors[0] = hexToRgb(0xFF69B4);
        grad.colors[1] = hexToRgb(0xFF1493);
        grad.colors[2] = hexToRgb(0xDB7070);
        grad.colorCount = 3;
        grad.speed = 6200.0;
        grad.angle = 105.0;
        grad.glossSpeed = 0.7;
        grad.glossIntensity = 0.5;
        foundGradient = true;
    } else if(iColor == ivec3(64,224,208)) {
        grad.colors[0] = hexToRgb(0x40E0D0);
        grad.colors[1] = hexToRgb(0x00CED1);
        grad.colors[2] = hexToRgb(0x48D1CC);
        grad.colorCount = 3;
        grad.speed = 4100.0;
        grad.angle = 120.0;
        grad.glossSpeed = 0.0;
        grad.glossIntensity = 0.0;
        foundGradient = true;
    } else if(iColor == ivec3(255,127,80)) {
        grad.colors[0] = hexToRgb(0xFF7F50);
        grad.colors[1] = hexToRgb(0xFF6347);
        grad.colors[2] = hexToRgb(0xFFA07A);
        grad.colorCount = 3;
        grad.speed = 5100.0;
        grad.angle = 15.0;
        grad.glossSpeed = 0.55;
        grad.glossIntensity = 0.4;
        foundGradient = true;
    } else if(iColor == ivec3(147,112,219)) {
        grad.colors[0] = hexToRgb(0x9370DB);
        grad.colors[1] = hexToRgb(0x8A2BE2);
        grad.colors[2] = hexToRgb(0xBA55D3);
        grad.colorCount = 3;
        grad.speed = 5600.0;
        grad.angle = 150.0;
        grad.glossSpeed = 0.5;
        grad.glossIntensity = 0.35;
        foundGradient = true;
    } else if(iColor == ivec3(0,255,255)) {
        grad.colors[0] = hexToRgb(0x00FFFF);
        grad.colors[1] = hexToRgb(0x00CED1);
        grad.colors[2] = hexToRgb(0x40E0D0);
        grad.colorCount = 3;
        grad.speed = 3900.0;
        grad.angle = 165.0;
        grad.glossSpeed = 0.0;
        grad.glossIntensity = 0.0;
        foundGradient = true;
    } else if(iColor == ivec3(255,0,127)) {
        grad.colors[0] = hexToRgb(0xFF007F);
        grad.colors[1] = hexToRgb(0xFF1493);
        grad.colors[2] = hexToRgb(0xDB2777);
        grad.colorCount = 3;
        grad.speed = 6100.0;
        grad.angle = 52.5;
        grad.glossSpeed = 0.6;
        grad.glossIntensity = 0.45;
        foundGradient = true;
    } else if(iColor == ivec3(100,149,237)) {
        grad.colors[0] = hexToRgb(0x6495ED);
        grad.colors[1] = hexToRgb(0x4169E1);
        grad.colors[2] = hexToRgb(0x1E90FF);
        grad.colorCount = 3;
        grad.speed = 4700.0;
        grad.angle = 37.5;
        grad.glossSpeed = 0.45;
        grad.glossIntensity = 0.35;
        foundGradient = true;
    } else if(iColor == ivec3(27,61,33)) {
        grad.colors[0] = hexToRgb(0x0DF211);
        grad.colors[1] = hexToRgb(0x9BFF05);
        grad.colors[2] = hexToRgb(0x00FF2A);
        grad.colorCount = 3;
        grad.speed = 5000.0;
        grad.angle = 45.0;
        foundGradient = true;
    }

    if(foundGradient) {
        float angleFactor = getAngleFactor(gl_FragCoord.xy * 0.01, grad.angle);
        vec4 gradColor = getGradientColor(grad, angleFactor);
        gradColor = applyGlossToGradient(grad, gradColor);
        color = texture(Sampler0, texCoord0) * gradColor * ColorModulator;
    }

    if (vertexColor.rgb == vec3(1.0, 1.0, 1.0)) {
        fragColor = color;
    } else {
        fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
    }
}