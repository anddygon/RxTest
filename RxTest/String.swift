//
//  String.swift
//  RxTest
//
//  Created by xiaoP on 2017/3/1.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import Foundation

extension String {
    
    var number: NSNumber? {
        let formatter = NumberFormatter()
        let number = formatter.number(from: self)
        return number
    }
    
    var double: Double? {
        return number?.doubleValue
    }
    
}
