//
//  NetworkManager.swift
//  StoreApp
//
//  Created by Giri on 4/18/25.
//

import Foundation
import Alamofire



class NetworkManager: NSObject {
    var afSession: Session!
    var parameters = Parameters()
    var headers = HTTPHeaders()
    var method: HTTPMethod!
    var url: String!
    var encoding: ParameterEncoding! = JSONEncoding.default
    
    init(data: [String: Any] = [:], headers: [String: String] = [:], url: String?, method: HTTPMethod = .get, isJSONRequest: Bool = true) {
        super.init()
        data.forEach { parameters.updateValue($0.value, forKey: $0.key) }
        headers.forEach { self.headers.add(name: $0.key, value: $0.value) }
        
        if !isJSONRequest {
            encoding = URLEncoding.default
        }
        if afSession == nil {
            afSession = Session()
        }
        self.method = method
        self.url = url
        print("Service: \(self.url ?? "") \n data: \(parameters)")
    }
    
    func executeQuery<T>(completion: @escaping (Result<T, Error>) -> Void) where T: Codable {
        if !Connectivity().isConnectedToInternet() {
            print("No Internet Connection")
            return
        }
        
        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).cURLDescription { description in
            print(description)
        }.responseData { response in
            print("Response Data: \(String(data: response.data ?? Data(), encoding: .utf8) ?? "No data")")
            switch response.result {
            case .success(let res):
                if let code = response.response?.statusCode {
                    switch code {
                    case 200...299:
                        do {
                            let obj = try JSONDecoder().decode(T.self, from: res)
                            print("Decoded Response: \(obj)")
                            completion(.success(obj))
                        } catch let error {
                            print("Error decoding response: \(error.localizedDescription)")
                            print("Raw Response Data: \(String(data: res, encoding: .utf8) ?? "nil")")
                            completion(.failure(error))
                        }
                    default:
                        let error = NSError(domain: response.debugDescription, code: code, userInfo: response.response?.allHeaderFields as? [String: Any])
                        print("Error: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                print("Request failed with error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}

class Connectivity {
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
