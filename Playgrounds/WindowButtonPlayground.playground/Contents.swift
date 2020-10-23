/*:
 # WindowButton Playground
 
 > Be sure to have the `SwiftUIWindowBinder` schema selected.
 > You may choose between the various platform in the Playground Inspector to demonstrate usage across each
 
 `WindowButton` is based on `WindowBinder`. This ensures the window is aways accessible
 when the view is presented, by determine the window at runtime when the view is added to a view hierachy.
 
 A benefit of this approach is no set up, so no passing of a platform window object during app launch or
 via a scene presentation. Additionally, as you'll see, this works with Playgrounds and SwiftUI apps without
 `AppDelegate` or `SceneDelegate` implementations.
 */
import SwiftUI
import PlaygroundSupport
import SwiftUIWindowBinder
/*:
 ## Content view
 The `ContentView` hosts a `WindowButton`, where the window is capture in the `action:` closure for use
 */
struct ContentView: View {
    var body: some View {
        VStack(alignment: .center, spacing: nil, content: {
/*:
 ### Window Action Handling
 Add an action handler to the `WindowActionButton`. The closure will be passed a
 platform dependent `Window` object (UIWindow or NSWindow) to work with. It's here
 where the window may be used to interop with UIKit or AppKit where a window or a
 view controller is needed.
 */
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
                Text("Hello Button")
            }
            .buttonStyle(BlueButtonStyle())
        }).padding()
    }
}
/*:
 ## Button Styling
 For cross-platform consistency with SwiftUI, create a simple `ButtonStyle` to use with
 the `WindowButton` in the `ContentView` above
 */
struct BlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(12)
            .foregroundColor(Color.white)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous).fill(
                    configuration.isPressed ? Color.blue.opacity(0.8) : Color.blue))
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.setLiveView(ContentView())
