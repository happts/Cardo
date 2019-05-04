//
//  CardoAnnotationView.swift
//  Cardo
//
//  Created by happts on 2019/3/13.
//  Copyright © 2019 happts. All rights reserved.
//

import UIKit
import MapKit

class CardoAnnotationView: MKAnnotationView {
    
    var cardo:Cardo?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = true
        self.centerOffset = CGPoint(x: 0, y: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
