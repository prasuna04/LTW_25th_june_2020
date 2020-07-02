//  SignUpVC.swift
//  LTW
//  Created by Ranjeet Raushan on 08/04/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import PhotosUI
import Alamofire
import SwiftyJSON
import SDWebImage
import SwiftMessages
import MobileCoreServices
import NVActivityIndicatorView
//import Quickblox
//import QuickbloxWebRTC
import CountryPickerView

// Tags Creation Related
fileprivate let tagsField = WSTagsField()

class SignUpVC: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,NVActivityIndicatorViewable,CountryPickerViewDelegate, EditImgSender{
    
    @IBOutlet weak var profiLeIV: UIImageView!{
        didSet{
            profiLeIV.setRounded()
            profiLeIV.clipsToBounds = true
        }
    }
    
    
    @IBOutlet weak var fNaMeTF: UITextField!
    @IBOutlet weak var lNaMeTF: UITextField!
    @IBOutlet weak var emaIlTF: UITextField!
    //@IBOutlet weak var confIrmEmailTF: UITextField!
    @IBOutlet weak var passWordTF: UITextField!
    @IBOutlet weak var confirmPassWordTF: UITextField!
    
    /* Button Outlet related to Student , Parent and Teacher - From Here */
    @IBOutlet weak var stUdentBtn: UIButton!
    // @IBOutlet weak var paRentBtn: UIButton! /* As per the Ranjit(USA) Suggestions we are removing now , but future might same requirement will come , so don't delete it */
    @IBOutlet weak var teAcherBtn: UIButton!
    /* Button Outlet related to Student , Parent and Teacher - Till Here */
    
    // @IBOutlet weak var cityTF: UITextField!
    // @IBOutlet weak var zipCodeTF: UITextField!
    @IBOutlet weak var currentEdctn: UITextField!
    @IBOutlet weak var scholTF: UITextField!
    @IBOutlet weak var tagListView: TagListView! // For Interest
    
    //    @IBOutlet weak var tagListView1: TagListView! // For Teaching
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var counTryTF: UITextField!
    //    @IBOutlet weak var linkedInLnkTF: UITextField!
    //    @IBOutlet weak var workExp: UITextField!
    
    
    @IBOutlet weak var chkBoxwithBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
        {
        didSet{
            signUpBtn.layer.cornerRadius = signUpBtn.frame.height / 12
        }
    }
    @IBOutlet weak var scRollView: UIScrollView!
    @IBOutlet weak var conTentView: UIView!
    @IBOutlet weak var cardView: UIView!
    
    
    
    
    @IBOutlet weak var termsOfService: UIButton!{
        didSet{
            termsOfService.underlineButtonText() // underline button text
        }
    }
    
    @IBOutlet weak var privacyPolcy: UIButton!
        {
        didSet{
            privacyPolcy.underlineButtonText() // underline button text
        }
    }
    @IBOutlet weak var bottomLoginHere: UIButton!
    
    var profileImgLocalUrl: String = ""
    var imagePicker = ImagePicker()
    var personType : Int!
    //     var personType : Int = -1 /* Commented By Ranjeet on 8th April 2020 (this was the functionality for manual selection of person type , don't delete future might reuse )*/
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
    
    // Tag Related
    var arrTagList : [String] = []
    var arrTag : [Int] = []
    // var arrTag1: [Int] = []
    var selectArr :[String] = []
    //  var selectArr1: [String] = []
    var FileAzureUrl:String = ""
    private static let timeZone = "Indian Standard Time"
    private static let points = 0
    var countryPicker = CountryPickerView()
    var cpv: CountryPickerView! /*  Added By Ranjeet on 1st April 2020 */
    var countryCode = "" /*  Added By Ranjeet on 24th April 2020 */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        counTryTF.delegate = self
        countryPicker.delegate = self
        countryPicker.setCountryByCode(NSLocale.current.regionCode ?? "")
        counTryTF.text = countryPicker.selectedCountry.name
        
        countryCode = countryPicker.selectedCountry.code
        /*  Added By Ranjeet on 1st April 2020 - starts here */
        // Default Selection Of Person Type
        stUdentBtn.isSelected = true
        /*  Added By Ranjeet on 1st April 2020 - ends here */
        
