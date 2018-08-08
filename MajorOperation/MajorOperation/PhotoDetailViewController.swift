//
//  PhotoDetailViewController.swift
//  MajorOperation
//
//  Created by Ethan Hess on 7/29/18.
//  Copyright © 2018 EthanHess. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    var theImage : UIImage!
    
    var scrollView : UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        config()
    }
    
    fileprivate func config() {
        
        guard let keyWindow = UIApplication.shared.keyWindow else { return }

        scrollView = UIScrollView(frame: keyWindow.frame)
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * 3, height: scrollView.frame.size.height)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.size.width * 3, height: scrollView.frame.size.height))
        imageView.image = theImage
        scrollView.addSubview(imageView)
        self.view.addSubview(scrollView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
