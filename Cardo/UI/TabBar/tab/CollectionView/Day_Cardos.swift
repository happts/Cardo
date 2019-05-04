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

class Day_Cardos {
    var dateS:String = "X月X日"
    var cardos:[Cardo] = []
    //
    var data : Data = Data()
    //
    var section:Int = 0
    weak var CollectionView:UICollectionView?
    
    //
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
            header?.EditState = editState
            footer?.EditState = editState
            self.CollectionView?.reloadSections([section])
        }
    }
    
    
    ///
    weak var header:CardoCollectionHeaderView? = nil {
        didSet{
            header?.collect = {
                for index in self.CollectionView?.indexPathsForSelectedItems ?? [] {
                    if index.section == self.section {
                        // MARK: - web
                        self.cardos[index.row].isCollected = true
                    }
                }
                self.editState = false
            }
            
            header?.share = {
                for index in self.CollectionView?.indexPathsForSelectedItems ?? [] {
                    if index.section == self.section {
                        // MARK: - web
                        self.cardos[index.row].isShared = true
                    }
                }
                self.editState = false
            }
            
            header?.delete = {
                UIAlertUtils.alertControllerDistructive(ViewController: self.CollectionView?.delegate as! UIViewController, message: "确认删除已选中的 Cardo?", deleteHandler: { (_) in
                    for index in self.CollectionView?.indexPathsForSelectedItems ?? [] {
                        if index.section == self.section {
                            // MARK: - web
                            self.cardos[index.row].willDelete = true
                        }
                    }
                    self.cardos.removeAll(where: { (cardo) -> Bool in
                        return cardo.willDelete
                    })
                    self.editState = false
                }, cancelHandler: { (_) in
                    self.editState = false
                })
            }
            
        }
    }
    weak var footer:CardoCollectionFooterView? = nil
}
