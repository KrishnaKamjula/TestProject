//
//  CircularImageView.swift
//  TestProject
//
//  Created by vamsi krishna reddy kamjula on 2/18/18.
//  Copyright © 2018 Patel, Sanjay. All rights reserved.
//

import UIKit

class CircularImageView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
}

