//
//  ThreeViewController.swift
//  Cardo
//
//  Created by happts on 2019/2/23.
//  Copyright © 2019 happts. All rights reserved.
//

import UIKit
import MapKit
import ESTabBarController_swift

import CoreLocation

class MapCardsViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet weak var MineOrOthersSegmentedControl: UISegmentedControl!
    
    @IBAction func switchStateAction(_ sender: UISegmentedControl) {
        self.CardMapView.removeAnnotations(self.CardMapView.annotations)
        if sender.selectedSegmentIndex == 0 {
            for cardo in mycardoList {
                CardMapView.addAnnotation(cardo.pointAnnoation)
            }
            print("now is 0, My Cardo")
        }else {
            print("now is 1, Others Cardo")
            for cardo in nearbyCardoList {
                CardMapView.addAnnotation(cardo.pointAnnoation)
            }
        }
    }
    @IBOutlet weak var CardMapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var mycardoList:[Cardo] = []
    var nearbyCardoList:[Cardo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        requestPrivacy()
        
        CardMapView.delegate = self
        CardMapView.mapType = .standard
        CardMapView.showsUserLocation = true
        CardMapView.userTrackingMode = .followWithHeading
        
        testdata()
    }
    
    func testdata() {
        let a = Cardo(id: 0, title: "test1", subtitle: "test sub test", image: UIImage(named: "bkg"), latitude: 31.497438, longitude: 120.318628, isShared: true, isCollected: true)
        self.mycardoList.append(a)
        
        let b = Cardo(id: 1, title: "test2", subtitle: "it is a story", image: UIImage(named: "bkg"), latitude: 31.497438, longitude: 120.318628, isShared: true, isCollected: true)
        self.nearbyCardoList.append(b)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CardMapView.setRegion(MKCoordinateRegion(center: locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 31.497438, longitude: 120.318628), latitudinalMeters: 5000, longitudinalMeters: 5000), animated: true)

        for cardo in mycardoList {
            CardMapView.addAnnotation(cardo.pointAnnoation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let reuserId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuserId)
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuserId)
            pinView?.centerOffset = CGPoint(x: 0, y: 0)
            pinView?.canShowCallout = true
        }
        pinView?.annotation = annotation
        
        pinView?.image = (annotation as! CardoAnnotation).pointViewImage
        
        let imageview = UIImageView(image: (annotation as! CardoAnnotation).image)
        imageview.frame.size = CGSize(width: 50, height: 50)
        pinView?.leftCalloutAccessoryView = imageview
        
        if self.MineOrOthersSegmentedControl.selectedSegmentIndex == 1 {
//            let imageview = UIImageView(image: (annotation as! CardoAnnotation).image)
//            imageview.frame.size = CGSize(width: 50, height: 50)
//            pinView?.rightCalloutAccessoryView = imageview
        }
        
        return pinView
    }
    

    func requestPrivacy(){
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            if !CLLocationManager.locationServicesEnabled(){
                UIAlertUtils.alertControllerWithMessage(ViewController: self, message: "请前往 设置 开启定位服务")
            }
        default:
            UIAlertUtils.alertControllerWithMessage(ViewController: self, message: "请前往 设置-隐私-定位服务 开启权限")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
