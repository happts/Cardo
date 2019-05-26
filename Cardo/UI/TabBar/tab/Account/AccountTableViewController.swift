//
//  AccountTableViewController.swift
//  Cardo
//
//  Created by happts on 2019/2/28.
//  Copyright © 2019 happts. All rights reserved.
//

import UIKit

class AccountTableViewController: UITableViewController {
    @IBOutlet weak var HeadImageView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var MailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.NameLabel.text = User.instance.nickname
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 227/255.0, green: 191/255.0, blue: 0/255.0, alpha: 1.0)
//        self.navigationItem.backBarButtonItem?.tintColor = UIColor.init(red: 227/255.0, green: 191/255.0, blue: 0/255.0, alpha: 1.0)
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 3
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        switch section {
//        case 0:
//            return 1
//        case 1:
//            return 2
//        case 2:
//            return 1
//        default:
//            return 0
//        }
//    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //logout
        if indexPath.section == 2 {
            Logout_Request().execute { (_) in
                return
            }
            self.navigationController?.tabBarController?.dismiss(animated: true, completion: nil)
        }
        
        
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                print("已购项目")
            case 1:
                print("恢复购买")
            case 2:
                print("清空缓存")
                DBHelper.instance.deleteAll()
                UIAlertUtils.alertControllerWithMessage(ViewController: self, message: "清空缓存完成")
                
            default:
                print("nothing")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
