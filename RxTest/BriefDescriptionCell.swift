//
//  BriefDescriptionCell.swift
//  RxTest
//
//  Created by xiaoP on 2017/2/28.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import UIKit
import TextAttributes

class BriefDescriptionCell: BaseTableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var identity: UILabel!
    @IBOutlet weak var platform: UILabel!
    @IBOutlet weak var connections: UILabel!
    @IBOutlet weak var favorited: UILabel!
    @IBOutlet weak var viewed: UILabel!
    
    
    func fillData(info: VisitedInfo)  {
        
        avatar.image = UIImage(named: info.avatar)
        name.text = info.name + " · " + info.title
        identity.isHidden = info.is_identity != "1"
        platform.text = info.company
        connections.attributedText = buildAttributedString(string: "人脉 \(info.connection_num)")
        favorited.attributedText = buildAttributedString(string: "收藏 \(info.favored_num)")
        viewed.attributedText = buildAttributedString(string: "查看 \(info.viewed_num)")
    }
    
    func buildAttributedString(string: String) -> NSAttributedString {
        let att = TextAttributes()
            .foregroundColor(.black)
        let attString = NSMutableAttributedString(string: string, attributes: att)
        let grayAtt = TextAttributes()
            .foregroundColor(.lightGray)
        let titles = ["人脉", "收藏", "查看"]
        for title in titles {
            let range = (string as NSString).range(of: title)
            if range.location != NSNotFound {
                attString.addAttributes(grayAtt, range: range)
                break
            }
        }
        return attString
    }
    
}

