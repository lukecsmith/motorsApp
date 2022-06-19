//
//  HomeViewModelTests.swift
//  MotorsAppTests
//
//  Created by Luke Smith on 18/06/2022.
//

import XCTest
@testable import MotorsApp

class HomeViewModelTests: XCTestCase {
    
    //Test:
    func testStartingMotorQueryWithEmptyFieldsCausesError() {
        let mockMotorResponse = Motor(id: "0", name: "car", title: "car", make: "car", model: "model", year: "2000", price: "£1.00")
        let viewModel = HomeViewModel(repository: MockMotorsRepository(mockResult: { .success([mockMotorResponse])}))
        
        //assert all fields empty
        XCTAssertEqual(viewModel.makeField, "")
        XCTAssertEqual(viewModel.modelField, "")
        XCTAssertEqual(viewModel.yearField, "")
        
        //check theres no error
        XCTAssertEqual(viewModel.errorText, "")
        
        viewModel.queryMotors()
        
        //after running query, should now be an error
        XCTAssertEqual(viewModel.errorText, "Please enter something for Make, Model or Year")
        //and results should still be empty
        XCTAssertEqual(viewModel.results, [])
    }
    
    func testMotorQuerySuccessPopulatesResultsArray() {
        let mockMotorResponse = Motor(id: "0", name: "car", title: "car", make: "car", model: "Nissan", year: "2000", price: "£1.00")
        let viewModel = HomeViewModel(repository: MockMotorsRepository(mockResult: { .success([mockMotorResponse]) }))
        
        //populate a field so the query is executed
        viewModel.modelField = "Nissan"
        
        viewModel.queryMotors()
        
        //check results field has been populated
        XCTAssertEqual(viewModel.results, [mockMotorResponse])
    }
    
    func testMotorQueryFailureErrorIsPopulated() {
        let viewModel = HomeViewModel(repository: MockMotorsRepository(mockResult: { .failure(DataError.networkingError) }))
        
        //populate a field so the query is executed
        viewModel.modelField = "Nissan"
        
        viewModel.queryMotors()
        
        //check error text has been populated
        XCTAssertEqual(viewModel.errorText, "Failed with error: The operation couldn’t be completed. (MotorsApp.DataError error 2.)")
    }
    
    func testResultsFieldIsEmptiedOnStartingAQuery() {
        let motor0 = Motor(id: "0", name: "car", title: "car", make: "car", model: "Nissan", year: "2000", price: "£1.00")
        let motor1 = Motor(id: "1", name: "car", title: "car", make: "car", model: "Nissan", year: "2000", price: "£1.00")
        
        let viewModel = HomeViewModel(repository: MockMotorsRepository(mockResult: { .failure(DataError.networkingError) }))
        //already existing results pre query:
        viewModel.results = [motor0, motor1]
        
        //populate a field so the query is executed
        viewModel.modelField = "Nissan"
        
        viewModel.queryMotors()
        
        //check results are empty post query, even though result was fail
        XCTAssertEqual(viewModel.results, [])
    }
    
}
