/*:
 [Welcome](Welcome) | [Previous Page](@previous)
 # Understanding WindowBinder

 `WindowBinder` is at the core of capturing a `Window` in your SwiftUI `View`. As it name implies it uses a
 `Bindable` parameter to bind a `Window` to a `@State` property of the view (`Window` is a platform abstraction
 type alias for `UIWindow` or `NSWindow`).

 A WindowBinder is a view injected into the *actual* view hierarchy in UIKit or AppKit, able to tap into the
 hosted UIWindow or NSWindow respectively.

 > If you would like to go splunking then check out `WindowBindableView.swift` to see the implementation.
 > `WindowBinder` encapsulates the logic there for simplicitly and consistent presentation across UIKit
 > and AppKit
 */
import SwiftUI
import SwiftUIWindowBinder
/*:
 ## Content View
 To use `WindowBinder`, it's often easiest to but it at the root of your view returned from `body`, or isolated to just the
 view/view modifier you'll need access to.

 Do not be tempted to use multiple WindowBinders as this repeats work unnecessarily.

 `WindowBinder` initialization takes two arguments, `window:` and `content:`

 - `window:` is of `Bindable<Window>`, which should be your `@State` property to bind to, and set a `Window` when available.
 - `content:` is a closure where nested Views can be placed.

 The `content:` is only a convenience as it does not matter where in your view you place `WindowBinder,
 it just needs to be in the hierarchy to function.
 */
struct ContentView : View {
    /// You will need a `@State` property in your view for the binding
    @State var window: Window?

    /// View body
    var body: some View {
        // Create a WindowBinder and bind it to the state property `window`
        WindowBinder(window: $window) {
/*:
 Now we are here, some of you may ask: Why does the `content:` closure doesn't receive a `Window`? Wouldn't that be a great help?!

 > SwiftUI views are not "views" but really descriptors of views. The real view is an `UIView` or `NSView`
 > produced from this descriptor. As such, a `Window` is not yet avaialble to be received.
 > We'll talk more about this in [What Not to Do with Window]() to avoid a potential pitfall.
 */
/*:
 ### Using the Window
 Lets create a `Text` view with an `onTapGesture` modifier on it. When the text is tapped, the bound window description will
 be printed to the console (you can do this with other event based modifiers too, like `onDrop`, ...)

 Using `self.window` in a view modifier you will need to guard against possibility of a `nil` Window -
 In practice this should never happen for gensture modifiers as a view will need to be in the
 UIKit/AppKit view hierarchy.
 */
            Text("Hello")
                .padding()
                .onTapGesture {
                    guard let window = window else {
                        return
                    }

                    // Print the window description
                    print(window.description)
                }
/*:
 Go ahead, **run** the playground now. Tap the label to see the window description printed to the console.
 */
        }.padding(50)
    }
}

/*:
 Next, [Using `WindowButton`](@next)
 */
/*:
 */
// Present the view controller in the Live View window
import PlaygroundSupport
PlaygroundPage.current.setLiveView(ContentView())
