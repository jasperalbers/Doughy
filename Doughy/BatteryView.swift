//
//  BatteryView.swift
//  Doughy
//
//  Created by Jasper on 20.05.24.
//

import SwiftUI
import IOKit.ps
import Foundation

struct BatteryView: View {
    @ObservedObject var batteryInfo: BatteryInfo
    @State private var isHoveredBatterySettings = false
    @State private var isHoveredPreferences = false
    @State private var isHoveredQuit = false
    @EnvironmentObject var settings: Settings
    @Binding var isShowingSettings: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 40) {
                Text("Battery")
                    .fontWeight(.semibold)
                Spacer()
                Text("\(batteryInfo.percentage)%")
                    .foregroundStyle(.secondary)
            }
            
            if settings.showBatteryBar {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 30)
                        .frame(width: 250, height: 10)
                        .foregroundStyle(.quaternary)
                    
                    RoundedRectangle(cornerRadius: 30)
                        .frame(width: 250 * Double(batteryInfo.percentage) / 100, height: 10)
                        .foregroundStyle(settings.selectedColor)
                    
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Power Source: \(batteryInfo.status)")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    
                    //            Divider()
                    
                    
                    Text("Time Remaining: \(batteryInfo.timeRemaining)")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
            

                Divider()
                
                
                dropdownButton(
                    action: { if let url = URL(string: "x-apple.systempreferences:com.apple.preference.battery") {
                        NSWorkspace.shared.open(url)
                    } },
                    shortcutKey: "B",
                    isHovered: $isHoveredBatterySettings,
                    label: "Battery Settings"
                )
                dropdownButton(
                    action: { isShowingSettings = true },
                    shortcutKey: ",",
                    isHovered: $isHoveredPreferences,
                    label: "Preferences"
                )
//                .sheet(isPresented: $showingSettings) {
//                    SettingsView()
//                        .environmentObject(settings)
//                }
                
                dropdownButton(
                    action: { NSApplication.shared.terminate(nil) },
                    shortcutKey: "Q",
                    isHovered: $isHoveredQuit,
                    label: "Quit"
                )
            }
        }
        .frame(width: 250)
        .padding(.leading, 13)
        .padding(.trailing, 13)
        .padding(.top, 13)
        .padding(.bottom, 9)
        
    }
}

