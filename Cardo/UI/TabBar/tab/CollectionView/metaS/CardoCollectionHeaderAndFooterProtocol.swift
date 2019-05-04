//
//  CardoCollectionReusableView.swift
//  CardoB
//
//  Created by happts on 2019/4/23.
//  Copyright © 2019 happts. All rights reserved.
//

import UIKit

protocol CardoCollectionHeaderAndFooterProtocol {
    var viewModel:SectionViewModel? {get set}
    var index:Int {get set}
    
    var EditState:Bool {get}
    
    func changeState()
    func bind(viewModel: SectionViewModel,index:Int)
}
