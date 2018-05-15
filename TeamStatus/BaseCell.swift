//
//  BaseCell.swift
//  TeamStatus
//
//  Created by craig.brossman@ricoh-usa.com on 3/20/18.
//  Copyright © 2018 craig.brossman@ricoh-usa.com. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    func setUpViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
