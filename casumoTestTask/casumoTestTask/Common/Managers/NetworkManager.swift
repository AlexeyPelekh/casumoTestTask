//
//  NetworkManager.swift
//  casumoTestTask
//
//  Created by Oleksii Pelekh on 25.10.2020.
//

import Alamofire

class NetworkManager {
    private var sessionManager = Alamofire.SessionManager()

    func request(url: URLConvertible = Constants.eventsFinalUrl,
                 method: HTTPMethod = .get,
                 parameters: Parameters? = nil,
                 headers: HTTPHeaders? = nil,
                 completion: @escaping (Result<Data>) -> Void) {
        sessionManager.request(url,
                               method: method,
                               parameters: parameters,
                               headers: headers)
            .responseData(completionHandler: { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    completion(.success(data))

                case .failure(let error):
                    completion(.failure(error))
                }
            })
    }
}

extension NetworkManager {
    struct Constants {
        static let eventsFinalUrl = eventsBaseUrl + eventsPerPageQuery
        static let eventsBaseUrl = "https://api.github.com/events"
        static let eventsPerRequestCount = 100
        static let eventsPerPageQuery = "?per_page=\(eventsPerRequestCount)"
    }
}
