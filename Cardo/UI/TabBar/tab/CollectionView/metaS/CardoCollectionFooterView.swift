//
//  CardoCollectionFooterView.swift
//  Cardo
//
//  Created by happts on 2019/3/4.
//  Copyright © 2019 happts. All rights reserved.
//

import UIKit

class CardoCollectionFooterView: UICollectionReusableView, CardoCollectionHeaderAndFooterProtocol {

    
    weak var viewModel: SectionViewModel?
    
    var index: Int = 1
    
    var EditState: Bool {
        return viewModel?.editState ?? false
    }
    
    func changeState() {
        self.isHidden = !EditState
    }
    
    func bind(viewModel: SectionViewModel,index:Int) {
        self.viewModel = viewModel
        self.index = index
        changeState()
    }
    
    
    @IBOutlet weak var CancelButton: UIButton!
    @IBAction func CancelAction() {
        self.viewModel?.changeState()
        self.viewModel?.deSelectItems()
    }
    
}
