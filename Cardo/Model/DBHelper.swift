//
//  DBHelper.swift
//  Cardo
//
//  Created by happts on 2019/5/11.
//  Copyright © 2019 happts. All rights reserved.
//

import Foundation
import RealmSwift

class DBHelper {
    
    let db = try! Realm()
    
    static let instance = DBHelper()
    
    private init() {}
    
    func add_Async(row:Object) {
        DispatchQueue(label: "db").async {
            autoreleasepool(invoking: { () -> Void in
                let db = try! Realm()
                try! db.write {
                    db.add(row)
                }
            })
        }
    }
    
    func add(row:Object) {
        try! db.write {
            db.add(row)
        }
    }
    
    func deleteAll() {
        try! db.write {
            db.deleteAll()
        }
    }
}
