/*:
 # Using WindowButton

 Buttons are probably where window related actions may be used most. For convience `WindowButton` wraps the logic of
 `WindowBinder` and allow the `action:` closure to receive a `Window` when interacted with.
 */
import SwiftUI
import SwiftUIWindowBinder
/*:
 ## Function Requiring a UIWindow or NSWindow

 In a hyperthetical example, lets assume `Alert` doesn't exist in SwiftUI. Presenting an alert in UIKit or AppKit
 requires a `UIViewController` or `NSWindow` respectively. This function does the job of using a `Window` to
 present the alert.

 > `Window` is a platform abstraction of `UIWindow` or `NSWindow`
 */
func presentWindowAlert(onWindow window: Window) {
    let title = "Hello"
    let message = "Hello Mum"
    let buttonTitle = "Bye!"

    // In this example it know ``Alert`` can be used from SwiftUI
    // Instead this demonstrates the accessibity of the window tersely

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
    alert.informativeText = "\(message) on screen '\(window.screen.localizedName ?? "Unknown screen")'"
    alert.addButton(withTitle: buttonTitle)

    alert.beginSheetModal(for: window)

#endif
}
/*:
 ## Content view
 The `ContentView` hosts a `WindowButton`, where the window is capture in the `action:` closure for use
 */
struct ContentView: View {
    var body: some View {
        VStack(alignment: .center, spacing: nil, content: {
            Text("Tap the button below")
                .font(.headline)
                .padding()
/*:
 ### Window Action Handling
 Add an action handler to the `WindowButton`. The closure will be receive a platform dependent
 `Window` object (UIWindow or NSWindow) to work with. It's here where the window may be used
 to interop with UIKit or AppKit where a window or a view controller is needed.
 */
            WindowButton { window in
                // Call a function needing a Window
                presentWindowAlert(onWindow: window)
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
