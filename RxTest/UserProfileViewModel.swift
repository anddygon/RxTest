//
//  UserProfileViewModel.swift
//  RxTest
//
//  Created by xiaoP on 2017/2/28.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class UserProfileViewModel {
    
    typealias CellType = UserProfileViewController.CellType
    
    let bag = DisposeBag()
    let cells = Variable<[SectionModel<String, CellType>]>([])
    let dataSources = RxTableViewSectionedReloadDataSource<SectionModel<String, CellType>>()
    
    
    init() {
        let urlString = "https://www.veryangels.com/user/detail/a726d8d4fb59edf600dd51f064bc059c"
        let user = rx_request(urlString, method: .get, params: nil)
            .retry(3)
            .catchError { (error: Error) -> Observable<(AnyObject?, HTTPURLResponse?)> in
                return Observable.empty()
            }
            .mapObject(User.self)
            .shareReplay(1)
        
        user
            .map(userToCells)
            .bindTo(cells)
            .addDisposableTo(bag)
    }
    
    func userToCells(user: User) -> [SectionModel<String, CellType>] {
        var sections: [SectionModel<String, CellType>] = []
        //简介
        let briefSection = SectionModel(model: "", items: [
            CellType.briefDescription(info: user.visitedInfo)
            ])
        //背景
            //行业
        var backgroundItems: [CellType] = []
        if !user.visitedInfo.industry.isEmpty {//行业为空不显示
            let title = "行业"
            let content = user.visitedInfo.industry.joined(separator: "    ")
            backgroundItems.append(.background(title: title, content: content))
        }
            //领域
        if !user.visitedInfo.field.isEmpty {
            let title = "领域"
            let content = user.visitedInfo.field.joined(separator: "    ")
            backgroundItems.append(.background(title: title, content: content))
        }
            //地区
        if !user.visitedInfo.province_title.isEmpty {
            let title = "地区"
            let content = user.visitedInfo.province_title
            backgroundItems.append(.background(title: title, content: content))
        }
            //能力
        if !user.visitedInfo.skill.isEmpty {
            let title = "核心能力"
            let content = user.visitedInfo.skill.joined(separator: "    ")
            backgroundItems.append(.background(title: title, content: content))
        }
            //入驻
        if !user.visitedInfo.space_title.isEmpty {
            let title = "入驻"
            let content = user.visitedInfo.space_title
            backgroundItems.append(.background(title: title, content: content))
        }
        
        let backgroundSection = SectionModel(model: "", items: backgroundItems)
        //需求
        let requireSection = SectionModel(model: "", items: user.requires.map({ (r: Require) -> CellType in
            return .require(require: r)
        }))
        
        sections.append(briefSection)
        sections.append(backgroundSection)
        sections.append(requireSection)
        
        return sections
    }
    
}
