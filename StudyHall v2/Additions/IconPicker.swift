//
//  IconPicker.swift
//  StudyHall v2
//
//  Created by Kathryn Jerez on 3/27/22.
//

import SwiftUI

import SwiftUI
import SymbolPicker

struct IconPicker: View {
    @State private var iconPickerPresented = false
    @State private var icon = "pencil"

    var body: some View {
        Button(action: {
            iconPickerPresented = true
         }) {
            HStack {
                Image(systemName: icon)
                Text(icon)
            }
        }
        .sheet(isPresented: $iconPickerPresented) {
            SymbolPicker(symbol: $icon)
        }
    }
}

struct IconPicker_Previews: PreviewProvider {
    static var previews: some View {
        IconPicker()
    }
}
