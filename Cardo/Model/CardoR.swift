//
//  CardoR.swift
//  Cardo
//
//  Created by happts on 2019/5/11.
//  Copyright © 2019 happts. All rights reserved.
//

import Foundation
import RealmSwift

import SwiftyJSON

class CardoImage: Object {
    @objc dynamic var id = -9999
    @objc dynamic var imageFilePath = ""
    @objc dynamic var imageData:Data? = nil
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class CardoR:Object {
    @objc dynamic var id = -9999
    @objc dynamic var fileUserID = -9999
    @objc dynamic var time = Date()
    
    @objc dynamic var title = ""
    @objc dynamic var CardoDescription = ""
    @objc dynamic var imageFilePath = ""
    @objc dynamic var imageData:Data? = nil
    
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    
    @objc dynamic var isShared = false
    @objc dynamic var isCollected = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
extension Cardo {
    var dbModel:CardoR {
        let row = CardoR()
        row.id = self.id
        row.fileUserID = self.fileUserId
        row.time = self.time
        row.title = self.title
        row.CardoDescription = self.description
        row.imageFilePath = self.imageFilePath
        row.imageData = self.imageData
        row.latitude = self.latitude
        row.longitude = self.longitude
        row.isShared = self.isShared
        row.isCollected = self.isCollected
        return row
    }
    
    convenience init(row:CardoR) {
        self.init(id: row.id, fileUserid: row.fileUserID, time: row.time, title: row.title, description: row.CardoDescription, imageFilePath: row.imageFilePath, latitude: row.latitude, longitude: row.longitude,isShared:row.isShared,isCollected:row.isCollected,imageData:row.imageData)
    }
}

func testRealm() {
    DispatchQueue(label: "db").async {
        autoreleasepool(invoking: { () -> Void in
            let db = try! Realm()
            print(db.configuration.fileURL)
            
        })
    }

}
