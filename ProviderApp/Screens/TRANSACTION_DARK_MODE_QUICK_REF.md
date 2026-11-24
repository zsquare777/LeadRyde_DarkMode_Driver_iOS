# Transaction Screen Dark Mode - Developer Quick Reference

## Quick Implementation Summary

The Transaction screen (`ManageWalletUV.swift`) has been updated to fully support dark mode. Here's what you need to know:

---

## What Changed

### ✅ Enhanced Methods

1. **`applyTheme()`** - Expanded to cover all UI elements
2. **`sendMoneyInitialize()`** - Applies theme to Send Money popup
3. **`goPayMoneyEnterSetup()`** - Maintains theme during transfer flow
4. **`openGoPayAlertViewWith()`** - Themes all alert views
5. **`cellForRowAt`** - Already themed (no changes needed)

### ✅ New Functionality

- Dynamic theme switching without restart
- Proper popup theming on load
- Alert views with theme-aware colors
- Activity indicators adapted for visibility

---

## Code Patterns Used

### Pattern 1: Get ThemeManager Instance

```swift
let themeManager = ThemeManager.shared
```

### Pattern 2: Check Theme Mode

```swift
if themeManager.isDarkModeActive {
    // Dark mode specific code
} else {
    // Light mode specific code
}
```

### Pattern 3: Apply Background Colors

```swift
view.backgroundColor = themeManager.backgroundColor()           // Main backgrounds
view.backgroundColor = themeManager.cardBackgroundColor()       // Card backgrounds
```

### Pattern 4: Apply Text Colors

```swift
label.textColor = themeManager.textColor()                      // Primary text
label.textColor = themeManager.secondaryTextColor()             // Secondary text
```

### Pattern 5: Apply Borders & Separators

```swift
view.layer.borderColor = themeManager.borderColor().cgColor
tableView.separatorColor = themeManager.separatorColor()
```

### Pattern 6: Conditional Styling

```swift
// Use this pattern when dark/light need different values
view.backgroundColor = themeManager.isDarkModeActive ? 
    themeManager.backgroundColor() : UIColor.white

// Shadow adaptation
if themeManager.isDarkModeActive {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.3
} else {
    layer.shadowColor = UIColor.lightGray.cgColor
    layer.shadowOpacity = 0.5
}
```

---

## Common Use Cases

### Use Case 1: Theme a New Popup

```swift
func showMyPopup() {
    let popup = loadView(nibName: "MyPopup", ...)
    
    // Apply theme immediately after loading
    let themeManager = ThemeManager.shared
    popup.backgroundColor = themeManager.isDarkModeActive ? 
        themeManager.backgroundColor() : UIColor.white
    
    // Theme subviews
    titleLabel.textColor = themeManager.textColor()
    subtitleLabel.textColor = themeManager.secondaryTextColor()
    inputField.textColor = themeManager.textColor()
    inputField.backgroundColor = themeManager.cardBackgroundColor()
    
    // Show popup
    // ...
}
```

### Use Case 2: Theme a Table View Cell

```swift
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(...)
    let themeManager = ThemeManager.shared
    
    // Cell backgrounds
    cell.backgroundColor = themeManager.backgroundColor()
    cell.contentView.backgroundColor = themeManager.backgroundColor()
    cell.containerView.backgroundColor = themeManager.cardBackgroundColor()
    
    // Text colors
    cell.titleLabel.textColor = themeManager.textColor()
    cell.subtitleLabel.textColor = themeManager.secondaryTextColor()
    
    // Adapt shadows for dark mode
    if themeManager.isDarkModeActive {
        cell.containerView.layer.shadowOpacity = 0.3
    } else {
        cell.containerView.layer.shadowOpacity = 0.5
    }
    
    return cell
}
```

### Use Case 3: Theme an Alert View

```swift
func showAlert() {
    let themeManager = ThemeManager.shared
    
    alertView.backgroundColor = themeManager.isDarkModeActive ? 
        themeManager.cardBackgroundColor() : UIColor.white
    
    alertBackgroundOverlay.backgroundColor = themeManager.isDarkModeActive ? 
        UIColor.black.withAlphaComponent(0.7) : 
        UIColor.black.withAlphaComponent(0.5)
    
    alertTitleLabel.textColor = themeManager.textColor()
    alertMessageLabel.textColor = themeManager.secondaryTextColor()
}
```

