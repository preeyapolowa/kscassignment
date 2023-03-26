//
//  LandingStore.swift
//  KSCAssignment
//
//  Created by Preeyapol Owatsuwan on 24/3/2566 BE.
//

import Foundation

protocol LandingStoreNetworkLogic {
    func inquiryLatLonWithCityName(request: LatLonRequestModel, completion: @escaping (Result<[LatLonResponseModel], CommonError>) -> Void)
    func inquiryCurrentWeather(request: CurrentWeatherRequestModel, completion: @escaping (Result<CurrentWeatherResponseModel, CommonError>) -> Void)
}

class LandingStore: LandingStoreNetworkLogic {
    let geoBaseUrl = "http://api.openweathermap.org/geo/1.0/"
    let dataBaseUrl = "https://api.openweathermap.org/data/2.5/"
    
    enum Endpoints: String {
        case latlon = "direct"
        case currentWeather = "weather"
    }
    
    let cannotGetDataError: CommonError = .init(
        title: "Error",
        description: "Cannot get data from API"
    )
    
    let apiKey = "ca2083efc77b826a38e9011ee8a383ed"
    
    func inquiryLatLonWithCityName(
        request: LatLonRequestModel,
        completion: @escaping (Result<[LatLonResponseModel], CommonError>) -> Void
    ) {
        guard var url = URL(string: geoBaseUrl + Endpoints.latlon.rawValue) else {
            completion(.failure(.init(
                title: "Error",
                description: "Cannot convert URL")
            ))
            return
        }
        
        let queryItems: [URLQueryItem] = [
            .init(name: "q", value: request.cityName),
            .init(name: "limit", value: "1"),
            .init(name: "appid", value: apiKey)
        ]
        url.append(queryItems: queryItems)
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let dataValid = data {
                do {
                    let latlonResponse = try JSONDecoder().decode([LatLonResponseModel].self, from: dataValid)
                    DispatchQueue.main.async {
                        guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                            completion(.failure(self.cannotGetDataError))
                            return
                        }
                        
                        guard 200 ..< 300 ~= httpResponse.statusCode else {
                            completion(.failure(self.cannotGetDataError))
                            return
                        }
                        
                        completion(.success(latlonResponse))
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
    
    func inquiryCurrentWeather(
        request: CurrentWeatherRequestModel,
        completion: @escaping (Result<CurrentWeatherResponseModel, CommonError>) -> Void
    ) {
        guard var url = URL(string: dataBaseUrl + Endpoints.currentWeather.rawValue) else {
            completion(.failure(.init(
                title: "Error",
                description: "Cannot convert URL")
            ))
            return
        }
        
        let queryItems: [URLQueryItem] = [
            .init(name: "lat", value: request.lat),
            .init(name: "lon", value: request.lon),
            .init(name: "appid", value: apiKey)
        ]
        url.append(queryItems: queryItems)
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let dataValid = data {
                do {
                    let weatherResponse = try JSONDecoder().decode(CurrentWeatherResponseModel.self, from: dataValid)
                    DispatchQueue.main.async {
                        guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                            completion(.failure(self.cannotGetDataError))
                            return
                        }
                        
                        guard 200 ..< 300 ~= httpResponse.statusCode else {
                            completion(.failure(self.cannotGetDataError))
                            return
                        }
                        
                        completion(.success(weatherResponse))
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
