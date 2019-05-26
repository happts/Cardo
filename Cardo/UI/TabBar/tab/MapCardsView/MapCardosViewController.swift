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

class MapCardosViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet weak var MineOrOthersSegmentedControl: UISegmentedControl!
    
    @IBAction func switchStateAction(_ sender: UISegmentedControl) {
        self.CardMapView.removeAnnotations(self.CardMapView.annotations)
        if sender.selectedSegmentIndex == 0 {
            ViewModel.loadMyCardos()
            print("now is 0, My Cardo")
        }else {
            print("now is 1, Others Cardo")
            ViewModel.loadNearbyCardos()
            let co = self.CardMapView.region.center
            ViewModel.loadNearbyCardos(longitude: co.longitude, latitude: co.latitude)
        }
    }
    @IBOutlet weak var CardMapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var ViewModel:MapCardosViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ViewModel = MapCardosViewModel(self)
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        
        PrivacyRequest.requestLocationPrivacy(locationManager: self.locationManager) { (_) in
            return
        }
        
        CardMapView.delegate = self
        CardMapView.mapType = .standard
        CardMapView.showsUserLocation = true
        CardMapView.userTrackingMode = .followWithHeading
        
        CardMapView.setRegion(MKCoordinateRegion(center: locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 31.497438, longitude: 120.318628), latitudinalMeters: 5000, longitudinalMeters: 5000), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if MineOrOthersSegmentedControl.selectedSegmentIndex == 0 {
            ViewModel.loadMyCardos()
        }else {
            ViewModel.loadNearbyCardos()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    var tmpSpan:MKCoordinateSpan!
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        tmpSpan = mapView.region.span
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("regionChanged")
//
//        if MineOrOthersSegmentedControl.selectedSegmentIndex == 1 {
//            let center = mapView.region.center
//            let span = mapView.region.span
//            if span.latitudeDelta < tmpSpan.latitudeDelta || span.longitudeDelta < tmpSpan.longitudeDelta {
//                return
//            }else {
//                ViewModel.loadNearbyCardos(longitude: center.longitude, latitude: center.latitude)
//            }
//        }
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
        
        pinView?.leftCalloutAccessoryView = {
            let imgBtn = UIButton()
            imgBtn.frame.size = CGSize(width: 50, height: 50)
            imgBtn.setImage((annotation as! CardoAnnotation).image, for: .normal)
            imgBtn.isUserInteractionEnabled = true
            return imgBtn
        }()
        
        
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let cardo = (view.annotation as! CardoAnnotation).cardo
        let vc = CardoViewController()
        vc.cardo = cardo
        vc.fromMap = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
