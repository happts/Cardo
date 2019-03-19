//
//  CardCell.swift
//  Cardo
//
//  Created by happts on 2019/2/25.
//  Copyright © 2019 happts. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    @IBOutlet private weak var BackgroundImageView: UIImageView!
    
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
        }
        
        get {
            return BackgroundImageView.image
        }
    }
    
    var isShared:Bool {
        get {
            return !ShareImageView.isHidden
        }
        
        set {
            ShareImageView.isHidden = !newValue
        }
    }
    
    var isCollected:Bool {
        get {
            return !CollectImageView.isHidden
        }
        
        set {
            CollectImageView.isHidden = !newValue
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.ShareImageView.image = UIImage(named: "Selected_Cell")
            }else {
                self.ShareImageView.image = UIImage(named: "UnSelect_Cell")
            }
        }
    }
    
    var editState = false {
        didSet {
            self.CollectImageView.isHidden = editState
            if editState {
                self.ShareImageView.isHidden = false
                self.ShareImageView.image = UIImage(named: "UnSelect_Cell")
            }else {
                self.ShareImageView.image = UIImage(named: "分享")
            }
        }
    }
    
    
    
//    var press = UILongPressGestureRecognizer(target: self, action: #selector(presa))
    
//    var longpressAction:(()->Void)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @objc func presa() {
        print("long press")
//        longpressAction()
    }

    
    func setCardCell(cardo:Cardo,index:IndexPath) {
        self.editState = cardo.editState
        self.index = index
        self.name = cardo.title
        self.image = cardo.image
        self.isShared = cardo.isShared
        self.isCollected = cardo.isCollected
    }
}
