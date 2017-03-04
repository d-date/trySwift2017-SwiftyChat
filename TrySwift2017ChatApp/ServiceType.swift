//
//  ServiceType.swift
//  TrySwift2017ChatApp
//
//  Created by 廣瀬雄大 on 2017/03/04.
//  Copyright © 2017年 田中賢治. All rights reserved.
//

import Foundation

enum ServiceType: String {
    case twitter
    case slack
    case firebase
    
    var image: UIImage? {
        switch self {
        case .twitter:
            return #imageLiteral(resourceName: "twitter-icon")
        case .slack:
            return #imageLiteral(resourceName: "slack-icon")
        case .firebase:
            return nil
        }
    }
    
    var name: String {
        return self.rawValue.uppercased()
    }
}
