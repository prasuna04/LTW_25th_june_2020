//  ChangePswrdVC.swift
//  LTW
//  Created by Ranjeet Raushan on 15/04/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import SwiftMessages
import NVActivityIndicatorView

class ChangePswrdVC: UIViewController, UITextFieldDelegate,NVActivityIndicatorViewable{
    
    @IBOutlet weak var cuRRentPassWord_TxtF: UITextField! //current password
    @IBOutlet weak var neWPassword_TxtF: UITextField!//new password
    @IBOutlet weak var conFirmPassword_TxtF: UITextField! // re - enter new password
    @IBOutlet weak var sAveBtn: UIButton!//saveBtn
        {
        didSet{
            sAveBtn.layer.cornerRadius = sAveBtn.frame.height / 12
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cuRRentPassWord_TxtF.delegate = self
        self.neWPassword_TxtF.delegate = self
        self.conFirmPassword_TxtF.delegate = self
        
        cuRRentPassWord_TxtF.useUnderline()
        neWPassword_TxtF.useUnderline()
        conFirmPassword_TxtF.useUnderline()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.navigationController?.navigationBar) != nil {
            navigationController?.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        }
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Change Password"
    }
    @IBAction func onSaVeBtnClick(_ sender: UIButton){
        validiateInputFields()
    }
    
    @IBAction func onForGotPasswordClick(_ sender: UIButton) {
        //forgotpwd
        let forgotpwdVC = storyboard?.instantiateViewController(withIdentifier: "forgotpwd") as! ForgotPwdVC
        navigationController?.pushViewController(forgotpwdVC, animated: true)
    }
    
    private func validiateInputFields(){

        guard let curentpswd = cuRRentPassWord_TxtF.text, !curentpswd.trimmingCharacters(in: .whitespaces).isEmpty else {
             showMessage(bodyText: "Please enter current password.", theme: .warning)
            return
        }
        if curentpswd.count < 6
        {
            // showMessage(bodyText: "Atleast Provide 6 charcters",theme: .warning) /* Commented By Ranjeet on 9th April 2020 */
            showMessage(bodyText: "Provide minimum 6 charecters for password",theme: .warning);  /* Updated  By Ranjeet on 9th April 2020 */            return
            
        }
            
        guard let newpswd = neWPassword_TxtF.text, !newpswd.trimmingCharacters(in: .whitespaces).isEmpty else {
            showMessage(bodyText: "Please enter new password.", theme: .warning)
            return
        }
        
        if newpswd.count < 6
        {
           //  showMessage(bodyText: "Atleast Provide 6 charcters",theme: .warning) /* Commented By Ranjeet on 9th April 2020 */
            showMessage(bodyText: "Provide minimum 6 charecters for password",theme: .warning);  /* Updated  By Ranjeet on 9th April 2020 */            return
            
        }
            
        guard let confirmpswd = conFirmPassword_TxtF.text, !confirmpswd.trimmingCharacters(in: .whitespaces).isEmpty else {
            showMessage(bodyText:"Please  confirm new password.", theme: .warning)
            return
        }
        if confirmpswd.count < 6
        {
           //  showMessage(bodyText: "Atleast Provide 6 charcters",theme: .warning) /* Commented By Ranjeet on 9th April 2020 */
            showMessage(bodyText: "Provide minimum 6 charecters for password",theme: .warning);  /* Updated  By Ranjeet on 9th April 2020 */            return
            
        }
            
         if neWPassword_TxtF.text != conFirmPassword_TxtF.text  {
            showMessage(bodyText: "password mismatched.",theme: .warning)
            return
        }
        
        if currentReachabilityStatus != .notReachable {
            let params:[String:Any] = ["CurrentPassword":getEncryptedString(planeString: cuRRentPassWord_TxtF.text!),
                                       "NewPassword": getEncryptedString(planeString: neWPassword_TxtF.text!),
                                       "emailID": UserDefaults.standard.string(forKey: "emailId")!]
            hitServer(params: params , action: "changePassword")
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
            })
        }
    }
    
    private func hitServer(params: [String:Any],action: String) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: Endpoints.changePwdEndPoint, using: .post, dueToAction: action){ result in
            self.stopAnimating()
            switch result {
            case let .success(json,_):
                
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }else {
                    showMessage(bodyText: msg ,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.01))
                    
                    
//                    let deviceToken =  UserDefaults.standard.object(forKey: "deviceTokenSBN") as! Data /* Comment in Case of Simulator */
                  let deviceToken =  UserDefaults.standard.object(forKey: "deviceTokenSBN") as? Data /* Comment in Case of Device */
                    
                    let appDomain = Bundle.main.bundleIdentifier
                    UserDefaults.standard.removePersistentDomain(forName: appDomain!)
                    UserDefaults.standard.synchronize()
                    
                    UserDefaults.standard.set(deviceToken, forKey: "deviceTokenSBN")
                    UserDefaults.standard.synchronize()
                    
                    
                    SDWebImageManager.shared().imageCache!.clearDisk()
                    SDWebImageManager.shared().imageCache!.clearMemory()
                    UIApplication.shared.keyWindow?.rootViewController = nil
                    let navi = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "landingPageNavBar") as! UINavigationController
                    UIApplication.shared.keyWindow?.rootViewController = navi
                }
                
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
}
