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
    
    func insert(row:Object) {
        DispatchQueue(label: "db").async {
            autoreleasepool(invoking: { () -> Void in
                let db = try! Realm()
                try! db.write {
                    db.add(row)
                }
            })
        }
    }
}
