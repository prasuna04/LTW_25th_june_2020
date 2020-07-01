//  SignInVC.swift
//  LTW
//  Created by Ranjeet Raushan on 09/04/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON
import SwiftMessages
import NVActivityIndicatorView
//import QuickbloxWebRTC
//import Quickblox
class SignInVC: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var emaIlTF: UITextField!
    @IBOutlet weak var passWordTF: UITextField!
    @IBOutlet weak var forgotPaswrdBtn: UIButton!{
        didSet{
           // forgotPaswrdBtn.font = UIFont(name:"Roboto-Regular", size: 16.0)!
          forgotPaswrdBtn.titleLabel?.font =  .boldSystemFont(ofSize: 16)
        }
    }
    @IBOutlet weak var loginBtn: UIButton!
        {
        didSet{
            loginBtn.layer.cornerRadius = loginBtn.frame.height / 12
        }
    }
    @IBOutlet weak var signUpHere: UIButton!
    {
           didSet{
               signUpHere.layer.cornerRadius = signUpHere.frame.height / 12
           }
    }
    lazy var loader: UIView = {
        let loaderView = NVActivityIndicatorView(frame: .zero)
        loaderView.frame.size = CGSize(width: 60, height: 60)
        loaderView.center = CGPoint(x:UIScreen.main.bounds.midX,y:UIScreen.main.bounds.midY);
        loaderView.color = UIColor.init(hex: "2DA9EC")
        loaderView.type = .lineScale
        return loaderView
    }()
    
    var index: Int?
    var count: Int?
    
    var subjectId: Int?
    var sub_subjectId: Int?
    var gradeId: Int?
    
    var subjectType: Array<Dictionary<String, Any>>?
    var sub_SubjectList1: Array<JSON> = []
    var sub_SubjectList2: Array<JSON> = []
    var sub_SubjectList3: Array<JSON> = []
    var sub_SubjectList4: Array<JSON> = []
    
    var subjectList: Array<JSON> = []
    
    var gradeList: Array<JSON> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        /* Right Bar Button Code Starts Here */
//        let signUpRightBarButtonItem = UIBarButtonItem(title: "Sign Up", style: .done, target: self, action: #selector(onSignUpRightBarBtnClick))
//        self.navigationItem.rightBarButtonItem  = signUpRightBarButtonItem
//        /* Right Bar Button Code Ends Here */
        

        // Underline functionality in Text Field
        emaIlTF.useUnderline()
        passWordTF.useUnderline()
        emaIlTF.delegate = self
        passWordTF.delegate = self
    }
