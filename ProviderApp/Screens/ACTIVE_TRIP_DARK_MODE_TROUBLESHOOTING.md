# Dark Mode Troubleshooting - ActiveTripUV

## Issue: Dark mode not reflecting on ActiveTripUV

This guide helps diagnose and fix common issues when dark mode doesn't work.

---

## 🔍 Common Issues and Solutions

### Issue 1: No `applyTheme()` Implementation

**Symptoms:**
- Nothing changes when switching themes
- UI stays in light mode even when dark mode is enabled

**Solution:**
Add the `applyTheme()` method to your view controller:

```swift
func applyTheme() {
    let themeManager = ThemeManager.shared
    
    // 1. Main backgrounds
    self.view.backgroundColor = themeManager.backgroundColor()
    self.contentView?.backgroundColor = themeManager.backgroundColor()
    self.googleMapContainerView?.backgroundColor = themeManager.backgroundColor()
    
    // 2. Map style
    if self.gMapView != nil {
        if themeManager.isDarkModeActive {
            self.gMapView.nightMapStyle()
        } else {
            self.gMapView.mapStyle = nil
        }
    }
    
    // 3. Bottom card/details view
    if themeManager.isDarkModeActive {
        self.bottomDetailsView?.backgroundColor = themeManager.cardBackgroundColor()
        self.bottomDetailsView?.layer.shadowColor = UIColor.black.cgColor
        self.bottomDetailsView?.layer.shadowOpacity = 0.6
        self.bottomDetailsView?.layer.shadowRadius = 8
        self.bottomDetailsView?.layer.shadowOffset = CGSize(width: 0, height: -2)
        self.bottomDetailsView?.layer.borderColor = themeManager.borderColor().cgColor
        self.bottomDetailsView?.layer.borderWidth = 0.5
    } else {
        self.bottomDetailsView?.backgroundColor = UIColor.white
        self.bottomDetailsView?.layer.shadowColor = UIColor.lightGray.cgColor
        self.bottomDetailsView?.layer.shadowOpacity = 0.9
        self.bottomDetailsView?.layer.shadowRadius = 3
        self.bottomDetailsView?.layer.shadowOffset = CGSize.zero
        self.bottomDetailsView?.layer.borderWidth = 0
    }
    
    // 4. Text colors
    // Replace these with your actual label names
    self.yourPrimaryLabel?.textColor = themeManager.textColor()
    self.yourSecondaryLabel?.textColor = themeManager.secondaryTextColor()
    
    print("✅ ActiveTripUV: Theme applied - Dark mode: \(themeManager.isDarkModeActive)")
}
```

---

### Issue 2: Not Registered for Theme Change Notifications

**Symptoms:**
- Initial load works but theme doesn't change when switching
- Must restart app to see theme changes

**Solution:**
Add this in `viewDidLoad()`:

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
    // ... your existing code ...
    
    // ADD THIS:
    NotificationCenter.default.addObserver(
        self, 
        selector: #selector(themeDidChange), 
        name: ThemeManager.themeDidChangeNotification, 
        object: nil
    )
    
    // ... rest of setup ...
    
    // Apply initial theme (should be near the end)
    applyTheme()
}
```

---

### Issue 3: Missing `themeDidChange()` Handler

**Symptoms:**
- Same as Issue 2

**Solution:**
Add this method:

```swift
@objc func themeDidChange() {
    applyTheme()
}
```

---

### Issue 4: `applyTheme()` Not Called on Initial Load

**Symptoms:**
- Dark mode works when switching but not on initial launch
- Must switch themes back and forth to see effect

**Solution:**
Add `applyTheme()` at the end of `viewDidLoad()`:

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
    // ... all your setup code ...
    
    // ADD THIS at the very end:
    applyTheme()
}
```

---

### Issue 5: Map Style Not Updating

**Symptoms:**
- UI elements theme correctly but map stays light/dark

**Solution:**

