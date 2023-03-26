//
//  LandingInteractor.swift
//  KSCAssignment
//
//  Created by Preeyapol Owatsuwan on 24/3/2566 BE.
//

import Foundation

protocol LandingInteractorBusinessLogic {
    func inquiryCurrentLatLonWeather(request: LandingModels.CurrentLatLonWeather.Request)
    func inquiryCurrentLatLon(request: LandingModels.CurrentLatLon.Request)
    func convertTempurature(request: LandingModels.ConvertTempurature.Request)
}

class LandingInteractor: LandingInteractorBusinessLogic {
    var presenter: LandingPresenterPresentationLogic!
    var landingWorker = LandingWorker(store: LandingStore())
    
    var currentTemperatureTypes: LandingModels.TemperatureTypes = .celcius
    var currentTemp: Double = 0.00
    
    func inquiryCurrentLatLonWeather(request: LandingModels.CurrentLatLonWeather.Request) {
        landingWorker.inquiryLatLonWithCityName(request: .init(cityName: request.cityName)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                guard let firstArray = response.first else {
                    self.presenter.presentCurrentLatLonWeather(response: .init(dataSource: .failure(.init(
                        title: "Error",
                        description: "\(request.cityName) is not a city name, please recheck and try again.")))
                    )
                    return
                }
                
                let request: CurrentWeatherRequestModel = .init(
                    lat: "\(firstArray.lat ?? 0.00)",
                    lon: "\(firstArray.lon ?? 0.00)"
                )
                self.landingWorker.inquiryCurrentWeather(request: request) { result in
                    switch result {
                    case .success(let currentWeather):
                        guard let weather = currentWeather.weather?.first else { return }
                        
                        self.currentTemperatureTypes = .celcius
                        self.currentTemp = (currentWeather.main?.temp ?? 0.00) - 273.15 // Celcius
                        self.presenter.presentCurrentLatLonWeather(response: .init(dataSource: .success(.init(
                            currentWeatherPath: weather.icon ?? "",
                            tempCelcius: self.currentTemp,
                            humidity: currentWeather.main?.humidity ?? 0)))
                        )
                    case .failure(let error):
                        self.presenter.presentCurrentLatLonWeather(response: .init(dataSource: .failure(error)))
                    }
                }
            case .failure(let error):
                self.presenter.presentCurrentLatLonWeather(response: .init(dataSource: .failure(error)))
            }
        }
    }
    
    func inquiryCurrentLatLon(request: LandingModels.CurrentLatLon.Request) {
        landingWorker.inquiryLatLonWithCityName(request: .init(cityName: request.cityName)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                guard let firstArray = response.first else {
                    self.presenter.presentCurrentLatLon(response: .init(dataSource: .failure(.init(
                        title: "Error",
                        description: "\(request.cityName) is not a city name, please recheck and try again.")))
                    )
                    return
                }
                
                self.presenter.presentCurrentLatLon(response: .init(dataSource: .success(.init(
                    lat: "\(firstArray.lat ?? 0.00)",
                    lon: "\(firstArray.lon ?? 0.00)")
                )))
            case .failure(let error):
                self.presenter.presentCurrentLatLon(response: .init(dataSource: .failure(error)))
            }
        }
    }
    
    func convertTempurature(request: LandingModels.ConvertTempurature.Request) {
        switch currentTemperatureTypes {
        case .celcius:
            // MARK: Celcius to fahrenheit
            let fahrenheit = (currentTemp * (9 / 5)) + 32
            currentTemp = fahrenheit
            currentTemperatureTypes = .fahrenheit
        case .fahrenheit:
            // MARK: Fahrenheit to celcius
            let celcius = (currentTemp - 32) * (5 / 9)
            currentTemp = celcius
            currentTemperatureTypes = .celcius
        }
        
        presenter.presentConvertTempurature(response: .init(
            currentTemperatureTypes: currentTemperatureTypes,
            currentTemp: Int(currentTemp))
        )
    }
}
