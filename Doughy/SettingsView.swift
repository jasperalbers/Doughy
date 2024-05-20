//
//  SettingsView.swift
//  Doughy
//
//  Created by Jasper on 20.05.24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    @Binding var isShowingSettings: Bool
    @State private var isHoveredBack = false
    @State private var isHoveredURL = false
    @Environment(\.openURL) var openURL
    

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading) {
                Text("Preferences")
                    .fontWeight(.semibold)
            }
            
            VStack(alignment: .leading) {
                Toggle("Show Battery Bar", isOn: $settings.showBatteryBar)
            }

            Divider()
            dropdownButton(
                action: {
                    if let url = URL(string: "https://github.com/jasperalbers/Doughy") {
                        openURL(url)
                    }
                },
                isHovered: $isHoveredURL,
                label: "Github Repository"
            )
            dropdownButton(
                action: { isShowingSettings = false },
                isHovered: $isHoveredBack,
                label: "Back"
            )
        }
        .frame(width: 250)
        .padding(.leading, 13)
        .padding(.trailing, 13)
        .padding(.top, 13)
        .padding(.bottom, 12)
    }
}

class Settings: ObservableObject {
    @Published var showBatteryBar: Bool = false

}
