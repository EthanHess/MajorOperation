//
//  PhotoFetcher.swift
//  MajorOperation
//
//  Created by Ethan Hess on 7/22/18.
//  Copyright © 2018 EthanHess. All rights reserved.
//

import UIKit

class PhotoFetcher: NSObject {
    
    static let sharedManager = PhotoFetcher()
    
    func fetchPhotos(theURL: URL, completion:@escaping (_ photos: [PhotoRecord]) -> Void) {
        
        var completionArray : [PhotoRecord] = []

        let request = URLRequest(url: theURL)
        //let queue = OperationQueue.main
    
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription ?? "No description")
                self.showError()
                completion([])
            }
            guard let theData = data else { return }
            do {
                let dataDict = try PropertyListSerialization.propertyList(from: theData, options: PropertyListSerialization.ReadOptions.mutableContainers, format: nil) as! Dictionary<String, String?>
                
                for (key, value) in dataDict {
                    let name = key
                    if value != nil {
                        let url = URL(string: value!)
                        if let fUrl = url {
                            let record = PhotoRecord(name: name, url: fUrl)
                            completionArray.append(record)
                        }
                    }
                }
                
                completion(completionArray)
                
            } catch let error {
                print(error.localizedDescription)
                completion([])
            }
        }.resume()
    }
    
    fileprivate func showError() {
        
        let alertController = UIAlertController(title: "Something went wrong", message: "", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okayAction)
        
        let window = UIApplication.shared.keyWindow
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
