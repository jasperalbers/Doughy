//
//  DropdownButton.swift
//  Doughy
//
//  Created by Jasper on 20.05.24.
//

import SwiftUI

struct dropdownButton: View {
    let action: () -> Void
    let shortcutKey: Character?
    @Binding var isHovered: Bool
    let label: String

    init(action: @escaping () -> Void, shortcutKey: Character? = nil, isHovered: Binding<Bool>, label: String) {
        self.action = action
        self.shortcutKey = shortcutKey
        self._isHovered = isHovered
        self.label = label
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Text(label)
                Spacer()
                if let shortcutKey = shortcutKey {
                    Text("⌘\(shortcutKey)")
                        .foregroundStyle(.tertiary)
                }
            }
            .background(Color(.clear))
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(isHovered ? Color.gray.opacity(0.3) : Color.clear)
                    .padding(.leading, -8) // Adjust padding to make the rectangle larger
                    .padding(.trailing, -8) // Adjust padding to make the rectangle larger
                    .padding(.top, -4) // Adjust padding to make the rectangle larger
                    .padding(.bottom, -4) // Adjust padding to make the rectangle larger
            }
            .onHover { hovering in
                isHovered = hovering
            }
        }
        .buttonStyle(PlainButtonStyle()) // Use plain button style to remove button appearance
        .applyIf(shortcutKey != nil) { view in
            view.keyboardShortcut(KeyEquivalent(shortcutKey!), modifiers: [.command])
        }
    }
}

extension View {
    func applyIf<T: View>(_ condition: Bool, transform: (Self) -> T) -> some View {
        Group {
            if condition {
                transform(self)
            } else {
                self
            }
        }
    }
}