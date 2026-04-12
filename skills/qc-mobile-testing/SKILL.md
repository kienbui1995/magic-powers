---
name: qc-mobile-testing
description: Use when testing mobile applications — device matrix strategy, iOS and Android testing tools (XCUITest, Espresso, Appium), gesture and interaction testing, network condition testing, app lifecycle testing, and mobile-specific quality concerns.
---

# QC Mobile Testing

## When to Use
- Testing a native iOS or Android application
- Testing a React Native or Flutter cross-platform app
- Planning device matrix coverage for a release
- Testing mobile-specific behaviors (gestures, push notifications, deep links)
- Testing app behavior on poor network conditions

## Core Jobs

### 1. Device Matrix Strategy
```
Not feasible to test on every device. Use risk-based device matrix:

Tier 1 — Must test (every release):
  iOS: Latest iPhone (current + N-1 iOS), iPad latest
  Android: Samsung Galaxy (latest), Google Pixel (latest), latest Android version
  Coverage: ~60% of your actual user base (check analytics)

Tier 2 — Test before major releases:
  iOS: iPhone SE (small screen), older iPhone (N-2)
  Android: Mid-range phone (Xiaomi, Oppo), older Android (N-2)
  Coverage: additional ~25% of user base

Tier 3 — Spot check quarterly:
  Edge devices, very old Android, tablets
  Coverage: remaining long tail

Prioritize based on:
  - Your analytics: which devices/OS versions do YOUR users have?
  - Market data: iOS vs Android split in your region
  - Device capabilities: features like camera, NFC, biometrics

Tools for device access:
  - BrowserStack / Sauce Labs: real device cloud (subscription)
  - Firebase Test Lab: free tier for Android
  - Physical devices: maintain small pool of Tier 1 devices
```

### 2. iOS Testing with XCUITest
```swift
// XCUITest — Apple's native UI testing framework
import XCTest

class LoginUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]  // flag to use test data
        app.launch()
    }

    func testSuccessfulLogin() throws {
        // Find elements by accessibility identifier
        let emailField = app.textFields["email-input"]
        let passwordField = app.secureTextFields["password-input"]
        let loginButton = app.buttons["login-button"]

        emailField.tap()
        emailField.typeText("test@example.com")
        passwordField.tap()
        passwordField.typeText("Test1234!")
        loginButton.tap()

        // Verify navigation to home screen
        XCTAssertTrue(app.navigationBars["Home"].waitForExistence(timeout: 5))
    }

    func testLoginWithBiometrics() throws {
        // Test Face ID / Touch ID
        app.buttons["biometric-login"].tap()
        // Simulate biometric in simulator
        let coordinator = XCUIDevice.shared
        coordinator.biometricEnrollment(enrolled: true)
        coordinator.performBiometricAuthentication(success: true)

        XCTAssertTrue(app.navigationBars["Home"].waitForExistence(timeout: 3))
    }
}
```

### 3. Android Testing with Espresso
```kotlin
// Espresso — Android's native UI testing framework
@RunWith(AndroidJUnit4::class)
class LoginInstrumentedTest {
    @get:Rule
    val activityRule = ActivityScenarioRule(LoginActivity::class.java)

    @Test
    fun testSuccessfulLogin() {
        onView(withId(R.id.email_input))
            .perform(typeText("test@example.com"), closeSoftKeyboard())

        onView(withId(R.id.password_input))
            .perform(typeText("Test1234!"), closeSoftKeyboard())

        onView(withId(R.id.login_button))
            .perform(click())

        onView(withId(R.id.home_toolbar))
            .check(matches(isDisplayed()))
    }

    @Test
    fun testValidationError() {
        onView(withId(R.id.login_button)).perform(click())

        onView(withText("Email is required"))
            .check(matches(isDisplayed()))
    }
}
```

### 4. Cross-Platform Testing with Appium
```python
# Appium — cross-platform (iOS + Android from same test code)
from appium import webdriver
from appium.options import XCUITestOptions, UiAutomator2Options

# iOS configuration
ios_options = XCUITestOptions()
ios_options.platform_name = "iOS"
ios_options.device_name = "iPhone 15"
ios_options.bundle_id = "com.myapp.ios"

# Android configuration
android_options = UiAutomator2Options()
android_options.platform_name = "Android"
android_options.device_name = "Pixel 7"
android_options.app_package = "com.myapp.android"

# Test using MobileBy locators
from appium.webdriver.common.appiumby import AppiumBy

def test_login(driver):
    email = driver.find_element(AppiumBy.ACCESSIBILITY_ID, "email-input")
    email.send_keys("test@example.com")

    password = driver.find_element(AppiumBy.ACCESSIBILITY_ID, "password-input")
    password.send_keys("Test1234!")

    login_btn = driver.find_element(AppiumBy.ACCESSIBILITY_ID, "login-button")
    login_btn.click()

    home = driver.find_element(AppiumBy.ACCESSIBILITY_ID, "home-screen")
    assert home.is_displayed()
```

