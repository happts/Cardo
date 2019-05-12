//
//  LoginViewController.swift
//  Cardo
//
//  Created by happts on 2019/2/23.
//  Copyright © 2019 happts. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class LoginViewController: UIViewController,UITabBarDelegate {

    @IBOutlet weak var IndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var PasswordTextFieldView: UITextField!
    @IBOutlet weak var AccountTextFieldView: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        LoginButton.isEnabled = false
        
//        User.instance.login { (islogin) in
//            self.IndicatorView.stopAnimating()
//            if islogin {
//                self.LoginButton.isEnabled = true
//            }else {
//                UIAlertUtils.alertControllerWithMessage(ViewController: self, message: "网络连接失败")
//            }
//        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func RegisterAction(_ sender: UIButton) {
        
    }
    @IBAction func LoginAction(_ sender: UIButton) {
        sender.isEnabled = false
        self.IndicatorView.startAnimating()
        
        User.instance.setUserData(username: AccountTextFieldView.text!, password: PasswordTextFieldView.text!).login { (isLogin) in
            self.IndicatorView.stopAnimating()
            sender.isEnabled = true
            
            if isLogin {
                self.performSegue(withIdentifier: "loginSuccess", sender: nil)
            }else {
                UIAlertUtils.alertControllerWithMessage(ViewController: self, message: "网络连接失败")
            }
        }
        
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 

}
