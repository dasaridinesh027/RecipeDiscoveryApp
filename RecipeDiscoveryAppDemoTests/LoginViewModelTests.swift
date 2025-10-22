//
//  LoginViewModelTestss.swift
//  RecipeDiscoveryAppDemoTests
//
//  Created by My Mac on 16/10/25.
//

import XCTest
@testable import RecipeDiscoveryAppDemo

@MainActor
final class LoginViewModelTests: XCTestCase {
    
    var viewModel: LoginViewModel!
    var alertManager: AlertViewManager!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        viewModel = LoginViewModel()
        alertManager = AlertViewManager.shared
        
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        alertManager = nil
    }
    
    func testEmptyEmailShowsAlert() async {
           await viewModel.login(username: "", password: "Abc@12")
           XCTAssertEqual(alertManager.title, "Alert")
           XCTAssertEqual(alertManager.message, "Please enter valid username")
       }
    
    func testInvalidEmailShowsAlert() async {
        await viewModel.login(username: "invalidemail", password: "Abc@12")
        XCTAssertEqual(alertManager.title, "Alert")
        XCTAssertEqual(alertManager.message, "Please enter valid username")
    }
    
    func testEmptyPasswordShowsAlert() async {
           await viewModel.login(username: "test@test.com", password: "")
           XCTAssertEqual(alertManager.title, "Alert")
        XCTAssertTrue(alertManager.message.contains("Password must be"))
       }
    
    func testInvalidPasswordShowsAlert() async {
        await viewModel.login(username: "test@test.com", password: "abc")
        XCTAssertEqual(alertManager.title, "Alert")
        XCTAssertTrue(alertManager.message.contains("Password must be"))
    }
    
    
     func testSuccessfulLogin() async {
         await viewModel.login(username: "test@test.com", password: "Abc@12")
         // Simulate waiting for fake delay
         let expectation = XCTestExpectation(description: "Wait for async login")
         DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
             XCTAssertTrue(self.viewModel.isLoggedIn)
             expectation.fulfill()
         }
         await fulfillment(of: [expectation], timeout: 3)
     }
     
     func testInvalidCredentialsShowsError() async {
         await viewModel.login(username: "wrong@test.com", password: "Wrong@123")
         let expectation = XCTestExpectation(description: "Wait for async login fail")
         DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
             XCTAssertEqual(self.alertManager.title, "Error")
             XCTAssertEqual(self.alertManager.message, "Invalid credentials. Try again.")
             expectation.fulfill()
         }
         await fulfillment(of: [expectation], timeout: 3)
     }
    
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
