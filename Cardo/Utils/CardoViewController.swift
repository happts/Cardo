//
//  CardoViewController.swift
//  Cardo
//
//  Created by happts on 2019/2/28.
//  Copyright © 2019 happts. All rights reserved.
//

import UIKit

class CardoViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var ResultTextView: UITextView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    @IBAction func CancelAction(_ sender: Any) {
        if self.navigationController != nil {
            print("test")
            self.navigationController?.popViewController(animated: true)
        }else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func SaveAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
