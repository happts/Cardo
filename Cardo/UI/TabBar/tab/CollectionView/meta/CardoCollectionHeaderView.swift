//
//  CollectionHeaderView.swift
//  Cardo
//
//  Created by happts on 2019/2/27.
//  Copyright © 2019 happts. All rights reserved.
//

import UIKit

class CardoCollectionHeaderView: UICollectionReusableView {
    
    //id = "headview"
    
    @IBOutlet weak var EditButton: UIButton!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var EditStackView: UIStackView!
    
    var viewModel:CardoSectionViewModel!
    
    var EditState = false {
        didSet {
            EditStackView.isHidden = !EditState
            EditButton.isHidden = EditState
        }
    }
    
    var share:(() -> Void)?
    var collect:(() -> Void)?
    var delete:(() -> Void)?
    var edit:(() -> Void)?
    
    @IBAction func ShareAction() {
        guard let action = share else {
            print("share nil")
            return
        }
        action()
    }
    
    @IBAction func DeleteAction() {
        guard let action = delete else {
            print("delete nil")
            return
        }
        action()
    }
    
    @IBAction func CollectAction() {
        guard let action = collect else {
            print("collect nil")
            return
        }
        action()
    }
    
    @IBAction func EditAction(_ sender: Any) {
        viewModel.editState = true
    }
    
}
