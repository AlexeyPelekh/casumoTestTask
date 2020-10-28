//
//  NetworkManagerMock.swift
//  casumoTestTaskTests
//
//  Created by Oleksii Pelekh on 28.10.2020.
//

import Alamofire
@testable import casumoTestTask

final class NetworkManagerMock: NetworkManager {
    var invocationCount = 0
    var fakeResponse: Result<Data>?
    var eventsEndpoint: String = NetworkManager.Constants.eventsFinalUrl

    override func request(url: URLConvertible,
                          method: HTTPMethod = .get,
                          parameters: Parameters? = nil,
                          headers: HTTPHeaders? = nil,
                          completion: @escaping (Result<Data>) -> Void) {
        invocationCount += 1

        completion(fakeResponse ?? .failure(NSError(domain: "", code: Int(), userInfo: nil)))
    }
}
