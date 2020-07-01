//
//  StripeAccountVC.swift
//  BidToBring
//
//  Created by vaayoo on 7/9/18.
//  Copyright © 2018 vaayoo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import WindowsAzureMessaging
//import WindowsAzureMobileServices
import CountryPickerView
import NVActivityIndicatorView

//enum TravelModes: Int {
//    case driving
//    case walking
//    case bicycling
//    case transit
//}


class StripeAccountVC: UIViewController , UITabBarDelegate, UITabBarControllerDelegate,UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,CountryPickerViewDelegate,UIScrollViewDelegate, NVActivityIndicatorViewable{
    
    @IBOutlet weak var SSNhide_Constraint: NSLayoutConstraint!
    @IBOutlet weak var routinghide_Constraint: NSLayoutConstraint!
    @IBOutlet weak var personIdhide_Constraint: NSLayoutConstraint!

    @IBOutlet weak var scrollVW: UIScrollView!
    @IBOutlet weak var lbl_infoConstraint: NSLayoutConstraint!
    @IBOutlet weak var subview: UIView!

    @IBOutlet weak var accountNo_txtF: UITextField!
    @IBOutlet weak var bankNm_txtF: UITextField!
    @IBOutlet weak var bankInfo_txtF: UITextField!
    @IBOutlet weak var countryCodeTxtF: UITextField!
    @IBOutlet weak var lastTxtF: UITextField!
    @IBOutlet weak var firstTxtF: UITextField!
    @IBOutlet weak var phonenoTxtF: UITextField!
    @IBOutlet weak var dateofBirth_txtF: UITextField!
    @IBOutlet weak var SSN_txtF: UITextField!
    @IBOutlet weak var address_txtF: UITextField!
    @IBOutlet weak var state_txtF: UITextField!
    @IBOutlet weak var city_txtF: UITextField!
    @IBOutlet weak var zipcode_txtF: UITextField!
    @IBOutlet weak var personalId_txtF: UITextField!
    @IBOutlet weak var identity_txtF: UITextField!
    @IBOutlet weak var identityback_txtF: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var back_btn: UIButton!
    
