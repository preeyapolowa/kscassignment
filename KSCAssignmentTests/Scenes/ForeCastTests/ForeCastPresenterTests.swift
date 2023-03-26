//
//  ForeCastPresenterTests.swift
//  KSCAssignmentTests
//
//  Created by Preeyapol Owatsuwan on 26/3/2566 BE.
//

@testable import KSCAssignment
import XCTest

class ForeCastPresenterTests: XCTestCase {
    private var presenter: ForeCastPresenter!
    private var viewControllerSpy: ForeCastViewControllerSpy!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
      super.setUp()
        setupForeCastPresenterTests()
    }
    
    override func tearDown() {
      super.tearDown()
    }

    // MARK: - Test setup
    
    private func setupForeCastPresenterTests() {
      presenter = ForeCastPresenter()
      viewControllerSpy = ForeCastViewControllerSpy()
      presenter.viewController = viewControllerSpy
    }
    
    // MARK: - Spy class
    
    final class ForeCastViewControllerSpy: ForeCastViewControllerDisplayLogic {
        var displayForeCastCalled = false
        var displayForeCastViewModel: ForeCastModels.ForeCast.ViewModel!
        
        func displayForeCast(viewModel: ForeCastModels.ForeCast.ViewModel) {
            displayForeCastCalled = true
            displayForeCastViewModel = viewModel
        }
    }
    
    // MARK: - presentForeCast Tests
    
    func testPresentForeCastSuccess() {
        // Given
        let date = "2022-08-30 15:00:00".split(separator: " ")
        let response = ForeCastModels.ForeCast.Response(dataSource: .success([.init(
            date: date,
            tempCelcius: 32,
            iconPath: "10n")
        ]))
        
        // When
        presenter.presentForeCast(response: response)
        
        // Then
        XCTAssertTrue(viewControllerSpy.displayForeCastCalled, "presentForeCast() should ask viewController to displayForeCast()")
        
        if let viewModel = viewControllerSpy.displayForeCastViewModel {
            switch viewModel.dataSource {
            case .success(let foreCast):
                guard let firstArray = foreCast.first else {
                    XCTFail("Array should not empty")
                    return
                }
                XCTAssertEqual(firstArray.date, "Aug, 30")
                XCTAssertEqual(firstArray.tempCelcius, "32°C")
                XCTAssertEqual(firstArray.day, "Tuesday")
                XCTAssertEqual(firstArray.iconURL, URL(string: "https://openweathermap.org/img/wn/10n@2x.png"))
                XCTAssertEqual(firstArray.time, "15:00")
            case .failure:
                XCTFail("ViewModel should not be failed")
            }
        } else {
            XCTFail("Cannot get viewModel from displayForeCast()")
        }
    }
    
    func testPresentForeCastFailed() {
        // Given
        let response = ForeCastModels.ForeCast.Response(dataSource: .failure(.init(
            title: "Error",
            description: "Description")
        ))
        
        // When
        presenter.presentForeCast(response: response)
        
        // Then
        XCTAssertTrue(viewControllerSpy.displayForeCastCalled, "presentForeCast() should ask viewController to displayForeCast()")
        
        if let viewModel = viewControllerSpy.displayForeCastViewModel {
            switch viewModel.dataSource {
            case .success:
                XCTFail("ViewModel should not be succeeded")
            case .failure(let error):
                XCTAssertEqual(error.title, "Error")
                XCTAssertEqual(error.description, "Description")
            }
        } else {
            XCTFail("Cannot get viewModel from displayForeCast()")
        }
    }
}
