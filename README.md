# SwiftUIWindowBinder

![Swift Version](https://img.shields.io/badge/swift-5.2-blue.svg?style=for-the-badge)
![iOS Version](https://img.shields.io/badge/iOS-13.0-green.svg?style=for-the-badge)
![macOS Version](https://img.shields.io/badge/macOS-10.15-green.svg?style=for-the-badge)
![tvOS Version](https://img.shields.io/badge/tvOS-13-green.svg?style=for-the-badge)
![watchOS Version](https://img.shields.io/badge/watchOS-UNSUPPORTED-red.svg?style=for-the-badge)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge)](.//LICENSE)
[![Maintained](https://img.shields.io/badge/Maintained%3F-yes-green.svg?style=for-the-badge)](https://github.com/happycodelucky/SwiftUIWindowBinder/graphs/commit-activity)
![Release](https://img.shields.io/github/v/release/happycodelucky/SwiftUIWindowBinder.svg?style=for-the-badge)

# Overview

**SwiftUIWindowBinder** supports getting SwiftUI access to a host Window object ([UIWindow](https://developer.apple.com/documentation/uikit/uiwindow) or [NSWindow](https://developer.apple.com/documentation/appkit/nswindow)) with *zero set up*. SwiftUI apps [without an application delegate](https://developer.apple.com/documentation/swiftui/app) or scene delegate can still access the Window, and the window is scoped to each document in a multi-window application. Playgrounds are also supported here.

# Installation
To use **SwiftUIWindowBinder** within your project see how to reference package using the [Swift Package Manager](https://swift.org/package-manager/) or in [Xcode](https://developer.apple.com/videos/play/wwdc2019/408/), using this repository's GitHub link. Once installed you can import **SwiftUIWindowBinder** as appropriate.

## Adding to Package.swift
To add manually in the `Package.swift` use the following reference in your `dependencies` section:

```
dependencies: [
    .package(
        name: "SwiftUIWindowBinder".
        url: "https://github.com/happycodelucky/SwiftUIWindowBinder.git", 
        .upToNextMajor(from: "1.0.0"),
],

...
```

# Usage & Examples

Documentation here on the README.md is light. There's not a whole lot to the package, you are encouraged to explore the code and offer fixes/comments on better ways, or additions you might like.

This package does come with ample documentation (I hope), through a set of [Swift Playgrounds](https://developer.apple.com/documentation/swift_playgrounds) pages in the package itself. Walk through the documentation, run the code, and definitely *read up about the Gotchas*! 

> The playgrounds examples are still in draft. They are all runnable, just watch out for some typos.

In good conscience I can't have no code on a README, so look out below.

## Playgrounds

To run the [SwiftIWindowBinder Playground](https://github.com/happycodelucky/SwiftUIWindowBindableView/tree/main/Playgrounds/WindowBinderPlayground.playground) examples you will need to open the package in Xcode and run any of the playgrounds under `Playgrounds`. 

Be sure to have the options '**Render Documentation**' and '**Build Active Schema**' enabled (they are by default) for the best representation, as the Playgrounds serve as working documentation.

> Although the package supports iOS 13, macOS 10.15, and tvOS 13, you will need to use Xcode 12.2 to run the playgrounds. **If you are on Catalina (macOS 10.15) then the 'macOS' target for the playground will not run** due to requiring Big Sur (macOS 11) to run some of the SwiftUI code.

## Examples 

There are only two real examples of demonstrate here. Using something called `WindowBinder` and a convenience called `WindowButton`. As the playground Wrapping Up documentation eludes to, there could be more done here (such as supporting event view modifiers like `onTapGesture`), but was chosen to avoid. If you want to know more, read through the Playgrounds ;).

### WindowBinder

[`WindowBinder`](Sources/SwiftUIWindowBinder/WindowBinder.swift) is at the core of capturing a `Window` in your SwiftUI `View`. As it name implies it uses a [`Binding`](https://developer.apple.com/documentation/swiftui/binding) parameter to bind a `Window` to a `@State` property of the view (`Window` is a platform abstraction type alias for `UIWindow` or `NSWindow`).

> A `WindowBinder` is a view injected into the *actual* view hierarchy in UIKit or AppKit, able to tap into the hosted `UIWindow` or `NSWindow` respectively.

The following show the use of `WindowBinder` , binding to `self.$window`, followed by the trailing closure for the content views. The closure contains a [Text](https://developer.apple.com/documentation/swiftui/text) view with the `onTapGesture` view modifier using the bound `window` property.

```swift
import SwiftUI
import SwiftUIWindowBinder

struct ContentView : View {
    /// You will need a `@State` property in your view for the binding
    @State var window: Window?

    /// View body
    var body: some View {
        // Create a WindowBinder and bind it to the state property `window`
        WindowBinder(window: $window) {
          
            Text("Hello")
                .padding()
                .onTapGesture {
                    // `self.window` will be nil initially, until (this) View's actual view is in the
                    // hosted window hierarchy
                    guard let window = window else {
                        return
                    }

                    // Print the window description
                    print(window.description)
                }
          
        }
    }
}
```

There is no requirement your view be authored in this way. `WindowBinder` is not required to be a root view, or even contain any of your view element, it just needs to be in your view. Below is an acceptable alternative. The content closure is a convenience to avoid the need for a stack.

```swift
struct ContentView : View {
    @State var window: Window?

    var body: some View {
        ZStack(alignment: .center, content: {
            WindowBinder(window: $window) { /* Nothing */ }
          
            Text("Hello")
                .padding()
                .onTapGesture { /* ... */}
        }
    }
}
```

### WindowButton

Buttons are probably where window related actions may be used most. For convenience [`WindowButton`](Sources/SwiftUIWindowBinder/WindowButton.swift) wraps the logic of `WindowBinder` and provides the `action:` closure to with a platform dependent `Window` when interacted with.

Modifying the example above we get a much simpler looking ContentView:
```swift
import SwiftUI
import SwiftUIWindowBinder

struct ContentView : View {
    /// View body
    var body: some View {
      
        // Our button that receives a `Window` when interacted with
        WindowButton { window in
            // Print the window description
            print(window.description)
        } label: {
            Text("Hello")
        }
        // Just like Button, WindowButton can be styled just the same
        .buttonStyle(DefaultButtonStyle())
      
    }
}
```

Unlike the `WindowBinder` example there is no guard for `window`. This is because in the case there is no host window the button `action:` closure will not be called. Given the architecture of SwiftUI/UIKit/AppKit you would need to be doing something out of the ordinary to interact with a view that's not in a host window's view hierarchy. 

## Wait, There WindowButton But No Event View Modifiers?

Correct! For good reasons. Checkout the [Wrapping Up](Playgrounds/WindowBinderPlayground.playground/Pages/WrappingUp.xcplaygroundpage/Contents.swift) for those reasons and if you really, really want it, a code example.

 # Enjoy!

SwiftUI is evolving, getting a ton of new features each release. This package represents a bit of a [polyfill](https://en.wikipedia.org/wiki/Polyfill_(programming)) assistance (hello JavaScript + Babel nomenclature) until the time when we have official wrappers for the things we want.

I don't see UIKit or AppKit disappearing from beneath SwiftUI anytime soon (likely never), and a few of us will continue to find a need for such things like this package.

Of course, bugs, issues, pull requests, corrections, suggestions, or comments fire away...

