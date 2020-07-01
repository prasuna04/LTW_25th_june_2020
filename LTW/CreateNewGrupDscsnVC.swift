// CreateNewGrupDscsnVC.swift
// LTW
// Created by Ranjeet Raushan on 27/07/19.
// Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import PhotosUI
import Alamofire
import SwiftyJSON
import SDWebImage
import SwiftMessages
import MobileCoreServices
import NVActivityIndicatorView

protocol vm:class {
    func ststus(reviewans:Int)
}
class CreateNewGrupDscsnVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NVActivityIndicatorViewable,UITextFieldDelegate,EditImgSender {
    //    add  by chandra for newly edit
    var NoSubscribers:Int!
     let userId = UserDefaults.standard.string(forKey: "userID")
    @IBOutlet weak var scrollVw: UIScrollView!
    @IBOutlet weak var contentVwforCreateGrps: UIView!
    @IBOutlet weak var viewContnedTogleBtn: UIView!
    
    @IBOutlet weak var grupModeLbl: UILabel!
    @IBOutlet weak var grupModeToggle: UISwitch!
    
    @IBOutlet weak var grupDscsnIV: UIImageView!{
        didSet{
            grupDscsnIV.setRounded()
            grupDscsnIV.clipsToBounds = true
        }
    }
     weak var delegate: vm? //Added By Chandra on 3rd Jan 2020
    // Related serach for Email
    var jsondict:[[String:Any]]?
    @IBOutlet weak var cancelBtnInTablevie: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
//    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searcTableView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addBtnClicked: UIButton!
    lazy var storedmail = [String]()
    var stringRepresentation:String?
    var collectionStoredMails:String?
    
    @IBOutlet weak var grupDscsnTilteTF: UITextField!
    @IBOutlet weak var catBtn: UIButton!
    @IBOutlet weak var subCatBtn: UIButton!
    
    @IBOutlet weak var categryContainerView1: UIView! // View1
    @IBOutlet weak var categryContainerView2: UIView! // View2
    @IBOutlet weak var addDescrptnContainerView3: UIView! // View3
    @IBOutlet weak var emailIDsContainerView4: UIView! // View4
    
