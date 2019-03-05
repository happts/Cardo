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
    var testData:[CardoSectionViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Register cell classes
        self.collectionView.register(UINib(nibName: "CardCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        for i in 0..<4 {
            let viewmodel = CardoSectionViewModel(headerView: self.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headview", for: IndexPath(item: 0, section: i)) as! CardoCollectionHeaderView, footerView: self.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerview", for: IndexPath(item: 0, section: i)) as! CardoCollectionFooterView)
            testData.append(viewmodel)
        }
        
        for x in 0..<testData.count {
            for i in 0...4 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: IndexPath(item: i, section: 0)) as! CardCell
                testData[x].cells.append(cell)
            }
        }
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
        return testData.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return testData[section].cells.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CardCell
    
        // Configure the cell
        if indexPath.section == 2 {
            cell.editState = true
        }
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headview", for: indexPath) as! CardoCollectionHeaderView
            //
            head.DateLabel.text = "2月1\(indexPath.section)日"
            
            head.share = {
                print("you share them")
            }
            //
            return head
        }else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerview", for: indexPath) as! CardoCollectionFooterView
            //
            footer.index = indexPath
            footer.collectionView = collectionView
            footer.isHidden = true
            //
            return footer
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //默认状态
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        let vc = CardoViewController()
        vc.loadViewIfNeeded()
        vc.ImageView.image = cell.image
        vc.NameLabel.text = cell.name
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
