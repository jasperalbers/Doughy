//
//  DoughyApp.swift
//  Doughy
//
//  Created by Jasper on 20.05.24.
//

import SwiftUI

@main
struct DoughyApp: App {
    @ObservedObject var batteryInfo = BatteryInfo()
    @StateObject private var settings = Settings()
    @State private var isShowingSettings = false
    @State private var isVisible = false
    
    var body: some Scene {
        MenuBarExtra {
            ContentView(batteryInfo: batteryInfo, isShowingSettings: $isShowingSettings)
                .environmentObject(settings)
                .onAppear {
                        NotificationCenter.default.addObserver(
                            forName: NSWindow.didChangeOcclusionStateNotification, object: nil, queue: nil)
                        { notification in
                            if !(notification.object as! NSWindow).isVisible {
                                isShowingSettings = false
                            }
                        }
                    }

        } label: {
            // Custom label with resized SF Symbol
            Image(nsImage: createCustomSizedSymbol(name: batteryInfo.batteryIcon, size: 19))
        }
        .menuBarExtraStyle(.window)
    }
    
    // Function to create an NSImage with a custom size and hierarchical rendering mode
    func createCustomSizedSymbol(name: String, size: CGFloat) -> NSImage {
        let primaryColor = NSColor(Color.primary)
        let config = NSImage.SymbolConfiguration(pointSize: size, weight: .light, scale: .medium)
            .applying(.init(hierarchicalColor: primaryColor))
        let image = NSImage(systemSymbolName: name, accessibilityDescription: nil)?
            .withSymbolConfiguration(config)
        return image ?? NSImage()
    }
}
        
        
