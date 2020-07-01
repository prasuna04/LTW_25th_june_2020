//  CreateNewClassForTeacherNotificationVC.swift
//  LTW
//  Created by Ranjeet Raushan on 25/02/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView

class CreateNewClassForTeacherNotificationVC: UIViewController , NVActivityIndicatorViewable{
    @IBOutlet weak var gradesBtn: UIButton!
    @IBOutlet weak var boardsBtn: UIButton!
    @IBOutlet weak var subjectBtn: UIButton!
    @IBOutlet weak var subSubjectBtn: UIButton!
    @IBOutlet weak var classTitleTF: UITextField!
    @IBOutlet weak var startDateOfCreateClassBtn: UIButton!
    @IBOutlet weak var fromBtn: UIButton!
    @IBOutlet weak var toBtn: UIButton!
    @IBOutlet weak var pointsTF: UITextField!
    @IBOutlet weak var numberOfAttendeesTF: UITextField!
    @IBOutlet weak var descrptonTV: UITextView!
    @IBOutlet weak var submitBtn: UIButton!
        
        {
        didSet{
            submitBtn.layer.cornerRadius = submitBtn.frame.height / 12
        }
    }
    @IBOutlet weak var cancelBtn: UIButton!
        
        {
        didSet{
            cancelBtn.layer.cornerRadius = cancelBtn.frame.height / 12
        }
    }
    
    @IBOutlet weak var cLaSsModeLbl: UILabel!
    @IBOutlet weak var cLaSsModeToggle: UISwitch!
    @IBOutlet weak var ViewSearcTableView: UIView!
    @IBOutlet weak var searchEmailTextfield: UITextField!
    @IBOutlet weak var addEmailBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var vwForMailNSLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var vwForMailVw: UIView!
    
    var gradsForCreateClass = ["1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th","11th","12th","UnderGraduates","Graduates"]
   //var boardsForCreateClass = ["CBSE","ICSE","IGCSE","IB","Others"] /*  Commented by yasodha on 11th April 2020 */
     var boardsForCreateClass = ["CBSE","ICSE","IGCSE","IB","Others","US Common Core"] /*  Updated  by yasodha on 11th April 2020 */

    
    var testStartDate: Date? /*  Updated By Ranjeet on 12th March 2020  */
    var fromTimingDate: Date?
    var toTimingDate: Date?
    var isSubjectSelected = false
    var timeZoneID = -1
    let textViewDescriptionsHintForCreateRequestClassFromTutor =  "Description"
    var jsondict:[[String:Any]]?
    
    var Oldemailids:[String]?
    var stringRepresentation:String?
    lazy var storedmail = [String]()
    
    var uniqueID : String!
    var userId = UserDefaults.standard.string(forKey: "userID")
    // Screen width.
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add by chandra 05/11
        searchEmailTextfield.useUnderline()
        searchEmailTextfield.layer.cornerRadius = 13.5
        searchEmailTextfield.layer.borderWidth = 2.0
        searchEmailTextfield.layer.borderColor = UIColor.init(hex: "2DA9EC").cgColor
        searchEmailTextfield.leftViewMode = UITextField.ViewMode.always
        
        //        let imageView1 = UIImageView(frame: CGRect(x:50, y: 0, width: 20, height: 20))
        //        let image = UIImage(named: "Asset 182-1")
        //        imageView1.image = image
        
