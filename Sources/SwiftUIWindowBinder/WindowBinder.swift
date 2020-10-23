//
//  SwiftUIWindowBinder.swift
//  SwiftUIWindowBinder
//
//  Created by Paul Bates on 10/19/20.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// Use WindowBinder in your view hierarchy to capture a host `Window` and bind it to the container view's state
///
///     struct ContentView {
///         @State private var window: WindowBinder.Window?
///
///         var body: some View {
///             WindowBinder(hostWindow: $window) {
///                 Text("Hello")
///                     .onTapGesture {
///                         print(window?.description ?? "nil")
///                     }
///             }
///         }
///
public struct WindowBinder<Content> : View where Content : View {
    //// Host window based on presentation of view
    @Binding private var window: Window?

    /// Content view to expose
    private var content: () -> Content

    #if canImport(UIKit)
    public typealias Window = UIWindow
    #elseif canImport(AppKit)
    public typealias Window = NSWindow
    #endif

    ///
    public init(window: Binding<Window?>, @ViewBuilder content: @escaping () -> Content) {
        self._window = window
        self.content = content
    }

    // MARK: View

    public var body: some View {
        ZStack(alignment: .center, content: {
            // Add bindindable view to hierachy to tap UIKit/AppKit view hierarchy
            WindowBindableView(hostWindow: $window)
                .frame(minWidth: 0, idealWidth: 0, maxWidth: 0, minHeight: 0,
                       idealHeight: 0, maxHeight: 0, alignment: .center)

            // Original label
            content()
        })
    }
}
