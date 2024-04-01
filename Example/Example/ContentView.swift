//
//  ContentView.swift
//  Example
//
//  Created by Enes Karaosman on 1.04.2024.
//

import KeyboardActions
import SwiftUI

struct ContentView: View {
    @State private var mail: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    enum Field: CaseIterable, FieldContract {
        case mail
        case password
        case confirmPassword
    }

    @FocusState var focusedField: Field?

    var body: some View {
        VStack {
            TextField("Mail", text: $mail)
                .focused($focusedField, equals: Field.mail)
                .padding(4)
                .border(.gray)

            TextField("Password", text: $password)
                .focused($focusedField, equals: Field.password)
                .padding(4)
                .border(.gray)

            TextField("Confirm Password", text: $confirmPassword)
                .focused($focusedField, equals: Field.confirmPassword)
                .padding(4)
                .border(.gray)
        }
        .padding()
        .keyboardActions(focusedField: $focusedField, fields: Field.allCases)
        .onAppear {
            focusedField = Field.mail
        }
    }
}

#Preview {
    ContentView()
}