        let views = UIView(frame: CGRect(x: 50, y: 0, width: 35, height: 40))
        views.backgroundColor = UIColor.clear
        let imageView1 = UIImageView(frame: CGRect(x: 10, y:10, width: 20, height: 20))
        let image = UIImage(named: "Asset 182-1")
        imageView1.image = image
        views.addSubview(imageView1)
        searchEmailTextfield.leftView = views
        searchEmailTextfield.attributedPlaceholder =
            NSAttributedString(string: "Search by emailId,first name and last name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        vwForMailVw.isHidden = true
        vwForMailNSLayoutConstraint.constant = 0
        descrptonTV.delegate = self
        descrptonTV.text = textViewDescriptionsHintForCreateRequestClassFromTutor
        if currentReachabilityStatus != .notReachable {
            hitServerForGetTheDataFromNotification(params: [:], endPoint: Endpoints.getRequestClassInfo + (self.uniqueID!) ,action: "getRequestClassInfo", httpMethod: .get)
            
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
            })
        }
        self.ViewSearcTableView.isHidden = true
        self.ViewSearcTableView.frame = CGRect(x: 15, y: 45, width: self.view.frame.size.width-30, height: self.view.frame.size.height/4)
        self.view.addSubview(self.ViewSearcTableView)
        searchEmailTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let navigationController = navigationController else { return }
        navigationController.view.backgroundColor = UIColor.init(hex: "2DA9EC")
        if (self.navigationController?.navigationBar) != nil {
            navigationController.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        }
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Create Class on Request"
    }
    
    func serverToLocal(date:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let localDate = dateFormatter.date(from: date)
        
        return localDate
    }
    private func addUnderLines()
    {
        classTitleTF.useUnderline()
        pointsTF.useUnderline()
        numberOfAttendeesTF.useUnderline()
    }
    var isRecord: Int = 0  // Hardcoded as per server side suggestions(Akila)
    override func viewDidLayoutSubviews() {
        self.addUnderLines()
    }
    
    //   add by chandra
    @objc func textFieldDidChange(_ textField: UITextField){
        let searchText = searchEmailTextfield.text!
        print("Search key = \(searchText)")
        if searchText.count >= 3 {
            let encodeSearchKey = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            print("encodeSearchKey = \(encodeSearchKey)")
               let id = 1
               let emailurl = Endpoints.fetchEmailID + (userId ?? "") + "/\(id)?searchText=" + "\(encodeSearchKey)"
            
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
    @IBAction func onClassModeToggle(_ sender: UISwitch) {
        
        let newClassMode = cLaSsModeLbl.text == "Public" ? "Private" : "Public"
        cLaSsModeLbl.text = newClassMode
        if cLaSsModeLbl.text == "Public" {
            
            vwForMailVw.isHidden = true
            vwForMailNSLayoutConstraint.constant = 0
            self.submitBtn.setTitle("Submit", for: .normal)
            
        }else {
            vwForMailVw.isHidden = false
            vwForMailNSLayoutConstraint.constant = 110
            self.submitBtn.setTitle("Send Invitation", for: .normal)
            
        }
    }
    
    @IBAction func onSubjectsBtnClick(_ sender: UIButton) {
        
        let controller = ArrayChoiceTableViewControllerForRequestClass(subjects){[unowned self] (selectedSubject) in
            self.subjectBtn.setTitle(String(describing: selectedSubject ), for: .normal)
            self.subjectBtn.setTitleColor(UIColor.black, for: .normal)
                        /* Added By Ranjeet on 13th April 2020 - starts here */
            if #available(iOS 13.0, *) {
                self.subjectBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
                        /* Added By Ranjeet on 13th April 2020 - ends here */
            self.isSubjectSelected = true
            self.onSubSubjectsBtnClick(self.subSubjectBtn)
        }
        controller.preferredContentSize = CGSize(width: self.screenWidth - 20, height: 200)
        showPopup(controller, sourceView: sender)
        
    }
    var subSubjectListData: [String] = sub_Subjects
    @IBAction func onSubSubjectsBtnClick(_ sender: UIButton) {
        subSubjectListData = []
        
        if subjectBtn.title(for: .normal) == "Subjects(Topic)" {
            showMessage(bodyText: "Please select subjects first.",theme: .warning)
            return
        }
        
        let subIndex = subjects.firstIndex(where: {$0 == subjectBtn.title(for: .normal)!})!
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
            self.subSubjectBtn.setTitle(String(describing: subSubjectListData[0] ), for: .normal)
            self.subSubjectBtn.setTitleColor(UIColor.black, for: .normal)
            /* Added By Ranjeet on 13th April 2020 - starts here */
            if #available(iOS 13.0, *) {
                self.subSubjectBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
             /* Added By Ranjeet on 13th April 2020 - ends  here */
            isSubjectSelected = false
        }
        
        let controller = ArrayChoiceTableViewControllerForRequestClass(subSubjectListData){[unowned self ](selectedSubSubject) in
            self.subSubjectBtn.setTitle(String(describing: selectedSubSubject ), for: .normal)
        }
        controller.preferredContentSize =  CGSize(width: self.screenWidth - 20, height: self.screenHeight / 3)
        showPopup(controller, sourceView: sender)
    }
    
    @IBAction func onGradesBtnClk(_ sender: UIButton) {
        let controller = ArrayChoiceTableViewControllerForRequestClass(gradsForCreateClass){[unowned self ](selectedGrade) in
            self.gradesBtn.setTitle(String(describing: selectedGrade), for: .normal)
            self.gradesBtn.setTitleColor(UIColor.black, for: .normal)
            /* Added By Ranjeet on 13th April 2020 - starts here */
            if #available(iOS 13.0, *) {
                self.gradesBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            /* Added By Ranjeet on 13th April 2020 - ends here */
        }
        controller.preferredContentSize =  CGSize(width: self.screenWidth - 20, height: self.screenHeight / 3)
        showPopup(controller, sourceView: sender)
    }
    
    @IBAction func onBoardsBtnClk(_ sender: UIButton) {
        let controller = ArrayChoiceTableViewControllerForRequestClass(boardsForCreateClass){[unowned self ](selectedBoard) in
            self.boardsBtn.setTitle(String(describing: selectedBoard), for: .normal)
            self.boardsBtn.setTitleColor(UIColor.black, for: .normal)
            /* Added By Ranjeet on 13th April 2020 - starts here */
            if #available(iOS 13.0, *) {
                self.boardsBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            /* Added By Ranjeet on 13th April 2020 - ends here */
        }
        controller.preferredContentSize =  CGSize(width: self.screenWidth - 20,  height: 200)
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
        let sb = UIStoryboard.init(name: "DatePopupViewControllerForCreateRequestClassAndRequestForAClass", bundle: nil) /* Added By Ranjeet on 17th March 2020 */
        let popup = sb.instantiateInitialViewController()! as! DatePopupViewControllerForCreateRequestClassAndRequestForAClass /* Added By Ranjeet on 17th March 2020 */
        popup.showTimePicker = false
        popup.actionName = "testStartDate" /*  Updated By Ranjeet on 12th March 2020  */
        popup.onSave = {[unowned self] (date) in
            sender.setTitle(DateHelper.formattDate(date: date, toFormatt: "MM/dd/yyyy"), for: .normal)
            sender.setTitleColor(UIColor.black, for: .normal)
            /* Added By Ranjeet on 13th April 2020 - starts here */
            if #available(iOS 13.0, *) {
                sender.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            /* Added By Ranjeet on 13th April 2020 - ends here */
            self.testStartDate = date /*  Updated By Ranjeet on 12th March 2020  */
            let utcDate = DateHelper.localToUTC(date: self.testStartDate!, toFormat: "yyyy-MM-dd HH:mm:ss") /*  Updated By Ranjeet on 12th March 2020  */
            print("utcDate = \(utcDate)")
        }
        self.present(popup,animated: true)
    }
    
    @IBAction func fromBtn(_ sender: UIButton){
        if testStartDate != nil{
            print("On fromBtn Btn Click")
            let sb = UIStoryboard.init(name: "DatePopupViewControllerForCreateRequestClassAndRequestForAClass", bundle: nil) /* Added By Ranjeet on 17th March 2020 */
            let popup = sb.instantiateInitialViewController()! as! DatePopupViewControllerForCreateRequestClassAndRequestForAClass /* Added By Ranjeet on 17th March 2020 */
            popup.showTimePicker = true
            popup.selectedClassDate = testStartDate! /*  Updated By Ranjeet on 12th March 2020  */
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
                print("hourString = \(hourString)")
                print("minuteString = \(minuteString)")
                sender.setTitle("\(hourString):\(minuteString)", for: .normal)
                sender.setTitleColor(UIColor.black, for: .normal)
                /* Added By Ranjeet on 13th April 2020 - starts here */
                if #available(iOS 13.0, *) {
                    sender.setTitleColor(UIColor.label, for: .normal)
                } else {
                    // Fallback on earlier versions
                }
                /* Added By Ranjeet on 13th April 2020 - ends here */
                //self.testExpiryDate = date
            }
            self.present(popup,animated: true)
        }
        else{
            if startDateOfCreateClassBtn.title(for: .normal) == " Select Start Date" {
                showMessage(bodyText: "Please select start date first .",theme: .warning)
                return
            }
        }
    }
    @IBAction func toBtn(_ sender: UIButton) {
        if testStartDate != nil{
            if startDateOfCreateClassBtn.title(for: .normal) == "Select Start Date" {
                showMessage(bodyText: "Please select start date first.",theme: .warning)
                return
            }
            
            let sb = UIStoryboard.init(name: "DatePopupViewControllerForCreateRequestClassAndRequestForAClass", bundle: nil) /* Added By Ranjeet on 17th March 2020 */
            let popup = sb.instantiateInitialViewController()! as! DatePopupViewControllerForCreateRequestClassAndRequestForAClass /* Added By Ranjeet on 17th March 2020 */
            popup.showTimePicker = true
           // popup.selectedClassDate = testStartDate! /*  Updated By Ranjeet on 12th March 2020  */
            popup.selectedClassDate = fromTimingDate!
            popup.toTimeSelected = true
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
                
                sender.setTitleColor(UIColor.black, for: .normal)
                /* Added By Ranjeet on 13th April 2020 - starts here */
                if #available(iOS 13.0, *) {
                    sender.setTitleColor(UIColor.label, for: .normal)
                } else {
                    // Fallback on earlier versions
                }
                /* Added By Ranjeet on 13th April 2020 - ends here */
            }
            self.present(popup,animated: true)
        }else{
            if startDateOfCreateClassBtn.title(for: .normal) == " Select Start Date" {
                showMessage(bodyText: "Please select start date first .",theme: .warning)
                return
            }
        }
    }
    /*  Added By Ranjeet on 19th March 2020 - starts here */
    @IBAction func onAddEmailBtnClick(_ sender: Any) {
        if !searchEmailTextfield.text!.isEmpty == false{
            showMessage(bodyText: "Please enter email id",theme: .warning)
            return
        }
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
      /*  Added By Ranjeet on 19th March 2020 - ends  here */
    
    @IBAction func onSubmitBtnClk(_ sender: UIButton) {
        validateData()
    }
    @IBAction func onCancelBtnClk(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    func validateData()
    {
        if gradesBtn.title(for: .normal) == "Offering for Grade" {
            showMessage(bodyText: "Please select Grades",theme: .warning)
            return
        }
        if boardsBtn.title(for: .normal) == "Board" {
            showMessage(bodyText: "Please select Board",theme: .warning)
            return
        }
        
        if subjectBtn.title(for: .normal) == "Subjects(Topic)" {
            showMessage(bodyText: "Please select Subjects.",theme: .warning)
            return
        }
        if subSubjectBtn.title(for: .normal) == "Sub Subjects(Sub Topic)" {
            showMessage(bodyText: "Please select subSubjects.",theme: .warning)
            return
        }
        guard let requestClassTitle = classTitleTF.text, !requestClassTitle.trimmingCharacters(in: .whitespaces).isEmpty else {
            showMessage(bodyText: "Please enter class name.",theme: .warning)
            return
        }
        
        if startDateOfCreateClassBtn.title(for: .normal) == "Select Start Date" {
            showMessage(bodyText: "Please select start date .",theme: .warning)
            return
        }
        
        if fromBtn.title(for: .normal) == "From" {
            showMessage(bodyText: "Please enter start time.",theme: .warning)
            return
        }
        if toBtn.title(for: .normal) == "To" {
            showMessage(bodyText: "Please enter end time.",theme: .warning)
            return
        }
        
        if fromTimingDate != nil && toTimingDate != nil {
            
            
            
            /************************************Commented by yasodha on 16/4/2020**************************************/
//            let order = NSCalendar.current.compare(fromTimingDate!, to: toTimingDate!, toGranularity: .minute)
//
//            if order == .orderedAscending {
//                // date 1 is older
//            }
//            else if order == .orderedDescending {
//                // date 1 is newer
//                showMessage(bodyText: "From time can not be greater than To time.",theme: .warning)
//                return
//            }
//            else if order == .orderedSame {
//                // same day/hour depending on granularity parameter
//
//                showMessage(bodyText: "From time and To time can not be equal",theme: .warning)
//                return
//            }
             /************************************Commented by yasodha on 16/4/2020**************************************/
            
            
            
             /*Added by yasodha for from & totime validation on 16/4/2020 */
                   let components = Calendar.current.dateComponents([.hour, .minute], from: fromTimingDate!)
                   let frmHour = components.hour!
                   let frmMinute = components.minute!
                   
                   let components1 = Calendar.current.dateComponents([.hour, .minute], from: toTimingDate!)
                   let toHour = components1.hour!
                   let toMinute = components1.minute!
                   
                   
                   if frmHour == toHour && frmMinute == toMinute{
                        showMessage(bodyText: "From time and To time can not be equal",theme: .warning)
                        return
                   }
                   if (frmHour == toHour && frmMinute > toMinute) || (frmHour > toHour){
                       showMessage(bodyText: "End time is earlier than Start time.",theme: .warning) /*  Updated By Ranjeet on 18th March 2020 */
                       return
                   }
                   
                    /*Added by yasodha for from & totime validation on 16/4/2020 end here  */
            
            
            
            
            
            
            let distanceBetweenDates: TimeInterval? = toTimingDate?.timeIntervalSince(fromTimingDate!)
            let minBetweenDates = Int((distanceBetweenDates! / 60 ))//minsInAnHour
            
            if minBetweenDates > 60 {
                showMessage(bodyText: "Duration can not be more than 60 minutes",theme: .warning)
                return
            }
        }
        
        guard let numberOfPoints = pointsTF.text, !numberOfPoints.trimmingCharacters(in: .whitespaces).isEmpty else {
            showMessage(bodyText: "Please enter points per attandee.",theme: .warning)
            return
        }
        
        guard let numberOfAttendees = numberOfAttendeesTF.text, !numberOfAttendees.trimmingCharacters(in: .whitespaces).isEmpty else {
            showMessage(bodyText: "Please enter number of attendees.",theme: .warning)
            return
        }
        if Int(numberOfAttendeesTF.text!)! > 100 {
            showMessage(bodyText: "Number of Attendees cannot be more than 100!",theme: .warning)
            return
        }
        guard let description = descrptonTV.text,!description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showMessage(bodyText: "Description",theme: .warning)
            return
        }
        if description == textViewDescriptionsHintForCreateRequestClassFromTutor {
            showMessage(bodyText: "Description",theme: .warning)
            return
        }
        
        /*  Added By Ranjeet on 11th March 2020 - starts here */
        if cLaSsModeLbl.text == "Private"{
            /*  Commented By Ranjeet on  19th March 2020 - starts here */
//            if !searchEmailTextfield.text!.isEmpty == false{
//                showMessage(bodyText: "Please Provide mail",theme: .warning)
//                return
//            }
//            if  !searchEmailTextfield.text!.isValidEmail() {
//                         showMessage(bodyText: "Please Enter a valid email id.",theme: .warning)
//                         return
//                     }
               /*  Commented By Ranjeet on  19th March 2020 - ends  here */

             /*  Added By Ranjeet on  19th March 2020 - ends  here */
            if storedmail.isEmpty{
                showMessage(bodyText: "Please enter email id",theme: .warning)
                return
            }
             /*  Added By Ranjeet on  19th March 2020 - ends  here */
            
        }
        /*  Added By Ranjeet on 11th March 2020 - ends here */
        
        
        
        
        let dateString = DateHelper.localToUTC(date: testStartDate!, toFormat: "yyyy-MM-dd HH:mm:ss") /*  Updated By Ranjeet on 12th March 2020  */
        var startDateString: String? = nil
        if fromTimingDate != nil {
            startDateString = DateHelper.localToUTC(date: fromTimingDate!, toFormat: "yyyy-MM-dd HH:mm:ss")
        }
        
        var endDateString: String? = nil
        if toTimingDate != nil{
            endDateString = DateHelper.localToUTC(date: toTimingDate!, toFormat: "yyyy-MM-dd HH:mm:ss")
        }
        
        let dateParts = dateString.split(separator: " ")
        let startTimeParts = startDateString?.split(separator: " ")
        let endTimeParts = endDateString?.split(separator: " ")
        let classStartDate = dateParts[0] + " " + (startTimeParts?[1])!
        let classEndtime = dateParts[0] + " " + (endTimeParts?[1])!
        let params: [String: Any] = [ "title": classTitleTF.text!,
                                      "timezone": timeZoneID,
                                      "date": dateString,
                                      "start_time":fromBtn.title(for: .normal)!,
                                      "end_time":toBtn.title(for: .normal)!,
                                      "isrecord": 0,
                                      "num_Subscribed":numberOfAttendeesTF.text!,
                                      "Pay_points":pointsTF.text!,
                                      "SubjectID":(subjects.firstIndex(where: {$0 == subjectBtn.title(for: .normal)!})! + 1),
                                      "Sub_SubjectID":getSubSubjectID(subSubjectName: subSubjectBtn.title(for: .normal)! ) ?? 0,
                                      "userid":UserDefaults.standard.string(forKey: "userID")!,
                                      "UTC_ClassStartDatetime":classStartDate,
                                      "UTC_ClassEndtime":classEndtime,
                                      "SharedType":cLaSsModeLbl.text == "Public" ? 1 : 2,
                                      "EmailIDs":  stringRepresentation ?? "",
                                      "Grades": gradsForCreateClass[(gradsForCreateClass.firstIndex(where: {$0 == gradesBtn.title(for: .normal)!})!)],
                                      "RequestID":uniqueID!,
        ]
        
        print("params = \(params)")
        if NetworkReachabilityManager()?.isReachable ?? false {
            //Internet connected,Go ahead
            hitServer(params: params, endPoint: Endpoints.createClass, httpMethod: .post, action: "create_class")
        }else {
            //NO Internet connection, just return
            showMessage(bodyText: "No internet connection",theme: .warning)
        }
    }
}



