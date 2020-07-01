//  ForgotPwdVC.swift
//  LTW
//  Created by Ranjeet Raushan on 15/04/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON
import SwiftMessages
import  NVActivityIndicatorView
class ForgotPwdVC: UIViewController,UITextFieldDelegate, NVActivityIndicatorViewable {
    @IBOutlet weak var emAilTF: UITextField!
    @IBOutlet weak var reSetPaswrdBtn: UIButton!
    {
        didSet{
            reSetPaswrdBtn.layer.cornerRadius = reSetPaswrdBtn.frame.height / 12
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.navigationController?.navigationBar) != nil {
            navigationController?.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
    }
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Forgot Password"
       
        emAilTF.delegate = self
        emAilTF.useUnderline()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    //resetPaswrdBtn
    @IBAction func onReSetPwdBtnClick(_ sender: Any) {
        validiateInputFields()
    }

    private func validiateInputFields(){
        guard let email = emAilTF.text?.trim(), !email.isEmpty ,email.isValidEmail() else {
           showMessage(bodyText: "Enter Valid Email ID",theme: .warning)
            return
        }
        
        if currentReachabilityStatus != .notReachable {
            hitServer(params: [:], endPoint: Endpoints.forgotPwdEndPoint + emAilTF.text!,  action: "forgotPassword", httpMethod: .get)
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
            })
        }
    }
}

extension ForgotPwdVC {

    private func hitServer(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){ result in
            self.stopAnimating()
            switch result {
            case let .success(json,_):
            let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }
                else {
                    self.navigationController?.popViewController(animated: true)
                    showMessage(bodyText: msg ,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.01))
            }
             break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
}
