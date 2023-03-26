//
//  ForeCastCellModel.swift
//  KSCAssignment
//
//  Created by Preeyapol Owatsuwan on 25/3/2566 BE.
//

import Foundation

struct ForeCastCellModel {
    let day: String
    let date: String
    let time: String
    let tempCelcius: String
    let iconURL: URL?
    
    init(model: ForeCastModels.ForeCast.ForeCastViewModel) {
        day = model.day
        date = model.date
        time = model.time
        tempCelcius = model.tempCelcius
        iconURL = model.iconURL
    }
}
