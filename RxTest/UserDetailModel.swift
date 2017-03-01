//
//  File.swift
//  RxSwiftMVVM
//
//  Created by 我心永恒 on 17/2/23.
//  Copyright © 2017年 wangyanqing. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class User: Mappable {

    var create_card = ""
    var apply_left = ""
    var is_identity = Variable<String>("")
    var is_favor = Variable<String>("")
    var card_display = ""
    var url = ""
    var share_title = ""
    var share_desc = ""
    var share_img = ""
    var visitedInfo = VisitedInfo()
    var requires: [Require] = []
    
    init() {}
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        create_card <- map["create_card"]
        apply_left <- map["apply_left"]
        is_identity.value <- map["is_identity"]
        is_favor <- map["is_favor"]
        card_display <- map["card_display"]
        url <- map["url"]
        share_img <- map["url"]
        share_title <- map["share_title"]
        share_desc <- map["share_desc"]
        visitedInfo <- map["visited_info"]
        requires <- map["requires"]
    }
}

class VisitedInfo: Mappable {
    
    var user_id = ""
    var avatar = ""
    var viewed_num = ""
    var favored_num = ""
    var connection_num = ""
    var name = ""
    var city_title = ""
    var company = ""
    var title = ""
    var province_title = ""
    var financial_status_title = ""
    var space_title = ""
    var space_hash = ""
    var industry = [String]()
    var field = [String]()
    var skill = [String]()
    var is_identity = ""
    var is_favor = ""
    var card_display = ""
    
    
    
    fileprivate init(){
    
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        user_id <- map["user_id"]
        avatar <- map["avatar"]
        viewed_num <- map["viewed_num"]
        favored_num <- map["favored_num"]
        connection_num <- map["connection_num"]
        name <- map["name"]
        city_title <- map["city_title"]
        company <- map["company"]
        title <- map["title"]
        is_identity <- map["is_identity"]
        is_favor <- map["is_favor"]
        card_display <- map["card_display"]
        province_title <- map["province_title"]
        financial_status_title <- map["financial_status_title"]
        space_hash <- map["space_hash"]
        space_title <- map["space_title"]
        industry <- map["industry"]
        field <- map["field"]
        skill <- map["skill"]
    }
}

class Require: Mappable {
    
    var id = ""
    var type = ""
    var desc = ""
    var repay = [String]()
    var create_time = ""
    var title = ""
    var hash = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        type <- map["type"]
        desc <- map["description"]
        repay <- map["repay"]
        create_time  <- map["create_time"]
        hash <- map["hash"]
        title <- map["title"]
    }
    
}






