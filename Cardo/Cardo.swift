//
//  Cardo.swift
//  Cardo
//
//  Created by happts on 2019/3/13.
//  Copyright © 2019 happts. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

import Alamofire
import SwiftyJSON

import RealmSwift

class Cardo {
    let id:Int
    let fileUserId:Int
    let userId:Int
    let time:Date
    var date:Date {
        return time
    }
    
    var title:String
    var description:String {
        didSet {
            if oldValue != description {
                Request_modifyCardoDescription(photo_id: self.id, newdescription: description).execute { (result) in
                    print(result)
                }
            }
        }
    }
    
    var imageFilePath:String
    var imageData:Data? {
        didSet {
            guard let idOfcell = self.cell?.cardoId else {
                return
            }
            if idOfcell == id {
                cell?.image = UIImage(data: imageData!)
            }
        }
    }
    
    var latitude:Double
    var longitude:Double
    
    var isShared:Bool {
        didSet {
            if isShared != oldValue {
                if self.fileUserId == self.userId {
                    if isShared {
                        UpdateCardo_Request(action: .share, photoId: self.id).execute { (result) in
                            print("分享\(result)")
                        }
                    }else {
                        UpdateCardo_Request(action: .unshare, photoId: self.id).execute { (result) in
                            print("取消分享\(result)")
                        }
                    }
                }else {
                    isShared = oldValue
                }
            }
        }
    }
    var isCollected:Bool{
        didSet {
            if isCollected != oldValue {
                if isCollected {
                    UpdateCardo_Request(action: .favourite, photoId: self.id).execute { (result) in
                        print("收藏\(result)")
                    }
                }else {
                    UpdateCardo_Request(action: .unfavourite, photoId: self.id).execute { (result) in
                        print("取消收藏\(result)")
                    }
                }
            }
        }
    }
    
    weak var cell:CardCell?
    
    let getImageRequest:DataRequest!
    
    convenience init(json:JSON) {
        self.init(id: json["photo_id"].intValue,
                  fileUserid: json["file_user_id"].intValue,
                  time: json["upload_time"].stringValue.dateFromISO8601 ?? Date(),
                  title: json["title"].stringValue,
                  description: json["description"].stringValue,
                  imageFilePath: json["file_name"].stringValue,
                  latitude: json["latitude"].doubleValue,
                  longitude: json["longitude"].doubleValue,
                  isShared: json["is_shared"].boolValue,
                  isCollected: json["is_fav"].boolValue, imageData: nil)
        self.getImage { (_, _) in
            return
        }
        
    }
    
 init(id:Int,fileUserid:Int,time:Date,title:String,description:String,imageFilePath:String,latitude:Double,longitude:Double,isShared:Bool = false,isCollected:Bool = false,imageData:Data? = nil) {
        self.id = id
        self.fileUserId = fileUserid
        self.userId = 0
        self.time = time
        self.title = title
        self.description = description
        self.imageFilePath = imageFilePath
        self.latitude = latitude
        self.longitude = longitude
        self.isShared = isShared
        self.isCollected = isCollected
        self.imageData = imageData
        self.getImageRequest = Alamofire.request(Server.baseUrl + "/" + self.imageFilePath, method: .get)
    }
    
    
    func getImage(completion:@escaping ((Bool,Data?)->Void)) {
        //local
        let db = try! Realm()
        if let row = db.object(ofType: CardoImage.self, forPrimaryKey: self.id) {
            self.imageData = row.imageData
            completion(true,row.imageData)
            print("from database")
            return
        }else {
            getImageRequest?.responseData { (response) in
                switch response.result {
                case .success(let value):
                    self.imageData = value
                    print("from server")
                    //
                    do {
                        let row = CardoImage()
                        row.id = self.id
                        row.imageData = value
                        row.imageFilePath = self.imageFilePath
                        
                        if db.object(ofType: CardoImage.self, forPrimaryKey: row.id) == nil {
                            try db.write {
                                db.add(row)
                            }
                        }
                    }catch let erro {
                        print(erro)
                    }
                    
                    completion(true,value)
                case .failure(_):
                    completion(false,nil)
                }
            }
        }
        
    }
    
    
    func UpdateChangedValue(_ newValue:TmpCardo){
        self.title = newValue.title
        self.description = newValue.descripition
        self.isShared = newValue.isShared
        self.isCollected = newValue.isCollected
    }
    
    func delete(){
        UpdateCardo_Request(action: .delete, photoId: self.id).execute { (result) in
            print("删除\(result)")
        }
    }
}

struct TmpCardo {
    let title:String
    let descripition:String
    let isShared:Bool
    let isCollected:Bool
}

struct Day_Cardo {
    var cardos:[Cardo] = []
    var date:Date
    
    var collectedCardo:[Cardo] {
        return cardos.filter({ (cardo) -> Bool in
            return cardo.isCollected
        })
    }
    
    mutating func insertCardo(_ cardo:Cardo) {
        cardos.append(cardo)
    }
    
    mutating func addCardo(_ cardo:Cardo){
        cardos.append(cardo)
        //TODO:新增 Cardo 网络请求
    }
    
    mutating func removeCardo(_ indexs:[Int]){
        for i in indexs {
            cardos[i].delete()
        }
        
        cardos = cardos.enumerated()
            .filter { (offset,_) -> Bool in
                return !indexs.contains(offset)
            }
            .map { (_,cardo) -> Cardo in
                return cardo
        }
    }
    
    init(date:Date) {
        self.date = date
    }
}

extension Cardo {
    var locatation:CLLocationCoordinate2D {
        get{
            return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        }
    }
    
    var pointAnnoation:MKPointAnnotation {
        get {
            let ann = CardoAnnotation()
            ann.cardo = self
            ann.image = UIImage(data: self.imageData ?? Data())
            ann.title = self.title
            ann.subtitle = self.description
            ann.coordinate = self.locatation
            return ann
        }
    }
    
}

