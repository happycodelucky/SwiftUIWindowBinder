/*:
 # Welcome to The WindowBinder Playgrounds

 > Be sure to have the `SwiftUIWindowBinder` schema selected to run any playground here
 > You may choose between the various platform in the Playground Inspector to demonstrate usage across each

 All the playground here should work with iOS 14, macOS 11 (Big Sur), and tvOS 14.
 */
/*:
 ## Playgrounds to Explore
 There are multiple playgrounds to explore here, walking you through fundamentals and gotchas.

 1. [Understanding WindowBinder](UnderstandingWindowBinder)
 2. [Using WindowButton](UsingWindowButton)
 2. [WindowBinder - What Not to Do!](GotchasOfWindowBinder)
 3. [Wrapping Up](WrappingUp)
 */
/*:
 ## A Taster
 We can't in good conscience have a welcome page without any code, so here's a taster...

 > Tap/Click the welcome button to see a print out of the host window
 */
import SwiftUI
import SwiftUIWindowBinder

struct ContentView : View {
    @State var window: Window?

    var body: some View {
        WindowButton { window in
            // Determine the screen name, or description if not name is available
            var screenName: String
            #if canImport(AppKit)
            screenName = window.screen?.localizedName ?? "Unknown screen"
            #elseif canImport(UIKit)
            screenName = window.screen.description
            #endif

            print("Window screen: \(screenName)")
        } label: {
            Text("Welcome to WindowBinder")
                .padding()
        }
    }
}
/*:
 To get started, head to [Understanding WindowBinder](@next)
 */

// Present the view controller in the Live View window
import PlaygroundSupport
PlaygroundPage.current.setLiveView(ContentView())
