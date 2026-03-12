# 🎨 Animated Text Gradients

<div align="center">

![Gradient Animation](https://img.shields.io/badge/Shader-GLSL%20150-blue?style=flat-square)
![Minecraft](https://img.shields.io/badge/Minecraft-1.20+-green?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-red?style=flat-square)

**A powerful shader system for smooth, animated color gradients on Minecraft text and UI elements**

[Features](#-features) • [Quick Start](#-quick-start) • [Documentation](#-documentation) • [Tools](#-tools)

</div>

---

## ✨ Features

- **Smooth Animations** - 3-color cycling gradients with 1-second cycles
- **Universal Support** - Works on glyphs (UI) and text messages (chat/signs)
- **Easy Creation** - Interactive web tool to generate gradient code
- **Duplicate Detection** - Automatic warnings for shader conflicts
- **Professional Quality** - Production-ready shader implementation

---

## 🚀 Quick Start

### Using the Gradient Helper

The easiest way to create new gradients is with the included `gradient_helper.html` tool:

1. **Open** `gradient_helper.html` in your web browser
2. **Select** your trigger color (the color code that activates the gradient)
3. **Pick** 3 gradient colors using the color pickers
4. **Click** "Generate Configs"
5. **Copy** the generated code to the three required files

---

## 📝 Creating Custom Gradients

When you create a new gradient, you **must** add code to all three files for it to work everywhere.

### Architecture

The gradient system is split across three shader files:

| File | Purpose | Target |
|------|---------|--------|
| `core/rendertype_text.vsh` | Gradient registration | Glyphs (Vertex Shader) |
| `core/rendertype_text.fsh` | Gradient rendering | Glyphs (Fragment Shader) |
| `include/text_effects_config.glsl` | Gradient application | Text Messages |

### Implementation Guide

#### Step 1: Register in Vertex Shader

**File:** `core/rendertype_text.vsh`

Add this line in the `initGradients()` function:

```glsl
registerGradient(0xTRIGGER, 0xCOLOR1, 0xCOLOR2, 0xCOLOR3, 1000.0, 45.0);
```

**Example:**
```glsl
registerGradient(0x7B32A8, 0x70D352, 0xDFF3E0, 1000.0, 45.0);
```

#### Step 2: Apply to Text Messages

**File:** `include/text_effects_config.glsl`

Add this block in the switch statement:

```glsl
TEXT_EFFECT(R, G, B) { // #HEXCOLOR
    apply_gradient_3(rgb(R1, G1, B1), rgb(R2, G2, B2), rgb(R3, G3, B3), 1.0);
    textData.shouldScale = true;
}
```

**Example:**
```glsl
TEXT_EFFECT(123, 50, 168) { // #7B32A8
    apply_gradient_3(rgb(112, 211, 82), rgb(223, 243, 224), rgb(56, 165, 232), 1.0);
    textData.shouldScale = true;
}
```

#### Step 3: Render for Glyphs

**File:** `core/rendertype_text.fsh`

Add this block in the main() function's if-else chain:

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

**Example:**
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

---

## ⚙️ Configuration

### Gradient Parameters

- **Speed**: Animation cycle duration in milliseconds (default: 1000ms)
- **Angle**: Gradient direction in degrees (default: 45°)
- **Colors**: 3-color cycling animation

### Color Format

- **Trigger Color**: RGB hex code (e.g., `#7B32A8`)
- **Gradient Colors**: RGB hex codes (e.g., `0x70D352`)
- **Hex Format**: Always uppercase (e.g., `0x70D352` not `0x70d352`)

---

## ⚠️ Important Notes

- **All three files must be updated** for a gradient to work on both glyphs and text messages
- **Trigger color must match exactly** across all three files (RGB values)
- **Hex colors must be in uppercase** format
- **Avoid duplicate case labels** - the helper tool will warn you if your color creates a collision
- **Speed and angle are locked** to 1000ms and 45° for consistency

---

## 📂 File Structure

```
shaders/
├── core/
│   ├── rendertype_text.vsh    # Vertex shader (glyphs)
│   ├── rendertype_text.fsh    # Fragment shader (glyphs)
│   └── rendertype_text.json
├── include/
│   ├── text_effects_config.glsl    # Text message effects
│   ├── text_effects.glsl
│   ├── spheya_packs.glsl
│   └── ...
├── gradient_helper.html        # Gradient generator tool
└── how_to_use.md              # Documentation
```

---

## 🛠️ Tools

### gradient_helper.html

Interactive web tool for generating gradient code. Features:
- Color picker for trigger and gradient colors
- Automatic code generation for all three files
- Duplicate detection to prevent shader errors
- Copy-to-clipboard functionality

---

## 📖 Technical Details

- **Animation Type**: 3-color gradient cycling
- **Cycle Duration**: 1000 milliseconds
- **Gradient Direction**: 45-degree diagonal
- **Supported Targets**: Glyphs + Text Messages
- **Shader Version**: GLSL 150

---

## 🤝 Contributing

To add new gradients or improve the system:

1. Use `gradient_helper.html` to generate code
2. Test the gradient on both glyphs and text messages
3. Ensure all three files are properly updated
4. Verify no duplicate case labels are created

---

## 📄 License

This shader pack is provided as-is for use in Minecraft resource packs.
