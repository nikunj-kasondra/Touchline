//
//  aboutView.swift
//  tableDemo
//
//  Created by Rajesh Jadi on 19/03/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit

class aboutView: UIView {

    
    override func draw(_ rect: CGRect) {
        setUI()
    }
    func setUI(){
        self.frame = CGRect(x:0, y: 0, width:UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.size.height)
    }

    @IBAction func btnOk(_ sender: Any) {
        self.removeFromSuperview()
    }
}
