//  UserProfileUpdateVC.swift
//  LTW
//  Created by Ranjeet Raushan on 21/08/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import PhotosUI
import Alamofire
import SwiftyJSON
import SDWebImage
import SwiftMessages
import MobileCoreServices
import NVActivityIndicatorView
import CountryPickerView


class UserProfileUpdateVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,NVActivityIndicatorViewable, CountryPickerViewDelegate, EditImgSender {
    @IBOutlet weak var profiLeIV: UIImageView!{
        didSet{
            profiLeIV.setRounded()
            profiLeIV.clipsToBounds = true
        }
    }
    @IBOutlet weak var fNaMeTF: UITextField!
    @IBOutlet weak var lNaMeTF: UITextField!
    @IBOutlet weak var emaIlTF: UITextField!
    
    /* Button Outlet related to Student , Parent and Teacher - From Here */
    @IBOutlet weak var studentBtn: UIButton!
    {
        didSet{
            studentBtn.isUserInteractionEnabled = false
        }
    }
   // @IBOutlet weak var parentBtn: UIButton!  /* As per the Ranjit(USA) Suggestions we are removing now , but future might same requirement will come , so don't delete it */
    @IBOutlet weak var teacherBtn: UIButton!
        {
    didSet{
            teacherBtn.isUserInteractionEnabled = false
        }
    }
    /* Button Outlet related to Student , Parent and Teacher - Till Here */
    
   // @IBOutlet weak var cityTF: UITextField!
   // @IBOutlet weak var zipCodeTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var counTryTF: UITextField!
  //  @IBOutlet weak var linkedInLnkTF: UITextField!
    @IBOutlet weak var currentEdctn: UITextField!
    @IBOutlet weak var scholTF: UITextField!
     // @IBOutlet weak var workExp: UITextField!
   
        
    
    // tag Related
    @IBOutlet weak var tagListView: TagListView! // For Interest
    @IBOutlet weak var updateBtn: UIButton!
        {
        didSet{
            updateBtn.layer.cornerRadius = updateBtn.frame.height / 12
        }
    }
     @IBOutlet weak var saveAndContinueBtn: UIButton!// add by chandra
    {
        didSet{
            saveAndContinueBtn.layer.cornerRadius = saveAndContinueBtn.frame.height / 12
        }
    }
    @IBOutlet weak var scRollView: UIScrollView!
    @IBOutlet weak var conTentView: UIView!
    @IBOutlet weak var cardView: UIView!
   

        var profileImgLocalUrl: String = ""
        var imagePicker = ImagePicker()
        var userID: String!
        var personType : Int! /* Uncommented By Ranjeet on 8th April 2020 */
      //  var personType : Int = -1 /* Commented By Ranjeet on 8th April 2020 */
        var index: Int?
        var count: Int?
        var update:Int! // add by chandra
    
