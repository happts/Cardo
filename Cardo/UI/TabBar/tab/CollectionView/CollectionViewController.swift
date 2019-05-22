//
//  CollectionViewController.swift
//  Cardo
//
//  Created by happts on 2019/1/30.
//  Copyright © 2019 happts. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import CRRefresh

private let reuseIdentifier = "CardCell"

class CollectionViewController: UICollectionViewController {
    
//    @IBOutlet weak var CardoSegmentedControl: UISegmentedControl!
//    @IBAction func SegmentChangeAction(_ sender: UISegmentedControl) {
//        collectionView.reloadData()
//    }
    
    var ViewModel:CollectionViewModel!
    
    let popview = MyPopView(frame: CGRect(x: 0, y: 0, width: 248, height: 110))
    let refreshControl = UIRefreshControl()
    var footerView:CRRefreshFooterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.allowsMultipleSelection = true
        self.collectionView.register(UINib(nibName: "CardCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        popview.center = self.view.center
        popview.isHidden = true
        self.view.addSubview(popview)
        
        let longPressGes = UILongPressGestureRecognizer(target: self, action: #selector(toCardoDetail(sender:)))
        self.collectionView.addGestureRecognizer(longPressGes)
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "refresh")
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
        
        footerView = collectionView.cr.addFootRefresh {
            if self.footerView.state == .refreshing {
                self.ViewModel.getCardos { (count) in
                    self.footerView.endRefreshing()
                    if count == 0 {
                        self.footerView.noticeNoMoreData()
                    }
                }
            }
        }
        
        self.ViewModel = CollectionViewModel(self)
        
        refreshControl.beginRefreshing()
        refreshAction()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ViewModel.sectionCount
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return ViewModel.cardoCount(byIndex: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CardCell
        cell.bindCell(sectionViewModel: ViewModel.MyCardoViewModel[indexPath.section], index: indexPath)
        
        return cell
    }
    
    //bind header and footer and section
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headview", for: indexPath) as! CardoCollectionHeaderView
            
            head.bind(viewModel: ViewModel.MyCardoViewModel[indexPath.section], index: indexPath.section)
            
            ViewModel.MyCardoViewModel[indexPath.section].headerView = head
            
            return head
        }else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerview", for: indexPath) as! CardoCollectionFooterView
            
            footer.bind(viewModel: ViewModel.MyCardoViewModel[indexPath.section], index: indexPath.section)
            
            ViewModel.MyCardoViewModel[indexPath.section].footerView = footer
            return footer
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        
        if cell.editState {
            cell.isSelected = false
        }else {
            popview.isHidden = !popview.isHidden
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //默认状态
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        
        if cell.editState {
            cell.isSelected = true
            cell.hasEdited = true
        }else {
            popview.isHidden = !popview.isHidden
            popview.WordsLabel.text = cell.name
            collectionView.deselectItem(at: indexPath, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    @objc func toCardoDetail(sender:UILongPressGestureRecognizer) {
        
        
        guard let itemIndexPath = collectionView.indexPathForItem(at: sender.location(in: self.collectionView)) else {
            return
        }
        if sender.state == .began {
            let cardovc = CardoViewController()
            cardovc.cardo = ViewModel.MyCardoViewModel[itemIndexPath.section].data.cardos[itemIndexPath.item]
            cardovc.cardoItem = itemIndexPath.item
            self.navigationController?.pushViewController(cardovc, animated: true)
        }
    }
    
    @objc func refreshAction(){
        print("refreshAction")
        if self.footerView.state == .refreshing {
            self.refreshControl.endRefreshing()
            return
        }
        
        self.ViewModel.refreshData {
            self.refreshControl.endRefreshing()
            self.footerView.resetNoMoreData()
        }
    }
    
}
