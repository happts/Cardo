//
//  Day_Cardos.swift
//  Cardo
//
//  Created by happts on 2019/3/24.
//  Copyright © 2019 happts. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

import Alamofire
import SwiftyJSON

class Day_Cardos_Model {
    var dateS:String = "X月X日"
    var cardos:[Cardo] = []
    //
    var data : Data = Data()
    //
    var section:Int = 0
    weak var CollectionView:UICollectionView?
    
    // FIXME: 后续版本删除
    var collectedCardos:[Cardo] {
        get {
            return cardos.filter({ (cardo) -> Bool in
                return cardo.isCollected
            })
        }
    }
    
    
    var editState = false {
        didSet {
            for cardo in cardos {
                cardo.editState = editState
            }
            // FIXME: 记得删除/修改/新的
//            header?.EditState = editState
//            footer?.EditState = editState
            self.CollectionView?.reloadSections([section])
        }
    }
    
    weak var footer:CardoCollectionFooterView? = nil
}
