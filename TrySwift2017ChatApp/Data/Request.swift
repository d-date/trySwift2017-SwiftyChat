//
//  Request.swift
//  trySwift2017-SwiftyChat
//
//  Created by 廣瀬雄大 on 2017/03/04.
//  Copyright © 2017年 廣瀬雄大. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Request {
    let url: String
    
    func request(
        done: @escaping ((Alamofire.Result<JSON>) -> Void)
        ) {
        Alamofire.request(url).responseJSON { response in
            if let error = response.result.error {
                done(Result.failure(error))
                return
            }
            if let value = response.result.value {
                done(Result.success(JSON(value)))
                return
            }
            
            let error = NSError(domain: "com.chat.com", code: 1000, userInfo: nil)
            done(Result.failure(error))
        }
        
    }
}
