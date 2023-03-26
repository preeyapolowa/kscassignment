//
//  LandingWorker.swift
//  KSCAssignment
//
//  Created by Preeyapol Owatsuwan on 24/3/2566 BE.
//

import Foundation

class LandingWorker {
    let store: LandingStoreNetworkLogic
    
    init(store: LandingStoreNetworkLogic) {
        self.store = store
    }
    
    func inquiryLatLonWithCityName(
        request: LatLonRequestModel,
        completion: @escaping (Result<[LatLonResponseModel], CommonError>) -> Void
    ) {
        store.inquiryLatLonWithCityName(request: request, completion: completion)
    }
    
    func inquiryCurrentWeather(
        request: CurrentWeatherRequestModel,
        completion: @escaping (Result<CurrentWeatherResponseModel, CommonError>) -> Void
    ) {
        store.inquiryCurrentWeather(request: request, completion: completion)
    }
}
