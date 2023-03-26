//
//  LandingRouter.swift
//  KSCAssignment
//
//  Created by Preeyapol Owatsuwan on 24/3/2566 BE.
//

import Foundation
import UIKit

protocol LandingRouterRoutingLogic: AnyObject {
    func navigateToForeCast(lat: String, lon: String)
}

class LandingRouter: LandingRouterRoutingLogic {
    weak var viewController: LandingViewController!
    
    func navigateToForeCast(lat: String, lon: String) {
        let storyboard = UIStoryboard(name: "ForeCast", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ForeCastViewController") as? ForeCastViewController else { return }
        vc.interactor.lat = lat
        vc.interactor.lon = lon
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}
