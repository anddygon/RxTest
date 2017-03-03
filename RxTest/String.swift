//
//  String.swift
//  RxTest
//
//  Created by xiaoP on 2017/3/1.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import Foundation
import TextAttributes

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

extension String {
    
    func buildAttributedString(normalAttribute: TextAttributes, highLightItems items: [String: TextAttributes]) -> NSAttributedString {
        let attString = NSMutableAttributedString(string: self, attributes: normalAttribute)
        for (str, att) in items {
            let range = (self as NSString).range(of: str)
            attString.addAttributes(att, range: range)
        }
        return attString
    }
    
}
