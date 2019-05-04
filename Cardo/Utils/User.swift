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
    
    //
    var datas:[Day_Cardos] {
        get {
            return dicDayCardo.values.sorted(by: { (d1, d2) -> Bool in
                return d1.dateS.dateFromMyFormat!.compare(d1.dateS.dateFromMyFormat!) == .orderedDescending
            })
        }
    }
    
    var dicDayCardo:[String:Day_Cardos] = [:]
    //
    
    static var instance = User()
    
    private init() {}
    
    func setUserData(username : String, nickname : String, password : String, userid : Int) -> Void {
        self.username = username
        self.nickname = nickname
        self.password = password
        self.userid = userid
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
    
    ///"2019-02-27"
    func getCardos(byDateString dateS:String ,responseOneCardo:@escaping ((Cardo)->Void), completation:@escaping ((Bool,String)->Void)) {
        
        Cardo_Request(dateS: dateS).execute(responseCardo: { (cardo) in
            let cardotimeS = cardo.time.dateFromISO8601!.myDateString
            
            if !self.dicDayCardo.keys.contains(cardotimeS) {
                let daycardos = Day_Cardos()
                daycardos.dateS = cardotimeS
                daycardos.cardos = [cardo]
                self.dicDayCardo[cardotimeS] = daycardos
            }else {
                self.dicDayCardo[cardotimeS]?.cardos.append(cardo)
            }
            
            responseOneCardo(cardo)
        }) { (isSuccess, erroInfo) in
            if isSuccess {
                completation(isSuccess,"")
            }else {
                completation(isSuccess,erroInfo)
            }
        }
    }
    
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
