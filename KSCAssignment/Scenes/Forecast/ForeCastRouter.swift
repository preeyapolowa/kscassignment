//
//  ForeCastRouter.swift
//  KSCAssignment
//
//  Created by Preeyapol Owatsuwan on 25/3/2566 BE.
//

import Foundation

protocol ForeCastRouterRoutingLogic {
    func navigateBack()
}

class ForeCastRouter: ForeCastRouterRoutingLogic {
    weak var viewController: ForeCastViewController!
    
    func navigateBack() {
        viewController.navigationController?.popViewController(animated: true)
    }
}
