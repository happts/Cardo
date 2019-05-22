//
//  MyTabBarController.swift
//  Cardo
//
//  Created by happts on 2019/2/23.
//  Copyright © 2019 happts. All rights reserved.
//

import UIKit
import ESTabBarController_swift

import CoreLocation
import RealmSwift

class MyTabBarController: ESTabBarController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CLLocationManagerDelegate {
    
    var isOCR = false
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        
        let tabBarController = self
        
        tabBarController.delegate = delegate
        tabBarController.title = "Irregularity"
        tabBarController.tabBar.shadowImage = UIImage(named: "transparent")
        
        var vcs = self.viewControllers ?? []
        for i in 0..<vcs.count {
            switch i {
            case 0:
                vcs[i].tabBarItem = ESTabBarItem.init(TabBarColorContentView(), title: "", image: UIImage(named: "calendar"), selectedImage: UIImage(named: "calendar_select"))
            case 1:
                vcs[i].tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(), title: nil, image: UIImage(named: "photo_verybig"), selectedImage: UIImage(named: "photo_verybig"))
                vcs[i].tabBarItem.tag = 9
            case 2:
                vcs[i].tabBarItem = ESTabBarItem.init(TabBarColorContentView(), title: "", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
            default:
                vcs[i].tabBarItem = ESTabBarItem.init(TabBarColorContentView(), title: "", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
            }
        }
        // Do any additional setup after loading the view.
        
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 9 {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse :
                toCameraController()
            default:
                PrivacyRequest.requestLocationPrivacy(locationManager: locationManager, completation: nil)
            }
        }else {
            super.tabBar(tabBar, didSelect: item)
        }
    }
    
    func toCameraController(){
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let translateAction = UIAlertAction(title: "翻译", style: .default){ _ in
            self.isOCR = true
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let  cameraPicker = UIImagePickerController()
                cameraPicker.delegate = self
                cameraPicker.allowsEditing = true
                cameraPicker.sourceType = .camera
                //                    cameraPicker.showsCameraControls = false
                //                    cameraPicker.cameraOverlayView = self.setCameraView()
                //在需要的地方present出来
                self.present(cameraPicker, animated: true, completion: nil)
            } else {
                print("不支持拍照")
            }
        }
        
        alertController.addAction(translateAction)
        let objectDetectAction = UIAlertAction(title: "识别", style: .default){ _ in
            self.isOCR = false
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let  cameraPicker = UIImagePickerController()
                cameraPicker.delegate = self
                cameraPicker.allowsEditing = true
                cameraPicker.sourceType = .camera
                //                    cameraPicker.showsCameraControls = false
                //                    cameraPicker.cameraOverlayView = self.setCameraView()
                //在需要的地方present出来
                self.present(cameraPicker, animated: true, completion: nil)
            } else {
                print("不支持拍照")
            }
        }
        alertController.addAction(objectDetectAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let lt = locationManager.location?.coordinate
        
        let vc = CardoViewController()
        vc.photoResult = true
        vc.loadViewIfNeeded()
        vc.ActivittyIndicator.startAnimating()
        vc.ImageView.image = image
        picker.pushViewController(vc, animated: true)
        
        
        let result:(String,String,Int?)->Void = { (title,desc,photo_id) in
            vc.ActivittyIndicator.stopAnimating()
            vc.NameLabel.text = title
            vc.ResultTextView.text = desc
            
            if let p_id = photo_id {
                vc.photo_id = p_id
                let row = CardoImage()
                row.id = p_id
                row.imageData = image.pngData()
                row.imageFilePath = ""
                
                let db = try! Realm()
                if db.object(ofType: CardoImage.self, forPrimaryKey: row.id) == nil {
                    try! db.write {
                        db.add(row)
                    }
                }
            }
        }
        
        
        if isOCR {
            User.instance.cardoOR(imageData: image.pngData()!, longitude: lt?.longitude ?? 0, latitude: lt?.latitude ?? 0, completation: result)
//            User.instance.cardoOCR(imageData: image.pngData()!, longitude: lt?.longitude ?? 0, latitude: lt?.latitude ?? 0) { (title, desc,photo_id)  in
//                vc.ActivittyIndicator.stopAnimating()
//                vc.NameLabel.text = title
//                vc.ResultTextView.text = desc
//
//                if let p_id = photo_id {
//
//                    let row = CardoImage()
//                    row.id = p_id
//                    row.imageData = image.pngData()
//                    row.imageFilePath = ""
//
//                    let db = try! Realm()
//                    if db.object(ofType: CardoImage.self, forPrimaryKey: row.id) == nil {
//                        try! db.write {
//                            db.add(row)
//                        }
//                    }
//                }
//            }
        }else {
            User.instance.cardoOR(imageData: image.pngData()!, longitude: lt?.longitude ?? 0, latitude: lt?.latitude ?? 0, completation: result)
//            User.instance.cardoOR(imageData: image.pngData()!, longitude: lt?.longitude ?? 0, latitude: lt?.latitude ?? 0) { (msg, words,photo_id)  in
//                vc.ActivittyIndicator.stopAnimating()
//                vc.NameLabel.text = msg
//                vc.ResultTextView.text = words
//
//                if let p_id = photo_id {
//
//                    let row = CardoImage()
//                    row.id = p_id
//                    row.imageData = image.pngData()
//                    row.imageFilePath = ""
//
//                    let db = try! Realm()
//                    if db.object(ofType: CardoImage.self, forPrimaryKey: row.id) == nil {
//                        try! db.write {
//                            db.add(row)
//                        }
//                    }
//                }
//            }
        }
        
        
        
        
        
    }

}




