//
//  PastEventsCell.swift
//  TestProject
//
//  Created by vamsi krishna reddy kamjula on 2/18/18.
//  Copyright © 2018 Patel, Sanjay. All rights reserved.
//

import UIKit

class PastEventsCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeAndDrNameLbl: UILabel!
    @IBOutlet weak var specialistLbl: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func prepareForReuse() {
        image.image = #imageLiteral(resourceName: "profImage")
    }
    
    var date: String! {
        didSet {
            dateLbl.text = date
        }
    }
    
    var timeAndDrName: String! {
        didSet {
            timeAndDrNameLbl.text = timeAndDrName
        }
    }
    
    var specialist: String! {
        didSet {
            specialistLbl.text = specialist
        }
    }
}
