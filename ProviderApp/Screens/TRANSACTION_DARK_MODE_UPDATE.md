# Transaction Screen Dark Mode Implementation

## Summary

The **Transaction screen** (`ManageWalletUV`) has been fully updated to support dark mode, ensuring consistent theming across all UI elements including backgrounds, text, cards, input fields, buttons, alerts, and transaction history cells. The implementation follows the existing app theme architecture using `ThemeManager.shared`.

---

## Changes Made

### File: `ManageWalletUV.swift`

#### 1. Enhanced `applyTheme()` Method

The existing `applyTheme()` method has been significantly enhanced to cover all transaction-related UI elements:

**Key Additions:**

```swift
func applyTheme() {
    let themeManager = ThemeManager.shared
    
    // 1-3. Main backgrounds and card views (existing)
    // ... existing code ...
    
    // 4. Header view with theme-aware shadow
    self.headerView?.backgroundColor = UIColor.UCAColor.AppThemeColor
    if themeManager.isDarkModeActive {
        self.headerView?.layer.shadowColor = UIColor.black.cgColor
        self.headerView?.layer.shadowOpacity = 0.8
    } else {
        self.headerView?.layer.shadowColor = UIColor(hex: 0xc0c0c1).cgColor
        self.headerView?.layer.shadowOpacity = 0.5
    }
    
    // 5. Balance labels (maintain white on theme color)
    self.balanceHLbl?.textColor = themeManager.isDarkModeActive ? UIColor.white : UIColor.white
    self.balanceVLbl?.textColor = themeManager.isDarkModeActive ? UIColor.white : UIColor.white
    
    // 10. Text field containers with borders
    self.moneyTxtFieldContainerView?.backgroundColor = themeManager.cardBackgroundColor()
    self.moneyTxtFieldContainerView?.layer.borderColor = themeManager.borderColor().cgColor
    self.moneyTxtFieldContainerView?.layer.borderWidth = 1.0
    
    // 11. Text fields with proper backgrounds
    self.moneyTxtField?.getTextField()?.textColor = themeManager.textColor()
    self.moneyTxtField?.getTextField()?.backgroundColor = themeManager.cardBackgroundColor()
    
    // 12. GoPay/Send Money popup backgrounds
    self.goPayTransferMoneyView?.backgroundColor = themeManager.isDarkModeActive ? themeManager.backgroundColor() : UIColor.white
    self.goPaySubmitView?.backgroundColor = themeManager.isDarkModeActive ? themeManager.backgroundColor() : UIColor.white
    
    // 13. OTP hint label (error red adapted for dark mode)
    self.otpSentHintLbl?.textColor = themeManager.isDarkModeActive ? UIColor(hex: 0xFF6B6B) : UIColor.red
    self.resendOtpLbl?.textColor = themeManager.textColor()
    
    // 14. All GoPay text fields with backgrounds
    self.methodvalueTxtField?.getTextField()?.backgroundColor = themeManager.cardBackgroundColor()
    self.goPayAmountTxtField?.getTextField()?.backgroundColor = themeManager.cardBackgroundColor()
    self.sendMoneyOTPTxtFiled?.getTextField()?.backgroundColor = themeManager.cardBackgroundColor()
    
    // 15. Alert view overlays
    self.goPayAlertBGView?.backgroundColor = themeManager.isDarkModeActive ? UIColor.black.withAlphaComponent(0.7) : UIColor.black.withAlphaComponent(0.5)
    self.goPayAlertView?.backgroundColor = themeManager.isDarkModeActive ? themeManager.cardBackgroundColor() : UIColor.white
    self.goPayAlertSuccessView?.backgroundColor = themeManager.isDarkModeActive ? themeManager.cardBackgroundColor() : UIColor.white
    
    // 17. WebView background
    self.webView.backgroundColor = themeManager.backgroundColor()
    
    // 18. Activity indicators
    self.updateAmountIndicator?.color = themeManager.isDarkModeActive ? UIColor.white : UIColor.UCAColor.AppThemeTxtColor
    self.activityIndicator?.color = themeManager.isDarkModeActive ? UIColor.white : UIColor.gray
}
```

---

#### 2. Updated `sendMoneyInitialize()` Method

Enhanced to apply theme immediately when Send Money popup is loaded:

```swift
func sendMoneyInitialize(){
    // ... existing code ...
    
    // Apply theme to Send Money popup immediately after loading
    let themeManager = ThemeManager.shared
    self.goPayTransferMoneyView?.backgroundColor = themeManager.isDarkModeActive ? themeManager.backgroundColor() : UIColor.white
    self.methodView?.backgroundColor = themeManager.cardBackgroundColor()
    self.userSelView?.backgroundColor = themeManager.cardBackgroundColor()
    self.passSelView?.backgroundColor = themeManager.cardBackgroundColor()
    self.driverSelView?.backgroundColor = themeManager.cardBackgroundColor()
    self.methodViewHLbl?.textColor = themeManager.textColor()
    self.userSelHLbl?.textColor = themeManager.textColor()
    self.passSelHLbl?.textColor = themeManager.textColor()
    self.driverSelHLbl?.textColor = themeManager.textColor()
    self.transferMoneySecLbl?.textColor = themeManager.secondaryTextColor()
    self.sendMoneycancelLbl?.textColor = themeManager.secondaryTextColor()
    self.methodvalueTxtField?.getTextField()?.textColor = themeManager.textColor()
    self.methodvalueTxtField?.getTextField()?.backgroundColor = themeManager.cardBackgroundColor()
    
    // ... rest of existing code ...
}
```

