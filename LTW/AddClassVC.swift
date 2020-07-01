// AddClassVC.swift
// LTW
// Created by Ranjeet Raushan on 10/10/19.
// Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import NVActivityIndicatorView
import Alamofire
import SwiftyJSON

class AddClassVC: UIViewController,NVActivityIndicatorViewable {
    var editClass:Int?
    var Oldemailids:[String]?
    var stringRepresentation:String?
    lazy var storedmail = [String]()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var ViewSearcTableView: UIView!
    var jsondict:[[String:Any]]?
    @IBOutlet weak var searchEmailTextfield: UITextField!
    @IBOutlet weak var addEmailBtn: UIButton!
    
    @IBOutlet weak var testModeLbl: UILabel!
    @IBOutlet weak var testModeToggle: UISwitch!
    @IBOutlet weak var classTitleTF: UITextField!
    @IBOutlet weak var catBtn: UIButton!
    @IBOutlet weak var subCatBtn: UIButton!
    @IBOutlet weak var fromBtn: UIButton!
    @IBOutlet weak var toBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var timeZoneBtn: UIButton!
    @IBOutlet weak var pointsChargedPerAttandeeTF: UITextField!
    @IBOutlet weak var numberOfAttendeesTF: UITextField!
    @IBOutlet weak var recordClassBtn: UIButton!
    @IBOutlet weak var startTestBtn: UIButton!
    @IBOutlet weak var emailIDsContainerView: UIView!
    @IBOutlet weak var cardView: CardView!
    //    @IBOutlet weak var emailIDTV: UITextView!
    @IBOutlet weak var submitBtnTopConst: NSLayoutConstraint!
    
    @IBOutlet weak var startDateTopConst: NSLayoutConstraint!
      @IBOutlet weak var GradeTopConst: NSLayoutConstraint!
    
    //  @IBOutlet weak var gradeBtn: UIButton!
    //prasuna added
    @IBOutlet weak var tagsBtn: UIButton!
    @IBOutlet weak var tagListView: TagListView!
    // Tag Related
    var arrTagList : [String] = []
    var arrTag : [Int] = []
    var selectArr :[String] = []
    
    let textViewEmailIdsHint =  "Enter email id(s) seperated by ;"
    
    var refreshClassList: (()->())?
    
    // Screen width.
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    var isSubjectSelected = false
    var timeZoneArrayJSON: [JSON]!
    var timeZoneStringArray: [String] = []
    var testStartDate: Date?
    var fromTimingDate: Date?
    var toTimingDate: Date?
    var timeZoneID = -1
    let userId = UserDefaults.standard.string(forKey: "userID")
    // Edit variable
    
    var isEditClass  = false
    var classID: String?
    var classDetailJSON:JSON?
    
    
    var number_Of_Attendees : String! /* For copy of class */
    
    //For toTime validation
    var fromHourString : String!
    var fromMinuteString : String!
    var isExpiredClass = false//added by yasodha
    var isFromExpiredClass = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchEmailTextfield.useUnderline()
        searchEmailTextfield.leftViewMode = UITextField.ViewMode.always
        searchEmailTextfield.layer.cornerRadius = 13.5
        searchEmailTextfield.layer.borderWidth = 2.0
        searchEmailTextfield.layer.borderColor = UIColor.init(hex: "2DA9EC").cgColor
        searchEmailTextfield.leftViewMode = UITextField.ViewMode.always
        
