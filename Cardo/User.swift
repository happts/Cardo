//
//  User.swift
//  Cardo-m
//
//  Created by app on 2019/3/5.
//  Copyright © 2019年 jndxttt. All rights reserved.
//

import Foundation

//remeber to delete
import UIKit

class User {
    var username : String = "cardoteam"
    var nickname : String = ""
    var password : String = "super"
    var userid : Int = 0
    
    var isLogin : Bool = false
    
    static let instance = User()
    
    private init() {}
    
    func setUserData(username : String, nickname : String = "", password : String, userid : Int = 0) -> User {
        self.username = username
        self.nickname = nickname
        self.password = password
        self.userid = userid
        return self
    }
    
    func login(completation:@escaping ((Bool)->Void)) {
        Login_Request.init(username: username, password: password).execute { (islogin, nickname, userid) in
            self.isLogin = islogin
            self.nickname = nickname
            self.userid = userid
            print(self.isLogin)
            completation(islogin)
        }
    }
    
    // FIXME: 后续分离
    weak var collectionViewModel:CollectionViewModel?
    weak var mapViewModel:MapCardosViewModel?
}

extension User {
    func cardoOR(imageData:Data,longitude:Double,latitude:Double,completation:@escaping ((String,String)->Void)) {
        Upload_Request(image: imageData, longitude: longitude, latitude: latitude, time: Date()).execute { (msg, words) in
            completation(msg,words)
        }
    }
    
    func cardoOCR(imageData:Data,longitude:Double,latitude:Double,completation:@escaping ((String,String)->Void)){
        Upload_Request(image: imageData, longitude: longitude, latitude: latitude, time: Date(), from: "zh", to: "jp").execute { (title, description) in
            completation(title,description)
        }
    }
}
