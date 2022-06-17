//
//  ErrorView.swift
//  SpaceX
//
//  Created by Luke Smith on 24/08/2020.
//  Copyright © 2020 Luke Smith. All rights reserved.
//

import SwiftUI

extension View {
    func errorView(text: Binding<String>) -> some View {
        self.modifier(ErrorViewModifier(text: text))
    }
}

struct ErrorViewModifier: ViewModifier {
    
    @Binding var text: String
    func body(content: Content) -> some View {
        ZStack {
            content
            ErrorView(text: $text)
        }
    }
}

struct ErrorView: View {
    
    @Binding var text: String
    @State private var visibleErrorText: String = ""
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            if visibleErrorText.count > 0 {
                ErrorBox(errorMessage: text)
                    .transition(.asymmetric(insertion: AnyTransition.opacity
                                                .combined(with: AnyTransition.move(edge: .top)),
                                            removal: AnyTransition.opacity
                                                .combined(with: AnyTransition.move(edge: .top))))
            }
            Spacer()
        }.onChange(of: text) { newValue in
            withAnimation {
                self.visibleErrorText = newValue
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
                    withAnimation {
                        self.visibleErrorText = ""
                        self.text = ""
                    }
                }
            }
            
        }
    }
}

struct ErrorBox: View {
    
    let errorMessage: String
    private let padding: CGFloat = 5.0
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            Text(errorMessage)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .padding(15)
            Spacer()
        }
        .background(Color.red)
        .cornerRadius(10)
        .shadow(radius: 24)
        .padding(EdgeInsets(top: padding,
                            leading: 24,
                            bottom: padding,
                            trailing: 24))
    }
}