        let views = UIView(frame: CGRect(x: 50, y: 0, width: 35, height: 40))
        views.backgroundColor = UIColor.clear
        let imageView1 = UIImageView(frame: CGRect(x: 10, y:10, width: 20, height: 20))
        let image = UIImage(named: "Asset 182-1")
        imageView1.image = image
        views.addSubview(imageView1)
        searchEmailTextfield.leftView = views
        searchEmailTextfield.attributedPlaceholder =
            NSAttributedString(string: "Search by emailId,first name and last name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        
        self.ViewSearcTableView.isHidden = true
        self.ViewSearcTableView.frame = CGRect(x: cardView.frame.origin.x, y: cardView.frame.origin.y, width: self.view.frame.size.width - 20, height: self.view.frame.size.height/4)
        self.view.addSubview(self.ViewSearcTableView)
        searchEmailTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        navigationItem.title = "Create New Class"
      //  startDateTopConst.constant = 10//commented by yasodha
        submitBtnTopConst.constant = 10
       // GradeTopConst.constant = 10//commented by yasodha
        
        
        
        
        if let path = Bundle.main.path(forResource: "timezone", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let json = try JSON(data: data)
                timeZoneArrayJSON = json["TimeZone"].arrayValue
                print("timeZoneArrayJSON:\(timeZoneArrayJSON!)")
                for jsonObj in timeZoneArrayJSON {
                    timeZoneStringArray.append(jsonObj["_text"].stringValue)
                }
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        
        pointsChargedPerAttandeeTF.delegate = self
        numberOfAttendeesTF.delegate = self
        
        if isEditClass {
            navigationItem.title = "Edit Class"
            testModeToggle.isUserInteractionEnabled = true
            /* Added By Yashoda on 4th March 2020 - from here */
            if  number_Of_Attendees == "0"{
                submitBtn.setTitle("  Update Class  ", for: .normal)
                
            }else{
                navigationItem.title = "COPY CLASS" // add by yusodha 05/3/2020
                testModeToggle.isUserInteractionEnabled = true
                submitBtn.setTitle("  Copy Class  ", for: .normal)
            }
            if isExpiredClass == true{
                navigationItem.title = "Create New Class"// add by yusodha 05/3/2020
                testModeToggle.isUserInteractionEnabled = true
                submitBtn.setTitle(" SUBMIT ", for: .normal)
                
            }
            /* Added By Yashoda on 4th March 2020 - till here */
            
            //submitBtn.setTitle("  Update Class  ", for: .normal) /* Commented  By Yashoda on 4th March 2020  */
            // noOfQuesTF.isUserInteractionEnabled = false
            if NetworkReachabilityManager()?.isReachable ?? false {
                //Internet connected,Go ahead
                let editPoint = Endpoints.getClassinfoEndPoint + userId! + "/" + classID!
                hitServer(params: [:], endPoint: editPoint, httpMethod: .get, action: "getClassData")
            }else {
                //NO Internet connection, just return
                showMessage(bodyText: "No internet connection",theme: .warning)
            }
        }
        // tag Realated
        tagListView.delegate = self
        arrTagList = ["1st", "2nd", "3rd","4th", "5th","6th","7th","8th","9th", "10th","11th","12th", "UnderGraduates","Graduates"]
        arrTag = Array(repeating: 0, count: arrTagList.count)
        
    }
    
    /*Added by yasodha 6/3/2020 starts here */
    func serverToLocal(date:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let localDate = dateFormatter.date(from: date)
        
        return localDate
    }
    
    /*Added by yasodha 6/3/2020 ends here */
    
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
    
    //   add by chandra
    @objc func textFieldDidChange(_ textField: UITextField){
        let searchText = searchEmailTextfield.text!
        print("Search key = \(searchText)")
        if searchText.count >= 3 {
            let encodeSearchKey = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            print("encodeSearchKey = \(encodeSearchKey)")
            let id = 1
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
                                    self.tableview.reloadData()
                                }else{
                                    AppConstants().ShowAlert(vc: self, title:"Message", message:"There is no data!")
                                }
                            }
                        }
                        
                    }
            }
        }
        if jsondict?.count != 0{
            self.view.addSubview(self.ViewSearcTableView)
        }else{
            ViewSearcTableView.removeFromSuperview()
        }
        if searchText.count >= 3 {
            self.ViewSearcTableView.isHidden = false
        }else{
            self.ViewSearcTableView.isHidden = true
        }
    }
    @IBAction func ClickOnDoneBtn(_ sender: UIButton){
        self.ViewSearcTableView.isHidden = true
    }
    @objc func removeMail(sender: UIButton){
        let index = sender.tag
        storedmail.remove(at: index)
        stringRepresentation = storedmail.joined(separator:";")
        print(storedmail)
        self.collectionView.reloadData()
        self.tableview.reloadData()
        // cell.add.setImage(UIImage(named: "unchecked"), for: .normal)
    }
    func getTimeZoneID(timeZoneName: String) -> Int? {
        let resultArray = timeZoneArrayJSON.filter { json -> Bool in
            return json["_text"].stringValue == timeZoneName
        }
        if resultArray.count > 0 {
            return resultArray[0]["_zoneid"].intValue
        }
        return nil
    }
    func getTimeZoneName(timeZoneID: String) -> String? {
        
        let resultArray = timeZoneArrayJSON.filter { json -> Bool in
            return json["_zoneid"].stringValue == timeZoneID
        }
        if resultArray.count > 0 {
            return resultArray[0]["_text"].stringValue
        }
        return nil
    }
    @IBAction func onTestModeToggle(_ sender: UISwitch) {
        let newTestMode = testModeLbl.text == "Public" ? "Private" : "Public"
        testModeLbl.text = newTestMode
        if testModeLbl.text == "Public" {
            emailIDsContainerView.isHidden = true
            submitBtnTopConst.constant = 10
            
            
        }else {
            emailIDsContainerView.isHidden = false
            submitBtnTopConst.constant = 118
        }
    }
    
    @IBAction func onCatBtnClick(_ sender: UIButton) {
        
        let controller = ArrayChoiceTableViewController(subjects){[unowned self] (selectedSubject) in
            self.catBtn.setTitle(String(describing: selectedSubject ), for: .normal)
            self.catBtn.setTitleColor(UIColor.black, for: .normal) /* Added By Ranjeet on 12th April 2020 */
            /*  Added By Ranjeet on 26th March 2020 - starts here */
            if #available(iOS 13.0, *) {
                self.catBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            /*  Added By Ranjeet on 26th March 2020 - ends here */
            self.isSubjectSelected = true
            self.onSubCatBtnClick(self.subCatBtn)
        }
        controller.preferredContentSize = CGSize(width: self.screenWidth - 20, height: 200)
        showPopup(controller, sourceView: sender)
        
    }
    var subSubjectListData: [String] = sub_Subjects
    
    override func viewWillAppear(_ animated: Bool) {
        if isExpiredClass {
            isFromExpiredClass = "yes"
        }
    }
    
    
    
    @IBAction func onAddEmailBtnClick(_ sender: Any) {
        if searchEmailTextfield.text != "" {
            guard let email = searchEmailTextfield.text, !email.trimmingCharacters(in: .whitespaces).isEmpty else {
                showMessage(bodyText: "Please enter valid email id.",theme: .warning)
                return
            }
            if !email.isValidEmail() {
                showMessage(bodyText: "Please Enter a valid email id.",theme: .warning)
                return
            }
            storedmail.append(searchEmailTextfield.text?.trim() ?? "" )
            self.searchEmailTextfield.text = nil
            self.collectionView.reloadData()
        }
        
    }
    
    @IBAction func onSubCatBtnClick(_ sender: UIButton) {
        subSubjectListData = []
        
        if catBtn.title(for: .normal) == "Select Category" {
            //  showMessage(bodyText: "Please select category first.",theme: .warning) /*  Commented By Ranjeet on 18th March 2020 */
            showMessage(bodyText: "Select Subject/Topic First",theme: .warning) /*  Updated By Ranjeet on 18th March 2020 */
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
            self.subCatBtn.setTitleColor(UIColor.black, for: .normal) /* Added By Ranjeet on 12th April 2020 */
            /*  Added By Ranjeet on 26th March 2020 - starts here */
            if #available(iOS 13.0, *) {
                self.subCatBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            /*  Added By Ranjeet on 26th March 2020 - ends here */
            isSubjectSelected = false
        }
        
        let controller = ArrayChoiceTableViewController(subSubjectListData){[unowned self ](selectedSubSubject) in
            self.subCatBtn.setTitle(String(describing: selectedSubSubject ), for: .normal)
        }
        controller.preferredContentSize = CGSize(width: self.screenWidth - 20, height: self.screenHeight / 3)
        showPopup(controller, sourceView: sender)
    }
    
    @IBAction func ontimeZoneBtnClick(_ sender: UIButton) {
        let controller = ArrayChoiceTableViewController(timeZoneStringArray){[unowned self] (selectedSubject) in
            self.timeZoneBtn.setTitle(String(describing: selectedSubject ), for: .normal)
            self.timeZoneBtn.setTitleColor(UIColor.black, for: .normal) /* Added By Ranjeet on 12th April 2020 */
            /*  Added By Ranjeet on 26th March 2020 - starts here */
            if #available(iOS 13.0, *) {
                self.timeZoneBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            /*  Added By Ranjeet on 26th March 2020 - ends here */
            self.timeZoneID = self.getTimeZoneID(timeZoneName: selectedSubject)!
            print("timeZoneID = \(self.timeZoneID)")
        }
        controller.preferredContentSize = CGSize(width: self.screenWidth - 20, height: 200)
        showPopup(controller, sourceView: sender)
    }
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    
    @IBAction func onStartDateBtnClicked(_ sender: UIButton) {
        let sb = UIStoryboard.init(name: "DatePopupViewControllerForCreateRequestClassAndRequestForAClass", bundle: nil) /*  Updated By Ranjeet on 23rd March 2020 */
        let popup = sb.instantiateInitialViewController()! as! DatePopupViewControllerForCreateRequestClassAndRequestForAClass /*  Updated By Ranjeet on 23rd March 2020 */
        popup.showTimePicker = false
        popup.actionName = "testStartDate"
        popup.onSave = {[unowned self] (date) in
            sender.setTitle(DateHelper.formattDate(date: date, toFormatt: "MM/dd/yyyy"), for: .normal)
            sender.setTitleColor(UIColor.black, for: .normal) /* Added By Ranjeet on 12th April 2020 */
            /*  Added By Ranjeet on 26th March 2020 - starts here */
            if #available(iOS 13.0, *) {
                sender.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            /*  Added By Ranjeet on 26th March 2020 - ends here */
            self.testStartDate = date
            let utcDate = DateHelper.localToUTC(date: self.testStartDate!, toFormat: "yyyy-MM-dd HH:mm:ss")
            print("utcDate = \(utcDate)")
        }
        self.present(popup,animated: true)
        
        
        
    }
    
    @IBAction func fromBtn(_ sender: UIButton) {
        
        if startTestBtn.title(for: .normal) == "Select Start Date" {
            showMessage(bodyText: "Please select start date first .",theme: .warning)
            return
        }
        
        print("On fromBtn Btn Click")
        let sb = UIStoryboard.init(name: "DatePopupViewControllerForCreateRequestClassAndRequestForAClass", bundle: nil) /*  Updated By Ranjeet on 23rd March 2020 */
        let popup = sb.instantiateInitialViewController()! as! DatePopupViewControllerForCreateRequestClassAndRequestForAClass /*  Updated By Ranjeet on 23rd March 2020 */
        popup.showTimePicker = true
        popup.selectedClassDate = testStartDate!
        popup.onSave = {[unowned self] (date) in
            print("Date = \(date)")
            self.fromTimingDate = date
            let components = Calendar.current.dateComponents([.hour, .minute], from: date)
            let hour = components.hour!
            let minute = components.minute!
            
            var hourString = "\(hour)"
            var minuteString = "\(minute)"
            if hour < 10 {
                hourString = "0\(hour)"
            }
            if minute < 10 {
                minuteString = "0\(minute)"
            }
            /*****************************************Commented by yasodha on 16/4/2020 starts here*******************************************/
            
            //                          self.toTimingDate = date + TimeInterval(2700.0)//added by yasodha
            //                          let componentsTotime = Calendar.current.dateComponents([.hour, .minute], from: date + TimeInterval(2700.0))
            //
            //                          let hourTotime = componentsTotime.hour!
            //                          let minuteTotime = componentsTotime.minute!
            //
            //                          var hourStringTotime = "\(hourTotime)"
            //                          var minuteStringTotime = "\(minuteTotime)"
            //                          if hourTotime < 10 {
            //                              hourStringTotime = "0\(hour)"
            //                          }
            //                          if minuteTotime < 10 {
            //                              minuteStringTotime = "0\(minute)"
            //                          }
            //
            //                          print("hourString = \(hourString)")
            //                          print("minuteString = \(minuteString)")
            //                          self.fromHourString = hourString //added by yasodha
            //                          self.fromMinuteString = minuteString //added by yasodha
            /*****************************************Commented by yasodha on 16/4/2020  ends  here*******************************************/
            
            sender.setTitle("\(hourString):\(minuteString)", for: .normal)
            // self.toBtn.setTitle("\(hourStringTotime):\(minuteStringTotime)", for: .normal)//added by yasodha
            
            
            
            sender.setTitleColor(UIColor.black, for: .normal) /* Added By Ranjeet on 12th April 2020 */
            //  self.toBtn.setTitleColor(UIColor.black, for: .normal)/* Added By Ranjeet on 12th April 2020 */ /* COMMENTED BY YASHODA ON 16TH APRIL 2020 */
            /*  Added By Ranjeet on 26th March 2020 - starts here */
            if #available(iOS 13.0, *) {
                sender.setTitleColor(UIColor.label, for: .normal)
                // self.toBtn.setTitleColor(UIColor.label, for: .normal)//added by yasodha
            } else {
                // Fallback on earlier versions
            }
            /*  Added By Ranjeet on 26th March 2020 - ends here */
            //self.testExpiryDate = date
        }
        self.present(popup,animated: true)
    }
    @IBAction func toBtn(_ sender: UIButton) {
        if startTestBtn.title(for: .normal) == "Select Start Date" {
            showMessage(bodyText: "Please select start date first.",theme: .warning)
            return
        }
        /*Added by yasodha on 6/5/2020 starts here */
        if fromBtn.title(for: .normal) == "From" {
            showMessage(bodyText: "Please select From time.",theme: .warning)
            return
        }        /*Added by yasodha on 6/5/2020 ends here */
        
        let sb = UIStoryboard.init(name: "DatePopupViewControllerForCreateRequestClassAndRequestForAClass", bundle: nil) /*  Updated By Ranjeet on 23rd March 2020 */
        let popup = sb.instantiateInitialViewController()! as! DatePopupViewControllerForCreateRequestClassAndRequestForAClass /*  Updated By Ranjeet on 23rd March 2020 */
        popup.showTimePicker = true
        // popup.selectedClassDate = testStartDate!//commented by yasodha 16/4/2020
        popup.selectedClassDate = fromTimingDate!  /* ADded By Yashoda on 16th April 2020 */ 
        popup.toTimeSelected = true /* ADded By Yashoda on 16th April 2020 */
        popup.onSave = {[unowned self] (date) in
            print("Date = \(date)")
            self.toTimingDate = date
            let components = Calendar.current.dateComponents([.hour, .minute], from: date)
            let hour = components.hour!
            let minute = components.minute!
            
            var hourString = "\(hour)"
            var minuteString = "\(minute)"
            if hour < 10 {
                hourString = "0\(hour)"
            }
            if minute < 10 {
                minuteString = "0\(minute)"
            }
            print("hourString = \(hourString)")
            print("minuteString = \(minuteString)")
            sender.setTitle("\(hourString):\(minuteString)", for: .normal)
            sender.setTitleColor(UIColor.black, for: .normal) /* Added By Ranjeet on 12th April 2020 */
            /*  Added By Ranjeet on 26th March 2020 - starts here */
            if #available(iOS 13.0, *) {
                sender.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            /*  Added By Ranjeet on 26th March 2020 - ends here */
            //self.testExpiryDate = date
        }
        self.present(popup,animated: true)
    }
    var isRecord: Int = 2 //uncheck
    @IBAction func onRecordClassBtnClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            isRecord = 1// check
        }else {
            isRecord = 2// uncheck
        }
    }
    
    @IBAction func onSendInvitationBtnClicked(_ sender: UIButton) {
        
        guard let classTilte = classTitleTF.text, !classTilte.trimmingCharacters(in: .whitespaces).isEmpty else {
            // showMessage(bodyText: "Please enter class name.",theme: .warning) /*  Commented By Ranjeet on 18th March 2020 */
            showMessage(bodyText: "Enter Name of the Class",theme: .warning) /*  Updated By Ranjeet on 18th March 2020 */
            return
        }
        
        if catBtn.title(for: .normal) == "Select Category" {
            // showMessage(bodyText: "Please select category.",theme: .warning) /*  Commented By Ranjeet on 18th March 2020 */
            showMessage(bodyText: "Select Subject/Topic",theme: .warning) /*  Updated By Ranjeet on 18th March 2020 */
            return
        }
        if subCatBtn.title(for: .normal) == "Select Subcategory" {
            // showMessage(bodyText: "Please select subcategory.",theme: .warning) /*  Commented By Ranjeet on 18th March 2020 */
            showMessage(bodyText: "Select SubSubject/SubTopic.",theme: .warning) /*  Updated By Ranjeet on 18th March 2020 */
            
            return
        }
        
        /*  Updated By Ranjeet on 18th March 2020 - starts here */
        if startTestBtn.title(for: .normal) == "Select Start Date" {
            // showMessage(bodyText: "Please select start date .",theme: .warning) /*  Commented By Ranjeet on 18th March 2020 */
            showMessage(bodyText: "Select Start Date",theme: .warning) /*  Updated By Ranjeet on 18th March 2020 */
            return
        }
        if selectArr.isEmpty {
            showMessage(bodyText: "Select one or more grades",theme: .warning)
            return
        }
        /*  Updated By Ranjeet on 18th March 2020 - ends here */
        
        if fromBtn.title(for: .normal) == "From" {
            // showMessage(bodyText: "Please enter start time.",theme: .warning) /*  Commented By Ranjeet on 18th March 2020 */
            showMessage(bodyText: "Enter Class Start Time",theme: .warning) /*  Updated By Ranjeet on 18th March 2020 */
            return
        }
        if toBtn.title(for: .normal) == "To" {
            // showMessage(bodyText: "Please enter end time.",theme: .warning) /*  Commented By Ranjeet on 18th March 2020 */
            showMessage(bodyText: "Enter Class End Time", theme: .warning) /*  Updated By Ranjeet on 18th March 2020 */
            return
        }
        
        if fromTimingDate != nil && toTimingDate != nil {
            
            /* commented by yasodha*/
            //    let order = NSCalendar.current.compare(fromTimingDate!, to: toTimingDate!, toGranularity: .minute)
            //
            //    if order == .orderedAscending {
            //    // date 1 is older
            //    }
            //    else if order == .orderedDescending {
            //    // date 1 is newer
            //    // showMessage(bodyText: "From time can not be greater than To time.",theme: .warning) /*  Commented By Ranjeet on 18th March 2020 */
            //    showMessage(bodyText: "End time is earlier than Start time.",theme: .warning) /*  Updated By Ranjeet on 18th March 2020 */
            //    return
            //    }
            //    else if order == .orderedSame {
            //    // same day/hour depending on granularity parameter
            //    showMessage(bodyText: "From time and To time can not be equal",theme: .warning)
            //    return
            //    }
            /*commented by yasodha */
            
            
            /**********************************Commented by yasodha  on 24/4//2020 *****************************************/
            
            /*Added by yasodha for from & totime validation  */
            //              let components = Calendar.current.dateComponents([.hour, .minute], from: fromTimingDate!)
            //              let frmHour = components.hour!
            //              let frmMinute = components.minute!
            //
            //              let components1 = Calendar.current.dateComponents([.hour, .minute], from: toTimingDate!)
            //              let toHour = components1.hour!
            //              let toMinute = components1.minute!
            //
            //
            //              if frmHour == toHour && frmMinute == toMinute{
            //                   showMessage(bodyText: "From time and To time can not be equal",theme: .warning)
            //                   return
            //              }
            //              if (frmHour == toHour && frmMinute > toMinute) || (frmHour > toHour){
            //                  showMessage(bodyText: "End time is earlier than Start time.",theme: .warning) /*  Updated By Ranjeet on 18th March 2020 */
            //                  return
            //              }
            //
            /*Added by yasodha for from & totime validation end here  */
            /***********************************************Commented by yasodha 24/4/2020***********************************/
            
            
            let distanceBetweenDates: TimeInterval? = toTimingDate?.timeIntervalSince(fromTimingDate!)
            let minBetweenDates = Int((distanceBetweenDates! / 60 ))//minsInAnHour
            /*Added by yasodh on 24/4/2020 starts here*/
            if minBetweenDates == 0{
                showMessage(bodyText: "From time and To time can not be equal",theme: .warning)
                return
            }
            if minBetweenDates < 0 {
                showMessage(bodyText: "End time is earlier than Start time.",theme: .warning)
                return
            }
            if minBetweenDates < 5 {
                showMessage(bodyText: "There should be minimum 5 min difference between Start time and End time",theme: .warning)
                return
            }
            
            /*Added by yasodha on 24/4/2020 ends here */
            
            if minBetweenDates > 60 {
                // showMessage(bodyText: "Duration can not be more than 60 minutes",theme: .warning) /*  Commented By Ranjeet on 18th March 2020 */
                showMessage(bodyText: "Limit the Class time to less than 60 mins",theme: .warning) /*  Updated By Ranjeet on 18th March 2020 */
                
                return
            }
        }
        
        
        
        guard let pointsChargedPerAttandee = pointsChargedPerAttandeeTF.text, !pointsChargedPerAttandee.trimmingCharacters(in: .whitespaces).isEmpty else {
            // showMessage(bodyText: "Please enter points per attandee.",theme: .warning) /*  Commented By Ranjeet on 18th March 2020 */
            showMessage(bodyText: "Enter points that every attendee should pay",theme: .warning) /*  Updated By Ranjeet on 18th March 2020 */
            return
        }
        guard let numberOfAttendees = numberOfAttendeesTF.text, !numberOfAttendees.trimmingCharacters(in: .whitespaces).isEmpty else {
            // showMessage(bodyText: "Please enter number of attendees.",theme: .warning) /*  Commented By Ranjeet on 18th March 2020 */
            showMessage(bodyText: "Enter Maximum number of Attendees for this class",theme: .warning) /*  Updated By Ranjeet on 18th March 2020 */
            
            
            return
        }
        if Int(numberOfAttendees)! < 1 {
            showMessage(bodyText: "Number of attendees can not be less than 1.",theme: .warning)
            return
        }
        if Int(numberOfAttendees)! > 100 {
            showMessage(bodyText: "Number of attendees can not be greater than 100.",theme: .warning)
            return
        }
        //        if Int(numberOfAttendees)! > 20 {
//            showMessage(bodyText: "Number of attendees can not be greater than 20.",theme: .warning)
//            return
//        }
        if isExpiredClass == true
        {
            /************************Commented by yasodha ********************************/

            // let distanceBetweenDates: TimeInterval? = testStartDate!.timeIntervalSince(Date())
            // let minBetweenDates = Int((distanceBetweenDates! / 60 ))//minsInAnHour //minsInAnHour
            // if minBetweenDates < 0 {
            // showMessage(bodyText: "Date should be greater than current date",theme: .warning)
            // return
            // }
            //
            // let distanceBetweenStarAndTimeDate: TimeInterval? = fromTimingDate!.timeIntervalSince(Date())
            // let minfBetweenStarAndTimeDates = Int((distanceBetweenStarAndTimeDate! / 60 ))//minsInAnHour //minsInAnHour
            //
            // if minfBetweenStarAndTimeDates < 0 {
            // showMessage(bodyText: "Please Select Time",theme: .warning)
            // return
            // }

            /************************Commented by yasodha ********************************/

            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let currentDate = formatter.string(from: date)
            let currentDateAndTime = currentDate.split(separator: " ")

            let dateString = DateHelper.localToUTC(date: testStartDate!, toFormat: "yyyy-MM-dd HH:mm:ss")
            let dateParts = dateString.split(separator: " ")

            let distanceBetweenDates: TimeInterval? = testStartDate!.timeIntervalSince(Date())
            let minBetweenDates = Int((distanceBetweenDates! / 60 ))//minsInAnHour //minsInAnHour


            if currentDateAndTime[0] == dateParts[0] {

            let components = Calendar.current.dateComponents([.hour, .minute], from: Date())
            var todayHour = components.hour!
            let todayMinute = components.minute!

            let components1 = Calendar.current.dateComponents([.hour, .minute], from: fromTimingDate!)
            var frmHour = components1.hour!
            let frmMinute = components1.minute!


            let components2 = Calendar.current.dateComponents([.hour, .minute], from: toTimingDate!)
            var toHour = components2.hour!
            let toMinute = components2.minute!

            if todayHour == 0{
            todayHour = 24
            }
            if frmHour == 0{
            frmHour = 24
            }

            if toHour == 0{
            toHour = 24
            }

            if todayHour == frmHour && todayMinute == frmMinute{
            showMessage(bodyText: "There should be minimum 5 min difference between Current time and Class time",theme: .warning)
            return
            }

            if (todayHour == frmHour && todayMinute > frmMinute) || (todayHour > frmHour){
            showMessage(bodyText: "Time should be greater than current time",theme: .warning) /* Updated By Ranjeet on 18th March 2020 */
            return
            }

            if frmHour == toHour && frmMinute == toMinute{
            showMessage(bodyText: "From time and To time can not be equal",theme: .warning)
            return
            }
            if (frmHour == toHour && frmMinute > toMinute) || (frmHour > toHour){
            showMessage(bodyText: "End time is earlier than Start time.",theme: .warning) /* Updated By Ranjeet on 18th March 2020 */
            return
            }
            }else if minBetweenDates < 0 {
            showMessage(bodyText: "Date should be greater than current date",theme: .warning)
            return
            }

        }
        
        // var emailIDS = ""
        // if testModeLbl.text == "Public" {} else {
        // if let mailIDS = emailIDTV.text,!mailIDS.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, mailIDS != textViewEmailIdsHint, !mailIDS.isEmpty {
        // emailIDS = mailIDS
        // }else {
        // showMessage(bodyText: "Please enter atleast one mail id.",theme: .warning)
        // return
        // }
        // }
        
        /* Added By Ranjeet on 11th March 2020 - starts here */
        if testModeLbl.text == "Private"{
            
            /*  Commented By Ranjeet on 19th March 2020 - starts here */
            // if !searchEmailTextfield.text!.isEmpty == false{
            // showMessage(bodyText: "Please Provide mail",theme: .warning) /*  Commented By Ranjeet on 18th March 2020 */
            // showMessage(bodyText: "Enter email ids to invite students for this class",theme: .warning) /*  Updated By Ranjeet on 18th March 2020 */
            // return
            // }
            
            // if !searchEmailTextfield.text!.isValidEmail() {
            // showMessage(bodyText: "Enter valid email ids to invite students for this class",theme: .warning)
            // return
            // }
            /*  Commented By Ranjeet on 19th March 2020 - ends here */
            
            /*  Added By Ranjeet on 19th March 2020 - ends here */
            if storedmail.isEmpty{
                showMessage(bodyText: "Enter email ids to invite students for this class",theme: .warning)
                return
            }
            /*  Added By Ranjeet on 19th March 2020 - ends here */
        }
        /* Added By Ranjeet on 11th March 2020 - ends here */
        
        // let dateString = DateHelper.localToUTC(date: testStartDate!, toFormat: "yyyy-MM-dd HH:mm:ss")
        // let dateParts = dateString.split(separator: " ")
        // let classStartDate = dateParts[0] + "T" + fromBtn.title(for: .normal)! + ":25.700555+00:00"
        // let classEndtime = dateParts[0] + "T" + toBtn.title(for: .normal)! + ":25.700555+00:00"
        //let classStartDate = DateHelper.localToUTC(date: fromTimingDate!, toFormat: "yyyy-MM-dd HH:mm:ss")
        //let classEndtime = DateHelper.localToUTC(date: toTimingDate!, toFormat: "yyyy-MM-dd HH:mm:ss")
        
        
        let dateString = DateHelper.localToUTC(date: testStartDate!, toFormat: "yyyy-MM-dd HH:mm:ss")
        let startDateString = DateHelper.localToUTC(date: fromTimingDate!, toFormat: "yyyy-MM-dd HH:mm:ss")
        let endDateString = DateHelper.localToUTC(date: toTimingDate!, toFormat: "yyyy-MM-dd HH:mm:ss")
        let dateParts = dateString.split(separator: " ")
        let startTimeParts = startDateString.split(separator: " ")
        let endTimeParts = endDateString.split(separator: " ")
        let classStartDate = dateParts[0] + " " + startTimeParts[1]
        let classEndtime = dateParts[0] + " " + endTimeParts[1]
        // add by chandra for for editing the class newly added start here
        if testModeLbl.text == "Public"{
            storedmail.removeAll()
            Oldemailids?.removeAll()
            stringRepresentation = ""
        }else{
            print("PRIVATE GROUP CHANGED")
        }
        let params: [String: Any] = ["title": classTitleTF.text! ,
                                     "timezone": self.timeZoneID,
                                     "date": dateString,
                                     "start_time":fromBtn.title(for: .normal)!,
                                     "end_time":toBtn.title(for: .normal)!,
                                     "isrecord":isRecord,
                                     "num_Subscribed":numberOfAttendeesTF.text!,
                                     "Pay_points": pointsChargedPerAttandeeTF.text!,
                                     "SubjectID": (subjects.firstIndex(where: {$0 == catBtn.title(for: .normal)!})! + 1),
                                     "Sub_SubjectID": getSubSubjectID(subSubjectName: subCatBtn.title(for: .normal)! ) ?? 0,
                                     "userid": UserDefaults.standard.string(forKey: "userID")!,
                                     "UTC_ClassStartDatetime": classStartDate,
                                     "UTC_ClassEndtime": classEndtime,
                                     "SharedType": testModeLbl.text == "Public" ? 1 : 2,
                                     
                                     "EmailIDs": stringRepresentation ?? "","Grades":selectArr.joined(separator: ",")
            
        ]
        print("params = \(params)")
        
        if NetworkReachabilityManager()?.isReachable ?? false {
            //Internet connected,Go ahead
            
            if isEditClass {
                // hitServer(params: params, endPoint: Endpoints.editClassEndPoint + classID! + "/" + userId!, httpMethod: .post, action: "update_class") / Commented By Yashoda on 4th March 2020 /
                /* Added By Yashoda on 4th March 2020 - starts here */
                
                if isExpiredClass == true{
                    isFromExpiredClass = "yes"
                    hitServer(params: params, endPoint: Endpoints.createClass, httpMethod: .post, action: "create_class")
                  //  isExpiredClass = false
                }else if number_Of_Attendees == "0" {//updated by yasodha
                    hitServer(params: params, endPoint: Endpoints.editClassEndPoint + classID! + "/" + userId!, httpMethod: .post, action: "update_class")
                    
                }else{
                    
                    //"api/class/CreateClass"
                    
                    hitServer(params: params, endPoint: Endpoints.createClass, httpMethod: .post, action: "create_class")
                    
                }
                /* Added By Yashoda on 4th March 2020 - ends here */
            }else {
                hitServer(params: params, endPoint: Endpoints.createClass, httpMethod: .post, action: "create_class")
            }
        }else {
            //NO Internet connection, just return
            showMessage(bodyText: "No internet connection",theme: .warning)
        }
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: UITextFieldDelegate
extension AddClassVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == self.numberOfAttendeesTF || textField == self.pointsChargedPerAttandeeTF) {
            let numCharacterSet = CharacterSet(charactersIn:"0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            if !numCharacterSet.isSuperset(of: characterSet) {
                return false
            }
        }
        return true
    }
    
}
extension AddClassVC {
    