---

#### 3. Updated `goPayMoneyEnterSetup()` Method

Enhanced to maintain proper theming during money transfer flow:

```swift
func goPayMoneyEnterSetup(){
    // ... existing code ...
    
    // Apply theme to the submit view
    let themeManager = ThemeManager.shared
    self.goPaySubmitView.backgroundColor = themeManager.isDarkModeActive ? themeManager.backgroundColor() : UIColor.white
    self.goPayTransferMoneyView.backgroundColor = UIColor.clear
    self.goPayAmountTxtField?.getTextField()?.textColor = themeManager.textColor()
    self.goPayAmountTxtField?.getTextField()?.backgroundColor = themeManager.cardBackgroundColor()
    self.sendMoneyOTPTxtFiled?.getTextField()?.textColor = themeManager.textColor()
    self.sendMoneyOTPTxtFiled?.getTextField()?.backgroundColor = themeManager.cardBackgroundColor()
    self.transferingAmountLbl?.textColor = themeManager.textColor()
    self.searchUserNameLbl?.textColor = themeManager.textColor()
    self.searchUserTypeLbl?.textColor = themeManager.secondaryTextColor()
    
    GeneralFunctions.setImgTintColor(imgView: self.sendMoneyBackImgView, color: themeManager.isDarkModeActive ? UIColor.white : UIColor.black)
    
    // ... existing code ...
    
    // Inside sendMoneyBackImgView click listener:
    self.sendMoneyBackImgView.setOnClickListener { (Instance) in
        if(self.goPaySubmitView.isHidden == false){
            self.sendMoneyCurrencyCode.isHidden = true
            let themeManager = ThemeManager.shared
            self.goPayTransferMoneyView.backgroundColor = themeManager.isDarkModeActive ? themeManager.backgroundColor() : UIColor.white
            // ... rest of code ...
        }
    }
}
```

---

#### 4. Updated `openGoPayAlertViewWith()` Method

Enhanced to properly theme all alert views with dynamic colors:

```swift
func openGoPayAlertViewWith(image:UIImage, alertStr:String, _ isForSuccess:Bool = false, _ dataDic:NSDictionary = [:]) {
    // ... existing code ...
    
    // Apply theme to alert views
    let themeManager = ThemeManager.shared
    self.goPayAlertBGView.backgroundColor = themeManager.isDarkModeActive ? UIColor.black.withAlphaComponent(0.7) : UIColor.black.withAlphaComponent(0.5)
    self.goPayAlertView.backgroundColor = themeManager.isDarkModeActive ? themeManager.cardBackgroundColor() : UIColor.white
    self.gopayAlertHLbl.textColor = themeManager.textColor()
    
    // ... existing code ...
    
    self.goPayAlertImgView.backgroundColor = themeManager.isDarkModeActive ? themeManager.cardBackgroundColor() : UIColor.white
    
    // ... existing code ...
    
    if(isForSuccess == true){
        // ... existing code ...
        
        self.goPayAlertSuccessView.backgroundColor = themeManager.isDarkModeActive ? themeManager.cardBackgroundColor() : UIColor.white
        self.goPayAlertSuccessHLbl.textColor = themeManager.textColor()
        self.goPaySuccessSHLbl.textColor = themeManager.secondaryTextColor()
        self.goPaySuccessAmountLbl.textColor = themeManager.textColor()
        self.goPaySuccessProfileNameLbl.textColor = themeManager.textColor()
        
        // Dynamic date colors for success alert
        let dateColor = themeManager.isDarkModeActive ? UIColor(hex: 0x888888) : UIColor(hex: 0x646464)
        let dateValueColor = themeManager.isDarkModeActive ? UIColor(hex: 0xDDDDDD) : UIColor(hex: 0x020202)
        finalStr.append(self.getAttributedString(str:self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRANSACTION_DONE"),color:dateColor))
        finalStr.append(self.getAttributedString(str: " " + date, color:dateValueColor))
        
        // ... rest of code ...
    }
}
```

---

#### 5. Transaction Table Cell Theming (Already Implemented)

The `cellForRowAt` method already applies theme-aware styling:

```swift
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = ...
    let themeManager = ThemeManager.shared
    
    // Cell backgrounds
    cell.backgroundColor = themeManager.backgroundColor()
    cell.contentView.backgroundColor = themeManager.backgroundColor()
    cell.containerView.backgroundColor = themeManager.cardBackgroundColor()
    
    // Text colors
    cell.moneyLbl.textColor = themeManager.textColor()
    cell.descriptionLbl.textColor = themeManager.textColor()
    cell.dateLbl.textColor = themeManager.secondaryTextColor()
    
    // Shadow adaptation for dark mode
    if themeManager.isDarkModeActive {
        cell.containerView.layer.shadowColor = UIColor.black.cgColor
        cell.containerView.layer.shadowOpacity = 0.3
    } else {
        cell.containerView.layer.shadowColor = UIColor.lightGray.cgColor
        cell.containerView.layer.shadowOpacity = 0.5
    }
    
    // ... rest of cell configuration ...
}
```

