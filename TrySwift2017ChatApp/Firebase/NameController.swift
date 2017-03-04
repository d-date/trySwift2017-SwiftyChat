//
//  NameController.swift
//  TestSlack
//
//  Created by 李慶燦 on 2017/03/04.
//  Copyright © 2017年 李慶燦. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase

class NameController: UIViewController {
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBAction func doSend() {
        // store.
        doStoreAndSend()
        performSegue(withIdentifier: "ToUsers", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTf.rx.text.asObservable().map{$0?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != ""}.bindTo(sendBtn.rx.isEnabled).addDisposableTo(disposeBag)
        
        setEndEditing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setEndEditing() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NameController.doEnd(_:)))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func doEnd(_ sender: UITapGestureRecognizer?) {
        self.view.endEditing(true)
    }
    
    private func doStoreAndSend() {
        guard let userName = nameTf.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) else {return}
        
        let userId = NSUUID().uuidString
        UserDefaults.standard.set(userId, forKey: "userid")
        UserDefaults.standard.set(userName, forKey: "username")
        UserDefaults.standard.synchronize()
        
        // add to firebase.
        var userDic = [String : Any]()
        userDic["username"] = userName
        userDic["avatarurl"] = ""
        let key = userId
        
        var resultDic = [String : Any]()
        resultDic[key] = userDic
        
        let ref = FIRDatabase.database().reference()
        ref.child("users").updateChildValues(resultDic)
    }
}
