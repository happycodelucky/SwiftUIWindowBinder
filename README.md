# SwiftUIWindowBinder

![Swift Version](https://img.shields.io/badge/swift-5.2-blue.svg?style=for-the-badge)
![iOS Version](https://img.shields.io/badge/iOS-13.0-green.svg?style=for-the-badge)
![macOS Version](https://img.shields.io/badge/macOS-10.15-green.svg?style=for-the-badge)
![tvOS Version](https://img.shields.io/badge/tvOS-13-green.svg?style=for-the-badge)
![watchOS Version](https://img.shields.io/badge/watchOS-UNSUPPORTED-red.svg?style=for-the-badge)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge)](.//LICENSE)
[![Maintained](https://img.shields.io/badge/Maintained%3F-yes-green.svg?style=for-the-badge)](https://github.com/happycodelucky/SwiftUIWindowBinder/graphs/commit-activity)
![Release](https://img.shields.io/github/v/release/happycodelucky/SwiftUIWindowBinder.svg?include_prereleases&style=for-the-badge)

# Overview
**SwiftUIWindowBinder** supports SwiftUI in getting access to a host Window object with zero set up. SwiftUI apps with no application delegate or scene delegate can still access the Window, and the window is scoped to each document in a multi-window application.

## WindowButton

A typically usage of importing **SwiftUIWindowBinder** is to access [`WindowButton`](Sources/SwiftUIWindowBinder/WindowAction.swift). `WindowButton` wraps the internal binding and provides a Window (platform dependent) object.

`WindowButton` looks and behaves like SwiftUI's [Button](https://developer.apple.com/documentation/swiftui/button). It can be initialized in the same way, and have styles applied to it in the same way. 

```swift
// Create a window action button, where a Window object will be provided to the the `action:` closure
WindowButton { window in
    // Do something with `window`...
} label: {
    // Provide the label view for the button
    Text("Hello")
}
```

See more in the [Examples](#Examples) below, or the [WindowButton Playground](Playgrounds/WindowButton.playground/Contents.swift)

## Where it Doesn't Work

If you need access to a window object as an Environment or State object (see this [Stack Overflow thread](https://stackoverflow.com/questions/60359808/how-to-access-own-window-within-swiftui-view)), this is not going to work for you.

 Really, you shouldn't need access to the window object during the initialization of a SwiftUI view, but only when the view is acted upon (like a Button's `action:` closure). SwiftUI itself provides SwiftUI classes to wrap existing functionality in this way, such as `Alert` in place of using `UIAlertViewController` or `NSAlert`.

# Installation
To use **SwiftUIWindowBinder** within your project see how to reference package using the [Swift Package Manager](https://swift.org/package-manager/) or in [Xcode](https://developer.apple.com/videos/play/wwdc2019/408/), using this repository's GitHub link. Once installed you can import **SwiftUIWindowBinder** as appropriate.

## Adding to Package.swift
To add manually in the `Package.swift` use the following reference in your `dependencies` section:

```
dependencies: [
    .package(
        name: "SwiftUIWindowBinder".
        url: "https://github.com/happycodelucky/SwiftUIWindowBinder.git", 
        .upToNextMajor(from: "0.9.0"),
],

targets: [
    .target(
        name: "MyApp", 
        dependencies: [
            .product(name: "SwiftUIWindowBinder", package: "SwiftUIWindowBinder"),
        ])
]
```

## Playgrounds

To run the [SwiftUIWindowBinder Playground](Playgrounds) examples you will need to open the package in Xcode and run any of the playgrounds under `Playgrounds`. 

Be sure to have the options "Render Documentation" and "Build Active Schema" enabled (they are by default) for the best representation, as the Playgrounds serve as working documentation.

# Examples

## Using WindowButton

[`WindowButton`](Sources/SwiftUIWindowBinder/WindowAction.swift) looks and behaves like SwiftUI's [Button](https://developer.apple.com/documentation/swiftui/button). It can be initialized in the same way, and have styles applied to it in the same way. 

Below is a simple example of setting up a `WindowButton`

```swift
// Create a window action button, where a Window object will be provided to the the `action:` closure
WindowButton { window in
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
WindowButton { window in
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
