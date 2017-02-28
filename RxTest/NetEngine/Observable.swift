//
//  Observable.swift
//  StyleWe
//
//  Created by xiaoP on 16/8/18.
//  Copyright © 2016年 Chicv. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import RxSwift

private let mappingError = NSError(domain: "", code: -1, userInfo: [NSLocalizedFailureReasonErrorKey:"Mapping Failed"])

extension ObservableType where E == (AnyObject?, HTTPURLResponse?) {
    
    func mapObject<T: Mappable>(_ type: T.Type, keyPath: String? = nil)-> Observable<T> {
        return observeOn(SerialDispatchQueueScheduler(qos: .background))
            .flatMap{ (anyObject, response) -> Observable<T> in
                
                let waitMapObject: AnyObject?
                if let keyPath = keyPath , !keyPath.isEmpty {
                    waitMapObject = (anyObject as! NSObject).value(forKeyPath: keyPath) as AnyObject?
                } else {
                    waitMapObject = anyObject
                }
                
                if let object = Mapper<T>().map(JSONObject:waitMapObject) {
                    return Observable.just(object)
                } else {
                    return Observable.error(mappingError)
                }
            }
            .observeOn(MainScheduler.instance)
    }
    
    /**
     - parameter type:    返回的数据需要解析成的模型类型
     - parameter keyPath: 对应的JSON路径
     
     - returns: 会发送对应的Object以及对应的数量
     
     比如productIndex接口  如果参数配置return-filter=1服务器返回的是一个下面形式的JSON
     {
     list: [xxxx]
     filter: {} //filter对象
     }
     这样的接口返回的第二个Bool是list是不是还有更多数据待加载
     */
    
    func mapArray<T: Mappable>(_ type: T.Type, keyPath: String? = nil)-> Observable<[T]> {
        
        return observeOn(SerialDispatchQueueScheduler(qos: .background))
            .flatMap{ (anyObject, response) -> Observable<[T]> in
                
                let waitMapObject: AnyObject?
                if let keyPath = keyPath , !keyPath.isEmpty {
                    waitMapObject = (anyObject as! NSObject).value(forKeyPath: keyPath) as AnyObject?
                } else {
                    waitMapObject = anyObject
                }
                
                if let object = Mapper<T>().mapArray(JSONObject: waitMapObject) {
                    return Observable.just(object)
                } else {
                    return Observable.error(mappingError)
                }
            }
            .observeOn(MainScheduler.instance)
    }
    
}
