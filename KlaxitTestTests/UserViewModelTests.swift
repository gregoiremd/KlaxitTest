//
//  UserViewModelTests.swift
//  KlaxitTestTests
//
//  Created by Grégoire Marchand on 23/03/2022.
//

import XCTest
@testable import KlaxitTest

class UserViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: "user_infos")
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testInitialization() {
        let userViewModel = UserViewModel()
        XCTAssertNotNil(userViewModel, "The profile view model should not be nil.")
        XCTAssertEqual(userViewModel.userName.value, "Michel Lambert")
        XCTAssertEqual(userViewModel.phoneNumber.value, "+33 6 12 34 56 78")
        XCTAssertEqual(userViewModel.profession.value, "Développeur iOS")
        XCTAssertEqual(userViewModel.company.value, "Klaxit")
        XCTAssertEqual(userViewModel.address.value, nil)
    }

}
