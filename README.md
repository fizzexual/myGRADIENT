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

```glsl
registerGradient(0x7B32A8, 0x70D352, 0xDFF3E0, 1000.0, 45.0);
```

### Step 3: Add to Text Config

**File:** `include/text_effects_config.glsl`

Find the switch statement and add:

```glsl
TEXT_EFFECT(123, 50, 168) { // #7B32A8
    apply_gradient_3(rgb(112, 211, 82), rgb(223, 243, 224), rgb(56, 165, 232), 1.0);
    textData.shouldScale = true;
}
```

### Step 4: Add to Fragment Shader

**File:** `core/rendertype_text.fsh`

Find the if-else chain and add:

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
