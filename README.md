# LeadRyde-Driver-ios

## Overview

This project, `Provider app`, is an iOS application with two main environments: **Staging** and **Production**. This README provides guidelines to help you set up, configure, and troubleshoot the project during development and deployment.

## Environments

### Staging

- **URL:** `https://demo.leadryde.com`
- **Scheme:** `Provider app Staging`
- **Configuration:** `Staging`
- **App Icon:** `AppIcon_staging`
- **App Name:** Configured in **Target > Provider app > Build Settings (all) > Info.plist values** by searching for `Bundle Display Name` for the staging configuration.

### Production

- **URLs:** 
  - `https://app.leadryde.com`
  - `https://leadryde.com`
- **Scheme:** `Provider app`
- **Configuration:** `Production`
- **App Icon:** `AppIcon`
- **App Name:** Configured in **Target > Provider app > Build Settings (all) > Info.plist values** by searching for `Bundle Display Name` for the production configuration.

### Configuration Settings

To manage the environments:
1. **Build Configurations:**
   - Go to **Project > Info > Configurations** to view or modify the configurations for both Staging and Production.

2. **Schemes:**
   - **Provider app Staging**: Uses the `Staging` configuration.
   - **Provider app**: Uses the `Production` configuration.
   - To check or edit these, navigate to **Product > Scheme > Edit Scheme**.

3. **App Name and App Icon:**
   - These are configured separately for each environment in **Target > Provider app > Build Settings** (ensure "All" is selected).
   - Search for `AppIcon` to find and edit the app icons for each environment. Icons are named `AppIcon` for Production and `AppIcon_staging` for Staging.
   - Search for `Bundle Display Name` in **Info.plist values** to configure the app name for each environment.

4. **Base URL Handling:**
   - The `BASE_URL` is set using compilation flags, which are determined by the active scheme.
   - Compilation flags are defined in **Target > Provider app > Build Settings**. Search for `Active Compilation Conditions`.
   - These flags are utilized in the `CommonUtils` class to select the appropriate URL.

## Troubleshooting

### Handy JSON Pod Issue

There is a known issue with the `HandyJSON` pod, particularly when compiling or archiving with the `Release` configuration. The error is related to the optimization level in the build settings.

**Temporary Fix:**
- Navigate to **Pods project > Handy JSON > Build Settings**.
- Search for `Optimization Level` and set it to `None` for all configurations.

**Permanent Solution:**
- Consider updating the `HandyJSON` pod to the latest version to see if the issue is resolved.
- Alternatively, you may replace `HandyJSON` with a different JSON parsing library that does not have this issue.

### Info.plist File Anomaly

An unusual behavior has been observed where the `Info.plist` file in the project appears to be unused:
- Custom properties added to the `Info.plist` do not show up when reading from the file.
- Values fetched via `Bundle.main.infoDictionary` are actually coming from **Target > Provider app > Build Settings (all) > Info.plist values**.
- Even if the `Info.plist` file is deleted, the project still functions normally, indicating that the file is not being utilized by the build process.

**Recommendation:**
- Since the `Info.plist` file is not impacting the project, the `BASE_URL` is handled via compilation flags. Ideally, it would be better to store the `BASE_URL` in User-Defined settings and add an entry in the `Info.plist`. However, due to the current anomaly, using compilation flags is the safer approach.
