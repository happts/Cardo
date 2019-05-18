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
        IndicatorView.stopAnimating()
    }
    
    @IBAction func RegisterAction(_ sender: UIButton) {
        let registAlertController = UIAlertController(title: "注册账号", message: nil, preferredStyle: .alert)
        var usernameTextField:UITextField!
        var passwordTextField:UITextField!
        var repeatPasswordTextField:UITextField!
        
        registAlertController.addTextField { (textField) in
            usernameTextField = textField
            textField.placeholder = "请输入用户名"
        }
        
        registAlertController.addTextField { (textField) in
            passwordTextField = textField
            textField.placeholder = "请输入密码"
            textField.isSecureTextEntry = true
        }
        
        registAlertController.addTextField { (textField) in
            repeatPasswordTextField = textField
            textField.placeholder = "确认密码"
            textField.isSecureTextEntry = true
        }
        
        let registerAction = UIAlertAction(title: "注册", style: .default) { (_) in
            if passwordTextField.text != repeatPasswordTextField.text {
                UIAlertUtils.alertControllerWithMessage(ViewController: self, message: "两次输入的密码不一致")
            }else {
                Register_Request(username: usernameTextField.text!, password: passwordTextField.text!, phone: "", nickname: usernameTextField.text!).execute(response: { (result) in
                    if result {
                        UIAlertUtils.alertControllerWithMessage(ViewController: self, message: "注册成功")
                    }else {
                        UIAlertUtils.alertControllerWithMessage(ViewController: self, message: "注册失败")
                    }
                })
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        registAlertController.addAction(registerAction)
        registAlertController.addAction(cancelAction)
        
        self.present(registAlertController, animated: true, completion: nil)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.AccountTextFieldView.resignFirstResponder()
        self.PasswordTextFieldView.resignFirstResponder()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 

}
