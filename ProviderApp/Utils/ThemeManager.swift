//
//  ThemeManager.swift
//  Login_SignUp
//
//  Created on 29/10/2026.
//

import UIKit

enum AppTheme: String {
    case light = "light"
    case dark = "dark"
}

class ThemeManager {
    
    static let shared = ThemeManager()
    
    private let themeKey = "APP_THEME_PREFERENCE"
    
    // Notification name for theme changes
    static let themeDidChangeNotification = Notification.Name("ThemeDidChangeNotification")
    
    private init() {}
    
    var currentTheme: AppTheme {
        get {
            guard let themeString = UserDefaults.standard.string(forKey: themeKey),
                  let theme = AppTheme(rawValue: themeString) else {
                return .light
            }
            return theme
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: themeKey)
            UserDefaults.standard.synchronize()
            applyTheme(newValue)
            NotificationCenter.default.post(name: ThemeManager.themeDidChangeNotification, object: nil)
        }
    }
    
    func applyTheme(_ theme: AppTheme) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        switch theme {
        case .light:
            window.overrideUserInterfaceStyle = .light
        case .dark:
            window.overrideUserInterfaceStyle = .dark
        }
    }
    
    func applyCurrentTheme() {
        applyTheme(currentTheme)
    }
    
    // Helper to check if dark mode is currently active
    var isDarkModeActive: Bool {
        return currentTheme == .dark
    }
    
    // Theme colors
    func backgroundColor() -> UIColor {
        return isDarkModeActive ? UIColor(hex: 0x1C1C1E) : UIColor(hex: 0xf1f1f1)
    }
    
    func cardBackgroundColor() -> UIColor {
        return isDarkModeActive ? UIColor(hex: 0x2C2C2E) : UIColor(hex: 0xEDEDED)
    }
    
    func textColor() -> UIColor {
        return isDarkModeActive ? UIColor(hex: 0xEDEDED) : UIColor.black
    }
    
    func secondaryTextColor() -> UIColor {
        return isDarkModeActive ? UIColor(hex: 0xAAAAAA) : UIColor.darkGray
    }
    
    func separatorColor() -> UIColor {
        return isDarkModeActive ? UIColor(hex: 0x3A3A3C) : UIColor(hex: 0xE5E5EA)
    }
    
    func borderColor() -> UIColor {
        return isDarkModeActive ? UIColor(hex: 0x3A3A3C) : UIColor.lightGray
    }
}

