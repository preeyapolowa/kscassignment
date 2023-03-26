//
//  ForeCastPresenter.swift
//  KSCAssignment
//
//  Created by Preeyapol Owatsuwan on 25/3/2566 BE.
//

import Foundation

protocol ForeCastPresenterPresentationLogic {
    func presentForeCast(response: ForeCastModels.ForeCast.Response)
}

class ForeCastPresenter: ForeCastPresenterPresentationLogic {
    weak var viewController: ForeCastViewControllerDisplayLogic!
    
    private let baseImagePath = "https://openweathermap.org/img/wn/"

    func presentForeCast(response: ForeCastModels.ForeCast.Response) {
        switch response.dataSource {
        case .success(let foreCast):
            var foreCastCellModel: [ForeCastModels.ForeCast.ForeCastViewModel] = []
            for value in foreCast {
                guard let date = value.date?.first,
                      let time = value.date?[1].prefix(5).lowercased() else {
                    viewController.displayForeCast(viewModel: .init(dataSource: .failure(.init(
                        title: "Error",
                        description: "Cannot get day")))
                    )
                    return
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateTime = dateFormatter.date(from: date.lowercased()) ?? Date()
                let day = getTodayWeekDay(date: dateTime)
                
                dateFormatter.dateFormat = "MMM, dd"
                let dateString = dateFormatter.string(from: dateTime)
                let iconURL = URL(string: "\(baseImagePath)\(value.iconPath)@2x.png")
                                
                foreCastCellModel.append(.init(
                    day: day,
                    date: dateString,
                    tempCelcius: "\(value.tempCelcius)°C",
                    time: time,
                    iconURL: iconURL)
                )
            }
            
            viewController.displayForeCast(viewModel: .init(dataSource: .success(foreCastCellModel)))
        case .failure(let error):
            viewController.displayForeCast(viewModel: .init(dataSource: .failure(error)))
        }
    }
}

// MARK: - Common Function

extension ForeCastPresenter {
    private func getTodayWeekDay(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekDay = dateFormatter.string(from: date)
        return weekDay
    }
}
