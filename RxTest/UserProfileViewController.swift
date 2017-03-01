//
//  UserProfileViewController.swift
//  RxTest
//
//  Created by xiaoP on 2017/2/28.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import UIKit
import RxSwift

class UserProfileViewController: UIViewController {
    
    enum CellType {
        case briefDescription(info: VisitedInfo)
        case background(title: String, content: String)
        case require(require: Require)
    }
    
    @IBOutlet weak var tableView: UITableView!
    let viewModel = UserProfileViewModel()
    let bag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        bind()
    }

    func config() {
        tableView.delegate = self
        title = "人脉"
        viewModel.dataSources.configureCell = { ds, tv, ip, type in
            switch type {
            case .briefDescription(let info):
                let cell = tv.dequeueReusableCell(withIdentifier: "BriefDescriptionCell") as! BriefDescriptionCell
                cell.fillData(info: info)
                return cell
            case .background(let title, let content):
                let cell = tv.dequeueReusableCell(withIdentifier: "BackgroundCell") as! BackgroundCell
                cell.fillData(title: title, content: content)
                return cell
            case .require(let r):
                let cell = tv.dequeueReusableCell(withIdentifier: "RequireCell") as! RequireCell
                cell.fillData(require: r)
                return cell
            }
        }
    }
    
    func bind() {
        viewModel.cells
            .asObservable()
            .bindTo(tableView.rx.items(dataSource: viewModel.dataSources))
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
        let cellType = viewModel.dataSources[indexPath]
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
