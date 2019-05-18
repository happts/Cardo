//
//  MapViewModel.swift
//  Cardo
//
//  Created by happts on 2019/3/23.
//  Copyright © 2019 happts. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class MapCardosViewModel {
    weak var vc:MapCardosViewController?
    
    var myCardos:[Cardo] {
        return User.instance.collectionViewModel?.MyCardoViewModel.flatMap{ $0.data.cardos } ?? []
    }
    
    var nearybyCardos:[Cardo] = []
    
    init(_ vc:MapCardosViewController) {
        self.vc = vc
        
        User.instance.mapViewModel = self
    }
    
    func loadMyCardos() {
        self.vc?.CardMapView.removeAnnotations((self.vc?.CardMapView.annotations) ?? [])
        for cardo in myCardos {
            self.vc?.CardMapView.addAnnotation(cardo.pointAnnoation)
        }
    }
    
    func loadNearbyCardos() {
        self.vc?.CardMapView.removeAnnotations(self.vc?.CardMapView.annotations ?? [])
        // FIXME: 获取附近 cardo
        for cardo in nearybyCardos {
            self.vc?.CardMapView.addAnnotation(cardo.pointAnnoation)
        }
    }

    func getMyCardosFromDB() {
        let db = try! Realm()
        
        db.objects(CardoImage.self)
    }
    
//    func testUse()  {
//        let a = Cardo(id: 0, title: "test1", subtitle: "test sub test", image: UIImage(named: "bkg"), latitude: 31.497438, longitude: 120.318628, isShared: true, isCollected: true)
//
//        let b = Cardo(id: 1, title: "test2", subtitle: "it is a story", image: UIImage(named: "bkg"), latitude: 31.38, longitude: 120.28, isShared: true, isCollected: true)
//
//        nearybyCardos += [a,b]
//    }
    
}
