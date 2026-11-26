# Dark Mode Implementation Guide for ActiveTripUV

This guide provides step-by-step instructions to implement dark mode in ActiveTripUV (or any trip-related screen) following the exact patterns used in DriverArrivedUV.

---

## 📋 Implementation Checklist

- [ ] Register for theme change notifications in `viewDidLoad()`
- [ ] Add `themeDidChange()` handler
- [ ] Implement `applyTheme()` method
- [ ] Update map initialization with theme-based styling
- [ ] Update `setData()` or initialization methods with theme-aware styling
- [ ] Clean up notifications in `deinit`
- [ ] Apply initial theme on load

---

## 🔧 Step-by-Step Implementation

### Step 1: Register for Theme Changes in `viewDidLoad()`

Add this in your `viewDidLoad()` method, **before** calling `applyTheme()`:

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
    // ... your existing code ...
    
    // Register for theme change notifications
    NotificationCenter.default.addObserver(
        self, 
        selector: #selector(themeDidChange), 
        name: ThemeManager.themeDidChangeNotification, 
        object: nil
    )
    
    // ... other setup code ...
    
    // Apply initial theme (should be last in viewDidLoad)
    applyTheme()
}
```

---

### Step 2: Add Theme Change Handler

Add this method to your view controller:

```swift
@objc func themeDidChange() {
    applyTheme()
}
```

---

### Step 3: Clean Up in `deinit`

Add or update your `deinit` method:

```swift
deinit {
    NotificationCenter.default.removeObserver(
        self, 
        name: ThemeManager.themeDidChangeNotification, 
        object: nil
    )
    // ... your existing cleanup code ...
}
```

---

### Step 4: Update Map Initialization

Find where your `GMSMapView` is initialized (usually in `viewDidAppear` or similar) and replace the day/night logic:

**❌ Replace this:**
```swift
gMapView = GMSMapView.map(withFrame: self.googleMapContainerView.frame, camera: camera)
if(GeneralFunctions.getDayNightForToday().uppercased() == "NIGHT"){
    self.gMapView.nightMapStyle()
} else {
    self.gMapView.mapStyle = nil
}
```

**✅ With this:**
```swift
gMapView = GMSMapView.map(withFrame: self.googleMapContainerView.frame, camera: camera)