extension CreateNewClassForTeacherNotificationVC {
    
    private func hitServer(params: [String:Any],endPoint: String, httpMethod: HTTPMethod, action : String) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){[unowned self] result in
            self.stopAnimating()
            switch result {
            case let .success(json, _):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }else {
                    //let myclass = self.storyboard?.instantiateViewController(withIdentifier: "myclassvc") as! MyClassVC // dk commented.
                    ModelData.shared.isComingBackFromRequestedClassPage = true
                    self.navigationController?.popViewController(animated: true) //dk made this changes on 13th march 2020,  /* comment this line when animation not required */
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
}
extension CreateNewClassForTeacherNotificationVC{
    private func hitServerForGetTheDataFromNotification(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){[weak self] result in
            guard let _self = self else {
                return
            }
            switch result {
            case let .success(json,requestType):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }
                else {
                    _self.parseNDispayListData(json: json["ControlsData"]["lsv_reqclass"], requestType: requestType)
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    
    private func parseNDispayListData(json: JSON,requestType: String){
        self.gradesBtn.setTitle(String(describing: gradsForCreateClass[json["GradeID"].intValue - 1]), for: .normal)
        self.gradesBtn.setTitleColor(UIColor.black, for: .normal)
        /* Added By Ranjeet on 13th April 2020 - starts here */
        if #available(iOS 13.0, *) {
            self.gradesBtn.setTitleColor(UIColor.label, for: .normal)
        } else {
            // Fallback on earlier versions
        }
        /* Added By Ranjeet on 13th April 2020 - ends here */
        self.boardsBtn.setTitle(String(describing: boardsForCreateClass[json["BoardID"].intValue - 1]), for: .normal)
        self.boardsBtn.setTitleColor(UIColor.black, for: .normal)
        /* Added By Ranjeet on 13th April 2020 - starts here */
        if #available(iOS 13.0, *) {
            self.boardsBtn.setTitleColor(UIColor.label, for: .normal)
        } else {
            // Fallback on earlier versions
        }
        /* Added By Ranjeet on 13th April 2020 - ends here */
        subjectBtn.setTitle(String(describing: subjects[json["SubjectID"].intValue - 1]), for: .normal)
        subjectBtn.setTitleColor(UIColor.black, for: .normal)
        /* Added By Ranjeet on 13th April 2020 - starts here */
        if #available(iOS 13.0, *) {
            subjectBtn.setTitleColor(UIColor.label, for: .normal)
        } else {
            // Fallback on earlier versions
        }
        /* Added By Ranjeet on 13th April 2020 - ends here */
        subSubjectBtn.setTitle(String(describing: getSubjectName(with: json["Sub_SubjectID"].intValue)!), for: .normal)
        subSubjectBtn.setTitleColor(UIColor.black, for: .normal)
        /* Added By Ranjeet on 13th April 2020 - starts here */
        if #available(iOS 13.0, *) {
            subSubjectBtn.setTitleColor(UIColor.label, for: .normal)
        } else {
            // Fallback on earlier versions
        }
        /* Added By Ranjeet on 13th April 2020 - ends here */
        classTitleTF.text = json["ClassTitle"].stringValue
        
        var dateString = json["startdate"].stringValue
        //Manju added this code..
        // if( !dateString.isEmpty && dateString != nil) / Commented Manju Code by Ranjeet on 6th March 2020 cause [dateString != nil] giving one warning message - Comparing non-optional value of type 'String' to 'nil' always returns true /
        if( !dateString.isEmpty) /* Modified Manju code by Ranjeet on 6th March 2020 to remove above warning message */
        {
            
             /*  Updated By Ranjeet on 19th March 2020 - starts  here */
            dateString = dateString.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
            // For Decimal value
            // startDateOfCreateClassBtn.setTitle(DateHelper.localToUTC(date: dateString, fromFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "MM/dd/yyyy"), for: .normal)
          //  testStartDate = DateHelper.getDateObj(from: dateString, fromFormat: "yyyy-MM-dd'T'HH:mm:ss") /*  Updated By Ranjeet on 12th March 2020 *//commented by yasodha on 8th April 2020
            startDateOfCreateClassBtn.setTitleColor(UIColor.black, for: .normal)
            /* Added By Ranjeet on 13th April 2020 - starts here */
            if #available(iOS 13.0, *) {
                startDateOfCreateClassBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            /* Added By Ranjeet on 13th April 2020 - ends here */
            // fromBtn.setTitle(json["FromTimeDuration"].stringValue, for: .normal)
            
            //Manju code...
            // This code taking current date and adding FromTime.
            //Cause of some one using self.fromTimingDate was setting nil.. without making changes in starttime and end time was giving issues.
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            var stringDummy = Date().string(format: "yyyy-MM-dd")
            stringDummy.append(contentsOf: "T\(json["FromTimeDuration"].stringValue):00")
            let Converteddate = dateFormatter.date(from: stringDummy)
            //Manju code ends here..
           // self.fromTimingDate = Converteddate//commented by yasodha on 8th April 2020
            fromBtn.setTitleColor(UIColor.black, for: .normal)
            /* Added By Ranjeet on 13th April 2020 - starts here */
            if #available(iOS 13.0, *) {
                fromBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            /* Added By Ranjeet on 13th April 2020 - ends here */
            // toBtn.setTitle(json["ToTimeDuration"].stringValue, for: .normal)
            
            
            //Manju added this code..
            stringDummy = Date().string(format: "yyyy-MM-dd")
            stringDummy.append(contentsOf: "T\(json["ToTimeDuration"].stringValue):00")
            let ConvertedTodate = dateFormatter.date(from: stringDummy)
            
            //End of the code..
         //   self.toTimingDate = ConvertedTodate //commented by yasodha on 8th April 2020
            toBtn.setTitleColor(UIColor.black, for: .normal)
            /* Added By Ranjeet on 13th April 2020 - starts here */
            if #available(iOS 13.0, *) {
                toBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            /* Added By Ranjeet on 13th April 2020 - ends here */
            
              /*Added by yasodha for converting UTC to local 8/4/2020 starts here */
                      self.testStartDate = self.serverToLocal(date: json["startdate"].stringValue)
                      self.fromTimingDate = self.serverToLocal(date: json["FromTimeDuration"].stringValue)
                      self.toTimingDate = self.serverToLocal(date: json["ToTimeDuration"].stringValue)
                      
                      /*Added by yasodha for converting UTC to local 8/4/2020 ends here */
            
            
            
            
            
                        /*  Added By Ranjeet on 20th Dec 2020 */
                        if json["startdate"].stringValue != "" {
                                       self.fromTimingDate = self.serverToLocal(date: (json["startdate"].stringValue).replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression))
                                       let formatter = DateFormatter()
                                       // formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                       formatter.dateFormat = "MM/dd/yyyy HH:mm"
                                       let fromTimingDateString = formatter.string(from: fromTimingDate!)
                                       let startTimeParts = fromTimingDateString.split(separator: " ")
                                       // startDateOfCreateClassBtn.setTitleColor(UIColor.black, for: .normal)
                            /* Added By Ranjeet on 13th April 2020 - starts here */
//                            if #available(iOS 13.0, *) {
//                                startDateOfCreateClassBtn.setTitleColor(UIColor.label, for: .normal)
//                            } else {
//                                // Fallback on earlier versions
//                            }
                            /* Added By Ranjeet on 13th April 2020 - starts here */
                                       startDateOfCreateClassBtn.setTitle("\(startTimeParts[0])", for: .normal)
                                       // fromBtn.setTitleColor(UIColor.black, for: .normal)
                                        /* Added By Ranjeet on 13th April 2020 - starts here */
                                       //                            if #available(iOS 13.0, *) {
                                       //                                fromBtn.setTitleColor(UIColor.label, for: .normal)
                                       //                            } else {
                                       //                                // Fallback on earlier versions
                                       //                            }
                                       fromBtn.setTitle("\(startTimeParts[1])", for: .normal)
                                   }
                                   
                                   if json["EndDate"].stringValue != "" {
                                       self.toTimingDate = self.serverToLocal(date: (json["EndDate"].stringValue).replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression))
                                       let formatter1 = DateFormatter()
                                       // formatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                       formatter1.dateFormat = "MM/dd/yyyy HH:mm"
                                       let toTimingDateString = formatter1.string(from: toTimingDate!)
                                       let endTimeParts = toTimingDateString.split(separator: " ")
                                       // toBtn.setTitleColor(UIColor.black, for: .normal)
                                                /* Added By Ranjeet on 13th April 2020 - starts here */
                                    if #available(iOS 13.0, *) {
                                        toBtn.setTitleColor(UIColor.label, for: .normal)
                                    } else {
                                        // Fallback on earlier versions
                                    }
                                                /* Added By Ranjeet on 13th April 2020 - ends here */
                                       toBtn.setTitle("\(endTimeParts[1])", for: .normal)
                                   }
                        /*  Updated By Ranjeet on 20th March 2020 */
                    }
                    
                 
        
        descrptonTV.text = json["Description"].stringValue
        descrptonTV.textColor = UIColor.black
        /* Added By Ranjeet on 13th April 2020 - starts here */
        
        if #available(iOS 13.0, *) {
            descrptonTV.textColor = UIColor.label
        } else {
            // Fallback on earlier versions
        }
        /* Added By Ranjeet on 13th April 2020 - ends  here */
        
    }
}


extension CreateNewClassForTeacherNotificationVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsondict?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateRequestClassTableViewCell") as! CreateRequestClassTableViewCell
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
        if let celll = tableView.cellForRow(at: indexPath) as? CreateRequestClassTableViewCell{
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
extension CreateNewClassForTeacherNotificationVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storedmail.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let colcell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreateRequestClassCollectionViewCell", for: indexPath) as! CreateRequestClassCollectionViewCell
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


/* Text View PlaceHolder Handling - From here */
extension CreateNewClassForTeacherNotificationVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewDescriptionsHintForCreateRequestClassFromTutor {
            textView.text = nil
        }
        textView.textColor = UIColor.black
        /* Added By Ranjeet on 13th April 2020 - starts here */
        
        if #available(iOS 13.0, *) {
            textView.textColor = UIColor.label
        } else {
            // Fallback on earlier versions
        }
        /* Added By Ranjeet on 13th April 2020 - ends here */
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textViewDescriptionsHintForCreateRequestClassFromTutor
            textView.textColor = UIColor.gray
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
}

/* Text View PlaceHolder Handling - Till here */

/* Added By Manju on 3rd March 2020 - starts here */
extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
/* Added By Manju on 3rd March 2020 - ends  here */


