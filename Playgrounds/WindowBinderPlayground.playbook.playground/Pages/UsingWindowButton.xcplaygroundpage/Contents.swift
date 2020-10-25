/*:
 [Welcome](Welcome) | [Previous Page](@previous)
 # Using WindowButton

 Buttons are probably where window related actions may be used most. For convience `WindowButton`
 wraps the logic of `WindowBinder` and provides the `action:` closure to with a platform depedendent
 `Window` when interacted with.
 */
import SwiftUI
import SwiftUIWindowBinder
/*:
 ## Supplimentary Code

 ### A Function Requiring a UIWindow or NSWindow

 In a hyperthetical scenario, lets assume `Alert` doesn't exist in SwiftUI. Presenting an alert in
 UIKit or AppKit requires a `UIViewController` or `NSWindow`. This function implements the use of
 `UIAlertController`/`NSAlert` to demonstrate the use of Window later.

 The implementation is not important here, just that a function exists requiring a `UIWindow` or
 `NSWindow` (remember `Window` is a platform abstraction to represent both).
 */
func presentWindowAlert(withWindow window: Window) {
    let title = "Hello"
    let message = "Hello Mum"
    let buttonTitle = "Bye!"

#if canImport(UIKit)

    // Use UIAlertController instead of Alert
    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
    controller.addAction(UIAlertAction(title: buttonTitle, style: .cancel))

    window.rootViewController?.present(controller, animated: true) { }

#elseif canImport(AppKit)

    // Use NSAlert instead of Alert
    let alert = NSAlert()
    alert.messageText = title
    // AppKit has a localizedName for the screen, for extra flair
alert.informativeText = "\(message) on screen '\(window.screen?.localizedName ?? "Unknown screen")'"
    alert.addButton(withTitle: buttonTitle)

    alert.beginSheetModal(for: window)

#endif
}
/*:
 ## Content view
 In the content view we'll be using `WindowButton` instead of SwiftUI's `Button`. The are almost
 identical in usage. The diffence being is `WindowButton`'s `action:` closure will receive a `Window`
 argument.

 Using `WindowButton` instead of `WindowBinder` cleans up the content view as there is no explict
 state variable and binding.
 */
struct ContentView: View {
    var body: some View {
        VStack(alignment: .center, spacing: nil, content: {
            // Some helpful text
            Text("Tap the button below")
                .font(.headline)
                .padding()

/*:
 ### Adding WindowButton
 Initialize a `WindowButton` that calls our `presentWindowAlert(withWindow:)` function.

 > If for some reason there is not `Window` (it's `nil`) the `action` clouser will not be called.

 `WindowButton` is much like `Button`, it can even be styled in exactly the same way.
 */
            // Our button that receives a `Window` when interacted with
            WindowButton { window in
                // Make a call with the passed `window: Window`
                presentWindowAlert(withWindow: window)
            } label: {
                Text("Hello Button")
            }
            // Use our custom style defined below (this just makes things look a little nicer)
            .buttonStyle(BlueButtonStyle())
/*:
 Go ahead, **run** the playground now on iOS or macOS. Tap the button to see the platform alert.
 */
        }).padding(50)
    }

    /// For cross-platform consistency with SwiftUI, create a simple `ButtonStyle` to use with
    /// the `WindowButton` in the `ContentView` above
    private struct BlueButtonStyle: ButtonStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .padding(12)
                .foregroundColor(Color.white)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(
                        configuration.isPressed ? Color.blue.opacity(0.8) : Color.blue))
        }
    }
}

/*:
 Next, [WindowBinder - What Not to Do!](@next)
 */
/*:
 */
// Present the view controller in the Live View window
import PlaygroundSupport
PlaygroundPage.current.setLiveView(ContentView())
