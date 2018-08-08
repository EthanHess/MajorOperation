//
//  ImageDownloader.swift
//  MajorOperation
//
//  Created by Ethan Hess on 7/21/18.
//  Copyright © 2018 EthanHess. All rights reserved.
//

import UIKit

class ImageDownloader: Operation {

    let photoRecord: PhotoRecord
    
    init(photoRecord: PhotoRecord) {
        self.photoRecord = photoRecord
    }
    
    override func main() {
        if self.isCancelled == true {
            return
        }
        
        var imageData: Data?
        
        do {
            imageData = try Data(contentsOf: self.photoRecord.url)
        } catch let error {
            print(error.localizedDescription)
        }
        
        guard let theData = imageData else { return }
        
        if self.isCancelled == true {
            return
        }
        
        if theData.count > 0 {
            self.photoRecord.image = UIImage(data: theData)
            self.photoRecord.state = .Downloaded
        } else {
            self.photoRecord.image = UIImage(named: "") //failed
            self.photoRecord.state = .Failed
        }
    }
}
