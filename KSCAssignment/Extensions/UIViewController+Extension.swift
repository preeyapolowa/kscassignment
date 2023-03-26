//
//  UIViewController+Extension.swift
//  KSCAssignment
//
//  Created by Preeyapol Owatsuwan on 24/3/2566 BE.
//

import Foundation
import UIKit

extension UIViewController {
    var loadingHandler: LoadingHandler {
        return LoadingHandler(vc: self)
    }
    
    func showLoading() {
        loadingHandler.initiateLoading()
    }
    
    func hideLoading() {
        loadingHandler.hideLoading()
    }
    
    func showErrorPopup(
        title: String,
        description: String,
        action: ((UIAlertAction) -> Void)? = nil
    ) {
        // Dismiss something that may breaks when present popup
        dismiss(animated: false) { [weak self] in
            guard let self = self else { return }
            let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default, handler: action))
            self.present(alert, animated: true)
        }
    }
}
