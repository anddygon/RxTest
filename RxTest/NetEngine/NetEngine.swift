//
//  SWNetEngine.swift
//  StyleWe
//
//  Created by xiaoP on 16/8/18.
//  Copyright © 2016年 Chicv. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Alamofire

/**
 
 
 - parameter router: 传入一个Router，根据配置去请求数据
 
 - returns: 返回一个元祖 分别是 一个JSON对象 和 response 以供解析
 */

func rx_request(_ string: String, method: HTTPMethod = .get,params:[String:Any]? = nil)-> Observable<(AnyObject?,HTTPURLResponse?)> {
    let url = URL(string: string)!
    let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20)
    request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 10_2_1 like Mac OS X) AppleWebKit/602.4.6 (KHTML, like Gecko) Mobile/14D27 Chuangeke.Weitianshi/2.0", forHTTPHeaderField: "User_Agent")
    request.httpMethod = method.rawValue
    let encoding = URLEncoding.queryString
    let r = try! encoding.encode(request as URLRequest, with: params)
    return rx_request(r)
}

func rx_request(_ router: URLRequestConvertible)-> Observable<(AnyObject?, HTTPURLResponse?)> {
    
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
    return Observable
        .create{ observer in
            let _request = request(router).responseJSON{ response in
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                if response.result.error != nil {
                    observer.onError(response.result.error!)
                } else {
                    observer.onNext((response.result.value as AnyObject?, response.response))
                    observer.onCompleted()
                }
                
            }
            return Disposables.create {
                _request.cancel()
            }
    }
}
