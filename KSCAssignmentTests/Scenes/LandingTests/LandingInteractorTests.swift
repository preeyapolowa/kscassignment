//
//  KSCAssignmentTests.swift
//  KSCAssignmentTests
//
//  Created by Preeyapol Owatsuwan on 25/3/2566 BE.
//

@testable import KSCAssignment
import XCTest

class LandingInteractorTests: XCTestCase {
    private var interactor: LandingInteractor!
    private var presenterSpy: LandingPresenterSpy!
    private var workerSpy: LandingWorkerSpy!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupLandingInteractorTests()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private func setupLandingInteractorTests() {
        interactor = LandingInteractor()
        presenterSpy = LandingPresenterSpy()
        workerSpy = LandingWorkerSpy(store: LandingMockStore())
        interactor.presenter = presenterSpy
        interactor.landingWorker = workerSpy
    }
    
    // MARK: - Spy Class
    
    final class LandingPresenterSpy: LandingPresenterPresentationLogic {
        var presentCurrentLatLonWeatherCalled = false
        var presentCurrentLatLonCalled = false
        var presentConvertTempuratureCalled = false
        
        var presentCurrentLatLonWeatherResponse: LandingModels.CurrentLatLonWeather.Response!
        var presentCurrentLatLonResponse: LandingModels.CurrentLatLon.Response!
        var presentConvertTempuratureResponse: LandingModels.ConvertTempurature.Response!
        
        func presentCurrentLatLonWeather(response: LandingModels.CurrentLatLonWeather.Response) {
            presentCurrentLatLonWeatherCalled = true
            presentCurrentLatLonWeatherResponse = response
        }
        
        func presentCurrentLatLon(response: LandingModels.CurrentLatLon.Response) {
            presentCurrentLatLonCalled = true
            presentCurrentLatLonResponse = response
        }
        
        func presentConvertTempurature(response: LandingModels.ConvertTempurature.Response) {
            presentConvertTempuratureCalled = true
            presentConvertTempuratureResponse = response
        }
    }
    
    final class LandingWorkerSpy: LandingWorker {
        var inquiryLatLonWithCityNameCalled = false
        var inquiryCurrentWeatherCalled = false
        
        var forceError = false
        var forceEmpty = false
        
        override func inquiryLatLonWithCityName(request: LatLonRequestModel, completion: @escaping (Result<[LatLonResponseModel], CommonError>) -> Void) {
            inquiryLatLonWithCityNameCalled = true
            if forceError {
                completion(.failure(.init(
                    title: "Error",
                    description: "Description")
                ))
            } else if forceEmpty {
                completion(.success([]))
            } else {
                super.inquiryLatLonWithCityName(request: request, completion: completion)
            }
        }
        
        override func inquiryCurrentWeather(request: CurrentWeatherRequestModel, completion: @escaping (Result<CurrentWeatherResponseModel, CommonError>) -> Void) {
            inquiryCurrentWeatherCalled = true
            if forceError {
                completion(.failure(.init(
                    title: "Error",
                    description: "Description")
                ))
            } else {
                super.inquiryCurrentWeather(request: request, completion: completion)
            }
        }
    }
    
    // MARK: - inquiryCurrentLatLonWeather Tests
    
    func testInquiryCurrentLatLonWeatherSuccess() {
        // Given
        let request = LandingModels.CurrentLatLonWeather.Request(cityName: "Bangkok")
        
        // When
        interactor.inquiryCurrentLatLonWeather(request: request)
        
        // Then
        XCTAssertTrue(presenterSpy.presentCurrentLatLonWeatherCalled, "inquiryCurrentLatLonWeather() should ask presenter to presentCurrentLatLonWeather()")
        XCTAssertTrue(workerSpy.inquiryLatLonWithCityNameCalled, "inquiryCurrentLatLonWeather() should ask worker to inquiryLatLonWithCityName()")
        
        if let response = presenterSpy.presentCurrentLatLonWeatherResponse {
            switch response.dataSource {
            case .success(let currentWeather):
                let tempCelcius = 275 - 273.15 // Celcius
                XCTAssertEqual(currentWeather.tempCelcius, tempCelcius)
                XCTAssertEqual(currentWeather.currentWeatherPath, "10n")
                XCTAssertEqual(currentWeather.humidity, 60)
            case .failure:
                XCTFail("Response should not failed")
            }
        } else {
            XCTFail("Cannot get response from presentCurrentLatLonWeather()")
        }
    }
    
