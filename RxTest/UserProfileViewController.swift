//
//  UserProfileViewController.swift
//  RxTest
//
//  Created by xiaoP on 2017/2/28.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import CoreBluetooth


private let refreshSignal = PublishSubject<Void>()
class UserProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private(set) var manager: CBCentralManager!
    let peripherals = Variable<Set<CBPeripheral>>([])
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, CBPeripheral>>()
    let bag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manager = CBCentralManager(delegate: self, queue: nil)
        
        tableView.delegate = self
        
        dataSource.configureCell = { ds, tv, ip, cb in
            let cell = tv.dequeueReusableCell(withIdentifier: "Cell") as! Cell
            cell.fillData(cb: cb, refreshSignal: refreshSignal)
            return cell
        }
        
        peripherals.asObservable()
            .map { (cbs: Set<CBPeripheral>) -> [SectionModel<String, CBPeripheral>] in
                return [
                    SectionModel(model: "", items: Array(cbs))
                ]
            }
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(bag)
        
        tableView.rx.itemSelected
            .asObservable()
            .map { (ip: IndexPath) -> (IndexPath, Bool) in
                return (ip, true)
            }
            .bindNext(tableView.deselectRow)
            .addDisposableTo(bag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        peripherals.value.forEach { (cb: CBPeripheral) in
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
        peripherals.value.insert(peripheral)
        central.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        refreshSignal.onNext()
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        refreshSignal.onNext()
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        refreshSignal.onNext()
    }
    
    
}

extension UserProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}
