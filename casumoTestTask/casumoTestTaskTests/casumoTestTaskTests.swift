//
//  casumoTestTaskTests.swift
//  casumoTestTaskTests
//
//  Created by Oleksii Pelekh on 25.10.2020.
//

import XCTest
@testable import casumoTestTask

final class casumoTestTaskTests: XCTestCase {
    func testNetworkManagerGetsData() {
        // arrange
        let fakeNetworkManager = NetworkManagerMock()
        let exp = expectation(description: "Network Manager response expectation")

        fakeNetworkManager.request(url: fakeNetworkManager.eventsEndpoint) { response in
            XCTAssertNotNil(response)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 5)
    }

    func testNetworkManagerReceivedError() {
        // arrange
        let fakeNetworkManager = NetworkManagerMock()
        let fakeError = NSError(domain: "Nerwork Manager fake error", code: 123, userInfo: nil)
        fakeNetworkManager.fakeResponse = .failure(fakeError)
        let exp = expectation(description: "Network Manager response expectation")

        fakeNetworkManager.request(url: fakeNetworkManager.eventsEndpoint) { response in
            // assert
            XCTAssert(fakeNetworkManager.invocationCount == 1)
            XCTAssert(response.isFailure)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 5)
    }

    func testNetworkManagerReceivedSuccess() {
        // arrange
        let fakeNetworkManager = NetworkManagerMock()
        let jsonString = """
{
}
"""
        let fakeData = Data((jsonString.utf8))
        fakeNetworkManager.fakeResponse = .success(fakeData)

        let exp = expectation(description: "Network Manager fake data response")

        // act
        fakeNetworkManager.request(url: fakeNetworkManager.eventsEndpoint) { response in
            // assert
            XCTAssert(fakeNetworkManager.invocationCount == 1)
            XCTAssert(response.isSuccess)
            XCTAssertNotNil(response)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 5)
    }
}