    var idnt_txtfObj: UITextField!
    var signUpObject: [String: Any]!
    var datePicker = UIDatePicker()
    var toolBar = UIToolbar()
    var cpv:CountryPickerView!
    var imgDataArr = Array<Any>()
    var imgfileNameArr = [String]()
    var count = 0
    var account = ""
    var imagePicker = ImagePicker()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //images allignment for buttons
        self.title = "Create Account"
        firstTxtF.setBottomBorder()
        lastTxtF.setBottomBorder()
        countryCodeTxtF.setBottomBorder()
        phonenoTxtF.setBottomBorder()
        dateofBirth_txtF.setBottomBorder()
        SSN_txtF.setBottomBorder()
        address_txtF.setBottomBorder()
        state_txtF.setBottomBorder()
        city_txtF.setBottomBorder()
        zipcode_txtF.setBottomBorder()
        identity_txtF.setBottomBorder()
        identityback_txtF.setBottomBorder()
        accountNo_txtF.setBottomBorder()
        bankNm_txtF.setBottomBorder()
        bankInfo_txtF.setBottomBorder()
        personalId_txtF.setBottomBorder()
        accountNo_txtF.addDoneButtonToKeyboard(myActionDone:  #selector(self.accountNo_txtF.resignFirstResponder), myActionCancel: #selector(self.accountNo_txtF.resignFirstResponder))
        submitBtn.layer.cornerRadius = 5
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        showDatePicker()
        identity_txtF.tag = 1
        identityback_txtF.tag = 2
        scrollVW.delegate = self
        
        // this is for adding countryCodeView to textfield
        cpv = CountryPickerView(frame: CGRect(x: 0, y: 0, width: countryCodeTxtF.frame.size.width, height: countryCodeTxtF.frame.size.height))
        cpv.delegate  = self
//        cpv.setCountryByPhoneCode("+\(UserDefaults.standard.object(forKey: "CountryCode") as! String)")
        countryCodeTxtF.leftView = cpv
        countryCodeTxtF.leftViewMode = .always
        firstTxtF.text = UserDefaults.standard.object(forKey: "fname") as? String
        lastTxtF.text = UserDefaults.standard.object(forKey: "lname") as? String
//        phonenoTxtF.text = UserDefaults.standard.object(forKey: "PhoneNumber") as? String
//        accountNo_txtF.text = UserDefaults.standard.object(forKey: "AccountNumber") as? String
//        bankNm_txtF.text = UserDefaults.standard.object(forKey: "BankName") as? String
//        bankInfo_txtF.text = UserDefaults.standard.object(forKey: "BankRoutingInfo") as? String
//        dateofBirth_txtF.text = UserDefaults.standard.object(forKey: "dateOfBirth") as? String
//        SSN_txtF.text = UserDefaults.standard.object(forKey: "ssn") as? String
//        address_txtF.text = UserDefaults.standard.object(forKey: "address") as? String
//        city_txtF.text = UserDefaults.standard.object(forKey: "city") as? String
//        state_txtF.text = UserDefaults.standard.object(forKey: "state") as? String
//        zipcode_txtF.text = UserDefaults.standard.object(forKey: "zipcode") as? String
//        identity_txtF.text = UserDefaults.standard.object(forKey: "IdentityDocument") as? String //15/11/18
//        identityback_txtF.text = UserDefaults.standard.object(forKey: "IdentityDocumentBack") as? String
        imgfileNameArr.insert("", at: 0)//13/11/18
        imgfileNameArr.insert("", at: 1)
        imgDataArr.insert("", at: 0)
        imgDataArr.insert("", at: 1)
        if !(identity_txtF.text?.isEmpty)!
        {
            identity_txtF.placeholder = identity_txtF.text
            identity_txtF.text = ""
            identity_txtF.isUserInteractionEnabled = false
        }
        if !(identityback_txtF.text?.isEmpty)!
        {
            identityback_txtF.placeholder = identityback_txtF.text
            identityback_txtF.text = ""
            identityback_txtF.isUserInteractionEnabled = false
        }
        
            

        
         account = UserDefaults.standard.object(forKey: "AccountNumber") as? String ?? ""
        if account != ""
        {
//            back_btn.isHidden = false
//            SSN_txtF.isEnabled = false
//            SSN_txtF.textColor = UIColor.lightGray
//            SSN_txtF.text = UserDefaults.standard.object(forKey: "ssn") as? String
//            SSN_txtF.placeholder = UserDefaults.standard.object(forKey: "ssn") as? String
        }
//        else{
//
//            back_btn.isHidden = true
//
//        }
//       subview.dropShadow()//10/12/18
       self.whichFieldsToShow(code: cpv.selectedCountry.code)
        
        
        
        

    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        scrollVW.setContentOffset(CGPoint.zero, animated: true)
//
//    }
    
   @objc func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
//        scrollVW.endEditing(true)
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:UItextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
//        let scrollPoint = CGPoint(x: 0, y: textField.frame.origin.y)
//        scrollVW.setContentOffset(scrollPoint, animated: true)
        if textField == dateofBirth_txtF
            {
                
                // add toolbar to textField
                textField.inputAccessoryView = toolBar
                // add datepicker to textField
                textField.inputView = datePicker
        }
        if textField == identity_txtF || textField == identityback_txtF
        {
            idnt_txtfObj = textField
            textField.resignFirstResponder()
            self.view.endEditing(true)
            addTapGestureToView(view: textField)
        }

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
//        scrollVW.setContentOffset(CGPoint.zero, animated: true)
    }
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        
        self.whichFieldsToShow(code: country.code)
        
        
        
    }
    
    
    func whichFieldsToShow(code:String){
        
        if code == "US"
        {
            routinghide_Constraint.constant = 55
            SSNhide_Constraint.constant = 55
            personIdhide_Constraint.constant = 10
            SSN_txtF.isHidden = false
            bankInfo_txtF.isHidden = false
            personalId_txtF.isHidden = true
            accountNo_txtF.placeholder = "IBAN Number:"
            bankInfo_txtF.placeholder = "Bank Routing Info:"
            
            identityback_txtF.placeholder = "Identity Document Back (optional):"
            identity_txtF.placeholder = "Identity Document:"
                
            
            

        }else{
            personIdhide_Constraint.constant = 55
            routinghide_Constraint.constant = 55
            SSNhide_Constraint.constant = 10
            accountNo_txtF.placeholder = "Account Number:"
            SSN_txtF.isHidden = true
            bankInfo_txtF.isHidden = false
            personalId_txtF.isHidden = false
            bankInfo_txtF.placeholder = "IFSC Code:"
            identityback_txtF.placeholder = "Aadhar/Voterid/PAN card (optional):"
            identity_txtF.placeholder = "Aadhar/Voterid/PAN card:"

        }
    }
    
    
    @IBAction func InfoBtnClocked(_ sender: UIButton) {
    
        let v = Bundle.main.loadNibNamed("InfoViewController", owner: self, options: nil)! [0] as! InfoViewController
        let size = UIScreen.main.bounds.size
        v.btnClose.addTarget(self, action: #selector(btn_close), for: .touchUpInside)
        v.layer.cornerRadius = 10
         var str =  ""
        let url = URL(string: "https://stripe.com/docs/connect/identity-verification-api#acceptable-id-types")!

        if sender.tag == 1
        {
            // str = "Requirements for ID verification\n\n \u{2022} Acceptable documents vary by country, although a passport scan is always acceptable and preferred.\n \u{2022} Scans of both the front and back are usually required for government-issued IDs and driver’s licenses.\n \u{2022} Files need to be JPEGs or PNGs smaller than 5MB. We can’t verify PDFs.\n \u{2022} Files should be in color, be rotated with the image right-side up, and have all information clearly legible"
            // let range = (str as NSString).range(of: "Requirements for ID verification")
            // let range1 = (str as NSString).range(of: "vary by country")
            // let range2 = (str as NSString).range(of: "usually required")
            
            str = "Requirements for ID verification\n\n \u{2022} Acceptable documents vary by country, although a passport scan is always acceptable and preferred.\n \u{2022} Scans of both the front and back are usually required for government-issued IDs and driver’s licenses.\n \u{2022} Files need to be JPEGs or PNGs smaller than 5MB. We can’t verify PDFs.\n \u{2022} Files should be in color, be rotated with the image right-side up, and have all information clearly legible"
            str = (str as NSString).replacingOccurrences(of: "u{2022}", with: "\u{2022}")
            let range = (str as NSString).range(of: "Requirements for ID verification")
            let range1 = (str as NSString).range(of: "vary by country")
            let range2 = (str as NSString).range(of: "usually required")
            
            let range3 = (str as NSString).range(of:String(str.suffix(str.count - range.length)))
            
            let attributedString = NSMutableAttributedString(string:str)
            attributedString.setAttributes([.font : UIFont.boldSystemFont(ofSize: 15.0)], range: range)
            attributedString.setAttributes([.font : UIFont.systemFont(ofSize: 15)], range: range3)
            // attributedString.setAttributes([.font : UIFont.systemFont(ofSize: 15)], range: (str as NSString).range(of: "\u{2022} Acceptable documents vary by country, although a passport scan is always acceptable and preferred.\n \u{2022} Scans of both the front and back are usually required for government-issued IDs and driver’s licenses.\n \u{2022} Files need to be JPEGs or PNGs smaller than 5MB. We can’t verify PDFs.\n \u{2022} Files should be in color, be rotated with the image right-side up, and have all information clearly legible"))
            attributedString.setAttributes([.link: url,NSAttributedString.Key.foregroundColor :UIColor.blue,.font : UIFont.systemFont(ofSize: 15)], range: range1)
            attributedString.setAttributes([.link: url,NSAttributedString.Key.foregroundColor :UIColor.blue,.font : UIFont.systemFont(ofSize: 15)], range: range2)
            v.textVw.attributedText = attributedString
            
            
        }else{
            //Baksiden av førekort skal være med
            //Leselighetskrav av innlastet dokument
            // str = "The document back is usually required for government-issued IDs and driver's licenses.\nView requirements by country and photo ID type →"
            str = "The document back is usually required for government-issued IDs and driver's licenses.\nView requirements by country and photo ID type →"
            let str_range = "View requirements by country and photo ID type →"
            let range = (str as NSString).range(of: str_range)
            let attributedString = NSMutableAttributedString(string:str)
            attributedString.setAttributes([.font : UIFont.systemFont(ofSize: 15)], range: (str as NSString).range(of:String(str.prefix(str.count - range.length))))
            attributedString.setAttributes([.link: url,NSAttributedString.Key.foregroundColor :UIColor.blue,.font : UIFont.systemFont(ofSize: 15)], range: range)
            v.textVw.attributedText = attributedString
            
        }
        
//        v.frame = CGRect.init(x: 10, y: self.view.center.x, width: size.width-20, height: str.heightWithConstrainedWidth(width: size.width, font: UIFont.systemFont(ofSize: 12)))
        v.frame.size = CGSize.init(width: size.width-20, height: str.heightWithConstrainedWidth(width: size.width, font: UIFont.systemFont(ofSize: 17)))
        v.center = self.view.center
        v.textVw.dataDetectorTypes = .link
        v.textVw.isUserInteractionEnabled = true
        v.textVw.isEditable = false
       
        let bgView = UIView.init(frame: UIScreen.main.bounds)
        bgView.tag = 10
        bgView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        bgView.addSubview(v)
        self.view.addSubview(bgView)
//        self.view.bringSubview(toFront:bgView )

    }
    @objc func btn_close()
    {
        
        self.view.viewWithTag(10)?.removeFromSuperview()
        
    }
    
    @objc func addTapGestureToView(view:UITextField)

    {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(launchImagePickerController(gets:)))
        //let tapGesture = UITapGestureRecognizer.init()
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)

    }
    
    
    
    @objc func launchImagePickerController(gets:UITapGestureRecognizer)
    {
        if gets.view?.tag == 1 {
            
            idnt_txtfObj = identity_txtF

        }else
        {
            idnt_txtfObj = identityback_txtF

        }
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .savedPhotosAlbum
        self.present(imagePickerController, animated: true, completion: nil)
        
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let chosenImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
               let imageFolder = imagePicker.getImagesFolder()
               let imageFileName = imagePicker.getUniqueFileName()
        
//        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//        let imageFolder = VSCore().getImagesFolder()
//        let imageFileName = VSCore().getUniqueFileName()
        let finalPath = URL.init(fileURLWithPath: "\(String(describing: imageFolder))/\(String(describing: imageFileName))")
        do
        {
            try chosenImage.jpegData(compressionQuality: 1.0)?.write(to: finalPath, options: .atomic)
//            str_imageUrl = "\(String(describing: imageFolder))/\(String(describing: imageFileName))"
            idnt_txtfObj.text = imageFileName

            
            let imageData = chosenImage.jpegData(compressionQuality: 1.0)
            if idnt_txtfObj == identity_txtF
            {
                imgDataArr[0] = imageData as Any
                
            }else if idnt_txtfObj == identityback_txtF
            {
                // imgDataArr.insert(imageData as Any, at: 1)
                imgDataArr[1] = imageData as Any
                
                
            }
            
        }
        catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Show Date Picker
    func showDatePicker(){
        
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -80, to: Date())
        
        //ToolBar
        toolBar.sizeToFit()
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title:"Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        
        toolBar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
    }
    
    @objc func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        dateofBirth_txtF.text! = formatter.string(from:datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK:StripeAccountVC Class Functions
    
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func logInBtnClicked(_ sender: UIButton) {
        
        let story = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.present(story, animated: true, completion: nil)
    }
    

    func getIP()-> String? {
        var address : String?

        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }

        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee

            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" || name == "pdp_ip0" {

                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)

        return address
    }
    
    
    
    @IBAction func submitBtnClicked(_ sender: Any) {

                guard let firstName = firstTxtF.text, firstName != "" else {
                    showMessage(bodyText: "Please enter firstName",theme: .warning)
                    
                    return
                }
            guard let lastName = lastTxtF.text, lastName != "" else {
                
                showMessage(bodyText: "Please enter lastName",theme: .warning)

                
                return
            }
            guard let phone = phonenoTxtF.text, phone != "" else {
                
               showMessage(bodyText: "Please enter phone Number",theme: .warning)

                return
            }
            if(cpv.selectedCountry.code == "US")
            {
                guard let accountNum = accountNo_txtF.text, accountNum != "" else {
                    
                    showMessage(bodyText: "Please enter valid account number",theme: .warning)

                    return
                }
            }else
            {
                guard let accountNum = accountNo_txtF.text, accountNum != "" else {
                    
                     showMessage(bodyText: "Please enter IBAN",theme: .warning)
                    return
                }
            }
                guard let bankNum = bankNm_txtF.text, bankNum != "" else {
                    
                showMessage(bodyText: "Please enter bank name",theme: .warning)

                    return
                }
            
            
            guard let dateof = dateofBirth_txtF.text, dateof != "" else {
                
                showMessage(bodyText: "Please enter date of birth",theme: .warning)

                return
            }
            
            if(cpv.selectedCountry.code == "US")
            {
                guard let bankInfo = bankInfo_txtF.text, bankInfo != "" else {
                    
                    showMessage(bodyText: "please enter bank info details",theme: .warning)

                    return
                }
    //        if account == ""
    //        {
                
            guard let ssn = SSN_txtF.text, ssn != "" else {

                showMessage(bodyText: "please enter SSN number",theme: .warning)

                return
            }
            //}
            }else
            {
                guard let bankInfo = bankInfo_txtF.text, bankInfo != "" else {
                    
                    showMessage(bodyText: "please enter IFSC code",theme: .warning)

                    return
                }
                guard let address = personalId_txtF.text, address != "" else {
                    
                    showMessage(bodyText: "please enter personalId",theme: .warning)

                    return
                }
            }
           
            guard let address = address_txtF.text, address != "" else {
                
                showMessage(bodyText: "please enter address",theme: .warning)

                return
            }
            guard let city = city_txtF.text, city != "" else {
                
                           showMessage(bodyText: "please enter city",theme: .warning)

                return
            }
            guard let state = state_txtF.text, state != "" else {
                
                showMessage(bodyText: "please enter state",theme: .warning)

                return
            }
            guard let zip = zipcode_txtF.text, zip != "" else {
                
                   showMessage(bodyText: "please enter zipcode",theme: .warning)

                return
            }//17/6/2020
//            guard let ident = idnt_txtfObj.text, ident == "" else {
//
//                showMessage(bodyText: "please select identity proof",theme: .warning)
//
//    //            VSCore().ShowAlert(vc: self, title: "Message", message: "please select identity proof")
//                return
//            }
    //
    //        self.requestToServer()
            let second = imgDataArr[1] as? Data ?? nil//15/11/18
            let first = imgDataArr.first as? Data ?? nil
        
        
        if first == nil 
        {
            showMessage(bodyText: "please select identity proof",theme: .warning)
            return
            
        }
        
            if first != nil || second != nil
            {
    //            ProgressHUD.show(NSLocalizedString("ALERT_UPLOADING_DOCUMENT", comment: ""))
                startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
                uploadImageToStrap(arr: imgDataArr)
                
            }else{

    //             ProgressHUD.show(NSLocalizedString("ALERT_CREATING_STRIPE_ACC", comment: ""))
                startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
                self.requestToServer()
            }
            submitBtn.isEnabled = false
            
        }

    func requestToServer() {
        
        
        //for country code
        let code = cpv.countryDetailsLabel.text!
        let countrycode = cpv.selectedCountry.code
        let countryCode = code.split(separator: "+")
        let codestr = countryCode[1]
        let finalDate =  AppConstants().currentDateInUTC()
        
        guard let ipaddress = getIP() else{
            self.stopAnimating()
            showMessage(bodyText: "Not able get IP address",theme: .warning)

            return
        }
        
        
        
        let params2 = ["TosAcceptanceDate":"\(finalDate)", "TosAcceptanceIp": ipaddress, "TosAcceptanceUserAgent":"550"] as [String : Any]
//        ProgressHUD.show("Creating stripe account")
        var params = [String : Any]() //19/11/18
//        if account == ""
//        {
//            params = ["UserID":UserDefaults.standard.object(forKey: "UserID") as! String, "EmailID":"\(UserDefaults.standard.object(forKey: "EmailID") as! String)","FirstName": firstTxtF.text!, "LastName":lastTxtF.text!,"CountryCode":String(codestr),"PhoneNumber":phonenoTxtF.text!,"AccountNumber":accountNo_txtF.text!,"BankName":bankNm_txtF.text!,"BankRoutingInfo":bankInfo_txtF.text!,"SSNLast4":SSN_txtF.text!,"DOB":dateofBirth_txtF.text!,"IdentityDocument": imgfileNameArr[0] ,"IdentityDocumentBack":imgfileNameArr[1],"LanguageCode": String(L102Language.currentAppleLanguage().split(separator: "-").first!)]
            params = ["UserID":UserDefaults.standard.object(forKey: "userID") as! String, "EmailID":"\(UserDefaults.standard.object(forKey: "emailId") as! String)","FirstName": firstTxtF.text!, "LastName":lastTxtF.text!,"CountryCode":codestr,"PhoneNumber":phonenoTxtF.text!.trim(),"AccountNumber":accountNo_txtF.text!.trim(),"BankName":bankNm_txtF.text!.trim(),"BankRoutingInfo":bankInfo_txtF.text!.trim(),"SSN":SSN_txtF.text!.trim(),"DOB":dateofBirth_txtF.text!,"StripeAccountID":"","StreetAddress1":address_txtF.text!.trim(),"State":state_txtF.text!.trim(),"PostalCode":zipcode_txtF.text!.trim(),"Country":countrycode,"City":city_txtF.text!,"idNumber":personalId_txtF.text!.trim(),"imageFront":imgfileNameArr[0],"imageBack":imgfileNameArr[1] ,"TermsOfService":params2]
            
      //  }else{
            
//            params = ["UserID":UserDefaults.standard.object(forKey: "UserID") as! String, "EmailID":"\(UserDefaults.standard.object(forKey: "EmailID") as! String)","FirstName": firstTxtF.text!, "LastName":lastTxtF.text!,"CountryCode":String(codestr),"PhoneNumber":phonenoTxtF.text!,"AccountNumber":accountNo_txtF.text!,"BankName":bankNm_txtF.text!,"BankRoutingInfo":bankInfo_txtF.text!,"SSNLast4":SSN_txtF.text!,"DOB":dateofBirth_txtF.text!,"IdentityDocument": imgfileNameArr[0] ,"IdentityDocumentBack":imgfileNameArr[1],"LanguageCode": String(L102Language.currentAppleLanguage().split(separator: "-").first!)]
            
       // }

        
//        let params1 = ["StreetAddress1":address_txtF.text!, "City": city_txtF.text!, "State":state_txtF.text!,"PostalCode":zipcode_txtF.text!,"Country":countrycode,"ActorID":UserDefaults.standard.object(forKey: "userID") as! String,"AddressID":UserDefaults.standard.object(forKey: "AddressID") as? String ?? 0,"CountryName":cpv.selectedCountry.name] as [String : Any]
//
//
//        let dict = ["DriverDetails":params , "DriverAddress": params1, "TermsOfService":params2] as [String : Any]
        print("\(params)")
        var accountURL :String!
        
        let acount = UserDefaults.standard.object(forKey: "AccountNumber") as? String ?? ""
        
        if acount == "" {
            
            // CreateStripeConnectAccount
            accountURL = Endpoints.CreateStripeConnectAccount

        }else{
            
//            accountURL = VSCore.baseUrl + "api/Payment/UpdateDriverAccountInfo"

        }
        accountURL = Endpoints.CreateStripeConnectAccount

        Alamofire.request(accountURL, method:.post, parameters: params,encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON {
            response in
            //print("Alamofire response ")
            switch response.result {
                
            case .success(_):
                self.stopAnimating()
               self.submitBtn.isEnabled = true
                                if response.result.value != nil{
                                    
                                    let json = JSON(response.result.value!)
                                    // 18/7/2020
                               if json["error"].intValue == 1 {
                                
                                    showMessage(bodyText: json["message"].stringValue,theme: .error)
                                
                                }else {
                //                    if  let value = response.result.value{

                                        print("response : \(json)")

                //                        UserDefaults.standard.set(nil, forKey: "accountform")
//                                let dict = json["ControlsData"].dictionaryValue
                                UserDefaults.standard.set(json["ControlsData"]["accountInfo"]["StripeAccountID"].stringValue, forKey: "AccountID")
//                                        UserDefaults.standard.set(json["StripeAccountID"].stringValue, forKey: "AccountID")
                                        UserDefaults.standard.set(self.firstTxtF.text!, forKey: "accountFirstName")
                                        UserDefaults.standard.set(self.lastTxtF.text!, forKey: "accountLastName")
                                        UserDefaults.standard.set(self.phonenoTxtF.text!, forKey: "accountPhoneNumber")
                                        UserDefaults.standard.set(countrycode, forKey: "accountCountryCode")
                                        UserDefaults.standard.set(self.accountNo_txtF.text!, forKey: "AccountNumber")
                                        UserDefaults.standard.set(self.bankNm_txtF.text!, forKey: "BankName")
                                        UserDefaults.standard.set(self.bankInfo_txtF.text!, forKey: "BankRoutingInfo")
                                        UserDefaults.standard.set(self.dateofBirth_txtF.text!, forKey: "dateOfBirth")
                                        UserDefaults.standard.set(self.SSN_txtF.text!, forKey: "ssn")
                                        UserDefaults.standard.set(self.address_txtF.text!, forKey: "address")
                                        UserDefaults.standard.set(self.city_txtF.text!, forKey: "city")
                                        UserDefaults.standard.set(self.state_txtF.text!, forKey: "state")
                                        UserDefaults.standard.set(self.zipcode_txtF.text!, forKey: "zipcode")
                                        UserDefaults.standard.set(self.imgfileNameArr[0], forKey: "IdentityDocument")
                                        UserDefaults.standard.set(self.imgfileNameArr[1], forKey: "IdentityDocumentBack")
                                        UserDefaults.standard.synchronize()
                                        
                                    let alertController = UIAlertController(title: "Message", message: json["message"].stringValue , preferredStyle: .alert)
                                           // let alertAction = UIAlertAction(title: "OK", style: .default)
                                           let alertAction = UIAlertAction.init(title: "Ok", style: .default, handler: { (UIAlertAction) in
                                                    UIApplication.shared.keyWindow!.rootViewController!.dismiss(animated: true, completion: {
                                               //                         ProgressHUD.dismiss()
                                                                       })
                                                                       _ = self.navigationController?.popViewController(animated: true)                                           })
                                           alertController.addAction(alertAction)
                                           self.present(alertController, animated: true)

                                    
               

                                       
                //                        UIApplication.shared.keyWindow?.rootViewController = VSCore().launchDriversHomePage(index: 0)
                //                        UIApplication.shared.keyWindow?.rootViewController =  TapBarViewController()


                //                    }
                                        
                                    }
                                }
                break

            case .failure(_):
                self.stopAnimating()
                self.submitBtn.isEnabled = true
//                ProgressHUD.dismiss()
                if let error = response.result.error {
                    if error._code == NSURLErrorTimedOut {
                        
                         showMessage(bodyText: "Low connectivity",theme: .error)
                        
                    }else if error._code == NSURLErrorNotConnectedToInternet
                    {
                        //
                showMessage(bodyText: "Please connect to the internet and try again!",theme: .error)

                    }
                }
                break

            }


        }
        

    }

//    func updateDriverLocation() {
//
//        let finalDate =  VSCore().currentDateInUTC()
//        let params = ["DriverLocationID":0, "DriverID": UserDefaults.standard.object(forKey: "UserID") as! String,  "Time": finalDate, "LocationLatitude": driverLocation.latitude, "LocationLongitude": driverLocation.longitude] as [String : Any]
//
//        Alamofire.request(driverUpdateUrl, method:.post, parameters: params,encoding: JSONEncoding.default, headers: headers).responseJSON {
//            response in
//
//            switch response.result {
//            case .success(_):
//                if response.result.value != nil{
//                    if (response.response?.statusCode)! < 300
//                    {
//                        let json = JSON(response.result.value!)
//                        print("response : \(json)")
//
//
//                    }else{
//
//
//
//                    }
//                }
//                break
//
//            case .failure(_):
//
//                if let error = response.result.error {
//                    if error._code == NSURLErrorTimedOut { // 4/2/19
//                        VSCore().ShowAlert(vc: self, title: NSLocalizedString("ALERT_MESSAGE", comment: ""), message: NSLocalizedString("ALERT_LOW_CONNECTIVITY", comment: "") )
//                    }else if error._code == NSURLErrorNotConnectedToInternet
//                    {
//                        VSCore().ShowAlert(vc: self, title: NSLocalizedString("ALERT_MESSAGE", comment: ""), message: NSLocalizedString("ALERT_CONNECTION", comment: "") )
//                    }
//                }
//                break
//            }
//        }
//    }
    
    func uploadImageToStrap(arr:Array<Any>) {
        var temp = arr
        
        for (index,elememt) in arr.enumerated() {
            
            if let data = elememt as? Data, !(data).isEmpty {
                
                let params:[String : Any] = ["purpose": "identity_document"]
                requestWith(endUrl: "https://files.stripe.com/v1/files", imageData: data as? Data, parameters: params, index: index)
                
            }else
            {
                temp.remove(at: index)
                
            }
            
        }
        count = temp.count
        
    }
    
    func requestWith(endUrl: String, imageData: Data?, parameters: [String : Any], index:Int , onCompletion: ((JSON?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        
       /*
         pk_test_M27j3Xio3JOgrk9j0S0hkfkW00TzyDgjfy
         sk_test_Fho2JJ3YvFyguZ46nuU9ILAe00TTTMmqqD

         use above keys to test with creating account and payments
         */
        
        let headers: HTTPHeaders = [
            
            "Content-type": "multipart/form-data",
            "Authorization" : publishableKeyForImg
            //"Bearer  sk_test_Fho2JJ3YvFyguZ46nuU9ILAe00TTTMmqqD",
            ]
        

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = imageData{
                multipartFormData.append(data, withName: "file", fileName: "image.png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: endUrl, method: .post, headers: headers) { (result) in
            

            switch result{
            case .success(let upload,_,_):
                    self.submitBtn.isEnabled = true
                    upload.responseJSON { response in
                    print("Succesfully uploaded")
//                    if let valuee = response.result.value{
                        if response.result.isSuccess{
                            
                        let json = JSON(response.result.value!)
                        print("Response : \(response.result.value!)")
                        print("let value = \(upload)")
                        print("json = \(json)")//file_1DVYj4JsXtBNFWK6GuEyJHyg
                        self.imgfileNameArr[index] = json["id"].stringValue
                        var temp2 = self.imgfileNameArr
                        for (index,elememt) in self.imgfileNameArr.enumerated() {
                            if let data = elememt as? String, (data).isEmpty {
                                temp2.remove(at: index)
                            }
                        }
                        if index == 0
                        {
                        UserDefaults.standard.set(json["id"].stringValue, forKey: "IdentityDocument")

                        }
                        if index == 1
                        {
                            UserDefaults.standard.set(json["id"].stringValue, forKey: "IdentityDocumentBack")

                        }
                        UserDefaults.standard.synchronize()

                        if self.count == temp2.count
                        {
//                            ProgressHUD.show("Creating stripe account")
                            self.requestToServer()
                        }
                    }
//                    }
                    else{
                       self.stopAnimating()
                showMessage(bodyText:"\((JSON(response.result.value!)["error"])["message"])",theme: .warning)

//                        print((JSON(response.result.value!)["error"])["message"])
//                        ProgressHUD.dismiss()
//                        VSCore().ShowAlert(vc: self, title: NSLocalizedString("ALERT_FAILURE", comment: ""), message: "\((JSON(response.result.value!)["error"])["message"])")
                    }
                    if let err = response.error{
                        onError?(err)
                        return
                    }
                    onCompletion?(nil)
                }
            case .failure(let error):
                self.stopAnimating()
                self.submitBtn.isEnabled = true
//                ProgressHUD.dismiss()
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
//                VSCore().ShowAlert(vc: self, title: NSLocalizedString("ALERT_FAILURE", comment: ""), message: "\(error.localizedDescription)")
            }
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
//MARK: UIButton Extention

public extension UIButton {
    
    func alignTextBelow(spacing: CGFloat = 6.0) {
        if let image = self.imageView?.image {
            let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
            let labelString = NSString(string: self.titleLabel!.text!)
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font])
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        }
    }
    
    
    func underlined(){
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
        
    }
    
    func setBottomBorder() {
        
//        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
}
//extension UITextView {
//    func hyperLink(originalText: String, hyperLink: String, urlString: String) {
//        let style = NSMutableParagraphStyle()
//        style.alignment = .center
//        let attributedOriginalText = NSMutableAttributedString(string: originalText)
//        let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
//        let fullRange = NSMakeRange(0, attributedOriginalText.length)
//        attributedOriginalText.addAttribute(NSAttributedStringKey.link, value: urlString, range: linkRange)
//        attributedOriginalText.addAttribute(NSAttributedStringKey.paragraphStyle as NSAttributedStringKey, value: style, range: fullRange)
//        attributedOriginalText.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 10), range: fullRange)
//        self.linkTextAttributes = [
//            kCTForegroundColorAttributeName: UIColor.blue,
//            kCTUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue,
//            ] as [String : Any]
//        self.attributedText = attributedOriginalText
//    }
//}

