//
//  SectionHeaderView.swift
//  TestProject
//
//  Created by vamsi krishna reddy kamjula on 2/18/18.
//  Copyright © 2018 Patel, Sanjay. All rights reserved.
//

import UIKit

protocol SectionHeaderDelegate {
    func showAsthma(allow: Bool)
}

class SectionHeaderView: UICollectionReusableView {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var allTypesBtn: UIButton!
    @IBOutlet weak var asthmaOnlyBtn: UIButton!
    var delegate: SectionHeaderDelegate?
    
    var headerTitle: String! {
        didSet {
            titleLabel.text = headerTitle
        }
    }
    
    @IBAction func allTypesBtnPressed(_ sender: Any) {
        allTypesBtn.setTitleColor(UIColor.black, for: .normal)
        asthmaOnlyBtn.setTitleColor(UIColor.lightGray, for: .normal)
        filterContent(isAsthma: false)
    }

    @IBAction func asthmaOnlyBtnPressed(_ sender: Any) {
        asthmaOnlyBtn.setTitleColor(UIColor.black, for: .normal)
        allTypesBtn.setTitleColor(UIColor.lightGray, for: .normal)
        filterContent(isAsthma: true)
    }

    func filterContent(isAsthma: Bool) {
        if let dlgt = delegate {
            dlgt.showAsthma(allow: isAsthma)
        }
    }
}
