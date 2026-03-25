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

1. **Download** the myGRADIENT pack from [mc-packs.net](https://mc-packs.net)
2. **Extract** the ZIP file
3. **Move** the folder to your resource packs folder:
   - **Windows:** `%appdata%\.minecraft\resourcepacks\`
   - **Mac:** `~/Library/Application Support/minecraft/resourcepacks/`
   - **Linux:** `~/.minecraft/resourcepacks/`
4. **Open Minecraft** → Settings → Resource Packs → Enable myGRADIENT
5. **Done!** Your text now has beautiful gradients

### For Server Owners

**⚠️ Important:** Upload your pack to [mc-packs.net](https://mc-packs.net) for easy distribution to players!

1. **Upload** the myGRADIENT pack to [mc-packs.net](https://mc-packs.net)
2. **Copy** the download link and SHA1 hash provided by mc-packs.net
3. **Add to server.properties:**
   ```
   resource-pack=https://download.mc-packs.net/pack/YOUR_PACK_ID.zip
   resource-pack-sha1=YOUR_SHA1_HASH
   ```
4. **Example:**
   ```
   resource-pack=https://download.mc-packs.net/pack/ceff49f82c4a767d76e5d8cdf381fdf3ae3b5cec.zip
   resource-pack-sha1=ce4f824a767fd76e58cff264g31b813ade3b5cec
   ```
5. **Restart** your server
6. **Players** will automatically download the pack on join

**Compatibility:**
- ✅ Minecraft 1.21.11 (tested and working)
- ⚠️ Minecraft versions above 1.21.11 (not tested)

---

## 🎨 Using Pre-Made Gradients

The pack comes with beautiful pre-made gradients ready to use. Simply use the color codes in Minecraft:

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
│       └── shaders/
│           ├── core/
│           │   ├── rendertype_text.fsh
│           │   ├── rendertype_text.vsh
│           │   ├── rendertype_text.json
│           │   ├── text.json
│           │   ├── gui_text.json
│           │   └── text_polygon_offset.json
├── pack.mcmeta
└── README.md
```

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

