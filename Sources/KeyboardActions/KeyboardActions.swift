//
//  KeyboardActions.swift
//  KeyboardActions
//
//  Created by Enes Karaosman on 1.04.2024.
//

import SwiftUI

public protocol FieldContract: Hashable {}

public struct KeyboardActions<Content: View, Field: FieldContract>: View {
    private var focusedField: FocusState<Field?>.Binding?
    private let fields: [Field]
    private let content: Content

    public init(
        focusedField: FocusState<Field?>.Binding? = nil,
        fields: [Field],
        @ViewBuilder content: () -> Content
    ) {
        self.focusedField = focusedField
        self.fields = fields
        self.content = content()
    }

    public var body: some View {
        content
            .keyboardActions(focusedField: focusedField, fields: fields)
    }
}

public extension View {
    func keyboardActions<Field: FieldContract>(
        focusedField: FocusState<Field?>.Binding? = nil,
        fields: [Field]
    ) -> some View {
        modifier(KeyboardActionsModifier(focusedField: focusedField, fields: fields))
    }
}

struct KeyboardActionsModifier<Field: FieldContract>: ViewModifier {
    private var focusedField: FocusState<Field?>.Binding?
    private let fields: [Field]

    init(
        focusedField: FocusState<Field?>.Binding? = nil,
        fields: [Field]
    ) {
        self.focusedField = focusedField
        self.fields = fields
    }

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button(action: focusPreviousField) {
                        Image(systemName: "chevron.up")
                    }
                    .disabled(!canFocusPreviousField())

                    Button(action: focusNextField) {
                        Image(systemName: "chevron.down")
                    }
                    .disabled(!canFocusNextField())

                    Spacer()

                    Button(action: {
                        focusedField?.wrappedValue = nil
                    }) {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(.bordered)
                }
            }
    }

    private var selectedIndex: Int? {
        fields.firstIndex(where: { $0.hashValue == focusedField?.wrappedValue?.hashValue })
    }

    private func focusPreviousField() {
        if canFocusPreviousField() {
            focusedField?.wrappedValue = fields[selectedIndex! - 1]
        }
    }

    private func focusNextField() {
        if canFocusNextField() {
            focusedField?.wrappedValue = fields[selectedIndex! + 1]
        }
    }

    private func canFocusPreviousField() -> Bool {
        guard let selectedIndex, selectedIndex > 0 else { return false }

        return true
    }

    private func canFocusNextField() -> Bool {
        guard let selectedIndex, selectedIndex < fields.endIndex - 1 else { return false }

        return true
    }
}
