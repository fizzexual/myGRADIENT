# 🎨 myGRADIENT - Animated Text Gradients

<div align="center">

![Gradient Animation](https://file.garden/abM-TiHSwTHZbAzx/myGRADIENT-3-13-2026.gif)

![Shader](https://img.shields.io/badge/Shader-GLSL%20150-blue?style=flat-square)
![Minecraft](https://img.shields.io/badge/Minecraft-1.20+-green?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-red?style=flat-square)

**Beautiful animated color gradients for Minecraft text - No coding required!**

[Installation](#-installation) • [Add Colors](#-adding-new-colors) • [Server Setup](#-server-setup)

</div>

---

## ✨ What is myGRADIENT?

myGRADIENT adds **smooth, animated color gradients** to your Minecraft text. Text smoothly cycles through beautiful colors instead of staying static.

**Perfect for:**
- 🎮 Server branding and custom text
- 💬 Chat messages with style
- 🏷️ Scoreboards and signs
- 🎨 Custom UI elements

**Best part?** You don't need to know how to code. We've made it super simple!

---

## 🚀 Installation

### For Players

1. **Download** the myGRADIENT pack
2. **Extract** the ZIP file
3. **Move** the folder to your resource packs folder:
   - **Windows:** `%appdata%\.minecraft\resourcepacks\`
   - **Mac:** `~/Library/Application Support/minecraft/resourcepacks/`
   - **Linux:** `~/.minecraft/resourcepacks/`
4. **Open Minecraft** → Settings → Resource Packs → Enable myGRADIENT
5. **Done!** Your text now has beautiful gradients

### For Server Owners

1. **Download** the myGRADIENT pack
2. **Extract** the ZIP file
3. **Move** to your server's resource packs folder
4. **Add to server.properties:**
   ```
   resource-pack=file:///path/to/myGRADIENT
   resource-pack-sha1=<optional-hash>
   ```
5. **Restart** your server
6. **Players** will automatically download the pack on join

### For Nexo Users (Paper/Spigot Servers)

1. **Download** the myGRADIENT pack
2. **Extract** the ZIP file
3. **Move** the `myGRADIENT` folder to:
   ```
   plugins/Nexo/pack/external_packs/myGRADIENT
   ```
4. **Edit Nexo config** (`plugins/Nexo/settings.yml`):
   ```yaml
   generate_gif_shaders: false
   ```
5. **Restart** your server
6. **Done!** Gradients will work on your server

**Compatibility:**
- ✅ Nexo 1.20 (tested and working)
- ⚠️ Nexo versions above 1.20 (not tested)
- ✅ Minecraft 1.21.4 - 1.21.11 (tested and working)
- ⚠️ Minecraft versions above 1.21.11 (not tested)

---

## 🎨 Adding New Colors (Super Easy!)

### What You Need

- A color you like (hex code, like `#FF5733`)
- A text editor (Notepad, Word, anything!)
- 5 minutes

### Step 1: Pick Your Colors

You need **4 colors total:**
1. **Trigger Color** - The color code that activates your gradient (e.g., `#FF5733`)
2. **3 Gradient Colors** - The colors that animate (e.g., `#FF0000`, `#00FF00`, `#0000FF`)

**Where to find colors:**
- Google "color picker" and click the first result
- Use any online color picker tool
- Pick colors you like!

### Step 2: Convert to RGB

Once you have your hex colors, convert them to RGB:

**Example:** `#FF5733` → RGB: `(255, 87, 51)`

**How to convert:**
- Use an online converter (Google "hex to RGB")
- Or use this simple method:
  - Take the hex code: `#FF5733`
  - Split it: `FF` `57` `33`
  - Convert each to decimal: `255` `87` `51`

### Step 3: Add to the Config File

**Open this file:**
```
myGRADIENT/assets/minecraft/shaders/include/text_effects_config.glsl
```

**Find the end of the file** (look for the last `}` before the end)

**Add this code:**
```glsl
TEXT_EFFECT(R, G, B) { // #HEXCOLOR
    apply_gradient_3(rgb(R1, G1, B1), rgb(R2, G2, B2), rgb(R3, G3, B3), 1.0);
    textData.shouldScale = true;
}
```

**Replace with your values:**
- `R, G, B` = Your trigger color RGB (e.g., `255, 87, 51`)
- `#HEXCOLOR` = Your trigger color hex (e.g., `#FF5733`)
- `R1, G1, B1` = First gradient color RGB
- `R2, G2, B2` = Second gradient color RGB
- `R3, G3, B3` = Third gradient color RGB

**Real Example:**
```glsl
TEXT_EFFECT(255, 87, 51) { // #FF5733
    apply_gradient_3(rgb(255, 0, 0), rgb(0, 255, 0), rgb(0, 0, 255), 1.0);
    textData.shouldScale = true;
}
```

### Step 4: Use Your Color in Minecraft

Now you can use your color code in Minecraft:

**In chat:**
```
/say §cHello World!
```

**On signs:**
```
Line 1: §cHello
Line 2: World!
```

**On scoreboards:**
```
/scoreboard objectives add test dummy "§cTest"
```

The `§c` is the color code. Replace `c` with your color code.

---

## 🎨 Pre-Made Colors

We've included some beautiful pre-made gradients. Here are the color codes:

| Color | Code | Hex | RGB |
|-------|------|-----|-----|
| Red/Orange | `§c` | #E03009 | 224, 48, 9 |
| Purple/Pink | `§d` | #BE1AF5 | 190, 26, 245 |
| Blue | `§9` | #1F7AFE | 31, 122, 254 |
| Gold | `§6` | #FFA500 | 255, 165, 0 |
| Green | `§a` | #00FF7F | 0, 255, 127 |
| Pink | `§d` | #FF1493 | 255, 20, 147 |

**Use them like this:**
```
/say §cThis text has a red gradient!
/say §dThis text has a purple gradient!
/say §9This text has a blue gradient!
```

---

## 🎯 Tips for Great Gradients

### Color Combinations That Look Good

**Warm Colors:**
- Red → Orange → Yellow
- Orange → Yellow → Gold

**Cool Colors:**
- Blue → Cyan → Light Blue
- Purple → Blue → Cyan

**Rainbow:**
- Red → Green → Blue
- Purple → Pink → Magenta

**Monochrome:**
- Dark Red → Red → Light Red
- Dark Blue → Blue → Light Blue

### What NOT to Do

❌ **Don't use the same color twice**
```glsl
// BAD - all colors are the same
apply_gradient_3(rgb(255, 0, 0), rgb(255, 0, 0), rgb(255, 0, 0), 1.0);
```

❌ **Don't use very similar colors**
```glsl
// BAD - colors are too similar, no animation effect
apply_gradient_3(rgb(255, 0, 0), rgb(254, 0, 0), rgb(253, 0, 0), 1.0);
```

✅ **Do use contrasting colors**
```glsl
// GOOD - colors are different and create a nice effect
apply_gradient_3(rgb(255, 0, 0), rgb(0, 255, 0), rgb(0, 0, 255), 1.0);
```

---

## 🖥️ Server Setup Guide

### Step 1: Download and Extract

1. Download myGRADIENT
2. Extract the ZIP file
3. Place it in your server's resource packs folder

### Step 2: Configure Server

**Edit `server.properties`:**

```properties
# Add these lines:
resource-pack=file:///C:/path/to/myGRADIENT
resource-pack-sha1=
require-resource-pack=false
```

**Windows path example:**
```
resource-pack=file:///C:/Users/YourName/Desktop/myGRADIENT
```

**Linux path example:**
```
resource-pack=file:///home/username/myGRADIENT
```

### Step 3: Restart Server

Restart your server. Players will now see a prompt to download the pack.

### Step 4: Test It

1. Join your server
2. Accept the resource pack
3. Use a color code in chat: `/say §cTest`
4. You should see the gradient animation!

---

## ❓ FAQ

### Q: Do I need to know how to code?
**A:** No! Just follow the steps above. It's just copy-paste.

### Q: Can I add unlimited colors?
**A:** Yes! Add as many as you want. Just follow the same steps.

### Q: Will this work on my server?
**A:** Yes! Works on any Minecraft server (1.20+).

### Q: Can players disable it?
**A:** Yes, they can turn off the resource pack in their settings.

### Q: What if I make a mistake?
**A:** Just undo your changes and try again. You can't break anything.

### Q: Can I use this on a public server?
**A:** Yes! It's MIT licensed - use it however you want.

### Q: How do I remove a color?
**A:** Delete the entire `TEXT_EFFECT` block for that color.

### Q: Can I edit existing colors?
**A:** Yes! Just change the RGB values in the `apply_gradient_3()` line.

---

## 🔧 Troubleshooting

### Gradient not showing?

**Check:**
1. Did you save the file?
2. Did you reload the resource pack in Minecraft?
3. Are you using the correct color code?

**Fix:**
1. Save the file
2. Restart Minecraft
3. Re-enable the resource pack

### Text looks weird?

**Check:**
1. Are your RGB values correct?
2. Did you use the right format?

**Fix:**
1. Double-check your RGB values
2. Make sure you copied the code exactly

### Server won't load the pack?

**Check:**
1. Is the path correct in `server.properties`?
2. Is the folder in the right location?

**Fix:**
1. Use the full path (not relative path)
2. Make sure the folder exists

---

## 📂 File Structure

```
myGRADIENT/
├── assets/
│   └── minecraft/
│       ├── lang/
│       │   └── en_us.json
│       └── shaders/
│           ├── core/
│           │   └── rendertype_text.json
│           └── include/
│               └── text_effects_config.glsl  ← Edit this file!
├── 1_21_2/
│   └── assets/minecraft/shaders/core/
│       └── rendertype_text.json
├── 1_21_11/
│   └── assets/minecraft/shaders/core/
│       └── rendertype_text.json
├── pack.mcmeta
└── README.md
```

---

## 🎨 Advanced: Adding Gloss Effects

Want to make your gradients even fancier? Add a gloss effect!

### Basic Gloss

```glsl
TEXT_EFFECT(255, 87, 51) { // #FF5733
    apply_gradient_3(rgb(255, 0, 0), rgb(0, 255, 0), rgb(0, 0, 255), 1.0);
    apply_gloss_basic(0.55, 0.45);  // ← Add this line
    textData.shouldScale = true;
}
```

### Advanced Gloss

```glsl
TEXT_EFFECT(255, 87, 51) { // #FF5733
    apply_gradient_3(rgb(255, 0, 0), rgb(0, 255, 0), rgb(0, 0, 255), 1.0);
    apply_gloss(0.45, 0.35);  // ← Or this line
    textData.shouldScale = true;
}
```

**Parameters:**
- First number (0.0 - 1.0): Speed of the gloss
- Second number (0.0 - 1.0): Brightness of the gloss

---

## 📊 Version Support

| Version | Supported | Folder |
|---------|-----------|--------|
| 1.20.x | ✅ Yes | `assets/` |
| 1.21.0 - 1.21.1 | ✅ Yes | `1_21_2/` |
| 1.21.2+ | ✅ Yes | `1_21_2/` |
| 1.21.11+ | ✅ Yes | `1_21_11/` |

---

## 📄 License

MIT License - Use freely in your projects, servers, and packs!

---

## 🤝 Support

Having issues? Here's what to check:

1. **File saved?** Make sure you saved the file after editing
2. **Correct format?** Copy the code exactly as shown
3. **RGB values?** Make sure they match your hex color
4. **Minecraft restarted?** Restart Minecraft after changes

---

## 🎉 Have Fun!

That's it! You now have beautiful animated gradients in your Minecraft server. Enjoy!

