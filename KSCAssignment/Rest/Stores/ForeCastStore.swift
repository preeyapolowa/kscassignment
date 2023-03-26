//
//  ForeCastStore.swift
//  KSCAssignment
//
//  Created by Preeyapol Owatsuwan on 25/3/2566 BE.
//

import Foundation

protocol ForeCastStoreNetworkLogic {
    func inquiryForeCast(request: ForeCastRequestModel, completion: @escaping (Result<ForeCastResponseModel, CommonError>) -> Void)
}

class ForeCastStore: ForeCastStoreNetworkLogic {
    let dataBaseUrl = "https://api.openweathermap.org/data/2.5/"
    
    enum Endpoints: String {
        case forecast = "forecast"
    }
    
    let cannotGetDataError: CommonError = .init(
        title: "Error",
        description: "Cannot get data from API"
    )
    
    let apiKey = "ca2083efc77b826a38e9011ee8a383ed"
    
    func inquiryForeCast(
        request: ForeCastRequestModel,
        completion: @escaping (Result<ForeCastResponseModel, CommonError>) -> Void
    ) {
        guard var url = URL(string: dataBaseUrl + Endpoints.forecast.rawValue) else {
            completion(.failure(.init(
                title: "Error",
                description: "Cannot convert URL")
            ))
            return
        }
        
        let queryItems: [URLQueryItem] = [
            .init(name: "lat", value: request.lat),
            .init(name: "lon", value: request.lon),
            .init(name: "cnt", value: "5"),
            .init(name: "appid", value: apiKey)
        ]
        url.append(queryItems: queryItems)
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let dataValid = data {
                do {
                    let foreCastResponse = try JSONDecoder().decode(ForeCastResponseModel.self, from: dataValid)
                    DispatchQueue.main.async {
                        guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                            completion(.failure(self.cannotGetDataError))
                            return
                        }
                        
                        guard 200 ..< 300 ~= httpResponse.statusCode else {
                            completion(.failure(self.cannotGetDataError))
                            return
                        }
                        
                        completion(.success(foreCastResponse))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.init(
                            title: "Error",
                            description: "Cannot convert data to JSON model")
                        ))
                    }
                }
            } else {
                completion(.failure(self.cannotGetDataError))
            }
        }.resume()
    }
}
