//
//  MyRequest.swift
//  Cardo-m
//
//  Created by app on 2019/3/5.
//  Copyright © 2019年 jndxttt. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol MyRequest {
    var path : String { get }
    var method : HTTPMethod { get }
    var parameters : [String : String]? { get }
}

extension MyRequest {
    func EntityToDic<T:Codable> (_ entity:T) -> Dictionary<String, String>? {
        do {
            let entityJsonData = try JSONEncoder().encode(entity)
            return try JSONSerialization.jsonObject(with: entityJsonData, options: .mutableLeaves) as? Dictionary<String, String>
        } catch {
            print("参数转换失败")
            return nil
        }
    }
}

func EntityToDic<T:Codable> (_ entity:T) -> Dictionary<String, String>? {
    do {
        let entityJsonData = try JSONEncoder().encode(entity)
        return try JSONSerialization.jsonObject(with: entityJsonData, options: .mutableLeaves) as? Dictionary<String, String>
    } catch {
        print("参数转换失败")
        return nil
    }
}

extension MyRequest {
    func request() -> DataRequest {
        return Alamofire.request(path, method: method, parameters: parameters)
    }
}

struct Request_base : MyRequest {
    var path: String
    var method: HTTPMethod
    var parameters: [String : String]?
    
    func execute(responseJson:@escaping ((String, JSON) -> Void)) {
        Alamofire.request(path, method: method, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                responseJson(json["message"].string ?? "", json["data"])
            case .failure(let error):
                responseJson(String(describing: error), JSON.null)
                print(error)
            }
        }
    }
    
    func execute(responseData:@escaping ((Data?) -> Void)) {
        Alamofire.request(path, method: method, parameters: parameters).responseData { (response) in
            switch response.result {
            case .success(let value):
                responseData(value)
            case .failure( _ ):
                responseData(nil)
            }
        }
    }
}

struct Login_Request : MyRequest {
    var path: String = Server.loginUrl
    var method: HTTPMethod = .post
    var parameters: [String : String]?
    var username: String
    var password: String
    
    init(username : String, password : String) {
        self.username = username
        self.password = password
        self.parameters = ["username" : username, "password" : password]
    }
    
    func execute(response:@escaping ((Bool, String, Int) -> Void)) {
        Alamofire.request(path, method: method, parameters: parameters).responseJSON { (responseJson) in
            switch responseJson.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                if json["msg"].string == "ok" {
                    User.instance.setUserData(username: self.username, nickname: json["nickname"].string ?? "",
                                              password: self.password, userid: json["userid"].int ?? 0).isLogin = true
                }
                response(json["msg"].string == "ok", json["nickname"].string ?? "", json["userid"].int ?? 0)
            case .failure( _ ):
                response(false, "", -99)
                //print(error)
            }
        }
    }
}

struct Register_Request : MyRequest {
    var path: String = Server.registerUrl
    var method: HTTPMethod = .post
    var parameters: [String : String]?
    
    init(username : String, password : String, phone : String, nickname : String) {
        self.parameters = ["username" : username, "password" : password, "phone" : phone, "nickname" : nickname]
    }
    
    func execute(response:@escaping ((Bool) -> Void)) {
        Alamofire.request(path, method: method, parameters: parameters).responseJSON { (responseJson) in
            switch responseJson.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                response(json["msg"].string == "ok")
            case .failure( _ ):
                response(false)
                //print(error)
            }
        }
    }
}

struct Logout_Request : MyRequest {
    let path: String = Server.logoutUrl
    let method: HTTPMethod = .post
    let parameters: [String : String]? = nil
    
    func execute(response:@escaping ((Bool) -> Void)) {
        Alamofire.request(path, method: method, parameters: parameters).responseJSON { (responseJson) in
            switch responseJson.result {
            case .success(let value):
                let json = JSON(value)
                if json["msg"].string == "ok" {
                    User.instance.isLogin = false
                }
                response(json["msg"].string == "ok")
            case .failure( _ ):
                response(false)
                //print(error)
            }
        }
    }
}

