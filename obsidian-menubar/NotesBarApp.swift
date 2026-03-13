//
//  NotesBarApp.swift
//  obsidian-menubar
//
//  Created by Aman Raj on 18/5/25.
//

import SwiftUI

@main
struct NotesBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings { EmptyView() }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var panel: NSPanel!
    private let vaultViewModel = VaultViewModel()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "archivebox", accessibilityDescription: "Obsidian Menubar")
            button.action = #selector(togglePanel)
            button.target = self
        }

        // Create floating panel
        let contentView = ContentView().environmentObject(vaultViewModel)
        panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 600),
            styleMask: [.titled, .closable, .nonactivatingPanel, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        panel.titleVisibility = .hidden
        panel.titlebarAppearsTransparent = true
        panel.isMovableByWindowBackground = true
        panel.level = .floating
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.isReleasedWhenClosed = false
        panel.contentView = NSHostingView(rootView: contentView)
        panel.backgroundColor = NSColor(white: 0.15, alpha: 0.95)
    }

    @objc private func togglePanel() {
        if panel.isVisible {
            panel.orderOut(nil)
        } else {
            // Position panel below the status item
            if let button = statusItem.button {
                let buttonFrame = button.window!.convertToScreen(button.convert(button.bounds, to: nil))
                let panelWidth = panel.frame.width
                let panelHeight = panel.frame.height
                let x = buttonFrame.midX - panelWidth / 2
                let y = buttonFrame.minY - panelHeight - 4
                panel.setFrameOrigin(NSPoint(x: x, y: y))
            }
            panel.makeKeyAndOrderFront(nil)
        }
    }
}
