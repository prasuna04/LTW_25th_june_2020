//  CreateNewTestVC.swift
//  LTW
//  Created by manjunath Hindupur on 03/07/19.
//  Copyright © 2019 vaayoo. All rights reserved.
import UIKit
import NVActivityIndicatorView
import Alamofire
import SwiftyJSON

let hrs = Array(0...12)
let mins  = Array(0...60)
//let grades = ["1st", "2nd", "3rd","4th", "5th","6th","7th","8th","9th", "10th","11th","12th", "UnderGraduates","Graduates"]//commented by yasodha
let grades = ["1st", "2nd", "3rd","4th", "5th","6th","7th","8th","9th", "10th","11th","12th", "UnderGraduates","Graduates"]//Added by yasodha
let subjects = UserDefaults.standard.array(forKey: "subjectArray") as! [String]
let sub_Subjects = UserDefaults.standard.array(forKey: "sub_SubjectArray1") as! [String]
class CreateNewTestVC: UIViewController,NVActivityIndicatorViewable {
    
    /* Code Added By Chandra on 18th Nov - starts here */
    
    // related search mail add by chandra
    let userId = UserDefaults.standard.string(forKey: "userID")
    var jsondict:[[String:Any]]?
    @IBOutlet weak var searchEmailTextfield: UITextField!
    @IBOutlet weak var addEmailBtn: UIButton!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var ViewSearcTableView: UIView!
    var Oldemailids:[String]?
    var stringRepresentation:String?
    lazy var storedmail = [String]()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionContainerView: UIView!
    @IBOutlet weak var notifyMeLblTopConstrain: NSLayoutConstraint!
    @IBOutlet weak var notifyMeLblTopConstrain2: NSLayoutConstraint!
    @IBOutlet weak var emailIDsContainerViewHight: NSLayoutConstraint!
    
    /* Code Added By Chandra on 18th Nov - till  here */
    
    @IBOutlet weak var testModeLbl: UILabel!
    @IBOutlet weak var testModeToggle: UISwitch!
    @IBOutlet weak var testTilteTF: UITextField!
    @IBOutlet weak var catBtn: UIButton!
    @IBOutlet weak var subCatBtn: UIButton!
    @IBOutlet weak var hrBtn: UIButton!
    @IBOutlet weak var minBtn: UIButton!
    @IBOutlet weak var StartDateBtn: UIButton!
    @IBOutlet weak var gradeBtn: UIButton!
    @IBOutlet weak var noOfQuesTF: UITextField!
    @IBOutlet weak var notifyChkBoxBtn: UIButton!
    @IBOutlet weak var expiryBtn: UIButton!
    
    @IBOutlet weak var emailIDsContainerView: UIView!
    @IBOutlet weak var emailIDTV: UITextView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var submitBtnTopConst: NSLayoutConstraint!//10+55//115,175
    @IBOutlet weak var expiryDateContainerView: UIView!
    @IBOutlet weak var expiryDateBtn: UIButton!
    
    
    @IBOutlet weak var expDateContainerView: UIView!
    @IBOutlet weak var expDateBtn: UIButton!
    @IBOutlet weak var emailContainerTopConstrain: NSLayoutConstraint!
    @IBOutlet weak var editTestQuestionBtn: UIButton!{
        didSet {
            editTestQuestionBtn.backgroundColor = .clear
            editTestQuestionBtn.layer.cornerRadius =  (editTestQuestionBtn.bounds.height - 10) / 2
            editTestQuestionBtn.layer.borderWidth = 1
            editTestQuestionBtn.layer.borderColor = UIColor.init(hex: "2DA9EC").cgColor
            editTestQuestionBtn.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        }
    }
    
    
    var isSubjectSelected = false
    var testStartDate: Date?; var testExpiryDate: Date?
    let textViewEmailIdsHint =  "Enter email id(s) seperated by ;"
    
    
    // Screen width.
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    //For edit test variable
    var isEditTest: Bool?
    var testID: String?
    var isEditQuestionClick  = false
    
    var gradesArray = UserDefaults.standard.array(forKey: "gradesArray") as! [String]
    
    //For copy of the test(Added by yasodha 29/2/2020)
    var isCopyOfTestClick = false
    var parentTestID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchEmailTextfield.layer.cornerRadius = 13.0
        searchEmailTextfield.layer.borderWidth = 2.0
        searchEmailTextfield.layer.borderColor = UIColor.init(hex: "2DA9EC").cgColor
        searchEmailTextfield.leftViewMode = UITextField.ViewMode.always
        /*Added By Chandra On 18th Nov 2019  - from here */
        searchEmailTextfield.useUnderline()
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
        
