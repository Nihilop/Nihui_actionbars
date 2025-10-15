# Nihui AB - Action Bars

**Version:** 1.0
**Author:** nihil (based on rnxmUI)

Complete action bar management system with visual enhancements and extensive text customization options.

## Features

### Mask System
- **Custom Textures:** Apply unique shaped masks to action bar buttons
- **Visual Consistency:** Match your action bars to the rest of your UI theme
- **Performance Optimized:** Efficient texture management

### Spell Break Detection
- **Visual Feedback:** Instant notification when your spell cast is interrupted
- **Clear Indicators:** Easily see which abilities were locked out

### Text Placement System

#### Keybind Text
- **Customizable Font:** Choose any font file from your WoW installation
- **Size Control:** Adjust font size from 8 to 24
- **Font Flags:** Normal, Outline, Thick Outline, Monochrome
- **Color Picker:** Full RGB+Alpha color customization
- **Shadow Effects:** Configurable shadow with offset control
- **Flexible Anchoring:** Position anywhere on the button (TopLeft, Top, TopRight, Left, Center, Right, BottomLeft, Bottom, BottomRight)
- **Offset Adjustment:** Fine-tune X/Y positioning

#### Macro Name Text
- **Independent Styling:** Separate configuration from keybind text
- **Same Features:** Font, size, color, shadow, anchor, offset
- **Visual Distinction:** Style differently to differentiate from keybinds

#### Item Count
- **Stack Numbers:** Display item stack counts clearly
- **Custom Styling:** Independent font, size, color configuration
- **Shadow Support:** Readable even on bright backgrounds
- **Corner Positioning:** Typically anchored to BottomRight for clarity

### Configuration GUI
- **In-Game Panel:** User-friendly configuration interface
- **Live Preview:** See changes as you make them
- **Reset Option:** Return to defaults instantly
- **Per-Character Settings:** Each character has independent configuration

## Installation

1. Extract the `Nihui_ab` folder to:
   ```
   World of Warcraft\_retail_\Interface\AddOns\
   ```
2. Restart World of Warcraft or type `/reload`

## Configuration

Open the settings GUI:
```
/nihuiab
```

### Quick Setup

1. Type `/nihuiab` to open the configuration panel
2. Navigate to the text element you want to customize (Keybind, Macro Name, or Count)
3. Enable/disable the element
4. Adjust font, size, color, and position
5. Click "Apply" to see changes immediately

### Text Element Settings

Each text element (Keybind, Macro Name, Count) has these options:

- **Enabled:** Show/hide this text element
- **Font:** Path to font file (e.g., `Fonts\FRIZQT__.TTF`)
- **Font Size:** Size in pixels (8-24 recommended)
- **Font Flags:** Outline style (OUTLINE, THICKOUTLINE, MONOCHROME, or blank)
- **Color:** RGBA values (0.0 to 1.0)
- **Shadow Color:** RGBA values for text shadow
- **Shadow Offset:** X/Y pixel offset for shadow
- **Anchor:** Attachment point on the button
- **Offset:** X/Y pixel offset from anchor point

### Recommended Settings

**Keybinds (highly visible):**
- Font: `Fonts\FRIZQT__.TTF`
- Size: 12
- Flags: `OUTLINE`
- Color: White (0.8, 0.8, 0.8, 1)
- Anchor: `TOPRIGHT`

**Macro Names (subtle):**
- Font: `Fonts\FRIZQT__.TTF`
- Size: 10
- Flags: `OUTLINE`
- Color: Light Blue (0.8, 0.8, 1, 1)
- Anchor: `BOTTOM`

**Item Count (corner):**
- Font: `Fonts\FRIZQT__.TTF`
- Size: 14
- Flags: `OUTLINE`
- Color: White (1, 1, 1, 1)
- Anchor: `BOTTOMRIGHT`

### Reset to Defaults

Return to default configuration:
```
/nihuiab reset
```

## Compatibility

- **Game Version:** Retail (The War Within - 11.0.2+)
- **Action Bar Addons:** Works with Bartender, Dominos, and Blizzard default bars
- **Conflicts:** Minimal - only modifies text display, not bar functionality

## Performance

- Lightweight event handling
- Efficient text updates (only on relevant events)
- Minimal memory footprint

## Saved Variables

Settings stored per character:
```
WTF\Account\<ACCOUNT>\<SERVER>\<CHARACTER>\SavedVariables\NihuiActionBarsDB.lua
```

## Troubleshooting

**Q: Text isn't showing**
A: Make sure the text element is enabled in `/nihuiab` and check that your action bars are visible

**Q: Text is cut off**
A: Adjust the anchor point and X/Y offset to move the text within the button area

**Q: Font looks wrong**
A: Verify the font path is correct. Use a font from `Fonts\` folder

**Q: Changes don't apply**
A: Click "Apply" button in the GUI. If issues persist, type `/reload`

**Q: Shadow not visible**
A: Increase shadow offset or use a darker shadow color with full opacity

## Commands

- `/nihuiab` - Open configuration GUI
- `/nihuiab reset` - Reset to default settings
- `/reload` - Reload UI after major changes

## Credits

**Author:** nihil
**Based on:** rnxmUI action bar system

Part of the **Nihui UI Suite**

---

*Clean action bars, maximum control*
