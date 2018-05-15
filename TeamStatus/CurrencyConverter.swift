//
//  CurrencyConverter.swift
//  TeamStatus
//
//  Created by craig.brossman@ricoh-usa.com on 3/19/18.
//  Copyright © 2018 craig.brossman@ricoh-usa.com. All rights reserved.
//

import Foundation
var currencyFormatter = NumberFormatter()

class CurrencyConverter {
    
    init() {
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        currencyFormatter.locale = Locale.current
    }
}
