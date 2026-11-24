# Theme Support Updates - Summary

## Overview
This document summarizes the theme-related updates made to support Dark and Light themes across the profile-related view controllers, following the Google Wallet design pattern.

---

## Files Updated

### ✅ 1. **ListOfDocumentUV.swift** 
**Status:** Already had theme support - No changes needed

**Existing Features:**
- Theme change observer registered in `viewDidLoad()`
- `applyTheme()` method updates:
  - View backgrounds
  - TableView background and separator color
  - Cell backgrounds via `cellForRowAt`

---

### ✅ 2. **BankDetailsUV.swift**
**Status:** Already had theme support - No changes needed

**Existing Features:**
- Theme change observer registered in `viewDidLoad()`
- `applyTheme()` method updates:
  - View backgrounds
  - Text field backgrounds (card style)
  - Text colors

---

### ✅ 3. **StaticPageUV.swift**
**Status:** Already had theme support - No changes needed

**Existing Features:**
- Theme change observer registered in `viewDidLoad()`
- `applyTheme()` method updates:
  - View backgrounds
  - WebView background and styling
  - Dynamic CSS injection for dark/light theme content
  - Agree container backgrounds

---

### ✅ 4. **HelpUV.swift**
**Status:** Theme support added ✨

**Changes Made:**

#### 1. Added theme observer registration in `viewDidLoad()`:
```swift
// Register for theme change notifications
NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: ThemeManager.themeDidChangeNotification, object: nil)

// Apply initial theme
applyTheme()
```

#### 2. Added `deinit` to remove observer:
```swift
deinit {
    NotificationCenter.default.removeObserver(self)
}
```

#### 3. Added theme change handler:
```swift
@objc func themeDidChange() {
    applyTheme()
}
```

#### 4. Added `applyTheme()` method:
```swift
func applyTheme() {
    let themeManager = ThemeManager.shared
    
    // Update main view backgrounds
    self.view.backgroundColor = themeManager.backgroundColor()
    self.contentView.backgroundColor = themeManager.backgroundColor()
    
    // Update table view background
    self.tableView.backgroundColor = themeManager.backgroundColor()
    
    // Update separator color (Google Wallet style)
    self.tableView.separatorColor = themeManager.separatorColor()
    
    // Reload table to update cells and headers
    self.tableView.reloadData()
    
    print("✅ HelpUV: Theme applied - Dark mode: \(themeManager.isDarkModeActive)")
}
```

#### 5. Updated `viewDidAppear()` to apply theme:
```swift
override func viewDidAppear(_ animated: Bool) {
    if(isDataLoad == false){
        getFAQData()
        isDataLoad = true
    }
    
    // Apply theme after view appears
    applyTheme()
}
```

#### 6. Updated `tableView(_:viewForHeaderInSection:)` for dynamic theme:
```swift
func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let themeManager = ThemeManager.shared
    
    let view = UIView.init(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 55))
    view.backgroundColor = themeManager.backgroundColor()  // Changed from fixed color
    
    let label = UILabel.init(frame: CGRect(x:15, y:0, width: tableView.frame.size.width - 35, height: 50))
    label.font = UIFont.init(name: Fonts().semibold, size: 17)
    label.numberOfLines = 2
    label.textColor = themeManager.textColor()  // Changed from UIColor.black
    label.text = self.dataArrList[section].get("vTitle")
    view.addSubview(label)
    return view
}
```

#### 7. Updated `tableView(_:cellForRowAt:)` for dynamic theme:
```swift
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCategoryListTVCell", for: indexPath) as! FAQCategoryListTVCell
    let themeManager = ThemeManager.shared

    cell.selectionStyle = .none
    
    // Apply theme-aware backgrounds
    cell.backgroundColor = themeManager.cardBackgroundColor()
    cell.contentView.backgroundColor = themeManager.cardBackgroundColor()

    let itemDict = self.dataArrList[indexPath.section].getArrObj("Questions")[indexPath.row] as! NSDictionary
    cell.titleLbl.text = itemDict.get("vTitle")
    cell.titleLbl.textColor = themeManager.textColor()  // Added

    let rightImage = "ic_arrow_right"
    if(Configurations.isRTLMode()){
        cell.rightArrowImgView.image = UIImage(named:rightImage)?.rotate(180)
    }else{
        cell.rightArrowImgView.image = UIImage(named:rightImage)
    }
    
    // Apply theme-aware arrow color
    let arrowColor = themeManager.isDarkModeActive ? UIColor.white.withAlphaComponent(0.6) : UIColor.lightGray
    GeneralFunctions.setImgTintColor(imgView: cell.rightArrowImgView, color: arrowColor)

    return cell
}
```

---

### ✅ 5. **ContactUsUV.swift**
**Status:** Theme support added ✨

**Changes Made:**

#### 1. Added theme observer registration in `viewDidLoad()`:
```swift
// Register for theme change notifications
NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: ThemeManager.themeDidChangeNotification, object: nil)

// Apply initial theme
applyTheme()
```

#### 2. Added `deinit` to remove observer:
```swift
deinit {
    NotificationCenter.default.removeObserver(self)
}
```

#### 3. Added theme change handler:
```swift
@objc func themeDidChange() {
    applyTheme()
}
```

