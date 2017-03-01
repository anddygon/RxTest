//
//  BackgroundCell.swift
//  RxTest
//
//  Created by xiaoP on 2017/2/28.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import UIKit

class BackgroundCell: BaseTableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    
    
    func fillData(title: String, content: String) {
        self.title.text = title
        self.content.text = content
    }
    
}