        // Tag Related
        var arrTagList : [String] = []
        var arrTag : [Int] = []
      //  var arrTag1: [Int] = []
        var selectArr :[String] = []
       // var selectArr1:[String] = []
        var FileAzureUrl:String = ""
      var personTypeCheck: String! /* Added By Chandra on 28th Feb 2020  */
      var countryPicker = CountryPickerView()
      var cpv: CountryPickerView! /*  Added By Ranjeet on 1st April 2020 */
      var countryCode = "" /*  Added By Ranjeet on 24th April 2020 */
    /* Below two lines are there For Editing Tutor - Added By Chandra on 28th Feb 2020 */
    var isEdit = false /* Added By Chandra on 28th Feb 2020  */  /* For Editing Teacher */
    var tutorDetails1:JSON! /* Added By Chandra on 28th Feb 2020  */
    var skipBtn = UserDefaults.standard.bool(forKey: "Skip") // add by chandra for skip in tutor
    override func viewDidLoad() {
        super.viewDidLoad()
        /*  Added By Ranjeet on 1st April 2020 - starts here */
              // Default Selection Of Person Type
//              studentBtn.isSelected = true
              /*  Added By Ranjeet on 1st April 2020 - ends here */
        userID =  UserDefaults.standard.string(forKey: "userID")
        personTypeCheck = UserDefaults.standard.string(forKey: "persontyp")! /* Added By Chandra on 28th Feb 2020  */
//        hitServer(params: [:], endPoint: Endpoints.userProfileEndPoint + (userID) ,  action: "userProfile", httpMethod: .get)
       
        /* Added By Chandra on 28th Feb 2020 - starts here */
        if personTypeCheck == "1"{
            saveAndContinueBtn.isHidden = true // add by chandra
        }else{
            saveAndContinueBtn.isHidden = false // add by chandra
        }
        /* Added By Chandra on 28th Feb 2020 - starts here */
        
        fNaMeTF.useUnderline()
        lNaMeTF.useUnderline()
        emaIlTF.useUnderline()
        //cityTF.useUnderline()
        //zipCodeTF.useUnderline()
        stateTF.useUnderline()
        counTryTF.useUnderline()
     //   linkedInLnkTF.useUnderline()
        scholTF.useUnderline()
        profiLeIV.setRounded()
      //  workExp.useUnderline()
        currentEdctn.useUnderline()
        profiLeIV.clipsToBounds = true
        
       countryPicker.delegate = self
        countryCode = countryPicker.selectedCountry.code
              
        // Profile image related
        let tap = UITapGestureRecognizer(target: self, action: #selector(UserProfileUpdateVC.tappedMe))
        profiLeIV.addGestureRecognizer(tap)
        profiLeIV.isUserInteractionEnabled = true
        
        updateData()
          // tag Realated
              tagListView.delegate = self
          //    tagListView1.delegate = self
              arrTagList = ["1st", "2nd", "3rd","4th", "5th","6th","7th","8th","9th", "10th","11th","12th", "UnderGraduates","Graduates"]
             // arrTagList1 = ["1st", "2nd", "3rd","4th", "5th","6th","7th","8th","9th", "10th","11th","12th", "UnderGraduates","Graduates"]
              arrTag = Array(repeating: 0, count: arrTagList.count)
            //  arrTag1 = Array(repeating: 0 , count: arrTagList.count)
       
        /* disable the tags which is already selected while sign up */
        for i in 0..<arrTagList.count {
            
            for j in 0..<selectArr.count {
                
                if selectArr[j] == arrTagList[i]{
                    
                    arrTag[i] = 1
                    break
                }
            }
            
        }
        print(arrTag)
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        
         countryCode = country.code
               counTryTF.text = country.name
        
    }
    
    @IBAction func onStudntTechrBtnsClick(_ sender: UIButton) {
        if sender.tag == 1
        {
            studentBtn.isSelected = true
            teacherBtn.isSelected = false
            personType = 1
        }
        else if sender.tag == 3{
            studentBtn.isSelected = false
            teacherBtn.isSelected = true
            personType = 3
        }
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
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            update = 0
              hitServer(params: [:], endPoint: Endpoints.userProfileEndPoint + (userID) ,  action: "userProfile", httpMethod: .get)
             
            if (self.navigationController?.navigationBar) != nil {
                navigationController?.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
            }
            self.navigationController?.navigationBar.topItem?.title = " "
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationItem.title = "Update Profile"
//            hitServer(params: [:], endPoint: Endpoints.userProfileEndPoint + (userID) ,  action: "userProfile", httpMethod: .get)
    }
    
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
                picker.navigationBar.topItem?.rightBarButtonItem?.tintColor = .black
                self.present(picker,animated: true,completion: nil)
            }else{
                self.noCamera()
            }
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (action) in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = .savedPhotosAlbum
            picker.mediaTypes = [kUTTypeImage as String]
            picker.navigationBar.isTranslucent = false
            picker.navigationBar.barTintColor  = UIColor.init(hex:"2DA9EC") // Background color
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
        
    }//
    
    //MARK: - Delegates
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        /* Below Commented by DK on 9th june 2020.*/
        /*
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        profiLeIV.image = chosenImage //4
        let imageFolder = imagePicker.getImagesFolder()
        let uniqueFileName = imagePicker.getUniqueFileName()
        let finalPath = URL.init(fileURLWithPath: "\(String(describing: imageFolder))/\(String(describing: uniqueFileName))")
        do {
            try chosenImage.jpegData(compressionQuality: 1)?.write(to: finalPath, options: .atomic)
            profileImgLocalUrl = "\(String(describing: imageFolder))/\(String(describing: uniqueFileName))"
        }
        catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        dismiss(animated:true, completion: nil)//5
*/
        /* Above Commented by DK on 9th june 2020.*/
        /* Below Added by Dk on 9th june 2020*/
        if picker.sourceType == .savedPhotosAlbum {
            let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let vc = storyboard?.instantiateViewController(withIdentifier: "ImageEditForScriblingANdCropVC") as! ImageEditForScriblingANdCropVC
            vc.backgroundImgPassed = chosenImage
            vc.Delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
            picker.dismiss(animated: true, completion: nil)
            dismiss(animated:true, completion: nil)
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
    func getImg(EditedImg : UIImage ) { //added by dk on 9th june 2020.
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
    private func updateData(){
        
        emaIlTF.isEnabled = false
        emaIlTF.isUserInteractionEnabled = false
        fNaMeTF.text = UserDefaults.standard.string(forKey: "fname")
        lNaMeTF.text = UserDefaults.standard.string(forKey: "lname")
        emaIlTF.text = UserDefaults.standard.string(forKey: "emailId")
//        cityTF.text = UserDefaults.standard.string(forKey: "city")
//        zipCodeTF.text = UserDefaults.standard.string(forKey: "zipcode")
        stateTF.text = UserDefaults.standard.string(forKey: "state")
       // counTryTF.text = UserDefaults.standard.string(forKey: "country")
        counTryTF.text = UserDefaults.standard.string(forKey: "country")

      //  linkedInLnkTF.text = UserDefaults.standard.string(forKey: "linkedinUrl")
        currentEdctn.text = UserDefaults.standard.string(forKey: "curentEductn")
       //  workExp.text = UserDefaults.standard.string(forKey: "workExp")
        scholTF.text = UserDefaults.standard.string(forKey: "school")
        selectPersonType(value: UserDefaults.standard.object(forKey: "persontyp") as! Int)
        selectArr = UserDefaults.standard.array(forKey: "grades") as! [String]
    //    let str = UserDefaults.standard.string(forKey: "teaching")!
     //   selectArr1 = str.components(separatedBy: ",")
        for  strname in selectArr
        {
            tagListView.addTag(strname)
        }
//        for strname1 in selectArr1{
//            tagListView1.addTag(strname1)
//        }
        if let profileImgLocalUrl = UserDefaults.standard.object(forKey: "profileImgLocalUrl") as? String {
            print("profileImgUrl = \(profileImgLocalUrl)")
            self.profileImgLocalUrl = profileImgLocalUrl
            let fileName = (profileImgLocalUrl as NSString).lastPathComponent
            if (profileImgLocalUrl.contains("var")) {
                //read image from document directory
                let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
                let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
                let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
                if let dirPath = paths.first {
                    let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("Images/\(fileName)")
                    if let image = UIImage(contentsOfFile: imageURL.path) {
                        // use image
                        profiLeIV.image = image
                    }
                    else {
                        //or bind default image
                    }
                }
            }
        } else {
            if  let imgUrl =  UserDefaults.standard.string(forKey: "profileURL") {
                self.profileImgLocalUrl = imgUrl
                self.profiLeIV?.sd_setImage(with: URL.init(string: imgUrl),placeholderImage:UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload])
            }
        }
    }
    
    func selectPersonType(value : Int)
    {
        switch value {
        case 1:
            studentBtn.isSelected = true
            personType = 1
        case 3:
            teacherBtn.isSelected = true
            personType = 3
        default:
            break
        }
    }
    
    @IBAction func onProfileOrUserUpdateBtnClk(_ sender: UIButton) {
        
            self.validiate()
        
       
    }
    
    /* Added By Chandra on 28th Feb 2020 - starts here */
    @IBAction func onSaveAndContinueBtnsClick(_ sender: UIButton) {
        
        // add by chandra for tutor sip form staret here 
        
            let tutorSignUpVC = self.storyboard?.instantiateViewController(withIdentifier: "TutorSignUpVC") as! TutorSignUpVC
                if skipBtn == true{
                 print("skipBtnClick")
             }else{
                 self.update = 2
                 self.validiate()
                 tutorSignUpVC.isEdit = true
                 tutorSignUpVC.tutorDetails = self.tutorDetails1
             }
                // self.navigationController?.pushViewController(tutorSignUpVC, animated: true)
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                 self.navigationController?.pushViewController(tutorSignUpVC, animated: true)
            }
        }
    }
   

    func validiate(){

        guard let fName = fNaMeTF.text, !fName.trimmingCharacters(in: .whitespaces).isEmpty else {
            showMessage(bodyText: "Please enter your first name.",theme: .warning)
            return
        }
        guard let lName = lNaMeTF.text,  !lName.trimmingCharacters(in: .whitespaces).isEmpty else {
            showMessage(bodyText: "Please enter your last name.",theme: .warning)
            return
        }
         /*  Commented By Ranjeet on 8th  April 2020 - starts here(Defaults selection of person type, please don't remove , future might reuse ) */
//        if personType == -1{
//            showMessage(bodyText: "Please select person type.",theme: .warning)
//            return
//        }
       /*  Commented By Ranjeet on 8th  April 2020 - ends here(Defaults selection of person type, please don't remove , future might reuse ) */
        
        guard let curentEductn = currentEdctn.text, !curentEductn.trimmingCharacters(in: .whitespaces).isEmpty else {
                  showMessage(bodyText: "Enter Current Education",theme: .warning)
                  return
              }
        guard let school = scholTF.text, !school.trimmingCharacters(in: .whitespaces).isEmpty else {
                   showMessage(bodyText: "Please enter your school.",theme: .warning)
                   return
               }
        guard !selectArr.isEmpty else {
            showMessage(bodyText: "Please select grades",theme: .warning)
            return
        }
//        if teacherBtn.isSelected{
//                   guard let linkedInLink = linkedInLnkTF.text, !linkedInLink.trimmingCharacters(in: .whitespaces).isEmpty else {
//                       showMessage(bodyText: "Please enter your linkedIn link.",theme: .warning)
//                       return
//                   }
//        }
        guard let state = stateTF.text, !state.trimmingCharacters(in: .whitespaces).isEmpty else {
            showMessage(bodyText: "Please enter your state.",theme: .warning)
            return
        }
  
        if !profileImgLocalUrl.isEmpty{
            let urlFilePath = (profileImgLocalUrl as NSString).lastPathComponent
            FileAzureUrl = "https://ltwuploadcontent.blob.core.windows.net/actualimages/\(urlFilePath)"
        }
        else {
            FileAzureUrl = profileImgLocalUrl
        }
        
        if studentBtn.isSelected == true {
            personType = 1
        }
        else  if teacherBtn.isSelected == true {
            personType = 3
        }
        
        
        let params: [String:Any] =    [
        "UserID": UserDefaults.standard.object(forKey: "userID") as! String,
        "FirstName": fName ,
        "LastName": lName ,
        "ProfileURL": FileAzureUrl,
        "DeviceToken": "iPhone",
        "PersonType":personType!,
        "Description": "",
        "Education": curentEductn,
        "Schools":school,
        "Timezone": "Indian Standard Time",
        "Points": 0,
        //"City":city,
        "State": state,
        // "Country": country, /*  Commented By Ranjeet on 1st April 2020 */
        "Country":counTryTF.text ?? "", /*  Added By Ranjeet on 1st April 2020 */
       // "ZipCode":zipcode,
        "Grade": selectArr
       // "Teaching": selectArr1.joined(separator: ",")
            ]as [String : Any]
//         params["LinkedinUrl"] = linkedInLnkTF.text!
//         params["WorkExperience"] = workExp.text!
        callService(params: params,endPoint: Endpoints.updateProfileUser)
    }
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
    private func hitServer(params: [String:Any],endPoint: String) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: .post, dueToAction: "updateUser"){ result in
            self.stopAnimating()
            switch result {
                 case let .success(json,_):
                
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }else {
                    
                    if !self.profileImgLocalUrl.isEmpty{
                        UserDefaults.standard.set(self.profileImgLocalUrl, forKey: "profileImgLocalUrl")
                    }
                    UserDefaults.standard.set(self.FileAzureUrl, forKey: "profileURL")
                    UserDefaults.standard.set(self.fNaMeTF.text!, forKey: "fname")
                    UserDefaults.standard.set(self.lNaMeTF.text!, forKey: "lname")
                    UserDefaults.standard.set(self.personType, forKey: "persontyp")
                //    UserDefaults.standard.set(self.linkedInLnkTF.text!, forKey: "linkedinUrl")
                    UserDefaults.standard.set(self.currentEdctn.text!,forKey: "school")
                    UserDefaults.standard.set(self.scholTF.text!, forKey: "curentEductn")
                 //   UserDefaults.standard.set(self.workExp.text!, forKey: "workExp")
                    // UserDefaults.standard.set(self.cityTF.text!, forKey: "city")
                    UserDefaults.standard.set(self.stateTF.text!, forKey: "state")
                    // UserDefaults.standard.set(self.counTryTF.text!, forKey: "country")
                    UserDefaults.standard.set(self.counTryTF.text!, forKey: "country") /*  Added By Ranjeet on 1st April 2020 */
                    // UserDefaults.standard.set(self.zipCodeTF.text!, forKey: "zipcode")
                    UserDefaults.standard.set(self.selectArr, forKey: "grades")
                 //   UserDefaults.standard.set(self.selectArr1.joined(separator: ","), forKey :"teaching")
                    UserDefaults.standard.synchronize()
                    HomeVC.setGradeToInitailState()
                    HomeVC.subjectIDs = ""
                    HomeVC.subSubjectIDs = ""
                    if self.update == 2{
                        
                    }else{
                        self.navigationController?.popViewController(animated: true)
                        showMessage(bodyText: msg ,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.01))
                    }
                    // upload image file to azure
                    if !self.profileImgLocalUrl.isEmpty {// image new or not add conditon
                        var arr = Array<String>()
                        arr.append(self.profileImgLocalUrl)
                       // AzureUploadUtil().uploadBlobToContainer(filePathArray: Array(arr))
                        AzureUpload().uploadBlobToContainer(filePathArray: arr, containerType: "Images")
                    }
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
}
/* Tag Related - From Here */
extension UserProfileUpdateVC : TagListVCDelegate {
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

extension UserProfileUpdateVC : TagListViewDelegate {
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
        let index = arrTagList.firstIndex(of: title)
        if index != nil { // Added By Veeresh & Ranjeet on 8th June 2020
        if sender.tag == 0
        {
            selectArr.remove(at: selectArr.index(of: title)!)
            arrTag[index!] = 0
        }else
        {
//            selectArr1.remove(at: selectArr1.index(of: title)!)
//            arrTag1[index!] = 0
        }
    }
      
        // if teacher {} else {dismiss taglistview same as on close click} /* don't delete this line, future might reuse to strict to pass more than one tags to student and parent & in case of teacher will allow to pass multiple tags. */
    }
    
    // add by chandra for edit tutor
    // user Profile related
    private func hitServer(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) { LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){ [weak self] result in
        guard let _self = self else {
            return
        }
        
        _self.stopAnimating()
        switch result {
        case let .success(json,_):
            let msg = json["message"].stringValue
            if json["error"].intValue == 1 {
                showMessage(bodyText: msg,theme: .error)
            }
            else {
                _self.tutorDetails1 = json["ControlsData"]["tutorInfo"] // add by chandra for getting profile
            }
            break
        case .failure(let error):
            print("MyError = \(error)")
            break
        }
        }
    }
    
    
}
/* Tag Related - Till Here */


/* Added By Ranjeet on 24th April 2020 - starts here */
extension UserProfileUpdateVC : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == counTryTF {
            self.countryPicker.showCountriesList(from: self)
            return false
        }
        return false
    }
}
/* Added By Ranjeet on 24th April 2020 - ends  here */


