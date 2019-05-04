//
//  UIAlertUtils.swift
//  Cardo
//
//  Created by happts on 2019/2/28.
//  Copyright © 2019 happts. All rights reserved.
//

import Foundation
import UIKit

class UIAlertUtils {
    
    class func alertControllerWithMessage(ViewController:UIViewController, message: String,handler:((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好", style: .default, handler: handler)
        alertController.addAction(okAction)
        ViewController.present(alertController, animated: true, completion: nil)
    }
    
    class func alertControllerDistructive(ViewController:UIViewController, message: String ,deleteHandler:((UIAlertAction) -> Void)? = nil){
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "删除", style: .destructive, handler: deleteHandler)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        ViewController.present(alertController, animated: true, completion: nil)
    }
    
    class func alertControllerDistructive(ViewController:UIViewController, message: String ,deleteHandler:((UIAlertAction) -> Void)? = nil, cancelHandler:((UIAlertAction) -> Void)? = nil){
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "删除", style: .destructive, handler: deleteHandler)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: cancelHandler)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        ViewController.present(alertController, animated: true, completion: nil)
    }
    
    class func alertControllerWithMessageAndChoice(ViewController:UIViewController, message:String, handler:((UIAlertAction) -> Void)? = nil){
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: handler)
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        ViewController.present(alertController, animated: true, completion: nil)
    }
}
