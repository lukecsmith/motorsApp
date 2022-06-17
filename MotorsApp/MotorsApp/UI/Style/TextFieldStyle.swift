//
//  TextFieldStyle.swift
//  MotorsApp
//
//  Created by Luke Smith on 17/06/2022.
//

import Foundation
import SwiftUI

extension View {
    func textFieldStyle() -> some View {
        self.modifier(TextFieldStyle())
    }
}

struct TextFieldStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.title)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}
