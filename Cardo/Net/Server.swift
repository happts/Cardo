//
//  Server.swift
//  Cardo-m
//
//  Created by app on 2019/3/5.
//  Copyright © 2019年 jndxttt. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Server {
    static let serverProtocol = "http://"
    static let host = "140.143.233.35:3000"
    static let baseUrl = serverProtocol + host
    
    static let registerUrl = baseUrl + "/api/register"
    
    static let loginUrl = baseUrl + "/api/login"
    
    static let logoutUrl = baseUrl + "/api/logout"
    
    static let uploadUrl = baseUrl + "/api/upload"
    
    static let photoUrl = baseUrl + "/api/photo"
    
    static let deleteUrl = baseUrl + "/api/delete"
    
    static let favouriteUrl = baseUrl + "/api/favourite"
    
    static let unfavouriteUrl = baseUrl + "/api/unfavourite"
    
    static let shareUrl = baseUrl + "/api/share"
    
    static let unshareUrl = baseUrl + "/api/unshare"
    
    static let modifydescriptionUrl = baseUrl + "api/modifydescription"
}

