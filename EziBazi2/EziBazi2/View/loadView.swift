//
//  loadView.swift
//  EziBazi2
//
//  Created by AliArabgary on 10/7/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit

class loadData: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required public init?(coder : NSCoder) {
        super.init(coder: coder)
        config()
    }
    override func draw(_ rect: CGRect) {
    config()
    }
    func config(){
        backgroundColor = UIColor.white
    }
    public func hideView(){
        self.alpha = 0.0
    }
    public func showView(){
        self.alpha = 1.0
    }
}
