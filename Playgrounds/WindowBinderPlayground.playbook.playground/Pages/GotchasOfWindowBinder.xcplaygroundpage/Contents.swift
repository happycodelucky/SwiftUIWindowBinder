/*:
 [Previous Page](@previous)
 # WindowBinder - What Not to Do!

 Attempting to access the `@State var window` property from within the *construction* of a view, that is not inside
 an escaping closure, will cause SwiftUI to track state changes on `window`.

 This seems ideal but a host window
 object will not be availble until the underlying `UIView` or `NSView` is in the actual view hierarchy.

 To see this in action keep reading. But first, run the playground to see what happens
 */
import SwiftUI
import SwiftUIWindowBinder
/*:
 ## Conditionals
 Change the conditionals here to change the playground execution
 */
struct Conditions {
    /// When set to `true`, a window @State property will be used in view construction.
    ///
    /// First run with `false` and later, when instructed, change to `true`
    static let useWindow = true
}
/*:
 ## Content view
 Our playground's live content view
 */
struct ContentView : View {
    //: Use a state property to capture the `Window` from `WindowBinder` (below)
    // Use a state property to capture the Window from WindowBinder (below)
    @State var window: Window?

    /// View body
    var body: some View {
        // Add some logging so we can see what's going on
        print("Building ContentView...")
        if (Conditions.useWindow) {
            // Here we are using `self.window` so it needs to be under the conditional
            print("> window=\(window?.debugDescription ?? "nil")")
        }

        return WindowBinder(window: $window) {
            // The use of `self.window` during view construction informs SwiftUI to track `window` changes,
            // resulting in multiple calls until SwiftUI bails

            // Trying to make the text be based on `window` state (don't do this!)
            if Conditions.useWindow {
                Text(window?.description ?? "nil")
                    .font(.title)
                    .padding()
            } else {
                Text("Hello")
                    .font(.title)
                    .padding()
            }


        }
    }
}



// Present the view controller in the Live View window
import PlaygroundSupport
PlaygroundPage.current.setLiveView(ContentView())
