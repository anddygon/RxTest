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
        case requireHeader
    }
    
    @IBOutlet weak var checkCard: UIButton!
    @IBOutlet weak var share: UIButton!
    @IBOutlet weak var favorite: UIButton!
    @IBOutlet weak var toolBar: UIView!
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
        
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        tableView.backgroundView = aiv
        
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
                
            case .requireHeader:
                let cell = tv.dequeueReusableCell(withIdentifier: "RequireHeaderCell") as! RequireHeaderCell
                return cell
            }
        }
    }
    
    func bind() {
        //数据绑定
        viewModel.cells
            .asObservable()
            .bindTo(tableView.rx.items(dataSource: viewModel.dataSources))
            .addDisposableTo(bag)
        
        //反选
        tableView.rx.itemSelected
            .asObservable()
            .map { (ip: IndexPath) -> (IndexPath, Bool) in
                return (ip, true)
            }
            .bindNext(tableView.deselectRow)
            .addDisposableTo(bag)
        
        //有没有数据
        let haveCells = viewModel.cells
            .asObservable()
            .map { (sections) -> Bool in
                return sections.isEmpty
            }
            .distinctUntilChanged()
            .shareReplay(1)
        
        //底部bar和列表数据显示一致
        haveCells
            .bindTo(toolBar.rx.isHidden)
            .addDisposableTo(bag)
        
        //网络加载指示
        let aiv = tableView.backgroundView as! UIActivityIndicatorView
        haveCells
            .bindNext { (had: Bool) in
                had ? aiv.stopAnimating() : aiv.startAnimating()
            }
            .addDisposableTo(bag)
        
        //点击
        tableView.rx.modelSelected(CellType.self)
            .bindNext { (type: CellType) in
                switch type {
                case .briefDescription:
                    print("点击简介cell")
                    
                case .background(let title, _):
                    if title == "入驻" {
                        print("加载视图-47")
                    } else {
                        print("点击个人背景cell \(title)")
                    }
                    
                case .require:
                    print("加载视图-15")
                    
                default:
                    break
                }
            }
            .addDisposableTo(bag)
        
        favorite.rx.tap
            .asObservable()
            .bindNext {
                print("若 条件-1 则加载 视图-7 否则调用 接口-29 收藏人脉")
            }
            .addDisposableTo(bag)
        
        share.rx.tap
            .asObservable()
            .bindNext {
                print("加载 视图-32")
            }
            .addDisposableTo(bag)
        
        
    }
    
    deinit {
        print("deinit invoke!")
    }
    
}

extension UserProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = viewModel.dataSources[indexPath]
        switch cellType {
        case .briefDescription:
            return 88
        case .background, .requireHeader:
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(getter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }
        
    }
    
}
