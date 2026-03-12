#version 150
#if defined(RENDERTYPE_TEXT) || defined(RENDERTYPE_TEXT_INTENSITY)

struct TextData {
    vec4 color;
    vec4 topColor;
    vec4 backColor;
    vec2 position;
    vec2 characterPosition;
    vec2 localPosition;
    vec2 uv;
    vec2 uvMin;
    vec2 uvMax;
    vec2 uvCenter;
    bool isShadow;
    bool doTextureLookup;
    bool shouldScale;
};

TextData textData;

// Pre-calculated time values (calculate once per frame, not per pixel)
float fastTime;
float medTime;
float slowTime;

void initTimeValues() {
    fastTime = GameTime * 500.0;
    medTime = GameTime * 1200.0;
    slowTime = GameTime * 300.0;
}

bool uvBoundsCheck(vec2 uv, vec2 uvMin, vec2 uvMax) {
    if(isnan(uv.x) || isnan(uv.y)) return true;
    const float error = 0.0001;
    return uv.x < textData.uvMin.x + error || uv.y < textData.uvMin.y + error || uv.x > textData.uvMax.x - error || uv.y > textData.uvMax.y - error;
}

// OPTIMIZED: 4-sample cross pattern instead of 9-sample grid
vec3 textSdf() {
    vec3 value = vec3(0.0, 0.0, 1.0);
    vec2 texelSize = 1.0 / vec2(256.0);
    
    // Check 4 cardinal directions + center
    vec2 offsets[5] = vec2[](
        vec2(0.0, 0.0),
        vec2(texelSize.x, 0.0),
        vec2(-texelSize.x, 0.0),
        vec2(0.0, texelSize.y),
        vec2(0.0, -texelSize.y)
    );
    
    for(int i = 0; i < 5; i++) {
        vec2 uv = textData.uv + offsets[i];
        if(uvBoundsCheck(uv, textData.uvMin, textData.uvMax)) continue;

        vec4 s = texture(Sampler0, uv);
        if(s.a >= 0.1) {
            vec3 v = vec3(fract(uv * 256.0), 0.0);
            
            if(offsets[i].x == 0.0) v.x = 0.0;
            if(offsets[i].y == 0.0) v.y = 0.0;
            if(offsets[i].x > 0.0) v.x = 1.0 - v.x;
            if(offsets[i].y > 0.0) v.y = 1.0 - v.y;
            
            v.z = length(v.xy);
            if(v.z < value.z) value = v;
        }
    }
    return value;
}

void apply_gloss(float speed, float intensity) {
    if(textData.isShadow) return;
    #ifdef FSH
        vec2 pos = gl_FragCoord.xy / 100.0;
        float f = pos.x + pos.y - GameTime * 6400.0 * speed;

        if(mod(f, 5.0) < 0.5) textData.topColor = vec4(1.0, 1.0, 1.0, intensity);
        textData.shouldScale = true;
    #endif
}

void apply_gloss_basic(float speed, float intensity) {
    if(textData.isShadow) return;
    float f = textData.localPosition.x + textData.localPosition.y - GameTime * 6400.0 * speed;

    if(mod(f, 5) < 0.75) textData.topColor = vec4(1.0, 1.0, 1.0, intensity);
    textData.shouldScale = true;
}

void apply_rainbow() {
    textData.color.rgb = hsvToRgb(vec3(0.005 * (textData.position.x + textData.position.y) - slowTime, 0.7, 1.0));
    if(textData.isShadow) textData.color.rgb *= 0.25;
    textData.shouldScale = true;
}

void apply_pastel() {
    vec3 hsvColor = vec3(0.005 * (textData.position.x + textData.position.y) - slowTime, 0.43, 0.94);
    textData.color.rgb = hsvToRgb(hsvColor);
    if(textData.isShadow) textData.color.rgb *= 0.25;
}

float fast_hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float fast_noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f); // Smoothstep
    
    float a = fast_hash(i);
    float b = fast_hash(i + vec2(1.0, 0.0));
    float c = fast_hash(i + vec2(0.0, 1.0));
    float d = fast_hash(i + vec2(1.0, 1.0));
    
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float fast_fbm(vec2 p) {
    float value = 0.0;
    value += 0.5 * fast_noise(p);
    value += 0.25 * fast_noise(p * 2.0);
    return value;
}

