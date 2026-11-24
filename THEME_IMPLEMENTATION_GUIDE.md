# Theme Toggle Implementation Guide

## Overview
This implementation adds a theme toggle feature to the View Profile screen, allowing users to switch between Light, Dark, and System themes. The selected theme is properly reflected across the application, specifically in the YourZonesUV class and its TableView.

## Changes Made

### 1. ThemeManager.swift (NEW FILE)
A new singleton class that manages the app's theme preference:

**Features:**
- Three theme options: Light, Dark, and System (follows device settings)
- Persists theme selection using UserDefaults
- Broadcasts theme changes via NotificationCenter
- Provides theme-aware colors for backgrounds, text, separators, and borders
- Handles smooth theme transitions across the app

**Key Methods:**
- `currentTheme`: Get/set the current theme
- `applyTheme(_:)`: Applies the selected theme to the app window
- `isDarkModeActive`: Returns whether dark mode is currently active
- Theme color helpers: `backgroundColor()`, `cardBackgroundColor()`, `textColor()`, etc.

### 2. ViewProfileUV.swift (MODIFIED)
Added theme toggle option and theme support:

**Changes:**
- Added `CHANGE_THEME = "31"` constant for the new menu option
- Added "Theme" option to the Account Settings section (Section 1)
- Implemented `changeThemeTapped()` method that shows an action sheet with three theme options
- Added theme change notification observer in `viewDidLoad()`
- Implemented `applyTheme()` method to update UI when theme changes
- Updated table view background colors to use ThemeManager
- Updated section header colors to use ThemeManager

**Menu Item Details:**
- Title: "Theme" (uses key "LBL_CHANGE_THEME")
- Icon: "ic_pf_theme" (you'll need to add this image asset)
- Position: Account Settings section, after Change Language option

### 3. YourZonesUV.swift (MODIFIED)
Updated to support dark and light modes:

**Changes:**
- Added theme change notification observer in `viewDidLoad()`
- Implemented `applyTheme()` method that updates:
  - View background color
  - Container view background color
  - Table view background color
  - Error label text color
- Updated table header section background to use ThemeManager
- Added `deinit` to remove notification observer

### 4. YourZoneTableViewCell.swift (MODIFIED)
Updated cell to support both dark and light themes:

**Changes:**
- Added theme change notification observer in `awakeFromNib()`
- Implemented `applyTheme()` method that updates:
  - Card view background color
  - Border color
  - Shadow color (white in dark mode, black in light mode)
  - Zone name label text color
  - Cell background color
- Added `deinit` to remove notification observer

### 5. ProfileTVCell.swift (MODIFIED)
Updated profile menu cell to support dark mode:

**Changes:**
- Added theme change notification observer in `awakeFromNib()`
- Implemented `applyTheme()` method that updates:
  - Cell background color
  - Title label text color
  - Icon tint color
  - Arrow icon tint color
- Added `deinit` to remove notification observer

## How It Works

### Theme Selection Flow:
1. User taps "Theme" option in View Profile screen
2. Action sheet appears with three options: Light, Dark, System
3. User selects preferred theme
4. ThemeManager saves preference and applies theme to app window
5. NotificationCenter broadcasts theme change
6. All observing view controllers and cells update their appearance

### Theme Persistence:
- Theme preference is saved to UserDefaults with key "APP_THEME_PREFERENCE"
- On app launch, ThemeManager automatically loads and applies the saved theme
- Default theme is "System" if no preference is saved

### YourZonesUV Theme Support:
When the theme changes:
- Background color updates to match the theme
- Table view cells reload with new colors
- Card backgrounds change appropriately
- Text colors invert for readability
- Borders and separators adjust their colors

## Color Specifications

### Light Mode:
- Background: #f1f1f1 (light gray)
- Card Background: #FFFFFF (white)
- Text: #000000 (black)
- Secondary Text: Dark gray
- Separators: #E5E5EA
- Borders: Light gray

### Dark Mode:
- Background: #1C1C1E (dark gray)
- Card Background: #2C2C2E (medium dark gray)
- Text: #FFFFFF (white)
- Secondary Text: #AAAAAA (light gray)
- Separators: #3A3A3C
- Borders: #3A3A3C

## Required Assets

You need to add the following image asset to your project:
- `ic_pf_theme` - Icon for the Theme menu item (recommended: a sun/moon icon or palette icon)

## Integration Notes

### For Future View Controllers:
To add theme support to any view controller:

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
    // Register for theme changes
    NotificationCenter.default.addObserver(
        self, 
        selector: #selector(themeDidChange), 
        name: ThemeManager.themeDidChangeNotification, 
        object: nil
    )
    
    applyTheme()
}

deinit {
    NotificationCenter.default.removeObserver(self)
}

@objc func themeDidChange() {
    applyTheme()
}

func applyTheme() {
    let themeManager = ThemeManager.shared
    view.backgroundColor = themeManager.backgroundColor()
    // Update other UI elements...
}
```

### For Future Table View Cells:
```swift
override func awakeFromNib() {
    super.awakeFromNib()
    
    NotificationCenter.default.addObserver(
        self, 
        selector: #selector(themeDidChange), 
        name: ThemeManager.themeDidChangeNotification, 
        object: nil
    )
    
    applyTheme()
}

deinit {
    NotificationCenter.default.removeObserver(self)
}

@objc func themeDidChange() {
    applyTheme()
}

func applyTheme() {
    let themeManager = ThemeManager.shared
    backgroundColor = themeManager.cardBackgroundColor()
    // Update other cell elements...
}
```

## Testing Checklist

- [ ] Theme toggle appears in View Profile screen under Account Settings
- [ ] Tapping Theme shows action sheet with Light, Dark, and System options
- [ ] Selecting Light theme changes entire app to light mode
- [ ] Selecting Dark theme changes entire app to dark mode
- [ ] Selecting System theme follows device appearance settings
- [ ] Theme preference persists after app restart
- [ ] YourZonesUV screen updates colors when theme changes
- [ ] Table cells in YourZonesUV display properly in both themes
- [ ] Profile screen menu items display properly in both themes
- [ ] Section headers update colors appropriately
- [ ] No UI glitches or flashing during theme transitions

## Localization Keys

Add these keys to your localization files:

```
LBL_CHANGE_THEME = "Theme"
LBL_SELECT_THEME = "Select your preferred theme"
LBL_THEME_LIGHT = "Light"
LBL_THEME_DARK = "Dark"
LBL_THEME_SYSTEM = "System"
```

## Notes

- The implementation follows the existing code architecture
- No unrelated functionality was modified
- The theme system is similar to how Google Wallet handles dark mode
- All theme changes are smooth and instantaneous
- The system respects RTL (Right-to-Left) layout configurations
- Icon tinting is applied for better visibility in dark mode
