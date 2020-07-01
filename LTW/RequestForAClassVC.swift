//  RequestForAClassVC.swift
//  LTW
//  Created by Ranjeet Raushan on 19/02/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView

class RequestForAClassVC: UIViewController, NVActivityIndicatorViewable {
    @IBOutlet weak var tchrFrstNm: UILabel!
    @IBOutlet weak var tchrLastNm: UILabel!
    @IBOutlet weak var schoolLbl: UILabel!
    @IBOutlet weak var prsnTypLabel: UILabel!
    @IBOutlet weak var gradesBtn: UIButton!
    @IBOutlet weak var boardsBtn: UIButton!
    @IBOutlet weak var subjectBtn: UIButton!
    @IBOutlet weak var subSubjectBtn: UIButton!
    
    @IBOutlet weak var classTitleTF: UITextField!{
        didSet{
            classTitleTF.textColor = .darkGray //Added By DK On 28th March,2020.
            /* Added By Ranjeet on 28th March 2020 - starts here */
            if #available(iOS 13.0, *) {
                classTitleTF.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
            }
             /* Added By Ranjeet on 28th March 2020 - ends  here */
        }
    }
    @IBOutlet weak var flexibilityForAnyDateAndTimeBtn: UIButton!
    
    @IBOutlet weak var dateVw: UIView!
    @IBOutlet weak var startRequestClassBtn: UIButton!
    @IBOutlet weak var timeVw: UIView!
    @IBOutlet weak var fromBtn: UIButton!
    @IBOutlet weak var toBtn: UIButton!
    @IBOutlet weak var descrptonTV: UITextView!
    
    @IBOutlet weak var descrptonToTimeNSLConstnt: NSLayoutConstraint!
    @IBOutlet weak var descrptnToFlxbleDtTmNSLConstnt: NSLayoutConstraint!
    @IBOutlet weak var submitBtn: UIButton!
    var grads = ["1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th","11th","12th","UnderGraduates","Graduates"]
    var board = ["CBSE","ICSE","IGCSE","IB","Others","US Common Core"]
    
    
    var testStartDate: Date? /*  Updated By Ranjeet on 12th March 2020  */
    var fromTimingDate: Date?
    var toTimingDate: Date?
    let textViewDescriptionsHint =  "Write Your Description Here"
    var isFlexible: Bool = false  //uncheck
    var fname: String!
    var lname: String!
    var schol: String!
    var personType: String!
    
    var studentUserID: String!
    var teacherListUserID: String!
    
    
    
    var isSubjectSelected = false
    
    
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
        descrptonTV.delegate = self
        descrptonTV.text = textViewDescriptionsHint
        studentUserID =  UserDefaults.standard.string(forKey: "userID")
        tchrFrstNm.text = fname
        tchrLastNm.text = lname
        schoolLbl.text = schol
        if personType == "3"{
            prsnTypLabel.text = "Teacher"
        }else{
            prsnTypLabel.text = "Student"
        }
        /* Added By Deepak on 26th Feb 2020 - starts here */
        if (PassableData.gradsToNextVC != nil)// Added by dk 26th feb 2020.
        {
            /*  Updated By Ranjeet on 26th March 2020  - starts here */
            gradesBtn.setTitle(PassableData.gradsToNextVC, for: .normal)
            gradesBtn.setTitleColor(.darkGray, for: .normal) /* Added  By Deepak on 28th March 2020 */
            if #available(iOS 13.0, *) {
                gradesBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            boardsBtn.setTitle(PassableData.boardsTonextVC, for: .normal)
            boardsBtn.setTitleColor(.darkGray, for: .normal) /* Added  By Deepak on 28th March 2020 */
            
            if #available(iOS 13.0, *) {
                boardsBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            subjectBtn.setTitle(PassableData.subjectsToNextVC, for: .normal)
            subjectBtn.setTitleColor(.darkGray, for: .normal) /* Added  By Deepak on 28th March 2020 */
            if #available(iOS 13.0, *) {
                subjectBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            
            /*  Updated By Ranjeet on 26th March 2020  - ends here */
        } //edit by dk ended.
        /* Added By Deepak on 26th Feb 2020 - ends here */
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func addUnderLines()
    {
        classTitleTF.useUnderline()
    }
    override func viewDidLayoutSubviews() {
        let screenSize = UIScreen.main.bounds.size
        self.view.bounds.size = screenSize
        self.view.frame.origin.x = 0
        self.view.frame.origin.y = 0
        self.addUnderLines()
    }
    
    
    @IBAction func onSubjectsBtnClick(_ sender: UIButton) {
        
        let controller = ArrayChoiceTableViewControllerForRequestClass(subjects){[unowned self] (selectedSubject) in
            self.subjectBtn.setTitle(String(describing: selectedSubject ), for: .normal)
            self.subjectBtn.setTitleColor(.darkGray, for: .normal) /* Added  By Deepak on 28th March 2020 */
            if #available(iOS 13.0, *) {
                self.subjectBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
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
            isSubjectSelected = false
        }
        
        let controller = ArrayChoiceTableViewControllerForRequestClass(subSubjectListData){[unowned self ](selectedSubSubject) in
            self.subSubjectBtn.setTitle(String(describing: selectedSubSubject ), for: .normal)
            self.subSubjectBtn.setTitleColor(.darkGray, for: .normal) //Added By Dk, 28th Mar,2020.
            /*  Updated By Ranjeet on 26th March 2020  - starts here */
            if #available(iOS 13.0, *) {
                self.subSubjectBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }  /* Added By Deepak on 26th Feb 2020 */
            /*  Updated By Ranjeet on 26th March 2020  - ends here */
        }
        controller.preferredContentSize =  CGSize(width: self.screenWidth - 20, height: self.screenHeight / 3)
        showPopup(controller, sourceView: sender)
    }
    
    @IBAction func onGradesBtnClk(_ sender: UIButton) {
        let controller = ArrayChoiceTableViewControllerForRequestClass(grads){[unowned self ](selectedGrade) in
            self.gradesBtn.setTitle(String(describing: selectedGrade), for: .normal)
            self.gradesBtn.setTitleColor(.darkGray, for: .normal) //Added By Dk, on  28th march,2020.
            /*  Updated By Ranjeet on 26th March 2020  - starts here */
            if #available(iOS 13.0, *) {
                self.gradesBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            /*  Updated By Ranjeet on 26th March 2020  - ends here */
        }
        controller.preferredContentSize =  CGSize(width: self.screenWidth - 20, height: self.screenHeight / 3)
        showPopup(controller, sourceView: sender)
    }
    
    @IBAction func onBoardsBtnClk(_ sender: UIButton) {
        let controller = ArrayChoiceTableViewControllerForRequestClass(board){[unowned self ](selectedBoard) in
            self.boardsBtn.setTitle(String(describing: selectedBoard), for: .normal)
            self.boardsBtn.setTitleColor(.darkGray, for: .normal) //Added By Dk, on  28th march,2020.
            /*  Updated By Ranjeet on 26th March 2020  - starts here */
            if #available(iOS 13.0, *) {
                self.boardsBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            /*  Updated By Ranjeet on 26th March 2020  - ends here */
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
    
    @IBAction func onFlexibilityForAnyDateAndTimeBtnClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            isFlexible = true // check
            descrptonToTimeNSLConstnt.constant = 15
            descrptnToFlxbleDtTmNSLConstnt.constant = 0
            dateVw.isHidden = true
            timeVw.isHidden = true
            
        }else {
            isFlexible = false // uncheck
            descrptnToFlxbleDtTmNSLConstnt.constant = 152
            descrptonToTimeNSLConstnt.constant = 0
            dateVw.isHidden = false
            timeVw.isHidden = false
            
        }
    }
    @IBAction func onStartDateBtnClicked(_ sender: UIButton) {
        let sb = UIStoryboard.init(name: "DatePopupViewControllerForCreateRequestClassAndRequestForAClass", bundle: nil) /* Added By Ranjeet on 17th March 2020 */
        let popup = sb.instantiateInitialViewController()! as! DatePopupViewControllerForCreateRequestClassAndRequestForAClass /* Added By Ranjeet on 17th March 2020 */
        popup.showTimePicker = false
        popup.actionName = "testStartDate" /*  Updated By Ranjeet on 12th March 2020  */
        popup.onSave = {[unowned self] (date) in
            sender.setTitle(DateHelper.formattDate(date: date, toFormatt: "MM/dd/yyyy"), for: .normal)
            sender.setTitleColor(UIColor.black, for: .normal)
            
            /* Added By Ranjeet on 26th April 2020 - starts here */
            
            if #available(iOS 13.0, *) {
                sender.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
             /* Added By Ranjeet on 26th April 2020 - ends  here */
            
            self.testStartDate = date /*  Updated By Ranjeet on 12th March 2020  */
            let utcDate = DateHelper.localToUTC(date: self.testStartDate!, toFormat: "yyyy-MM-dd HH:mm:ss") /*  Updated By Ranjeet on 12th March 2020  */
            print("utcDate = \(utcDate)")
        }
        self.present(popup,animated: true)
    }
    
    @IBAction func fromBtn(_ sender: UIButton){
        
        if startRequestClassBtn.title(for: .normal) == "Select Start Date" {
            showMessage(bodyText: "Please select start date first .",theme: .warning)
            return
        }
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
            
            /* Added By Ranjeet on 26th April 2020 - starts here */
            if #available(iOS 13.0, *) {
                sender.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            /* Added By Ranjeet on 26th April 2020 - starts here */
            //self.testExpiryDate = date
        }
        self.present(popup,animated: true)
    }
    @IBAction func toBtn(_ sender: UIButton) {
//        if testStartDate != nil{
//                   if startRequestClassBtn.title(for: .normal) == "Select Start Date" {
//                       showMessage(bodyText: "Please select start date first.",theme: .warning)
//                       return
//                   }
//        }
        if startRequestClassBtn.title(for: .normal) == "Select Start Date" {
            showMessage(bodyText: "Please select start date first.",theme: .warning)
            return
        }
        if fromBtn.title(for: .normal) == "From" {
        showMessage(bodyText: "Please select From time.",theme: .warning)
        return
        } 
        
        let sb = UIStoryboard.init(name: "DatePopupViewControllerForCreateRequestClassAndRequestForAClass", bundle: nil) /* Added By Ranjeet on 17th March 2020 */
        let popup = sb.instantiateInitialViewController()! as! DatePopupViewControllerForCreateRequestClassAndRequestForAClass /* Added By Ranjeet on 17th March 2020 */
        popup.showTimePicker = true
       // popup.selectedClassDate = testStartDate! /*  Updated By Ranjeet on 12th March 2020  */  /* Commented By Ranjeet  on 26th April 2020 */
        popup.selectedClassDate = fromTimingDate!  /* ADded By Ranjeet  on 26th April 2020 */
        popup.toTimeSelected = true /* ADded By Ranjeet  on 26th April 2020 */
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
            /*  Updated By Ranjeet on 26th March 2020  - starts here */
            if #available(iOS 13.0, *) {
                sender.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            /*  Updated By Ranjeet on 26th March 2020  - ends here */
        }
        self.present(popup,animated: true)
        
