//
//  CustomAnnotationView.swift
//  Cardo
//
//  Created by happts on 2019/2/28.
//  Copyright © 2019 happts. All rights reserved.
//

import UIKit
import MapKit

class CardoAnnotation: MKPointAnnotation {
    var cardo:Cardo?
    var image:UIImage?
    
    var pointViewImage:UIImage? {
        get {
            let cardopointview = CardoPointView(frame: CGRect(x: 0, y: 0, width: 45, height: 50))
            cardopointview.ImageView.image = image
            return cardopointview.convertToImage()
        }
    }
    override init() {
        super.init()
    }
}
