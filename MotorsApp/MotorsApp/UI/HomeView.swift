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
            Image("MotorsLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
            TextField("Make", text: $viewModel.make)
                .textFieldStyle()
            TextField("Model", text: $viewModel.model)
                .textFieldStyle()
            TextField("Year", text: $viewModel.year)
                .textFieldStyle()
            Button(action: {
                withAnimation {
                    viewModel.queryMotors()
                }
            }, label: {
                Text("Search").frame(maxWidth: .infinity)
            }).buttonStyle(BlueButton())
            ScrollView {
                VStack {
                    ForEach(viewModel.results, id: \.self) { motor in
                        ListItemView(motor: motor)
                            .frame(width: .infinity)
                    }
                }.frame(maxWidth: .infinity)
            }
        }.padding()
        .errorView(text: $viewModel.errorText)
    }
}

struct ListItemView: View {
    
    var motor: Motor
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("title: \(motor.title)")
            Text("name: \(motor.name)")
            Text("price: \(motor.price)")
            Text("make: \(motor.make)")
            Text("model: \(motor.model)")
        }
        .padding()
        .background(Color.gray)
        .foregroundColor(.white)
        .cornerRadius(10)
        .clipShape(Rectangle())
        
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var testViewModel: HomeViewModel {
        let viewModel = HomeViewModel(repository: MotorsRepository(apiClient: MockAPIClient()))
        viewModel.results = [
            Motor(id: "000", name: "Car 0", title: "Car zero", make: "Nissan", model: "Leaf", year: "2002", price: "£2461.20"),
            Motor(id: "001", name: "Car 1", title: "Car one", make: "Honda", model: "CR-V", year: "2010", price: "£8000.20")]
        return viewModel
    }
    
    static var previews: some View {
        HomeView(viewModel: testViewModel)
    }
}
