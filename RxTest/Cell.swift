//
//  Cell.swift
//  RxTest
//
//  Created by xiaoP on 2017/2/28.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import UIKit
import CoreBluetooth
import RxSwift

class Cell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var state: UILabel!
    private(set) var bag = DisposeBag()
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }

    func fillData(cb: CBPeripheral, refreshSignal: Observable<Void>) {
        name.text = cb.name
        state.text = cb.state.description
        
        refreshSignal
            .debug("\(cb.name)")
            .bindNext { [weak self] in
                self?.state.text = cb.state.description
            }
            .addDisposableTo(bag)
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