### Use Case 4: Theme Text Fields

```swift
func setupTextField() {
    let themeManager = ThemeManager.shared
    
    textField.textColor = themeManager.textColor()
    textField.backgroundColor = themeManager.cardBackgroundColor()
    
    textFieldContainer.backgroundColor = themeManager.cardBackgroundColor()
    textFieldContainer.layer.borderColor = themeManager.borderColor().cgColor
    textFieldContainer.layer.borderWidth = 1.0
}
```

### Use Case 5: Error Text Colors

```swift
func showError() {
    let themeManager = ThemeManager.shared
    
    // Error text with better visibility in dark mode
    errorLabel.textColor = themeManager.isDarkModeActive ? 
        UIColor(hex: 0xFF6B6B) : UIColor.red
}
```

---

## Available ThemeManager Colors

```swift
// Backgrounds
themeManager.backgroundColor()          // #1C1C1E (dark) / #f1f1f1 (light)
themeManager.cardBackgroundColor()      // #2C2C2E (dark) / #EDEDED (light)

// Text
themeManager.textColor()                // #EDEDED (dark) / Black (light)
themeManager.secondaryTextColor()       // #AAAAAA (dark) / Dark Gray (light)

// UI Elements
themeManager.separatorColor()           // #3A3A3C (dark) / #E5E5EA (light)
themeManager.borderColor()              // #3A3A3C (dark) / Light Gray (light)

// State
themeManager.isDarkModeActive           // Bool - true if dark mode
```

---

## Colors to PRESERVE (Don't Theme)

These should remain the same in both themes:

```swift
// ❌ DON'T theme these:
UIColor.UCAColor.AppThemeColor              // App theme color
UIColor.UCAColor.AppThemeTxtColor           // App theme text
UIColor.UCAColor.AppThemeTxtColor_1         // Branded colors
UIColor(hex: 0x56a031)                      // Credit indicator (green)
UIColor(hex: 0xb22316)                      // Debit indicator (red)

// ✅ DO theme these:
UIColor.black                               // Replace with textColor()
UIColor.white                               // Replace with cardBackgroundColor()
UIColor.darkGray                            // Replace with secondaryTextColor()
UIColor.lightGray                           // Replace with borderColor()
```

---

## Registration Pattern

Every view controller that supports dark mode should:

### 1. Register for theme changes in viewDidLoad:

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
    // ... other setup code ...
    
    // Register for theme changes
    NotificationCenter.default.addObserver(
        self, 
        selector: #selector(themeDidChange), 
        name: ThemeManager.themeDidChangeNotification, 
        object: nil
    )
    
    // Apply initial theme
    applyTheme()
}
```

### 2. Clean up in deinit:

```swift
deinit {
    NotificationCenter.default.removeObserver(self)
}
```

### 3. Implement theme change handler:

```swift
@objc func themeDidChange() {
    applyTheme()
}
```

### 4. Implement applyTheme method:

```swift
func applyTheme() {
    let themeManager = ThemeManager.shared
    
    // Apply theme to all UI elements
    // See examples above
    
    // Reload data if needed
    tableView?.reloadData()
}
```

---

## Common Mistakes to Avoid

### ❌ Mistake 1: Setting Colors in viewDidLoad Only

```swift
// ❌ BAD - Only applies on first load
override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = ThemeManager.shared.backgroundColor()
}
```

```swift
// ✅ GOOD - Reapplies when theme changes
override func viewDidLoad() {
    super.viewDidLoad()
    applyTheme()
}