//        else {
//            if startRequestClassBtn.title(for: .normal) == " Select Start Date" {
//                showMessage(bodyText: "Please select start date first .",theme: .warning)
//                return
//            }
//        }
    }
    
    
    @IBAction func onSubmitBtnClk(_ sender: UIButton) {
        validateData()
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
        if !flexibilityForAnyDateAndTimeBtn.isSelected{
            if startRequestClassBtn.title(for: .normal) == "Select Start Date" {
                showMessage(bodyText: "Please select start date .",theme: .warning)
                return
            }
        }
        
        if !flexibilityForAnyDateAndTimeBtn.isSelected{
            
            //  1/6/2020  prasuna commented
            
//            if fromBtn.title(for: .normal)?.stringByTrimingWhitespace() == "" ||  fromBtn.title(for: .normal)?.lowercased() == "from"{
//                showMessage(bodyText: "Please enter start time.",theme: .warning)
//                return
//            }
//            if toBtn.title(for: .normal)?.stringByTrimingWhitespace() == "" ||  toBtn.title(for: .normal)?.lowercased() == "to" {
//                showMessage(bodyText: "Please enter end time.",theme: .warning)
//                return
//            }
            
            if fromTimingDate != nil && toTimingDate != nil {
                let order = NSCalendar.current.compare(fromTimingDate!, to: toTimingDate!, toGranularity: .minute)
                if order == .orderedAscending {
                    // date 1 is older
                }
                else if order == .orderedDescending {
                    // date 1 is newer
                    showMessage(bodyText: "From time can not be greater than To time.",theme: .warning)
                    return
                }
                else if order == .orderedSame {
                    // same day/hour depending on granularity parameter
                    showMessage(bodyText: "From time and To time can not be equal",theme: .warning)
                    return
                }
                
                let distanceBetweenDates: TimeInterval? = toTimingDate?.timeIntervalSince(fromTimingDate!)
                let minBetweenDates = Int((distanceBetweenDates! / 60 ))//minsInAnHour
                
                if minBetweenDates > 60 {
                    showMessage(bodyText: "Duration can not be more than 60 minutes",theme: .warning)
                    return
                }
            }
        }
        
        
        guard let description = descrptonTV.text,!description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showMessage(bodyText: "Write Your Description Here",theme: .warning)
            return
        }
        if description == textViewDescriptionsHint {
            showMessage(bodyText: "Write Your Description Here",theme: .warning)
            return
        }
        
        /*  Modified By Ranjeet on 11th March - starts here */
        var classStartDate: String = ""
        if fromTimingDate != nil {
            classStartDate = DateHelper.localToUTC(date: fromTimingDate!, toFormat: "yyyy-MM-dd HH:mm:ss")
        }
        
        var classEndtime: String = ""
        if toTimingDate != nil{
            classEndtime = DateHelper.localToUTC(date: toTimingDate!, toFormat: "yyyy-MM-dd HH:mm:ss")
        }
        
        /*  Modified By Ranjeet on 11th March - ends here */
        
        let params: [String: Any] = [
            "StudentUserID": studentUserID!,
            "TutorUserID": teacherListUserID!,
            "GradeID": (grads.firstIndex(where: {$0 == gradesBtn.title(for: .normal)!})! + 1),
            "BoardID": (board.firstIndex(where: {$0 == boardsBtn.title(for: .normal)!})! + 1),
            "SubjectID": (subjects.firstIndex(where: {$0 == subjectBtn.title(for: .normal)!})! + 1),
            "Sub_SubjectID": getSubSubjectID(subSubjectName: subSubjectBtn.title(for: .normal)! ) ?? 0 ,
            "ClassTitle": classTitleTF.text!,
            "IsFlexibleDateTime": isFlexible,
            "StartDate": isFlexible ? "" : classStartDate ,
            "FromTimeDuration": isFlexible ? "" : fromBtn.title(for: .normal) ?? "",
            "ToTimeDuration": isFlexible ? "" : toBtn.title(for: .normal) ?? "",
            "Description": description,
            "EndDate": isFlexible ? "" : classEndtime /*  Added By Ranjeet on 11th March */]
        // print("params = \(params)") /*  Commented By Ranjeet on 11th March 2020 */ - /* Don't Remove this line, this line is useful for future reference to print the params */
        if NetworkReachabilityManager()?.isReachable ?? false {
            //Internet connected,Go ahead
            hitServer(params: params, endPoint: Endpoints.requestAClassClassEndPoint , httpMethod: .post, action: "request_a_class")
        }else {
            //NO Internet connection, just return
            showMessage(bodyText: "No internet connection",theme: .warning)
        }
    }
}
extension RequestForAClassVC {
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
//                    self.navigationController?.popViewController(animated: true)
                    showMessage(bodyText: "Class Requested Successfully",theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.1)) //changed to from 0.5 to 0.1 by dk on 21st may.
                    /* added by dk on 21st may 2020, start*/
                    var allViewControllers: [UIViewController]? = nil
                    if let view = self.navigationController?.viewControllers {
                        allViewControllers = view
                    }
                    for aViewController in allViewControllers ?? [] {
                        if (aViewController is MyClassVC) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.navigationController?.popToViewController(aViewController, animated: false)
                            }
                        }
                    }
                    /* added by dk on 21st may 2020, end*/
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
}

/* Text View PlaceHolder Handling - From here */
extension RequestForAClassVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewDescriptionsHint {
            textView.text = nil
        }
        /*  Updated By Ranjeet on 26th March 2020  - starts here */
        if #available(iOS 13.0, *) {
            textView.textColor = UIColor.label
        } else {
            // Fallback on earlier versions
        }
        /*  Updated By Ranjeet on 26th March 2020  - ends here */
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textViewDescriptionsHint
            textView.textColor = UIColor.gray
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
}
/* Text View PlaceHolder Handling - Till here */


