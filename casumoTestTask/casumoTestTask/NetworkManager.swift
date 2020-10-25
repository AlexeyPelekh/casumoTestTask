//
//  NetworkManager.swift
//  casumoTestTask
//
//  Created by Oleksii Pelekh on 25.10.2020.
//

import Alamofire

class NetworkManager {
    private var sessionManager = Alamofire.SessionManager()

    func request(url: URLConvertible,
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

    func request(_ urlRequest: URLRequestConvertible,
                 completion: @escaping (Result<Data>) -> Void) {
        SessionManager.default.request(urlRequest).validate().responseData { (dataResponse) in
            switch dataResponse.result {
            case .success(let data):
                completion(.success(data))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
