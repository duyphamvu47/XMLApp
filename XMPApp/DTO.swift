//
//  DTO.swift
//  XMPApp
//
//  Created by Vu Duy on 10/07/2021.
//

import Foundation
class DTO{
    var id:String
    var url:String
    
    init(id: String, url: URL) {
        self.id = id
        self.url = url.path
    }
    
    
}
