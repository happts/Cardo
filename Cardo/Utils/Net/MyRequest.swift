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
                                              password: self.password, userid: json["userid"].int ?? 0)
                    User.instance.isLogin = true
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
                response(json["msg"].string == "ok")
            case .failure( _ ):
                response(false)
                //print(error)
            }
        }
    }
}

struct Logout_Request : MyRequest {
    var path: String = Server.logoutUrl
    var method: HTTPMethod = .post
    var parameters: [String : String]?
    
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
    
    func execute(responseMsg:@escaping ((String, String) -> Void)) {
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
                        responseMsg(json["words"].arrayValue[0].string ?? "sd",
                            {
                                var string = ""
                                for s in json["words"].arrayValue {
                                    string += s.string ?? ""
                                }
                                return string
                            }()
                        )
                    })
                case .failure(let error):
                    responseMsg(String(describing: error), "")
                    //print(error)
                }
            }
        } else if action == .or {
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
                        let json = JSON(response.value as Any)
                        print(json)
                        responseMsg(json["title"].string ?? "", json["destination"].string ?? "")
                        //
                    })
                case .failure(let error):
                    responseMsg(String(describing: error), "")
                    //print(error)
                }
            }
        }
    }
}

struct Cardo_Request : MyRequest {
    var path: String = Server.baseUrl
    var method: HTTPMethod = .get
    var parameters: [String : String]?
    
    enum ViewMode : String {
        case view_favourite = "view_favourite"
        case view_all = "view_all"
        case nearby_self = "nearby_self"
        case nearby_share = "nearby_share"
        case view_all_date = "view_all_date"
    }
    
    init(dateS : String) {
        self.parameters = ["whose" : ViewMode.view_all.rawValue, "date" : dateS]
    }
    
    init(longitude: Double, longitudeOffset: Double, latitude: Double, latitudeOffset: Double, viewMode: ViewMode) {
        self.parameters = ["whose": viewMode.rawValue, "lo": "\(longitude)", "la": "\(latitude)", "lo_r": "\(longitudeOffset)", "la_r": "\(latitudeOffset)"]
    }
    
    func execute(responseCardo:@escaping ((Cardo) -> Void), completation:@escaping ((Bool,String)->Void)) {
        Alamofire.request(Server.photoUrl, method: method, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var count = json.array?.count ?? 0
                
                for cell in json.array ?? [] {
                    
                    Alamofire.request(self.path + "/" + cell["file_name"].string!, method: self.method).responseData(completionHandler: { (responseData) in
                        switch responseData.result {
                        case .success(let photo):
                            responseCardo(Cardo(json: cell, imageData: photo))
                        case .failure(let error):
                            print(error)
                        }
                        count -= 1
                        if !(count > 0) {
                            completation(true,"")
                        }
                    })
                    
                }
            case .failure(let error):
                print(error)
                completation(false,"\(error)")
            }
        }
    }
}

struct Delete_Request : MyRequest {
    var path: String = Server.deleteUrl
    var method: HTTPMethod = .post
    var parameters: [String : String]?
    
    init(photoId : Int) {
        parameters = ["photo_id" : "\(photoId)"]
    }
    
    func execute(response:@escaping ((Bool) -> Void)) {
        Alamofire.request(path, method: method, parameters: parameters).responseJSON { (responseJson) in
            switch responseJson.result {
            case .success(let value):
                let json = JSON(value)
                response(json["msg"].stringValue == "ok")
            case .failure(let error):
                response(false)
                print(error)
            }
        }
    }
}

struct Share_Request : MyRequest {
    var path: String = Server.shareUrl
    var method: HTTPMethod = .post
    var parameters: [String : String]?
    
    init(photoId : Int) {
        parameters = ["photo_id" : "\(photoId)"]
    }
    
    func execute(response:@escaping ((Bool) -> Void)) {
        Alamofire.request(path, method: method, parameters: parameters).responseJSON { (responseJson) in
            switch responseJson.result {
            case .success(let value):
                let json = JSON(value)
                response(json["msg"].stringValue == "ok")
            case .failure(let error):
                response(false)
                print(error)
            }
        }
    }
}

struct Favourite_Request : MyRequest {
    var path: String = Server.favouriteUrl
    var method: HTTPMethod = .post
    var parameters: [String : String]?
    
    init(photoId : Int) {
        parameters = ["photo_id" : "\(photoId)"]
    }
    
    func execute(response:@escaping ((Bool) -> Void)) {
        Alamofire.request(path, method: method, parameters: parameters).responseJSON { (responseJson) in
            switch responseJson.result {
            case .success(let value):
                let json = JSON(value)
                response(json["msg"].stringValue == "ok")
            case .failure(let error):
                response(false)
                print(error)
            }
        }
    }
}

struct Unshare_Request : MyRequest {
    var path: String = Server.unshareUrl
    var method: HTTPMethod = .post
    var parameters: [String : String]?
    
    init(photoId : Int) {
        parameters = ["photo_id" : "\(photoId)"]
    }
    
    func execute(response:@escaping ((Bool) -> Void)) {
        Alamofire.request(path, method: method, parameters: parameters).responseJSON { (responseJson) in
            switch responseJson.result {
            case .success(let value):
                let json = JSON(value)
                response(json["msg"].stringValue == "ok")
            case .failure(let error):
                response(false)
                print(error)
            }
        }
    }
}

struct Unfavourite_Request : MyRequest {
    var path: String = Server.unfavouriteUrl
    var method: HTTPMethod = .post
    var parameters: [String : String]?
    
    init(photoId : Int) {
        parameters = ["photo_id" : "\(photoId)"]
    }
    
    func execute(response:@escaping ((Bool) -> Void)) {
        Alamofire.request(path, method: method, parameters: parameters).responseJSON { (responseJson) in
            switch responseJson.result {
            case .success(let value):
                let json = JSON(value)
                response(json["msg"].stringValue == "ok")
            case .failure(let error):
                response(false)
                print(error)
            }
        }
    }
}