// Apply dark/light map style based on theme
let themeManager = ThemeManager.shared
if themeManager.isDarkModeActive {
    self.gMapView.nightMapStyle()
} else {
    self.gMapView.mapStyle = nil
}
```

---

### Step 5: Implement Complete `applyTheme()` Method

Add this comprehensive method to your view controller. Customize the outlet names to match your actual IBOutlets:

```swift
func applyTheme() {
    let themeManager = ThemeManager.shared
    
    // 1. Main backgrounds
    self.view.backgroundColor = themeManager.backgroundColor()
    self.contentView?.backgroundColor = themeManager.backgroundColor()
    self.googleMapContainerView?.backgroundColor = themeManager.backgroundColor()
    
    // 2. Apply map style based on theme (if map exists)
    if self.gMapView != nil {
        if themeManager.isDarkModeActive {
            self.gMapView.nightMapStyle()
        } else {
            self.gMapView.mapStyle = nil
        }
    }
    
    // 3. Bottom details/info card - Google Wallet-inspired dark styling
    if themeManager.isDarkModeActive {
        // Dark mode: Use dark card background with subtle border
        self.bottomDetailsView?.backgroundColor = themeManager.cardBackgroundColor()
        self.bottomDetailsView?.layer.shadowColor = UIColor.black.cgColor
        self.bottomDetailsView?.layer.shadowOpacity = 0.6
        self.bottomDetailsView?.layer.shadowRadius = 8
        self.bottomDetailsView?.layer.shadowOffset = CGSize(width: 0, height: -2)
        
        // Add subtle border for depth
        self.bottomDetailsView?.layer.borderColor = themeManager.borderColor().cgColor
        self.bottomDetailsView?.layer.borderWidth = 0.5
    } else {
        // Light mode: Keep white background with light shadow
        self.bottomDetailsView?.backgroundColor = UIColor.white
        self.bottomDetailsView?.layer.shadowColor = UIColor.lightGray.cgColor
        self.bottomDetailsView?.layer.shadowOpacity = 0.9
        self.bottomDetailsView?.layer.shadowRadius = 3
        self.bottomDetailsView?.layer.shadowOffset = CGSize.zero
        
        // Remove border in light mode
        self.bottomDetailsView?.layer.borderWidth = 0
    }
    
    // 4. Text labels - Primary text
    self.destinationLbl?.textColor = themeManager.textColor()
    self.userNameLbl?.textColor = themeManager.textColor()
    self.tripStatusLbl?.textColor = themeManager.textColor()
    // Add your other primary text labels here
    
    // 5. Text labels - Secondary text
    self.timeLbl?.textColor = themeManager.secondaryTextColor()
    self.distanceLbl?.textColor = themeManager.secondaryTextColor()
    self.fareLbl?.textColor = themeManager.secondaryTextColor()
    // Add your other secondary text labels here
    
    // 6. Card/Container views (if any)
    if self.tripInfoCardView != nil {
        self.tripInfoCardView?.backgroundColor = themeManager.isDarkModeActive ? 
            themeManager.cardBackgroundColor() : UIColor.white
        
        // Add border in dark mode
        if themeManager.isDarkModeActive {
            self.tripInfoCardView?.layer.borderColor = themeManager.borderColor().cgColor
            self.tripInfoCardView?.layer.borderWidth = 0.5
        } else {
            self.tripInfoCardView?.layer.borderWidth = 0
        }
    }
    
    // 7. Top navigation/header views (if present)
    if self.topNavigationView != nil {
        // Keep the app theme color but adjust shadow
        self.topNavigationView?.navContaintView?.layer.shadowColor = themeManager.isDarkModeActive ? 
            UIColor.black.cgColor : UIColor.lightGray.cgColor
        self.topNavigationView?.navContaintView?.layer.shadowOpacity = themeManager.isDarkModeActive ? 0.8 : 0.6
    }
    
    // 8. Modal/Popup views (if any)
    if self.modalView != nil {
        self.modalView?.backgroundColor = themeManager.isDarkModeActive ? 
            themeManager.cardBackgroundColor() : UIColor.white
        
        if themeManager.isDarkModeActive {
            self.modalView?.layer.borderColor = themeManager.borderColor().cgColor
            self.modalView?.layer.borderWidth = 0.5
        } else {
            self.modalView?.layer.borderWidth = 0
        }
    }
    
    // 9. Semi-transparent overlays (if any)
    if self.overlayView != nil {
        self.overlayView?.backgroundColor = themeManager.isDarkModeActive ? 
            UIColor.black.withAlphaComponent(0.7) : 
            UIColor.black.withAlphaComponent(0.5)
    }
    
    // 10. Icon tints (for icons that need to adapt)
    if themeManager.isDarkModeActive {
        // Set to white for better visibility in dark mode
        GeneralFunctions.setImgTintColor(imgView: self.detailsIconImgView, color: UIColor.white)
    } else {
        // Use app theme color in light mode
        GeneralFunctions.setImgTintColor(imgView: self.detailsIconImgView, color: UIColor.UCAColor.AppThemeTxtColor)
    }
    
    // 11. DON'T theme these (they use brand colors):
    // - self.callView
    // - self.chatView
    // - self.navigationView
    // - Action buttons with brand colors
    
    print("✅ ActiveTripUV: Theme applied - Dark mode: \(themeManager.isDarkModeActive)")
}
```

---

### Step 6: Update Initial Styling in Setup Methods

Find where you initially set up your UI (usually in `setData()`, `viewDidAppear()`, or similar) and add theme-aware styling:

**Example for bottom card/details view:**

```swift
func setData() {
    // ... your existing code ...
    
    let themeManager = ThemeManager.shared
    
    // Apply theme-aware shadow styling
    if themeManager.isDarkModeActive {
        self.bottomDetailsView.layer.addShadow(opacity: 0.6, radius: 8, UIColor.black)
        self.bottomDetailsView.layer.borderColor = themeManager.borderColor().cgColor
        self.bottomDetailsView.layer.borderWidth = 0.5
    } else {
        self.bottomDetailsView.layer.addShadow(opacity: 0.9, radius: 3, UIColor.lightGray)
        self.bottomDetailsView.layer.borderWidth = 0
    }
    self.bottomDetailsView.layer.roundCorners(radius: 15)
    
    // ... rest of your setup ...
}
```

**Example for action buttons (keep branded colors):**

```swift
// These should NOT be themed - they use brand colors
self.callView.backgroundColor = UIColor.UCAColor.CallImageBGColor
self.chatView.backgroundColor = UIColor.UCAColor.ChatImageBGColor
self.navigationView.backgroundColor = UIColor.UCAColor.NavigateImageBGColor