// TabBarItemView
class TabBarColorContentView: ESTabBarItemContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor.init(white: 175.0 / 255.0, alpha: 1.0)
        highlightTextColor = UIColor.init(red: 227/255.0, green: 191/255.0, blue: 0/255.0, alpha: 1.0)
        iconColor = UIColor.init(white: 175.0 / 255.0, alpha: 1.0)
        highlightIconColor = UIColor.init(red: 227/255.0, green: 191/255.0, blue: 0/255.0, alpha: 1.0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class ExampleIrregularityContentView: ESTabBarItemContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView.backgroundColor = UIColor.init(red: 23/255.0, green: 149/255.0, blue: 158/255.0, alpha: 1.0)
        self.imageView.layer.borderWidth = 3.0
        self.imageView.layer.borderColor = UIColor.init(white: 235 / 255.0, alpha: 1.0).cgColor
        self.imageView.layer.cornerRadius = 35
        self.insets = UIEdgeInsets.init(top: -32, left: 0, bottom: 0, right: 0)
        let transform = CGAffineTransform.identity
        self.imageView.transform = transform
        self.superview?.bringSubviewToFront(self)
        
        textColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        highlightTextColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        iconColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        highlightIconColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        backdropColor = .clear
        highlightBackdropColor = .clear
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let p = CGPoint.init(x: point.x - imageView.frame.origin.x, y: point.y - imageView.frame.origin.y)
        return sqrt(pow(imageView.bounds.size.width / 2.0 - p.x, 2) + pow(imageView.bounds.size.height / 2.0 - p.y, 2)) < imageView.bounds.size.width / 2.0
    }
    
    override func updateLayout() {
        super.updateLayout()
        self.imageView.sizeToFit()
        self.imageView.center = CGPoint.init(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 2.0)
    }
    
    public override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        let view = UIView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize(width: 2.0, height: 2.0)))
        view.layer.cornerRadius = 1.0
        view.layer.opacity = 0.5
        view.backgroundColor = UIColor.init(red: 10/255.0, green: 66/255.0, blue: 91/255.0, alpha: 1.0)
        self.addSubview(view)
        playMaskAnimation(animateView: view, target: self.imageView, completion: {
            [weak view] in
            view?.removeFromSuperview()
            completion?()
        })
    }
    
    public override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    public override func deselectAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    public override func highlightAnimation(animated: Bool, completion: (() -> ())?) {
        UIView.beginAnimations("small", context: nil)
        UIView.setAnimationDuration(0.2)
        let transform = self.imageView.transform.scaledBy(x: 0.8, y: 0.8)
        self.imageView.transform = transform
        UIView.commitAnimations()
        completion?()
    }
    
    public override func dehighlightAnimation(animated: Bool, completion: (() -> ())?) {
        UIView.beginAnimations("big", context: nil)
        UIView.setAnimationDuration(0.2)
        let transform = CGAffineTransform.identity
        self.imageView.transform = transform
        UIView.commitAnimations()
        completion?()
    }
    
    private func playMaskAnimation(animateView view: UIView, target: UIView, completion: (() -> ())?) {
        view.center = CGPoint.init(x: target.frame.origin.x + target.frame.size.width / 2.0, y: target.frame.origin.y + target.frame.size.height / 2.0)
    }
    
}
