//
//  UserProfileViewController.swift
//  RxTest
//
//  Created by xiaoP on 2017/2/28.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import UIKit
import CoreBluetooth


class UserProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private(set) var manager: CBCentralManager!
    fileprivate(set) var _peripherals = Set<CBPeripheral>()
    var peripherals: [CBPeripheral] {
        return Array(_peripherals)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manager = CBCentralManager(delegate: self, queue: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
//
//        peripherals.asObservable()
//            .map { (cbs: Set<CBPeripheral>) -> [SectionModel<String, CBPeripheral>] in
//                let arr = Array(cbs).sorted(by: { (cb1: CBPeripheral, cb2: CBPeripheral) -> Bool in
//                    switch (cb1.state, cb2.state) {
//                    case (.connecting, _):
//                        return true
//                    case (_, .connecting):
//                        return false
//                    default:
//                        return true
//                    }
//                })
//                return [
//                    SectionModel(model: "", items: arr)
//                ]
//            }
//            .bindTo(tableView.rx.items(dataSource: dataSource))
//            .addDisposableTo(bag)
//        
//        tableView.rx.itemSelected
//            .asObservable()
//            .map { (ip: IndexPath) -> (IndexPath, Bool) in
//                return (ip, true)
//            }
//            .bindNext(tableView.deselectRow)
//            .addDisposableTo(bag)
//        
//        tableView.rx.modelSelected(CBPeripheral.self)
//            .bindNext { [unowned self] (cb: CBPeripheral) in
//                self.manager.connect(cb, options: nil)
//            }
//            .addDisposableTo(bag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        peripherals.forEach { (cb: CBPeripheral) in
            manager.cancelPeripheralConnection(cb)
        }
    }

}

extension UserProfileViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            print("poweredOff")
            
        case .poweredOn:
            print("poweredOn")
            central.scanForPeripherals(withServices: nil, options: nil)
        case .resetting:
            print("resetting")
            
        case .unauthorized:
            print("unauthorized")
            
        case .unknown:
            print("unknown")
            
        case .unsupported:
            print("unknown")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        _peripherals.insert(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        print("didDisconnectPeripheral \(error)")
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
        print("didFailToConnect \(error)")
    }
    
    
}

extension UserProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! Cell
        cell.fillData(cb: peripherals[indexPath.row])
        return cell
    }
    
}

extension UserProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}
