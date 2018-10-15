//
//  SearchFooter.swift
//  EziBazi2
//
//  Created by AliArabgary on 10/6/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import Foundation
import UIKit

class SearchFooter: UIView {
    
    let label:UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    required public init?(coder:NSCoder){
        super.init(coder: coder)
        configView()
    }
    override func draw(_ rect: CGRect) {
        label.frame = bounds
    }
    internal func configView(){
        
        backgroundColor = UIColor.ezibaziThem
        alpha = 0.0
        label.textAlignment = .center
        label.textColor = .white
        addSubview(label)
    }
    func hideFooter(){
        UIView.animate(withDuration: 0.4) {
            self.alpha = 0.0
        }
    }
    
    func showFooter(){
        UIView.animate(withDuration: 0.8) {
            self.alpha = 1.0
        }
    }
    internal func setNoFilter(){
        
        label.text = ""
        hideFooter()
    }
    public func filterShow(_ itemFiltered:Int){
       
        if(itemFiltered == 0){
            label.text = "هیچ موردی یافت نشد  :("
            showFooter()
        }else{

            label.text = "\(itemFiltered) مورد یافت شد"
            showFooter()
            
        }
        
        
        
    }
    
    
    
    
    
    
    
}