    // add by chandra 05/11
    @IBOutlet weak var emailIDtextView: UITextView!
    @IBOutlet weak var privateShowingView: NSLayoutConstraint!
    @IBOutlet weak var topSpaceToView3Constraint: NSLayoutConstraint!
    @IBOutlet weak var submitBtn: UIButton!
        {
        didSet{
            submitBtn.layer.cornerRadius = submitBtn.frame.height / 12
        }
    }
    @IBOutlet weak var cancelBtn: UIButton!{
        didSet {
            cancelBtn.backgroundColor = .clear
            cancelBtn.layer.borderWidth = 1
            cancelBtn.layer.borderColor = UIColor.red.cgColor
            cancelBtn.layer.cornerRadius = cancelBtn.frame.height / 12
        }
        
    }
    @IBOutlet weak var addDescriptionTxtVw: UITextView!
    @IBOutlet weak var tagListView: TagListView!
    // Screen width.
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    var isSubjectSelected = false
    let textViewAddDescriptionHint = "Add description(optional)"
    var profileImgLocalUrl: String = ""
    var imagePicker = ImagePicker()
    var topicUrl: String!
    // add by chandra 04/11
    var catgery:String?
    var subcategery:String?
    var stringUrl:String?
    var groupName:String?
    var EditGroup:String?
    var emailids:String?
    var Oldemailids:[String]?
    var tagString = ""
    var oldGrades:String?
    var Description:String?
    var DiscussionID1:String?
    // add by chandra 05/11
    var SharedType1:Int?
    var editType1:Int?
    // let defaults = UserDefaults.standard
    // defaulUserDefaults.standardts.set(array, forKey: "SavedStringArray"
    // Tag Related
       var arrTagList : [String] = []
       var arrTag : [Int] = []
       var selectArr :[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // add by chandra 05/11
        searchTextField.useUnderline()
        searchTextField.layer.cornerRadius = 15.0
        searchTextField.layer.borderWidth = 2.0
        searchTextField.layer.borderColor = UIColor.init(hex: "2DA9EC").cgColor
        searchTextField.leftViewMode = UITextField.ViewMode.always
        
//        let imageView1 = UIImageView(frame: CGRect(x:50, y: 0, width: 20, height: 20))
//        let image = UIImage(named: "Asset 182-1")
//        imageView1.image = image
        
        let views = UIView(frame: CGRect(x: 50, y: 0, width: 35, height: 40))
        views.backgroundColor = UIColor.clear
        let imageView1 = UIImageView(frame: CGRect(x: 10, y:10, width: 20, height: 20))
        let image = UIImage(named: "Asset 182-1")
        imageView1.image = image
        views.addSubview(imageView1)
        searchTextField.leftView = views
        searchTextField.attributedPlaceholder =
        NSAttributedString(string: "Search by emailId,first name and last name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        // related search for Email
        self.searcTableView.isHidden = true
        self.searcTableView.frame = CGRect(x: 15, y: 95, width: self.view.frame.size.width-30, height: self.view.frame.size.height/4)
        self.view.addSubview(self.searcTableView)
        
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        if SharedType1 == 2{
            // grupModeToggle .setOn(true, animated: false)
            grupModeToggle.isOn = true
            grupModeLbl.text = "Private"
            grupModeToggle.isUserInteractionEnabled = false
            // add by chandra for newly edit the group
            if NoSubscribers == 1{
                 grupModeToggle.isUserInteractionEnabled = true
            }else{
                grupModeToggle.isUserInteractionEnabled = false
            }
        }else if SharedType1 == 1{
            // grupModeToggle .setOn(true, animated: false)
            grupModeToggle.isOn = false
            grupModeLbl.text = "Public"
            grupModeToggle.isUserInteractionEnabled = false
            // add by chandra for newly edit the group
            if NoSubscribers == 1{
                 grupModeToggle.isUserInteractionEnabled = true
            }else{
                grupModeToggle.isUserInteractionEnabled = false
            }
        }
        // add by chandra 04/11
        if EditGroup != "Group Edit"{
            addDescriptionTxtVw.delegate = self
            addDescriptionTxtVw.text = textViewAddDescriptionHint
            addDescriptionTxtVw.textColor = UIColor.init(hex: "909191")
            
            // Group Discussion Image Related
            let tap = UITapGestureRecognizer(target: self, action: #selector(CreateNewGrupDscsnVC.tappedMe))
            grupDscsnIV.addGestureRecognizer(tap)
            grupDscsnIV.isUserInteractionEnabled = true
        }else{
            self.catBtn.setTitle(catgery, for: .normal)
            self.catBtn.setTitleColor(UIColor.black, for: .normal) /* UnCommented By Ranjeet on 10th April */
         
            /* Updated By Ranjeet on 2nd April - starts here */
            if #available(iOS 13.0, *) {
                self.catBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            /* Updated By Ranjeet on 2nd April  - ends here */
            
            self.subCatBtn.setTitle(subcategery, for: .normal)
            self.subCatBtn.setTitleColor(UIColor.black, for: .normal)/* UnCommented By Ranjeet on 10th April */
           
            /* Updated By Ranjeet on 2nd April  - starts  here */
            if #available(iOS 13.0, *) {
                self.subCatBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            /* Updated By Ranjeet on 2nd April  - ends here */
            
            self.grupDscsnTilteTF.text = groupName
            // self.emailIDtextView.text = emailids
            storedmail = Oldemailids!
            collectionView.reloadData()
//            let tagsArray = oldGrades?.split(separator: ",")
            let tagsArray = oldGrades?.split(separator: ",").map { String($0) }
            for i in tagsArray!{
            tagListView.addTag(String(i) )
            selectArr.append(String(i))
             
            }
            collectionView.reloadData()
            let thumbnail = stringUrl!.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
            self.grupDscsnIV.sd_setImage(with: URL.init(string:thumbnail ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
            // add by chandra 04/11
            if Description != "Add description(optional)" && Description != ""{
                self.addDescriptionTxtVw.text = Description
                self.addDescriptionTxtVw.textColor = .black
            }else{
                addDescriptionTxtVw.delegate = self
                addDescriptionTxtVw.text = textViewAddDescriptionHint
                addDescriptionTxtVw.textColor = UIColor.init(hex: "909191")
            }
            // Group Discussion Image Related
            let tap = UITapGestureRecognizer(target: self, action: #selector(CreateNewGrupDscsnVC.tappedMe))
            grupDscsnIV.addGestureRecognizer(tap)
            grupDscsnIV.isUserInteractionEnabled = true
        }
         // tag Realated
              tagListView.delegate = self
              arrTagList = ["1st", "2nd", "3rd","4th", "5th","6th","7th","8th","9th", "10th","11th","12th", "UnderGraduates","Graduates"]
              arrTag = Array(repeating: 0, count: arrTagList.count)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for i in 0..<arrTagList.count {
            for j in 0..<selectArr.count {
                if selectArr[j] == arrTagList[i]{
                    arrTag[i] = 1
                    break
                }
            }

        }
            print(arrTag)
        adjustUI()
        self.submitBtn.setTitle("Submit", for: .normal)
        if EditGroup != "Group Edit"{
             self.submitBtn.setTitle("Submit", for: .normal)
        }else{
             self.submitBtn.setTitle("Update", for: .normal)
        }
        if (self.navigationController?.navigationBar) != nil {
            navigationController?.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        }
        // add by chandra 04/11
        if EditGroup != "Group Edit"{
            self.navigationController?.navigationBar.topItem?.title = " "
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationItem.title = "Create Group"
        }else{
            self.navigationController?.navigationBar.topItem?.title = " "
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationItem.title = "Edit Group"
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
    
    // For search email
    @IBAction func ClickOnSearchBtn(_ sender: UIButton){
        
    }
    @IBAction func ClickOnCancelBtn(_ sender: UIButton){
        self.searcTableView.isHidden = true
    }
    
    @IBAction func onGrupModeToggle(_ sender: UISwitch) {
        let newGrupMode = grupModeLbl.text! == "Public" ? "Private" : "Public"
        grupModeLbl.text = newGrupMode
        
        adjustUI()
    }
    private func adjustUI() {
        if grupModeLbl.text == "Private" {
            emailIDsContainerView4.isHidden = false
            // submitBtnTopConstraint.constant = 115
            privateShowingView.constant = 157.67
            self.submitBtn.setTitle("Send Invitation", for: .normal)
        }else {
            emailIDsContainerView4.isHidden = true
            // submitBtnTopConstraint.constant = 5
            privateShowingView.constant = 10
            self.submitBtn.setTitle("Submit", for: .normal)
        }
    }
    @IBAction func onCatBtnClk(_ sender: UIButton) {
        let controller = ArrayChoiceTableViewController(subjects){[unowned self] (selectedSubject) in
            self.catBtn.setTitle(String(describing: selectedSubject ), for: .normal)
            self.catBtn.setTitleColor(UIColor.black, for: .normal) /* Added By Ranjeet on 12th April 2020 */
            /* Added By Ranjeet on 12th April 2020 - starts here */
                      if #available(iOS 13.0, *) {
                          self.catBtn.setTitleColor(UIColor.label, for: .normal)
                      } else {
                          // Fallback on earlier versions
                      }
              /* Added By Ranjeet on 12th April 2020 - ends here */
            self.isSubjectSelected = true
            self.onSubCatBtnClk(self.subCatBtn)
        }
        controller.preferredContentSize = CGSize(width: self.screenWidth - 20, height: 200)
        showPopup(controller, sourceView: sender)
    }
    
    var subSubjectListData: [String] = sub_Subjects
    @IBAction func onSubCatBtnClk(_ sender: UIButton) {
        subSubjectListData = []
        guard let selectCategory = catBtn.title(for: .normal), selectCategory != "Select Category" else{
            showMessage(bodyText: "Plaese select category first",theme: .warning)
            return
        }
        let subIndex = subjects.firstIndex(where: {$0 == catBtn.title(for: .normal)!})!
        switch subIndex {
        case 0:
            subSubjectListData = UserDefaults.standard.array(forKey: "sub_SubjectArray1") as! [String]
        case 1:
            subSubjectListData = UserDefaults.standard.array(forKey: "sub_SubjectArray2") as! [String]
        case 2:
            subSubjectListData = UserDefaults.standard.array(forKey: "sub_SubjectArray3") as! [String]
        case 3:
            subSubjectListData = UserDefaults.standard.array(forKey: "sub_SubjectArray4") as! [String]
            
        default:
            break
        }
        
        if isSubjectSelected {
            self.subCatBtn.setTitle(String(describing: subSubjectListData[0] ), for: .normal)
            isSubjectSelected = false
        }
        
        let controller = ArrayChoiceTableViewController(subSubjectListData){[unowned self ](selectedSubSubject) in
            self.subCatBtn.setTitle(String(describing: selectedSubSubject ), for: .normal)
              self.subCatBtn.setTitleColor(UIColor.black, for: .normal) /* Added By Ranjeet on 12th April 2020 */
            /* Added By Ranjeet on 12th April 2020 - starts here */
            if #available(iOS 13.0, *) {
                self.subCatBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
             /* Added By Ranjeet on 12th April 2020 - ends here */
            
            /* Added By Ranjeet on 12th April 2020 */
        }
        controller.preferredContentSize = CGSize(width: self.screenWidth - 20, height: self.screenHeight / 3)
        showPopup(controller, sourceView: sender)
    }
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    
    // Related search for Email
    @objc func textFieldDidChange(_ textField: UITextField){
        let searchText = searchTextField.text!
        print("Search key = \(searchText)")
        if searchText.count >= 3 {
            let encodeSearchKey = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            print("encodeSearchKey = \(encodeSearchKey)")
            let id = 0
            let emailurl = Endpoints.fetchEmailID + (userId ?? "") + "/\(id)?searchText=" + "\(encodeSearchKey)" /* Added By Chandra on 3rd Jan 2020 */

            Alamofire.request(emailurl , method: .get, parameters: nil , encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response)
                    let swiftyJsonVar = JSON(response.result.value!)
                    DispatchQueue.main.async{
                        if let message = swiftyJsonVar["message"].string{
                            if message == "Success"{
                                if let lsv_emailid = swiftyJsonVar["ControlsData"]["lsv_emailid"].arrayObject as? [[String:Any]]{
                                    self.jsondict = lsv_emailid
                                    self.tableView.reloadData()
                                }else{
                                    AppConstants().ShowAlert(vc: self, title:"Message", message:"There is no data!")
                                }
                            }
                        }
                        
                    }
            }
        }
        if jsondict?.count != 0{
            self.view.addSubview(self.searcTableView)
        }else{
            searcTableView.removeFromSuperview()
        }
        if searchText.count >= 3 {
            self.searcTableView.isHidden = false
        }else{
            self.searcTableView.isHidden = true
        }
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
//                picker.navigationBar.topItem?.rightBarButtonItem?.tintColor = .black
                 /* Updated By Ranjeet on 2nd April - starts here */
                if #available(iOS 13.0, *) {
                    picker.navigationBar.topItem?.rightBarButtonItem?.tintColor = .label
                } else {
                    // Fallback on earlier versions
                }
                 /* Updated By Ranjeet on 2nd April - starts here */
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
        /*
         // The info dictionary may contain multiple representations of the image. You can use the original.
        guard let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        grupDscsnIV.image = chosenImage
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
        dismiss(animated:true, completion: nil)
        */
         //added by dk on 21st may 2020.
            let image = info[.originalImage] as! UIImage
            let vc = storyboard?.instantiateViewController(withIdentifier: "ImageEditForScriblingANdCropVC") as! ImageEditForScriblingANdCropVC
            vc.backgroundImgPassed = image
            vc.Delegate = self
            // vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
            picker.dismiss(animated: true, completion: nil)
        
    }
    func getImg(EditedImg: UIImage) { //added by dk on 21st may 2020.
        grupDscsnIV.image = EditedImg
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
    /* How to get the current date and post it to the server - starts here */
    func currentDateInUTC() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let createdDate = Date()
        let result = dateFormatter.string(from: createdDate)
        let finalCreatedDate = self.localToUTC(date: result, formatter:dateFormatter )
        return finalCreatedDate
    }
    func localToUTC(date:String, formatter: DateFormatter) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: dt!)
    }
    /* How to get the current date and post it to the server - ends here */
    @IBAction func onSubmitBtnClk(_ sender: UIButton) {
        // add by chandra 04/11
         delegate?.ststus(reviewans: 1)
        if EditGroup != "Group Edit"{
            self.validiate()
        }else{
            self.validiate1()
        }
    }
    @IBAction func onaddBtnClicked(_ sender: UIButton){
        if searchTextField.text != "" {
            guard let email = searchTextField.text, !email.trimmingCharacters(in: .whitespaces).isEmpty else {
                showMessage(bodyText: "Please Enter valid email id.",theme: .warning)
                return
            }
            if !email.isValidEmail() {
                showMessage(bodyText: "Please Enter a valid email id.",theme: .warning)
                return
            }
            storedmail.append(searchTextField.text?.trim() ?? "" )
            self.searchTextField.text = nil
            self.collectionView.reloadData()
        }
        
    }
    private func validiate(){
        /* Added By Chandra on 3rd Dec 2019 - starts here */
        if grupModeLbl.text == "Public" {} else{
            guard let emaiIds = stringRepresentation, !emaiIds.trimmingCharacters(in: .whitespaces).isEmpty else {
                showMessage(bodyText: "Invite others to join this group by Entering their Email IDs.",theme: .warning)
                return
            }
        }
        
        guard !selectArr.isEmpty else {
            showMessage(bodyText: "Select one or more grades",theme: .warning)
            return
        }
        /* Added By Chandra on 3rd Dec 2019 - ends here */
        guard let grupTilte = grupDscsnTilteTF.text, !grupTilte.trimmingCharacters(in: .whitespaces).isEmpty else {
            showMessage(bodyText: "Enter Group Name",theme: .warning)
            return
        }
        guard let selectCategory = catBtn.title(for: .normal), selectCategory != "Select Category" else{
            showMessage(bodyText: "Select Subject/Topic",theme: .warning)
            return
        }
        
        guard let selectSub_Category = subCatBtn.title(for: .normal), selectSub_Category != "Select Sub Category" else{
            showMessage(bodyText: "Select Subject/Topic",theme: .warning)
            return
        }
        
        
//        tagString = ""
        for tags in selectArr{
         tagString += tags + ","
        }
        
        if !tagString.isEmpty{
        tagString.removeLast()
        }
        var FileAzureUrl:String = ""
       // if !profileImgLocalUrl.isEmpty && profileImgLocalUrl.contains("var") /* Commented By Chandra on 6th Jan 2020 */
         if !profileImgLocalUrl.isEmpty /* Added By Chandra on 6th Jan 2020 */
        {
            let urlFilePath = (profileImgLocalUrl as NSString).lastPathComponent
            FileAzureUrl = "https://ltwuploadcontent.blob.core.windows.net/actualimages/\(urlFilePath)"
        }else
        {
            FileAzureUrl = profileImgLocalUrl
        }
        
        if NetworkReachabilityManager()?.isReachable ?? false {
            //Internet connected,Go ahead
            if addDescriptionTxtVw.text == "Add description(optional)"{
                           addDescriptionTxtVw.text = ""
                       }
            let param:[String: Any] = [
                "UserID": UserDefaults.standard.string(forKey: "userID")!,
                "Title": grupDscsnTilteTF.text!,
                "SubjectID": (subjects.firstIndex(where: {$0 == catBtn.title(for: .normal)!})! + 1),
                "Sub_SubjectID": getSubSubjectID(subSubjectName: subCatBtn.title(for: .normal)! ) ?? 0 ,
                "SharedType": grupModeLbl.text == "Public" ? 1 : 2,
                "Description": addDescriptionTxtVw.text!,
                "Emailids":stringRepresentation ?? "",
                // "Emailids":emailIDtextView.text!,
                "TopicUrl":FileAzureUrl,
                "CreatedDate": currentDateInUTC(),
                "Grades": tagString
            ]
             tagString.removeAll() // add by chandra for grades 
            hitServer(params: param, endPoint: Endpoints.createGroup)
        }else {
            //NO Internet connection, just return
            showMessage(bodyText: "No internet connection",theme: .warning)
        }
        
    }
    private func validiate1(){
        
        if grupModeLbl.text == "Public" {} else{
            guard let emaiIds = stringRepresentation, !emaiIds.trimmingCharacters(in: .whitespaces).isEmpty else {
                showMessage(bodyText: "Invite others to join this group by Entering their Email IDs.",theme: .warning)
                return
            }
        }
        
        guard let grupTilte = grupDscsnTilteTF.text, !grupTilte.trimmingCharacters(in: .whitespaces).isEmpty else {
            showMessage(bodyText: "Enter Group Name",theme: .warning)
            return
        }
        guard !selectArr.isEmpty else {
                   showMessage(bodyText: "Select one or more grades",theme: .warning)
                   return
               }
        guard let selectCategory = catBtn.title(for: .normal), selectCategory != "Select Category" else{
                   showMessage(bodyText: "Select Subject/Topic",theme: .warning)
                   return
               }
        guard let selectSub_Category = subCatBtn.title(for: .normal), selectSub_Category != "Select Sub Category" else{
            showMessage(bodyText: "Select Subject/Topic",theme: .warning)
            return
        }
       
        for tags in selectArr{
         tagString += tags + ","
        }
        
        if !tagString.isEmpty{
        tagString.removeLast()
        }
        var FileAzureUrl:String = ""
      //  if !profileImgLocalUrl.isEmpty && profileImgLocalUrl.contains("var"){ /*  Commented By Chandra on 6th Jan 2020 */
          if !profileImgLocalUrl.isEmpty /* Added By Chandra on 6th Jan 2020 */
          {
            let urlFilePath = (profileImgLocalUrl as NSString).lastPathComponent
            FileAzureUrl = "https://ltwuploadcontent.blob.core.windows.net/actualimages/\(urlFilePath)"
        }else
        {
            FileAzureUrl = profileImgLocalUrl
        }
        
        if NetworkReachabilityManager()?.isReachable ?? false {
            //Internet connected,Go ahead
            // add by chandra for mailid delete
                        if grupModeLbl.text == "Public"{
                           stringRepresentation?.removeAll()
                           storedmail.removeAll()
                           Oldemailids?.removeAll()
                       }
            
            let param:[String: Any] = [
                "UserID": UserDefaults.standard.string(forKey: "userID")!,
                "Title": grupDscsnTilteTF.text!,
                "SubjectID": (subjects.firstIndex(where: {$0 == catBtn.title(for: .normal)!})! + 1),
                "Sub_SubjectID": getSubSubjectID(subSubjectName: subCatBtn.title(for: .normal)! ) ?? 0 ,
                "SharedType": grupModeLbl.text == "Public" ? 1 : 2,
                "Description": addDescriptionTxtVw.text!,
                "Emailids":stringRepresentation ?? "",
                // "Emailids":emailIDtextView.text!,
                "TopicUrl":FileAzureUrl,
                "CreatedDate": currentDateInUTC(),
                "Grades": tagString
            ]
            //hitServer(params: param, endPoint:Endpoints.editGroup + "/\(DiscussionID1 ?? "")") /* Added By Chandra on 3rd Jan 2020 */
            if grupModeLbl.text == "Public"{
                 if storedmail.isEmpty{
                      hitServer(params: param, endPoint:Endpoints.editGroup + "/\(DiscussionID1 ?? "")") /* Added By Chandra on 3rd Jan 2020 */
                 }else{
                     showMessage(bodyText: "delete mailids",theme: .warning)
                 }
                 
             }else{
                 hitServer(params: param, endPoint:Endpoints.editGroup + "/\(DiscussionID1 ?? "")") /* Added By Chandra on 3rd Jan 2020 */
             }
            
        }else {
            //NO Internet connection, just return
            showMessage(bodyText: "No internet connection",theme: .warning)
        }
    }
    @IBAction func onCancelBtnClk(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    private func hitServer(params: [String:Any],endPoint: String) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: .post, dueToAction: "create_group"){[unowned self] result in
            self.stopAnimating()
            switch result {
            case let .success(json, _):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }else {
                    // upload image file to azure
                   // if !self.profileImgLocalUrl.isEmpty && self.profileImgLocalUrl.contains("var") {// image new or not add conditon /* Commented By Chandra on 6th Jan 2020 */
                    if !self.profileImgLocalUrl.isEmpty{ /* Added By Chandra on 6th Jan 2020 */
                        var arr = Array<String>()
                        arr.append(self.profileImgLocalUrl)
                        AzureUpload().uploadBlobToContainer(filePathArray: arr, containerType: "Images")
//                        AzureUploadUtil().uploadBlobToContainer(filePathArray: arr)
                    }
                    if self.grupModeLbl.text == "Public" {
                        self.navigationController?.popViewController(animated: true)
                        if self.EditGroup != "Group Edit"{
                            //showMessage(bodyText: "Public Group Created Successfully" ,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.02))
                        }else{
                            //showMessage(bodyText: "Public Group Edtit Successfully" ,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.02))
                        }

                        if self.editType1 == 1{
                            for controller in self.navigationController!.viewControllers as Array {
                                if controller.isKind(of: MyGroupsVC.self) {
                                    self.navigationController!.popToViewController(controller, animated: true)
                                    break
                                }
                            }
                        }else{
                            for controller in self.navigationController!.viewControllers as Array {
                                if controller.isKind(of: MyGroupsVC.self) {
                                    self.navigationController!.popToViewController(controller, animated: true)
                                    break
                                }
                            }
                        }
                    }
                    else{
                        if self.editType1 != 1{
                            for controller in self.navigationController!.viewControllers as Array {
                                if controller.isKind(of: MyGroupsVC.self) {
                                    self.navigationController!.popToViewController(controller, animated: true)
                                    break
                                }
                            }
                        }else{
                           for controller in self.navigationController!.viewControllers as Array {
                                if controller.isKind(of: MyGroupsVC.self) {
                                    self.navigationController!.popToViewController(controller, animated: true)
                                    break
                                }
                            }
                        }
                        if self.EditGroup != "Group Edit"{
                           //showMessage(bodyText: "Private Group Created Successfully" ,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.02))
                        }else{
                           // showMessage(bodyText: "Private Group Edtit Successfully" ,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.02))
                        }

                    }
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    @objc func removeMail(sender: UIButton){
        let index = sender.tag
        storedmail.remove(at: index)
        stringRepresentation = storedmail.joined(separator:";")
        print(storedmail)
        self.collectionView.reloadData()
        self.tableView.reloadData()
        // cell.add.setImage(UIImage(named: "unchecked"), for: .normal)
    }
}
extension CreateNewGrupDscsnVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if [textViewAddDescriptionHint].contains(textView.text) {
            textView.text = nil
        }
        textView.textColor = UIColor.black   /* Commented By Ranjeet on 2nd April */
       
        /* Updated By Ranjeet on 2nd April - starts here */
        
        if #available(iOS 13.0, *) {
            textView.textColor = UIColor.label
        } else {
            // Fallback on earlier versions
        }

        /* Updated By Ranjeet on 2nd April - ends  here */
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textViewAddDescriptionHint
            textView.textColor = UIColor.init(hex: "909191")
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
}
extension CreateNewGrupDscsnVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsondict?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchMailDisplayTableViewCell") as! SearchMailDisplayTableViewCell
        let dict = jsondict?[indexPath.row]
        cell.Email.text = "\(dict?["EmailID"] as? String ?? "")"
        if let email = dict?["EmailID"] as? String {
            if storedmail.contains(email){
                cell.add.setImage(UIImage(named: "checked"), for: .normal)
            }else{
                cell.add.setImage(UIImage(named: "unchecked"), for: .normal)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let celll = tableView.cellForRow(at: indexPath) as? SearchMailDisplayTableViewCell{
            let dict = jsondict?[indexPath.row]
            if let email = dict?["EmailID"] as? String {
                if storedmail.contains(email){
                    celll.add.setImage(UIImage(named: "unchecked"), for: .normal)
                    if let index = storedmail.index(of: email) {
                        storedmail.remove(at: index)
                        self.collectionView.reloadData()
                    }
                }
                else{
                    storedmail.append(email)
                    // stringRepresentation = storedmail.joined(separator:";")
                    celll.add.setImage(UIImage(named: "checked"), for: .normal)
                    self.collectionView.reloadData()
                }
            }
            
        }
    }
}

extension CreateNewGrupDscsnVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return storedmail.count
        //      add  by chandra for remove the empty url in collection view  dstart here to
                if grupModeLbl.text == "Public"{
                    storedmail.removeAll()
                }
        //      add  by chandra for remove the empty url in collection view  dstart here to
                return storedmail.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let colcell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchMailBindCollectionViewCell", for: indexPath) as! SearchMailBindCollectionViewCell
        colcell.cornerView.layer.cornerRadius = 10
        colcell.cornerView.layer.masksToBounds = true
        let dict = storedmail[indexPath.item]
        stringRepresentation = storedmail.joined(separator:";")
        colcell.collEmail.text = dict
        colcell.collEmail.adjustsFontSizeToFitWidth = true
        colcell.collEmail.sizeToFit()
        colcell.colladd.tag = indexPath.item
        colcell.colladd.addTarget(self, action: #selector(removeMail), for: .touchUpInside)
        
        return colcell
    }

    
    /* New Code Added By Chandra on 12th-Nov-2019 -  Start  here */
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let collectionViewWidth = collectionView.bounds.width
            return CGSize(width: collectionViewWidth/3, height: 33)
    //        made change in hight 30 to 33
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 5
        }
}


/* New Code Added By Chandra on 17th-Nov-2019 -  ends  here */
/* Tag Related - From Here */
extension CreateNewGrupDscsnVC : TagListVCDelegate {
    func setTagItems(strName: String, index: Int ,Tag:Int) {
        tagListView.addTag(strName)
        selectArr.append(strName)
        arrTag[index] = 1
    }
}

extension CreateNewGrupDscsnVC : TagListViewDelegate {
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
       
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
        let index = arrTagList.firstIndex(of: title)
        selectArr.remove(at: selectArr.index(of: title)!)
        arrTag[index!] = 0
        // if teacher {} else {dismiss taglistview same as on close click} /* don't delete this line, future might reuse to strict to pass more than one tags to student and parent & in case of teacher will allow to pass multiple tags. */
    }
}
/* Tag Related - Till Here */