        /* Right Bar Button Code Starts Here */
        /* commented by veeresh on 21st may */
//        let signInRightBarButtonItem = UIBarButtonItem(title: "Sign In", style: .done, target: self, action: #selector(onSignInRightBarBtnClick))
//        self.navigationItem.rightBarButtonItem  = signInRightBarButtonItem
        /* Right Bar Button Code Ends Here */
        
        
        // Underline functionality in Text Field
        fNaMeTF.useUnderline()
        lNaMeTF.useUnderline()
        emaIlTF.useUnderline()
        //  confIrmEmailTF.useUnderline()
        passWordTF.useUnderline()
        confirmPassWordTF.useUnderline()
        //        cityTF.useUnderline()
        //        zipCodeTF.useUnderline()
        stateTF.useUnderline()
        counTryTF.useUnderline()
        //        counTryTF.tintColor = .clear
        // linkedInLnkTF.useUnderline()
        currentEdctn.useUnderline()
        scholTF.useUnderline()
        // workExp.useUnderline()
        
        
        // Profile image related
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.tappedMe))
        profiLeIV.addGestureRecognizer(tap)
        profiLeIV.isUserInteractionEnabled = true
        
        
        
        // tag Realated
        tagListView.delegate = self
        //  tagListView1.delegate = self
        arrTagList = ["1st", "2nd", "3rd","4th", "5th","6th","7th","8th","9th", "10th","11th","12th",
                      "UnderGraduates","Graduates"]
        arrTag = Array(repeating: 0, count: arrTagList.count)
        //    arrTag1 = Array(repeating: 0 , count: arrTagList.count)
    }
    
    /* Right Bar Button  Function Code Starts Here */
