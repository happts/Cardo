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
    
    init(_ viewController:CollectionViewController) {
        self.vc = viewController
        
        User.instance.collectionViewModel = self
    }
    
    var MyCardoViewModel:[SectionViewModel] = []
    
    var sectionCount:Int {
        return MyCardoViewModel.count
    }

    var isShowingMyCardo = true
    
    private var mode = Request_GetCardos.ViewMode.view_all
    private var limit = 10
    private var offset = 0
    
    private var dic:[String:Int] = [:]
    private var tmpIndex = 0
    
    func getCardos(completion:@escaping (()->Void)) {
        Request_GetCardos(mode: .view_all, userid: User.instance.userid, limit: limit, offset: offset).execute { (cardos) in
            
            if cardos.count == 0 {
                return
            }
            
            self.offset += cardos.count
            
            for cardo in cardos {
                if let currentIndex = self.dic[cardo.date.myDateString]{
                    self.MyCardoViewModel[currentIndex].data.insertCardo(cardo)
                    self.vc?.collectionView.reloadSections([currentIndex])
                }else {
                    self.dic[cardo.date.myDateString] = self.tmpIndex
                    let sectionviewmodel = SectionViewModel(collectionViewModel: self, sectionIndex: self.tmpIndex, date: cardo.date)
                    self.MyCardoViewModel.append(sectionviewmodel)
                    self.MyCardoViewModel[self.tmpIndex].data.insertCardo(cardo)
                    
                    self.vc?.collectionView.insertSections([self.tmpIndex])
                    self.tmpIndex += 1
                }
            }
            completion()
        }
    }
    
    func cardoCount(byIndex index:Int) -> Int {
        return self.MyCardoViewModel[index].data.cardos.count
    }
    
}