void apply_fractal(vec3 color1, vec3 color2, vec3 color3, vec3 color4, vec3 color5, vec3 color6, vec3 color7, float speed) {
    #ifdef FSH
        vec2 uv = floor(vec2(gl_FragCoord.xy) / 2.0) * 2.0 / 100.0;
        float fractalShade = fast_fbm(uv + medTime * speed);
        
        float baseHue = 0.005 * (textData.position.x + textData.position.y) - slowTime * speed;
        float hue = mod(baseHue + fractalShade * 3.0, 1.0);
        
        float colorIndex = hue * 7.0;
        int index1 = int(floor(colorIndex));
        int index2 = (index1 + 1) % 7;
        float t = fract(colorIndex);
        
        vec3 fractalColors[7];
        fractalColors[0] = color1;
        fractalColors[1] = color2;
        fractalColors[2] = color3;
        fractalColors[3] = color4;
        fractalColors[4] = color5;
        fractalColors[5] = color6;
        fractalColors[6] = color7;
        
        textData.color.rgb = mix(fractalColors[index1 % 7], fractalColors[index2 % 7], t);
        
        if (textData.isShadow) {
            textData.color.rgb *= 0.25;
        }
    #endif
}

void apply_cloud(vec3 color1, vec3 color2, vec3 color3, vec3 color4, float speed) {
    #ifdef FSH
        float t = medTime * speed;
        vec2 p = floor(vec2(gl_FragCoord.xy) / 2.0) * 2.0 / 100.0;
        vec2 q = p * 5.0;
        
        q.x += sin(q.y * 2.0 + t) * 0.2;
        q.y += cos(q.x * 2.0 + t) * 0.2;
        
        float n1 = fast_fbm(q + t);
        float n2 = fast_fbm(q * 1.5 - t * 0.5);
        
        vec3 col = n1 * color1 + n2 * color2;
        col += fast_noise(q * 3.0 + t * 0.25) * color3 * 0.5;
        col += fast_noise(q * 3.0 - t * 0.25) * color4 * 0.5;
        col = pow(col, vec3(1.3));
        
        float star = fract(sin(dot(p * 20.0, vec2(12.9898, 78.233))) * 43758.5453);
        star = smoothstep(2.95, 5.0, star) * 0.2;
        textData.color.rgb = col + vec3(star);

        if (textData.isShadow) {
            textData.color.rgb *= 0.25;
        }
    #endif
}

void apply_gradient_3(vec3 color1, vec3 color2, vec3 color3, float speed) {
    float t = 0.05 * (textData.position.x + textData.position.y) - fastTime * 10.0 * speed;
    float smoothT = fract(t / (2.0 * 3.14159)) * 3.0;
    vec3 resultColor;
    if (smoothT < 1.0) {
        resultColor = mix(color1, color2, smoothT);
    } else if (smoothT < 2.0) {
        resultColor = mix(color2, color3, smoothT - 1.0);
    } else {
        resultColor = mix(color3, color1, smoothT - 2.0);
    }
    textData.color.rgb = resultColor;
    if(textData.isShadow) textData.color.rgb *= 0.25;
    textData.shouldScale = true;
}

void apply_gradient_4(vec3 color1, vec3 color2, vec3 color3, vec3 color4, float speed) {
    float t = 0.05 * (textData.position.x + textData.position.y) - fastTime * 10.0 * speed;
    float smoothT = fract(t / (2.0 * 3.14159)) * 4.0;
    vec3 resultColor;
    if (smoothT < 1.0) {
        resultColor = mix(color1, color2, smoothT);
    } else if (smoothT < 2.0) {
        resultColor = mix(color2, color3, smoothT - 1.0);
    } else if (smoothT < 3.0) {
        resultColor = mix(color3, color4, smoothT - 2.0);
    } else {
        resultColor = mix(color4, color1, smoothT - 3.0);
    }
    textData.color.rgb = resultColor;
    if(textData.isShadow) textData.color.rgb *= 0.25;
    textData.shouldScale = true;
}

