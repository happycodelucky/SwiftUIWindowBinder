/*:
 # WindowBinder What Not to Do!

 > Be sure to have the `SwiftUIWindowBinder` schema selected.
 > You may choose between the various platform in the Playground Inspector to demonstrate usage across each

 Attempt to access the `@State var window` property from within the construction of a view, that is not inside
 an escaping closure, will cause SwiftUI to track state changes on `window`. This seems ideal but a host window
 object will not be availble until the underlying `UIView` or `NSView` is in the actual view hierarchy.

 To see this in action keep reading. But first, run the playground to see what happens
 */
import SwiftUI
import SwiftUIWindowBinder
import PlaygroundSupport
/*:
 */
struct ContentView : View {
//: Use a state property to capture the `Window` from `WindowBinder` (below)
    // Use a state property to capture the Window from WindowBinder (below)
    @State var window: Window?

    var body: some View {
        //: ss
        print("Building ContentView...")
        if (Conditions.useWindow) {
            print("> window=\(window?.debugDescription ?? "nil")")
        }

        return WindowBinder(window: $window) {
            // The use of `self.window` during view construction informs SwiftUI to track `window` changes,
            // resulting in multiple calls until SwiftUI bails

            // Trying to make the text be based on `window` state (don't do this!)
            if Conditions.useWindow {
                Text(window?.description ?? "nil")
                    .padding()
            } else {
                Text("Hello")
                    .padding()
            }
        }
    }
}

struct Conditions {
    static let useWindow = true
}

// Present the view controller in the Live View window
PlaygroundPage.current.setLiveView(ContentView())
