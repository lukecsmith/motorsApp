//
//  MotorsAppApp.swift
//  MotorsApp
//
//  Created by Luke Smith on 16/06/2022.
//

import SwiftUI

@main
struct MotorsApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel(repository: MotorsRepository()))
        }
    }
}