//    /* Right Bar Button  Function Code Starts Here */
//    @objc func onSignUpRightBarBtnClick(){
//        print("Sign Up Right Bar Button Clicked")
//        let sIgnUp = storyboard?.instantiateViewController(withIdentifier: "signup") as! SignUpVC
//        navigationController?.pushViewController(sIgnUp, animated: true)
//    }
//    /* Right Bar Button  Function Code Ends  Here */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.navigationController?.navigationBar) != nil {
            navigationController?.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        }
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Learn Teach World"
//        navigationItem.title = "Sign In"

    }
  

    
    @IBAction func onLoginBtnClick(_ sender: UIButton) {
        validiateInputFields()
        hideKeyBoard()
    }
    
    @IBAction func onSignUpHereClick(_ sender: UIButton) {
        hideKeyBoard()
//        navigationController?.popViewController(animated: true)

        let sIgnUp = storyboard?.instantiateViewController(withIdentifier: "signup") as! SignUpVC
        navigationController?.pushViewController(sIgnUp, animated: true)
    }
    @IBAction func onForGotPasswordClick(_ sender: UIButton) {
        let forgotpwdVC = storyboard?.instantiateViewController(withIdentifier: "forgotpwd") as! ForgotPwdVC
        navigationController?.pushViewController(forgotpwdVC, animated: true)
    }
    
    fileprivate func validiateInputFields(){
        guard let email = emaIlTF.text?.trim() else {
            showMessage(bodyText: "Enter Email ID",theme: .warning)
            return
        }
        if !email.isValidEmail() {
            showMessage(bodyText: "Enter valid Email ID",theme: .warning)
            return
        }
        guard let pwd = passWordTF.text, !pwd.trimmingCharacters(in: .whitespaces).isEmpty else {
            showMessage(bodyText: "Enter Password",theme: .warning)
            return
        }
        
        let params:[String:Any] = ["EmailID":email,"Password": getEncryptedString(planeString: pwd)
,"Devicetoken": "iPhone"]
        callService(params: params)
    }
    
    private func callService(params: [String: Any]){
        if currentReachabilityStatus != .notReachable {
            self.hitServer(params:params ,action: "signIn" )
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
                self.callService(params: params)
            })
        }
    }
    
    private func hitServer(params: [String:Any],action: String) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: Endpoints.signIn, using: .post, dueToAction: action){ result in
            self.stopAnimating()
            switch result {
            case let .success(json,requestType):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }else {
                    /* Don't remove below commented showMessage line */
                    //showMessage(bodyText: msg,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 1)) /* Don't remove this line might future manju will tell to show this message , time being as per Manju i am removing this message */
                    self.parseValueAndStore(json: json["ControlsData"], requestType: requestType)
                    
                    /* push notification setup starts - /* comment these lines while load in simulator but for device uncomment it */ */
                    let hub = SBNotificationHub(connectionString:Constants.HUBLISTENACCESS, notificationHubPath:Constants.HUBNAME)
                    let set: Set<String> = [UserDefaults.standard.string(forKey: "userID")!, self.emaIlTF.text!]
                    
//                    do {
//                                          
//                                      try hub?.unregisterAll(withDeviceToken: (UserDefaults.standard.object(forKey: "deviceTokenSBN") as? Data))
//                                            print("deviceTokenSBN registered")
//
//                                        }
//                                        catch {
//                                            let fetchError = error as Error
//                                            print(fetchError)
//                                        }
//                    
                    do {
                   try hub?.registerNative(withDeviceToken: (UserDefaults.standard.object(forKey: "deviceTokenSBN") as! Data), tags: set) /* Comment in case of Simulator */

//                        try hub?.registerNative(withDeviceToken: (UserDefaults.standard.object(forKey: "deviceTokenSBN") as? Data), tags: set) /* Comment in case of Device */
                    }
                    catch {
                        let fetchError = error as Error
                        print(fetchError)
                    }
                    /* push notification setup ends - /* comment these lines while load in simulator but for device uncomment it */ */
                  //  if (json["ControlsData"]["tutorInfo"].dictionary == nil && json["lsv_userdetails"]["PersonType"].intValue == 3)/* Commented  on 1st February 2020 By Prasuna */
                    if (json["ControlsData"]["tutorInfo"].dictionary == nil && json["ControlsData"]["lsv_userdetails"]["PersonType"].intValue == 3)/* Written on 4th February 2020 By Prasuna */
                    {
                    UserDefaults.standard.set(true, forKey: "Tutor")
                    UserDefaults.standard.synchronize()
                    let tutorSignUpVC = self.storyboard?.instantiateViewController(withIdentifier: "TutorSignUpVC") as! TutorSignUpVC
                    self.navigationController?.pushViewController(tutorSignUpVC, animated: true)
                    }else{
                    UIApplication.shared.keyWindow!.rootViewController!.dismiss(animated: true, completion: nil)
                    UIApplication.shared.keyWindow?.rootViewController = VSCore().launchHomePage(index: 0)
                    }
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    
    private  func parseValueAndStore(json: JSON,requestType: String) {
//        let newUser = QBUUser()
//        newUser.email = self.emaIlTF.text!
////        newUser.fullName = json["lsv_userdetails"]["FirstName"].stringValue
//       newUser.fullName =  json["lsv_userdetails"]["FirstName"].stringValue + " " + json["lsv_userdetails"]["LastName"].stringValue
//        newUser.tags = ["LTW"]
//        newUser.password = LoginConstant.defaultPassword
//        QBRequest.signUp(newUser, successBlock: { response, user in
//
//            print("responseyguygy :\(response)")
//
//            self.login(fullName: json["lsv_userdetails"]["FirstName"].stringValue + " " + json["lsv_userdetails"]["LastName"].stringValue, emailId: self.emaIlTF.text!, ClassId:0 )
//
//            UserDefaults.standard.set("\(user.id)", forKey: "QuickBlockID")
//            UserDefaults.standard.synchronize()
//
//        }, errorBlock: { [weak self] response in
//
//            print("response :\(response)")
//            if response.status == QBResponseStatusCode.validationFailed {
//                // The user with existent login was created earlier
//                self!.login(fullName: json["lsv_userdetails"]["FirstName"].stringValue + " " + json["lsv_userdetails"]["LastName"].stringValue, emailId: self!.emaIlTF.text!, ClassId:0 )
//
//                return
//            }
//            self?.handleError(response.error?.error, domain: ErrorDomain.signUp)
//        })
        UserDefaults.standard.set(json["lsv_userdetails"]["UserID"].stringValue, forKey: "userID")
        UserDefaults.standard.set(json["lsv_userdetails"]["FirstName"].stringValue, forKey: "fname")
        UserDefaults.standard.set(json["lsv_userdetails"]["LastName"].stringValue, forKey: "lname")
        UserDefaults.standard.set("\(json["lsv_userdetails"]["FirstName"].stringValue)" + " \(json["lsv_userdetails"]["LastName"].stringValue)",forKey: "name")
        UserDefaults.standard.set(self.emaIlTF.text!, forKey: "emailId")
        UserDefaults.standard.set(json["lsv_userdetails"]["Password"].stringValue, forKey: "password")
        UserDefaults.standard.set(json["lsv_userdetails"]["CreateDate"].stringValue, forKey: "creatDate")
        UserDefaults.standard.set(json["lsv_userdetails"]["ProfileURL"].stringValue, forKey: "profileURL")
        UserDefaults.standard.set(json["lsv_userdetails"]["DeviceToken"].stringValue, forKey: "deviceToken")
        UserDefaults.standard.set(json["lsv_userdetails"]["IsFacebook"].boolValue, forKey: "isFacbok")
        UserDefaults.standard.set(json["lsv_userdetails"]["IsGoogle"].boolValue, forKey: "isGogle")
        UserDefaults.standard.set(json["lsv_userdetails"]["Active"].boolValue, forKey: "active")
        UserDefaults.standard.set(json["lsv_userdetails"]["PersonType"].intValue, forKey: "persontyp")
        UserDefaults.standard.set(json["lsv_userdetails"]["LinkedinUrl"].stringValue, forKey: "linkedinUrl")
        UserDefaults.standard.set(json["lsv_userdetails"]["Description"].stringValue, forKey: "description")
        UserDefaults.standard.set(json["lsv_userdetails"]["Schools"].stringValue, forKey: "school")
        UserDefaults.standard.set(json["lsv_userdetails"]["Timezone"].stringValue, forKey: "timezone")
        UserDefaults.standard.set(json["lsv_userdetails"]["Points"].intValue, forKey: "points")
        UserDefaults.standard.set(json["lsv_userdetails"]["City"].stringValue, forKey: "city")
        UserDefaults.standard.set(json["lsv_userdetails"]["State"].stringValue, forKey: "state")
        UserDefaults.standard.set(json["lsv_userdetails"]["Country"].stringValue, forKey: "country")
        UserDefaults.standard.set(json["lsv_userdetails"]["ZipCode"].stringValue, forKey: "zipcode")
        UserDefaults.standard.set(json["lsv_userdetails"]["Grade"].arrayObject, forKey: "grades")
        
        UserDefaults.standard.set(json["lsv_userdetails"]["AccountID"].stringValue, forKey: "AccountID")
        UserDefaults.standard.set(json["lsv_userdetails"]["WorkExperience"].stringValue, forKey: "workExp")
        UserDefaults.standard.set(json["lsv_userdetails"]["Education"].stringValue, forKey: "curentEductn")
        UserDefaults.standard.set(json["lsv_userdetails"]["Teaching"].stringValue, forKey: "teaching")
        UserDefaults.standard.set("", forKey: "CustomerID")

        var sub_SubjectArray1: [String] = []
        var sub_SubjectArray2: [String] = []
        var sub_SubjectArray3: [String] = []
        var sub_SubjectArray4: [String] = []
        
        // Select Sub Subject Category
        for subSubject in json["SubSubjectList"].arrayValue {
            let subjectId =  subSubject["SubjectID"].intValue
            
            switch subjectId {
            case 1:
                // initialize array 1
                sub_SubjectArray1.append(subSubject["SubjectName"].stringValue)
                break
            case 2:
                // initialize array 2
                sub_SubjectArray2.append(subSubject["SubjectName"].stringValue)
                break
            case 3:
                // initialize array 3
                sub_SubjectArray3.append(subSubject["SubjectName"].stringValue)
                break
            case 4:
                // initialize array 4
                sub_SubjectArray4.append(subSubject["SubjectName"].stringValue)
                break
            default:
                break
            }
        }
        
        // Select Subject Category
        subjectList = json["SubjectList"].arrayValue
        var subjectArray: [String] = []
        for subject in subjectList{
            subjectArray.append(subject["SubjectName"].stringValue)
        }
        
        //Select Grade Category
        gradeList = json["lsv_GradeList"].arrayValue
        var gradesArray: [String] = []
        for grades in gradeList{
            gradesArray.append(grades["Grades"].stringValue)
        }
        
        // store subSubject in userdefault
        UserDefaults.standard.set(sub_SubjectArray1, forKey: "sub_SubjectArray1")
        UserDefaults.standard.set(sub_SubjectArray2, forKey: "sub_SubjectArray2")
        UserDefaults.standard.set(sub_SubjectArray3, forKey: "sub_SubjectArray3")
        UserDefaults.standard.set(sub_SubjectArray4, forKey: "sub_SubjectArray4")
        // added by mukesh
        UserDefaults.standard.set(json["SubSubjectList"].rawString(), forKey: "subSubjectList")
        UserDefaults.standard.set(json["lsv_GradeList"].rawString(), forKey: "gradeList")
        //store subject in userdefault
        UserDefaults.standard.set(subjectArray, forKey: "subjectArray")
        
        //store grades in userdefault
        UserDefaults.standard.set(gradesArray, forKey: "gradesArray")
        
        UserDefaults.standard.synchronize()
    }
    
//    private func handleError(_ error: Error?, domain: ErrorDomain) {
//        guard let error = error else {
//            return
//        }
//        //           let infoText = error.localizedDescription
//
////        showMessage(bodyText: error.localizedDescription ,theme: .error)
//
//
//        if error._code == NSURLErrorNotConnectedToInternet {
//        }
//    }
    
    
//    private func login(fullName: String, emailId: String, password: String = LoginConstant.defaultPassword , ClassId:Int) {
//
//        QBRequest.logIn(withUserEmail:emailId ,
//                        password: password,
//                        successBlock: { [weak self] response, user in
//
//                            user.fullName = fullName
//                            user.password = password
//                            user.updatedAt = Date()
//                            Profile.synchronize(user)
//                            UserDefaults.standard.set("\(user.id)", forKey: "QuickBlockID")
//                            UserDefaults.standard.synchronize()
//
//
//                            let quickIdUrl = Endpoints.updateQuickID + UserDefaults.standard.string(forKey: "userID")! + "/" + "\(user.id)"
//                            LTWClient.shared.hitService(withBodyData: [:], toEndPoint: quickIdUrl, using: .get, dueToAction: "QuickBloxId"){ result in
//                                switch result {
//                                case let .success(json,requestType):
//
//                                    let msg = json["message"].stringValue
//                                    if json["error"].intValue == 1 {
////                                        showMessage(bodyText: msg,theme: .error)
//                                    }else
//                                    {
//
//                                    }
//                                    break
//                                case .failure(let error):
//                                    print("MyError = \(error)")
//                                    break
//                                }
//                            }
//
//                            //for pushNotifications
//
//
//                            guard let deviceIdentifier = UIDevice.current.identifierForVendor?.uuidString else {
//                                return
//                            }
//
//                            if UserDefaults.standard.object(forKey: "deviceTokenSBN") != nil
//                            {
////                                let subscription = QBMSubscription()
////                                subscription.notificationChannel = .APNS
////                                subscription.deviceUDID = deviceIdentifier
////                                subscription.deviceToken = (UserDefaults.standard.object(forKey: "deviceTokenSBN") as! Data)
////
////                                QBRequest.createSubscription(subscription, successBlock: { response, objects in
////                                    debugPrint("[UsersViewController] Create Subscription request - Success")
////                                }, errorBlock: { response in
////                                    debugPrint("[UsersViewController] Create Subscription request - Error")
////                                })
//                                if QBChat.instance.isConnected == false {
//
//                                    QBRTCClient.instance().add((UIApplication.shared.delegate as! AppDelegate))
//                                    (UIApplication.shared.delegate as! AppDelegate).connectToChat()
//                                }
//                            }
//
//                            if user.fullName != fullName {
//                                self?.updateFullName(fullName: fullName, login: emailId)
//                            } else {
//
//                                self?.connectToChat(user: user)
//
//                            }
//
//            }, errorBlock: { [weak self] response in
//                self?.handleError(response.error?.error, domain: ErrorDomain.logIn)
//                if response.status == QBResponseStatusCode.unAuthorized {
//                    // Clean profile
//                    Profile.clearProfile()
//                }
//        })
//    }
    
    
    /*
     Update User Full Name
     */
//    private func updateFullName(fullName: String, login: String) {
//        let updateUserParameter = QBUpdateUserParameters()
//        updateUserParameter.fullName = fullName
//        QBRequest.updateCurrentUser(updateUserParameter, successBlock: {  [weak self] response, user in
//
//            user.updatedAt = Date()
//
//            Profile.update(user)
//            self?.connectToChat(user: user)
//
//            }, errorBlock: { [weak self] response in
//                self?.handleError(response.error?.error, domain: ErrorDomain.signUp)
//        })
//    }
    
    
//    private func connectToChat(user: QBUUser) {
//
//        QBChat.instance.connect(withUserID: user.id,
//                                password: LoginConstant.defaultPassword,
//                                completion: { [weak self] error in
//                                    if let error = error {
//                                        if error._code == QBResponseStatusCode.unAuthorized.rawValue {
//                                            // Clean profile
//                                            Profile.clearProfile()
//                                        } else {
//                                            self?.handleError(error, domain: ErrorDomain.logIn)
//                                        }
//                                    } else {
//
//
//                                    }
//        })
//    }
    
    fileprivate func hideKeyBoard(){
        emaIlTF.resignFirstResponder()
        passWordTF.resignFirstResponder()
       }
}