    private func hitServer(params: [String:Any],endPoint: String, httpMethod: HTTPMethod, action : String) {
        print(params)
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){[unowned self] result in
            self.stopAnimating()
            switch result {
            case let .success(json, _):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }else {
                    
                    if action == "create_class"{
                        ModelData.shared.isCreatingClassFromExpired = true
                        self.isExpiredClass = false
                        //  showMessage(bodyText: msg,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 1)) /*  Commented By Ranjeet on 19th March 2020 */
                        showMessage(bodyText: "Your class is created",theme: .success,presentationStyle: .center, duration: .seconds(seconds: 1)) /*  Updated By Ranjeet on 19th March 2020 */
                        self.navigationController?.popViewController(animated: true)
                        self.refreshClassList?()
                    }
                    else if action == "update_class"{
                        showMessage(bodyText: msg,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 1))
                        self.navigationController?.popViewController(animated: true)
                        self.refreshClassList?()
                    }
                    else if action == "getClassData"{
                        
                        let classDetailJSON = json["ControlsData"]["ClassInfo"]
                        
                        self.classTitleTF.text = classDetailJSON["title"].stringValue
                        self.catBtn.setTitle(String(describing: subjects[classDetailJSON["SubjectID"].intValue - 1]), for: .normal)
                        self.catBtn.setTitleColor(UIColor.black, for: .normal) /* Added By Ranjeet on 12th April 2020 */
                        /*  Added By Ranjeet on 26th March 2020 - starts here */
                        if #available(iOS 13.0, *) {
                            self.catBtn.setTitleColor(UIColor.label, for: .normal)
                        } else {
                            // Fallback on earlier versions
                        }
                        /*  Added By Ranjeet on 26th March 2020 - ends here */
                        
                        self.subCatBtn.setTitle(String(describing: getSubjectName(with: classDetailJSON["Sub_SubjectID"].intValue)!), for: .normal)
                        self.subCatBtn.setTitleColor(UIColor.black, for: .normal) /* Added By Ranjeet on 12th April 2020 */
                        /*  Added By Ranjeet on 26th March 2020 - starts here */
                        if #available(iOS 13.0, *) {
                            self.subCatBtn.setTitleColor(UIColor.label, for: .normal)
                        } else {
                            // Fallback on earlier versions
                        }
                        /*  Added By Ranjeet on 26th March 2020 - ends here */
                        
                        
                        //prasuna added this
                        self.selectArr = (classDetailJSON["Grades"].stringValue).components(separatedBy: ",")
                        
