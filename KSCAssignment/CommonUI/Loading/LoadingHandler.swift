//
//  LoadingHandler.swift
//  KSCAssignment
//
//  Created by Preeyapol Owatsuwan on 24/3/2566 BE.
//

import Foundation
import UIKit

class LoadingHandler {
    let vc: UIViewController
    
    init(vc: UIViewController) {
        self.vc = vc
    }
    
    func initiateLoading() {
        let storyboard = UIStoryboard(name: "Loading", bundle: nil)
        let loadingVC = storyboard.instantiateViewController(withIdentifier: "LoadingViewController")
        loadingVC.modalPresentationStyle = .overFullScreen
        loadingVC.modalTransitionStyle = .crossDissolve
        loadingVC.view.backgroundColor = .black.withAlphaComponent(0.5)
        vc.present(loadingVC, animated: true)
    }
    
    func hideLoading() {
        vc.dismiss(animated: false)
    }
}
