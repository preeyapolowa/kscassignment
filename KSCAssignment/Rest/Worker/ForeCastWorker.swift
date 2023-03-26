//
//  ForeCastWorker.swift
//  KSCAssignment
//
//  Created by Preeyapol Owatsuwan on 25/3/2566 BE.
//

import Foundation

class ForeCastWorker {
    let store: ForeCastStoreNetworkLogic
    
    init(store: ForeCastStoreNetworkLogic) {
        self.store = store
    }
    
    func inquiryForeCast(
        request: ForeCastRequestModel,
        completion: @escaping (Result<ForeCastResponseModel, CommonError>) -> Void
    ) {
        store.inquiryForeCast(request: request, completion: completion)
    }
}
