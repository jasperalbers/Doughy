//
//  ContentView.swift
//  Doughy
//
//  Created by Jasper on 20.05.24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var batteryInfo: BatteryInfo
    @Binding var isShowingSettings: Bool

    var body: some View {
        VStack {
            if isShowingSettings {
                SettingsView(isShowingSettings: $isShowingSettings)
            } else {
                BatteryView(batteryInfo: batteryInfo, isShowingSettings: $isShowingSettings)
            }
        }
    }
}