//    @objc func onSignInRightBarBtnClick(){
//        print("Sign In Right Bar Button Clicked")
//        let signIn = storyboard?.instantiateViewController(withIdentifier: "signinvc") as! SignInVC
//               navigationController?.pushViewController(signIn, animated: true)
//
//        navigationController?.popViewController(animated: true)
//    }
    /* Right Bar Button  Function Code Ends  Here */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.navigationController?.navigationBar) != nil {
            navigationController?.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        }
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Sign Up"
    }
    
    
    
    /* Added By Chandra on 25th Feb 2020 - starts here */
    @IBAction func onClickTermsAndConditions(_ sender: UIButton) {
        
        /*  Commented Chandra Code By Ranjeet on 18th March 2020 - starts here */
        //        let webVc = storyboard?.instantiateViewController(withIdentifier: "HowDoesItWorksViewController") as! HowDoesItWorksViewController
        //        webVc.mytitle = "termsAndConditions"
        //        self.navigationController?.pushViewController(webVc, animated: true)
        /*  Commented Chandra Code By Ranjeet on 18th March 2020 - ends here */
        
        /*  Added By Ranjeet on 18th March 2020 - starts here */
        /*  Commented By Ranjeet on 1st April 2020 - ends here */
        //           if personType == -1{
        //               showMessage(bodyText: "Please Select Person Type First",theme: .warning)
        //               return
        //           }
        /*  Commented By Ranjeet on 1st April 2020 - ends here */
        if stUdentBtn.isSelected{
            let story = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "webpage") as! WebPageVC
            story.myTitle = "Terms Of Service For Student"
            story.pageUrl = "https://learnteachworld.com/studentterms.html"
            navigationController?.pushViewController(story, animated: true) // side move
        }
        else{
            let story = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "webpage") as! WebPageVC
            story.myTitle = "Terms Of Service For Tutor"
            story.pageUrl = "https://learnteachworld.com/tutorterms.html"
            navigationController?.pushViewController(story, animated: true) // side move
        }
        /*  Added By Ranjeet on 18th March 2020 - starts here */
        
    }
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        
        //        counTryTF.text.font = UIFont.systemFont(ofSize: 14)
        countryCode = country.code
        counTryTF.text = country.name
        
    }
    
    @IBAction func onClickPrivacyAndPolicy(_ sender: UIButton) {
        /*  Commented Chandra Code By Ranjeet on 18th March 2020 - starts here */
        //        let webVc = storyboard?.instantiateViewController(withIdentifier: "HowDoesItWorksViewController") as! HowDoesItWorksViewController
        //        webVc.mytitle = "termsAndConditions"
        //        self.navigationController?.pushViewController(webVc, animated: true)
        /*  Commented Chandra Code By Ranjeet on 18th March 2020 - ends here */
        
        /*  Added By Ranjeet on 18th March 2020 - starts here */
        
        /*  Commented  By Ranjeet on 1st April 2020 - starts here */
        //           if personType == -1{
        //               showMessage(bodyText: "Please Select Person Type First",theme: .warning)
        //               return
        //           }
        /*  Commented By Ranjeet on 1st April 2020 - ends here */
        if stUdentBtn.isSelected{
            let story = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "webpage") as! WebPageVC
            story.myTitle = "Privacy Policy For Student"
            story.pageUrl = "https://learnteachworld.com/studentterms.html"
            navigationController?.pushViewController(story, animated: true) // side move
        }
        else{
            let story = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "webpage") as! WebPageVC
            story.myTitle = "Privacy Policy For Tutor"
            story.pageUrl = "https://learnteachworld.com/tutorterms.html"
            navigationController?.pushViewController(story, animated: true) // side move
        }
        /*  Added By Ranjeet on 18th March 2020 - starts here */
    }
    
    /* Added By Chandra on 25th Feb 2020 - ends here */
    
    @IBAction func onSignUpBtnClick(_ sender: UIButton) {
        validiate()
    }
    
    @IBAction func onBottomLoginHereClick(_ sender: UIButton) {
        let signIn = storyboard?.instantiateViewController(withIdentifier: "signinvc") as! SignInVC
                navigationController?.pushViewController(signIn, animated: false)
      //  navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onChkBoxWithBtnClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func onStudentTeacherBtnsClick(_ sender: UIButton) {
        /* Don't delete below person type selection code , it's a manual selection , future might need to change this again */
        /* Commented By Ranjeet on 8th April 2020 - starts here
         if sender.tag == 1
         {
         stUdentBtn.isSelected = true
         //  paRentBtn.isSelected = false /* As per the Ranjit(USA) Suggestions we are removing now , but future might same requirement will come , so don't delete it */
         teAcherBtn.isSelected = false
         personType = 1
         }
         //        else if sender.tag == 2 {
         //            stUdentBtn.isSelected = false
         //            paRentBtn.isSelected = true
         //            teAcherBtn.isSelected = false
         //            personType = 2
         //        }
         //        else if  sender.tag == 3{
         else {
         stUdentBtn.isSelected = false
         // paRentBtn.isSelected = false /* As per the Ranjit(USA) Suggestions we are removing now , but future might same requirement will come , so don't delete it */
         teAcherBtn.isSelected = true
         personType = 3
         }
         Commented By Ranjeet on 8th April 2020 - ends here */
        /* Added By Ranjeet on 8th April 2020 - starts here (default selection of person type )- starts here */
        stUdentBtn.isSelected = false
        teAcherBtn.isSelected = false
        sender.isSelected = true
        /* Added By Ranjeet on 8th April 2020 - starts here (default selection of person type )- ends here */
    }
    
    
    @IBAction func onSeletGradesBtnOrDropDownClick(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TagListVC") as! TagListVC
        vc.delegate = self
        vc.arrTag = arrTag
        vc.tag = 0
        vc.arrTagList = arrTagList
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    //    @IBAction func onGrdsThatUCanTeachBtnOrDropDownClick(_ sender: UIButton) {
    //        let vc = storyboard?.instantiateViewController(withIdentifier: "TagListVC") as! TagListVC
    //        vc.delegate = self
    //        vc.tag = 1
    //        vc.arrTag1 = arrTag1
    //        vc.arrTagList = arrTagList
    //        vc.modalPresentationStyle = .overCurrentContext
    //        vc.modalTransitionStyle = .crossDissolve
    //        self.present(vc, animated: true, completion: nil)
    //    }
    func cameraAuthorizationCheck(){
        
    }
    // Profile Image related
    @objc func tappedMe(){
        let alert = UIAlertController(title: "Select Photo", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            //execute some code when this option is selected
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = UIImagePickerController.SourceType.camera
                picker.cameraCaptureMode = .photo
                picker.modalPresentationStyle = .fullScreen
                picker.delegate = self
                /*  Updated By Ranjeet on 27th March 2020 - starts here  */
                if #available(iOS 13.0, *) {
                    picker.navigationBar.topItem?.rightBarButtonItem?.tintColor = .label
                } else {
                    // Fallback on earlier versions
                }
                switch AVCaptureDevice.authorizationStatus(for: .video) {
                case .authorized: // The user has previously granted access to the camera.
                    self.present(picker,animated: true,completion: nil)
                    
                case .notDetermined: // The user has not yet been asked for camera access.
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        if granted {
                            self.present(picker,animated: true,completion: nil)
                        }
                    }
                    
                case .denied, .restricted: // The user has previously denied access.
                    self.moveToSettings(enterhereWhichSettingControlYouWant: "Camera")
                /*  Updated By Ranjeet on 27th March 2020 - ends here  */
                
                }
            }else{
                self.noCamera()
            }
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (action) in
            let picker = UIImagePickerController()
            picker.delegate = self
            //picker.allowsEditing = false // commented by chandra
            picker.allowsEditing = false // add by chandra 
            picker.sourceType = .savedPhotosAlbum
            
            picker.mediaTypes = [kUTTypeImage as String]
            
            picker.navigationBar.isTranslucent = false
            picker.navigationBar.barTintColor = UIColor.init(hex:"2DA9EC") // Background color
            picker.navigationBar.tintColor = .white // Cancel button ~ any UITabBarButton items
            picker.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.white
            ]
            
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) in
            //execute some code when this option is selected
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        // below 3 lines are for iPAD
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // Profile Image related
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if picker.sourceType == .savedPhotosAlbum { //added by dk on 21st may 2020.
//        // The info dictionary may contain multiple representations of the image. You can use the original.
//        //        guard let chosenImage = info[.originalImage] as? UIImage else {
//        //            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
//        //        } // commented by chandra for croping
//        // The info dictionary may contain multiple representations of the image. You can use the original.
//        guard let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
//            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
//        }
//        profiLeIV.image = chosenImage
//        let imageFolder = imagePicker.getImagesFolder()
//        let uniqueFileName = imagePicker.getUniqueFileName()
//        let finalPath = URL.init(fileURLWithPath: "\(String(describing: imageFolder))/\(String(describing: uniqueFileName))")
//        do {
//
//            try chosenImage.jpegData(compressionQuality: 1)?.write(to: finalPath, options: .atomic)
//            profileImgLocalUrl = "\(String(describing: imageFolder))/\(String(describing: uniqueFileName))"
//        }
//        catch {
//            let fetchError = error as NSError
//            print(fetchError)
//        }
//        dismiss(animated:true, completion: nil)
            // below code added by dk on 10th june.
            let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let vc = storyboard?.instantiateViewController(withIdentifier: "ImageEditForScriblingANdCropVC") as! ImageEditForScriblingANdCropVC
            vc.backgroundImgPassed = chosenImage
            vc.Delegate = self
            // vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
            picker.dismiss(animated: true, completion: nil)
        }else if picker.sourceType == .camera { //added by dk on 21st may 2020.
            let image = info[.originalImage] as! UIImage
            let vc = storyboard?.instantiateViewController(withIdentifier: "ImageEditForScriblingANdCropVC") as! ImageEditForScriblingANdCropVC
            vc.backgroundImgPassed = image
            vc.Delegate = self
            // vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
            picker.dismiss(animated: true, completion: nil)
        }
    }
    func getImg(EditedImg: UIImage) { //added by dk on 21st may 2020.
        profiLeIV.image = EditedImg
        let imageFolder = imagePicker.getImagesFolder()
        let uniqueFileName = imagePicker.getUniqueFileName()
        let finalPath = URL.init(fileURLWithPath: "\(String(describing: imageFolder))/\(String(describing: uniqueFileName))")
        do {
            
            try EditedImg.jpegData(compressionQuality: 1)?.write(to: finalPath, options: .atomic)
            profileImgLocalUrl = "\(String(describing: imageFolder))/\(String(describing: uniqueFileName))"
        }
        catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    func validiate() {
        guard let fName = fNaMeTF.text, !fName.trimmingCharacters(in: .whitespaces).isEmpty else {
            showMessage(bodyText: "Enter First Name",theme: .warning)
            return
        }
        guard let lName = lNaMeTF.text,  !lName.trimmingCharacters(in: .whitespaces).isEmpty else {
            showMessage(bodyText: "Enter Last Name",theme: .warning)
            return
        }
        guard let email = emaIlTF.text?.trim() else {
            showMessage(bodyText: "Enter Email ID",theme: .warning)
            return
        }
        
        if !email.isValidEmail() {
            showMessage(bodyText: "Enter valid Email ID",theme: .warning)
            return
        }
        
        //            guard let confirmEmail = confIrmEmailTF.text, !confirmEmail.trimmingCharacters(in: .whitespaces).isEmpty else           {
        //                showMessage(bodyText: "Please confirm your email id",theme: .warning)
        //                return
        //            }
        //
        //            if !confirmEmail.isValidEmail(){
        //                showMessage(bodyText: "Please enter valid email id for confirmation",theme: .warning)
        //                return
        //            }
        //
        //            if email.lowercased() != confirmEmail.lowercased() {
        //                showMessage(bodyText: "email mismatched.",theme: .warning)
        //                return
        //            }
        
        guard let pswd = passWordTF.text, !pswd.trimmingCharacters(in: .whitespaces).isEmpty else {
            showMessage(bodyText: "Enter Password",theme: .warning)
            return
        }
        if pswd.count < 6
        {
            //            showMessage(bodyText: "Atleast Provide 6 charcters",theme: .warning) /* Commented By Ranjeet on 9th April 2020 */
            showMessage(bodyText: "Provide minimum 6 charecters for password",theme: .warning) /* Updated  By Ranjeet on 9th April 2020 */
            return
            
        }
        
        guard let confirmPswd = confirmPassWordTF.text,  !confirmPswd.isEmpty else {
            showMessage(bodyText: "Enter confirm Password",theme: .warning)
            return
        }
        
        if confirmPswd.count < 6
        {
            // showMessage(bodyText: "Atleast Provide 6 charcters",theme: .warning) /* Commented By Ranjeet on 9th April 2020 */
            showMessage(bodyText: "Provide minimum 6 charecters for password",theme: .warning) /* Updated  By Ranjeet on 9th April 2020 */
            return
            
        }
        
        if pswd != confirmPswd {
            showMessage(bodyText: "Passwords should match",theme: .warning)
            return
        }
        /*  Commented By Ranjeet on 1st April 2020 - starts  here */
        //        if personType == -1{
        //            showMessage(bodyText: "Select person type",theme: .warning)
        //            return
        //        }
        /*  Commented By Ranjeet on 1st April 2020 - ends here */
        //            guard let city = cityTF.text, !city.trimmingCharacters(in: .whitespaces).isEmpty else {
        //                showMessage(bodyText: "Please enter your city",theme: .warning)
        //                return
        //            }
        //            guard let zipcode = zipCodeTF.text, !zipcode.trimmingCharacters(in: .whitespaces).isEmpty else {
        //                showMessage(bodyText: "Please enter your zipcode",theme: .warning)
        //                return
        //            }
        guard let curentEductn = currentEdctn.text, !curentEductn.trimmingCharacters(in: .whitespaces).isEmpty else {
            showMessage(bodyText: "Enter Current Education",theme: .warning)
            return
        }
        
        guard let school = scholTF.text, !school.trimmingCharacters(in: .whitespaces).isEmpty else {
            showMessage(bodyText: "Enter School Name",theme: .warning)
            return
        }
        guard !selectArr.isEmpty else {
            showMessage(bodyText: "Select one or more grades",theme: .warning)
            return
        }
        /* if linkedin is mandatory for teacher then uncomment this code or else comment this - starts here [Don't remove this code future might same implementation may required to implement once again ]*/
        //        if teAcherBtn.isSelected{
        //             guard let linkedInLink = linkedInLnkTF.text, !linkedInLink.trimmingCharacters(in: .whitespaces).isEmpty else {
        //                 showMessage(bodyText: "Enter your LinkedIn URL",theme: .warning)
        //                 return
        //             }
        //         }
        /* if linkedin is mandatory for teacher then uncomment this code or else comment this - starts here [ Don't remove this code future might same implementation may required to implement once again ]*/
        guard let state = stateTF.text, !state.trimmingCharacters(in: .whitespaces).isEmpty else {
            showMessage(bodyText: "Enter Name of the State",theme: .warning)
            return
        }
        /*  Commented By Ranjeet on 31st March 2020 - starts here */
        //        guard let country = counTryTF.text , !country.trimmingCharacters(in: .whitespaces).isEmpty else {
        //            showMessage(bodyText: "Select Country",theme: .warning)
        //            return
        //        }
        /*  Commented By Ranjeet on 31st March 2020 - starts here */
        
        
        //         if teAcherBtn.isSelected{
        //        guard let workexp = workExp.text, !workexp.trimmingCharacters(in: .whitespaces).isEmpty else {
        //            showMessage(bodyText: "Enter Work Experience",theme: .warning)
        //            return
        //          }
        //        }
        //        if teAcherBtn.isSelected{
        //            guard !selectArr1.isEmpty else {
        //                showMessage(bodyText: "Please select grades that you can teach",theme: .warning)
        //                return
        //            }
        //        }
        
        //        var tagString = ""
        //               for tags in selectArr1{
        //                tagString += tags + ","
        //               }
        //
        //               if !tagString.isEmpty{
        //               tagString.removeLast()
        //               }
        if chkBoxwithBtn.isSelected == false {
            showMessage(bodyText: "Please accept the Terms Of Service & Privacy Policy.",theme: .warning)
            return
        }
        
        
        if !profileImgLocalUrl.isEmpty && profileImgLocalUrl.contains("var"){
            let urlFilePath = (profileImgLocalUrl as NSString).lastPathComponent
            FileAzureUrl = "https://ltwuploadcontent.blob.core.windows.net/actualimages/\(urlFilePath)"
        }
        else {
            FileAzureUrl = profileImgLocalUrl
        }
        
        
        /* Added By Ranjeet on 8th April 2020 - starts here (default selection of person type )- starts here */
        if stUdentBtn.isSelected == true {
            personType = 1
        }
        else{
            personType = 3
        }
        /* Added By Ranjeet on 8th April 2020 - starts here (default selection of person type )- starts here */
        
        // First Category params declaration
        var params: [String:Any] =  [
            "FirstName": fName,
            "LastName": lName,
            "ProfileURL": FileAzureUrl ,
            "Devicetoken": "iPhone",
            "PersonType": personType!,
            "Description": "",
            "Education": curentEductn,
            "Schools": school,
            "Timezone": SignUpVC.timeZone,
            "Points": SignUpVC.points,
            //  "City": city,
            "State": state,
            //  "Country": country, /*  Commented By Ranjeet on 1st April 2020 */
            "Country":counTryTF.text ?? "", /*  Added By Ranjeet on 1st April 2020 */
            //   "ZipCode": zipcode,
            "Grade": selectArr,
            // "Teaching": selectArr1.joined(separator: ",")
            ] as [String : Any]
        
        // Second Category params declaration
        params["EmailID"] = emaIlTF.text!
        // params["Password"] = encrypt /* Prasuna encryption code commented By Ranjeet , don't delete (future might reuse) on 22nd Jan 2020 , I am handling same things using extension file created in Utility class , that's why i commented here */
        params["Password"] =  getEncryptedString(planeString: pswd)
        
        //        params["LinkedinUrl"] = linkedInLnkTF.text!
        //        params["WorkExperience"] = workExp.text!
        callService(params: params,endPoint: Endpoints.signUp)
    }
    // Note : In both the places , declare the parameters at only one place
    
    // Internat Check
    private func callService(params: [String: Any],endPoint:String){
        if currentReachabilityStatus != .notReachable {
            hitServer(params: params,endPoint: endPoint)
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
                self.callService(params: params,endPoint: endPoint )
            })
        }
    }
    
    func hitServer(params: [String:Any],endPoint: String) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: .post, dueToAction: "signUp"){ result in
            self.stopAnimating()
            switch result {
            case let .success(json,requestType):
                
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }else {
                    /* Don't remove below commented showMessage line */
                    //showMessage(bodyText: msg,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 1)) /* Don't remove this line might future manju will tell to show this message , time being as per Manju i am removing this message */
                    
                    //Register With QuickBLocks
                    
//                    let newUser = QBUUser()
//                    newUser.email = self.emaIlTF.text!
////                    newUser.fullName = self.fNaMeTF.text!
//                   newUser.fullName = self.fNaMeTF.text! + " " + self.lNaMeTF.text!
//                    newUser.tags = ["LTW"]
//                    newUser.password = LoginConstant.defaultPassword
//                    QBRequest.signUp(newUser, successBlock: { response, user in
//
//                        print("responseyguygy :\(response)")
//                        self.login(fullName: self.fNaMeTF.text! + " " + self.lNaMeTF.text!, emailId: self.emaIlTF.text!, ClassId:0 )
//
//                        UserDefaults.standard.set("\(user.id)", forKey: "QuickBlockID")
//                        UserDefaults.standard.synchronize()
//
//                    }, errorBlock: { [weak self] response in
//
//                        print("response :\(response)")
//                        if response.status == QBResponseStatusCode.validationFailed {
//                            // The user with existent login was created earlier
//                            self!.login(fullName: self!.fNaMeTF.text! + " " + self!.lNaMeTF.text!, emailId: self!.emaIlTF.text!, ClassId:0 )
//
//                            return
//                        }
//                        self?.handleError(response.error?.error, domain: ErrorDomain.signUp)
//                    })
                    
                    
                    // upload image file to azure
                    if !self.profileImgLocalUrl.isEmpty && self.profileImgLocalUrl.contains("var") {// image new or not add conditon
                        var arr = Array<String>()
                        arr.append(self.profileImgLocalUrl)
                        AzureUploadUtil().uploadBlobToContainer(filePathArray: Array(arr))
                    }
                    
                    self.parseValueAndStore(json: json["ControlsData"], requestType: requestType)
                    self.parseValueAndStore1(json: json["ControlsData"]["lsv_userdetails"], requestType: requestType)
                    
                    /* push notification setup starts - /* comment these lines while load in simulator but for device uncomment it */ */
                    
                    let hub = SBNotificationHub(connectionString:Constants.HUBLISTENACCESS, notificationHubPath:Constants.HUBNAME)
                    let set: Set<String> = [UserDefaults.standard.string(forKey: "userID")!, self.emaIlTF.text!]
                    
                     

                    
                    do {
                          try hub?.registerNative(withDeviceToken: (UserDefaults.standard.object(forKey: "deviceTokenSBN") as! Data), tags: set) /* Comment in case of Simulator */
//                            try hub?.registerNative(withDeviceToken: (UserDefaults.standard.object(forKey: "deviceTokenSBN") as? Data), tags: set) /* Comment in case of Device */
                    }
                    catch {
                        let fetchError = error as Error
                        print(fetchError)
                    }
                    
                    /* push notification setup ends - /* comment these lines while load in simulator but for device uncomment it */ */
                    
                    /* Launch Home Page  From Here */
                    
                    
                    //prasuna added this on 31/1/2020
                    
                    if self.teAcherBtn.isSelected
                    {
                        
                        UserDefaults.standard.set(true, forKey: "Tutor")
                        UserDefaults.standard.synchronize()
                        let tutorSignUpVC = self.storyboard?.instantiateViewController(withIdentifier: "TutorSignUpVC") as! TutorSignUpVC
                        
                        self.navigationController?.pushViewController(tutorSignUpVC, animated: true)
                        
                    }else{
                        /* changed by veeresh on 5th march 2020 */
                        print("tour demo") // tourSlidesVC
                        /* Commented By Veeresh on 24th April 2020 - starts here */
                        //                                      let tourDemo = self.storyboard?.instantiateViewController(withIdentifier: "tourSlidesVC") as! tourSlidesVC
                        //                                      tourDemo.modalPresentationStyle = .fullScreen
                        //                                      self.present(tourDemo, animated: true, completion: nil)
                        /* Commented By Veeresh on 24th April 2020 - ends  here */
                        
                        /* Added By Veeresh on 24th April 2020 - starts  here */
                        UserDefaults.standard.set(true, forKey: "PostSignUpClassPage")
                        UserDefaults.standard.synchronize()
                        let followCategory = self.storyboard?.instantiateViewController(withIdentifier: "AvailableClassesPostSignupVC") as! AvailableClassesPostSignupVC
                        followCategory.modalPresentationStyle = .fullScreen
                        self.present(followCategory, animated: true, completion: nil)
                        
                        /* Added By Veeresh on 24th April 2020 - ends  here */
                        
                    }
                    
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    
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
//                            let quickIdUrl = Endpoints.updateQuickID + UserDefaults.standard.string(forKey: "userID")! + "/" + "\(user.id)"
//                            LTWClient.shared.hitService(withBodyData: [:], toEndPoint: quickIdUrl, using: .get, dueToAction: "QuickBloxId"){ result in
//                                switch result {
//                                case let .success(json,_):
//
//                                    //                                    let msg = json["message"].stringValue
//                                    if json["error"].intValue == 1 {
//                                        //                                        showMessage(bodyText: msg,theme: .error)
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
//                            //                                                                          let subscription = QBMSubscription()
//                            //                                                                          subscription.notificationChannel = .APNS
//                            //                                                                          subscription.deviceUDID = deviceIdentifier
//                            //                                                                          subscription.deviceToken = (UserDefaults.standard.object(forKey: "deviceTokenSBN") as! Data)
//                            //
//                            //                                                                          QBRequest.createSubscription(subscription, successBlock: { response, objects in
//                            //                                                                          debugPrint("[UsersViewController] Create Subscription request - Success")
//                            //                                                                          }, errorBlock: { response in
//                            //                                                                          debugPrint("[UsersViewController] Create Subscription request - Error")
//                            //                                                                          })
//                            //                                                                          if QBChat.instance.isConnected == false {
//                            //                                                                          (UIApplication.shared.delegate as! AppDelegate).connectToChat()
//                            //                                                                          }
//
//
//                            if user.fullName != fullName {
//                                self?.updateFullName(fullName: fullName, login: emailId)
//                            } else {
//                                self?.connectToChat(user: user)
//                            }
//            }, errorBlock: { [weak self] response in
//                self?.handleError(response.error?.error, domain: ErrorDomain.logIn)
//                if response.status == QBResponseStatusCode.unAuthorized {
//                    // Clean profile
//                    Profile.clearProfile()
//                }
//        })
//    }
    
    
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
//                                    }
//        })
//    }
    
    
    
//    private func handleError(_ error: Error?, domain: ErrorDomain) {
//        guard let error = error else {
//            return
//        }
//        //           let infoText = error.localizedDescription
//
//        //        showMessage(bodyText: error.localizedDescription ,theme: .error)
//
//
//        if error._code == NSURLErrorNotConnectedToInternet {
//        }
//
//    }
    //parseValueAndStore
    private  func parseValueAndStore(json: JSON,requestType: String) {
        
        UserDefaults.standard.set(self.profileImgLocalUrl, forKey: "profileImgLocalUrl")
        UserDefaults.standard.set(fNaMeTF.text!, forKey: "fname")
        UserDefaults.standard.set(lNaMeTF.text!, forKey: "lname")
        UserDefaults.standard.set("\(fNaMeTF.text!)" + " \(lNaMeTF.text!)",forKey: "name")
        UserDefaults.standard.set(self.emaIlTF.text!, forKey: "emailId")
        UserDefaults.standard.set(FileAzureUrl, forKey: "profileURL")
        UserDefaults.standard.set(self.personType, forKey: "persontyp")
        // UserDefaults.standard.set(linkedInLnkTF.text!, forKey: "linkedinUrl")
        UserDefaults.standard.set("", forKey: "description")
        UserDefaults.standard.set(currentEdctn.text!, forKey: "curentEductn")
        //  UserDefaults.standard.set(workExp.text!, forKey: "workExp")
        UserDefaults.standard.set(scholTF.text!, forKey: "school")
        UserDefaults.standard.set(SignUpVC.timeZone, forKey: "timezone")
        UserDefaults.standard.set(SignUpVC.points, forKey: "points")
        //  UserDefaults.standard.set(cityTF.text!, forKey: "city")
        UserDefaults.standard.set(stateTF.text!, forKey: "state")
        // UserDefaults.standard.set(counTryTF.text!, forKey: "country") /*  Commented By Ranjeet on 1st April 2020 */
        UserDefaults.standard.set(self.counTryTF.text!, forKey: "country") /*  Added By Ranjeet on 1st April 2020 */
        UserDefaults.standard.set(self.countryCode, forKey: "CountryCode") /*  Added By Ranjeet on 1st April 2020 */
        // UserDefaults.standard.set(zipCodeTF.text!, forKey: "zipcode")
        UserDefaults.standard.set(selectArr, forKey: "grades")
        // UserDefaults.standard.set(selectArr1.joined(separator: ","),forKey : "teaching")//
        UserDefaults.standard.set("", forKey: "AccountID")
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
    
    // parseValueAndStore1
    private  func parseValueAndStore1(json: JSON,requestType: String) {
        UserDefaults.standard.set(json["UserID"].stringValue, forKey: "userID")
        UserDefaults.standard.synchronize()
    }
}

/* Tag Related - From Here */
extension SignUpVC : TagListVCDelegate {
    func setTagItems(strName: String, index: Int ,Tag:Int) {
        if Tag == 0
        {
            tagListView.addTag(strName)
            arrTag[index] = 1
            selectArr.append(strName)
            
        }else
        {
            //            tagListView1.addTag(strName)
            //            arrTag1[index] = 1
            //            selectArr1.append(strName)
            
        }
        
    }
}

extension SignUpVC : TagListViewDelegate {
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
        let index = arrTagList.firstIndex(of: title)
        if sender.tag == 0
        {
            selectArr.remove(at: selectArr.index(of: title)!)
            arrTag[index!] = 0
        }else
        {
            //            selectArr1.remove(at: selectArr1.index(of: title)!)
            //            arrTag1[index!] = 0
        }
        
        // if teacher {} else {dismiss taglistview same as on close click} /* don't delete this line, future might reuse to strict to pass more than one tags to student and parent & in case of teacher will allow to pass multiple tags. */
    }
}
/* Tag Related - Till Here */

/* Added By Ranjeet on 24th April 2020 - starts here */
extension SignUpVC : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == counTryTF {
            self.countryPicker.showCountriesList(from: self)
            return false
        }
        return false
    }
    func moveToSettings(enterhereWhichSettingControlYouWant : String ){
        let alertController = UIAlertController(title: "Need \(enterhereWhichSettingControlYouWant) Permission.", message: "Please go to Settings and turn on the \(enterhereWhichSettingControlYouWant) permissions", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
             }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
/* Added By Ranjeet on 24th April 2020 - ends  here */


