//
//  ForeCastInteractor.swift
//  KSCAssignment
//
//  Created by Preeyapol Owatsuwan on 25/3/2566 BE.
//

import Foundation

protocol ForeCastInteractorBusinessLogic {
    func inquiryForeCast(request: ForeCastModels.ForeCast.Request)
    
    var lat: String? { get set }
    var lon: String? { get set }
}

class ForeCastInteractor: ForeCastInteractorBusinessLogic {
    var presenter: ForeCastPresenterPresentationLogic!
    var foreCastWorker = ForeCastWorker(store: ForeCastStore())
    
    var lat: String?
    var lon: String?
    
    func inquiryForeCast(request: ForeCastModels.ForeCast.Request) {
        guard let lat = lat,
              let lon = lon else {
            presenter.presentForeCast(response: .init(dataSource: .failure(.init(
                title: "Error",
                description: "Cannot get lat lon")))
            )
            return
        }
        
        foreCastWorker.inquiryForeCast(request: .init(lat: lat, lon: lon)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let foreCast):
                guard let list = foreCast.list else {
                    self.presenter.presentForeCast(response: .init(dataSource: .failure(.init(
                        title: "Error",
                        description: "Cannot get fore cast list")))
                    )
                    return
                }
                
                var foreCastArrays: [ForeCastModels.ForeCast.ForeCastModel] = []
                for value in list {
                    guard let weather = value.weather,
                          let firstArray = weather.first else {
                        self.presenter.presentForeCast(response: .init(dataSource: .failure(.init(
                            title: "Error",
                            description: "Cannot get weather list")))
                        )
                        return
                    }
                    
                    let date = value.dtTxt?.split(separator: " ")
                    let celcius = (value.main?.temp ?? 0.00) - 273.15
                    let iconPath = firstArray.icon ?? ""
                    
                    foreCastArrays.append(.init(
                        date: date,
                        tempCelcius: Int(celcius),
                        iconPath: iconPath)
                    )
                }
                
                self.presenter.presentForeCast(response: .init(dataSource: .success(foreCastArrays)))
            case .failure(let error):
                self.presenter.presentForeCast(response: .init(dataSource: .failure(error)))
            }
        }
    }
}
