//
//  CommonError.swift
//  KSCAssignment
//
//  Created by Preeyapol Owatsuwan on 24/3/2566 BE.
//

import Foundation

struct CommonError: Error {
    let title: String
    let description: String
    
    init(title: String,
         description: String) {
        self.title = title
        self.description = description
    }
}
