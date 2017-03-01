//
//  RequireCell.swift
//  RxTest
//
//  Created by xiaoP on 2017/2/28.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import UIKit
import TextAttributes

class RequireCell: BaseTableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var require: UILabel!
    @IBOutlet weak var reward: UILabel!
    @IBOutlet weak var time: UILabel!
    
    
    func fillData(require r: Require) {
        icon.image = UIImage(named: "requires_\(r.type)")
        title.text = r.title
        require.text = r.desciption
        reward.attributedText = buildAttributedString(string: "回报方式 \(r.repay.joined(separator: ","))")
        if let intervals = r.create_time.double {
            time.text = buildTime(intervals: intervals)
        } else {
            time.text = ""
        }
    }
    
    func buildAttributedString(string: String) -> NSAttributedString {
        let att = TextAttributes()
            .foregroundColor(.black)
        let attString = NSMutableAttributedString(string: string, attributes: att)
        let grayAtt = TextAttributes()
            .foregroundColor(.gray)

        let range = (string as NSString).range(of: "回报方式")
        attString.addAttributes(grayAtt, range: range)
        return attString
    }
    
    func buildTime(intervals: TimeInterval) -> String {
        let nowIntervals = Date().timeIntervalSince1970
        let distance = abs(nowIntervals - intervals)
        switch distance {
        case 0..<60:
            return "刚刚"
        case 60..<60 * 60:
            let minnutes = Int(distance / 60)
            return "\(minnutes)分钟前"
        case 60 * 60..<24 * 60 * 60:
            let hours = Int(distance / (60 * 60))
            return "\(hours)小时前"
        default:
            let days = Int(distance / (24 * 60 * 60))
            return "\(days)天前"
        }
    }
    
}