void apply_gradient_7(vec3 color1, vec3 color2, vec3 color3, vec3 color4, vec3 color5, vec3 color6, vec3 color7) {
    float t = 0.01 * (textData.position.x + textData.position.y) - fastTime;
    float smoothT = fract(t) * 12.0;

    vec3 resultColor;
    if (smoothT < 1.0) {
        resultColor = mix(color1, color2, smoothT);
    } else if (smoothT < 2.0) {
        resultColor = mix(color2, color3, smoothT - 1.0);
    } else if (smoothT < 3.0) {
        resultColor = mix(color3, color4, smoothT - 2.0);
    } else if (smoothT < 4.0) {
        resultColor = mix(color4, color5, smoothT - 3.0);
    } else if (smoothT < 5.0) {
        resultColor = mix(color5, color6, smoothT - 4.0);
    } else if (smoothT < 6.0) {
        resultColor = mix(color6, color7, smoothT - 5.0);
    } else if (smoothT < 7.0) {
        resultColor = mix(color7, color6, smoothT - 6.0);
    } else if (smoothT < 8.0) {
        resultColor = mix(color6, color5, smoothT - 7.0);
    } else if (smoothT < 9.0) {
        resultColor = mix(color5, color4, smoothT - 8.0);
    } else if (smoothT < 10.0) {
        resultColor = mix(color4, color3, smoothT - 9.0);
    } else if (smoothT < 11.0) {
        resultColor = mix(color3, color2, smoothT - 10.0);
    } else {
        resultColor = mix(color2, color1, smoothT - 11.0);
    }

    float wave = sin(10.0 * t + textData.position.x * 0.2) * 0.5 + 0.5;
    resultColor = mix(resultColor, vec3(1.0), wave * 0.15);

    textData.color.rgb = resultColor;
    if(textData.isShadow) textData.color.rgb *= 0.25;
}

void apply_animated_gradient_7_smoother(vec3 color1, vec3 color2, vec3 color3, vec3 color4, vec3 color5, vec3 color6, vec3 color7) {
    float t = 0.01 * (textData.position.x + textData.position.y) - fastTime;
    float smoothT = fract(t) * 12.0;
    float idx = floor(smoothT);
    float blend = fract(smoothT);

    vec3 resultColor = vec3(0.0);

    resultColor += mix(color1, color2, blend) * (1.0 - step(1.0, idx)) * step(0.0, idx);
    resultColor += mix(color2, color3, blend) * step(1.0, idx) * (1.0 - step(2.0, idx));
    resultColor += mix(color3, color4, blend) * step(2.0, idx) * (1.0 - step(3.0, idx));
    resultColor += mix(color4, color5, blend) * step(3.0, idx) * (1.0 - step(4.0, idx));
    resultColor += mix(color5, color6, blend) * step(4.0, idx) * (1.0 - step(5.0, idx));
    resultColor += mix(color6, color7, blend) * step(5.0, idx) * (1.0 - step(6.0, idx));

    resultColor += mix(color7, color6, blend) * step(6.0, idx) * (1.0 - step(7.0, idx));
    resultColor += mix(color6, color5, blend) * step(7.0, idx) * (1.0 - step(8.0, idx));
    resultColor += mix(color5, color4, blend) * step(8.0, idx) * (1.0 - step(9.0, idx));
    resultColor += mix(color4, color3, blend) * step(9.0, idx) * (1.0 - step(10.0, idx));
    resultColor += mix(color3, color2, blend) * step(10.0, idx) * (1.0 - step(11.0, idx));
    resultColor += mix(color2, color1, blend) * step(11.0, idx);
    
    float wave = sin(10.0 * t + textData.position.x * 0.2) * 0.5 + 0.5;
    resultColor = mix(resultColor, vec3(1.0), wave * 0.15);
    textData.color.rgb = resultColor * mix(1.0, 0.25, float(textData.isShadow));
}

