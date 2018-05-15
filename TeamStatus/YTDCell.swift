//
//  YTDCell.swift
//  TeamStatus
//
//  Created by craig.brossman@ricoh-usa.com on 3/20/18.
//  Copyright © 2018 craig.brossman@ricoh-usa.com. All rights reserved.
//

import UIKit

class YTDCell: BaseCell {
    var ytd: YTD? {
        didSet {
            propLabel.text = ytd?.property
            valueLabel.text = ytd?.value
        }
    }
    
    let propLabel: UILabel = {
        let label = UILabel()
        label.text = "Actual Core Services"
        return label
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.text = String(767584)
        return label
    }()
    
    override func setUpViews() {
        super.setUpViews()
        addSubview(propLabel)
        addSubview(valueLabel)
        
        addContraintsWithFormat("H:|-20-[v0(200)]-40-[v1]", views: propLabel, valueLabel)
        addContraintsWithFormat("V:|[v0]", views: propLabel)
        
        addContraintsWithFormat("V:|[v0]", views: valueLabel)
    }
    
    func addContraintsWithFormat(_ format: String, views: UIView...) {
        var viewDict = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewDict[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
}
