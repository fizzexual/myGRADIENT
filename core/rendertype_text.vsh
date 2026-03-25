#version 150
#define VSH
#define RENDERTYPE_TEXT

#moj_import <fog.glsl>

#define hue(v) ((.6+.6*cos(6.*(v)+vec4(0,23,21,1)))+vec4(0.,0.,0.,1.))

struct Gradient {
    ivec3 trigger;
    vec3 colors[4];
    int colorCount;
    float speed;
    float angle;
};

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;
uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform float GameTime;
uniform vec2 ScreenSize;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec4 baseColor;
out vec4 lightColor;

#moj_import <spheya_packs_impl.glsl>

vec3 hexToRgb(int hex) {
    return vec3(
        float((hex >> 16) & 0xFF)/255.0,
        float((hex >> 8) & 0xFF)/255.0,
        float(hex & 0xFF)/255.0
    );
}

Gradient gradients[10];
int gradientCount = 0;

void registerGradient(int triggerHex, int color1Hex, int color2Hex, float speed, float angle) {
    if(gradientCount < 10) {
        gradients[gradientCount].trigger = ivec3(
            (triggerHex >> 16) & 0xFF,
            (triggerHex >> 8) & 0xFF,
            triggerHex & 0xFF
        );
        gradients[gradientCount].colors[0] = hexToRgb(color1Hex);
        gradients[gradientCount].colors[1] = hexToRgb(color2Hex);
        gradients[gradientCount].colorCount = 2;
        gradients[gradientCount].speed = speed;
        gradients[gradientCount].angle = angle;
        gradientCount++;
    }
}

void registerGradient(int triggerHex, int color1Hex, int color2Hex, int color3Hex, float speed, float angle) {
    if(gradientCount < 10) {
        gradients[gradientCount].trigger = ivec3(
            (triggerHex >> 16) & 0xFF,
            (triggerHex >> 8) & 0xFF,
            triggerHex & 0xFF
        );
        gradients[gradientCount].colors[0] = hexToRgb(color1Hex);
        gradients[gradientCount].colors[1] = hexToRgb(color2Hex);
        gradients[gradientCount].colors[2] = hexToRgb(color3Hex);
        gradients[gradientCount].colorCount = 3;
        gradients[gradientCount].speed = speed;
        gradients[gradientCount].angle = angle;
        gradientCount++;
    }
}

void registerGradient(int triggerHex, int color1Hex, int color2Hex, int color3Hex, int color4Hex, float speed, float angle) {
    if(gradientCount < 10) {
        gradients[gradientCount].trigger = ivec3(
            (triggerHex >> 16) & 0xFF,
            (triggerHex >> 8) & 0xFF,
            triggerHex & 0xFF
        );
        gradients[gradientCount].colors[0] = hexToRgb(color1Hex);
        gradients[gradientCount].colors[1] = hexToRgb(color2Hex);
        gradients[gradientCount].colors[2] = hexToRgb(color3Hex);
        gradients[gradientCount].colors[3] = hexToRgb(color4Hex);
        gradients[gradientCount].colorCount = 4;
        gradients[gradientCount].speed = speed;
        gradients[gradientCount].angle = angle;
        gradientCount++;
    }
}

vec4 getGradientColor(Gradient grad, float t) {
    float mixVal = 0.5+0.5*sin(GameTime*grad.speed*0.001+t*5.0);
    
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

float getAngleFactor(vec3 pos, float angle) {
    float rad = radians(angle);
    return pos.x * cos(rad) + pos.y * sin(rad);
}

void initGradients() {
    registerGradient(0xE03009,0xC90238,0x600026,1000.0,45.0); // Red/Orange
    registerGradient(0xBE1AF5,0x6600A1,0x9C23FF,1000.0,45.0); // Purple/Pink
    registerGradient(0x1F7AFE,0x002EFD,0x5644FC,1000.0,45.0); // Blue}
    registerGradient(0X1B3D21,0x0DF211,0x9BFF05,0x00FF2A,1000.0,45.0);
}

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    baseColor = Color;
    lightColor = texelFetch(Sampler2, UV2 / 16, 0);

    initGradients();
    
    vertexColor = baseColor * lightColor;

    vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
    texCoord0 = UV0;

    if(applySpheyaPacks()) return;
}