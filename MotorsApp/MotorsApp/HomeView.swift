//
//  ContentView.swift
//  MotorsApp
//
//  Created by Luke Smith on 16/06/2022.
//

import SwiftUI

struct HomeView: View {
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            TextField("Make", text: $viewModel.make)
            TextField("Model", text: $viewModel.model)
            TextField("Year", text: $viewModel.year)
            List(viewModel.results, id: \.self) { result in
                ListItemView(result: result)
            }
            Spacer()
        }.padding()
    }
}

struct ListItemView: View {
    
    var result: MotorResult
    
    var body: some View {
        Text("make: \(result.make)")
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var testViewModel: HomeViewModel {
        let viewModel = HomeViewModel(repository: MotorsRepository())
        viewModel.results = [
            MotorResult(id: "000", name: "Car 0", title: "Car zero", make: "Nissan", model: "Leaf", year: "2002", price: "£2461.20"),
            MotorResult(id: "001", name: "Car 1", title: "Car one", make: "Honda", model: "CR-V", year: "2010", price: "£8000.20")]
        return viewModel
    }
    
    static var previews: some View {
        HomeView(viewModel: testViewModel)
    }
}
