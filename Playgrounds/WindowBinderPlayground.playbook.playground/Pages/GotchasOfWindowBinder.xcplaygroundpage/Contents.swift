/*:
 [Welcome](Welcome) | [Previous Page](@previous)
 # WindowBinder - What Not to Do!

 Ok, time to break things. That's the way to learn right??

 To see this in action keep reading. But first, run the playground to see what happens
 */
import SwiftUI
import SwiftUIWindowBinder
/*:
 ## Content View

 What you are going to see here is the incorrect (for this package at least) use of the bound window state.
 Typically you would use a `@State` property in the construction of you view, but for our `window` this
 will lead to undesired consequences

 > Attempting to access the `@State var window` property from within the *construction* of a view,
 > that is not inside an escaping closure, will cause SwiftUI to track state changes on `window`.

 1. A host window (`UIWindow` or `NSWindow`) object will be `nil` until the underlying `UIView` or
 `NSView` is in the *actual* view hierarchy and made visible. Remember, these SwiftUI views are not
 real views!
 2. Swift's compiler knows *how* a `@State` property is used. If it's used in construction of the view,
 the view will be invalidated and regenerated when the state changes (and it will). First the state
 changes when a `Window` is available (presented on screen). Then it will change again because the view is
 invalidated, removed from the *actual* view hierarchy, and rebuilt...

 No better way that a demo. Thankfully Swift Playgrounds clearly shows how many times a line of
 code is called - **pay attention** 😉
 */
struct ContentView : View {
    /// You will need a `@State` property in your view for the binding
    @State var window: Window?

    /// View body
    var body: some View {
/*:
 To show how many times the view is constructed, add some logging to the playground console

 Because some logging uses `self.window` it must be conditionally used to show a before/after (we'll
 change this conditional later)
 */
        // Add some logging so we can see what's going on
        print("Building ContentView...")
        if (Conditions.useWindow) {
            // Here we are using `self.window` so it needs to be under the conditional
            print("> window=\(window?.debugDescription ?? "nil")")
        }
/*:
 Just like other playgrounds, using `WindowBinder`. Only this time (under a conditional) `self.window` is being
 used in the configuration and construction of the SwiftUI View itself.

 By default, `Conditions.useWindow == true`, this can be changed later.
 */
        return WindowBinder(window: $window) {
            // Trying to make the text be based on `window` state (don't do this!)
            if Conditions.useWindow {
                // Using `window` (bad)
                Text(window?.description ?? "nil")
                    .font(.title)
                    .padding()
            } else {
                // Not using `window`
                Text("Hello")
                    .font(.title)
                    .padding()
            }
/*:
 Go ahead, **run** the playground now on iOS or macOS.

 The console should show you something like:
 ```
 Building ContentView...
 > window=nil
 Building ContentView...
 > window=<UIWindow: 0x7fea9850a650; frame = (0 479; 60 66); gestureRecognizers = <NSArray: 0x600003965ce0>; layer = <UIWindowLayer: 0x600003766020>>
 Building ContentView...
 > window=nil
 ```

 The problem is the cycle of changing the `@State` `window` property causes the view to be invalidated and removed
 from the actual view hierarchy. This in turn updated with `window` binding, causing another invalidation.

 > Only use the `@State var window: Window` binding in escaping closures, i.e those that run after the return
 > of the logic in `var body`.
 */
        }
    }
}
/*:
 ### Conditionals
 To extend the demo, try changing the value of `useWindow == false` and re-run.

 > If you are viewing this playground as a dependency package in Xcode, this is read-only.
 */
struct Conditions {
    /// When set to `true`, a `window` property will be used in the ContentView construction.
    static let useWindow = true
}
/*:
 Next, [Wrapping Up](@next)
 */
/*:
 */
// Present the view controller in the Live View window
import PlaygroundSupport
PlaygroundPage.current.setLiveView(ContentView())
