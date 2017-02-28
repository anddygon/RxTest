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

class UserProfileViewController: UIViewController {
    
    enum CellType {
        case briefDescription
        case background
        case require
    }
    
    @IBOutlet weak var tableView: UITableView!
    let dataSources = RxTableViewSectionedReloadDataSource<SectionModel<String, CellType>>()
    let bag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        bind()
    }

    func config() {
        tableView.delegate = self
        title = "人脉"
        dataSources.configureCell = { ds, tv, ip, type in
            switch type {
            case .briefDescription:
                let cell = tv.dequeueReusableCell(withIdentifier: "BriefDescriptionCell") as! BriefDescriptionCell
                return cell
            case .background:
                let cell = tv.dequeueReusableCell(withIdentifier: "BackgroundCell") as! BackgroundCell
                return cell
            case .require:
                let cell = tv.dequeueReusableCell(withIdentifier: "RequireCell") as! RequireCell
                return cell
            }
        }
    }
    
    func bind() {
        let sectionModels: [SectionModel<String, CellType>] = [
            SectionModel(model: "", items: [CellType.briefDescription]),
            SectionModel(model: "", items: [
                CellType.background,
                CellType.background,
                CellType.background,
                CellType.background,
                ]),
            SectionModel(model: "", items: [
                CellType.require,
                CellType.require,
                CellType.require,
                ])
        ]
        
        Observable.just(sectionModels)
            .bindTo(tableView.rx.items(dataSource: dataSources))
            .addDisposableTo(bag)
        
        tableView.rx.itemSelected
            .asObservable()
            .map { (ip: IndexPath) -> (IndexPath, Bool) in
                return (ip, true)
            }
            .bindNext(tableView.deselectRow)
            .addDisposableTo(bag)
    }

}

extension UserProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = dataSources[indexPath]
        switch cellType {
        case .briefDescription:
            return 88
        case .background:
            return 44
        case .require:
            return 74
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
}
