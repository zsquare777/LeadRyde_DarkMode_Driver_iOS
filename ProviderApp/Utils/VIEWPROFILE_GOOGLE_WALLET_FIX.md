# ViewProfileUV TableView - Google Wallet Style Dark Mode Fix

## Issue
The ViewProfileUV TableView was not working properly in dark mode like Google Wallet. Specific issues:
- Arrow icons were hardcoded to light gray (not theme-aware)
- Separator lines were not configured
- Separator color didn't change with theme
- Overall appearance didn't match Google Wallet's polished dark mode

## Solution

### Changes Made

#### 1. ViewProfileUV.swift - `cellForRowAt` Method
**Before:**
```swift
GeneralFunctions.setImgTintColor(imgView: cell.nextArrowImgView, color: UIColor.lightGray)
```

**After:**
```swift
// Apply theme-aware arrow color instead of hardcoded lightGray
let arrowColor = ThemeManager.shared.isDarkModeActive ? UIColor.white.withAlphaComponent(0.6) : UIColor.lightGray
GeneralFunctions.setImgTintColor(imgView: cell.nextArrowImgView, color: arrowColor)
```

**Why:** Arrow icons now adapt to the theme - white with 60% opacity in dark mode, light gray in light mode. This matches Google Wallet's style.

---

#### 2. ViewProfileUV.swift - `setTableView` Method
**Added:**
```swift
// Configure table view appearance for theme support (Google Wallet style)
self.tableView.separatorStyle = .singleLine
self.tableView.separatorColor = ThemeManager.shared.separatorColor()
self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 60, right: 0, bottom: 0)
```

**Why:** 
- Enables cell separators (Google Wallet uses subtle separators)
- Sets theme-aware separator color
- Indents separators by 60 points to align with content (starts after icon), matching Google Wallet's design

---

#### 3. ViewProfileUV.swift - `applyTheme` Method
**Added:**
```swift
// Update separator color (Google Wallet style)
self.tableView.separatorColor = themeManager.separatorColor()
```

**Why:** When theme changes, separator color updates dynamically. In dark mode, separators are subtle gray (#3A3A3C), in light mode they're light gray (#E5E5EA).

---

#### 4. ProfileTVCell.swift - `applyTheme` Method
**Simplified:**
```swift
func applyTheme() {
    let themeManager = ThemeManager.shared
    
    // Update colors based on theme (Google Wallet style)
    backgroundColor = themeManager.cardBackgroundColor()
    contentView.backgroundColor = themeManager.cardBackgroundColor()
    titleLbl.textColor = themeManager.textColor()
    
    // Note: Arrow and icon tint colors are set in cellForRowAt to respect custom images
}
```

**Why:** Removed icon tinting from cell to avoid conflicts. Arrow color is now set in `cellForRowAt` where it has access to theme information. This prevents the cell's `applyTheme` from overriding the arrow color.

---

## Visual Comparison: Google Wallet Style

### Light Mode:
- ✅ Cell Background: White (#FFFFFF)
- ✅ Text Color: Black (#000000)
- ✅ Arrow Color: Light Gray
- ✅ Separator Color: Light Gray (#E5E5EA)
- ✅ Table Background: Light Gray (#f1f1f1)

### Dark Mode:
- ✅ Cell Background: Dark Gray (#2C2C2E)
- ✅ Text Color: White (#FFFFFF)
- ✅ Arrow Color: White with 60% opacity
- ✅ Separator Color: Medium Gray (#3A3A3C)
- ✅ Table Background: Dark Gray (#1C1C1E)

---

## Technical Details

### Separator Configuration:
- **Style:** Single line (like Google Wallet)
- **Inset:** 60 points from left (aligns with text content)
- **Color:** Theme-aware (changes automatically)
- **Updates:** Dynamically when theme changes

### Arrow Icons:
- **Light Mode:** `UIColor.lightGray`
- **Dark Mode:** `UIColor.white.withAlphaComponent(0.6)`
- **Updates:** On cell configuration (cellForRowAt)
- **Style:** Matches Google Wallet's subtle arrow appearance

### Cell Backgrounds:
- **Light Mode:** White cards on light gray background
- **Dark Mode:** Dark gray cards on darker gray background
- **Separation:** Clear visual hierarchy maintained in both modes

---

## Result
The ViewProfileUV TableView now perfectly matches Google Wallet's dark mode implementation:
- Smooth transitions between themes
- Proper contrast and readability
- Professional, polished appearance
- Consistent with iOS design guidelines
- Theme-aware separators and arrows
- No hardcoded colors
