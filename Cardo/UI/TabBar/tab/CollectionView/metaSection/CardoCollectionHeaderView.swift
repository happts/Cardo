//
//  CollectionHeaderView.swift
//  Cardo
//
//  Created by happts on 2019/2/27.
//  Copyright © 2019 happts. All rights reserved.
//

import UIKit

class CardoCollectionHeaderView: UICollectionReusableView,CardoCollectionHeaderAndFooterProtocol {
    //id = "headview"
    weak var viewModel: SectionViewModel?
    var index: Int = 0
    
    var EditState: Bool {
        return viewModel?.editState ?? false
    }
    
    func changeState() {
        self.EditButton.isHidden = EditState
        self.EditStackView.isHidden = !EditState
        self.DateLabel.isHidden = EditState
    }
    
    func bind(viewModel: SectionViewModel, index: Int) {
        self.viewModel = viewModel
        self.index = index
        self.DateLabel.text = viewModel.date.myDateString
        changeState()
    }
    
    
    @IBOutlet weak var EditButton: UIButton!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var EditStackView: UIStackView!
    
    enum EditType {
        case Share
        case Delete
        case Collect
        case StartEdit
    }
    
    @IBAction func ShareAction() {
        editAction(.Share)
    }
    
    @IBAction func DeleteAction() {
        editAction(.Delete)
    }
    
    @IBAction func CollectAction() {
        editAction(.Collect)
    }
    
    @IBAction func EditAction(_ sender: Any) {
        editAction(.StartEdit)
    }
    
    private func editAction(_ type:EditType) {
        switch type {
        case .Share:
            for index in viewModel?.indexPathForSelectedItems ?? [] {
                self.viewModel?.data.cardos[index.item].isShared = true
            }
        case .Collect:
            for index in viewModel?.indexPathForSelectedItems ?? [] {
                self.viewModel?.data.cardos[index.item].isCollected = true
            }
        case .Delete:
//            UIAlertUtils.alertControllerDistructive(ViewController: (self.viewModel?.collectionViewModel?.vc)!, message: "确认删除选中Cardo?", deleteHandler: { (_) in
                self.viewModel?.data.removeCardo(self.viewModel?.indexPathForSelectedItems.map{$0.item} ?? [])
                self.viewModel?.collectionViewModel?.vc?.collectionView.reloadSections([self.viewModel!.sectionIndex])
//            })
        case .StartEdit:
            self.viewModel?.deSelectItems()
            self.viewModel?.changeState()
            return
        }
        
        self.viewModel?.deSelectItems()
        self.viewModel?.changeState()
    }
}