**Option A: Update in `applyTheme()`**
```swift
func applyTheme() {
    let themeManager = ThemeManager.shared
    
    // ... other theming ...
    
    // ADD THIS:
    if self.gMapView != nil {
        if themeManager.isDarkModeActive {
            self.gMapView.nightMapStyle()
        } else {
            self.gMapView.mapStyle = nil
        }
    }
}
```

**Option B: Update map initialization**
Find where you initialize the map (usually in `viewDidAppear`) and replace:

```swift
// ❌ Remove time-based logic:
if(GeneralFunctions.getDayNightForToday().uppercased() == "NIGHT"){
    self.gMapView.nightMapStyle()
} else {
    self.gMapView.mapStyle = nil
}
```

```swift
// ✅ Use theme-based logic:
let themeManager = ThemeManager.shared
if themeManager.isDarkModeActive {
    self.gMapView.nightMapStyle()
} else {
    self.gMapView.mapStyle = nil
}
```

---

### Issue 6: Hardcoded Colors Overriding Theme

**Symptoms:**
- Some elements stay the same color regardless of theme
- Specific views or labels don't change

**Common Culprits:**

```swift
// ❌ These override theme colors:
view.backgroundColor = UIColor.white
label.textColor = UIColor.black
view.backgroundColor = UIColor(hex: 0xFFFFFF)
```

**Solution:**
Replace with theme colors:

```swift
// ✅ Use theme colors:
view.backgroundColor = ThemeManager.shared.backgroundColor()
label.textColor = ThemeManager.shared.textColor()
view.backgroundColor = ThemeManager.shared.cardBackgroundColor()
```

---

### Issue 7: Colors Set in Storyboard/XIB

**Symptoms:**
- Elements stay one color even with proper code
- Interface Builder overriding theme

**Solution:**
In `applyTheme()`, explicitly set colors even if they're set in IB:

```swift
func applyTheme() {
    let themeManager = ThemeManager.shared
    
    // Force override IB colors
    self.view.backgroundColor = themeManager.backgroundColor()
    self.yourLabel.textColor = themeManager.textColor()
    self.yourView.backgroundColor = themeManager.cardBackgroundColor()
    
    // ... rest of theme application ...
}
```

---

### Issue 8: Views Created After `applyTheme()` Called

**Symptoms:**
- Some views theme correctly, others don't
- Dynamically created views stay in light mode

**Solution:**
Call `applyTheme()` after creating dynamic views:

```swift
func showPopup() {
    // Create view
    let popup = MyPopupView()
    self.view.addSubview(popup)
    
    // ADD THIS: Apply theme to new view
    let themeManager = ThemeManager.shared
    popup.backgroundColor = themeManager.cardBackgroundColor()
    
    // Or call applyTheme() if it handles this view
    applyTheme()
}
```

---

### Issue 9: Missing `deinit` Cleanup

**Symptoms:**
- Memory warnings
- Notifications fire on deallocated objects

**Solution:**
Add proper cleanup:

```swift
deinit {
    NotificationCenter.default.removeObserver(
        self, 
        name: ThemeManager.themeDidChangeNotification, 
        object: nil
    )
    // ... your other cleanup ...
}
```

---

## 🔧 Quick Diagnostic Steps

### Step 1: Check if ThemeManager works
Add this temporarily in `viewDidLoad()`:

```swift
let themeManager = ThemeManager.shared
print("🔍 Theme Manager Status:")
print("   - Current theme: \(themeManager.currentTheme)")
print("   - Is dark: \(themeManager.isDarkModeActive)")
print("   - Background color: \(themeManager.backgroundColor())")
```

**Expected output:**
```
🔍 Theme Manager Status:
   - Current theme: dark (or light)
   - Is dark: true (or false)
   - Background color: UIExtendedSRGBColorSpace ...
```

---

### Step 2: Check if `applyTheme()` is called
Add print statement:

```swift
func applyTheme() {
    print("🎨 applyTheme() called at \(Date())")
    
    let themeManager = ThemeManager.shared
    // ... rest of method ...
}
```

**Expected output:**
- Once when view loads
- Again whenever theme changes

---

### Step 3: Check if notification is received
Add this:

