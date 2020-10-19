# SwiftUIWindowBindableView

![Swift Version](https://img.shields.io/badge/swift-5.2-blue.svg?style=for-the-badge)
![iOS Version](https://img.shields.io/badge/iOS-13.0-green.svg?style=for-the-badge)
![macOS Version](https://img.shields.io/badge/macOS-10.15-green.svg?style=for-the-badge)
![tvOS Version](https://img.shields.io/badge/tvOS-13-green.svg?style=for-the-badge)
![watchOS Version](https://img.shields.io/badge/watchOS-UNSUPPORTED-red.svg?style=for-the-badge)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge)](.//LICENSE)
[![Maintained](https://img.shields.io/badge/Maintained%3F-yes-green.svg?style=for-the-badge)](https://github.com/happycodelucky/SwiftUIWindowBindableView/graphs/commit-activity)
![Release](https://img.shields.io/github/v/release/happycodelucky/SwiftUIWindowBindableView.svg?include_prereleases&style=for-the-badge)

# Overview
**SwiftUIWindowBindableView** is a package for SwiftUI to permit access to a host Window object with zero set up. As such the views in **SwiftUIWindowBindableView** works with newer SwiftUI apps where there is no place to capture a window, as well as multi-window apps.

[`WindowActionButton`](Sources/SwiftUIWindowBindableView/WindowAction.swift) is one handy `Button`-like View anyone coming here is likely to use. 

## Where it Doesn't Work
If you need access to a window object as an Environment this is not going to work for you. Really, you shouldn't need access to the window object during the construction of a SwiftUI view, but only when the view is acted upon (like a Button's `action:` closure). 

SwiftUI itself provides SwiftUI classes to wrap existing functionality in this way, such as `Alert` in place of using `UIAlertViewController` or `NSAlert`.

That said, use of [`WindowBindableView`](Sources/SwiftUIWindowBindableView/WindowBindableView.swift) does support binding to a View's State property.

# Installation
To use **SwiftUIWindowBindableView** within your project see how to reference package using the [Swift Package Manager](https://swift.org/package-manager/) or in [Xcode](https://developer.apple.com/videos/play/wwdc2019/408/), using this repository's GitHub link. Once installed you can import **SwiftUIWindowBindableView** as appropriate.

## Adding to Package.swift
To add manually in the `Package.swift` use the following reference in your `dependencies` section:

```
dependencies: [
    .package(
        name: "SwiftUIWindowBindableView".
        url: "https://github.com/happycodelucky/SwiftUIWindowBindableView.git", 
        .upToNextMajor(from: "0.9.0"),
],

targets: [
    .target(
        name: "MyApp", 
        dependencies: [
            .product(name: "SwiftUIWindowBindableView", package: "SwiftUIWindowBindableView"),
        ])
]
```

# Examples

More coming soon...

`WindowActionButton` looks and behaves like SwiftUI's [Button](https://developer.apple.com/documentation/swiftui/button). It can be initialized in the same way, and have styles applied to it in the same way. 

Below is a simple example of setting up a `WindowActionButton`

```swift
// Create a window action button, where a Window object will be provided to the the `action:` closure
WindowActionButton { window in
    // Do something with window...
} label: {
    // Provide the label view for the button
    Text("Hello")
}
// Set a button style (using default for placeholder)
.buttonStyle(DefaultButtonStyle())
```

Next, lets do something with the button's action closure. You may want to use this for something like [`ASWebAuthenticationSession`](https://developer.apple.com/documentation/authenticationservices/aswebauthenticationsession), which does not have a SwiftUI equivently yet. Instead lets interop with the UIKit version of [`Alert`](https://developer.apple.com/documentation/swiftui/alert).

```swift
// Create a window action button, where a Window object will be provided to the the `action:` closure
WindowActionButton { window in
    let title = "Hello"
    let message = "Hello Mum"
    let buttonTitle = "Bye!"

    // In this example it know ``Alert`` can be used from SwiftUI
    // Instead this demonstrates the accessibity of the window tersely

    // Use UIAlertController instead of Alert
    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
    controller.addAction(UIAlertAction(title: buttonTitle, style: .cancel))

    // Present the alert using the window's rootViewController
    window.rootViewController!.present(controller, animated: true) { }
} label: {
    // Provide the label view for the button
    Text("Hello")
}
// Set a button style (using default for placeholder)
.buttonStyle(DefaultButtonStyle())
```

It's that simple.

## Playgrounds
To run the [SwiftUIWindowBindableView Playground](Playgrounds) examples you will need to open the package in Xcode and run any of the playgrounds under `Playgrounds`. 

Be sure to have the options "Render Documentation" and "Build Active Schema" enabled (they are by default) for the best representation, as the Playgrounds serve as working documentation.