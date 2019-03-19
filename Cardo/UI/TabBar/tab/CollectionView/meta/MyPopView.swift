//
//  MyPopView.swift
//  Cardo
//
//  Created by happts on 2019/3/7.
//  Copyright © 2019 happts. All rights reserved.
//

import UIKit

@IBDesignable
class MyPopView: UIView {

    @IBOutlet weak var WordsLabel: UILabel!
    
    @IBOutlet var ContentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ContentView = loadViewFromNib()
        ContentView.frame = WordsLabel.frame
        ContentView.layer.masksToBounds = true
        ContentView.layer.cornerRadius = 8
        addSubview(ContentView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        ContentView = loadViewFromNib()
        ContentView.frame = WordsLabel.frame//bounds
        addSubview(ContentView)
        
    }
    
    private func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: String(describing:MyPopView.self), bundle: Bundle(for: self.classForCoder))
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

}