```swift
@objc func themeDidChange() {
    print("📢 Theme change notification received")
    applyTheme()
}
```

**Expected output:**
- Printed whenever you switch themes

---

### Step 4: Verify view references exist
Add this in `applyTheme()`:

```swift
func applyTheme() {
    print("📋 View status:")
    print("   - view: \(self.view != nil)")
    print("   - contentView: \(self.contentView != nil)")
    print("   - gMapView: \(self.gMapView != nil)")
    print("   - bottomDetailsView: \(self.bottomDetailsView != nil)")
    
    // ... rest of method ...
}
```

**Expected output:**
All should be `true` (or at least the views that exist)

---

## 🎯 Minimal Working Implementation

If nothing works, start fresh with this minimal implementation:

```swift
class ActiveTripUV: UIViewController {
    
    // ... your properties and outlets ...
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register for theme changes
        NotificationCenter.default.addObserver(
            self, 
            selector: #selector(themeDidChange), 
            name: ThemeManager.themeDidChangeNotification, 
            object: nil
        )
        
        // ... your existing setup ...
        
        // Apply theme at the end
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
        
        print("✅ Applying theme - Dark mode: \(themeManager.isDarkModeActive)")
        
        // Start with just the main view
        self.view.backgroundColor = themeManager.isDarkModeActive ? 
            UIColor(hex: 0x1C1C1E) : UIColor(hex: 0xf1f1f1)
        
        // Once this works, add more elements
    }
}
```

**Test:**
1. Run the app
2. Check console for "✅ Applying theme" message
3. Background should change
4. If this works, gradually add more elements

---

## 📝 Checklist for Full Implementation

Use this to ensure everything is in place:

- [ ] `ThemeManager.shared` is accessible
- [ ] `applyTheme()` method exists
- [ ] `themeDidChange()` handler exists
- [ ] Registered for notifications in `viewDidLoad()`
- [ ] `applyTheme()` called at end of `viewDidLoad()`
- [ ] `deinit` removes observer
- [ ] No hardcoded colors override theme
- [ ] Map style updated with theme
- [ ] All text labels use theme colors
- [ ] All backgrounds use theme colors
- [ ] Console shows theme applied message
- [ ] Console shows notification received message

---

## 🆘 Still Not Working?

If you've tried everything above and it still doesn't work:

### Share This Information:

1. **Console output** when app launches
2. **Console output** when switching themes
3. **Your `viewDidLoad()` method**
4. **Your `applyTheme()` method** (if exists)
5. **Any error messages**

### Quick Test:

Add this single line to `viewDidLoad()`:

```swift
self.view.backgroundColor = ThemeManager.shared.isDarkModeActive ? .black : .white
```

If this works → Your theme system is fine, issue is in `applyTheme()`
If this doesn't work → ThemeManager might not be initialized

---

## 💡 Most Common Solution

**90% of the time, the issue is one of these:**

1. ✅ **Missing `applyTheme()` call in `viewDidLoad()`**
2. ✅ **Not registered for theme change notifications**
3. ✅ **Hardcoded colors overriding theme**
4. ✅ **Map style not updated**

**Quick fix template:**

```swift
// Add to viewDidLoad():
NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: ThemeManager.themeDidChangeNotification, object: nil)
applyTheme()

// Add this method:
@objc func themeDidChange() {
    applyTheme()
}

// Add this method:
func applyTheme() {
    let themeManager = ThemeManager.shared
    self.view.backgroundColor = themeManager.backgroundColor()
    if self.gMapView != nil {
        if themeManager.isDarkModeActive {
            self.gMapView.nightMapStyle()
        } else {
            self.gMapView.mapStyle = nil
        }
    }
}
```

---

## 📞 Need the Actual Fix?

To provide the exact fix for your ActiveTripUV, I need to see:

1. The **ActiveTripUV.swift file content** (paste it in the chat)
2. Or tell me the **exact file name** if different

Then I can provide the precise implementation like I did for DriverArrivedUV.

---

**Last Updated:** November 26, 2026
**Status:** Troubleshooting Guide
