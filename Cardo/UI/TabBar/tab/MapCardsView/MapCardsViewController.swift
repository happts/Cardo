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
        if sender.selectedSegmentIndex == 0 {
            print("now is 0, My Cardo")
        }else {
            print("now is 1, Others Cardo")
        }
        
    }
    @IBOutlet weak var CardMapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        requestPrivacy()
        
        CardMapView.delegate = self
        CardMapView.mapType = .standard
        CardMapView.showsUserLocation = true
        CardMapView.userTrackingMode = .followWithHeading
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CardMapView.setRegion(MKCoordinateRegion(center: locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 31.497438, longitude: 120.318628), latitudinalMeters: 5000, longitudinalMeters: 5000), animated: true)
        
        let anno = MKPointAnnotation()
        anno.coordinate = CLLocationCoordinate2D(latitude: 31.497438, longitude: 120.318628)
        anno.title = "test"
        anno.subtitle = "subTest dasdf asdf aasdf asd"
        CardMapView.addAnnotation(anno)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let reuserId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuserId)
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuserId)
        }
        pinView?.annotation = annotation

        let cardopointview = CardoPointView(frame: CGRect(x: 0, y: 0, width: 45, height: 50))
        cardopointview.ImageView.image = UIImage(named: "bkg")
        
        pinView?.image = cardopointview.convertToImage()
        pinView?.centerOffset = CGPoint(x: 0, y: 0)
        pinView?.canShowCallout = true

        let imageview = UIImageView(image: UIImage(named: "bkg")) //UIImage(named: "favor")
        imageview.frame.size = CGSize(width: 50, height: 50)
        pinView?.leftCalloutAccessoryView = imageview
        
        if self.MineOrOthersSegmentedControl.selectedSegmentIndex == 1 {
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return pinView
    }
    
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        <#code#>
//    }
    
    

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