### 5. Mobile-Specific Test Cases
```
Gesture testing:
  - Swipe left/right (carousels, delete actions)
  - Pinch to zoom (maps, images)
  - Long press (context menus)
  - Pull to refresh
  - Scroll to bottom (infinite scroll, load more)

App lifecycle testing:
  - Background then foreground: does app restore state correctly?
  - Incoming call during operation: does app pause/resume gracefully?
  - Low memory warning: does app release memory, handle gracefully?
  - App update: does data persist across update?
  - Force kill: does app recover session on relaunch?
  - Deep links: does myapp://screen/123 open correct screen?
  - Push notifications: tapping notification navigates to correct screen?

Network testing:
  - Offline: does app show appropriate offline message?
  - Slow 3G (use Network Link Conditioner on iOS, Android emulator settings):
    - Do timeouts work correctly?
    - Does loading indicator show?
    - Does retry work?
  - Network switch (WiFi → 4G): does app handle gracefully?

Device-specific:
  - Orientation change: portrait ↔ landscape maintains state?
  - Screen size: small screen (SE) shows all content without truncation?
  - Dark mode: all screens readable and correct?
  - Accessibility: VoiceOver (iOS) / TalkBack (Android) works on key flows?
  - Keyboard: does keyboard obscure input fields? Scroll to show?
```

### 6. Mobile Performance Testing
```bash
# iOS performance — use Instruments (Xcode)
# Metrics to check:
#   - App launch time: cold launch < 2s, warm launch < 1s
#   - Memory usage: should not grow unboundedly during use
#   - CPU: should not spike > 80% during normal use
#   - Battery: excessive background activity drains battery

# Android — use Android Profiler (Android Studio)
adb shell am start -W -n com.myapp/.MainActivity
# Output: ThisTime, TotalTime (cold start)

# Frame rate: 60fps target (16ms per frame budget)
adb shell dumpsys gfxinfo com.myapp | grep "Total frames"
```

## Key Concepts
- **Device matrix** — curated set of devices/OS versions representing significant user segments
- **XCUITest** — Apple's native UI test framework for iOS; fastest, most reliable for iOS
- **Espresso** — Google's native UI test framework for Android; same advantages
- **Appium** — cross-platform mobile automation; write once, run on iOS+Android
- **App lifecycle** — background/foreground transitions, memory warnings, deep links, push notifications
- **Network Link Conditioner** — iOS tool to simulate poor network conditions in testing

## Checklist
- [ ] Device matrix defined based on user analytics (not just latest/greatest)?
- [ ] Critical flows tested on at least Tier 1 devices before release?
- [ ] App lifecycle tested (background/foreground, incoming call, force kill)?
- [ ] Network conditions tested (offline, slow 3G, network switch)?
- [ ] Gesture interactions tested (swipe, pinch, long press) where applicable?
- [ ] Orientation change tested for key screens?
- [ ] Dark mode tested if supported?

## Key Outputs
- Device matrix document with tier assignments and rationale
- Mobile test checklist covering app lifecycle, gestures, network conditions
- Automated mobile tests for critical flows (Appium or native framework)
- Mobile performance baseline (launch time, memory usage)

## Output Format
- 🔴 **Critical** — testing only on latest iPhone/Pixel (misses 60%+ of real device issues), no app lifecycle testing (background/foreground bugs reach production)
- 🟡 **Warning** — no network condition testing (app hangs on slow network), no orientation testing, only manual mobile testing with no automation
- 🟢 **Suggestion** — use Firebase Test Lab for automated device farm testing, add Network Link Conditioner tests to CI, document device matrix based on actual analytics

## Anti-Patterns
- Testing on emulator/simulator only (miss real device issues: memory pressure, real network, real battery)
- Testing on developer's own device only (misses other screen sizes, OS versions)
- Ignoring accessibility testing on mobile (VoiceOver/TalkBack used by significant user segment)
- No performance baseline (can't detect performance regressions)

## Integration
- `qc-test-design` — same test design techniques apply to mobile (EP, BVA, exploratory)
- `qc-automation` — Appium/XCUITest/Espresso replace Playwright for mobile
- `qa-risk-management` — device matrix is a risk-based decision
