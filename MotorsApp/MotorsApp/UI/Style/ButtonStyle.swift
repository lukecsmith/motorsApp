//
//  ButtonStyle.swift
//  MotorsApp
//
//  Created by Luke Smith on 17/06/2022.
//

import Foundation
import SwiftUI

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color("ButtonColour"))
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}
