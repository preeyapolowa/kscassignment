//
//  LandingPresenter.swift
//  KSCAssignment
//
//  Created by Preeyapol Owatsuwan on 24/3/2566 BE.
//

import Foundation

protocol LandingPresenterPresentationLogic {
    func presentCurrentLatLonWeather(response: LandingModels.CurrentLatLonWeather.Response)
    func presentCurrentLatLon(response: LandingModels.CurrentLatLon.Response)
    func presentConvertTempurature(response: LandingModels.ConvertTempurature.Response)
}

class LandingPresenter: LandingPresenterPresentationLogic {
    weak var viewController: LandingViewControllerDisplayLogic!
    
    private let baseImagePath = "https://openweathermap.org/img/wn/"

    func presentCurrentLatLonWeather(response: LandingModels.CurrentLatLonWeather.Response) {
        switch response.dataSource {
        case let .success(weather):
            let imageURL = URL(string: "\(baseImagePath)\(weather.currentWeatherPath)@2x.png")

            viewController.displayCurrentLatLonWeather(viewModel: .init(dataSource: .success(.init(
                currentWeatherURL: imageURL,
                defaultWeatherImagePath: "all-weather-icon",
                tempCelcius: "\(Int(weather.tempCelcius))°C",
                humidity: "\(weather.humidity)%")))
            )
        case let .failure(error):
            viewController.displayCurrentLatLonWeather(viewModel: .init(dataSource: .failure(error)))
        }
    }
    
    func presentCurrentLatLon(response: LandingModels.CurrentLatLon.Response) {
        viewController.displayCurrentLatLon(viewModel: .init(dataSource: response.dataSource))
    }
    
    func presentConvertTempurature(response: LandingModels.ConvertTempurature.Response) {
        let temperature: String
        
        switch response.currentTemperatureTypes {
        case .celcius:
            temperature = "\(response.currentTemp)°C"
        case .fahrenheit:
            temperature = "\(response.currentTemp)°F"
        }
        
        viewController.displayConvertTempurature(viewModel: .init(temperature: temperature))
    }
}
