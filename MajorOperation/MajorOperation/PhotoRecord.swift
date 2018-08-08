//
//  PhotoRecord.swift
//  MajorOperation
//
//  Created by Ethan Hess on 7/21/18.
//  Copyright © 2018 EthanHess. All rights reserved.
//

import Foundation
import UIKit

//Self explanatory
enum PhotoRecordState {
    case New, Downloaded, Filtered, Failed
}

class PhotoRecord {
    let name: String
    let url: URL
    var state = PhotoRecordState.New
    var image = UIImage(named: "") //placeholder image
    
    init(name: String, url: URL) {
        self.name = name
        self.url = url
    }
}