void apply_cycle_2(vec3 startRGB, vec3 endRGB, float speed, float frequency) {
    float timeOffset = fastTime * speed;
    float positionOffset = textData.characterPosition.x * frequency;
    float wave = sin(positionOffset - timeOffset) * 0.5 + 0.5;

    textData.color.rgb = mix(startRGB, endRGB, wave);

    if (textData.isShadow) {
        textData.color.rgb *= 0.25;
    }
    textData.shouldScale = true;
}

#define TEXT_EFFECT(r, g, b) return true; case ((uint(r/4) << 16) | (uint(g/4) << 8) | (uint(b/4))):

bool applyTextEffects() {
    uint vertexColorId = colorId(floor(round(textData.color.rgb * 255.0) / 4.0) / 255.0);
    if(textData.isShadow) { vertexColorId = colorId(textData.color.rgb);}
    switch(vertexColorId >> 8) {
        case 0xFFFFFFFFu:

    #moj_import<text_effects_config.glsl>

        return true;
    }
    return false;
}

#define SPHEYA_PACK_9

#ifdef FSH
in vec4 vctfx_screenPos;
flat in float vctfx_applyTextEffect;
flat in float vctfx_isShadow;
flat in float vctfx_changedScale;

in vec3 vctfx_ipos1;
in vec3 vctfx_ipos2;
in vec3 vctfx_ipos3;
in vec3 vctfx_ipos4;

in vec3 vctfx_uvpos1;
in vec3 vctfx_uvpos2;
in vec3 vctfx_uvpos3;
in vec3 vctfx_uvpos4;

bool applySpheyaPack9() {
    if(vctfx_applyTextEffect < 0.5) return false;

    // OPTIMIZATION: Initialize time values once
    initTimeValues();

    textData.isShadow = vctfx_isShadow > 0.5;
    textData.backColor = vec4(0.0);
    textData.topColor = vec4(0.0);
    textData.doTextureLookup = true;
    textData.color = baseColor;

    vec2 ip1 = vctfx_ipos1.xy / vctfx_ipos1.z;
    vec2 ip2 = vctfx_ipos2.xy / vctfx_ipos2.z;
    vec2 ip3 = vctfx_ipos3.xy / vctfx_ipos3.z;
    vec2 ip4 = vctfx_ipos4.xy / vctfx_ipos4.z;
    vec2 innerMin = min(ip1.xy,min(ip2.xy,min(ip3.xy,ip4.xy)));
    vec2 innerMax = max(ip1.xy,max(ip2.xy,max(ip3.xy,ip4.xy)));
    vec2 innerSize = innerMax - innerMin;

    vec2 uvp1 = vctfx_uvpos1.xy / vctfx_uvpos1.z;
    vec2 uvp2 = vctfx_uvpos2.xy / vctfx_uvpos2.z;
    vec2 uvp3 = vctfx_uvpos3.xy / vctfx_uvpos3.z;
    vec2 uvp4 = vctfx_uvpos4.xy / vctfx_uvpos4.z;
    vec2 uvMin = min(uvp1.xy,min(uvp2.xy,min(uvp3.xy, uvp4.xy)));
    vec2 uvMax = max(uvp1.xy,max(uvp2.xy,max(uvp3.xy, uvp4.xy)));
    vec2 uvSize = uvMax - uvMin;
    textData.uvMin = uvMin;
    textData.uvMax = uvMax;
    textData.uvCenter = uvMin + 0.25 * uvSize;
    textData.localPosition = ((vctfx_screenPos.xy - innerMin) / innerSize);
    textData.localPosition.y = 1.0 - textData.localPosition.y;
    textData.uv = textData.localPosition * uvSize + uvMin;
    if(vctfx_changedScale < 0.5) {
        textData.uv = texCoord0;
    }
    textData.position = vctfx_screenPos.xy * uvSize * 256.0 / innerSize;
    textData.characterPosition = 0.5 * (innerMin + innerMax) * uvSize * 256.0 / innerSize;
    if(textData.isShadow) {
        textData.characterPosition += vec2(-1.0, 1.0);
        textData.position += vec2(-1.0, 1.0);
    }
    applyTextEffects();
    if(uvBoundsCheck(textData.uv, uvMin, uvMax)) textData.doTextureLookup = false;

    vec4 textureSample = texture(Sampler0, textData.uv);

#ifdef RENDERTYPE_TEXT_INTENSITY
    textureSample = textureSample.rrrr;
    textureSample = vec4(0.0);
#endif

    if(!textData.doTextureLookup) textureSample = vec4(0.0);
    textData.topColor.a *= textureSample.a;

    fragColor = mix(vec4(textData.backColor.rgb, textData.backColor.a * textData.color.a), textureSample * textData.color, textureSample.a);
    fragColor.rgb = mix(fragColor.rgb, textData.topColor.rgb, textData.topColor.a);
    fragColor *= lightColor * ColorModulator;

    if (fragColor.a < 0.1) {
        discard;
    }

#ifdef IS_1_21_6
    fragColor = apply_fog(
        fragColor,
        sphericalVertexDistance,
        cylindricalVertexDistance,
        FogEnvironmentalStart,
        FogEnvironmentalEnd,
        FogRenderDistanceStart,
        FogRenderDistanceEnd,
        FogColor
    );
#else
    fragColor = linear_fog(fragColor, vertexDistance, FogStart, FogEnd, FogColor);
#endif
    return true;
}