struct Upload_Request : MyRequest {
    var path: String = Server.uploadUrl
    var method: HTTPMethod = .post
    var parameters: [String : String]?
    
    var image : Data
    var action : Action
    var longitude : Double
    var latitude : Double
    var time : String
    var from : String?
    var to : String?
    
    enum Action {
        case ocr
        case or
    }
    
    //or
    init(image : Data, longitude : Double, latitude : Double, time : Date) {
        self.image = image
        self.action = .or
        self.longitude = longitude
        self.latitude = latitude
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = .current
        self.time = formatter.string(from: time)
        
        self.from = nil
        self.to = nil
    }
    
    //ocr
    init(image : Data, longitude : Double, latitude : Double, time : Date, from : String, to : String) {
        self.image = image
        self.action = .ocr
        self.longitude = longitude
        self.latitude = latitude
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = .current
        self.time = formatter.string(from: time)
        
        self.from = from
        self.to = to
    }
    
    func execute(responseMsg:@escaping ((String, String,Int?) -> Void)) {
        if action == .ocr {
            Alamofire.upload(multipartFormData: { (formdata) in
                formdata.append(self.image, withName: "picture", fileName: "123.png", mimeType: "image/png")
                formdata.append("ocr".data(using: String.Encoding.utf8)!, withName: "action")
                formdata.append("\(self.longitude)".data(using: String.Encoding.utf8) ?? Data(), withName: "lo")
                formdata.append("\(self.latitude)".data(using: String.Encoding.utf8) ?? Data(), withName: "la")
                formdata.append(self.time.data(using: String.Encoding.utf8) ?? Data(), withName: "time")
                formdata.append(self.from!.data(using: String.Encoding.utf8) ?? Data(), withName: "from")
                formdata.append(self.to!.data(using: String.Encoding.utf8) ?? Data(), withName: "to")
            }, to: path) { (result) in
                switch result {
                case .success(let upload,_,_):
                    upload.responseJSON(completionHandler: { (response) in
                        let json = JSON(response.value as Any)
                        print(json)
                        responseMsg(json["words"].arrayValue.first?.string ?? "sd",
                                    {
                                        var string = ""
                                        for s in json["words"].arrayValue {
                                            string += s.string ?? ""
                                        }
                                        return string
                        }(),json["file_id"].intValue
                        )
                    })
                case .failure(let error):
                    responseMsg(String(describing: error), "",nil)
                    //print(error)
                }
            }
        }
        else if action == .or {
            Alamofire.upload(multipartFormData: { (formdata) in
                formdata.append(self.image, withName: "picture", fileName: "123.png", mimeType: "image/png")
                formdata.append("or".data(using: String.Encoding.utf8)!, withName: "action")
                formdata.append("\(self.longitude)".data(using: String.Encoding.utf8) ?? Data(), withName: "lo")
                formdata.append("\(self.latitude)".data(using: String.Encoding.utf8) ?? Data(), withName: "la")
                formdata.append(self.time.data(using: String.Encoding.utf8) ?? Data(), withName: "time")
            }, to: path) { (result) in
                switch result {
                case .success(let upload,_,_):
                    upload.responseJSON(completionHandler: { (response) in
                        switch response.result {
                        case .success(let value):
                            let json = JSON(value)
                            print(json)
                            let desc = json["description"]
                            
                            responseMsg(json["title"].stringValue, desc["ldmk"].stringValue +
                                desc["plant"].stringValue +
                                desc["animal"].stringValue +
                                desc["dish"].stringValue +
                                (desc["or"].arrayValue.first ?? JSON())["keyword"].stringValue, json["file_id"].intValue )
                        case .failure(let error):
                            print(error)
                            responseMsg(String(describing: error), "",nil)
                        }
                    })
                case .failure(let error):
                    responseMsg(String(describing: error), "",nil)
                }
            }
        }
    }
}
//struct Request_GetCardoImage:MyRequest {
//    var path: String
//
//    var method: HTTPMethod
//
//    var parameters: [String : String]?
//
//    init(fileName:String) {
//        self.path = Server.baseUrl + "/" + fileName
//        self.method = .get
//        self.parameters = nil
//    }
//
//    func execute(point:UnsafeMutablePointer<Cardo>,completation:@escaping (Bool)->Void ) {
//        self.request().responseData { (response) in
//            switch response.result {
//            case .success(let value):
//                point.pointee.imageData = value
//                completation(true)
//            case .failure(_):
//                completation(false)
//                print("获取照片失败")
//            }
//        }
//    }
//}

