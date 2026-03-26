# 🎨 Animated Text Gradients

<div align="center">

![Gradient Animation](https://file.garden/abM-TiHSwTHZbAzx/myGRADIENT-3-13-2026.gif)

![Minecraft](https://img.shields.io/badge/Minecraft-1.21.4--1.21.11-green?style=flat-square)
![Nexo](https://img.shields.io/badge/Nexo-1.20-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-red?style=flat-square)

**Adds smooth, animated color gradients to Minecraft text and UI elements**

> ⚠️ **Currently only working with Nexo 1.20**. Tested Minecraft versions: **1.21.4 – 1.21.11**

</div>

---

## What does this pack do?

This resource pack makes text in Minecraft (like chat messages, scoreboard names, signs, etc.) smoothly cycle through colors in an animated gradient. Instead of plain white or a single color, the text flows through 3 colors you choose.

---

## Before you start

You need a text editor to edit the shader files. Any of these work:
- [Notepad++](https://notepad-plus-plus.org/) (free, recommended)
- [VS Code](https://code.visualstudio.com/) (free)
- The built-in Windows Notepad (works, but harder to read)

> ⚠️ Do NOT use Microsoft Word or any rich-text editor. They will corrupt the files.

---

## How to install the pack

### For Nexo servers

1. Download the pack as a folder (or extract the `.zip`)
2. Navigate to your Nexo server directory: `\plugins\Nexo\pack\external_packs\`
3. Place the `myGRADIENT` folder there
4. Open `plugins/Nexo/settings.yml` and set:
   ```yaml
   generate_gif_shaders: false
   ```
5. Restart your server

### For vanilla Minecraft

1. Download the pack as a `.zip` file
2. Open Minecraft
3. Go to `Options` → `Resource Packs` → `Open Pack Folder`
4. Drop the `.zip` file into that folder
5. Back in Minecraft, click the arrow to activate the pack
6. Click `Done`

The pack works out of the box with the default gradients already set up. Read on only if you want to **add your own custom gradient colors**.

---

## How to add a custom gradient

Adding a gradient means: you pick a "trigger color" and 3 gradient colors. Whenever Minecraft renders text in that trigger color, it will show your animated gradient instead.

You need to edit **3 files** inside the pack. All 3 must match — if even one is wrong or missing, the gradient won't work.

The 3 files are:
```
assets/minecraft/shaders/core/rendertype_text.vsh
assets/minecraft/shaders/core/rendertype_text.fsh
assets/minecraft/shaders/include/text_effects_config.glsl
```

---

## Step 1 — Pick your colors

You need:
- 1 trigger color (the color you'll use in-game to activate the gradient)
- 3 gradient colors (the colors the text will animate through)

For each color you need two formats:
- **Hex** — looks like `#7B32A8` (used in the `.vsh` and `.fsh` files)
- **RGB** — looks like `123, 50, 168` (used in the `.glsl` config file)

You can convert between them at [rgbcolorpicker.com](https://rgbcolorpicker.com/) or any color picker tool.

> ⚠️ Write down both formats for all 4 colors before you start editing. Mixing them up is the most common mistake.

### Color Template

Fill this out before editing any files:

```
Trigger Color:
  Hex: #______
  RGB: ___, ___, ___

Gradient Color 1:
  Hex: #______
  RGB: ___, ___, ___

Gradient Color 2:
  Hex: #______
  RGB: ___, ___, ___

Gradient Color 3:
  Hex: #______
  RGB: ___, ___, ___
```

---

## Step 2 — Edit the vertex shader (.vsh)

Open: `assets/minecraft/shaders/core/rendertype_text.vsh`

Find the function called `initGradients()`. Inside it, add a new line using this format:

```
registerGradient(0xTRIGGER, 0xCOLOR1, 0xCOLOR2, 0xCOLOR3, 1000.0, 45.0);
```

Replace `TRIGGER`, `COLOR1`, `COLOR2`, `COLOR3` with your hex color values (without the `#`).

Example with real colors:
```
registerGradient(0x7B32A8, 0x70D352, 0xDFF3E0, 0x38A5E8, 1000.0, 45.0);
```

### Template for this step

```
registerGradient(0x______, 0x______, 0x______, 0x______, 1000.0, 45.0);
```

Fill in the blanks with your hex values (uppercase, no `#`).

### Common mistakes in this file

| Mistake | Wrong | Correct |
|---|---|---|
| Lowercase hex letters | `0x7b32a8` | `0x7B32A8` |
| Missing the last two numbers | `registerGradient(0x7B32A8, 0x70D352, 0xDFF3E0, 0x38A5E8)` | add `, 1000.0, 45.0` at the end |
| Wrong number of colors | only 2 colors listed | always list exactly 3 gradient colors |

> ⚠️ Hex values must always be UPPERCASE letters (A–F). Lowercase will cause the gradient to not match.

---

## Step 3 — Edit the config file (.glsl)

Open: `assets/minecraft/shaders/include/text_effects_config.glsl`

Find the section with other `TEXT_EFFECT(...)` blocks and add yours in the same area. Use this format:

```
TEXT_EFFECT(R, G, B) { // #HEXCOLOR
    apply_gradient_3(rgb(R1, G1, B1), rgb(R2, G2, B2), rgb(R3, G3, B3), 1.0);
    textData.shouldScale = true;
}
```

Replace `R, G, B` with the RGB values of your trigger color, and `R1 G1 B1` etc. with the RGB values of your 3 gradient colors.

Example:
```
TEXT_EFFECT(123, 50, 168) { // #7B32A8
    apply_gradient_3(rgb(112, 211, 82), rgb(223, 243, 224), rgb(56, 165, 232), 1.0);
    textData.shouldScale = true;
}
```

### Optional: add a gloss/shine effect

You can add a shiny highlight that moves across the text. Add one of these lines between `apply_gradient_3(...)` and `textData.shouldScale`:

For a subtle shine:
```
apply_gloss_basic(0.55, 0.45);
```

For a smoother, more refined shine:
```
apply_gloss(0.45, 0.35);
```

The two numbers are `speed` and `brightness`, both between `0.0` and `1.0`.

### Common mistakes in this file

| Mistake | Wrong | Correct |
|---|---|---|
| Decimal RGB values | `TEXT_EFFECT(123.5, 50, 168)` | `TEXT_EFFECT(123, 50, 168)` — whole numbers only |
| Missing `textData.shouldScale` | forgot the last line | always include `textData.shouldScale = true;` |
| Wrong speed value in gloss | `apply_gloss_basic(1.5, 0.45)` | max value is `1.0` |
| Missing closing `}` | block not closed | every `TEXT_EFFECT {` needs a matching `}` |

---

## Step 4 — Edit the fragment shader (.fsh)

Open: `assets/minecraft/shaders/core/rendertype_text.fsh`

Find the section with other `else if(iColor == ...)` blocks and add yours. Use this format:

```
} else if(iColor == ivec3(R, G, B)) {
    grad.colors[0] = hexToRgb(0xCOLOR1);
    grad.colors[1] = hexToRgb(0xCOLOR2);
    grad.colors[2] = hexToRgb(0xCOLOR3);
    grad.colorCount = 3;
    grad.speed = 1000.0;
    grad.angle = 45.0;
    foundGradient = true;
```

Example:
```
} else if(iColor == ivec3(123, 50, 168)) {
    grad.colors[0] = hexToRgb(0x70D352);
    grad.colors[1] = hexToRgb(0xDFF3E0);
    grad.colors[2] = hexToRgb(0x38A5E8);
    grad.colorCount = 3;
    grad.speed = 1000.0;
    grad.angle = 45.0;
    foundGradient = true;
```

### Common mistakes in this file

| Mistake | Wrong | Correct |
|---|---|---|
| Lowercase hex | `hexToRgb(0x70d352)` | `hexToRgb(0x70D352)` |
| Wrong color count | `grad.colorCount = 4` | always `grad.colorCount = 3` |
| Missing a color line | only 2 `grad.colors[...]` lines | always include all 3: `[0]`, `[1]`, `[2]` |
| Missing `foundGradient = true` | forgot the last line | always include it |

---

## The values must match across all 3 files

This is the most important rule. The trigger color RGB values you use in Step 3 must exactly match the ones in Step 4. The hex colors in Step 2 and Step 4 must also match.

Example — all 3 files using the same trigger color:

```
Step 2 (.vsh):  registerGradient(0x7B32A8, ...)
Step 3 (.glsl): TEXT_EFFECT(123, 50, 168) { ... }
Step 4 (.fsh):  } else if(iColor == ivec3(123, 50, 168)) {
```

`#7B32A8` = RGB `123, 50, 168` — these are the same color in different formats.

> ⚠️ If the numbers don't match between files, the gradient will silently not work. No error message, it just won't show.

---

## Minecraft version compatibility

This pack uses overlays to support multiple Minecraft versions automatically. You don't need to do anything — the right files are loaded based on your game version.

| Minecraft version | Folder used |
|---|---|
| 1.21.2 – 1.21.6 | `1_21_2/` |
| 1.21.7 – 1.21.8 | `1_21_7/` |
| 1.21.9 – 1.21.10 | `1_21_9/` |
| 1.21.11+ | `1_21_11/` |
| Everything else | `assets/` (base) |

If you're editing gradients, edit the files in `assets/` — that's the base that applies to all versions.

---

## Troubleshooting

**Gradient not showing at all**
- Did you edit all 3 files?
- Do the RGB values match exactly between the `.glsl` and `.fsh` files?
- Are the hex values uppercase in the `.vsh` and `.fsh` files?

**Game crashes or shows a pink/magenta screen**
- You have a syntax error in one of the shader files
- Open the file you last edited and look for a missing `;`, `}`, or a typo
- Compare your addition carefully against the examples above

**Gradient shows but colors look wrong**
- Double-check that the hex colors in `.vsh` and `.fsh` match
- Make sure you didn't accidentally swap trigger color and gradient colors

**Gloss effect not visible**
- Make sure `apply_gloss_basic()` or `apply_gloss()` is placed before `textData.shouldScale = true;`
- Check that both numbers are between `0.0` and `1.0`

**Pack not loading at all**
- Make sure the `.zip` file structure starts with `assets/` and `pack.mcmeta` at the root
- Don't put the pack inside an extra folder inside the zip

---

## File overview

```
assets/minecraft/shaders/
├── core/
│   ├── rendertype_text.vsh        ← Step 2: register your gradient
│   ├── rendertype_text.fsh        ← Step 4: render your gradient
│   └── rendertype_text.json       ← don't touch this
├── include/
│   ├── text_effects_config.glsl   ← Step 3: configure your gradient
│   └── ...                        ← don't touch these
```

---

## Planned Updates

- **Web-Based Editor** — Edit gradients directly in your browser without touching shader files
- **Effects** — Additional visual effects and animations for text

---

## License

MIT — free to use in your own resource packs and projects.
