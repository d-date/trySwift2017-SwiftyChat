//
//  ViewController.swift
//  trySwift2017-SwiftyChat
//
//  Created by 廣瀬雄大 on 2017/03/04.
//  Copyright © 2017年 廣瀬雄大. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Request(url: "http://echo.jsontest.com/key/value/one/two")
            .request { result in
                switch result {
                case .success(let value):
                    print(value)
                case .failure(let error):
                    print(error)
                }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