struct Request_GetCardos:MyRequest {
    var path: String = Server.photoUrl
    
    var method: HTTPMethod = .get
    
    var parameters: [String : String]? = [:]
    
    enum RequestMode : String {
        case view_favourite = "view_favourite"
        case view_all = "view_all"
        case nearby_self = "nearby_self"
        case nearby_share = "nearby_share"
        case view_all_date = "view_all_date"
    }
    
    init(mode:RequestMode,userid:Int,limit:Int,offset:Int,longitude:Double?=nil,latitude:Double?=nil,range:Double?=nil,date:Date?=nil) {
        self.parameters!["userid"] = String(userid)
        
        self.parameters!["whose"] = mode.rawValue
        self.parameters!["num"] = String(limit)
        self.parameters!["offset"] = String(offset)
        
        if longitude != nil {
            self.parameters!["lo"] = String(longitude!)
            self.parameters!["la"] = String(latitude!)
            self.parameters!["lo_r"] = String(range!)
            self.parameters!["la_r"] = String(range!)
        }
        
        if date != nil {
            self.parameters!["date"] = date!.myDateString
        }
    }
    
    func execute(compleation:@escaping ([Cardo])->Void) {
        self.request().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value).arrayValue
                print(json)
                var cardos:[Cardo] = []
                for one in json {
                    cardos.append(Cardo(json: one))
                    print(one)
                }
                cardos.sort(by: { (c1, c2) -> Bool in
                    return c1.time.compare(c2.time) == .orderedDescending
                })
                compleation(cardos)
            case .failure(_):
                compleation([])
                print("获取cardos 失败")
            }
        }
    }
    
}

struct UpdateCardo_Request : MyRequest {
    var path: String
    
    var method: HTTPMethod
    
    var parameters: [String : String]?
    
    enum Action {
        case delete
        case share
        case unshare
        case favourite
        case unfavourite
    }
    
    init(action:Action,photoId: Int) {
        parameters = ["photo_id" : "\(photoId)"]
        method = .post
        
        switch action {
        case .delete:
            path = Server.deleteUrl
            method = .delete
        case .favourite:
            path = Server.favouriteUrl
        case .unfavourite:
            path = Server.unfavouriteUrl
        case .share:
            path = Server.shareUrl
        case .unshare:
            path = Server.unshareUrl
        }
    }
    
    func execute(response:@escaping ((Bool) -> Void)) {
        Alamofire.request(path, method: method, parameters: parameters,encoding:URLEncoding.httpBody).responseJSON { (responseJson) in
            switch responseJson.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                response(json["msg"].stringValue == "ok")
            case .failure(let error):
                response(false)
                print(error)
            }
        }
    }
}

struct Request_modifyCardoDescription:MyRequest {
    var path: String
    
    var method: HTTPMethod
    
    var parameters: [String : String]? = [:]
    
    init(photo_id:Int,newdescription:String) {
        self.path = Server.modifydescriptionUrl
        self.method = .post
        self.parameters!["photo_id"] = "\(photo_id)"
        self.parameters!["new_desc"] = newdescription
    }
    
    // FIXME: 修复
    func execute(response:@escaping ((Bool) -> Void)) {
        Alamofire.request(path, method: method, parameters: parameters).responseJSON { (responseJson) in
            switch responseJson.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                response(true)
            case .failure(let error):
                print(error)
                response(false)
            }
        }
    }
}