// Icons on colored backgrounds always stay white
GeneralFunctions.setImgTintColor(imgView: self.callImgView, color: UIColor.white)
GeneralFunctions.setImgTintColor(imgView: self.chatImgView, color: UIColor.white)
GeneralFunctions.setImgTintColor(imgView: self.navigationImgView, color: UIColor.white)
```

---

## 🎨 Common UI Elements and Their Theming

### Bottom Card/Details View
```swift
// Dark mode
view.backgroundColor = themeManager.cardBackgroundColor()
view.layer.borderColor = themeManager.borderColor().cgColor
view.layer.borderWidth = 0.5
view.layer.shadowColor = UIColor.black.cgColor
view.layer.shadowOpacity = 0.6
view.layer.shadowRadius = 8

// Light mode
view.backgroundColor = UIColor.white
view.layer.borderWidth = 0
view.layer.shadowColor = UIColor.lightGray.cgColor
view.layer.shadowOpacity = 0.9
view.layer.shadowRadius = 3
```

### Text Labels
```swift
// Primary text (names, titles, main info)
label.textColor = themeManager.textColor()

// Secondary text (time, distance, additional info)
label.textColor = themeManager.secondaryTextColor()
```

### Cards and Containers
```swift
containerView.backgroundColor = themeManager.isDarkModeActive ? 
    themeManager.cardBackgroundColor() : UIColor.white

if themeManager.isDarkModeActive {
    containerView.layer.borderColor = themeManager.borderColor().cgColor
    containerView.layer.borderWidth = 0.5
} else {
    containerView.layer.borderWidth = 0
}
```

### Modals and Popups
```swift
// Background
modalView.backgroundColor = themeManager.isDarkModeActive ? 
    themeManager.cardBackgroundColor() : UIColor.white

// Overlay
overlayView.backgroundColor = themeManager.isDarkModeActive ? 
    UIColor.black.withAlphaComponent(0.7) : 
    UIColor.black.withAlphaComponent(0.5)

// Border
if themeManager.isDarkModeActive {
    modalView.layer.borderColor = themeManager.borderColor().cgColor
    modalView.layer.borderWidth = 0.5
}
```

---

## 🎯 Outlet Name Mapping

Replace these generic names with your actual IBOutlet names:

| Generic Name | Your Outlet Name |
|--------------|------------------|
| `bottomDetailsView` | ? |
| `destinationLbl` | ? |
| `userNameLbl` | ? |
| `tripStatusLbl` | ? |
| `timeLbl` | ? |
| `distanceLbl` | ? |
| `fareLbl` | ? |
| `tripInfoCardView` | ? |
| `topNavigationView` | ? |
| `modalView` | ? |
| `overlayView` | ? |
| `detailsIconImgView` | ? |

---

## ⚠️ Important: What NOT to Theme

**DO NOT theme these elements** (they use brand colors):

```swift
// ❌ DON'T theme:
UIColor.UCAColor.AppThemeColor
UIColor.UCAColor.AppThemeTxtColor
UIColor.UCAColor.CallImageBGColor
UIColor.UCAColor.ChatImageBGColor
UIColor.UCAColor.NavigateImageBGColor

// Action button backgrounds
self.callView.backgroundColor
self.chatView.backgroundColor
self.navigationView.backgroundColor

// Icons on colored backgrounds (always white)
callImgView (white)
chatImgView (white)
navigationImgView (white)
```

---

## 🧪 Testing Checklist

After implementation, test these scenarios:

### Initial Load
- [ ] Launch in light mode → Verify white cards, light map
- [ ] Launch in dark mode → Verify dark cards, dark map

### Dynamic Switching
- [ ] Switch from light to dark → All elements update
- [ ] Switch from dark to light → All elements revert
- [ ] Multiple switches → No visual artifacts

### UI Elements
- [ ] Bottom card has proper shadow and border in both modes
- [ ] Text is readable in both modes (good contrast)
- [ ] Map style matches app theme
- [ ] Action buttons keep brand colors
- [ ] Modals/popups theme correctly

### Edge Cases
- [ ] Screen rotation maintains theme
- [ ] Background/foreground maintains theme
- [ ] Navigation maintains theme

---

## 📊 Color Reference

### Dark Mode
| Element | Color | Hex |
|---------|-------|-----|
| Background | Dark Gray | #1C1C1E |
| Card | Darker Gray | #2C2C2E |
| Primary Text | Light | #EDEDED |
| Secondary Text | Medium Gray | #AAAAAA |
| Border | Dark Border | #3A3A3C |
| Shadow | Black | #000000 |

### Light Mode
| Element | Color | Hex |
|---------|-------|-----|
| Background | Light Gray | #f1f1f1 |
| Card | White | #FFFFFF |
| Primary Text | Black | #000000 |
| Secondary Text | Dark Gray | #808080 |
| Border | None | - |
| Shadow | Light Gray | #D3D3D3 |

---

## 🔍 Finding Your Outlets

If you're not sure what your outlet names are, search your file for:

```swift
@IBOutlet weak var
```

This will show all your IBOutlet declarations.

---

## 💡 Tips

1. **Start with the main backgrounds** (view, contentView, mapContainer)
2. **Then do the map** (easiest - just check theme and apply style)
3. **Then bottom card/details** (most visible - use Google Wallet pattern)
4. **Then text labels** (primary vs secondary)
5. **Finally cards/modals** (if present)

6. **Test frequently** - Switch themes after each section

7. **Don't theme branded elements** - Action buttons should keep their colors

8. **Use conditional styling** for dark mode specific adjustments

---

## 📝 Complete Example Template

Here's a complete template you can adapt:

```swift
class ActiveTripUV: UIViewController {
    