        // add by chandra related searchmail
        emailIDsContainerViewHight.constant = 0
        emailIDsContainerView.isHidden = true
        notifyMeLblTopConstrain.constant = 0
        notifyMeLblTopConstrain2.constant = 36
        // add by chandra for collection view hidden
        collectionContainerView.isHidden = true
        self.ViewSearcTableView.isHidden = true
        collectionContainerView.isHidden = true
        
        self.ViewSearcTableView.frame = CGRect(x: 15, y: 96, width: self.view.frame.size.width-30, height: self.view.frame.size.height/4)
        self.view.addSubview(self.ViewSearcTableView)
        searchEmailTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        /* Added By Chandra On 18th Nov 2019  - till here */
        
        submitBtnTopConst.constant = 10
        navigationItem.title = "Create New Test"
        noOfQuesTF.delegate = self
        emailIDTV.delegate = self
        emailIDTV.text = textViewEmailIdsHint
        emailIDTV.textColor = UIColor.init(hex: "909191")
        editTestQuestionBtn.isHidden = true
        if isEditTest != nil &&  isEditTest! == true {
            
            editTestQuestionBtn.isHidden = false
            noOfQuesTF.isUserInteractionEnabled = false
            if UserDefaults.standard.integer(forKey: "noOfAttentees") == 0 {//Added by yasodha 24/2/2020
                submitBtn.setTitle(" Update ", for: .normal)
                hitServer(params: [:], endPoint: "\(Endpoints.getTestInfoEndPoint)\(testID!)", dueToAction: "get_test_data", method: .get)
                navigationItem.title = "Edit Test"
                
            }else {
                submitBtn.setTitle(" Create Copy ", for: .normal)
                hitServer(params: [:], endPoint: "\(Endpoints.getTestInfoEndPoint)\(testID!)", dueToAction: "get_test_data", method: .get)
                navigationItem.title = " Create Copy ".uppercased()
                
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /* Added by yasodha on 28/1/2020 */
        if isEditTest != nil && isEditTest! == true {
            if UserDefaults.standard.integer(forKey: "noOfAttentees") == 0 {
                editTestQuestionBtn.isHidden = false
                editTestQuestionBtn.isUserInteractionEnabled = true
            }else{
                editTestQuestionBtn.isHidden = true
                editTestQuestionBtn.isUserInteractionEnabled = false
            }
            
        }
         /*Added by yasodha on 28/1/2020*/
        
    }
    /* Code Added By Chandra on 18th-Nov-2019 - starts here */
    // add by chandra related to the searhmail
    @objc func textFieldDidChange(_ textField: UITextField){
        let searchText = searchEmailTextfield.text!
        print("Search key = \(searchText)")
        if searchText.count >= 3 {
            let encodeSearchKey = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            print("encodeSearchKey = \(encodeSearchKey)")
            let Id = 1
            let emailurl = Endpoints.fetchEmailID + (userId ?? "") + "/\(Id)?searchText=" + "\(encodeSearchKey)" /* Added By Chandra on 3rd Jan 2020 */

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
    @objc func removeMail(sender: UIButton){
        let index = sender.tag
        storedmail.remove(at: index)
        stringRepresentation = storedmail.joined(separator:";")
        print(storedmail)
        self.collectionView.reloadData()
        self.tableview.reloadData()
        // cell.add.setImage(UIImage(named: "unchecked"), for: .normal)
    }
    
    /* Code Added By Chandra on 18th-Nov-2019 -ends here */
    
    @IBAction func onTestModeToggle(_ sender: UISwitch) {
        let newTestMode = testModeLbl.text == "Public" ? "Private" : "Public"
        testModeLbl.text = newTestMode
        if testModeLbl.text == "Public" {
            emailIDsContainerView.isHidden = true
            /* Added By Chandra on 18th Nov 2019 - starts here */
            emailIDsContainerViewHight.constant = 0
            notifyMeLblTopConstrain.constant = 0
            notifyMeLblTopConstrain2.constant = 36
            collectionContainerView.isHidden = true
            /* Added By Chandra on 18th Nov 2019 - ends  here */
            if expiryBtn.isSelected {
                submitBtnTopConst.constant = 80
            }else {
                submitBtnTopConst.constant = 10
            }
            
        }else {
            emailIDsContainerView.isHidden = false
            submitBtnTopConst.constant = 180
            
            /* Added By Chandra on 18th Nov 2019 - starts here */
            
            emailIDsContainerViewHight.constant = 0
            collectionContainerView.isHidden = false
            notifyMeLblTopConstrain2.constant = 150
            notifyMeLblTopConstrain.constant = 119
            emailIDsContainerView.isHidden = true
            submitBtnTopConst.constant = 80
            /* Added By Chandra on 18th Nov 2019 - ends  here */
        }
    }
    @IBAction func onCatBtnClick(_ sender: UIButton) {
        
        let controller = ArrayChoiceTableViewController(subjects){[unowned self] (selectedSubject) in
            self.catBtn.setTitle(String(describing: selectedSubject ), for: .normal)
            self.catBtn.setTitleColor(UIColor.black, for: .normal) /* UnCommented By Ranjeet on 12th April 2020 */
           
            /* Updated By Ranjeet on 3rd April 2020 - starts here */
            if #available(iOS 13.0, *) {
                self.catBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            /* Updated By Ranjeet on 3rd April 2020 - ends here */
            
            self.isSubjectSelected = true
            self.onSubCatBtnClick(self.subCatBtn)
        }
        controller.preferredContentSize = CGSize(width: self.screenWidth - 20, height: 200)
        showPopup(controller, sourceView: sender)
        
    }
    var subSubjectListData: [String] = sub_Subjects
    @IBAction func onSubCatBtnClick(_ sender: UIButton) {
        subSubjectListData = []
        
        if catBtn.title(for: .normal) == "Select Category" {
            showMessage(bodyText: "Please select category first.",theme: .warning)
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
            self.subCatBtn.setTitleColor(UIColor.black, for: .normal)/* unCommented By Ranjeet on 12th April 2020 */
          
            /* Updated By Ranjeet on 3rd April 2020 - starts here */
            if #available(iOS 13.0, *) {
                self.subCatBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
             /* Updated By Ranjeet on 3rd April 2020 - ends here */
            
            isSubjectSelected = false
        }
        
        let controller = ArrayChoiceTableViewController(subSubjectListData){[unowned self ](selectedSubSubject) in
            self.subCatBtn.setTitle(String(describing: selectedSubSubject ), for: .normal)
        }
        controller.preferredContentSize =  CGSize(width: self.screenWidth - 20, height: self.screenHeight / 3)
        showPopup(controller, sourceView: sender)
    }
    
    @IBAction func onHrBtnClick(_ sender: UIButton) {
        let inputArr = sender.tag == 1 ? hrs : mins
        let controller = ArrayChoiceTableViewController(inputArr){ (minHr) in
            if sender.tag == 1 {
                self.hrBtn.setTitle(String(describing: minHr), for: .normal)
                print("Month index = \((hrs.index(of: minHr)! + 1))")
                self.hrBtn.setTitleColor(UIColor.black, for: .normal) /* UnCommented  By Ranjeet on 12th April 2020 */
                /* Updated By Ranjeet on 3rd April 2020 - starts  here */
                if #available(iOS 13.0, *) {
                    self.hrBtn.setTitleColor(UIColor.label, for: .normal)
                } else {
                    // Fallback on earlier versions
                }
                /* Updated By Ranjeet on 3rd April 2020 - ends here */
            } else if sender.tag == 2 {
                self.minBtn.setTitle(String(describing: minHr), for: .normal)
                self.minBtn.setTitleColor(UIColor.black, for: .normal) /* UnCommented  By Ranjeet on 12th April 2020 */
                
                /* Updated By Ranjeet on 3rd April 2020 - starts  here */
                if #available(iOS 13.0, *) {
                    self.minBtn.setTitleColor(UIColor.label, for: .normal)
                } else {
                    // Fallback on earlier versions
                }
                /* Updated By Ranjeet on 3rd April 2020 - ends here */
            }
        }
        controller.preferredContentSize = CGSize(width: 75, height: 200)
        showPopup(controller, sourceView: sender)
    }
    
    
    @IBAction func onMinBtnClick(_ sender: Any) {
    }
    
    @IBAction func onStartSateBtnClick(_ sender: UIButton) {
        let sb = UIStoryboard.init(name: "DatePopupViewController", bundle: nil)
        let popup = sb.instantiateInitialViewController()! as! DatePopupViewController
        popup.showTimePicker = false
        // if sender.tag == 8 {  //start btn
        popup.actionName = "testStartDate"
        popup.onSave = {[unowned self] (date) in
            sender.setTitle(DateHelper.formattDate(date: date, toFormatt: "MM/dd/yyyy"), for: .normal)
            sender.setTitleColor(UIColor.black, for: .normal) /* UnCommented  By Ranjeet on 12th April 2020 */
          /* Updated By Ranjeet on 3rd April 2020 - starts  here */
            if #available(iOS 13.0, *) {
                sender.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            /* Updated By Ranjeet on 3rd April 2020 - ends  here */
            self.testStartDate = date
        }
            self.present(popup,animated: true)
        
    }
    
    @IBAction func onExpDateBtnClick(_ sender: UIButton) {
        print("On Expire Btn Click")
        let sb = UIStoryboard.init(name: "DatePopupViewController", bundle: nil)
        let popup = sb.instantiateInitialViewController()! as! DatePopupViewController
        popup.showTimePicker = false
        popup.actionName = "testStartDate"
        popup.onSave = {[unowned self] (date) in
            sender.setTitle(DateHelper.formattDate(date: date, toFormatt: "MM/dd/yyyy"), for: .normal)
            sender.setTitleColor(UIColor.black, for: .normal)/* UnCommented  By Ranjeet on 12th April 2020 */
           
            /* Updated By Ranjeet on 3rd April 2020 - starts  here */
            if #available(iOS 13.0, *) {
                sender.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
             /* Updated By Ranjeet on 3rd April 2020 - ends  here */
            self.testExpiryDate = date
        }
        self.present(popup,animated: true)
    }
    @IBAction func onExpiryBtnClick(_ sender: UIButton) {
        let sb = UIStoryboard.init(name: "DatePopupViewController", bundle: nil)
        let popup = sb.instantiateInitialViewController()! as! DatePopupViewController
        popup.showTimePicker = false
        //popup.actionName = "dateOfBirth"
        popup.onSave = {[unowned self] (date) in
            sender.setTitle(DateHelper.formattDate(date: date, toFormatt: "MM/dd/yyyy"), for: .normal)
            sender.setTitleColor(UIColor.black, for: .normal)/* UnCommented  By Ranjeet on 12th April 2020 */
          
            /* Updated By Ranjeet on 3rd April 2020 - starts  here */
            if #available(iOS 13.0, *) {
                sender.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
             /* Updated By Ranjeet on 3rd April 2020 - ends  here */
            self.testExpiryDate = date
            
        }
    }
    @IBAction func onGradeBtnClick(_ sender: UIButton) {
        let controller = ArrayChoiceTableViewController(grades){[unowned self ](selectedGrade) in
            self.gradeBtn.setTitle(String(describing: selectedGrade), for: .normal)
            self.gradeBtn.setTitleColor(UIColor.black, for: .normal)/* Commented  By Ranjeet on 12th April 2020 */
             /* Updated By Ranjeet on 3rd April 2020 - starts  here */
            if #available(iOS 13.0, *) {
                self.gradeBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
              /* Updated By Ranjeet on 3rd April 2020 - ends  here */
        }
        controller.preferredContentSize = CGSize(width: 80, height: 200)
        showPopup(controller, sourceView: sender)
    }
    
    @IBAction func onNotifyCheckBtnClick(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func onExpiryChkBtnClick(_ sender: UIButton) {
        
        //when both enable 175
        // when single enable  110 + 10 = 120
        //when both hidden  10
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            expDateBtn.isUserInteractionEnabled  = true;  expDateContainerView.isHidden = false
            if testModeLbl.text == "Public" {
                submitBtnTopConst.constant = 80
            }else {
                emailContainerTopConstrain.constant = 55
            }
        }else {
            expDateContainerView.isHidden = true
            
            if testModeLbl.text == "Private" {
                //submitBtnTopConst.constant = 150
                emailContainerTopConstrain.constant = 10
            }else {
                submitBtnTopConst.constant = 10
            }
        }
        
    }
    
    @IBAction func onSubmitBtnClick(_ sender: UIButton) {
        if isEditTest != nil &&  isEditTest! == true {
            isEditQuestionClick = false
        }
        validiate()
        
    }
    
    @IBAction func onEditTestQuestionClick(_ sender: UIButton) {
        print("Edit Test question click")
        isEditQuestionClick = true
        validiate()
        
    }
    
    private  func validiate() {
        guard let testTilte = testTilteTF.text, !testTilte.trimmingCharacters(in: .whitespaces).isEmpty else {
            showMessage(bodyText: "Please Enter Test Title.",theme: .warning)
            return
        }
        if catBtn.title(for: .normal) == "Select Category" {
            showMessage(bodyText: "Please select Topic.",theme: .warning)
            return
        }
        if subCatBtn.title(for: .normal) == "Select Subcategory" {
            showMessage(bodyText: "Please select subcategory.",theme: .warning)
            return
        }
         if testStartDate == nil{
                   showMessage(bodyText: "Select Date to Publish the Test",theme: .warning)//yasodha
                   return
               }
//        if hrBtn.title(for: .normal) == "hr" {
//            showMessage(bodyText: "Select Time Duration",theme: .warning)
//            return
//        }else
        
        /*Added by yasodha 3/4/2020 starts here */
                if hrBtn.title(for: .normal) == "hr" {
                    hrBtn.setTitle("0",for: .normal)
                   
               }
        /*Added by yasodha 3/4/2020 ends here */
        
        if minBtn.title(for: .normal) == "min" {
            showMessage(bodyText: "Select Time Duration",theme: .warning)
            return
        }
        else if StartDateBtn.title(for: .normal) == "Select Start Date" {
            showMessage(bodyText: "Select Time Duration",theme: .warning)
            return
        }
        else if gradeBtn.title(for: .normal) == "Select Grade" {
            showMessage(bodyText: "Select Grade level.",theme: .warning)
            return
        }
        guard let noOfQuestion = noOfQuesTF.text, !noOfQuestion.trimmingCharacters(in: .whitespaces).isEmpty else {
            showMessage(bodyText: "Enter number of Questions",theme: .warning)
            return
        }
        /*Added by yasodha 16/4/2020 starts here */
        if hrBtn.title(for: .normal) == "0" && minBtn.title(for: .normal) == "0"{
            showMessage(bodyText: "Select Time Duration",theme: .warning)
            return
        }
        
        /*Added by yasodha 16/4/2020 ends here */
        
        /* Added By Yashoda on 27th Jan 2020 - starts here */
        if Int(noOfQuestion)! == 0 {
                    showMessage(bodyText: "Enter number of Questions",theme: .warning)//yasodha
                    return
                }
   /* Added By Yashoda on 27th Jan 2020 - ends  here */
     
        
         if Int(noOfQuestion)! > 50 {
                   showMessage(bodyText: "Number of questions can not be more than 50 ",theme: .warning)
                   return
         }
        
        
        
        if !expDateContainerView.isHidden && expDateBtn.title(for: .normal) == "Select Expiry Date" {
            showMessage(bodyText: "Please enter expiry date.",theme: .warning)
            return
        }
        
        if testExpiryDate != nil && testStartDate != nil {
        let order = NSCalendar.current.compare(testStartDate!, to: testExpiryDate!, toGranularity: .day)
            
            if order == .orderedAscending {
                // date 1 is older
            }
            else if order == .orderedDescending {
                // date 1 is newer
                showMessage(bodyText: "Test start time can not be greater than test expiry time .",theme: .warning)
                return
            }
            else if order == .orderedSame {
                // same day/hour depending on granularity parameter
                
                showMessage(bodyText: "Test start time can not be equal to test expiry time .",theme: .warning)
                return
            }
        }
              if NetworkReachabilityManager()?.isReachable ?? false {
            let startDate = DateHelper.localToUTC(date: testStartDate!, toFormat: "yyyy-MM-dd HH:mm:ss")
            var endDate: String = "2029-08-08 00:00:00"// some dummy date as Manju said
            if testExpiryDate != nil {
                endDate = DateHelper.localToUTC(date: testExpiryDate!, toFormat: "yyyy-MM-dd HH:mm:ss")
            }
            let param:[String: Any] = [
                "UserID": UserDefaults.standard.string(forKey: "userID")!,
                "Duration": "\(UInt(hrBtn.title(for: .normal)!)!):\(UInt(minBtn.title(for: .normal)!)!)",
                "StartDate": startDate,
                "ExpiryDate":endDate,
                "IsExpiry": expiryBtn.isSelected,
                "TestTitle": testTilteTF.text!,
                "SubjectID": (subjects.firstIndex(where: {$0 == catBtn.title(for: .normal)!})! + 1),
                "Sub_SubjectID": getSubSubjectID(subSubjectName: subCatBtn.title(for: .normal)! ) ?? 0 ,
                "GradeID":(grades.firstIndex(where: {$0 == gradeBtn.title(for: .normal)!})! + 1),
                "SharedType": testModeLbl.text == "Public" ? 1 : 2,
                "IsNotifyAnswer": notifyChkBoxBtn.isSelected,
                "QuestionsCount": noOfQuesTF.text!,
                //  "EmailID": emailIDS /*Commented By Chandra on 18th Oct 2019 */
                "EmailID": stringRepresentation ?? "" /* Added  By Chandra on 18th Oct 2019 */
            ]
            if isEditTest != nil &&  isEditTest! == true {
                
                if isEditQuestionClick == false {
                    
                    if UserDefaults.standard.integer(forKey: "noOfAttentees") == 0{
                    hitServer(params: param, endPoint: "\(Endpoints.editTestEndPoint)\(testID!)", dueToAction: "update_test", method: .post)
                    }else{
                          isCopyOfTestClick = true
                          parentTestID = testID
                          hitServer(params: param, endPoint: Endpoints.createTest, dueToAction: "create_test", method: .post)
                        
                    }
                    
                }else {
                    hitServer(params: param, endPoint: "\(Endpoints.editTestEndPoint)\(testID!)", dueToAction: "create_test", method: .post)//commented by yasodha
                    
                }
                
            }else {
                hitServer(params: param, endPoint: Endpoints.createTest, dueToAction: "create_test", method: .post)
            }
        }else {
            //NO Internet connection, just return
            showMessage(bodyText: "No internet connection",theme: .warning)
        }
        
        
    }
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    
    private func hitServer(params: [String:Any],endPoint: String, dueToAction action: String,method: HTTPMethod) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: method, dueToAction: action){[unowned self] result in
            self.stopAnimating()
            switch result {
            case let .success(json, _):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }else {
                    if self.isEditTest != nil &&  self.isEditTest! == true {
                        
                    }else {
                        // showMessage(bodyText: msg,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 1))
                    }
                    if action == "create_test" {
                        
                        if  self.isEditQuestionClick == true {
                            
                            let addQuesVC = self.storyboard?.instantiateViewController(withIdentifier: "createQues") as! AddTestQuestionVC
                            addQuesVC.testID = self.testID!
                            addQuesVC.numberOfQues = Int(self.noOfQuesTF.text!)!
                            addQuesVC.isEditTestQuestion = true
                            self.navigationController?.pushViewController(addQuesVC, animated: true)
                        }else if self.isCopyOfTestClick == true {
                            let addQuesVC = self.storyboard?.instantiateViewController(withIdentifier: "createQues") as! AddTestQuestionVC
                            addQuesVC.testID = json["ControlsData"]["TestID"].stringValue
                            addQuesVC.numberOfQues = Int(self.noOfQuesTF.text!)!
                            addQuesVC.parentTestID = self.parentTestID
                            addQuesVC.isCopyOfTestClick = true
                            self.navigationController?.pushViewController(addQuesVC, animated: true)
                        }else {
                            let addQuesVC = self.storyboard?.instantiateViewController(withIdentifier: "createQues") as! AddTestQuestionVC
                            addQuesVC.testID = json["ControlsData"]["TestID"].stringValue
                            addQuesVC.numberOfQues = Int(self.noOfQuesTF.text!)!
                            self.navigationController?.pushViewController(addQuesVC, animated: true)
                        }
                        
                    }
                    else if action == "get_test_data" {
                        print("Got test data")
                        self.testTilteTF.text =  json["ControlsData"]["TestInfo"]["TestTitle"].stringValue
                        
                        self.catBtn.setTitle(String(describing: subjects[json["ControlsData"]["TestInfo"]["SubjectID"].intValue - 1]), for: .normal)
                        self.catBtn.setTitleColor(UIColor.black, for: .normal)/* unCommented By Ranjeet on 12th April 2020 */
                     
                       /* Updated By Ranjeet on 3rd April 2020 - starts here */
                       if #available(iOS 13.0, *) {
                           self.catBtn.setTitleColor(UIColor.label, for: .normal)
                       } else {
                           // Fallback on earlier versions
                       }
                        /* Updated By Ranjeet on 3rd April 2020 - ends here */

                        self.subCatBtn.setTitle(String(describing: getSubjectName(with: json["ControlsData"]["TestInfo"]["Sub_SubjectID"].intValue)!), for: .normal)
                        self.subCatBtn.setTitleColor(UIColor.black, for: .normal)/* unCommented By Ranjeet on 12th April 2020 */
                        
                          /* Updated By Ranjeet on 3rd April 2020 - starts here */
                          if #available(iOS 13.0, *) {
                              self.subCatBtn.setTitleColor(UIColor.label, for: .normal)
                          } else {
                              // Fallback on earlier versions
                          }
                           /* Updated By Ranjeet on 3rd April 2020 - ends here */

                        let duration = json["ControlsData"]["TestInfo"]["Duration"].stringValue
                        let duartionParts = duration.split(separator: ":")
                        if duartionParts.count > 1 {
                            self.hrBtn.setTitle(String(describing: duartionParts[0]), for: .normal)
                            self.minBtn.setTitle(String(describing: duartionParts[1]), for: .normal)
                            self.hrBtn.setTitleColor(UIColor.black, for: .normal) /* UnCommented By Ranjeet on 3rd April 2020 */
                            
                            /* Update By Ranjeet on 3rd April 2020  - starts here */
                            if #available(iOS 13.0, *) {
                                self.hrBtn.setTitleColor(UIColor.label, for: .normal)
                            } else {
                                // Fallback on earlier versions
                            } /* Update By Ranjeet on 3rd April 2020  - ends here */
                            
                            self.minBtn.setTitleColor(UIColor.black, for: .normal) /* UnCommented By Ranjeet on 3rd April 2020 */
                            
                            /* Update By Ranjeet on 3rd April 2020  - starts here */
                            if #available(iOS 13.0, *) {
                                self.minBtn.setTitleColor(UIColor.label, for: .normal)
                            } else {
                                // Fallback on earlier versions
                            }
                            /* Update By Ranjeet on 3rd April 2020  - ends here */
                        }
                        
                       // self.StartDateBtn.setTitle(DateHelper.localToUTC(date: json["ControlsData"]["TestInfo"]["StartDate"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "MM/dd/yyyy"), for: .normal)
                        self.StartDateBtn.setTitleColor(UIColor.black, for: .normal) /* UnCommented By Ranjeet on 3rd April 2020 */
                        
                        /* Added by yasodha 3/4/2020 starts here*/
                        
                        
                        var fromTimingDate: Date?
                        fromTimingDate = self.serverToLocal(date: json["ControlsData"]["TestInfo"]["StartDate"].stringValue)
                        let formatter = DateFormatter()
                        formatter.dateFormat = "MM/dd/yyyy HH:mm"
                        let fromTimingDateString = formatter.string(from: fromTimingDate!)
                        let startTimeParts = fromTimingDateString.split(separator: " ")
                        
                        self.StartDateBtn.setTitle ("\(startTimeParts[0])", for: .normal)
                        self.StartDateBtn.setTitleColor(UIColor.black, for: .normal)
                        /* Added By Ranjeet on 12th April 2020 - starts here (Please don't replace or remove it )*/
                        if #available(iOS 13.0, *) {
                            self.StartDateBtn.setTitleColor(UIColor.label, for: .normal)
                        } else {
                            // Fallback on earlier versions
                        }
                          /* Added By Ranjeet on 12th April 2020 - ends here (Please don't replace or remove it )*/
                        self.testStartDate = formatter.date(from: fromTimingDateString)
                        
                        
                        
                        
                        
                        /*Added by yasodha 3/4/2020 ends here */
                        
                        
                        /* Update By Ranjeet on 3rd April 2020  - starts  here */
                        if #available(iOS 13.0, *) {
                            self.StartDateBtn.setTitleColor(UIColor.label, for: .normal)
                        } else {
                            // Fallback on earlier versions
                        }
                        /* Update By Ranjeet on 3rd April 2020  - ends here */
                        
                        //   self.testStartDate = DateHelper.getDateObj(from: json["ControlsData"]["TestInfo"]["StartDate"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss")
                        let isExpiry = json["ControlsData"]["TestInfo"]["IsExpiry"].intValue
                        
                        if isExpiry  == 0 {
                            
                        }else {
                            //isExpiry  == 1
                            self.onExpiryChkBtnClick(self.expiryBtn)
                            // self.expDateBtn.setTitle(DateHelper.localToUTC(date: json["ControlsData"]["TestInfo"]["ExpiryDate"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "MM/dd/yyyy"), for: .normal)
                            //self.expDateBtn.setTitleColor(UIColor.black, for: .normal)/* Commented By Ranjeet on 3rd April 2020 */
                            
                            /*Added by yasodha 3/4/2020 starts here */
                            var fromTimingDate: Date?
                            fromTimingDate = self.serverToLocal(date: json["ControlsData"]["TestInfo"]["ExpiryDate"].stringValue)
                            let formatter = DateFormatter()
                            formatter.dateFormat = "MM/dd/yyyy HH:mm"
                            let fromTimingDateString = formatter.string(from: fromTimingDate!)
                            let expiryDate = fromTimingDateString.split(separator: " ")
                            
                            self.expDateBtn.setTitle ("\(expiryDate[0])", for: .normal)
                            self.expDateBtn.setTitleColor(UIColor.black, for: .normal)
                            self.testExpiryDate = formatter.date(from: fromTimingDateString)
                            /*Added by yasodha 3/4/2020 ends here */
                            
                            
                            
                            /* Update By Ranjeet on 3rd April 2020  - starts here */
                            if #available(iOS 13.0, *) {
                                self.expDateBtn.setTitleColor(UIColor.label, for: .normal)
                            } else {
                                // Fallback on earlier versions
                            }
                            /* Update By Ranjeet on 3rd April 2020  - ends here */
                            
                         //   self.testExpiryDate = DateHelper.getDateObj(from: json["ControlsData"]["TestInfo"]["ExpiryDate"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss")
                            
                        }
                        let IsNotifyAns = json["ControlsData"]["TestInfo"]["IsNotifyAns"].intValue
                        if IsNotifyAns == 0 {
                            
                        }else {
                            self.onNotifyCheckBtnClick(self.notifyChkBoxBtn)
                        }
                        let grade = self.gradesArray[json["ControlsData"]["TestInfo"]["GradeID"].intValue - 1]
                        self.gradeBtn.setTitle(String(describing: grade), for: .normal)
                        self.gradeBtn.setTitleColor(UIColor.black, for: .normal) /* Commented By Ranjeet on 3rd April 2020 */
                        /* Update By Ranjeet on 3rd April 2020  - starts here */
                        if #available(iOS 13.0, *) {
                            self.gradeBtn.setTitleColor(UIColor.label, for: .normal)
                        } else {
                            // Fallback on earlier versions
                        }
                        /* Update By Ranjeet on 3rd April 2020  - ends here */
                        
                        /* Added  By Yashoda on 27th Jan 2020 - starts  here */
                        if json["ControlsData"]["TestInfo"]["QuestionsCount"].int == 0 {
                            self.noOfQuesTF.textColor = UIColor.black /* Commented By Ranjeet on 3rd April 2020 */
                            /* Update By Ranjeet on 3rd April 2020  - starts here */
                            if #available(iOS 13.0, *) {
                                self.noOfQuesTF.textColor = UIColor.label
                            } else {
                                // Fallback on earlier versions
                            }
                            /* Update By Ranjeet on 3rd April 2020  - starts here */
                            
                            self.noOfQuesTF.isUserInteractionEnabled = true
                            self.noOfQuesTF.text = json["ControlsData"]["TestInfo"]["QuestionsCount"].stringValue
                            
                        }else{
                           // self.noOfQuesTF.textColor = UIColor.gray /* Commented By Ranjeet on 13th April 2020 */
                             self.noOfQuesTF.textColor = UIColor.black /* Added By Ranjeet on 13th April 2020 */
                            
                            /* Added By Ranjeet on 13th April 2020 - starts here(Please Don't remove) */
                            if #available(iOS 13.0, *) {
                                self.noOfQuesTF.textColor = UIColor.label
                            } else {
                                // Fallback on earlier versions
                            }
                            /* Added By Ranjeet on 13th April 2020 - ends here (Please Don't remove) */
                            self.noOfQuesTF.text = json["ControlsData"]["TestInfo"]["QuestionsCount"].stringValue
                            
                        }
            
                        if self.isEditTest != nil && self.isEditTest! == true {
                            
                            if UserDefaults.standard.integer(forKey: "noOfAttentees") == 0 {
                               
                            }
                            else{
                               // self.noOfQuesTF.textColor = UIColor.gray /* Commented By Ranjeet on 13th April 2020 */
                                 self.noOfQuesTF.textColor = UIColor.black /* Added By Ranjeet on 13th April 2020 */
                                   /* Added By Ranjeet on 13th April 2020 - starts here (Please Don't remove) */
                                if #available(iOS 13.0, *) {
                                    self.noOfQuesTF.textColor = UIColor.label
                                } else {
                                    // Fallback on earlier versions
                                }
                                   /* Added By Ranjeet on 13th April 2020 - ends here (Please Don't remove)*/
                                self.noOfQuesTF.text = json["ControlsData"]["TestInfo"]["QuestionsCount"].stringValue
                            }
                        }
                        
                        /*Added by yasodha 24/2/2020 ends here */
                 
                        
                        let sharedType = json["ControlsData"]["TestInfo"]["SharedType"].intValue
                        if sharedType == 1 {
                            // public test
                        }else {
                            //sharedType == 2 //private test
                            self.onTestModeToggle(self.testModeToggle)
                            self.testModeToggle.isOn = true
                            
                            /* Added By Chandra on 5th Dec 2019 - starts here */
                            let emailids = json["ControlsData"]["TestInfo"]["UserEmailIds"].stringValue
                            self.Oldemailids = emailids.split(separator: ";").map { String($0) }
                            self.storedmail = self.Oldemailids ?? []
                            self.collectionView.reloadData()
                            /* Added By Chandra on 5th Dec 2019 - ends here */
                        }
                        
                        
                    }else if action == "update_test" {
                self.navigationController?.popViewController(animated: true)
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
extension Int {
    func square() -> Int {
        return self * self
    }
    
}
extension CreateNewTestVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if [textViewEmailIdsHint].contains(textView.text) {
            textView.text = nil
        }
          /* Added By Ranjeet on 12th April 2020 - ends here (Please don't replace or remove it )*/
        textView.textColor = UIColor.black
        /* */
        if #available(iOS 13.0, *) {
            textView.textColor = UIColor.label
        } else {
            // Fallback on earlier versions
        }
     /* Added By Ranjeet on 12th April 2020 - ends here (Please don't replace or remove it )*/
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

// MARK: UITextFieldDelegate
extension CreateNewTestVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == self.noOfQuesTF) {
            let numCharacterSet = CharacterSet(charactersIn:"0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            if !numCharacterSet.isSuperset(of: characterSet) {
                return false
            }
        }
        return true
    }
    
    
}

/* Code Added By Chandra on 18th Nov - starts here */

extension CreateNewTestVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsondict?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateNewTestTableViewCell") as! CreateNewTestTableViewCell
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
        if let celll = tableView.cellForRow(at: indexPath) as? CreateNewTestTableViewCell{
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
extension CreateNewTestVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storedmail.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let colcell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreateNewTestCollectionViewCell", for: indexPath) as! CreateNewTestCollectionViewCell
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
        // made change in hight 30 to 33
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

/* Code Added By Chandra on 18th Nov - ends here */
/*Added by yasodha 3/4/2020 starts here */
extension CreateNewTestVC {
   func serverToLocal(date:String) -> Date? {
   let dateFormatter = DateFormatter()
   dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
   dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
   let localDate = dateFormatter.date(from: date)

   return localDate
   }
}

   /*Added by yasodha 3/4/2020 ends here */