func applyTheme() {
    view.backgroundColor = ThemeManager.shared.backgroundColor()
}
```

### ❌ Mistake 2: Not Themeing Dynamically Loaded Views

```swift
// ❌ BAD - Popup uses stale colors
func showPopup() {
    let popup = loadView(...)
    present(popup, animated: true)
}
```

```swift
// ✅ GOOD - Apply theme before showing
func showPopup() {
    let popup = loadView(...)
    
    let themeManager = ThemeManager.shared
    popup.backgroundColor = themeManager.backgroundColor()
    // ... theme other elements ...
    
    present(popup, animated: true)
}
```

### ❌ Mistake 3: Hardcoding Colors

```swift
// ❌ BAD
label.textColor = UIColor.black
view.backgroundColor = UIColor(hex: 0xf1f1f1)
```

```swift
// ✅ GOOD
label.textColor = themeManager.textColor()
view.backgroundColor = themeManager.backgroundColor()
```

### ❌ Mistake 4: Forgetting to Reload Data

```swift
// ❌ BAD - Cells keep old colors
func applyTheme() {
    view.backgroundColor = themeManager.backgroundColor()
}
```

```swift
// ✅ GOOD - Reload cells to update colors
func applyTheme() {
    view.backgroundColor = themeManager.backgroundColor()
    tableView?.reloadData()
}
```

---

## Testing Checklist

When adding dark mode to a screen, test:

- [ ] Initial load in light mode
- [ ] Initial load in dark mode
- [ ] Switch from light to dark (live)
- [ ] Switch from dark to light (live)
- [ ] All text is readable
- [ ] All input fields are visible
- [ ] All buttons are visible
- [ ] All popups/alerts theme correctly
- [ ] Table/collection view cells update
- [ ] Loading indicators are visible
- [ ] Icons have proper contrast
- [ ] Shadows/separators are visible
- [ ] No white/black "flashes" during transitions

---

## Performance Tips

1. **Cache ThemeManager instance:**
   ```swift
   let themeManager = ThemeManager.shared  // Once per method
   // Use themeManager multiple times
   ```

2. **Batch UI updates:**
   ```swift
   UIView.performWithoutAnimation {
       applyTheme()
   }
   ```

3. **Don't over-reload:**
   ```swift
   // ❌ BAD
   func applyTheme() {
       tableView.reloadData()
       collectionView.reloadData()
       tableView.reloadData()  // Duplicate!
   }
   
   // ✅ GOOD
   func applyTheme() {
       tableView.reloadData()
       collectionView.reloadData()
   }
   ```

---

## Debugging Tips

### Issue: Colors not updating

**Check:**
1. Is observer registered?
2. Is `applyTheme()` called in `themeDidChange()`?
3. Is `deinit` removing observer (potential memory leak)?

### Issue: Some elements stay the wrong color

**Check:**
1. Are you applying theme to that specific element in `applyTheme()`?
2. Is element created after `applyTheme()` runs?
3. Add theme application after element creation

### Issue: Table cells have wrong colors

**Check:**
1. Is `tableView.reloadData()` called in `applyTheme()`?
2. Are cells applying theme in `cellForRowAt`?
3. Is cell background opaque (hides theme)?

### Issue: Popups/alerts have wrong colors

**Check:**
1. Are you applying theme immediately after loading popup?
2. Is popup view hierarchy using correct backgrounds?

---

## Example: Full Implementation

```swift
class MyViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: MyLabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup UI
        setupUI()
        
        // Register for theme changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeDidChange),
            name: ThemeManager.themeDidChangeNotification,
            object: nil
        )
        
        // Apply initial theme
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
        
        // Main backgrounds
        self.view.backgroundColor = themeManager.backgroundColor()
        self.containerView.backgroundColor = themeManager.cardBackgroundColor()
        
        // Text
        self.titleLabel.textColor = themeManager.textColor()
        
        // Table
        self.tableView.backgroundColor = themeManager.backgroundColor()
        self.tableView.separatorColor = themeManager.separatorColor()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let themeManager = ThemeManager.shared
        
        cell.backgroundColor = themeManager.backgroundColor()
        cell.textLabel?.textColor = themeManager.textColor()
        
        return cell
    }
}
```

---

## Resources

- **ThemeManager.swift**: Core theme management
- **ManageWalletUV.swift**: Reference implementation
- **TRANSACTION_DARK_MODE_UPDATE.md**: Complete documentation
- **TRANSACTION_DARK_MODE_VISUAL_GUIDE.md**: Visual reference

---

## Need Help?

Common questions:

**Q: What color should I use for X?**
A: Refer to the "Available ThemeManager Colors" section above

**Q: Should I theme brand colors?**
A: No, keep branded colors (theme color, indicators) the same

**Q: How do I theme a custom component?**
A: Follow Pattern 1-6 above, apply in `applyTheme()`

**Q: Theme not updating live?**
A: Check observer registration and `applyTheme()` implementation

**Q: Can I test without building?**
A: Use the Theme toggle in app settings to test live

---

**Last Updated:** November 21, 2026
**Implementation Status:** ✅ Complete
