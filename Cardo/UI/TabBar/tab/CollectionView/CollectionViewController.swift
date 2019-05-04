//
//  CollectionViewController.swift
//  Cardo
//
//  Created by happts on 2019/1/30.
//  Copyright © 2019 happts. All rights reserved.
//

import UIKit
import ESTabBarController_swift

private let reuseIdentifier = "CardCell"

class CollectionViewController: UICollectionViewController {

//    var Model:
    @IBOutlet weak var CardoSegmentedControl: UISegmentedControl!
    @IBAction func SegmentChangeAction(_ sender: UISegmentedControl) {
        collectionView.reloadData()
    }
    
    var ViewModel:CollectionViewModel!
    
    let popview = MyPopView(frame: CGRect(x: 0, y: 0, width: 248, height: 110))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.allowsMultipleSelection = true
        self.collectionView.register(UINib(nibName: "CardCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        popview.center = self.view.center
        popview.isHidden = true
        self.view.addSubview(popview)
        
        let longPressGes = UILongPressGestureRecognizer(target: self, action: #selector(toCardoDetail(sender:)))
        self.collectionView.addGestureRecognizer(longPressGes)
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "refresh")
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
        
        self.ViewModel = CollectionViewModel(self)
        refreshControl.beginRefreshing()
        refreshAction()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if self.CardoSegmentedControl.selectedSegmentIndex == 0 {
            return ViewModel.cardosOfDays.count //data.count
        }else {
            return ViewModel.collectedCardosOfDays.count //collectedData.count
        }
        
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if self.CardoSegmentedControl.selectedSegmentIndex == 0 {
            return ViewModel.cardosOfDays[section].cardos.count//data[section].cardos.count
        }else {
            return ViewModel.collectedCardosOfDays[section].collectedCardos.count//collectedData[section].collectedCardos.count
        }
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CardCell
        if self.CardoSegmentedControl.selectedSegmentIndex == 0 {
            cell.setCardCell(cardo: ViewModel.cardosOfDays[indexPath.section].cardos[indexPath.row], index: indexPath)
        }else {
            cell.setCardCell(cardo: ViewModel.collectedCardosOfDays[indexPath.section].collectedCardos[indexPath.row], index: indexPath)
        }
        // Configure the cell
        return cell
    }
    
    //bind header and footer and section
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let data = self.CardoSegmentedControl.selectedSegmentIndex == 0 ? ViewModel.cardosOfDays : ViewModel.collectedCardosOfDays
        data[indexPath.section].section = indexPath.section
        
        if kind == UICollectionView.elementKindSectionHeader {
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headview", for: indexPath) as! CardoCollectionHeaderView
            
            head.EditButton.isEnabled = self.CardoSegmentedControl.selectedSegmentIndex == 1 ? false : true

            data[indexPath.section].header = head
            head.data = data[indexPath.section]

            return head
        }else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerview", for: indexPath) as! CardoCollectionFooterView
            //
            data[indexPath.section].footer = footer
            footer.data = data[indexPath.section]
            //
            return footer
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        if self.CardoSegmentedControl.selectedSegmentIndex == 0 {
            cell.setCardCell(cardo: ViewModel.cardosOfDays[indexPath.section].cardos[indexPath.row], index: indexPath)
        }else {
            cell.setCardCell(cardo: ViewModel.collectedCardosOfDays[indexPath.section].collectedCardos[indexPath.row], index: indexPath)
        }
        
        
        if !cell.editState {
            popview.isHidden = true
        }else {
            cell.isSelected = false
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //默认状态
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        let data = self.CardoSegmentedControl.selectedSegmentIndex == 0 ? ViewModel.cardosOfDays : ViewModel.collectedCardosOfDays
        
        CardoSegmentedControl.selectedSegmentIndex == 0 ? cell.setCardCell(cardo: data[indexPath.section].cardos[indexPath.row], index: indexPath)
            : cell.setCardCell(cardo: data[indexPath.section].collectedCardos[indexPath.row], index: indexPath)
        
        if !cell.editState {
            popview.WordsLabel.text = cell.name
            popview.isHidden = false
            cell.isSelected = false
        }else {
            cell.isSelected = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }

    @objc func toCardoDetail(sender:UILongPressGestureRecognizer) {

        let itemIndexPath = collectionView.indexPathForItem(at: sender.location(in: self.collectionView))
        print(itemIndexPath?.section ?? -1)
        print(itemIndexPath?.row ?? -1)
        if sender.state == .began {
            let cardovc = CardoViewController()
            cardovc.cardo = ViewModel.cardosOfDays[itemIndexPath!.section].cardos[itemIndexPath!.row]
            self.navigationController?.pushViewController(cardovc, animated: true)
        }
    }

    @objc func refreshAction(){
        print("dd")
        self.ViewModel.getCardos(byDate: "2019-02-27")
    }
}
