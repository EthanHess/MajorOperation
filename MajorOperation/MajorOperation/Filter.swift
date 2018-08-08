//
//  Filter.swift
//  MajorOperation
//
//  Created by Ethan Hess on 7/21/18.
//  Copyright © 2018 EthanHess. All rights reserved.
//

import UIKit

class Filter: Operation {
    
    let photoRecord: PhotoRecord
    
    init(photoRecord: PhotoRecord) {
        self.photoRecord = photoRecord
    }
    
    override func main() {
        if self.isCancelled == true {
            return
        }
        if self.photoRecord.state != .Downloaded {
            return
        }
        
        guard let theImage = self.photoRecord.image else { return }
        
        if let filteredImage = self.applySepiaFilter(image: theImage) {
            self.photoRecord.image = filteredImage
            self.photoRecord.state = .Filtered
        }
    }
}

extension Filter {
    func applySepiaFilter(image: UIImage) -> UIImage? {
        let inputImage = CIImage(data: UIImagePNGRepresentation(image)!)
        if self.isCancelled == true {
            return nil
        }
        
        let context = CIContext(options: nil)
        
        guard let theFilter = CIFilter(name: "CISepiaTone") else { return nil }
        
        theFilter.setValue(inputImage, forKey: kCIInputImageKey)
        theFilter.setValue(0.8, forKey: "inputIntensity")
        let outputImage = theFilter.outputImage
        
        if outputImage == nil {
            return nil
        }
        
        if self.isCancelled == true { //Flag?
            return nil
        }
        
        let outImage = context.createCGImage(outputImage!, from: outputImage!.extent)
        let returnImage = UIImage(cgImage: outImage!)
        
        return returnImage
    }
}
