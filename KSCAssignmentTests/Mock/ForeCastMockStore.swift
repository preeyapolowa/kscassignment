//
//  ForeCastMockStore.swift
//  KSCAssignmentTests
//
//  Created by Preeyapol Owatsuwan on 26/3/2566 BE.
//

@testable import KSCAssignment
import Foundation

class ForeCastMockStore: ForeCastStoreNetworkLogic {
    func inquiryForeCast(request: KSCAssignment.ForeCastRequestModel, completion: @escaping (Result<KSCAssignment.ForeCastResponseModel, KSCAssignment.CommonError>) -> Void) {
        let model = ForeCastResponseModel(
            cod: nil,
            message: nil,
            cnt: nil,
            list: [ForeCastResponseModel.List.init(
                dt: nil,
                main: .init(
                    temp: 297,
                    feelsLike: nil,
                    tempMin: nil,
                    tempMax: nil,
                    pressure: nil,
                    seaLevel: nil,
                    grndLevel: nil,
                    humidity: nil,
                    tempKf: nil
                ),
                weather: [ForeCastResponseModel.Weather.init(
                    id: nil,
                    main: nil,
                    description: nil,
                    icon: "10n"
                )],
                clouds: nil,
                wind: nil,
                visibility: nil,
                pop: nil,
                rain: nil,
                sys: nil,
                dtTxt: "2022-08-30 15:00:00")],
            city: nil)
        completion(.success(model))
    }
}
