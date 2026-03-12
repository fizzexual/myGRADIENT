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

void main() {
    if(applySpheyaPacks()) return;

    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;

    if (color.a < 0.1) {
        discard;
    }

    ivec3 iColor = ivec3(baseColor.xyz*255.0+vec3(0.5));
    
    Gradient grad;
    bool foundGradient = false;
    
    if(iColor == ivec3(230,255,254)) {
        grad.trigger = ivec3(230,255,254);
        grad.colorCount = 2;
        grad.speed = 1000.0;
        grad.angle = 0.0;
        foundGradient = true;
    } else if(iColor == ivec3(224,48,9)) {
        grad.trigger = ivec3(224,48,9);
        grad.colors[0] = hexToRgb(0x920000);
        grad.colors[1] = hexToRgb(0xFF0000);
        grad.colors[2] = hexToRgb(0xF37B0A);
        grad.colorCount = 3;
        grad.speed = 5000.0;
        grad.angle = 45.0;
        foundGradient = true;
    } else if(iColor == ivec3(31,122,254)) {
        grad.colors[0] = hexToRgb(0x002EFD);
        grad.colors[1] = hexToRgb(0x5644FC);
        grad.colors[2] = hexToRgb(0x0AB1FF);
        grad.colorCount = 3;
        grad.speed = 5000.0;
        grad.angle = 45.0;
        foundGradient = true;
    } else if(iColor == ivec3(190,26,245)) {
        grad.colors[0] = hexToRgb(0x6600A1);
        grad.colors[1] = hexToRgb(0x9C23FF);
        grad.colors[2] = hexToRgb(0xE00AF3);
        grad.colorCount = 3;
        grad.speed = 5000.0;
        grad.angle = 45.0;
        foundGradient = true;
    } else if(iColor == ivec3(190,26,249)) {
        grad.colors[0] = hexToRgb(0x6600A1);
        grad.colors[1] = hexToRgb(0x9C23FF);
        grad.colors[2] = hexToRgb(0xE00AF3);
        grad.colorCount = 3;
        grad.speed = 5000.0;
        grad.angle = 45.0;
        foundGradient = true;
    } else if(iColor == ivec3(191,33,34)) {
        grad.colors[0] = hexToRgb(0xFF3232);
        grad.colors[1] = hexToRgb(0x7BFF77);
        grad.colors[2] = hexToRgb(0xFF3232);
        grad.colors[3] = hexToRgb(0x7BFF77);
        grad.colorCount = 4;
        grad.speed = 0.6;
        grad.angle = 45.0;
        foundGradient = true;
    } else if(iColor == ivec3(191,33,39)) {
        grad.colors[0] = hexToRgb(0xFF3232);
        grad.colors[1] = hexToRgb(0x7BFF77);
        grad.colors[2] = hexToRgb(0xFF3232);
        grad.colors[3] = hexToRgb(0x7BFF77);
        grad.colorCount = 4;
        grad.speed = 0.6;
        grad.angle = 45.0;
        foundGradient = true;
    } else if(iColor == ivec3(123,50,168)) {
        grad.colors[0] = hexToRgb(0x70D352);
        grad.colors[1] = hexToRgb(0xDFF3E0);
        grad.colors[2] = hexToRgb(0x38A5E8);
        grad.colorCount = 3;
        grad.speed = 1000.0;
        grad.angle = 45.0;
        foundGradient = true;
    } else if(iColor == ivec3(134,194,34)) {
            grad.colors[0] = hexToRgb(0x2D3640);
            grad.colors[1] = hexToRgb(0x1A9BFA);
            grad.colors[2] = hexToRgb(0x01CF38);
            grad.colorCount = 3;
            grad.speed = 5000.0;
            grad.angle = 90.0;
            foundGradient = true;
    }
    
    if(foundGradient) {
        float angleFactor = getAngleFactor(gl_FragCoord.xy * 0.01, grad.angle);
        vec4 gradColor = getGradientColor(grad, angleFactor);
        color = texture(Sampler0, texCoord0) * gradColor * ColorModulator;
    }

    if (vertexColor.rgb == vec3(1.0, 1.0, 1.0)) {
        fragColor = color;
    } else {
        fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
    }
}