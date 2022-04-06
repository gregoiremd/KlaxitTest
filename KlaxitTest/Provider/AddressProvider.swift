//
//  APIManager.swift
//  KlaxitTest
//
//  Created by Grégoire Marchand on 23/03/2022.
//

import Foundation

enum ServiceError: Error {
    case url(URLError)
    case urlRequest
    case decode
}

class AddressProvider {
    
    static let shared = AddressProvider()
    
    // MARK: Initialization
    
    private init() {
    }
    
    // MARK: Public
    
    func fetchAddresses(input: String, _ completion: @escaping (Result<[Address], Error>) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api-adresse.data.gouv.fr"
        components.path = "/search/"
        components.queryItems = [URLQueryItem(name: "q", value: input)]
        
        guard let url = components.url else {
            completion(.failure(ServiceError.urlRequest))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 10.0
        urlRequest.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.success([]))
                }
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                
                let addresses = try self.decodeJson(json)
                DispatchQueue.main.async {
                    completion(.success(addresses))
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(ServiceError.decode))
                }
            }
        }
        
        dataTask.resume()
    }
    
    func decodeJson(_ json: [String : Any]) throws -> [Address] {
        guard let results = json["features"] as? [[String : Any]] else {
            return []
        }
        var addresses: [Address] = []
        for result in results {
            guard let properties = result["properties"] as? [String : Any] else {
                break
            }
            let address = Address()
            address.label = (properties["label"] as? String) ?? ""
            address.name = (properties["name"] as? String) ?? ""
            address.city = (properties["city"] as? String) ?? ""
            address.postcode = (properties["postcode"] as? String) ?? ""

//            let data = try JSONSerialization.data(withJSONObject: properties)
//            guard let address = try? JSONDecoder().decode(Address.self, from: data) else {
//                break
//            }
            addresses.append(address)
        }
        return addresses
    }

}
