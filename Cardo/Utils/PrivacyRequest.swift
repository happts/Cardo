//
//  PrivacyRequest.swift
//  Cardo
//
//  Created by happts on 2019/3/23.
//  Copyright © 2019 happts. All rights reserved.
//

import UIKit
import CoreLocation

class PrivacyRequest {
    class func requestLocationPrivacy(locationManager:CLLocationManager,completation:((Bool)->Void)){
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            if !CLLocationManager.locationServicesEnabled(){
                UIAlertUtils.alertControllerWithMessage(ViewController: locationManager.delegate as! UIViewController, message: "请前往 设置 开启定位服务")
            }else {
                completation(true)
            }
        default:
            UIAlertUtils.alertControllerWithMessage(ViewController: locationManager.delegate as! UIViewController, message: "请前往 设置-隐私-定位服务 开启权限")
        }
    }
    
}

