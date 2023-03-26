//
//  ForeCastInteractorTests.swift
//  KSCAssignmentTests
//
//  Created by Preeyapol Owatsuwan on 26/3/2566 BE.
//

@testable import KSCAssignment
import XCTest

class ForeCastInteractorTests: XCTestCase {
    private var interactor: ForeCastInteractor!
    private var presenterSpy: ForeCastPrsenterSpy!
    private var workerSpy: ForeCastWorkerSpy!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupForeCastInteractorTests()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private func setupForeCastInteractorTests() {
        interactor = ForeCastInteractor()
        presenterSpy = ForeCastPrsenterSpy()
        workerSpy = ForeCastWorkerSpy(store: ForeCastMockStore())
        interactor.presenter = presenterSpy
        interactor.foreCastWorker = workerSpy
    }
    
    // MARK: - Spy Class
    
    final class ForeCastPrsenterSpy: ForeCastPresenterPresentationLogic {
        var presentForeCastCalled = false
        var presentForeCastResponse: ForeCastModels.ForeCast.Response!
    
        func presentForeCast(response: ForeCastModels.ForeCast.Response) {
            presentForeCastCalled = true
            presentForeCastResponse = response
        }
    }
    
    final class ForeCastWorkerSpy: ForeCastWorker {
        var inquiryForeCastCalled = false
        
        var forceError = false
        var forceEmpty = false
        var forceNil = false
        
        override func inquiryForeCast(request: ForeCastRequestModel, completion: @escaping (Result<ForeCastResponseModel, CommonError>) -> Void) {
            inquiryForeCastCalled = true
            if forceError {
                completion(.failure(.init(
                    title: "Error",
                    description: "Description")
                ))
            } else if forceEmpty {
                completion(.success(.init(
                    cod: nil,
                    message: nil,
                    cnt: nil,
                    list: [.init(
                        dt: nil,
                        main: nil,
                        weather: [],
                        clouds: nil,
                        wind: nil,
                        visibility: nil,
                        pop: nil,
                        rain: nil,
                        sys: nil,
                        dtTxt: nil
                    )],
                    city: nil)
                ))
            } else if forceNil {
                completion(.success(.init(
                    cod: nil,
                    message: nil,
                    cnt: nil,
                    list: nil,
                    city: nil)
                ))
            } else {
                super.inquiryForeCast(request: request, completion: completion)
            }
        }
    }
    
    // MARK: - inquiryForeCast Tests
    
    func testInquiryForeCastSuccess() {
        // Given
        let request = ForeCastModels.ForeCast.Request()
        interactor.lat = "14.00"
        interactor.lon = "14.00"
        
        // When
        interactor.inquiryForeCast(request: request)
        
        // Then
        XCTAssertTrue(presenterSpy.presentForeCastCalled, "inquiryForeCast() should ask presenter to presentForeCast()")
        XCTAssertTrue(workerSpy.inquiryForeCastCalled, "inquiryForeCast() should ask worker to inquiryForeCast()")
        
        if let response = presenterSpy.presentForeCastResponse {
            switch response.dataSource {
            case .success(let foreCast):
                guard let firstArray = foreCast.first else {
                    XCTFail("Array should not empty")
                    return
                }
                let date = "2022-08-30 15:00:00".split(separator: " ")
                let celcius = Int(297 - 273.15)
                
                XCTAssertEqual(firstArray.tempCelcius, celcius)
                XCTAssertEqual(firstArray.date, date)
                XCTAssertEqual(firstArray.iconPath, "10n")
            case .failure:
                XCTFail("Response should not be failed")
            }
        } else {
            XCTFail("Cannot get response from presentForeCast()")
        }
    }
    
    func testInquiryForeCastWithoutLatLon() {
        // Given
        let request = ForeCastModels.ForeCast.Request()
        
        // When
        interactor.inquiryForeCast(request: request)
        
        // Then
        XCTAssertTrue(presenterSpy.presentForeCastCalled, "inquiryForeCast() should ask presenter to presentForeCast()")
        XCTAssertFalse(workerSpy.inquiryForeCastCalled, "inquiryForeCast() should not ask worker to inquiryForeCast()")

        if let response = presenterSpy.presentForeCastResponse {
            switch response.dataSource {
            case .success:
                XCTFail("Response should not be succeeded")
            case .failure(let error):
                XCTAssertEqual(error.title, "Error")
                XCTAssertEqual(error.description, "Cannot get lat lon")
            }
        } else {
            XCTFail("Cannot get response from presentForeCast()")
        }
    }
    
    func testInquiryForeCastFailed() {
        // Given
        let request = ForeCastModels.ForeCast.Request()
        interactor.lat = "14.00"
        interactor.lon = "14.00"
        workerSpy.forceError = true
        
        // When
        interactor.inquiryForeCast(request: request)
        
        // Then
        XCTAssertTrue(presenterSpy.presentForeCastCalled, "inquiryForeCast() should ask presenter to presentForeCast()")
        XCTAssertTrue(workerSpy.inquiryForeCastCalled, "inquiryForeCast() should ask worker to inquiryForeCast()")

        if let response = presenterSpy.presentForeCastResponse {
            switch response.dataSource {
            case .success:
                XCTFail("Response should not be succeeded")
            case .failure(let error):
                XCTAssertEqual(error.title, "Error")
                XCTAssertEqual(error.description, "Description")
            }
        } else {
            XCTFail("Cannot get response from presentForeCast()")
        }
    }
    
    func testInquiryForeCastEmpty() {
        // Given
        let request = ForeCastModels.ForeCast.Request()
        interactor.lat = "14.00"
        interactor.lon = "14.00"
        workerSpy.forceEmpty = true
        
        // When
        interactor.inquiryForeCast(request: request)
        
        // Then
        XCTAssertTrue(presenterSpy.presentForeCastCalled, "inquiryForeCast() should ask presenter to presentForeCast()")
        XCTAssertTrue(workerSpy.inquiryForeCastCalled, "inquiryForeCast() should ask worker to inquiryForeCast()")

        if let response = presenterSpy.presentForeCastResponse {
            switch response.dataSource {
            case .success:
                XCTFail("Response should not be succeeded")
            case .failure(let error):
                XCTAssertEqual(error.title, "Error")
                XCTAssertEqual(error.description, "Cannot get weather list")
            }
        } else {
            XCTFail("Cannot get response from presentForeCast()")
        }
    }
    
    func testInquiryForeCastNil() {
        // Given
        let request = ForeCastModels.ForeCast.Request()
        interactor.lat = "14.00"
        interactor.lon = "14.00"
        workerSpy.forceNil = true
        
        // When
        interactor.inquiryForeCast(request: request)
        
        // Then
        XCTAssertTrue(presenterSpy.presentForeCastCalled, "inquiryForeCast() should ask presenter to presentForeCast()")
        XCTAssertTrue(workerSpy.inquiryForeCastCalled, "inquiryForeCast() should ask worker to inquiryForeCast()")

        if let response = presenterSpy.presentForeCastResponse {
            switch response.dataSource {
            case .success:
                XCTFail("Response should not be succeeded")
            case .failure(let error):
                XCTAssertEqual(error.title, "Error")
                XCTAssertEqual(error.description, "Cannot get fore cast list")
            }
        } else {
            XCTFail("Cannot get response from presentForeCast()")
        }
    }
}
