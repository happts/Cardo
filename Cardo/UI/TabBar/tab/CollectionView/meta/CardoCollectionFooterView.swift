//
//  CardoCollectionFooterView.swift
//  Cardo
//
//  Created by happts on 2019/3/4.
//  Copyright © 2019 happts. All rights reserved.
//

import UIKit

class CardoCollectionFooterView: UICollectionReusableView {
    
    
    var data:Day_Cardos! {
        didSet {
            self.EditState = data.editState
        }
    }
    
    var EditState = false {
        didSet {
            self.isHidden = !EditState
        }
    }
    
    
    @IBOutlet weak var CancelButton: UIButton!
    @IBAction func CancelAction() {
        data.editState = false
    }
    
}