    // ... your outlets and properties ...
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ... your existing setup ...
        
        // Register for theme changes
        NotificationCenter.default.addObserver(
            self, 
            selector: #selector(themeDidChange), 
            name: ThemeManager.themeDidChangeNotification, 
            object: nil
        )
        
        // ... other setup ...
        
        // Apply initial theme
        applyTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // ... your existing code ...
        
        // Map initialization with theme
        if !isPageLoaded {
            let camera = GeneralFunctions.getCameraPosition(...)
            gMapView = GMSMapView.map(withFrame: self.googleMapContainerView.frame, camera: camera)
            
            let themeManager = ThemeManager.shared
            if themeManager.isDarkModeActive {
                self.gMapView.nightMapStyle()
            } else {
                self.gMapView.mapStyle = nil
            }
            
            // ... rest of map setup ...
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self, 
            name: ThemeManager.themeDidChangeNotification, 
            object: nil
        )
        // ... your cleanup ...
    }
    
    @objc func themeDidChange() {
        applyTheme()
    }
    
    func applyTheme() {
        let themeManager = ThemeManager.shared
        
        // 1. Backgrounds
        self.view.backgroundColor = themeManager.backgroundColor()
        self.contentView?.backgroundColor = themeManager.backgroundColor()
        
        // 2. Map
        if self.gMapView != nil {
            if themeManager.isDarkModeActive {
                self.gMapView.nightMapStyle()
            } else {
                self.gMapView.mapStyle = nil
            }
        }
        
        // 3. Bottom card
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
        self.destinationLbl?.textColor = themeManager.textColor()
        self.timeLbl?.textColor = themeManager.secondaryTextColor()
        
        // Add your other UI elements here...
        
        print("✅ ActiveTripUV: Theme applied - Dark mode: \(themeManager.isDarkModeActive)")
    }
    
    func setData() {
        // ... your existing code ...
        
        let themeManager = ThemeManager.shared
        
        // Theme-aware initial styling
        if themeManager.isDarkModeActive {
            self.bottomDetailsView.layer.addShadow(opacity: 0.6, radius: 8, UIColor.black)
            self.bottomDetailsView.layer.borderColor = themeManager.borderColor().cgColor
            self.bottomDetailsView.layer.borderWidth = 0.5
        } else {
            self.bottomDetailsView.layer.addShadow(opacity: 0.9, radius: 3, UIColor.lightGray)
            self.bottomDetailsView.layer.borderWidth = 0
        }
        
        // ... rest of setup ...
    }
}
```

---

## ✅ Summary

To implement dark mode in ActiveTripUV:

1. **Add 3 lifecycle hooks:**
   - `viewDidLoad()` - Register notification
   - `themeDidChange()` - Handler
   - `deinit` - Cleanup

2. **Update map initialization** - Use theme instead of time-based

3. **Implement `applyTheme()`** - Comprehensive UI theming

4. **Update setup methods** - Theme-aware initial styling

5. **Test thoroughly** - Both modes, dynamic switching

---

## 📚 Reference Files

- `DriverArrivedUV.swift` - Complete working example
- `ThemeManager.swift` - Theme system
- `DRIVER_ARRIVED_DARK_MODE_IMPLEMENTATION.md` - Detailed documentation
- `DRIVER_ARRIVED_DARK_MODE_QUICK_REF.md` - Quick reference

---

**Last Updated:** November 26, 2026
**Status:** Ready to implement
