//
//  COECell.swift
//  TeamStatus
//
//  Created by craig.brossman@ricoh-usa.com on 3/15/18.
//  Copyright © 2018 craig.brossman@ricoh-usa.com. All rights reserved.
//

import UIKit

class COECell: UITableViewCell {

    @IBOutlet weak var SSEName: UITextField!
    @IBOutlet weak var SSEAmount: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
