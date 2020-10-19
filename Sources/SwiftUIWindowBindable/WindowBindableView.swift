//
//  WindowAccessibleButton.swift
//  SwiftUITnker
//
//  Created by Paul Bates on 10/12/20.
//

import SwiftUI

#if canImport(UIKit)
import UIKit

public typealias Window = UIWindow

/// A host window bindable view controller to determine the host window on display
@available(iOS 13.0, *)
final private class WindowBindableViewController: UIViewController {
    /// Binding for view's host window
    @Binding var hostWindow: Window?

    /// No supported
    required init?(coder: NSCoder) {
        return nil // REVIEW: Does this infer with state restoration?
    }

    /// Initialized the view controller with a host window binding
    ///
    /// Parameters:
    ///     - window: Host window binding
    init(window: Binding<Window?>) {
        _hostWindow = window

        super.init(nibName: nil, bundle: nil)
    }

    // MARK: UIViewController

    override func loadView() {
        super.loadView()

        // Set up layout
        view.frame = .zero
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        view.translatesAutoresizingMaskIntoConstraints = false

        // No interaction support
        view.isAccessibilityElement = false
        view.isUserInteractionEnabled = false
    }

    override func viewDidAppear(_ animated: Bool) {
        hostWindow = view.window

        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        hostWindow = nil
    }
}

/// A SwiftUI view that is able to expose a hosted window
@available(iOS 13.0, *)
public struct WindowBindableView: UIViewControllerRepresentable {
    @Binding public var hostWindow: Window?

    // MARK: UIViewControllerRepresentable

    public func makeUIViewController(context: Context) -> UIViewController {
        WindowBindableViewController(window: $hostWindow)
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

#elseif canImport(AppKit)
import AppKit

public typealias Window = NSWindow

/// A host window bindable view controller to determine the host window on display
@available(macOS 10.15, *)
final private class WindowBindableViewController: NSViewController {
    /// Binding for view's host window
    @Binding var hostWindow: Window?

    /// No supported
    required init?(coder: NSCoder) {
        return nil // REVIEW: Does this infer with state restoration?
    }

    /// Initialized the view controller with a host window binding
    ///
    /// Parameters:
    ///     - window: Host window binding
    init(window: Binding<Window?>) {
        _hostWindow = window

        super.init(nibName: nil, bundle: Bundle.main)
    }

    // MARK: NSViewController

    override func loadView() {
        // Create view
        view = NSView(frame: .zero)

        // Set up layout
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        view.translatesAutoresizingMaskIntoConstraints = false

        // No user interaction
        view.setAccessibilityRole(.none)
    }

    override func viewDidAppear() {
        hostWindow = view.window

        super.viewDidAppear()
    }

    override func viewWillDisappear() {
        super.viewWillDisappear()

        hostWindow = nil
    }
}

/// A SwiftUI view that is able to expose a hosted window
@available(macOS 10.15, *)
public struct WindowBindableView: NSViewControllerRepresentable {
    @Binding public var hostWindow: Window?

    // MARK: UIViewControllerRepresentable

    public func makeNSViewController(context: Context) -> NSViewController {
        WindowBindableViewController(window: $hostWindow)
    }

    public func updateNSViewController(_ uiViewController: NSViewController, context: Context) { }
}
#endif
