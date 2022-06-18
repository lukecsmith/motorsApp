//
//  ContentView.swift
//  MotorsApp
//
//  Created by Luke Smith on 16/06/2022.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
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
                VStack(alignment: .leading) {
                    ForEach(viewModel.results, id: \.self) { motor in
                        HStack {
                            ListItemView(motor: motor)
                            Spacer()
                        }
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
        ZStack {
            Color.gray
            HStack {
                VStack(alignment: .leading, spacing: 5.0) {
                    Text("Make: \(motor.make)")
                    Text("Year: \(motor.year)")
                    Text("Model: \(motor.model)")
                    Text("Title: \(motor.title)")
                    Text("Name: \(motor.name)")
                    Text("Price: \(motor.price)")
                }.padding()
                Spacer()
            }.font(.body)
        }
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
            .previewDevice("iPhone 13 Pro Max")
            .preferredColorScheme(.light)
        HomeView(viewModel: testViewModel)
            .previewDevice("iPhone 8")
            .preferredColorScheme(.dark)
    }
}
