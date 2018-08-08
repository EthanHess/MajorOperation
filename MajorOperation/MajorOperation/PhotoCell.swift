//
//  PhotoCell.swift
//  MajorOperation
//
//  Created by Ethan Hess on 8/6/18.
//  Copyright © 2018 EthanHess. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {
    
    var theLabel : UILabel = {
        let tl = UILabel()
        return tl
    }()
    
    var theImageView : UIImageView = {
        let tiv = UIImageView()
        return tiv
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //viewSetup()
    }
    
    func viewSetup() {
        
        let xCoord = CGFloat(20)
        let yCoordIV = CGFloat(20)
        let width = self.contentView.frame.size.width - 40
        let ivHeight = self.contentView.frame.size.height - 90
        
        theImageView = UIImageView(frame: CGRect(x: xCoord, y: yCoordIV, width: width, height: ivHeight))
        theImageView.layer.borderColor = UIColor.black.cgColor
        theImageView.backgroundColor = UIColor.lightGray
        theImageView.layer.cornerRadius = 5
        theImageView.layer.borderWidth = 1
        theImageView.layer.masksToBounds = true
        theImageView.contentMode = .scaleAspectFill
        self.contentView.addSubview(theImageView)
        
        let yCoordLB = theImageView.frame.size.height + 40
        
        theLabel = UILabel(frame: CGRect(x: xCoord, y: yCoordLB, width: width, height: 30))
        theLabel.textAlignment = .center
        theLabel.textColor = .darkGray
        theLabel.backgroundColor = .white
        theLabel.layer.cornerRadius = 5
        theLabel.layer.borderWidth = 1
        theLabel.layer.masksToBounds = true
        self.contentView.addSubview(theLabel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
