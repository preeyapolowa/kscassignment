//
//  LandingPresenterTests.swift
//  KSCAssignmentTests
//
//  Created by Preeyapol Owatsuwan on 26/3/2566 BE.
//

@testable import KSCAssignment
import XCTest

class LandingPresenterTests: XCTestCase {
    private var presenter: LandingPresenter!
    private var viewControllerSpy: LandingViewControllerSpy!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
      super.setUp()
        setupLandingPresenterTests()
    }
    
    override func tearDown() {
      super.tearDown()
    }

    // MARK: - Test setup
    
    private func setupLandingPresenterTests() {
      presenter = LandingPresenter()
      viewControllerSpy = LandingViewControllerSpy()
      presenter.viewController = viewControllerSpy
    }
    
    // MARK: - Spy class
    
    final class LandingViewControllerSpy: LandingViewControllerDisplayLogic {
        var displayCurrentLatLonWeatherCalled = false
        var displayCurrentLatLonCalled = false
        var displayConvertTempuratureCalled = false
        
        var displayCurrentLatLonWeatherViewModel: LandingModels.CurrentLatLonWeather.ViewModel!
        var displayCurrentLatLonViewModel: LandingModels.CurrentLatLon.ViewModel!
        var displayConvertTempuratureViewModel: LandingModels.ConvertTempurature.ViewModel!
        
        func displayCurrentLatLonWeather(viewModel: LandingModels.CurrentLatLonWeather.ViewModel) {
            displayCurrentLatLonWeatherCalled = true
            displayCurrentLatLonWeatherViewModel = viewModel
        }
        
        func displayCurrentLatLon(viewModel: LandingModels.CurrentLatLon.ViewModel) {
            displayCurrentLatLonCalled = true
            displayCurrentLatLonViewModel = viewModel
        }
        
        func displayConvertTempurature(viewModel: LandingModels.ConvertTempurature.ViewModel) {
            displayConvertTempuratureCalled = true
            displayConvertTempuratureViewModel = viewModel
        }
    }
    
    // MARK: - presentCurrentLatLonWeather tests
    
    func testPresentCurrentLatLonWeatherSuccess() {
        // Given
        let response = LandingModels.CurrentLatLonWeather.Response(dataSource: .success(.init(
            currentWeatherPath: "10n",
            tempCelcius: 30,
            humidity: 60))
        )
        
        // When
        presenter.presentCurrentLatLonWeather(response: response)
        
        // Then
        XCTAssertTrue(viewControllerSpy.displayCurrentLatLonWeatherCalled, "presentCurrentLatLonWeather() should ask viewController to displayCurrentLatLonWeather()")
        
        if let viewModel = viewControllerSpy.displayCurrentLatLonWeatherViewModel {
            switch viewModel.dataSource {
            case .success(let weather):
                let tempCelcius = "\(weather.tempCelcius)"
                XCTAssertEqual(weather.humidity, "60%")
                XCTAssertEqual(weather.tempCelcius, tempCelcius)
                XCTAssertEqual(weather.currentWeatherURL, URL(string: "https://openweathermap.org/img/wn/10n@2x.png")!)
            case .failure:
                XCTFail("ViewModel should not be failed")
            }
        } else {
            XCTFail("Cannot get viewModel from displayCurrentLatLonWeather()")
        }
    }
    
    func testPresentCurrentLatLonWeatherFailed() {
        // Given
        let response = LandingModels.CurrentLatLonWeather.Response(dataSource: .failure(.init(
            title: "Error",
            description: "Description"))
        )
        
        // When
        presenter.presentCurrentLatLonWeather(response: response)
        
        // Then
        XCTAssertTrue(viewControllerSpy.displayCurrentLatLonWeatherCalled, "presentCurrentLatLonWeather() should ask viewController to displayCurrentLatLonWeather()")

        if let viewModel = viewControllerSpy.displayCurrentLatLonWeatherViewModel {
            switch viewModel.dataSource {
            case .success:
                XCTFail("ViewModel should not be succeeded")
            case .failure(let error):
                XCTAssertEqual(error.title, "Error")
                XCTAssertEqual(error.description, "Description")
            }
        } else {
            XCTFail("Cannot get viewModel from displayCurrentLatLonWeather()")
        }
    }
    
    // MARK: - presentCurrentLatLonWeather tests

    func testPresentCurrentLatLonSuccess() {
        // Given
        let response = LandingModels.CurrentLatLon.Response(dataSource: .success(.init(lat: "14.00", lon: "14.00")))
        
        // When
        presenter.presentCurrentLatLon(response: response)
        
        // Then
        XCTAssertTrue(viewControllerSpy.displayCurrentLatLonCalled, "presentCurrentLatLon() should ask viewController to displayCurrentLatLon()")
        
        if let viewModel = viewControllerSpy.displayCurrentLatLonViewModel {
            switch viewModel.dataSource {
            case .success(let latlon):
                XCTAssertEqual(latlon.lat, "14.00")
                XCTAssertEqual(latlon.lon, "14.00")
            case .failure:
                XCTFail("ViewModel should not be failed")
            }
        } else {
            XCTFail("Cannot get viewModel from displayCurrentLatLon()")
        }
    }
    
    func testPresentCurrentLatLonFailed() {
        // Given
        let response = LandingModels.CurrentLatLon.Response(dataSource: .failure(.init(
            title: "Error",
            description: "Description"))
        )
        
        // When
        presenter.presentCurrentLatLon(response: response)
        
        // Then
        XCTAssertTrue(viewControllerSpy.displayCurrentLatLonCalled, "presentCurrentLatLon() should ask viewController to displayCurrentLatLon()")
        
        if let viewModel = viewControllerSpy.displayCurrentLatLonViewModel {
            switch viewModel.dataSource {
            case .success:
                XCTFail("ViewModel should not be succeeded")
            case .failure(let error):
                XCTAssertEqual(error.title, "Error")
                XCTAssertEqual(error.description, "Description")
            }
        } else {
            XCTFail("Cannot get viewModel from displayCurrentLatLon()")
        }
    }
    
    // MARK: - presentConvertTempurature tests
    
    func testPresentConvertTempuratureCelcius() {
        // Given
        let response = LandingModels.ConvertTempurature.Response(
            currentTemperatureTypes: .celcius,
            currentTemp: 97 // Fahrenheit
        )
        
        // When
        presenter.presentConvertTempurature(response: response)
        
        // Then
        XCTAssertTrue(viewControllerSpy.displayConvertTempuratureCalled, "presentConvertTempurature() should ask viewController to displayConvertTempurature()")
        
        if let viewModel = viewControllerSpy.displayConvertTempuratureViewModel {
            XCTAssertEqual(viewModel.temperature, "97°C")
        } else {
            XCTFail("Cannot get viewModel from displayConvertTempurature()")
        }
    }
    
    func testPresentConvertTempuratureFahrenheit() {
        // Given
        let response = LandingModels.ConvertTempurature.Response(
            currentTemperatureTypes: .fahrenheit,
            currentTemp: 32 // Celcius
        )
        
        // When
        presenter.presentConvertTempurature(response: response)
        
        // Then
        XCTAssertTrue(viewControllerSpy.displayConvertTempuratureCalled, "presentConvertTempurature() should ask viewController to displayConvertTempurature()")
        
        if let viewModel = viewControllerSpy.displayConvertTempuratureViewModel {
            XCTAssertEqual(viewModel.temperature, "32°F")
        } else {
            XCTFail("Cannot get viewModel from displayConvertTempurature()")
        }
    }
}
