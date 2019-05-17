//
//  CardCell.swift
//  Cardo
//
//  Created by happts on 2019/2/25.
//  Copyright © 2019 happts. All rights reserved.
//

import UIKit
import AlamofireImage

class CardCell: UICollectionViewCell {
    @IBOutlet private weak var BackgroundImageView: UIImageView!
    @IBOutlet private weak var CollectImageView: UIImageView!
    @IBOutlet private weak var ShareImageView: UIImageView!
    @IBOutlet private weak var SelectImageView: UIImageView!
    
    @IBOutlet private weak var NameLabel: UILabel!
    
    var sectionViewModel:SectionViewModel?
    var cardoId:Int?
    var indexPath:IndexPath!
    
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
    
    var hasEdited = false
    
    // TODO :可能要修改
    override var isSelected: Bool {
        didSet {
            if editState {
                if isSelected {
                    self.SelectImageView.image = UIImage(named: "Selected_Cell")
                }else {
                    self.SelectImageView.image = UIImage(named: "UnSelect_Cell")
                }
            }
        }
    }
    
    var editState:Bool {
        return sectionViewModel?.editState ?? false
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @objc func presa() {
        print("long press")
        //        longpressAction()
    }
    
    func bindCell(sectionViewModel:SectionViewModel,index:IndexPath) {
        sectionViewModel.data.cardos[index.item].cell = self
        
        self.cardoId = sectionViewModel.data.cardos[index.item].id
        self.sectionViewModel = sectionViewModel
        self.indexPath = index
        
        self.name = self.sectionViewModel!.data.cardos[indexPath.item].title
        
        if let imagedata = sectionViewModel.data.cardos[index.item].imageData {
            self.image = UIImage(data: imagedata)
        }
        //
        changeState()
    }
    
    func changeState() {
        // TODO: 完善
        if editState {
            self.CollectImageView.isHidden = true
            self.ShareImageView.isHidden = true
            self.SelectImageView.isHidden = false
        }else {
            self.SelectImageView.isHidden = true
            // FIXME: index out of range
            self.isShared = sectionViewModel!.data.cardos[self.indexPath.item].isShared
            self.isCollected = sectionViewModel!.data.cardos[indexPath.item].isCollected
        }
    }
}
