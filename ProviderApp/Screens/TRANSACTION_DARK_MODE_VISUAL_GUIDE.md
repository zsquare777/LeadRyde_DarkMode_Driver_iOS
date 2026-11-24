# Transaction Screen Dark Mode - Visual Guide

## Overview
This document provides a detailed breakdown of the visual changes applied to each component of the Transaction screen for dark mode support.

---

## 1. Main Wallet Screen

### Light Mode
- Background: Light gray (#f1f1f1)
- Cards: Soft gray (#EDEDED)
- Text: Black
- Shadows: Light gray, subtle

### Dark Mode
- Background: Dark gray (#1C1C1E)
- Cards: Medium dark gray (#2C2C2E)
- Text: Light gray (#EDEDED)
- Shadows: Black, more pronounced

### Components:
```
┌─────────────────────────────────────┐
│  Header (Theme Color - Unchanged)   │
│  Balance: $XXX.XX (White Text)      │
│  View Transactions (Button)         │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  ┌───────────┐ ┌───────────┐       │
│  │ Add Money │ │ Transfer  │       │  <- Card BG
│  └───────────┘ └───────────┘       │
│  ┌───────────────────────────┐     │
│  │      Transactions         │     │  <- Card BG
│  └───────────────────────────┘     │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  Recent Transactions:               │
│  ┌─────────────────────────────┐   │
│  │ [Icon] Credit  +$XX.XX      │   │  <- Cell Card BG
│  │        Description          │   │
│  │        Date & Time          │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ [Icon] Debit   -$XX.XX      │   │  <- Cell Card BG
│  │        Description          │   │
│  │        Date & Time          │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

**Color Mapping:**
- Header Background: `AppThemeColor` (both modes)
- Balance Text: `White` (both modes)
- Main Background: `#1C1C1E` (dark) / `#f1f1f1` (light)
- Card Background: `#2C2C2E` (dark) / `#EDEDED` (light)
- Primary Text: `#EDEDED` (dark) / `Black` (light)
- Secondary Text: `#AAAAAA` (dark) / `Dark Gray` (light)

---

## 2. Add Money Popup

### Layout:
```
┌─────────────────────────────────────┐
│  Add Money                          │  <- Title (Primary Text)
│  Add funds to your wallet           │  <- Subtitle (Secondary Text)
│                                     │
│  ┌─────┐  ┌─────┐  ┌─────┐        │
│  │ $10 │  │ $20 │  │ $50 │        │  <- Quick Amount Buttons
│  └─────┘  └─────┘  └─────┘        │     (Card BG)
│                                     │
│  ┌─────────────────────────────┐   │
│  │ [-]  $ 0.00  [+]           │   │  <- Amount Input
│  └─────────────────────────────┘   │     (Card BG with Border)
│                                     │
│  ┌─────────────────────────────┐   │
│  │          DONE               │   │  <- Action Button
│  └─────────────────────────────┘   │
│                                     │
│           Cancel                    │  <- Cancel Link
└─────────────────────────────────────┘
```

**Dark Mode Colors:**
- Popup Background: `#1C1C1E`
- Quick Amount Buttons: `#2C2C2E` with `#EDEDED` text
- Input Field Background: `#2C2C2E`
- Input Field Border: `#3A3A3C`
- Input Text: `#EDEDED`
- Currency Symbol: `#AAAAAA`
- Cancel Link: `#AAAAAA`
- +/- Icons: Theme color (tinted)

**Light Mode Colors:**
- Popup Background: `White`
- Quick Amount Buttons: `#EDEDED` with `Black` text
- Input Field Background: `#EDEDED`
- Input Field Border: `Light Gray`
- Input Text: `Black`
- Currency Symbol: `Dark Gray`
- Cancel Link: `Dark Gray`

---

## 3. Send Money Flow

### Step 1: Search User
```
┌─────────────────────────────────────┐
│  ← Send Money                       │  <- Header
│  Transfer money to other users      │  <- Subtitle
│                                     │
│  Transfer to whom?                  │
│  ┌─────────────────────────────┐   │
│  │ ○ Passenger                 │   │  <- Selection Options
│  └─────────────────────────────┘   │     (Card BG)
│  ┌─────────────────────────────┐   │
│  │ ○ Driver                    │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Email or Phone Number       │   │  <- Input Field
│  └─────────────────────────────┘   │     (Card BG)
│                                     │
│  ┌─────────────────────────────┐   │
│  │          NEXT               │   │
│  └─────────────────────────────┘   │
│                                     │
│           Cancel                    │
└─────────────────────────────────────┘
```

### Step 2: Enter Amount
```
┌─────────────────────────────────────┐
│  ← Send Money                       │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  [Profile Image]            │   │  <- User Profile
│  │  John Doe                   │   │     (Card BG)
│  │  Passenger                  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ [-]  $ 0.00  [+]           │   │  <- Amount Input
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │    Send to John Doe         │   │
│  └─────────────────────────────┘   │
│                                     │
│           Cancel                    │
└─────────────────────────────────────┘
```

### Step 3: OTP Verification
```
┌─────────────────────────────────────┐
│  ← Send Money                       │
│                                     │
│  [ⓘ] Please enter OTP sent to      │  <- Info Icon
│       your registered contact       │     (Red/Pink text)
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Enter OTP                   │   │  <- OTP Input
│  └─────────────────────────────┘   │
│                                     │
│  🔄 Resend OTP                      │  <- Resend Link
│                                     │
│  ┌─────────────────────────────┐   │
│  │          SUBMIT             │   │
│  └─────────────────────────────┘   │
│                                     │
│           Cancel                    │
└─────────────────────────────────────┘
```

**Dark Mode Specifics:**
- Popup Background: `#1C1C1E`
- Selection Cards: `#2C2C2E`
- Input Fields: `#2C2C2E` with `#EDEDED` text
- User Profile Card: `#2C2C2E`
- OTP Hint Text: `#FF6B6B` (lighter red for visibility)
- Resend Link: `#EDEDED` with theme icon tint

---

## 4. Alert Views

### Error/Info Alert
```
┌─────────────────────────────────────┐
│                                     │
│    ┌───────────────────────┐       │
│    │                       │       │
│    │   [Icon - Themed]     │       │
│    │                       │       │
│    │  Error Message Text   │       │  <- Alert Card
│    │  appears here with    │       │     (Card BG)
│    │  proper formatting    │       │
│    │                       │       │
│    │   ┌───────────┐      │       │
│    │   │    OK     │      │       │
│    │   └───────────┘      │       │
│    │                       │       │
│    └───────────────────────┘       │
│                                     │
└─────────────────────────────────────┘
```

### Success Alert
```
┌─────────────────────────────────────┐
│                                     │
│    ┌───────────────────────┐       │
│    │                       │       │
│    │   ✓ Successfully      │       │
│    │                       │       │
│    │   Send money to       │       │
│    │   John Doe            │       │
│    │                       │       │
│    │   $ 50.00            │       │  <- Success Card
│    │                       │       │     (Card BG)
│    │  [Profile Image]      │       │
│    │   John Doe            │       │
│    │                       │       │
│    │   Transaction done    │       │
│    │   Nov 21, 2026        │       │
│    │                       │       │
│    │   ┌───────────┐      │       │
│    │   │   DONE    │      │       │
│    │   └───────────┘      │       │
│    │                       │       │
│    └───────────────────────┘       │
│                                     │
└─────────────────────────────────────┘
```

**Dark Mode Colors:**
- Background Overlay: `Black 70%` opacity
- Alert Background: `#2C2C2E`
- Title Text: `#EDEDED`
- Body Text: `#AAAAAA`
- Success Amount: `#EDEDED`
- Date Label:
  - Label: `#888888`
  - Value: `#DDDDDD`

**Light Mode Colors:**
- Background Overlay: `Black 50%` opacity
- Alert Background: `White`
- Title Text: `Black`
- Body Text: `Dark Gray`
- Success Amount: `Black`
- Date Label:
  - Label: `#646464`
  - Value: `#020202`

---

## 5. Transaction List Cells

### Cell Layout:
```
┌─────────────────────────────────────┐
│ [●] Credit        $ 50.00          │  <- Green indicator
│     Wallet recharge                 │
│     Nov 21, 2026 10:30 AM          │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ [●] Debit         $ 25.00          │  <- Red indicator
│     Payment for Trip #12345         │
│     Nov 20, 2026 03:15 PM          │
└─────────────────────────────────────┘
```

**Dark Mode:**
- Cell Background: `#2C2C2E`
- Cell Shadow: `Black` with 0.3 opacity
- Amount Text: `#EDEDED`
- Description Text: `#EDEDED`
- Date Text: `#AAAAAA`
- Separator: `#3A3A3C`

**Light Mode:**
- Cell Background: `#EDEDED`
- Cell Shadow: `Light Gray` with 0.5 opacity
- Amount Text: `Black`
- Description Text: `Black`
- Date Text: `Dark Gray`
- Separator: `#E5E5EA`

**Preserved (Both Modes):**
- Credit Indicator: `#56a031` on `#dbf2c0` background
- Debit Indicator: `#b22316` on `#f7d5d6` background
- Highlight Bar: `#56a031` (credit) / `#b22316` (debit)

---

## 6. Activity Indicators & Loading States

**Dark Mode:**
- Spinner Color: `White`
- Background: Transparent or `#1C1C1E`

**Light Mode:**
- Spinner Color: `Gray` or `AppThemeTxtColor`
- Background: Transparent or `#f1f1f1`

---

## 7. Text Field States

### Normal State
```
┌─────────────────────────────────────┐
│  Placeholder text...                │
└─────────────────────────────────────┘
```

**Dark Mode:**
- Background: `#2C2C2E`
- Border: `#3A3A3C`, 1pt
- Text: `#EDEDED`
- Placeholder: `#666666`

**Light Mode:**
- Background: `#EDEDED`
- Border: `Light Gray`, 1pt
- Text: `Black`
- Placeholder: `#999999`

### Focused State
- Border thickness may increase
- Border color: Theme color (optional, if implemented)

### Error State
- Border: Red
- Error text below field: `#FF6B6B` (dark) / `Red` (light)

---

## 8. Withdrawal Request Button

### Visual:
```
┌─────────────────────────────────────┐
│  [↓] Withdraw Request               │  <- Branded color
└─────────────────────────────────────┘
```

**Both Modes:**
- Background: `AppThemeTxtColor_1` (branded)
- Text: `Black`
- Icon: `AppThemeColor` (tinted)
- Maintains branding regardless of theme

---

## Color Reference Table

| Element | Dark Mode | Light Mode |
|---------|-----------|------------|
| **Backgrounds** | | |
| Main BG | `#1C1C1E` | `#f1f1f1` |
| Card BG | `#2C2C2E` | `#EDEDED` |
| Popup BG | `#1C1C1E` | `#FFFFFF` |
| Alert Overlay | `Black 70%` | `Black 50%` |
| **Text** | | |
| Primary Text | `#EDEDED` | `#000000` |
| Secondary Text | `#AAAAAA` | Dark Gray |
| Error/Warning | `#FF6B6B` | Red |
| **UI Elements** | | |
| Border | `#3A3A3C` | Light Gray |
| Separator | `#3A3A3C` | `#E5E5EA` |
| Shadow | Black 0.3 | Lt Gray 0.5 |
| Activity Indicator | White | Gray |
| **Preserved** | | |
| Theme Color | `AppThemeColor` | `AppThemeColor` |
| Credit Indicator | `#56a031` | `#56a031` |
| Debit Indicator | `#b22316` | `#b22316` |
| Withdrawal BG | `AppThemeTxtColor_1` | `AppThemeTxtColor_1` |

---

## Interaction States

### Button States

**Normal:**
- Light Mode: Theme color background, white text
- Dark Mode: Theme color background, white text

**Disabled:**
- Light Mode: Gray background, light gray text
- Dark Mode: `#2C2C2E` background, `#666666` text

**Pressed:**
- Both: Slightly darker/lighter version with ripple effect

---

## Accessibility Notes

1. **Contrast Ratios:**
   - Primary text on card background: > 4.5:1
   - Secondary text on card background: > 3:1
   - All interactive elements meet WCAG AA standards

2. **Touch Targets:**
   - All buttons and interactive elements maintain 44pt minimum touch target
   - No changes to touch areas in dark mode

3. **Visual Feedback:**
   - Buttons show pressed states
   - Input fields show focus states
   - Loading indicators visible in both modes

---

## Implementation Notes

1. **Shadow Adaptation:**
   - Shadows are more pronounced in light mode for depth
   - Softer shadows in dark mode to avoid harsh contrast

2. **Border Usage:**
   - Borders help define input fields in dark mode
   - More subtle in light mode where backgrounds provide definition

3. **Icon Tinting:**
   - Icons use theme color tinting for consistency
   - Special icons (credit/debit) maintain their semantic colors

4. **Text Hierarchy:**
   - Three levels: Primary (`#EDEDED`), Secondary (`#AAAAAA`), Tertiary (darker)
   - Maintains readability while showing information hierarchy

---

## Testing Scenarios

✅ **Tested Configurations:**
1. Light mode → Dark mode switch (live)
2. Dark mode → Light mode switch (live)
3. Add Money popup in both modes
4. Send Money flow (all steps) in both modes
5. Alert views in both modes
6. Transaction list scrolling in both modes
7. Text field input in both modes
8. Loading states in both modes
9. Error states in both modes
10. Success states in both modes

✅ **Result:** All UI elements properly adapt to theme changes with no visual glitches or readability issues.

---

## Conclusion

The Transaction screen now provides a **complete dark mode experience** with:
- Proper contrast and readability
- Consistent color scheme
- Smooth transitions between themes
- Preserved branding elements
- Full accessibility compliance
- Zero business logic impact

This implementation serves as a **reference for other screens** requiring dark mode support.
