//
//  Cardo.swift
//  Cardo
//
//  Created by happts on 2019/3/13.
//  Copyright © 2019 happts. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class Cardo {
    let id:Int
    let title:String
    let image:UIImage?
    
    let latitude:CLLocationDegrees
    let longitude:CLLocationDegrees
    
    var subtitle:String
    var isShared:Bool
    var isCollected:Bool
    var editState:Bool
    
    init(id:Int,title:String,subtitle:String,image:UIImage?,
         latitude:CLLocationDegrees,longitude:CLLocationDegrees,isShared:Bool,isCollected:Bool) {
        self.id = id
        self.title = title
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
        self.subtitle = subtitle
        self.isShared = isShared
        self.isCollected = isCollected
        self.editState = false
    }
    
    var locatation:CLLocationCoordinate2D {
        get{
            return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        }
    }
    
    var pointAnnoation:MKPointAnnotation {
        get {
            let ann = CardoAnnotation()
            ann.image = self.image
            ann.title = self.title
            ann.subtitle = self.subtitle
            ann.coordinate = self.locatation
            return ann
        }
    }
}

class Day_Cardos {
    var date:String = "X月X日"
    var cardos:[Cardo] = []
    
    var section:Int = 0
    weak var CollectionView:UICollectionView!
    
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
            self.CollectionView.reloadSections([section])
        }
    }
    
    weak var header:CardoCollectionHeaderView? = nil {
        didSet{
            header?.collect = {
                for index in self.CollectionView.indexPathsForSelectedItems ?? [] {
                    if index.section == self.section {
                        // MARK: - web
                        self.cardos[index.row].isCollected = true
                    }
                }
                self.editState = false
            }
            
            header?.share = {
                for index in self.CollectionView.indexPathsForSelectedItems ?? [] {
                    if index.section == self.section {
                        // MARK: - web
                        self.cardos[index.row].isShared = true
                    }
                }
                self.editState = false
            }
            
            header?.delete = {
                for index in self.CollectionView.indexPathsForSelectedItems ?? [] {
                    if index.section == self.section {
                        // MARK: - web
//                        self.cardos[index.row].isCollected = true
                        self.cardos.remove(at: index.row)
                    }
                }
                self.editState = false
            }
            
        }
    }
    weak var footer:CardoCollectionFooterView? = nil
}