                        //                                              for (index ,element) in self.selectArr.enumerated()
                        //                                              {
                        //                                              self.tagListView.addTag(element)
                        //                                              self.arrTag[index] = 1
                        //                                              }
                        //end here
                        
                        /*Added by yasodha on 1/5/2020 starts here */
                        for (index ,element) in self.arrTagList.enumerated()
                        {
                            
                            
                            for (index1 ,element1) in self.selectArr.enumerated()
                            {
                                if element == element1{
                                    self.tagListView.addTag(element1)
                                    self.arrTag[index] = 1
                                }
                            }
                        }
                        /*Added by yasodha on 1/5/2020 ends  here */
                        
                        
                        
                        
                        
                        /*Added by yasodha 6/3/2020 starts here */
                        
                        
                        if self.number_Of_Attendees == "0" ||  self.isFromExpiredClass == "yes" {//updated by yasodha
                            self.isFromExpiredClass = ""
                            
                            self.startTestBtn.setTitle(DateHelper.localToUTC(date: classDetailJSON["date"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "MM/dd/yyyy"), for: .normal)
                            self.startTestBtn.setTitleColor(UIColor.black, for: .normal) /* Added By Ranjeet on 12th April 2020 */
                            /*  Added By Ranjeet on 26th March 2020 - starts here */
                            if #available(iOS 13.0, *) {
                                self.startTestBtn.setTitleColor(UIColor.label, for: .normal)
                            } else {
                                // Fallback on earlier versions
                            }
                            /*  Added By Ranjeet on 26th March 2020 - ends here */
                            
                            self.fromBtn.setTitle(classDetailJSON["start_time"].stringValue, for: .normal)//date issue
                            self.fromBtn.setTitleColor(UIColor.black , for: .normal) /* Added By Ranjeet on 12th April 2020 */
                            /*  Added By Ranjeet on 26th March 2020 - starts here */
                            if #available(iOS 13.0, *) {
                                self.fromBtn.setTitleColor(UIColor.label, for: .normal)
                            } else {
                                // Fallback on earlier versions
                            }
                            /*  Added By Ranjeet on 26th March 2020 - ends here */
                            self.toBtn.setTitle(classDetailJSON["end_time"].stringValue, for: .normal)//date issue
                            self.toBtn.setTitleColor(UIColor.black, for: .normal) /* Added By Ranjeet on 12th April 2020 */
                            /*  Added By Ranjeet on 26th March 2020 - starts here */
                            if #available(iOS 13.0, *) {
                                self.toBtn.setTitleColor(UIColor.label, for: .normal)
                            } else {
                                // Fallback on earlier versions
                            }
                            /*  Added By Ranjeet on 26th March 2020 - ends here */
                            
                            self.testStartDate = self.serverToLocal(date: classDetailJSON["date"].stringValue)
                            self.fromTimingDate = self.serverToLocal(date: classDetailJSON["UTC_ClassDatetime"].stringValue)
                            self.toTimingDate = self.serverToLocal(date: classDetailJSON["UTC_ClassEndtime"].stringValue)
                            
                            self.pointsChargedPerAttandeeTF.text = classDetailJSON["Pay_points"].stringValue
                            self.numberOfAttendeesTF.text = classDetailJSON["num_Subscribed"].stringValue//check
                            
                            
                        }else{
                            
                            
                        }
                        
                        
                        /*Added by yasodha 5/3/2020 ends here */
                        let isrecord = classDetailJSON["isrecord"].intValue
                        if isrecord == 1 {
                            self.onRecordClassBtnClick(self.recordClassBtn)
                        }else {
                            
                        }
                        let sharedType = classDetailJSON["SharedType"].intValue
                        if sharedType == 1 {
                            // public class
                        }else {
                            //sharedType == 2 //private class
                            self.onTestModeToggle(self.testModeToggle)
                            self.testModeToggle.isOn = true
                            //                            let UserEmailIds =  classDetailJSON["UserEmailIds"].stringValue
                            let emailids = classDetailJSON["UserEmailIds"].stringValue
                            self.Oldemailids = emailids.split(separator: ";").map { String($0) }
                            self.storedmail = self.Oldemailids ?? []
                            self.collectionView.reloadData()
                            
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
}
extension AddClassVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if [textViewEmailIdsHint].contains(textView.text) {
            textView.text = nil
            textView.textColor = UIColor.black /* Added By Ranjeet on 12th April 2020 */
        }
        /*  Added By Ranjeet on 26th March 2020 - starts here */
        if #available(iOS 13.0, *) {
            textView.textColor = UIColor.label
        } else {
            // Fallback on earlier versions
        }
        /*  Added By Ranjeet on 26th March 2020 - ends here */
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textViewEmailIdsHint
            textView.textColor = UIColor.init(hex: "909191")
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
}
extension AddClassVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsondict?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddClassTableViewCell") as! AddClassTableViewCell
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
        if let celll = tableView.cellForRow(at: indexPath) as? AddClassTableViewCell{
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
                    celll.add.setImage(UIImage(named: "checked"), for: .normal)
                    self.collectionView.reloadData()
                }
            }
            
        }
    }
}
extension AddClassVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storedmail.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let colcell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddClassCollectionViewCell", for: indexPath) as! AddClassCollectionViewCell
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

/* Tag Related - From Here */
extension AddClassVC : TagListVCDelegate {
    func setTagItems(strName: String, index: Int ,Tag:Int) {
        tagListView.addTag(strName)
        selectArr.append(strName)
        arrTag[index] = 1
    }
}

extension AddClassVC : TagListViewDelegate {
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
