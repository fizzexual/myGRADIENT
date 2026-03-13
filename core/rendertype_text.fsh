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
        grad.colors[0] = hexToRgb(0x920000);
        grad.colors[1] = hexToRgb(0xFF0000);
        grad.colors[2] = hexToRgb(0xF37B0A);
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
        grad.speed = 5000.0;
        grad.angle = 45.0;
        grad.glossSpeed = 0.45;
        grad.glossIntensity = 0.35;
        foundGradient = true;
    } else if(iColor == ivec3(190,26,245)) {
        grad.colors[0] = hexToRgb(0x6600A1);
        grad.colors[1] = hexToRgb(0x9C23FF);
        grad.colors[2] = hexToRgb(0xE00AF3);
        grad.colorCount = 3;
        grad.speed = 5000.0;
        grad.angle = 45.0;
        grad.glossSpeed = 0.55;
        grad.glossIntensity = 0.45;
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