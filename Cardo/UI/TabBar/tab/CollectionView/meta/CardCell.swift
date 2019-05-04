//
//  CardCell.swift
//  Cardo
//
//  Created by happts on 2019/2/25.
//  Copyright © 2019 happts. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    @IBOutlet private weak var BackgroundImageView: UIImageView! {
        didSet {
            

        }
    }
    
    @IBOutlet private weak var CollectImageView: UIImageView!
    @IBOutlet private weak var ShareImageView: UIImageView!
    
    @IBOutlet private weak var NameLabel: UILabel!
    
    var index:IndexPath!
    
    var name:String {
        get {
            return NameLabel.text ?? ""
        }
        
        set {
            NameLabel.text = newValue
        }
    }
    
    var image:UIImage? {
        set {
            BackgroundImageView.image = newValue
            
//            UIGraphicsBeginImageContextWithOptions(BackgroundImageView.bounds.size, true, 0)
//            let ctx = UIGraphicsGetCurrentContext()
//            UIColor.clear.setFill()
//            UIRectFill(BackgroundImageView.bounds)
//            let rect = CGRect(x: 0, y: 0, width: BackgroundImageView.bounds.size.width, height: BackgroundImageView.bounds.size.height)
//            
//            ctx?.addEllipse(in: rect)
//            ctx?.clip()
//            
//            BackgroundImageView.draw(BackgroundImageView.bounds)
//            BackgroundImageView.image = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
            
        }
        
        get {
            return BackgroundImageView.image
        }
    }
    
    var isShared:Bool = false {
        didSet {
            ShareImageView.isHidden = !isShared
        }
    }
    
    var isCollected:Bool = false {
        didSet {
            CollectImageView.isHidden = !isCollected
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if editState {
                if isSelected {
                    self.ShareImageView.image = UIImage(named: "Selected_Cell")
                }else {
                    self.ShareImageView.image = UIImage(named: "UnSelect_Cell")
                }
            }
        }
    }
    
    var editState = false {
        didSet {
            self.CollectImageView.isHidden = editState
            if editState {
                self.CollectImageView.isHidden = true
                self.ShareImageView.isHidden = false
                self.ShareImageView.image = UIImage(named: "UnSelect_Cell")
            }else {
                self.CollectImageView.isHidden = !self.isCollected
                self.ShareImageView.image = UIImage(named: "分享")
            }
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @objc func presa() {
        print("long press")
//        longpressAction()
    }

    
    func setCardCell(cardo:Cardo,index:IndexPath) {
        self.index = index
        self.name = cardo.title
        self.image = UIImage(data: cardo.imageData)
        self.isShared = cardo.isShared
        self.isCollected = cardo.isCollected
        //
        self.editState = cardo.editState
    }
}