    func testInquiryCurrentLatLonWeatherFailed() {
        // Given
        let request = LandingModels.CurrentLatLonWeather.Request(cityName: "Bangkok")
        workerSpy.forceError = true
        
        // When
        interactor.inquiryCurrentLatLonWeather(request: request)

        // Then
        XCTAssertTrue(presenterSpy.presentCurrentLatLonWeatherCalled, "inquiryCurrentLatLonWeather() should ask presenter to presentCurrentLatLonWeather()")
        XCTAssertTrue(workerSpy.inquiryLatLonWithCityNameCalled, "inquiryCurrentLatLonWeather() should ask worker to inquiryLatLonWithCityName()")
        
        if let response = presenterSpy.presentCurrentLatLonWeatherResponse {
            switch response.dataSource {
            case .success:
                XCTFail("Response should not succeeded")
            case .failure(let error):
                XCTAssertEqual(error.title, "Error")
                XCTAssertEqual(error.description, "Description")
            }
        } else {
            XCTFail("Cannot get response from presentCurrentLatLonWeather()")
        }
    }
    
    func testInquiryCurrentLatLonWeatherEmpty() {
        // Given
        let request = LandingModels.CurrentLatLonWeather.Request(cityName: "Bangkok")
        workerSpy.forceEmpty = true
        
        // When
        interactor.inquiryCurrentLatLonWeather(request: request)

        // Then
        XCTAssertTrue(presenterSpy.presentCurrentLatLonWeatherCalled, "inquiryCurrentLatLonWeather() should ask presenter to presentCurrentLatLonWeather()")
        XCTAssertTrue(workerSpy.inquiryLatLonWithCityNameCalled, "inquiryCurrentLatLonWeather() should ask worker to inquiryLatLonWithCityName()")
        
        if let response = presenterSpy.presentCurrentLatLonWeatherResponse {
            switch response.dataSource {
            case .success:
                XCTFail("Response should not succeeded")
            case .failure(let error):
                XCTAssertEqual(error.title, "Error")
                XCTAssertEqual(error.description, "\(request.cityName) is not a city name, please recheck and try again.")
            }
        } else {
            XCTFail("Cannot get response from presentCurrentLatLonWeather()")
        }
    }
    
    // MARK: - presentCurrentLatLon tests
    
    func testPresentCurrentLatLonSuccess() {
        // Given
        let request = LandingModels.CurrentLatLon.Request(cityName: "Bangkok")
        
        // When
        interactor.inquiryCurrentLatLon(request: request)
        
        // Then
        XCTAssertTrue(presenterSpy.presentCurrentLatLonCalled, "inquiryCurrentLatLon() should ask presenter to presentCurrentLatLon()")
        XCTAssertTrue(workerSpy.inquiryLatLonWithCityNameCalled, "inquiryCurrentLatLonWeather() should ask worker to inquiryLatLonWithCityName()")
        
        if let response = presenterSpy.presentCurrentLatLonResponse {
            switch response.dataSource {
            case .success(let latlon):
                XCTAssertEqual(latlon.lat, "14.0")
                XCTAssertEqual(latlon.lon, "14.0")
            case .failure:
                XCTFail("Response should not failed")
            }
        } else {
            XCTFail("Cannot get response from presentCurrentLatLon()")
        }
    }
    
