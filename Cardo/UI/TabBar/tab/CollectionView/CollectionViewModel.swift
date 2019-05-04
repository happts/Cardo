//
//  CollectionViewModel.swift
//  Cardo
//
//  Created by happts on 2019/3/20.
//  Copyright © 2019 happts. All rights reserved.
//

import UIKit

class CollectionViewModel {
    weak var vc:CollectionViewController?
    
    var cardosOfDays:[Day_Cardos]  {
        get {
            return User.instance.datas
        }
    }
    var collectedCardosOfDays:[Day_Cardos] {
        get {
            return cardosOfDays.filter(){ $0.collectedCardos.count > 0}
        }
    }
    
    init(_ viewController:CollectionViewController) {
        self.vc = viewController
    }
    
    func getCardos(byDate date:String) {
        User.instance.getCardos(byDateString: date, responseOneCardo: { (cardo) in
            
            self.vc?.collectionView.reloadData()
        }) { (isSuccess, errorInfo) in
            self.vc?.collectionView.refreshControl?.endRefreshing()
            self.vc?.collectionView.reloadData()
            if !isSuccess {
                UIAlertUtils.alertControllerWithMessage(ViewController: self.vc!, message: errorInfo)
            }
            
            for day in self.cardosOfDays {
                day.CollectionView = self.vc?.collectionView
            }
            
        }
    }
    
}
