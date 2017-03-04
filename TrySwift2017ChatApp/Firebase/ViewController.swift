//
//  ViewController.swift
//  TestSlack
//
//  Created by 李慶燦 on 2017/03/04.
//  Copyright © 2017年 李慶燦. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var startBtn : UIButton!
    
    @IBAction func doStart() {
        if let _ = UserDefaults.standard.object(forKey: UDKey.UserId) as? String {
            performSegue(withIdentifier: "ToUsers", sender: nil)
        } else {
            performSegue(withIdentifier: "ToName", sender: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToName") {
            guard let next = segue.destination as? NameController else {
                return
            }
            
            next.modalPresentationStyle = .custom
        }
    }
}