    func testPresentCurrentLatLonFailed() {
        // Given
        let request = LandingModels.CurrentLatLon.Request(cityName: "Bangkok")
        workerSpy.forceError = true
        
        // When
        interactor.inquiryCurrentLatLon(request: request)

        // Then
        XCTAssertTrue(presenterSpy.presentCurrentLatLonCalled, "inquiryCurrentLatLon() should ask presenter to presentCurrentLatLon()")
        XCTAssertTrue(workerSpy.inquiryLatLonWithCityNameCalled, "inquiryCurrentLatLon() should ask worker to inquiryLatLonWithCityName()")
        
        if let response = presenterSpy.presentCurrentLatLonResponse {
            switch response.dataSource {
            case .success:
                XCTFail("Response should not succeeded")
            case .failure(let error):
                XCTAssertEqual(error.title, "Error")
                XCTAssertEqual(error.description, "Description")
            }
        } else {
            XCTFail("Cannot get response from presentCurrentLatLon()")
        }
    }
    
    func testPresentCurrentLatLonEmpty() {
        // Given
        let request = LandingModels.CurrentLatLon.Request(cityName: "Bangkok")
        workerSpy.forceEmpty = true
        
        // When
        interactor.inquiryCurrentLatLon(request: request)

        // Then
        XCTAssertTrue(presenterSpy.presentCurrentLatLonCalled, "inquiryCurrentLatLon() should ask presenter to presentCurrentLatLon()")
        XCTAssertTrue(workerSpy.inquiryLatLonWithCityNameCalled, "inquiryCurrentLatLonWeather() should ask worker to inquiryLatLonWithCityName()")
        
        if let response = presenterSpy.presentCurrentLatLonResponse {
            switch response.dataSource {
            case .success:
                XCTFail("Response should not succeeded")
            case .failure(let error):
                XCTAssertEqual(error.title, "Error")
                XCTAssertEqual(error.description, "\(request.cityName) is not a city name, please recheck and try again.")
            }
        } else {
            XCTFail("Cannot get response from presentCurrentLatLon()")
        }
    }
    
    // MARK: - convertTempurature Tests
    
    func testConvertTempuratureCelciusToFahrenheit() {
        // Given
        let request = LandingModels.ConvertTempurature.Request()
        let celcius = 275 - 273.15 // Celcius
        interactor.currentTemp = celcius // Celcius
        interactor.currentTemperatureTypes = .celcius
        
        // When
        interactor.convertTempurature(request: request)
        
        // Then
        XCTAssertTrue(presenterSpy.presentConvertTempuratureCalled, "convertTempurature() should ask presenter to presentConvertTempurature()")

        if let response = presenterSpy.presentConvertTempuratureResponse {
            let fahrenheit = Int((celcius * (9 / 5)) + 32)
            XCTAssertEqual(response.currentTemp, fahrenheit)
            XCTAssertEqual(response.currentTemperatureTypes, .fahrenheit)
        } else {
            XCTFail("Cannot get response from presentConvertTempurature()")
        }
    }
    
    func testConvertTempuratureFahrenheitToCelcius() {
        // Given
        let request = LandingModels.ConvertTempurature.Request()
        let celcius = 275 - 273.15 // Celcius
        let fahrenheit = (celcius * (9 / 5)) + 32 // Fahrenheit
        interactor.currentTemp = fahrenheit
        interactor.currentTemperatureTypes = .fahrenheit
        
        // When
        interactor.convertTempurature(request: request)
        
        // Then
        XCTAssertTrue(presenterSpy.presentConvertTempuratureCalled, "convertTempurature() should ask presenter to presentConvertTempurature()")
        
        if let response = presenterSpy.presentConvertTempuratureResponse {
            let celcius = Int((fahrenheit - 32) * (5 / 9))
            XCTAssertEqual(response.currentTemp, celcius)
            XCTAssertEqual(response.currentTemperatureTypes, .celcius)
        } else {
            XCTFail("Cannot get response from presentConvertTempurature()")
        }
    }
}