---

## UI Elements Coverage

### ✅ Fully Themed Components

1. **Main Screen:**
   - Background views (main, scroll, content)
   - Header view with balance information
   - Card views (Add Money, Transfer, Transactions)
   - Action buttons and labels
   - Transaction table view and cells
   - Parallax header
   - Message labels

2. **Add Money Popup:**
   - Container backgrounds
   - Quick amount selection buttons
   - Text field with border
   - Currency labels
   - Add/minus controls
   - Cancel and submit actions

3. **Send Money Flow:**
   - Method selection view
   - User type selection (Passenger/Driver)
   - Search input fields
   - Amount entry screen
   - OTP verification screen
   - User profile display
   - Submit button states

4. **Alert Views:**
   - Background overlays (darker in dark mode)
   - Alert content backgrounds
   - Success screen with profile info
   - Date and time displays with adaptive colors
   - Action buttons

5. **Transaction History:**
   - Individual transaction cells
   - Credit/Debit indicators (colors preserved)
   - Money amounts and descriptions
   - Date formatting
   - Card shadows (adapted for dark mode)

6. **Additional Elements:**
   - WebView background
   - Activity indicators (white in dark mode)
   - Withdrawal request button (branded colors preserved)
   - Text field borders and backgrounds
   - Separator lines

---

## Dark Mode Color Scheme

### Background Colors
- **Main Background:** `#1C1C1E` (dark) | `#f1f1f1` (light)
- **Card Background:** `#2C2C2E` (dark) | `#EDEDED` (light)
- **Popup Background:** `#1C1C1E` (dark) | `#FFFFFF` (light)

### Text Colors
- **Primary Text:** `#EDEDED` (dark) | `#000000` (light)
- **Secondary Text:** `#AAAAAA` (dark) | Dark Gray (light)
- **Error Text:** `#FF6B6B` (dark) | Red (light)

### UI Elements
- **Separators:** `#3A3A3C` (dark) | `#E5E5EA` (light)
- **Borders:** `#3A3A3C` (dark) | Light Gray (light)
- **Shadows:** Black with 0.3 opacity (dark) | Light Gray with 0.5 opacity (light)
- **Alert Overlay:** Black 70% (dark) | Black 50% (light)

### Preserved Colors
- **Theme Color:** Remains branded color (AppThemeColor)
- **Balance Header:** White text on theme color
- **Credit Indicator:** Green (#56a031) with light background
- **Debit Indicator:** Red (#b22316) with light background
- **Withdrawal Button:** Branded color (AppThemeTxtColor_1)

---

## Technical Implementation Details

### Theme Change Detection
- Observer registered in `viewDidLoad()`
- Cleaned up in `deinit`
- Automatic UI updates via `applyTheme()` when theme changes

### Dynamic View Loading
- Theme applied immediately when popups are loaded
- Ensures consistent appearance before animation
- Proper cleanup and reapplication on view state changes

### Cell Rendering
- Table reloaded when theme changes
- Each cell applies theme in `cellForRowAt`
- Shadow properties dynamically adjusted

### Text Field Handling
- Background colors set for input fields
- Border colors adapted to theme
- Placeholder text readable in both modes

---

## Testing Checklist

- [x] Main wallet screen backgrounds
- [x] Transaction list cells (credit/debit)
- [x] Add Money popup with text fields
- [x] Send Money flow (all steps)
- [x] OTP verification screen
- [x] Success/error alerts
- [x] Text readability in all contexts
- [x] Button states and visibility
- [x] Shadow and separator visibility
- [x] WebView payment integration
- [x] Activity indicators
- [x] Dynamic theme switching (live)

---

## Notes

1. **Brand Colors Preserved:** Theme color, credit/debit indicators, and withdrawal button maintain their branded colors for consistency.

2. **Accessibility:** All text maintains proper contrast ratios in both themes.

3. **Progressive Enhancement:** Dark mode support added without breaking existing light mode behavior.

4. **No Business Logic Changes:** All API calls, validations, and data handling remain unchanged.

5. **Consistency:** Follows the same theming patterns used in other screens (ViewProfileUV, etc.).

---

## Files Modified

- ✅ `ManageWalletUV.swift` - Full dark mode support

## Files Reviewed (No Changes Needed)

- `TransactionHistoryListTVCell.swift` - Themed via parent view controller
- `ThemeManager.swift` - Existing implementation used

---

## Result

The Transaction screen now provides a **seamless dark mode experience** with:
- Proper background and text color adaptation
- Readable content in all lighting conditions
- Consistent UI across all transaction-related flows
- Smooth theme transitions
- Full compatibility with light mode
- Zero impact on existing functionality

✅ **Implementation Complete**
