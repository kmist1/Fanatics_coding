//
//  Fanatics_CodingChallangeTests.swift
//  Fanatics_CodingChallangeTests
//
//  Created by Krunal Mistry on 9/29/22.
//

import XCTest
@testable import Fanatics_CodingChallange

final class Fanatics_CodingChallangeTests: XCTestCase {

    var urlSession: URLSession!
    var userVM: UserViewModel?

    override func setUpWithError() throws {
        // set url session for mock networking
        let configuration = URLSessionConfiguration.ephemeral
        urlSession = URLSession(configuration: configuration)
        userVM = UserViewModel()
    }

    // Testing get users data
    func test_getDataFromAPIWithCompletionHandler() {
        let handler = APIHandler()

        handler.session = urlSession

        let expectation = XCTestExpectation(description: "Data is not empty")

        handler.getAllPageThreeUsers(url: Endpoints.users.rawValue) { (result: Result<[User], Error>) in
            switch result {
            case .success(let users):
                XCTAssertFalse(users.isEmpty, "Array of users should not be empty")
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("Failed to fetch data \(String(describing: failure))")
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1)
    }

    // testing fetch user with wrong id
    func test_getUserWithId() {
        let handler = APIHandler()

        handler.session = urlSession

        handler.getUser(with: 5555, httpMethod: .GET) { code in
            XCTAssertEqual(code, 404)
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
