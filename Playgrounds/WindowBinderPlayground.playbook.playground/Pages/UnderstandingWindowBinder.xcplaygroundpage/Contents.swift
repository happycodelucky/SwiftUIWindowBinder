/*:
 # Understanding WindowBinder

 `WindowBinder` is at the core of capturing a `Window` in your SwiftUI `View`. As it name implies it uses a
 `Bindable` parameter to bind a `Window` to a `@State` property of the view.

 The binder is a view injected into the *actual* view hierarchy in UIKit or AppKit, which updates the bound
 window state property when inserted and made visible for the first time.

 > If you would like to go splunking then check out `WindowBindableView.swift` to see the implementation.
 > `WindowBinder` encapsulates the logic there for simplicitly and consistent presentation across UIKit
 > and AppKit
 */
import SwiftUI
import SwiftUIWindowBinder

struct ContentView : View {
//: You will need a @State property in your view for the binding
    @State var window: Window?

    var body: some View {
/*:
 Anywhere in your view hierarchy you will need to use `WindowBinder`.
 It takes two arguments, `window:` and `content:`

 - `window:` is of `Bindable<Window>`, which should be your `@State` property to bind to, and set a `Window` when available.
 - `content:` is a closure where nested Views can be placed. This
 is only a convenience as it does not matter where in your view you
 place `WindowBinder`, it just needs to be in the view.
 */
        WindowBinder(window: $window) {
/*:
 Some of you may ask, why the `content:` closure doesn't receive a `Window`? Wouldn't that be a great help?!

 > SwiftUI views are not "views" but descriptors of views. The real view is an UIView or NSView
 > produced from this descriptor. As such, a `Window` is not yet avaialble to be received.
 > We'll talk more about this in [What Not to Do with Window]() to avoid a potential pitfall.
 */
/*:
 Next, we have a our view to display, which we'll add an `onTapGesture` modifier to.
 */
            Text("Hello")
                .padding()
/*:
 Use `self.window` in a view modifier, but you will need to guard against possibility of a `nil` Window -
 In practice this should never happen. During initialization `self.window` will be nil.
 */
                .onTapGesture {
                    guard let window = window else {
                        return
                    }

                    // Print the window description
                    print(window.description)
                }
        } // WindowBinder
    }
}
/*:
 Go ahead, **run** the playground now. Tap the label to see the window description printed to the console.
 */
/*:
 To get started, head to [Understanding WindowBinder](@next)
 */


// Present the view controller in the Live View window
import PlaygroundSupport
PlaygroundPage.current.setLiveView(ContentView())





//: [Previous](@previous)


//: [Next](@next)
