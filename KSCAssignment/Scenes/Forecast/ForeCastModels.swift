//
//  ForeCastModels.swift
//  KSCAssignment
//
//  Created by Preeyapol Owatsuwan on 25/3/2566 BE.
//

import Foundation

enum ForeCastModels {
    enum ForeCast {
        struct Request {
            
        }
        
        struct Response {
            let dataSource: Result<[ForeCastModel], CommonError>
        }
        
        struct ViewModel {
            let dataSource: Result<[ForeCastViewModel], CommonError>
        }
        
        struct ForeCastModel {
            let date: [Substring]?
            let tempCelcius: Int
            let iconPath: String
        }
        
        struct ForeCastViewModel {
            let day: String
            let date: String
            let tempCelcius: String
            let time: String
            let iconURL: URL?
        }
    }
}
