/*:
 [Welcome](Welcome) | [Previous Page](@previous)
 # Wrapping Up

 The two major take aways from the `SwiftUIWindowBinder` package is `WindowButton` and `WindowBinder`. They both operate alike
 with different encapsulation.

 ## What, No View Modifiers?
 No, I'm not being lazy here. I did write a few [View Modifiers](https://developer.apple.com/documentation/swiftui/viewmodifier),
 stopped myself, and removed them. `WindowButton` was all the convenience I wanted to expose and I even thought if I should do
 that.

 I had a few objections to including them:
 1. Lots of boilerplate code, and maintenance here when SwiftUI changes
 2. Overloading futureproofing (if Apple decides to overload `onTapGesture`'s `action:` to receive something else)
 3. Most important - providing a `Window` to buttons or event oriented view modifiers isn't actual "The Right Way" (see next section)
 */
/*:
 ### Custom ViewModifiers
 But, if you really must, here's the code for overloading the `onTapGesture` (now optionally receives a `Window`).
 Repeat for all modifiers you want to support.
 */
 import SwiftUI
 import SwiftUIWindowBinder

 @available(tvOS, unavailable)
 struct WindowBinderOnTap: ViewModifier {
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
        return self.modifier(WindowBinderOnTap(count: count, action: action))
    }
 }
/*:
 ## The Right Way
 `WindowButton` is a convenience, it gets you where you need to get to. Eventually you code will replace `WindowButton` with
 `Button` as SwiftUI matures and new native SwiftUI functions become available.

 What I mean by "The Right Way" is you code should be using a wrapper, if possible, not accessing a `UIWindow`/`NSWindow`
 directly. For me personally, and why this package was created, something like `ASWebAuthenticationSession` should have a
 wrapper much like `Alert` is for `UIAlertViewController`/`NSAlert` in SwiftUI. The right way is instead to create a
 SwiftUI wrapper for `ASWebAuthenticationSession` using `WindowBinder`, and not use `ASWebAuthenticationSession` directly
 in a Button's `action:` closure (or a view modifier).
 */
/*:
 # Enjoy!
 SwiftUI is evolving, getting a ton of new features each release. This package represents a bit of a
 [polyfill](https://en.wikipedia.org/wiki/Polyfill_(programming)) assistance (hello JavaScript + Babel nomenclature) until
 the time when we have official wrappers for the things we want.

 I don't see UIKit or AppKit disappearing from beneath SwiftUI anytime soon (likely never), and a few of us will continue
 to find a need for such things like this package.

 Of course, bugs, issues, pull requests, corrections, or comments fire away

 Paul.
 */
