//
//  CardoPointView.swift
//  Cardo
//
//  Created by happts on 2019/2/27.
//  Copyright © 2019 happts. All rights reserved.
//

import UIKit
@IBDesignable
class CardoPointView: UIView {

    @IBOutlet var ContentView: UIView!
    @IBOutlet weak var ImageView: UIImageView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ContentView = loadViewFromNib()
        ContentView.frame = bounds
        addSubview(ContentView)
//        ImageView.layer.masksToBounds = true
//        ImageView.layer.cornerRadius = 25
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        ContentView = loadViewFromNib()
        ContentView.frame = bounds
        addSubview(ContentView)
//        ImageView.layer.masksToBounds = true
//        ImageView.layer.cornerRadius = 25
    }

    private func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: String(describing:CardoPointView.self), bundle: Bundle(for: self.classForCoder))
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func convertToImage() -> UIImage? {
        let view = self
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
//    func convertView(toImage v: UIView?) -> UIImage? {
//        let s: CGSize? = v?.bounds.size
//        // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
//        UIGraphicsBeginImageContextWithOptions(s ?? CGSize.zero, _: false, _: UIScreen.main.scale)
//        if let context = UIGraphicsGetCurrentContext() {
//            v?.layer.render(in: context)
//        }
//        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
//    }

}