#### 4. Added comprehensive `applyTheme()` method:
```swift
func applyTheme() {
    let themeManager = ThemeManager.shared
    
    // Update main view backgrounds
    self.view.backgroundColor = themeManager.backgroundColor()
    self.contentView.backgroundColor = themeManager.backgroundColor()
    self.scrollView.backgroundColor = themeManager.backgroundColor()
    
    // Update text view backgrounds (cards in Google Wallet style)
    self.commentTxtView.backgroundColor = themeManager.cardBackgroundColor()
    self.queryTxtView.backgroundColor = themeManager.cardBackgroundColor()
    
    // Update text colors
    self.commentTxtView.textColor = themeManager.textColor()
    self.queryTxtView.textColor = themeManager.textColor()
    
    // Update placeholder colors
    let placeholderColor = themeManager.secondaryTextColor()
    self.commentTxtView.placeholderColor = placeholderColor
    self.queryTxtView.placeholderColor = placeholderColor
    
    // Update border colors based on theme
    let borderColor = themeManager.isDarkModeActive ? UIColor.white.withAlphaComponent(0.3) : UIColor.lightGray
    self.commentTxtView.layer.borderColor = borderColor.cgColor
    self.queryTxtView.layer.borderColor = borderColor.cgColor
    
    // Update label colors
    self.headerTitleLbl.textColor = themeManager.textColor()
    self.headerDescLbl.textColor = themeManager.secondaryTextColor()
    self.headerSubTitleLbl.textColor = themeManager.textColor()
    self.subTitleLbl.textColor = themeManager.textColor()
    
    print("✅ ContactUsUV: Theme applied - Dark mode: \(themeManager.isDarkModeActive)")
}
```

#### 5. Updated `viewDidAppear()` to apply theme:
```swift
override func viewDidAppear(_ animated: Bool) {
    setScrollViewContent()
    
    // Apply theme after view appears
    applyTheme()
}
```

#### 6. Updated `setData()` to remove hardcoded border colors:
- Removed `self.commentTxtView.layer.borderColor = UIColor.lightGray.cgColor`
- Removed `self.queryTxtView.layer.borderColor = UIColor.lightGray.cgColor`
- Border colors now set dynamically in `applyTheme()`

---

## Theme Design Pattern

All implementations follow the **Google Wallet** dark theme design pattern:

### Light Theme:
- Background: White (`#FFFFFF`)
- Card Background: White (`#FFFFFF`)
- Text: Black (`#000000`)
- Secondary Text: Gray (`#808080`)
- Separator: Light Gray (`#E5E5E5`)

### Dark Theme:
- Background: Dark Gray (`#1C1C1E`)
- Card Background: Medium Dark Gray (`#2C2C2E`)
- Text: White (`#FFFFFF`)
- Secondary Text: Light Gray (`#AEAEB2`)
- Separator: Dark Gray with opacity (`#38383A`)

---

## ViewProfileUV Function Updates

The following functions in `ViewProfileUV.swift` now open view controllers with full theme support:

1. ✅ `openBankDetails()` → Opens `BankDetailsUV` (already had theme support)
2. ✅ `openAbout()` → Opens `StaticPageUV` with ID "1" (already had theme support)
3. ✅ `openPrivacy()` → Opens `StaticPageUV` with ID "64" (already had theme support)
4. ✅ `openTerms()` → Opens `StaticPageUV` with ID "63" (already had theme support)
5. ✅ `openHelp()` → Opens `HelpUV` (theme support added ✨)
6. ✅ `openContactUs()` → Opens `ContactUsUV` (theme support added ✨)

---

## Testing Checklist

To verify theme implementation:

- [ ] Navigate to each screen from ViewProfileUV
- [ ] Toggle theme from Settings (Light/Dark)
- [ ] Verify all backgrounds update correctly
- [ ] Verify all text colors update correctly
- [ ] Verify table view separators update correctly
- [ ] Verify card backgrounds update correctly
- [ ] Verify text field/view borders update correctly
- [ ] Verify placeholder text colors update correctly
- [ ] Verify icons/arrows update correctly
- [ ] Verify WebView content (StaticPageUV) updates correctly
- [ ] Verify no hardcoded colors remain
- [ ] Verify smooth transitions between themes

---

## Key Implementation Notes

1. **No Business Logic Changes:** Only visual theme-related updates were made
2. **Observer Pattern:** All view controllers register for `ThemeManager.themeDidChangeNotification`
3. **Memory Management:** All view controllers properly remove observers in `deinit`
4. **Immediate Application:** Theme applied in `viewDidLoad()` and `viewDidAppear()`
5. **Dynamic Updates:** `applyTheme()` called when theme changes
6. **Cell Reuse:** TableView cells update in `cellForRowAt` using current theme
7. **Section Headers:** Custom headers update using current theme
8. **Consistency:** All implementations follow the same pattern

---

## Dependencies

All updates rely on the existing `ThemeManager` class which provides:

- `ThemeManager.shared` - Singleton instance
- `currentTheme` - Current theme (light/dark)
- `isDarkModeActive` - Boolean for dark mode state
- `backgroundColor()` - Main background color
- `cardBackgroundColor()` - Card/container background color
- `textColor()` - Primary text color
- `secondaryTextColor()` - Secondary text color
- `separatorColor()` - Separator line color
- `themeDidChangeNotification` - Notification posted on theme change

---

## Result

All profile-related screens now fully support both Light and Dark themes with:
- ✅ Proper background colors
- ✅ Proper text colors
- ✅ Proper card/container backgrounds
- ✅ Proper separator colors
- ✅ Proper border colors
- ✅ Proper placeholder colors
- ✅ Proper icon colors
- ✅ Dynamic theme switching
- ✅ Google Wallet design consistency
- ✅ No business logic changes
