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
**SwiftUIWindowBinder** supports SwiftUI access to a host Window object (UIWindow or NSWindow) with *zero set up*. SwiftUI apps with no application delegate or scene delegate can still access the Window, and the window is scoped to each document in a multi-window application.

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
    // In this example it know ``Alert`` can be used from SwiftUI
    // Instead this demonstrates the accessibity of the window tersely

    // Use UIAlertController instead of Alert
    let controller = UIAlertController(title: "Hello", message: "Hello Mum", preferredStyle: .alert)
    controller.addAction(UIAlertAction(title: "Bye", style: .cancel))

    // Present the alert using the window's rootViewController
    window.rootViewController?.present(controller, animated: true) { }
} label: {
    // Provide the label view for the button
    Text("Hello")
}
// Set a button style (using default for placeholder)
.buttonStyle(DefaultButtonStyle())
```

It's that simple.

## Using a Window in Event Modifiers

`WindowButton` comes for free with the package but event modifiers like `onTapGesture` and the like do not have support. The package was originally coded with support for modifiers but increase the complexity of the package/symbol resolution for potentially little usage. So, you really want to create a modifier that supports it? 

Well there's two ways...

### Using WindowBinder Directly

```swift
import SwiftUI
import UIKit

struct ContentView : View {
    // State to bind to in `WindowBinder` use
    @State var window: Window?

    var body: some View {
        WindowBinder(window: $window) {
            Text("Hello")
                .onTapGesture {
                    // Ensure there is a `window` and it has a rootViewController
                    guard let controller = self.window?.rootViewController else {
                        return
                    }

                    // Use UIAlertController instead of Alert
                    let alertController = UIAlertController(title: "Hello", message: "Hello Mum", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Bye", style: .cancel))

                    // Present the alert using the window's rootViewController
                    controller.present(alertController, animated: true) { }
                }
        }
    }
}
```



### Creating A Custom Event Modifier

A `ViewModifier` needs to be created for the event modifier you want to support. Through overriding an existing event view modifier. The pattern below is similar to using `Windowbinder` directly but encapsulating the binding.

```swift
import SwiftUI

/// An on tap gesture modifier for SwiftUI `View`s
@available(tvOS, unavailable)
struct WindowBindableOnTap: ViewModifier {
    @State var window: Window?

    var count: Int
    var action: (Window) -> Void

    func body(content: Content) -> some View {
        WindowBinder(window: $window) {
            content.onTapGesture(count: count) {
                guard let window = self.window else {
                    return
                }

                action(window)
            }
        }
    }
}

@available(tvOS, unavailable)
extension View {
    /// Adds an action to perform when this view recognizes a tap gesture.
    public func onTapGesture(count: Int = 1, perform action: @escaping (Window) -> Void) -> some View {
        return self.modifier(WindowBindableOnTap(count: count, action: action))
    }
}
```

This needs to be repeated for all events you want to support (if you have a way to make this generic let me know). Using the modifier is like using `onTapGesture` in any other way, but now there is an optional `Window` passed.

Now `onTapGesture` can receive a `Window?` parameter

```swift
import SwiftUI
import UIKit

struct ContentView : View {
    var body: some View {
        Text("Hello")
            .onTapGesture { window in
                // In this example it know ``Alert`` can be used from SwiftUI
                // Instead this demonstrates the accessibity of the window tersely

                // Use UIAlertController instead of Alert
                let controller = UIAlertController(title: "Hello", message: "Hello Mum", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Bye", style: .cancel))

                // Present the alert using the window's rootViewController
                window.rootViewController?.present(controller, animated: true) { }
            }
            .padding()
    }
}
```

# What Not To Do!

If you are using `WindowBinder` directly in your `View` **do not** attempt to use the `@State` property for the host window in the creation of the view description. For one, SwiftUI Views are not views but represent views that *will* be in a view hierarchy. SwiftUI also tracks state changes for states used during the construction of a Swift UI View, and will regenerate a new view when said state changes (it will because a Window will be set). For reasons beyond the scope of this readme, we have to use `@State` and `UIWindow` and `NSWindow` are not basic types and are not captured properly as a state so are nil.

This will not produce the correct result, and you will see the UI regenerate multiple times. Adding a print statement show this.

```swift
import SwiftUI
import SwiftUIWindowBinder

struct ContentView : View {
    // State to bind to in `WindowBinder` use
    @State var window: Window?

    var body: some View {
        // Debug print statement
        print("Rebuilding view - window=\(window != nil ? "object" : "nil")")
      
        WindowBinder(window: $window) {
            // The use of `self.window` during view construction informs SwiftUI to track `window` changes,
            // resulting in multiple calls until SwiftUI bails
          
            // Trying to make the text be based on `window` state (don't do this!)
            Text(window.description ?? "nil")
                .padding()
        }
    }
}
```