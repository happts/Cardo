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
    
    var image:UIImage? {
        set {
            self.ImageView.image = newValue
        }
        get {
            return self.ImageView.image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ContentView = loadViewFromNib()
        ContentView.frame = bounds
        addSubview(ContentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        ContentView = loadViewFromNib()
        ContentView.frame = bounds
        addSubview(ContentView)
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
    
}
