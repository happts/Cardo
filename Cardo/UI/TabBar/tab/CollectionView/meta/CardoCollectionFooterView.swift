//
//  CardoCollectionFooterView.swift
//  Cardo
//
//  Created by happts on 2019/3/4.
//  Copyright © 2019 happts. All rights reserved.
//

import UIKit

class CardoCollectionFooterView: UICollectionReusableView {
    
    var viewModel:CardoSectionViewModel!
    var index:IndexPath!
    var collectionView:UICollectionView!
    
    var EditState = false {
        didSet {
            self.isHidden = !EditState
        }
    }
    
    
    @IBOutlet weak var CancelButton: UIButton!
    @IBAction func CancelAction() {
        viewModel.editState = false
    }
}
