#define TEXT_EFFECT(r, g, b) return true; case ((uint(r/4) << 16) | (uint(g/4) << 8) | (uint(b/4))):


TEXT_EFFECT(224, 48, 9) { // Red/Orange (#E03009)
    apply_gradient_3(rgb(201, 2, 56), rgb(96, 0, 38), rgb(224, 48, 9), 1.0);
    textData.shouldScale = true;
}

TEXT_EFFECT(190, 26, 245) { // Purple/Pink (#BE1AF5)
    apply_gradient_3(rgb(102, 0, 161), rgb(156, 35, 255), rgb(224, 10, 243), 1.0);
    textData.shouldScale = true;
    apply_gloss_basic(0.55, 0.45);
}

TEXT_EFFECT(31, 122, 254) { // Blue (#1F7AFE)
    apply_gradient_3(rgb(0, 46, 253), rgb(86, 68, 252), rgb(10, 177, 255), 1.0);
    textData.shouldScale = true;
    apply_gloss(0.45, 0.35);
}

TEXT_EFFECT(27, 61, 33) { // #1B3D21
    apply_gradient_3(rgb(13, 242, 17), rgb(155, 255, 5), rgb(0, 255, 42), 1.0);
    textData.shouldScale = true;
}