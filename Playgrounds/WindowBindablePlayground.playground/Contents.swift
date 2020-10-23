import SwiftUI
import PlaygroundSupport
import SwiftUIWindowBindable

struct ContentView : View {
    @State var window: Window?

    var body: some View {
        WindowBinder(window: $window) {
            Text("Hello")
                .padding()
                .onLongPressGesture {
                    if let window = window {
                        print(window.description)
                    }
                }
        }
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.setLiveView(ContentView())
