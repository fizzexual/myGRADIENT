# 🎨 Animated Text Gradients

<div align="center">

![Gradient Animation](https://file.garden/abM-TiHSwTHZbAzx/myGRADIENT-3-13-2026.gif)

![Shader](https://img.shields.io/badge/Shader-GLSL%20150-blue?style=flat-square)
![Minecraft](https://img.shields.io/badge/Minecraft-1.20+-green?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-red?style=flat-square)

**Smooth, animated color gradients for Minecraft text and UI elements**

[Get Started](#-getting-started) • [How It Works](#-how-it-works) • [Create Gradients](#-creating-gradients)

</div>

---

## ✨ What is This?

This shader system adds **smooth, animated color gradients** to your Minecraft text. Instead of static colors, your text smoothly cycles through 3 colors in a beautiful animation.

Perfect for:
- Custom resource packs
- Server branding
- UI customization
- Chat effects

---

## 🚀 Getting Started

### The Easy Way: Use the Gradient Helper

We've built a tool that does all the work for you:

1. Open `gradient_helper.html` in your browser
2. Pick your colors (3 color pickers)
3. Click "Generate"
4. Copy the code to 3 files

That's it! Your gradient is ready.

---

## 🎯 How It Works

The system has **3 parts** that work together:

```
Your Color Code (#7B32A8)
        ↓
    ┌───┴───┐
    ↓       ↓
 Glyphs   Text Messages
(UI)      (Chat/Signs)
```

- **Glyphs** (scoreboards, tabs, etc.) → Handled by shader files
- **Text Messages** (chat, signs) → Handled by config file

All three files must be updated for the gradient to work everywhere.

---

## 📝 Creating Your First Gradient

### Step 1: Generate Code

Open `gradient_helper.html` and:
1. Choose a trigger color (e.g., `#7B32A8`)
2. Pick 3 gradient colors
3. Click "Generate Configs"

You'll get 3 code blocks to copy.

### Step 2: Add to Vertex Shader

**File:** `core/rendertype_text.vsh`

Find the `initGradients()` function and add:

**Template:**
```glsl
registerGradient(0xTRIGGER, 0xCOLOR1, 0xCOLOR2, 0xCOLOR3, 1000.0, 45.0);
```

**✅ Correct Example:**
```glsl
registerGradient(0x7B32A8, 0x70D352, 0xDFF3E0, 1000.0, 45.0);
```

**❌ Wrong Examples:**
```glsl
registerGradient(0x7b32a8, 0x70d352, 0xdff3e0, 1000.0, 45.0);  // Lowercase hex
registerGradient(0x7B32A8, 0x70D352, 0xDFF3E0, 500.0, 90.0);   // Wrong speed/angle
registerGradient(0x7B32A8, 0x70D352, 0xDFF3E0);                // Missing speed/angle
```

---

### Step 3: Add to Text Config

**File:** `include/text_effects_config.glsl`

Find the switch statement and add:

**Template:**
```glsl
TEXT_EFFECT(R, G, B) { // #HEXCOLOR
    apply_gradient_3(rgb(R1, G1, B1), rgb(R2, G2, B2), rgb(R3, G3, B3), 1.0);
    textData.shouldScale = true;
}
```

**✅ Correct Example (Basic):**
```glsl
TEXT_EFFECT(123, 50, 168) { // #7B32A8
    apply_gradient_3(rgb(112, 211, 82), rgb(223, 243, 224), rgb(56, 165, 232), 1.0);
    textData.shouldScale = true;
}
```

**✅ Correct Example (With Gloss):**
```glsl
TEXT_EFFECT(224, 48, 9) { // #E03009
    apply_gradient_3(rgb(201, 2, 56), rgb(96, 0, 38), rgb(255, 0, 0), 1.0);
    apply_gloss_basic(0.55, 0.45);
    textData.shouldScale = true;
}
```

**✅ Correct Example (With Advanced Gloss):**
```glsl
TEXT_EFFECT(31, 122, 254) { // #1F7AFE
    apply_gradient_3(rgb(0, 46, 253), rgb(86, 68, 252), rgb(10, 177, 255), 1.0);
    apply_gloss(0.45, 0.35);
    textData.shouldScale = true;
}
```

**❌ Wrong Examples:**
```glsl
TEXT_EFFECT(123.5, 50, 168) { // Decimal RGB values (must be integers)
    apply_gradient_3(rgb(112, 211, 82), rgb(223, 243, 224), rgb(56, 165, 232), 1.0);
    textData.shouldScale = true;
}

TEXT_EFFECT(123, 50, 168) { // #7B32A8
    apply_gradient_3(rgb(112, 211, 82), rgb(223, 243, 224), rgb(56, 165, 232), 0.5); // Wrong speed
    textData.shouldScale = true;
}

TEXT_EFFECT(123, 50, 168) { // #7B32A8
    apply_gradient_3(rgb(112, 211, 82), rgb(223, 243, 224), rgb(56, 165, 232), 1.0);
    // Missing textData.shouldScale = true;
}

TEXT_EFFECT(123, 50, 168) { // #7B32A8
    apply_gradient_3(rgb(112, 211, 82), rgb(223, 243, 224), rgb(56, 165, 232), 1.0);
    apply_gloss_basic(1.5, 0.45);  // Speed too high (max 1.0)
    textData.shouldScale = true;
}
```

---

## ✨ Optional Effects

You can add extra effects to make your gradients even better:

### `textData.shouldScale = true;`

**What it does:** Makes the text slightly larger when the gradient is applied

**When to use:** Always include this - it makes the gradient more visible

**Example:**
```glsl
TEXT_EFFECT(123, 50, 168) { // #7B32A8
    apply_gradient_3(rgb(112, 211, 82), rgb(223, 243, 224), rgb(56, 165, 232), 1.0);
    textData.shouldScale = true;  // ← Makes text bigger
}
```

---

### `apply_gloss_basic(SPEED, INTENSITY);`

**What it does:** Adds a shiny gloss effect that moves across the text

**Parameters:**
- **SPEED** (0.0 - 1.0): How fast the gloss moves (0.6 = medium)
- **INTENSITY** (0.0 - 1.0): How bright the gloss is (0.45 = medium brightness)

**When to use:** For a subtle shine effect on text

**Examples:**

✅ **Correct:**
```glsl
TEXT_EFFECT(224, 48, 9) { // #E03009
    apply_gradient_3(rgb(201, 2, 56), rgb(96, 0, 38), rgb(255, 0, 0), 1.0);
    apply_gloss_basic(0.55, 0.45);  // Medium speed, medium brightness
    textData.shouldScale = true;
}

TEXT_EFFECT(191, 33, 34) { // #BF2122
    apply_gradient_3(rgb(255, 50, 50), rgb(123, 255, 119), rgb(255, 50, 50), 1.0);
    apply_gloss_basic(0.6, 0.45);   // Slightly faster gloss
    textData.shouldScale = true;
}
```

❌ **Wrong:**
```glsl
TEXT_EFFECT(224, 48, 9) { // #E03009
    apply_gradient_3(rgb(201, 2, 56), rgb(96, 0, 38), rgb(255, 0, 0), 1.0);
    apply_gloss_basic(1.5, 0.45);   // Speed too high (max 1.0)
    textData.shouldScale = true;
}

TEXT_EFFECT(224, 48, 9) { // #E03009
    apply_gradient_3(rgb(201, 2, 56), rgb(96, 0, 38), rgb(255, 0, 0), 1.0);
    apply_gloss_basic(0.55, 1.5);   // Intensity too high (max 1.0)
    textData.shouldScale = true;
}
```

---

### `apply_gloss(SPEED, INTENSITY);`

**What it does:** Advanced gloss effect with more control (used for UI elements)

**Parameters:**
- **SPEED** (0.0 - 1.0): How fast the gloss moves (0.45 = medium)
- **INTENSITY** (0.0 - 1.0): How bright the gloss is (0.35 = subtle)

**When to use:** For a more refined, professional shine effect

**Examples:**

✅ **Correct:**
```glsl
TEXT_EFFECT(31, 122, 254) { // #1F7AFE
    apply_gradient_3(rgb(0, 46, 253), rgb(86, 68, 252), rgb(10, 177, 255), 1.0);
    apply_gloss(0.45, 0.35);  // Subtle, professional gloss
    textData.shouldScale = true;
}

TEXT_EFFECT(255, 102, 102) { // #FF6666
    apply_gradient_3(rgb(255, 99, 229), rgb(247, 0, 0), rgb(255, 153, 255), 1.0);
    apply_gloss(0.45, 0.35);  // Same settings for consistency
    textData.shouldScale = true;
}
```

❌ **Wrong:**
```glsl
TEXT_EFFECT(31, 122, 254) { // #1F7AFE
    apply_gradient_3(rgb(0, 46, 253), rgb(86, 68, 252), rgb(10, 177, 255), 1.0);
    apply_gloss(0.45, 0.35);
    // Missing textData.shouldScale = true;
}

TEXT_EFFECT(31, 122, 254) { // #1F7AFE
    apply_gradient_3(rgb(0, 46, 253), rgb(86, 68, 252), rgb(10, 177, 255), 1.0);
    apply_gloss(0.45);  // Missing intensity parameter
    textData.shouldScale = true;
}
```

---

## 📊 Effect Comparison

| Effect | Purpose | Speed Range | Intensity Range | Use Case |
|--------|---------|-------------|-----------------|----------|
| `apply_gradient_3()` | Color animation | N/A | N/A | Always use |
| `apply_gloss_basic()` | Subtle shine | 0.0 - 1.0 | 0.0 - 1.0 | Text messages |
| `apply_gloss()` | Professional shine | 0.0 - 1.0 | 0.0 - 1.0 | UI elements |
| `textData.shouldScale` | Make text bigger | N/A | N/A | Always use |

---

## 🎨 Complete Examples

### Example 1: Simple Gradient (No Effects)
```glsl
TEXT_EFFECT(123, 50, 168) { // #7B32A8
    apply_gradient_3(rgb(112, 211, 82), rgb(223, 243, 224), rgb(56, 165, 232), 1.0);
    textData.shouldScale = true;
}
```

### Example 2: Gradient + Basic Gloss
```glsl
TEXT_EFFECT(224, 48, 9) { // #E03009
    apply_gradient_3(rgb(201, 2, 56), rgb(96, 0, 38), rgb(255, 0, 0), 1.0);
    apply_gloss_basic(0.6, 0.45);
    textData.shouldScale = true;
}
```

### Example 3: Gradient + Advanced Gloss
```glsl
TEXT_EFFECT(31, 122, 254) { // #1F7AFE
    apply_gradient_3(rgb(0, 46, 253), rgb(86, 68, 252), rgb(10, 177, 255), 1.0);
    apply_gloss(0.45, 0.35);
    textData.shouldScale = true;
}
```

### Example 4: Multiple Gradients with Different Effects
```glsl
TEXT_EFFECT(123, 50, 168) { // #7B32A8
    apply_gradient_3(rgb(112, 211, 82), rgb(223, 243, 224), rgb(56, 165, 232), 1.0);
    textData.shouldScale = true;
}

TEXT_EFFECT(224, 48, 9) { // #E03009
    apply_gradient_3(rgb(201, 2, 56), rgb(96, 0, 38), rgb(255, 0, 0), 1.0);
    apply_gloss_basic(0.55, 0.45);
    textData.shouldScale = true;
}

TEXT_EFFECT(31, 122, 254) { // #1F7AFE
    apply_gradient_3(rgb(0, 46, 253), rgb(86, 68, 252), rgb(10, 177, 255), 1.0);
    apply_gloss(0.45, 0.35);
    textData.shouldScale = true;
}
```

---

### Step 4: Add to Fragment Shader

**File:** `core/rendertype_text.fsh`

Find the if-else chain and add:

**Template:**
```glsl
} else if(iColor == ivec3(R, G, B)) {
    grad.colors[0] = hexToRgb(0xCOLOR1);
    grad.colors[1] = hexToRgb(0xCOLOR2);
    grad.colors[2] = hexToRgb(0xCOLOR3);
    grad.colorCount = 3;
    grad.speed = 1000.0;
    grad.angle = 45.0;
    foundGradient = true;
```

**✅ Correct Example:**
```glsl
} else if(iColor == ivec3(123, 50, 168)) {
    grad.colors[0] = hexToRgb(0x70D352);
    grad.colors[1] = hexToRgb(0xDFF3E0);
    grad.colors[2] = hexToRgb(0x38A5E8);
    grad.colorCount = 3;
    grad.speed = 1000.0;
    grad.angle = 45.0;
    foundGradient = true;
```

**❌ Wrong Examples:**
```glsl
} else if(iColor == ivec3(123, 50, 168)) {
    grad.colors[0] = hexToRgb(0x70d352);  // Lowercase hex
    grad.colors[1] = hexToRgb(0xDFF3E0);
    grad.colors[2] = hexToRgb(0x38A5E8);
    grad.colorCount = 3;
    grad.speed = 1000.0;
    grad.angle = 45.0;
    foundGradient = true;

} else if(iColor == ivec3(123, 50, 168)) {
    grad.colors[0] = hexToRgb(0x70D352);
    grad.colors[1] = hexToRgb(0xDFF3E0);
    grad.colors[2] = hexToRgb(0x38A5E8);
    grad.colorCount = 4;  // Should be 3, not 4
    grad.speed = 1000.0;
    grad.angle = 45.0;
    foundGradient = true;

} else if(iColor == ivec3(123, 50, 168)) {
    grad.colors[0] = hexToRgb(0x70D352);
    grad.colors[1] = hexToRgb(0xDFF3E0);
    // Missing grad.colors[2]
    grad.colorCount = 3;
    grad.speed = 1000.0;
    grad.angle = 45.0;
    foundGradient = true;
```

---

## 🔍 Quick Reference

### What Each Part Does

| Part | File | Purpose |
|------|------|---------|
| `registerGradient()` | `.vsh` | Registers the gradient in memory |
| `TEXT_EFFECT()` | `.glsl` | Applies gradient to text messages |
| `else if(iColor)` | `.fsh` | Renders gradient on UI elements |

### Color Values Must Match

All three files must use the **exact same RGB values**:

```
Trigger Color: #7B32A8
RGB: (123, 50, 168)

✅ All three files use: 123, 50, 168
❌ Don't mix: 123, 50, 168 in one file and 124, 50, 168 in another
```

### Hex Color Rules

- Always use **uppercase**: `0x70D352` ✅
- Never use **lowercase**: `0x70d352` ❌
- Always use **8 characters**: `0x70D352` ✅
- Never use **6 characters**: `0x70D35` ❌

---

## ⚙️ Understanding the Settings

Each gradient has these settings (all locked for consistency):

| Setting | Value | What it does |
|---------|-------|-------------|
| **Speed** | 1000ms | How fast the colors cycle |
| **Angle** | 45° | Direction of the gradient |
| **Colors** | 3 colors | The colors that animate |

---

## ⚠️ Important Rules

✅ **DO:**
- Use the gradient helper tool
- Copy code exactly as shown
- Update all 3 files
- Use uppercase hex colors (`0x70D352`)

❌ **DON'T:**
- Mix up the RGB values
- Use lowercase hex (`0x70d352`)
- Skip any of the 3 files
- Use the same color twice

---

## 🛠️ Tools

### gradient_helper.html

Your one-stop tool for creating gradients:
- 🎨 Color pickers for easy selection
- 📋 Auto-generates all code
- ⚠️ Warns about duplicate colors
- 📋 Copy-to-clipboard buttons

---

## 📂 File Structure

```
shaders/
├── core/
│   ├── rendertype_text.vsh    ← Add gradient registration here
│   ├── rendertype_text.fsh    ← Add gradient rendering here
│   └── rendertype_text.json
├── include/
│   ├── text_effects_config.glsl    ← Add gradient effects here
│   └── ...
└── gradient_helper.html        ← Use this tool
```

---

## 🤔 Troubleshooting

**Gradient not showing?**
- Make sure you updated all 3 files
- Check that RGB values match exactly
- Verify hex colors are uppercase

**Shader error?**
- The helper tool will warn you about duplicate colors
- Try a slightly different color

**Still stuck?**
- Double-check the color values match across all files
- Make sure you're using the exact format shown

---

## 📖 Technical Details

- **Animation Type:** 3-color cycling
- **Cycle Time:** 1 second
- **Direction:** 45° diagonal
- **Shader Version:** GLSL 150
- **Minecraft:** 1.20+

---

## 📄 License

MIT License - Use freely in your projects
