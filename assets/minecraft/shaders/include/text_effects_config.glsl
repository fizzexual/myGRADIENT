#define TEXT_EFFECT(r, g, b) return true; case ((uint(r/4) << 16) | (uint(g/4) << 8) | (uint(b/4))):


TEXT_EFFECT(224, 48, 9) { // Red/Orange (#E03009)
    apply_gradient_3(rgb(201, 2, 56), rgb(96, 0, 38), rgb(224, 48, 9), 1.0);
    textData.shouldScale = true;
}

TEXT_EFFECT(190, 26, 245) { // Purple/Pink (#BE1AF5)
    apply_gradient_3(rgb(102, 0, 161), rgb(156, 35, 255), rgb(224, 10, 243), 1.0);
    textData.shouldScale = true;
    apply_gloss(0.45, 0.35);
}

TEXT_EFFECT(31, 122, 254) { // Blue (#1F7AFE)
    apply_gradient_3(rgb(0, 46, 253), rgb(86, 68, 252), rgb(10, 177, 255), 1.0);
    textData.shouldScale = true;
    apply_gloss(0.45, 0.35);
}

TEXT_EFFECT(255, 165, 0) { // Gold/Yellow (#FFA500)
    apply_gradient_3(rgb(255, 215, 0), rgb(255, 140, 0), rgb(218, 165, 32), 1.0);
    textData.shouldScale = true;
    apply_gloss_basic(0.5, 0.4);
}

TEXT_EFFECT(0, 255, 127) { // Spring Green (#00FF7F)
    apply_gradient_3(rgb(0, 255, 127), rgb(34, 139, 34), rgb(50, 205, 50), 1.0);
    textData.shouldScale = true;
}

TEXT_EFFECT(255, 20, 147) { // Deep Pink (#FF1493)
    apply_gradient_3(rgb(255, 20, 147), rgb(219, 39, 119), rgb(255, 105, 180), 1.0);
    textData.shouldScale = true;
    apply_gloss_basic(0.6, 0.45);
}

TEXT_EFFECT(30, 144, 255) { // Dodger Blue (#1E90FF)
    apply_gradient_3(rgb(30, 144, 255), rgb(65, 105, 225), rgb(0, 191, 255), 1.0);
    textData.shouldScale = true;
    apply_gloss(0.45, 0.35);
}

TEXT_EFFECT(255, 69, 0) { // Red-Orange (#FF4500)
    apply_gradient_3(rgb(255, 69, 0), rgb(255, 140, 0), rgb(255, 99, 71), 1.0);
    textData.shouldScale = true;
}

TEXT_EFFECT(138, 43, 226) { // Blue Violet (#8A2BE2)
    apply_gradient_3(rgb(138, 43, 226), rgb(75, 0, 130), rgb(186, 85, 211), 1.0);
    textData.shouldScale = true;
    apply_gloss_basic(0.55, 0.4);
}

TEXT_EFFECT(0, 206, 209) { // Dark Turquoise (#00CED1)
    apply_gradient_3(rgb(0, 206, 209), rgb(64, 224, 208), rgb(72, 209, 204), 1.0);
    textData.shouldScale = true;
}

TEXT_EFFECT(220, 20, 60) { // Crimson (#DC143C)
    apply_gradient_3(rgb(220, 20, 60), rgb(178, 34, 34), rgb(255, 0, 0), 1.0);
    textData.shouldScale = true;
    apply_gloss_basic(0.5, 0.45);
}

TEXT_EFFECT(255, 215, 0) { // Gold (#FFD700)
    apply_gradient_3(rgb(255, 255, 0), rgb(255, 215, 0), rgb(218, 165, 32), 1.0);
    textData.shouldScale = true;
    apply_gloss_basic(0.65, 0.5);
}

TEXT_EFFECT(50, 205, 50) { // Lime Green (#32CD32)
    apply_gradient_3(rgb(50, 205, 50), rgb(34, 139, 34), rgb(0, 255, 0), 1.0);
    textData.shouldScale = true;
}

TEXT_EFFECT(255, 105, 180) { // Hot Pink (#FF69B4)
    apply_gradient_3(rgb(255, 105, 180), rgb(255, 20, 147), rgb(219, 112, 147), 1.0);
    textData.shouldScale = true;
    apply_gloss_basic(0.7, 0.5);
}

TEXT_EFFECT(64, 224, 208) { // Turquoise (#40E0D0)
    apply_gradient_3(rgb(64, 224, 208), rgb(0, 206, 209), rgb(72, 209, 204), 1.0);
    textData.shouldScale = true;
}

TEXT_EFFECT(255, 127, 80) { // Coral (#FF7F50)
    apply_gradient_3(rgb(255, 127, 80), rgb(255, 99, 71), rgb(255, 160, 122), 1.0);
    textData.shouldScale = true;
    apply_gloss_basic(0.55, 0.4);
}

TEXT_EFFECT(147, 112, 219) { // Medium Purple (#9370DB)
    apply_gradient_3(rgb(147, 112, 219), rgb(138, 43, 226), rgb(186, 85, 211), 1.0);
    textData.shouldScale = true;
    apply_gloss(0.5, 0.35);
}

TEXT_EFFECT(0, 255, 255) { // Cyan (#00FFFF)
    apply_gradient_3(rgb(0, 255, 255), rgb(0, 206, 209), rgb(64, 224, 208), 1.0);
    textData.shouldScale = true;
}

TEXT_EFFECT(255, 0, 127) { // Rose (#FF007F)
    apply_gradient_3(rgb(255, 0, 127), rgb(255, 20, 147), rgb(219, 39, 119), 1.0);
    textData.shouldScale = true;
    apply_gloss_basic(0.6, 0.45);
}

TEXT_EFFECT(100, 149, 237) { // Cornflower Blue (#6495ED)
    apply_gradient_3(rgb(100, 149, 237), rgb(65, 105, 225), rgb(30, 144, 255), 1.0);
    textData.shouldScale = true;
    apply_gloss(0.45, 0.35);
}
