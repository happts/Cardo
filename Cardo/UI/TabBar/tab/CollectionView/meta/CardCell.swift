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
    
    var editState = false {
        didSet {
            self.CollectImageView.isHidden = editState
            self.ShareImageView.image = UIImage(named: "UnSelect_Cell")
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
