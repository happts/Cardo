//
//  CardoCollectionViewSectionViewModel.swift
//  CardoB
//
//  Created by happts on 2019/4/23.
//  Copyright © 2019 happts. All rights reserved.
//

import Foundation

class SectionViewModel {
    weak var collectionViewModel:CollectionViewModel?
    weak var headerView:CardoCollectionHeaderView?
    weak var footerView:CardoCollectionFooterView?
    
    var sectionIndex:Int
    var date:Date
    
    var data:Day_Cardo
    
    init(collectionViewModel:CollectionViewModel,sectionIndex:Int,date:Date) {
        self.collectionViewModel = collectionViewModel
        self.sectionIndex = sectionIndex
        self.date = date
        self.data = Day_Cardo(date: date)
    }
    
    
    var indexPathForSelectedItems:[IndexPath] {
        return collectionViewModel?.vc?.collectionView.indexPathsForSelectedItems?.filter({ (indexPath) -> Bool in
            return indexPath.section == sectionIndex
        }) ?? []
    }
    
    var indexForHasEditedItem:[Int] {
        get {
            var arr:[Int] = []
            for i in 0..<data.cardos.endIndex {
                if data.cardos[i].cell?.hasEdited ?? false {
                    arr.append(i)
                }
            }
            return arr
        }
    }
    
    
    var editState = false
    
    func changeState() {
        self.editState = !(self.editState)
        headerView?.changeState()
        footerView?.changeState()
        
        for i in 0..<data.cardos.endIndex {
            data.cardos[i].cell?.changeState()
        }
    }
    
    func deSelectItems() {
        for indexPath in self.indexPathForSelectedItems {
            self.collectionViewModel?.vc?.collectionView.deselectItem(at: indexPath, animated: false)
            self.data.cardos[indexPath.item].cell?.isSelected = false
        }
    }
    
}
