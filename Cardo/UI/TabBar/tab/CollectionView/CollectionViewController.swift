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
    
    var data:[Day_Cardos] = []
    var collectedData:[Day_Cardos] {
        get {
            return data.filter(){ $0.collectedCardos.count > 0}
        }
    }
    
    let popview = MyPopView(frame: CGRect(x: 0, y: 0, width: 248, height: 110))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.allowsMultipleSelection = true
        self.collectionView.register(UINib(nibName: "CardCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        popview.center = self.view.center
        popview.isHidden = true
        self.view.addSubview(popview)
        
        let longPressGes = UILongPressGestureRecognizer(target: self, action: #selector(test(sender:)))
        
        //
        let section0 = Day_Cardos()
        section0.date = "3月2日"
        let cardo00 = Cardo(id: 0, title: "cardo00", subtitle: "sub00", image: UIImage(named: "bkg"), latitude: 10.0, longitude: 11.0, isShared: false, isCollected: false)
        let cardo01 = Cardo(id: 1, title: "cardo01", subtitle: "sub01", image: UIImage(named: "bkg"), latitude: 11, longitude: 11, isShared: true, isCollected: false)
        let cardo02 = Cardo(id: 2, title: "cardo02", subtitle: "sub02", image: UIImage(named: "bkg"), latitude: 11, longitude: 11, isShared: true, isCollected: true)
        let cardo03 = Cardo(id: 3, title: "cardo03", subtitle: "sub03", image: UIImage(named: "bkg"), latitude: 11, longitude: 11, isShared: false, isCollected: true)
        section0.cardos = [cardo00,cardo01,cardo02,cardo03]
        section0.CollectionView = self.collectionView
        section0.section = 0
        data.append(section0)
        
        let section1 = Day_Cardos()
        section1.date = "3月3日"
        section1.CollectionView = self.collectionView
        section1.section = 1
        data.append(section1)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if self.CardoSegmentedControl.selectedSegmentIndex == 0 {
            return data.count
        }else {
            return data.filter(){ $0.collectedCardos.count > 0
            }.count
        }
        
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if self.CardoSegmentedControl.selectedSegmentIndex == 0 {
            return data[section].cardos.count
        }else {
            return data.filter(){ $0.collectedCardos.count > 0}[section].collectedCardos.count
        }
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CardCell
        if self.CardoSegmentedControl.selectedSegmentIndex == 0 {
            cell.setCardCell(cardo: data[indexPath.section].cardos[indexPath.row], index: indexPath)
        }else {
            cell.setCardCell(cardo: data.filter(){ $0.collectedCardos.count > 0}[indexPath.section].collectedCardos[indexPath.row], index: indexPath)
        }
        // Configure the cell
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let data = self.CardoSegmentedControl.selectedSegmentIndex == 0 ? self.data : self.data.filter(){$0.collectedCardos.count > 0}
        
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
//        /678/
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        if CardoSegmentedControl.selectedSegmentIndex == 0 {
            cell.setCardCell(cardo: data[indexPath.section].cardos[indexPath.row], index: indexPath)
        }else {
            cell.setCardCell(cardo: data.filter(){$0.collectedCardos.count > 0}[indexPath.section].collectedCardos[indexPath.row], index: indexPath)
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
        let data = self.CardoSegmentedControl.selectedSegmentIndex == 0 ? self.data : self.data.filter(){$0.collectedCardos.count > 0}
        
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

    @objc func test(sender:UILongPressGestureRecognizer) {
        let itemIndexPath = collectionView.indexPathForItem(at: sender.location(in: self.collectionView))
        print(itemIndexPath?.section ?? -1)
        print(itemIndexPath?.row ?? -1)
    }

    
}