#endif

#ifdef VSH
out vec4 vctfx_screenPos;
flat out float vctfx_applyTextEffect;
flat out float vctfx_isShadow;
flat out float vctfx_changedScale;

out vec3 vctfx_ipos1;
out vec3 vctfx_ipos2;
out vec3 vctfx_ipos3;
out vec3 vctfx_ipos4;

out vec3 vctfx_uvpos1;
out vec3 vctfx_uvpos2;
out vec3 vctfx_uvpos3;
out vec3 vctfx_uvpos4;

bool applySpheyaPack9() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vctfx_isShadow = fract(Position.z) < 0.01 ? 1.0 : 0.0;
    vctfx_applyTextEffect = 1.0;
    vctfx_changedScale = 0.0;

    textData.isShadow = vctfx_isShadow > 0.5;
    textData.color = Color;
    textData.shouldScale = false;

    if(!applyTextEffects()) {
        vctfx_isShadow = 0.0;

#ifdef IS_1_21_6
        if (textData.isShadow)
        {
#else
        if(Position.z == 0.0 && textData.isShadow) {
#endif
            textData.isShadow = false;
            if(applyTextEffects()) {
                vctfx_isShadow = 0.0;
            }else {
                vctfx_applyTextEffect = 0.0;
                return false;
            }
        }else{
            vctfx_applyTextEffect = 0.0;
            return false;
        }
    }

    vec2 corner = vec2[](vec2(-1.0, +1.0), vec2(-1.0, -1.0), vec2(+1.0, -1.0), vec2(+1.0, +1.0))[gl_VertexID % 4];
    if(textureSize(Sampler0, 0) != ivec2(256, 256)) {
        vctfx_applyTextEffect = 0.0;
        return false;
    }

    vctfx_uvpos1 = vctfx_uvpos2 = vctfx_uvpos3 = vctfx_uvpos4 = vctfx_ipos1 = vctfx_ipos2 = vctfx_ipos3 = vctfx_ipos4 = vec3(0.0);
    switch (gl_VertexID % 4) {
        case 0: vctfx_ipos1 = vec3(gl_Position.xy, 1.0); vctfx_uvpos1 = vec3(UV0.xy, 1.0); break;
        case 1: vctfx_ipos2 = vec3(gl_Position.xy, 1.0); vctfx_uvpos2 = vec3(UV0.xy, 1.0); break;
        case 2: vctfx_ipos3 = vec3(gl_Position.xy, 1.0); vctfx_uvpos3 = vec3(UV0.xy, 1.0); break;
        case 3: vctfx_ipos4 = vec3(gl_Position.xy, 1.0); vctfx_uvpos4 = vec3(UV0.xy, 1.0); break;
    }

if(textData.shouldScale) {
    gl_Position.xy += corner * 0.03; 
    vctfx_changedScale = 1.0;
}

    vctfx_screenPos = gl_Position;
#ifdef IS_1_21_6
    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
#else
    vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
#endif
    vertexColor = baseColor * lightColor;
    texCoord0 = UV0;
    return true;
}

#endif

#endif
