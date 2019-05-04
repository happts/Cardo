//
//  MapViewModel.swift
//  Cardo
//
//  Created by happts on 2019/3/23.
//  Copyright © 2019 happts. All rights reserved.
//

import Foundation
import UIKit

class MapCardosViewModel {
    weak var vc:MapCardosViewController?
    
    var myCardos:[Cardo] {
        get {
            var cardos:[Cardo] = []
            for day in User.instance.datas {
                cardos += day.cardos
            }
            return cardos
        }
    }
    
    var nearybyCardos:[Cardo] = []
    
    init(_ vc:MapCardosViewController) {
        self.vc = vc
        testUse()
    }
    
    func loadMyCardos() {
        self.vc?.CardMapView.removeAnnotations((self.vc?.CardMapView.annotations) ?? [])
        for cardo in myCardos {
            self.vc?.CardMapView.addAnnotation(cardo.pointAnnoation)
        }
    }
    
    func loadNearbyCardos() {
        self.vc?.CardMapView.removeAnnotations(self.vc?.CardMapView.annotations ?? [])
        
        for cardo in nearybyCardos {
            self.vc?.CardMapView.addAnnotation(cardo.pointAnnoation)
        }
    }
    
    func testUse()  {
        let a = Cardo(id: 0, title: "test1", subtitle: "test sub test", image: UIImage(named: "bkg"), latitude: 31.497438, longitude: 120.318628, isShared: true, isCollected: true)

        let b = Cardo(id: 1, title: "test2", subtitle: "it is a story", image: UIImage(named: "bkg"), latitude: 31.38, longitude: 120.28, isShared: true, isCollected: true)
        
        nearybyCardos += [a,b]
    }
    
}
