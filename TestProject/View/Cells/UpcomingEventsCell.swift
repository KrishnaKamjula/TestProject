//
//  UpcomingEventsCell.swift
//  TestProject
//
//  Created by vamsi krishna reddy kamjula on 2/18/18.
//  Copyright © 2018 Patel, Sanjay. All rights reserved.
//

import UIKit

class UpcomingEventsCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var addressLblOne: UILabel!
    @IBOutlet weak var addressLblTwo: UILabel!
    @IBOutlet weak var drNameLbl: UILabel!
    @IBOutlet weak var specialistLbl: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func prepareForReuse() {
        image.image = #imageLiteral(resourceName: "profImage")
    }
    
    var date: String! {
        didSet {
            dateLabel.text = date
        }
    }

    var time: String! {
        didSet {
            timeLbl.text = time
        }
    }
    
    var addressOne: String! {
        didSet {
            addressLblOne.text = addressOne
        }
    }
    
    var addressTwo: String! {
        didSet {
            addressLblTwo.text = addressTwo
        }
    }
    
    var drName: String! {
        didSet {
            drNameLbl.text = drName
        }
    }
    
    var specialist: String! {
        didSet {
            specialistLbl.text = specialist
        }
    }
}

