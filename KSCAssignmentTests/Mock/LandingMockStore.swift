//
//  LandingMockStore.swift
//  KSCAssignmentTests
//
//  Created by Preeyapol Owatsuwan on 25/3/2566 BE.
//

@testable import KSCAssignment
import Foundation

class LandingMockStore: LandingStoreNetworkLogic {
    func inquiryLatLonWithCityName(request: LatLonRequestModel, completion: @escaping (Result<[LatLonResponseModel], CommonError>) -> Void) {
        let model: [LatLonResponseModel] = [
            .init(name: "Test", localNames: nil, lat: 14.00, lon: 14.00, country: nil, state: nil)
        ]
        completion(.success(model))
    }
    
    func inquiryCurrentWeather(request: CurrentWeatherRequestModel, completion: @escaping (Result<CurrentWeatherResponseModel, CommonError>) -> Void) {
        let model: CurrentWeatherResponseModel = .init(
            coord: .init(lon: 14.00, lat: 14.00),
            weather: [CurrentWeatherResponseModel.Weather.init(
                id: nil,
                main: .snow,
                description: nil,
                icon: "10n"
            )],
            base: nil,
            main: .init(
                temp: 275,
                feelsLike: nil,
                tempMin: nil,
                tempMax: nil,
                pressure: nil,
                humidity: 60,
                seaLevel: nil,
                grndLevel: nil
            ),
            visibility: nil,
            wind: nil,
            rain: nil,
            clouds: nil,
            dt: nil,
            sys: nil,
            timezone: nil,
            id: nil,
            name: nil,
            cod: nil)
        completion(.success(model))
    }
}
