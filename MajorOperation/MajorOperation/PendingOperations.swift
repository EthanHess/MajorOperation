//
//  PendingOperations.swift
//  MajorOperation
//
//  Created by Ethan Hess on 7/21/18.
//  Copyright © 2018 EthanHess. All rights reserved.
//

import Foundation
import UIKit

class PendingOperations {
    
    lazy var downloadsInProgress = [IndexPath: Operation]()
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "DownloadQueue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    lazy var filtrationInProgress = [IndexPath: Operation]()
    lazy var filtrationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "FiltrationQueue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}
