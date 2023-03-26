//
//  LandingModels.swift
//  KSCAssignment
//
//  Created by Preeyapol Owatsuwan on 24/3/2566 BE.
//

import Foundation

enum LandingModels {
    enum Popup {
        struct Request {
            let title: String
            let description: String
        }
        
        struct Response {
            let title: String
            let description: String
        }
        
        struct ViewModel {
            let title: String
            let description: String
        }
    }
    
    enum CurrentLatLonWeather {
        struct Request {
            let cityName: String
        }
        
        struct Response {
            let dataSource: Result<CurrentLatLonWeatherResponse, CommonError>
        }
        
        struct ViewModel {
            let dataSource: Result<CurrentLatLonWeatherDataSource, CommonError>
        }
        
        struct CurrentLatLonWeatherResponse {
            let currentWeatherPath: String
            let tempCelcius: Double
            let humidity: Int
        }
        
        struct CurrentLatLonWeatherDataSource {
            let currentWeatherURL: URL?
            let defaultWeatherImagePath: String
            let tempCelcius: String
            let humidity: String
        }
    }
    
    enum CurrentLatLon {
        struct Request {
            let cityName: String
        }
        
        struct Response {
            let dataSource: Result<LatLon, CommonError>
        }
        
        struct ViewModel {
            let dataSource: Result<LatLon, CommonError>
        }
        
        struct LatLon {
            let lat: String
            let lon: String
        }
    }
    
    enum ConvertTempurature {
        struct Request {
            
        }
        
        struct Response {
            let currentTemperatureTypes: TemperatureTypes
            let currentTemp: Int
        }
        
        struct ViewModel {
            let temperature: String
        }
    }
    
    enum TemperatureTypes {
        case celcius
        case fahrenheit
    }
}
