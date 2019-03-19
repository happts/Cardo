//
//  MyTabBarController.swift
//  Cardo
//
//  Created by happts on 2019/2/23.
//  Copyright © 2019 happts. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class MyTabBarController: ESTabBarController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    var isOCR = false

    override func viewDidLoad() {
        super.viewDidLoad()

        let tabBarController = self
        
        tabBarController.delegate = delegate
        tabBarController.title = "Irregularity"
//        tabBarController.tabBar.backgroundColor = UIColor(red: 227, green: 191, blue: 0, alpha: 1)
        tabBarController.tabBar.shadowImage = UIImage(named: "transparent")
//        tabBarController.tabBar.backgroundImage = UIImage(named: "background_dark")
        
        var vcs = self.viewControllers ?? []
        for i in 0..<vcs.count {
            switch i {
            case 0:
                vcs[i].tabBarItem = ESTabBarItem.init(TabBarColorContentView(), title: "Home", image: UIImage(named: "calendar"), selectedImage: UIImage(named: "calendar_select"))
            case 1:
                vcs[i].tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(), title: nil, image: UIImage(named: "capture_item"), selectedImage: UIImage(named: "capture_item"))
                vcs[i].tabBarItem.tag = 9
            case 2:
                vcs[i].tabBarItem = ESTabBarItem.init(TabBarColorContentView(), title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
            default:
                vcs[i].tabBarItem = ESTabBarItem.init(TabBarColorContentView(), title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 9 {
            let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            let translateAction = UIAlertAction(title: "nothing will happen", style: .default){ _ in
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
            let objectDetectAction = UIAlertAction(title: "Take a photo", style: .default){ _ in
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
        }else {
            super.tabBar(tabBar, didSelect: item)
        }
    }
    
    
//    func setCameraView() -> UIView {
//        let view = UIView(frame: UIScreen.main.bounds)
//
//        let startBtn = UIButton(type: .custom)
//        startBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 100)
//        startBtn.setTitle("开始", for: .normal)
//
//        view.addSubview(startBtn)
//        return view
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let vc = CardoViewController()
        vc.loadViewIfNeeded()
        vc.ImageView.image = image
        
        vc.NameLabel.text = "识别结果"
        self.present(vc, animated: true, completion: nil)
        picker.dismiss(animated: true, completion: nil)
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
