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

class Cardo {
    let photoId:Int
    //
    var fileUserId : Int?
    var fileUserNickname : String?
    var filename : String?
    var time : String //2019-11-11
    //
    
    var imageData:Data
    
    let latitude:CLLocationDegrees
    let longitude:CLLocationDegrees
    
    let title:String
    var description:String
    
    var isShared:Bool
    var isCollected:Bool
    
    ///
    var editState:Bool = false
    var willDelete:Bool = false
    ///
    
    ///test use
    init(id:Int,title:String,subtitle:String,image:UIImage?,
         latitude:CLLocationDegrees,longitude:CLLocationDegrees,isShared:Bool,isCollected:Bool) {
        self.photoId = id
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
        self.description = subtitle
        self.isShared = isShared
        self.isCollected = isCollected
        self.editState = false
        self.imageData = image!.pngData()!
        self.time = "2019-01-01"
    }
    
    init(photoId : Int, fileUserId : Int, fileUserNickname : String, name : String,
         time : String, latitude : Double, longitude : Double, imageData : Data?,
         title : String, description : String, isShared : Bool, isFavourated : Bool) {
        self.photoId = photoId
        self.fileUserId = fileUserId
        self.fileUserNickname = fileUserNickname
        self.filename = name
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.description = description
        self.isShared = isShared
        self.isCollected = isFavourated
        self.time = time
        self.imageData = imageData ?? Data()
    }
    
//    init(json : JSON) {
//        self.photoId = json["photo_id"].intValue
//        self.fileUserId = json["file_user_id"].intValue
//        self.fileUserNickname = json["nickname"].stringValue
//        self.filename = json["file_name"].stringValue
//        self.latitude = json["latitude"].doubleValue
//        self.longitude = json["longitude"].doubleValue
//        self.title = json["title"].stringValue
//        self.description = json["description"].stringValue
//        self.isShared = json["is_shared"].boolValue
//        self.isCollected = json["is_fav"].boolValue
//        self.time = json["upload_time"].stringValue
//    }
    
    init(json : JSON, imageData : Data) {
        self.photoId = json["photo_id"].intValue
        self.fileUserId = json["file_user_id"].intValue
        self.fileUserNickname = json["nickname"].stringValue
        self.filename = json["file_name"].stringValue
        self.latitude = json["latitude"].doubleValue
        self.longitude = json["longitude"].doubleValue
        self.title = json["title"].stringValue
        self.description = json["description"].stringValue
        self.isShared = json["is_shared"].boolValue
        self.isCollected = json["is_fav"].boolValue
        self.time = json["upload_time"].stringValue
        self.imageData = imageData
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
            ann.image = UIImage(data: self.imageData)
            ann.title = self.title
            ann.subtitle = self.description
            ann.coordinate = self.locatation
            return ann
        }
    }
}

