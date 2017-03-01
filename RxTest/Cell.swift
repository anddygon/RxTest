//
//  Cell.swift
//  RxTest
//
//  Created by xiaoP on 2017/2/28.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import UIKit
import CoreBluetooth

class Cell: UITableViewCell {
    
    @IBOutlet weak var rssi: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var state: UILabel!
    
    func fillData(cb: CBPeripheral) {
        name.text = cb.name ?? "没有名字"
        rssi.text = cb.identifier.description
        state.text = cb.state.description
    }
    
}

extension CBPeripheralState: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .connected:
            return "已连接"
            
        case .connecting:
            return "连接中"
            
        case .disconnected:
            return "已断开"
            
        case .disconnecting:
            return "断开中"
        
        }
    }
    
}
