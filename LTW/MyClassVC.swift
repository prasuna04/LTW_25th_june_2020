// MyClassVC.swift
// LTW
// Created by Ranjeet Raushan on 10/10/19.
// Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import NVActivityIndicatorView
import Alamofire
import SwiftyJSON
//import QuickbloxWebRTC
//import Quickblox
import SDWebImage


class MyClassVC: UIViewController,NVActivityIndicatorViewable {
    
    typealias DownloadComplete = () -> ()
    var cellDatas = [RequestedClassInfoData]()
    var cellIndex : Int!
    var previousViewController = ""
    var isFromExpiredClass = ""
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(MyClassVC.handleRefresh(_:)),for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    var notificationInt:Int! // add by chandra for notofication
    var buttonBar:UIView!
    var segmentedControl: UISegmentedControl!
    //    add by chandra for new changes starts here
    let personType = UserDefaults.standard.string(forKey: "persontyp")
    var personTypechuck:Int!
    
    /* Added By Yashoda on 27th Jan 2020 - starts  here */
    var tutorClassesEndPoint : String!
    var tutorTestsEndPoint : String!
    var studentClassesEndPoint : String!
    var studentTestTakenEndPoint : String!
    var perSonType :Int!
    /* Added By Yashoda on 27th Jan 2020 - ends   here */
    var views = UIView()
    
    //    add by chandra for new changes end here
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var classTableView: UITableView!
    @IBOutlet weak var navigationSearchBar: UIView!
    
    @IBOutlet var searchFooter: SearchFooter!
    @IBOutlet weak var addClassBtn: UIButton!{
        didSet {
            addClassBtn.layer.shadowColor = UIColor.gray.cgColor
            addClassBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
            addClassBtn.layer.shadowRadius = 5
            addClassBtn.layer.shadowOpacity = 1.0
            addClassBtn.layer.cornerRadius = addClassBtn.frame.height / 2
        }
    }
    @IBOutlet var createClassPan: UIPanGestureRecognizer! // Added By Ranjeet
    private var tablePageIndex = 1
    private var noOfItemsInaPage = 10
    var activityIndicator: LoadMoreControl!
    let userId = UserDefaults.standard.string(forKey: "userID")
    
    private var firstTabDataSet = [JSON](){
        didSet {
            //if !firstTabDataSet.isEmpty {
            classTableView.reloadData()
            // }
        }
    }
    /* Added By Yashoda on 27th Jan 2020 - starts  here */
    
    private var expClassData = [JSON](){
        didSet {
            //if !firstTabDataSet.isEmpty {
            classTableView.reloadData()
            // }
        }
    }
    private var classesAttendedData = [JSON](){
        didSet {
            
            classTableView.reloadData()
            
        }
    }
    
    /* Added By Yashoda on 27th Jan 2020 - ends  here */
    
    private var secondTabDataSet = [JSON](){
        didSet {
            classTableView.reloadData()
        }
    }
    private var thirdTabDataSet = [JSON]() {
        didSet {
            classTableView.reloadData()
        }
    }
    
    var activeTabIndex = 0// zero for 1st Tab
    var actionName = "tab1"
    //var actionClass = "classDataSet"   /* Added By Yashoda on 27th Jan 2020  */
    
    var timeZoneArrayJSON: [JSON]!
    var timeZoneStringArray: [String] = []
    private var deletedItemIndex = -1
    
    //    //MARK: - Properties
    //    lazy private var dataSource: UsersDataSource = {
    //        let dataSource = UsersDataSource()
    //        return dataSource
    //    }()
    //    lazy private var navViewController: UINavigationController = {
    //        let navViewController = UINavigationController()
    //        return navViewController
    //
    //    }()
    // private weak var session: QBRTCSession?
    //    lazy private var voipRegistry: PKPushRegistry = {
    //    let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
    //    return voipRegistry
    //    }()
    //    private var callUUID: UUID?
    //    lazy private var backgroundTask: UIBackgroundTaskIdentifier = {
    //        let backgroundTask = UIBackgroundTaskIdentifier.invalid
    //        return backgroundTask
    //    }()
    
    //For Copy of the Test
    var number_Of_Attendees : String!  // add by yusodha
     var subcribed: [String] = []
     var classIdString = ""//yasodha
    
    @IBAction func onAddClassBtnClick(_ sender: UIButton) {
        addClassBtn.isUserInteractionEnabled = false//Added by yasodha
        addNewClass()
        
    }
    
    //prasuna added
    //    var dialog: String!
    //    private let chatManager = ChatManager.instance
    var dict: JSON!
    //    var chatDialog: QBChatDialog?
    
    var currentTimeZoneName = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldSearch.layer.cornerRadius = 20
        textFieldSearch.layer.borderWidth = 1.5
        textFieldSearch.layer.borderColor = UIColor.white.cgColor
        textFieldSearch.leftViewMode = UITextField.ViewMode.always
        let views = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        views.backgroundColor = UIColor.clear
        let imageView1 = UIImageView(frame: CGRect(x: 10, y:10, width: 20, height: 20))
        let image = UIImage(named: "topsearch")
        imageView1.image = image
        views.addSubview(imageView1)
        textFieldSearch.leftView = views
        textFieldSearch.tintColor = .white
        textFieldSearch.attributedPlaceholder =
            // NSAttributedString(string: "Search By Class Name/Grades", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]) /* Commented By Ranjeet on 24th April 2020 */
            NSAttributedString(string: "search by tutor/class/grades", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]) /* Updated By Ranjeet on 24th April 2020 */
        //extendedLayoutIncludesOpaqueBars = true
        
        //Code by DK.
        // add by deepak on 19 march 2020 start here to
        
        let swipeLeft = UISwipeGestureRecognizer(target : self, action : #selector(self.swipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        
        let swipeRight = UISwipeGestureRecognizer(target : self, action : #selector(self.swipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        
        classTableView.addGestureRecognizer(swipeLeft)
        classTableView.addGestureRecognizer(swipeRight)
        // add by deepak on 19 march 2020 ends here to
        /* Added By Yashoda on 27th Jan 2020 - starts  here */
        
        
        
        /*****************************************Commented by yasodha*********************************************/
        
        /*  if self.navigationController?.viewControllers.previous is PersonalProfileVC {
         addClassBtn.isHidden = true /* Remove  add class button  when redirecting from User Details Screen By Ranjeet on 1st Feb 2020 */
         if currentReachabilityStatus != .notReachable {
         // hitServer(params: [:], endPoint: Endpoints.TutorClassesEndPoint + ((UserDefaults.standard.string(forKey: "UserID"))!) + "?searchText=\("")", action: "tab1", httpMethod: .get)
         
         //TutorClassesEndPoint,TutorTestsEndPoint,StudentClassesEndPoint,StudentTestTakenEndPoint
         
         
         if perSonType == 1 {
         print("************** Student*****************")
         // UserDefaults.standard.set(personalprofile.userID, forKey: "personalprofile")
         if studentClassesEndPoint == "Class Attended"{
         hitServer(params: [:], endPoint: Endpoints.StudentClassesEndPoint + userId! + "/" + ((UserDefaults.standard.string(forKey: "personalprofile"))!) + "?searchText=\("")" , action: "classDataSet", httpMethod: .get)//this is for TutorClassesEndPoint
         
         //studentClassesEndPoint = ""
         }
         
         
         }else if perSonType == 3 {
         print("************* Teacher ****************")
         if tutorClassesEndPoint == "Classes Delivered"{ // Changed by Chandra on 20/03/2020.
         
         hitServer(params: [:], endPoint: Endpoints.TutorClassesEndPoint + userId! + "/" + ((UserDefaults.standard.string(forKey: "personalprofile"))!) + "?searchText=\("")" , action: "classDataSet", httpMethod: .get)//this is for TutorClassesEndPoint
         // tutorClassesEndPoint = ""
         }
         }
         
         //                QBRTCClient.instance().add(self)
         
         } else {
         showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
         })
         }
         }
         /* Added By Yashoda on 27th Jan 2020 - starts  here */
         
         else {   /* Added By Yashoda on 27th Jan 2020  */
         //        add by chandra new changes starts here
         
         
         */ //Commented by yasodha
        
        /*****************************************Commented by yasodha*********************************************/
        
        if personType == "1"{
            
            addClassBtn.setImage(UIImage(named: "request-a-class.png"), for:.normal) // Added By Ranjeet on 20th Feb 2020
            //   addClassBtn.isHidden = false // Commented By Ranjeet on 20th Feb 2020
            personTypechuck = 1
            activeTabIndex = 2
            segmentupUIControl()
        }else{
            addClassBtn.setImage(UIImage(named: "newclass.png"), for:.normal) // Modified By Ranjeet on 20th Feb 2020
            //  addClassBtn.isHidden = false // Commented By Ranjeet on 20th Feb 2020
            personTypechuck = 2
            activeTabIndex = 0
            segmentupUIControl()
        }
        
        
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
        
        
        //
        //            hitService()
        
        //            QBRTCClient.instance().add(self)
        
        /* Moving Floating Button Code  - starts here[ Added By Ranjeet ] */
        self.addClassBtn.frame = CGRect(x:self.view.frame.width - 80 , y: self.view.frame.height - 230 , width: 80 , height: 80 )
        /* Moving Floating Button Code - ends here[ Added By Ranjeet ] */
        
        
        /* Added by yasodha on 17/4/2020 - starts here */
                hitService()
                self.classTableView.addSubview(self.refreshControl)
        /* Added by yasodha on 17/4/2020 - ends here */
    }
    
    /*******************************Commented by yasodha******************************************/
    
    //
    //        /* Added By Ranjeet on 4th March 2020 - starts here */
    //        if self.navigationController?.viewControllers.previous is CreateNewClassForTeacherNotificationVC {
    //            for obj in (self.navigationController?.viewControllers)! {
    //                if obj is NotificationVC {
    //                    self.navigationController?.popToViewController(obj, animated: true)
    //                    break
    //                }
    //            }
    //        }
    //        /* Added By Ranjeet on 4th March 2020 - ends  here */
    //        self.classTableView.addSubview(self.refreshControl) //Added by DK on 13  march 2020.
    //    }
    //
    
    /*******************************Commented by yasodha******************************************/
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        hitService()
        refreshControl.endRefreshing()
    }
    
    // add by deepak on 19 mar 2020
    @objc func swipeGesture(_ sender : UISwipeGestureRecognizer?) {
        if let swipeGesture = sender {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right :
                print("DK Swiped Right")
                segmentedControl.selectedSegmentIndex = 0
                activeTabIndex = segmentedControl.selectedSegmentIndex
                hitService()
                UIView.animate(withDuration: 0.3) {[unowned self] in
                    self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
                }
                
            case UISwipeGestureRecognizer.Direction.left :
                print("DK Swiped Left")
                segmentedControl.selectedSegmentIndex = 1
                activeTabIndex = segmentedControl.selectedSegmentIndex
                hitService()
                UIView.animate(withDuration: 0.3) {[unowned self] in
                    self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
                }
            default:
                break
            }
        }
    }
    /*Added by yasodha 21st may starts here */
    @objc func onReviewButtonPressed(_ sender: UIButton ) {
        
        previousViewController = "RateAndReviewVC"
        let vc = storyboard?.instantiateViewController(withIdentifier: "RateAndReviewVC") as! RateAndReviewVC
        let dict = classesAttendedData[sender.tag]
        vc.classId = dict["Class_id"].int ?? 0
        vc.userId = userId!
        vc.TutorUserID = dict["userid"].stringValue
        print("Class Id : \(dict["Class_id"].int ?? 0) TutorUserID : \(dict["userid"].stringValue)")
        self.navigationController?.pushViewController(vc, animated: true )
    }
    
    /*Added by yasodha 6/3/2020 starts here */
    func serverToLocal(date:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let localDate = dateFormatter.date(from: date)
        
        return localDate
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        ModelData.shared.previousViewController = previousViewController
        ModelData.shared.activeTabIndex = activeTabIndex
        
        // UserDefaults.standard.set(activeTabIndex, forKey: "activeTabIndex")
    }
    
    /*Added by yasodha 6/3/2020 ends here */
    /* Moving Floating Button Code - starts here [ Added By Ranjeet ] */
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        if recognizer.state == UIGestureRecognizer.State.ended {
            // 1
            let velocity = recognizer.velocity(in: self.view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 200
            print("magnitude: \(magnitude), slideMultiplier: \(slideMultiplier)")
            
            // 2
            let slideFactor = 0.1 * slideMultiplier     //Increase for more of a slide
            // 3
            var finalPoint = CGPoint(x:recognizer.view!.center.x + (velocity.x * slideFactor),
                                     y:recognizer.view!.center.y + (velocity.y * slideFactor))
            // 4
            finalPoint.x = min(max(finalPoint.x, 50), self.view.bounds.size.width - 40)
            finalPoint.y = min(max(finalPoint.y, 100), self.view.bounds.size.height - 40)
            
            /* Floating Button Automatically Moving from middle to left & right - ends here */
            if finalPoint.x <= self.view.center.x{
                
                finalPoint.x = 40.0
            }
                
            else{
                finalPoint.x = self.view.frame.width - 40
            }
            /* Floating Button Automatically Moving from middle to left & right - ends here */
            
            // 5
            UIView.animate(withDuration: Double(slideFactor * 2),
                           delay: 0,
                           // 6
                options: UIView.AnimationOptions.curveEaseOut,
                animations: {recognizer.view!.center = finalPoint },
                completion: nil)
        }
    }
    @IBAction func handlePinch(recognizer : UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
    }
    @IBAction func handleRotate(recognizer : UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    /* Moving Floating Button Code - ends here[ Added By Ranjeet ] */
    
    
    @objc func addNewClass() {
        if personType == "1"{
            let serchteacher = storyboard?.instantiateViewController(withIdentifier: "serchteacher") as! SearchTeacherVC
            navigationController?.pushViewController(serchteacher, animated: true)
        }
            
        else{
            
            /*************************Commented by yasodha on 24/4/2020***********************************/
            //            let vc = storyboard?.instantiateViewController(withIdentifier: "createClassvc") as! AddClassVC
            //            vc.refreshClassList = {[unowned self] in
            //                self.hitService()
            //            }
            //            navigationController?.pushViewController(vc, animated: true)
            /*************************Commented by yasodha on 24/4/2020***********************************/
            
            let url = URL(string: Endpoints.userProfileEndPoint + (userId!))
            Alamofire.request(url!).responseJSON{ response in
                let dict = response.result.value as! Dictionary<String,Any>
                let controlsData = dict["ControlsData"] as? [String:Any]
                let tutorInfo   = controlsData?["tutorInfo"]
                
                if let id = tutorInfo as? NSNull
                {
                    
                    
                    UserDefaults.standard.set(true, forKey: "Tutor")
                    UserDefaults.standard.set(true, forKey: "TutorSkipInClass")
                    //  UserDefaults.standard.synchronize()
                    let tutorSignUpVC = self.storyboard?.instantiateViewController(withIdentifier: "TutorSignUpVC") as! TutorSignUpVC
                    self.navigationController?.pushViewController(tutorSignUpVC, animated: true)
                    
                    
                }else {
                    //                    UserDefaults.standard.set(false, forKey: "TutorSkipInClass")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "createClassvc") as! AddClassVC
                    vc.refreshClassList = {[unowned self] in
                        self.hitService()
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                }
                
                
            }
            
        }
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.3) {[unowned self] in
            self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
            
        }
        print("Selected segment index = \(self.segmentedControl.selectedSegmentIndex)")
        //classTableView.setContentOffset(.zero, animated: true)
        activeTabIndex = self.segmentedControl.selectedSegmentIndex
        hitService()
    }
    var globalListEndPoint = ""
    private func hitService() {
        
        textFieldSearch.resignFirstResponder()
        if NetworkReachabilityManager()?.isReachable ?? false {
            //Internet connected,Go ahead
            
            
            if personTypechuck == 1 {//Student
                
                if activeTabIndex == 0 {
                    
                    textFieldSearch.attributedPlaceholder =
                        // NSAttributedString(string: " Search By Class Name/Grades", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]) / Commented By Ranjeet on 24th April 2020 /
                        NSAttributedString(string: " search by tutor/class/grades", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])// Updated By Ranjeet on 24th April 2020 /
                    
                    classesAttendedData.removeAll()
                    classTableView.reloadData()
                    globalListEndPoint = Endpoints.classAttended + userId! + "?searchText=\(textFieldSearch.text?.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")"
                    actionName = "AttendedClasses"
                    
                }else if activeTabIndex == 1{
                    textFieldSearch.attributedPlaceholder =
                        // NSAttributedString(string: " Search By Class Name/Grades", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]) / Commented By Ranjeet on 24th April 2020 /
                        NSAttributedString(string: " search by tutor/class/grades", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]) // Updated By Ranjeet on 24th April 2020 /
                    
                    secondTabDataSet.removeAll()
                    classTableView.reloadData()
                    globalListEndPoint = Endpoints.subcribedClassEndPoint + userId! + "?searchText=\(textFieldSearch.text?.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")"
                    actionName = "tab2"
                }else if activeTabIndex == 2{
                    textFieldSearch.attributedPlaceholder =
                        // NSAttributedString(string: " Search By Class Name/Grades", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]) / Commented By Ranjeet on 24th April 2020 /
                        NSAttributedString(string: " search by tutor/class/grades", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])// Updated By Ranjeet on 24th April 2020 /
                    thirdTabDataSet.removeAll()
                    classTableView.reloadData()
                    globalListEndPoint = Endpoints.availableClassesEndPoint + userId! + "?searchText=\(textFieldSearch.text?.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")"
                    actionName = "tab3"
                }
            }else{
                if activeTabIndex == 0{
                    textFieldSearch.attributedPlaceholder =
                        // NSAttributedString(string: " Search By Class Name/Grades", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])/* Commented By Ranjeet on 24th April 2020 */
                        NSAttributedString(string: " search by tutor/class/grades", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]) /* Updated By Ranjeet on 24th April 2020 */
                    firstTabDataSet.removeAll()
                    classTableView.reloadData()
                    globalListEndPoint = Endpoints.myClassesEndPoint + userId! + "?searchText=\(textFieldSearch.text?.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")"
                    actionName = "tab1"
                    
                }else if activeTabIndex == 1 {
                    actionName = "tab4"
                    textFieldSearch.text?.removeAll()
                    textFieldSearch.attributedPlaceholder =
                        NSAttributedString(string: " Search By Class Title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
                    self.cellDatas.removeAll()
                    self.classTableView.reloadData()
                    globalListEndPoint = Endpoints.requestedClassListEndPoint + userId! + "?SearchText=\(textFieldSearch.text?.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")"
                    self.downloadRequestedClassInformation{}
                }else if activeTabIndex == 2{//Added by yasodha on 16/4/2020 starts here
                    
                    textFieldSearch.attributedPlaceholder =
                        // NSAttributedString(string: " Search By Class Name/Grades", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]) /* Commented By Ranjeet on 24th April 2020 */
                        NSAttributedString(string: " search by tutor/class/grades", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])/* Updated By Ranjeet on 24th April 2020 */
                    expClassData.removeAll()
                    classTableView.reloadData()
                    globalListEndPoint = Endpoints.TutorExpiredClassesEndPoint + userId! + "?searchText=\(textFieldSearch.text?.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")"
                    actionName = "Expired Classes"
                    
                }
                /*Added by yasodha on 16/4/2020 ends here */
                
            }
            classTableView.reloadData()
            hitServer(params: [:], endPoint: globalListEndPoint ,action: actionName, httpMethod: .get)
            
        }else {
            //NO Internet connection, just return
            showMessage(bodyText: "No internet connection",theme: .warning)
        }
    }
    
    @IBAction func OnSearchClickBtn(sender:UIButton) {
        if actionName == "tab4"{
            globalListEndPoint = Endpoints.requestedClassListEndPoint + userId! + "?SearchText=\(textFieldSearch.text?.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")"
            self.cellDatas.removeAll()
            self.classTableView.reloadData()
            self.downloadRequestedClassInformation{}
            print("Deepak Kumar Global List", globalListEndPoint)
        } else {
            print("Deepak Kumar HitService")
            hitService()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        chatManager.delegate = self
        //        if QBChat.instance.isConnected == false {
        //            self.connectToChat()
        //        }else
        //        {
        //            chatManager.updateStorage()
        //
        //        }
        
        super.viewWillAppear(animated)
        guard let navigationController = navigationController else { return }
        navigationController.view.backgroundColor = UIColor.init(hex:"2DA9EC")
        if (self.navigationController?.navigationBar) != nil {
            navigationController.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        }
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // navigationItem.title = "My Classes"   /* Commented By Yashoda on 27th Jan 2020  */
        
        /* Added By Yashoda on 27th Jan 2020 - starts  here */
        /*********************************Commented by yasodha *********************************/
        //        if self.navigationController?.viewControllers.previous is PersonalProfileVC {
        //            if studentClassesEndPoint ==   "Class Attended"{
        //                navigationItem.title = "Class Taken"
        //            }else if tutorClassesEndPoint == "Class Created"{
        //
        //                navigationItem.title = "Class Created"
        //            }
        //        }
        //        else {
        //            navigationItem.title = "My Classes"
        //        }
        //  /*********************************Commented by yasodha *********************************/
        
        
        navigationItem.title = "My Classes"
        
        /* Added By Yashoda on 27th Jan 2020 - ends   here */
        
        /* Added By Veeresh on 23rd Jan 2020 - starts here */
        let rightBarBtn = UIBarButtonItem(title: "cal", style: .plain , target: self, action: #selector(rightBarBtnAction))
        rightBarBtn.image = UIImage(named: "date")
        let trackLbl = UILabel()
        trackLbl.text = "track your\nclass"
        trackLbl.font = UIFont(name: "Roboto-Bold", size: 10)!
        trackLbl.numberOfLines = 2
        trackLbl.textColor = UIColor.white
        self.navigationItem.rightBarButtonItems = [rightBarBtn,UIBarButtonItem(customView: trackLbl)]
        
        /* Added By Veeresh on 23rd Jan 2020 - ends here */
        addClassBtn.isUserInteractionEnabled = true//Added by yasodha
        //For display 2nd tab in student said
        //        if  personTypechuck == 1 {
        //            activeTabIndex = 1
        //            notificationInt = 2
        //            segmentupUIControl()
        //
        //        }
        if personTypechuck == 1 { //Student
            if ModelData.shared.previousViewController == "PersonalProfileVC" || ModelData.shared.previousViewController == "RateAndReviewVC" || ModelData.shared.previousViewController == "MyClassInfoVC" || ModelData.shared.previousViewController == "WhiteBoard" || ModelData.shared.previousViewController == "CalenderVC" {
                
                ModelData.shared.previousViewController = ""
                ModelData.shared.previousViewController = ""
                ModelData.shared.previousViewController = ""
                previousViewController = ""
                
                activeTabIndex = ModelData.shared.activeTabIndex
                segmentupUIControl()
                
            }else{
                
                activeTabIndex = 2
                notificationInt = 2
                segmentupUIControl()
                
                
            }
            
            
        }else if ModelData.shared.isCreatingClassFromExpired == true || ModelData.shared.isComingBackFromRequestedClassPage == true{//When create class from expired class
            activeTabIndex = 0
            segmentupUIControl()
            UIView.animate(withDuration: 0.3) {[unowned self] in
                self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) *     CGFloat(self.segmentedControl.selectedSegmentIndex)
            }
                        hitService()
//            if ModelData.shared.isComingBackFromRequestedClassPage == true {
//                hitService()
//            }
            ModelData.shared.isCreatingClassFromExpired = false
            ModelData.shared.isComingBackFromRequestedClassPage = false
            
        }
        
//
//        hitService() //uncommented by dk on 4 jun 2020.
//        self.classTableView.addSubview(self.refreshControl)
//
        
        
    }
    
    /***************************Commented by yasodha*********************************/
    //    /* Added By Yashoda on 27th Jan 2020 - starts   here */
    //    override func viewDidLayoutSubviews() {
    //        if self.navigationController?.viewControllers.previous is PersonalProfileVC {
    //            navigationSearchBar.heightAnchor.constraint(equalToConstant: 0).isActive = true
    //
    //            classTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
    //            classTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
    //            classTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
    //            classTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    //
    //            classTableView.reloadData()
    //
    //        }
    //    }
    //    /* Added By Yashoda on 27th Jan 2020 - starts   here */
    
    /***************************Commented by yasodha*********************************/
    
    /* Added By Veeresh on 23rd Jan 2020 - starts here */
    @objc func rightBarBtnAction(sender: UIBarButtonItem) {
        /*  Updated By Ranjeet on 27th March 2020 - starts here */
        
        previousViewController = "CalenderVC"
        let vc = storyboard?.instantiateViewController(withIdentifier: "CalenderVC") as! CalenderVC
        vc.userID = userId!
        self.navigationController?.pushViewController(vc, animated: true)
        
        // Fallback on earlier versions
        
        /*  Updated By Ranjeet on 27th March 2020 - ends here */
    }
    /* Added By Veeresh on 23rd Jan 2020 - ends here */
    
    private func segmentupUIControl() {
        // Container view
        let view = UIView(frame: CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width, height: 45))
        view.backgroundColor = UIColor.init(hex:"2DA9EC")
        
        segmentedControl = UISegmentedControl()
        if personTypechuck == 1{
            
            segmentedControl.insertSegment(withTitle: "CLASSES ATTENDED", at: 0, animated: true)
            segmentedControl.insertSegment(withTitle: "SUBSCRIBED CLASSES", at: 1, animated: true)
            segmentedControl.insertSegment(withTitle: "AVAILABLE CLASSES", at: 2, animated: true)
            
        }else{
            segmentedControl.insertSegment(withTitle: "MY CLASSES", at: 0, animated: true)
            segmentedControl.insertSegment(withTitle: "REQUESTED CLASSES", at: 1, animated: true)
            segmentedControl.insertSegment(withTitle: "EXPIRED CLASSES", at: 2, animated: true)
            
        }
        // add by chandra for notification start here
        if notificationInt == 2{
            // segmentedControl.selectedSegmentIndex = 2
            segmentedControl.selectedSegmentIndex = activeTabIndex
            personTypechuck = 1
            /// activeTabIndex = 2
        }else{
            segmentedControl.selectedSegmentIndex = 0
        }
        // add by chandra  for notification ends here
        
        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = .clear
        } else {
            // Fallback on earlier versions
        }
        
        // This needs to be false since we are using auto layout constraints
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        // Add lines below selectedSegmentIndex
        segmentedControl.backgroundColor = .clear
        segmentedControl.tintColor = .clear
        
        
        buttonBar = UIView()
        // This needs to be false since we are using auto layout constraints
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = UIColor.orange
        
        // Add lines below the segmented control's tintColor
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 15)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .normal)
        
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .selected)
        
        // Add the segmented control to the container view
        view.addSubview(segmentedControl)
        view.addSubview(buttonBar)
        
        // Constrain the segmented control to the top of the container view
        segmentedControl.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        // Constrain the segmented control width to be equal to the container view width
        segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        // Constraining the height of the segmented control to an arbitrarily chosen value
        segmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: UIControl.Event.valueChanged)
        
        //        // Constrain the top of the button bar to the bottom of the segmented control
        //        buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        //        buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        //        // Constrain the button bar to the left side of the segmented control
        //        buttonBar.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor).isActive = true
        //        // Constrain the button bar to the width of the segmented control divided by the number of segments
        //        buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
        
        
        // add by chandra for notification start here
        if notificationInt == 2{
            
            /*Added by chandra 15/5/2020 starts here */
            self.buttonBar.frame.origin.x = (UIScreen.main.bounds.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
            self.buttonBar.frame.origin.y = 40
            self.buttonBar.frame.size.width = (UIScreen.main.bounds.width / CGFloat(self.segmentedControl.numberOfSegments))
            self.buttonBar.frame.size.height = 5
            /*Added by chandra 15/5/2020 ends here */
            
            // Constrain the top of the button bar to the bottom of the segmented control
            //            buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
            //            buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
            //            // Constrain the button bar to the left side of the segmented control
            //            buttonBar.rightAnchor.constraint(equalTo: segmentedControl.rightAnchor).isActive = true
            //            // Constrain the button bar to the width of the segmented control divided by the number of segments
            //            buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
        }else{
            
            /*Added by chandra 15/5/2020 starts here */
            self.buttonBar.frame.origin.x = (UIScreen.main.bounds.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
            self.buttonBar.frame.origin.y = 40
            self.buttonBar.frame.size.width = (UIScreen.main.bounds.width / CGFloat(self.segmentedControl.numberOfSegments))
            self.buttonBar.frame.size.height = 5
            /*Added by chandra 15/5/2020 ends here */
            
            
            
            // Constrain the top of the button bar to the bottom of the segmented control
            //            buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
            //            buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
            //            // Constrain the button bar to the left side of the segmented control
            //            buttonBar.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor).isActive = true
            //            // Constrain the button bar to the width of the segmented control divided by the number of segments
            //            buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
        }
        
        //        add by chandra  for notification ends here
        
        
        self.view.addSubview(view)
    }
    
    //MARK: QuickBLock Methods
    
    //    private func handleError(_ error: Error?, domain: ErrorDomain) {
    //        guard let error = error else {
    //            return
    //        }
    //        // let infoText = error.localizedDescription
    //
    //        showMessage(bodyText: error.localizedDescription ,theme: .error)
    //
    //
    //        if error._code == NSURLErrorNotConnectedToInternet {
    //        }
    //
    //    }
    
    //    private func showAlertView(message: String?) {
    //        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    //        alertController.addAction(UIAlertAction(title: UsersAlertConstant.okAction, style: .default,
    //                                                handler: nil))
    //        present(alertController, animated: true)
    //    }
    //    private func hasConnectivity() -> Bool {
    //
    //        let status = Reachability.instance.networkConnectionStatus()
    //        guard status != NetworkConnectionStatus.notConnection else {
    //            showAlertView(message: UsersAlertConstant.checkInternet)
    //            if CallKitManager.instance.isCallStarted() == false {
    //                CallKitManager.instance.endCall(with: callUUID) {
    //                    debugPrint("[UsersViewController] endCall")
    //                }
    //            }
    //            return false
    //        }
    //        return true
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
    
    //    private func messageText(action: DialogAction, withUsers users: [QBUUser]) -> String {
    //        let actionMessage = action == .create ? "created new dialog with:" : "added"
    //        guard let current = QBSession.current.currentUser,
    //            let fullName = current.fullName else {
    //                return ""
    //        }
    //        var message = "\(fullName) \(actionMessage)"
    //        for user in users {
    //            guard let userFullName = user.fullName else {
    //                continue
    //            }
    //
    //            message += " \(userFullName),"
    //        }
    //        message = String(message.dropLast())
    //        return message
    //    }
    
    
    //    private func call(with conferenceType: QBRTCConferenceType ,index:Int ,tap:Int) {
    //
    //        var dict :JSON!
    //        if tap == 1
    //        {
    //            dict = firstTabDataSet[index]
    //
    //        }else
    //        {
    //            dict = secondTabDataSet[index]
    //
    //        }
    //
    //        // connectToChat()
    //        if QBChat.instance.isConnected == false {
    //            self.connectToChat()
    //        }
    //        let profile = Profile()
    //
    //        guard profile.isFull == true, let currentConferenceUser = Profile.currentUser() else {
    //            return
    //        }
    //        chatManager.loadDialog(withName: "\(dict["Class_id"].intValue)@\(dict["title"].stringValue)") { (loadedDialog) in
    //
    //
    //            if let dialog = loadedDialog
    //            {
    //
    //                self.stopAnimating()
    //                CallPermissions.check(with:QBRTCConferenceType.video ) { [weak self] granted in
    //                    guard granted == true else { return }
    //                    /* Added By Prasuna on 16th April 2020 - starts here */
    //                    self?.hitServer(params: [:]
    //                        , endPoint: Endpoints.classStartedEndpoint + (self?.userId!)! + "/\(dict["Class_id"].intValue)", action: "StartCall", httpMethod: .get)
    //                    /* Added By Prasuna on 16th April 2020 - ends  here */
    //                    let callViewController = UIStoryboard.init(name: "Call", bundle: nil).instantiateViewController(withIdentifier: "CallViewController") as! CallViewController
    //                    callViewController.chatDialog = dialog
    //                    callViewController.conferenceType = QBRTCConferenceType.video
    //                    callViewController.dataSource = self?.dataSource
    //                    self?.navigationController?.pushViewController(callViewController, animated: true)
    //
    //                }
    //
    //
    //            }else {
    //
    //                var opponentsIDstr = [String]()
    //                var opponentsIDs = [NSNumber]()
    //                for (_, element) in (dict["quickbloxUserIDs"].arrayValue.enumerated()) {
    //
    //                    if element.numberValue != NSNumber(value: currentConferenceUser.userID)
    //                    {
    //                        opponentsIDs.append(NSNumber(value: element.intValue))
    //                        opponentsIDstr.append(String( element.intValue))
    //                    }
    //
    //                }
    //
    //                QBRequest.users(withIDs: opponentsIDstr, page: QBGeneralResponsePage.init(currentPage: 1, perPage: 10), successBlock: {(response ,page ,users) in
    //
    //                    let completion = { [weak self] (response: QBResponse?, dialog: QBChatDialog?) -> Void in
    //
    //                        guard dialog != nil else {
    //                            if (response?.error) != nil {
    //                            }
    //                            return
    //                        }
    //
    //                        self?.dialog = dialog?.id
    //
    //                    }
    //
    //                    //  let name =  "\(dict["Class_id"].intValue)"
    //                    let name =  "\(dict["Class_id"].intValue)@\(dict["title"].stringValue)" /* Added By Prasuna on 20th March 2020 */
    //                    self.chatManager.createGroupDialog(withName: name, photo: nil, occupants: users,occupantsId: opponentsIDs) { [weak self] (response, dialog) -> Void in
    //
    //                        guard response?.error == nil,
    //                            let dialog = dialog,
    //                            let dialogOccupants = dialog.occupantIDs else {
    //                                return
    //                        }
    //                        self?.dialog = dialog.id
    //                        if self!.hasConnectivity() {
    //
    //                            self?.stopAnimating()
    //                            CallPermissions.check(with:QBRTCConferenceType.video ) { [weak self] granted in
    //                                guard granted == true else { return }
    //                                /* Added By Prasuna on 16th April 2020 - starts here */
    //                                self?.hitServer(params: [:]
    //                                    , endPoint: Endpoints.classStartedEndpoint + (self?.userId!)! + "/\(dict["Class_id"].intValue)", action: "StartCall", httpMethod: .get)
    //                                /* Added By Prasuna on 16th April 2020 - ends  here */
    //                                let callViewController = UIStoryboard.init(name: "Call", bundle: nil).instantiateViewController(withIdentifier: "CallViewController") as! CallViewController
    //
    //                                callViewController.chatDialog = dialog
    //                                callViewController.conferenceType = QBRTCConferenceType.video
    //                                callViewController.dataSource = self?.dataSource
    //                                self?.navigationController?.pushViewController(callViewController, animated: true)
    //
    //
    //
    //                            }
    //
    //
    //                        }
    //
    //
    //                        guard let message = self?.messageText(action: .create, withUsers: users) else {
    //                            completion(response, nil)
    //                            return
    //                        }
    //
    //                        self?.chatManager.sendAddingMessage(message, action: .create, withUsers: dialogOccupants, to: dialog, completion: { (error) in
    //                            completion(response, dialog)
    //                        })
    //
    //
    //                    }
    //
    //                }, errorBlock: {(response) in
    //
    //                    self.stopAnimating()
    //                })
    //            }
    //
    //        }
    //    }
    
    //    private func connectToChat() {
    //        let profile = Profile()
    //        guard profile.isFull == true else {
    //            return
    //        }
    //
    //        QBChat.instance.connect(withUserID: profile.ID,
    //                                password: LoginConstant.defaultPassword,
    //                                completion: { [weak self] error in
    //                                    guard self != nil else { return }
    //                                    if let error = error {
    //                                        if error._code == QBResponseStatusCode.unAuthorized.rawValue {
    //                                            // self.logoutAction()
    //                                        } else {
    //                                            debugPrint("[UsersViewController] login error response:\n \(error.localizedDescription)")
    //                                        }
    //                                    } else {
    //                                        //did Login action
    //                                        // SVProgressHUD.dismiss()
    //                                    }
    //        })
    //    }
    
}

extension MyClassVC: UITableViewDataSource, GroupCell { //GroupCell Protocol Added by Dk on 12/02/2020.
    
    func downloadRequestedClassInformation(completed : @escaping DownloadComplete) {
        print("Deepak Kumar url ", globalListEndPoint)
        // print("Deepak Kumar searchURl " , searchUrl!)
        Alamofire.request(globalListEndPoint).responseJSON {
            response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject>{
                if let controlsData = dict["ControlsData"] as? Dictionary<String, AnyObject> {
                    if let lsvGrp = controlsData["RequestedClassList"] as? [Dictionary<String, Any>]{
                        print(lsvGrp)
                        if lsvGrp.count != 0 {
                            for obj in lsvGrp {
                                let cellData = RequestedClassInfoData(requestedClassDict : obj as Dictionary<String, AnyObject>)
                                self.cellDatas.append(cellData)
                                print("appendData>>\(self.cellDatas)")
                            }
                        }
                        else {
                            return
                        }
                        self.classTableView.reloadData()
                    }
                }
            }
            completed()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return firstTabDataSet.count
        /*Added by yasodha on 27/1/2020 -start*/
        //        if self.navigationController?.viewControllers.previous is PersonalProfileVC {
        //
        //            if actionClass == "classDataSet"{
        //                return classDataSet.count
        //            }
        //        }else{/*Added by yasodha on 27/1/2020- ends*/
        if actionName == "tab1" {
            return firstTabDataSet.count
        }else if actionName == "tab2" {
            return secondTabDataSet.count
        }else if actionName == "tab4" {
            return cellDatas.count
        }else if actionName == "Expired Classes" {//Added by yasodha
            return expClassData.count
            
        }else if actionName == "AttendedClasses" {//Added by yasodha
            return classesAttendedData.count
        }
        else {
            return thirdTabDataSet.count
        }
        // }//else
        return 0
        
    }
    
    @objc func ImgTapped(sender:AnyObject){
        let userId = cellDatas[sender.view.tag].studentUserID
        let vc = storyboard?.instantiateViewController(withIdentifier: "personalprofile") as! PersonalProfileVC
        vc.userID = userId
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if actionName == "AttendedClasses"{
            dict = classesAttendedData[indexPath.row]
            self.classTableView.register(UINib.init(nibName: "ClassesAttended", bundle: nil), forCellReuseIdentifier: "classesAttendedCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "classesAttendedCell", for: indexPath) as! ClassesAttended
            cell.subView.isHidden = false
            //cell.profileVwHight.constant = 55
            // add by chandra for rating view
            cell.ratingView.rating = dict["Rating"].intValue == 0 ? 2.5 : Double(dict["Rating"].intValue)// Updated By Veeresh on 3rd April 2020 /
            cell.ratingView.isHidden = false
            let stringUrl = dict["profileURL"].stringValue
            let thumbnail = stringUrl.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
            cell.profileImg?.sd_setImage(with: URL.init(string:thumbnail ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
            cell.profileImg.setRounded()
            // cell.profileImg.contentMode = .scaleAspectFill
            cell.profileImg.clipsToBounds = true
            cell.nameLabel.text = dict["fullname"].stringValue
            
            //20/12/2019
            // View tap related to image
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(uiViewWithImageTapped))
            cell.profileImg.tag = indexPath.row
            tap1.numberOfTapsRequired = 1
            cell.profileImg.isUserInteractionEnabled = true
            cell.profileImg.addGestureRecognizer(tap1)
            
            cell.testTitleLabel.text = dict["title"].stringValue
            
            if dict["SubjectID"].intValue <= 4 {
                
                if(dict["SubjectID"].intValue) == 0{
                    
                }else{
                    cell.subjectNameLabel.text = subjects[dict["SubjectID"].intValue-1]
                    
                }
                
            }else {
                cell.subjectNameLabel.text = "Invalid Subject Name"
            }
            if getSubjectName(with: dict["Sub_SubjectID"].intValue) != nil {
                cell.subSubjectNameLabel.text = getSubjectName(with: dict["Sub_SubjectID"].intValue)!
            }
            cell.gradesLblValue.text = dict["Grades"].stringValue
            
            var fromTimingDate: Date?
            var toTimingDate: Date?
            
            fromTimingDate = self.serverToLocal(date: dict["UTC_ClassDatetime"].stringValue)
            toTimingDate = self.serverToLocal(date: dict["UTC_ClassEndtime"].stringValue)
            
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MMM-yyyy HH:mm"
            let fromTimingDateString = formatter.string(from: fromTimingDate!)
            
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "dd-MMM-yyyy HH:mm"
            let toTimingDateString = formatter1.string(from: toTimingDate!)
            
            let startTimeParts = fromTimingDateString.split(separator: " ")
            let endTimeParts = toTimingDateString.split(separator: " ")
            cell.dateLabel.text = "\(startTimeParts[0])"
            
            let startTime: String = amAppend(str: String(startTimeParts[1]))
            let endTime:String = amAppend(str: String(endTimeParts[1]))
            //cell.timeLabel.text = "\(startTime) - \(endTime)"
            currentTimeZoneName = getCurrentTimeZoneName()
            cell.timeLabel.text = "\(startTime) - \(endTime) (\(currentTimeZoneName))"
            
            
            
         //   cell.pointsCharegedLabel.text = dict["Pay_points"].stringValue
            cell.numberOfAttendeesLabel.text = dict["num_Subscribed"].stringValue
            if dict["SharedType"].intValue == 1 {
                cell.publicBtn.isSelected = false
            }else {
                cell.publicBtn.isSelected = true
            }
            print(dict["IsClassDelivered"].intValue)
//            if dict["IsClassDelivered"].intValue == 1 {
//                //cell.notAttendedBTn.isHidden = true
//                cell.notAttendedBTn.setTitle("Attended", for: .normal)
//                cell.notAttendedBTn.titleLabel?.textColor = .green
//            }else {
//               cell.notAttendedBTn.setTitle("Not Attended", for: .normal)
//                cell.notAttendedBTn.titleLabel?.textColor = .red
//                //cell.notAttendedBTn.isHidden = false
//            }
            
            if dict["IsClassDelivered"].intValue == 1 {
            //cell.notAttendedBTn.isHidden = true
            // cell.notAttendedBTn.titleLabel?.text = "Attended"



            cell.notAttendedBTn.setTitle("Attended", for: .normal)
            cell.notAttendedBTn.setTitleColor(UIColor.init(hex: "7DC20B"), for: .normal)

            //cell.notAttendedBTn.setTitleColor(.green, for: .normal)
            //cell.notAttendedBTn.titleLabel?.textColor = .green
            }else {
            //cell.notAttendedBTn.titleLabel?.text = "Not Attended"
            cell.notAttendedBTn.setTitle("Not Attended", for: .normal)
            cell.notAttendedBTn.setTitleColor(.red, for: .normal)

            // cell.notAttendedBTn.titleLabel?.textColor = .red
            //cell.notAttendedBTn.isHidden = false
            }
            
            if dict["num_Subscribed"].stringValue == "0"
            {//updated by yasodha
                cell.infoClassBtn.isHidden = true
                
            }else{
                cell.infoClassBtn.isHidden = false
                cell.infoClassBtn.tag = dict["Class_id"].intValue
                cell.infoClassBtn.addTarget(self, action: #selector(onInfoBtnClicked), for: .touchUpInside)
            }
            
            //if point zero we have to give green colore
            if dict["Pay_points"].stringValue == "0"{
                cell.pointsCharegedLabel.textColor = UIColor.init(hex: "7DC20B")
                cell.pointsCharegedLabel.text = "Free"
            }else{
                cell.pointsCharegedLabel.textColor = UIColor.init(hex: "2DA9EC")
                cell.pointsCharegedLabel.text = dict["Pay_points"].stringValue
            }
            
            
            
            cell.rateAndReviewBTn.tag = indexPath.row
            cell.rateAndReviewBTn.addTarget(self, action: #selector(onReviewButtonPressed), for: .touchUpInside)
            
            return cell
            
        }else if actionName == "tab4"{
            if cellDatas.count != 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "requestedclasscell", for: indexPath) as! RequestedClassInfoCell
                let data = cellDatas[indexPath.row]
                cell.updateCell(requestedClassInfoData: data)
                cell.cellDelegate = self
                cell.index = indexPath
                cell.acceptButton.tag = indexPath.row
                cell.declineButton.tag = indexPath.row
                print("image tags = \(cell.declineButton.tag)" )
                print("index path = " , indexPath.row)
                let gasture = UITapGestureRecognizer(target: self, action: #selector(ImgTapped))
                cell.requesteeImg.tag = indexPath.row
                cell.requesteeImg.isUserInteractionEnabled = true
                cell.requesteeImg.addGestureRecognizer(gasture)
                return cell
            }
            return RequestedClassInfoCell()
            //
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myclasscell") as! MyClassCell
            
            var dict: JSON
            cell.nsLayoutConstrintStartBtn.constant = 30//Added by yasodha
            
            cell.startBtn.isHidden = false   /* Added By Yashoda on 16th April 2020 */
         cell.WhiteBoard.isHidden = true //yasodha
            
            if self.actionName == "tab1" {
                
                dict = firstTabDataSet[indexPath.row]
                cell.startBtn.setTitle("Join", for: .normal)
                //              cell.startBtn.setTitle("Start", for: .normal) // commented by chandra
                cell.startBtn.backgroundColor = UIColor.init(hex:"60A200")
                cell.startBtn.isUserInteractionEnabled = true
                cell.SsubscribeBtn.isHidden = true
                cell.editClassBtn.isHidden = false
                cell.deleteClassBtn.isHidden = false
                cell.subView.isHidden = true
                cell.profileVwHight.constant = 0
                 /* Added By Yashoda on 11th june 2020 starts here*/
                cell.WhiteBoard.isHidden = false //yasodha
                cell.nsLayoutConstraintWhiteBoardLeft.constant = 111
                cell.WhiteBoard.topAnchor.constraint(equalTo: cell.SsubscribeBtn.topAnchor, constant: 0).isActive = true
                cell.WhiteBoard.rightAnchor.constraint(equalTo: cell.SsubscribeBtn.rightAnchor, constant: 0).isActive = true
                cell.WhiteBoard.bottomAnchor.constraint(equalTo: cell.SsubscribeBtn.bottomAnchor, constant: 0).isActive = true
                /* Added By Yashoda on 11th june 2020 end here*/
                //            add by chandra for rating view
                /* Added By Prasuna on 11th April 2020 - starts here */
                var diff : TimeInterval?
                if let date2 = self.serverToLocal(date: dict["UTC_ClassDatetime"].stringValue)
                {
                    
                    // diff = abs(Date().timeOfDayInterval(toDate: date2)) /* Commented  By Prasuna on 21st April 2020 */
                    diff =  date2.timeIntervalSince(Date()) /* Added By Prasuna on 21st April 2020 */
                    
                }
                
                // if diff!/60 < 30  /* Commented  By Prasuna on 21st April 2020 */
                if diff!/60 >= 30  /* Updated  By Prasuna on 21st April 2020 */
                {
                    //                    cell.startBtn.isUserInteractionEnabled = true /* Commented  By Prasuna on 25th April  2020 */
                    //                    cell.startBtn.backgroundColor = UIColor.init(hex:"60A200") /* Commented  By Prasuna on 25th April  2020 */
                    cell.startBtn.isUserInteractionEnabled = false  /* Added  By Prasuna on 25th April  2020 */
                    cell.startBtn.backgroundColor = UIColor.lightGray  /* Added  By Prasuna on 25th April  2020 */
                }else
                {
                    //                    cell.startBtn.isUserInteractionEnabled = false /* Commented  By Prasuna on 25th April  2020 */
                    //                    cell.startBtn.backgroundColor = UIColor.lightGray /* Commented  By Prasuna on 25th April  2020 */
                    cell.startBtn.isUserInteractionEnabled = true  /* Added  By Prasuna on 25th April  2020 */
                    cell.startBtn.backgroundColor = UIColor.init(hex:"60A200")  /* Added  By Prasuna on 25th April  2020 */
                }
                /* Added By Prasuna on 11th April 2020 - ends here */
                cell.ratingView.isHidden = true
            }else if actionName == "tab2" {
                dict = secondTabDataSet[indexPath.row]
                cell.startBtn.setTitle("Join", for: .normal)
                cell.startBtn.backgroundColor = UIColor.init(hex:"60A200")
                cell.startBtn.isUserInteractionEnabled = true
                cell.SsubscribeBtn.isHidden = false
                cell.editClassBtn.isHidden = true
                cell.deleteClassBtn.isHidden = true
                cell.subView.isHidden = false
                cell.profileVwHight.constant = 55
                //            add by chandra for rating view
                cell.ratingView.rating = dict["Rating"].intValue == 0 ? 2.5 : Double(dict["Rating"].intValue)/* Updated By Veeresh on 3rd April 2020 */
                cell.ratingView.isHidden = false
                let stringUrl = dict["profileURL"].stringValue
                let thumbnail = stringUrl.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
                cell.profileImg?.sd_setImage(with: URL.init(string:thumbnail ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
                cell.profileImg.setRounded()
                cell.profileImg.contentMode = .scaleAspectFill
                cell.nameLabel.text = dict["fullname"].stringValue
                /* Added By Yashoda on 11th june 2020 starts here*/
                cell.WhiteBoard.isHidden = false
                cell.nsLayoutConstraintWhiteBoardLeft.constant = 8
                /* Added By Yashoda on 11th june 2020 ends here*/
                //20/12/2019
                // View tap related to image
                let tap1 = UITapGestureRecognizer(target: self, action: #selector(uiViewWithImageTapped))
                cell.profileImg.tag = indexPath.row
                tap1.numberOfTapsRequired = 1
                cell.profileImg.isUserInteractionEnabled = true
                cell.profileImg.addGestureRecognizer(tap1)
                /* Added By Prasuna on 11th April 2020 - starts here */
                var diff : TimeInterval?
                if let date2 = self.serverToLocal(date: dict["UTC_ClassDatetime"].stringValue)
                {
                    
                    //  diff = abs(Date().timeOfDayInterval(toDate: date2)) /* Commented By Prasuna on 21st April  2020 */
                    diff = date2.timeIntervalSince(Date()) /* Updated By Prasuna on 21st April  2020 */
                    
                    
                }
                if diff!/60 >= 30 /* Updated By Prasuna on 21st April  2020 */
                    
                    //                if diff!/60 < 30 /* Commented  By Prasuna on 21st April  2020 */
                {
                    //                    cell.startBtn.isUserInteractionEnabled = true /* Commented  By Prasuna on 21st April  2020 */
                    //                    cell.startBtn.backgroundColor = UIColor.init(hex:"60A200") /* Commented  By Prasuna on 21st April  2020 */
                    cell.startBtn.isUserInteractionEnabled = false /* Updated  By Prasuna on 21st April  2020 */
                    cell.startBtn.backgroundColor = UIColor.lightGray /* Updated  By Prasuna on 21st April  2020 */
                }else
                {
                    //                    cell.startBtn.isUserInteractionEnabled = false /* Commented  By Prasuna on 21st April  2020 */
                    //                    cell.startBtn.backgroundColor = UIColor.lightGray /* Commented  By Prasuna on 21st April  2020 */
                    cell.startBtn.isUserInteractionEnabled = true /* Updated  By Prasuna on 21st April  2020 */
                    cell.startBtn.backgroundColor = UIColor.init(hex:"60A200")/* Updated  By Prasuna on 21st April  2020 */
                }
                /* Added By Prasuna on 11th April 2020 - ends here */
                
            }else if self.actionName == "Expired Classes" {//Added by yasodha
                
                dict = expClassData[indexPath.row]
                
                //cell.startBtn.setTitle("Join", for: .normal)//commented by yasodha
                cell.nsLayoutConstrintStartBtn.constant = 0
                cell.startBtn.backgroundColor = UIColor.init(hex:"60A200")
                cell.startBtn.isUserInteractionEnabled = true
                cell.startBtn.isHidden = true /* Added By Yashoda on 16th April 2020 */
                cell.SsubscribeBtn.isHidden = true
                cell.editClassBtn.isHidden = false
                cell.deleteClassBtn.isHidden = false
                cell.subView.isHidden = true
                cell.profileVwHight.constant = 0
                //            add by chandra for rating view
                cell.ratingView.isHidden = true
                /*Added by yasodha */
            }else {
                //              add by chandra for rating view
                cell.ratingView.isHidden = false
                cell.subView.isHidden = false
                cell.profileVwHight.constant = 55
                dict = thirdTabDataSet[indexPath.row]
                cell.ratingView.rating = dict["Rating"].intValue == 0 ? 2.5 : Double(dict["Rating"].intValue)/* Updated By Veeresh on 3rd April 2020 */
                if dict["isClassFull"].intValue == 0 {
                    cell.startBtn.setTitle("Subscribe", for: .normal)
                    cell.startBtn.backgroundColor = UIColor.init(hex:"60A200")
                    cell.startBtn.isUserInteractionEnabled = true
                }else{
                    cell.startBtn.setTitle("Class is full", for: .normal)
                    cell.startBtn.backgroundColor = UIColor.red
                    cell.startBtn.isUserInteractionEnabled = false
                }
                cell.SsubscribeBtn.isHidden = true
                cell.editClassBtn.isHidden = true
                cell.deleteClassBtn.isHidden = true
                cell.profileImg?.sd_setImage(with: URL.init(string:"" ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
                let stringUrl = dict["profileURL"].stringValue
                let thumbnail = stringUrl.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
                cell.profileImg?.sd_setImage(with: URL.init(string:thumbnail ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
                cell.profileImg.setRounded()
                cell.profileImg.contentMode = .scaleAspectFill
                cell.nameLabel.text = dict["fullname"].stringValue
                
                //20/12/2019
                // View tap related to image
                let tap1 = UITapGestureRecognizer(target: self, action: #selector(uiViewWithImageTapped))
                cell.profileImg.tag = indexPath.row
                tap1.numberOfTapsRequired = 1
                cell.profileImg.isUserInteractionEnabled = true
                cell.profileImg.addGestureRecognizer(tap1)
                
                
            }
            // else if self.actionName == "" {}
            // else if self.actionName == "" {}
            
            cell.testTitleLabel.text = dict["title"].stringValue
            
            print("Class Name : \(dict["title"].stringValue)")
            print("SubJectID:::\(dict["SubjectID"].intValue)")
            
            if dict["SubjectID"].intValue <= 4  {
                
                if(dict["SubjectID"].intValue) == 0{
                    
                }else{
                    cell.subjectNameLabel.text = subjects[dict["SubjectID"].intValue-1]
                    
                }
                //  cell.subjectNameLabel.text = subjects[dict["SubjectID"].intValue-1]
                
            }else {
                cell.subjectNameLabel.text = "Invalid Subject Name"
            }
            /* Modified on 28th Feb 2020 By Ranjeet */
            if  getSubjectName(with: dict["Sub_SubjectID"].intValue) != nil {
                cell.subSubjectNameLabel.text = getSubjectName(with: dict["Sub_SubjectID"].intValue)! /* Time being crashes coming thats the reason i commented this line , later uncomment this  */
            }
            
            cell.gradesLblValue.text = dict["Grades"].stringValue//Added by yasodha
            /*Added by yasodha 6/3/2020 starts here*/
            
            var fromTimingDate: Date?
            var toTimingDate: Date?
            
            fromTimingDate = self.serverToLocal(date: dict["UTC_ClassDatetime"].stringValue)
            toTimingDate = self.serverToLocal(date: dict["UTC_ClassEndtime"].stringValue)
            
            
            let formatter = DateFormatter()
            // formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.dateFormat = "dd-MMM-yyyy HH:mm" /* unCommented By Yashoda on 29th Apil 2020 */
            
            /**********************************Commented by yasodha***********************************/
            /* Updated By Yashoda on 25th April 2020 - starts here */
            //            formatter.dateFormat = "dd-MMM-yyyy h:mm a"
            //                                             formatter.amSymbol = "AM"
            //                                             formatter.pmSymbol = "PM"
            /**********************************Commented by yasodha***********************************/
            
            let fromTimingDateString = formatter.string(from: fromTimingDate!)
            /* Updated By Yashoda on 25th April 2020 - ends  here*/
            
            let formatter1 = DateFormatter()
            // formatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter1.dateFormat = "dd-MMM-yyyy HH:mm" /* unCommented By Yashoda on 29th April 2020 */
            
            /**********************************Commented by yasodha***********************************/
            
            /* Updated By Yashoda on 25th April 2020 - starts here*/
            //            formatter1.dateFormat = "dd-MMM-yyyy h:mm a"
            //                                  formatter.amSymbol = "AM"
            //                                  formatter.pmSymbol = "PM"
            /* Updated By Yashoda on 25th April 2020 - ends here  */
            /**********************************Commented by yasodha***********************************/
            
            
            let toTimingDateString = formatter1.string(from: toTimingDate!)
            
            let startTimeParts = fromTimingDateString.split(separator: " ")
            let endTimeParts = toTimingDateString.split(separator: " ")
            
            
            cell.dateLabel.text = "\(startTimeParts[0])"
            /*Added by yasodha 29/4/2020 starts here */
            let startTime: String = amAppend(str: String(startTimeParts[1]))
            let endTime:String = amAppend(str: String(endTimeParts[1]))
            
            currentTimeZoneName = getCurrentTimeZoneName()
            cell.timeLabel.text = "\(startTime) - \(endTime) (\(currentTimeZoneName))"
            /*Added by yasodha 29/4/2020 ends here */
            
            
            /****************************************Commented y yasodha 29/4/2020 starts here**********************************************/
            
            //            cell.timeLabel.text = "\(startTimeParts[1]) - \(endTimeParts[1])"  /* Updated By Yashoda on 25th April 2020   */
            
            /* Updated By Yashoda on 25th April 2020 - starts  here  */
            // let space = " "
            //  cell.timeLabel.text = "\(startTimeParts[1])\(space)\(startTimeParts[2]) - \(endTimeParts[1])\(space)\(endTimeParts[2])"
            /* Updated By Yashoda on 25th April 2020 - ends here  */
            /* Updated by yasodha 6/3/2020  - ends here*/
            /*************************************Commented by yasodha 29/4/2020  ends here************************************************/
            
            
            
           // cell.pointsCharegedLabel.text = dict["Pay_points"].stringValue
            cell.numberOfAttendeesLabel.text = dict["num_Subscribed"].stringValue
            if dict["SharedType"].intValue == 1 {
                cell.publicBtn.isSelected = false
            }else {
                cell.publicBtn.isSelected = true
            }
            
            cell.editClassBtn.tag = dict["Class_id"].intValue
            UserDefaults.standard.set(dict["num_Subscribed"].stringValue, forKey: "\(dict["Class_id"].intValue)")//Added By Yashoda on 4th March 2020
            cell.editClassBtn.addTarget(self, action: #selector(onEditClassBtnClicked), for: .touchUpInside)
            cell.deleteClassBtn.tag = indexPath.row
            //dict["Class_id"].intValue
            cell.deleteClassBtn.addTarget(self, action: #selector(onDeleteClassBtnClicked), for: .touchUpInside)
            
            //cell.startBtn.tag = dict["Class_id"].intValue
            cell.startBtn.tag = indexPath.row
            cell.startBtn.addTarget(self, action: #selector(onStartBtnClicked), for: .touchUpInside)
            cell.SsubscribeBtn.tag = dict["Class_id"].intValue
            cell.SsubscribeBtn.addTarget(self, action: #selector(onSubcriptionBtnClicked), for: .touchUpInside)
            /* added by yasodha on 11th june */
            cell.WhiteBoard.addTarget(self, action: #selector(onWhiteBoardBthClicked), for: .touchUpInside)//yasodha
            //                if dict["num_Subscribed"].stringValue == "0" || personTypechuck == 1 || actionName == "Expired Classes"
            if dict["num_Subscribed"].stringValue == "0" || actionName == "Expired Classes"
            {//updated by yasodha
                cell.infoClassBtn.isHidden =  true
                
            }else{
                cell.infoClassBtn.isHidden =  false
                cell.infoClassBtn.tag = dict["Class_id"].intValue
                cell.infoClassBtn.addTarget(self, action: #selector(onInfoBtnClicked), for: .touchUpInside)
            }
            
            //if point zero we have to give green colore
            if dict["Pay_points"].stringValue == "0"{
                cell.pointsCharegedLabel.textColor = UIColor.init(hex: "7DC20B")
                cell.pointsCharegedLabel.text = "Free"
            }else{
                cell.pointsCharegedLabel.textColor = UIColor.init(hex: "2DA9EC")
                cell.pointsCharegedLabel.text = dict["Pay_points"].stringValue
            }
            
            
            
            //}   /* Added By Yashoda on 27th Jan 2020  else - end */
            
            return cell
        }
        
        
    }
    func onDeclineButton(index: Int) {
        cellIndex = index
        let alert = UIAlertController(title: "Warning!", message: "Are you sure you want to decline the class request?", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Decline", style: .default, handler: self.declineTheRequest)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func declineTheRequest(alert : UIAlertAction!) {
        let url = "\(Endpoints.declineRequestedClassEndpoint)\(cellDatas[cellIndex].requestID)"
        Alamofire.request(URL(string : url)!).responseJSON {
            response in
            //print(response)
            self.cellDatas.remove(at: self.cellIndex)
            DispatchQueue.main.async {
                self.classTableView.reloadData()
            }
        }
    }
    
    func onAcceptButton(index: Int) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreateNewClassForTeacherNotificationVC") as? CreateNewClassForTeacherNotificationVC
        self.navigationController?.pushViewController(vc!, animated: true)
        vc?.uniqueID = cellDatas[index].requestID
        print(cellDatas[index].requestID,"Deepak Kumar")
    }
    
    func onUnsubscribeButton(index : Int){} /* Added By Deepak on 16th April 2020 */
    @objc func uiViewWithImageTapped(sender: UITapGestureRecognizer) {
        
        var dict : JSON?
        if actionName == "tab2"
        {
            dict = secondTabDataSet[(sender.view?.tag)!]
            
        }else if actionName == "AttendedClasses"{
            dict = classesAttendedData[(sender.view?.tag)!]
            
        }else
        {
            dict = thirdTabDataSet[(sender.view?.tag)!]
        }
        
        previousViewController = "PersonalProfileVC"
        let personalprofile = storyboard?.instantiateViewController(withIdentifier: "personalprofile") as! PersonalProfileVC
        personalprofile.userID = dict?["UserID"].stringValue ?? ""
        navigationController?.pushViewController(personalprofile, animated: false) // comment this line when animation not required //
    }
    // add by yusodha 05/3/2020 start here
    @objc func onEditClassBtnClicked(sender: UIButton) {
        // add by chandra for button animation
        //        sender.springAnimation(btn: sender)// add by chandra for spring animation to the button
        //        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
        
        print("onEditClassBtnClicked classID = \(sender.tag)")
        self.number_Of_Attendees = (UserDefaults.standard.string(forKey: "\(sender.tag)")!)
        
        if self.number_Of_Attendees == "0" || actionName == "Expired Classes"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "createClassvc") as! AddClassVC
            vc.isEditClass = true
            vc.classID = "\(sender.tag)"
            if actionName == "Expired Classes"{
                vc.isExpiredClass = true//updated by yasodha on 6/5/2020
            }
            //vc.isExpiredClass = true//updated by yasodha on 6/5/2020
            vc.number_Of_Attendees = (UserDefaults.standard.string(forKey: "\(sender.tag)")!)
            vc.refreshClassList = {[unowned self] in
                self.hitService()
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else {
            
            
            
            let alert = UIAlertController(title: "", message: "\(self.number_Of_Attendees!) students have subscribed for this class, would you like to create a copy of this class?", preferredStyle: UIAlertController.Style.alert)
            // show the alert
            self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { action in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "createClassvc") as! AddClassVC
                vc.isEditClass = true
                vc.classID = "\(sender.tag)"
                
                vc.number_Of_Attendees = (UserDefaults.standard.string(forKey: "\(sender.tag)")!)
                vc.refreshClassList = {[unowned self] in
                    self.hitService()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            }))//alert
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: { action in
                
            }))//alert
            
        }//else
        
        
        //        })
        
        
    }
    
    // add by yusodha 05/3/2020 ends here
    @objc func onDeleteClassBtnClicked(sender: UIButton) {if self.actionName == "Expired Classes"{
        
        let alert = UIAlertController(title: "Delete Class", message: "Are you sure you want to delete this class?", preferredStyle: UIAlertController.Style.alert)
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { action in
            
            
            print("onDeleteClassBtnClicked index = \(sender.tag)")
            //if dict["UserID"].string == userId! {
            
            let classID = self.expClassData[sender.tag]["Class_id"].intValue
            self.deletedItemIndex = sender.tag
            self.hitServer(params: [:], endPoint: Endpoints.deleteClassEndPoint + self.userId! + "/" + "\(classID)",action: "deleteExpClass", httpMethod: .get)
            
            self.classTableView.reloadData()
        }))//alert
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: { action in
            
            return
            
        }))
        
        
        
        
    }else{
        
        
//        if self.firstTabDataSet[sender.tag]["num_Subscribed"].intValue > 0 {
//            showMessage(bodyText: "You cannot delete the class as it is subscribed by other users",theme: .warning)
//            return
//        }
        
        
        let alert = UIAlertController(title: "Delete Class", message: "Are you sure you want to delete this class?", preferredStyle: UIAlertController.Style.alert)
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { action in
            
            
            print("onDeleteClassBtnClicked index = \(sender.tag)")
            //if dict["UserID"].string == userId! {
            print("Delete class")
            //{UserID}/{ClassID}
            let classID = self.firstTabDataSet[sender.tag]["Class_id"].intValue
            self.actionName = "deleteMyClass"
            self.deletedItemIndex = sender.tag
            self.hitServer(params: [:], endPoint: Endpoints.deleteClassEndPoint + self.userId! + "/" + "\(classID)",action: "deleteMyClass", httpMethod: .get)
            self.classTableView.reloadData()
            
        }))//alert
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: { action in
            
            return
            
        }))
        
        
        
        
        
        }
        /* Updated By Yashoda on 17th April 2020 - ends  here */
    }
    
    @objc func onStartBtnClicked(sender: UIButton) {
        //       sender.borderAnimation(btn: sender, color: UIColor.orange,keyPath:"strokeEnd" )
        //         sender.fullflash(btn: sender)
        /*Added by yasodha on 27/1/2020 - start */
        //        if self.navigationController?.viewControllers.previous is PersonalProfileVC {
        //            let dict = classDataSet[sender.tag]
        //            if NetworkReachabilityManager()?.isReachable ?? false {
        //                guard let ID = UserDefaults.standard.string(forKey: "QuickBlockID") else { return }
        //                let endPoint = Endpoints.quickBlockRegisterEndPoint + userId! + "/" + "\(dict["Class_id"].intValue)/" + ID
        //                actionName = "subscribe"
        //                hitServer(params: [:], endPoint: endPoint ,action: actionName, httpMethod: .get)
        //
        //            }else {
        //                //NO Internet connection, just return
        //                showMessage(bodyText: "No internet connection",theme: .warning)
        //            }
        //
        //
        //
        //        }else{/*Added by yasodha on 27/1/2020 -ends here */
        print("onStartBtnClicked index = \(sender.tag)")
        if self.actionName == "tab1" {
            print(" Start ")
            let dict = firstTabDataSet[sender.tag] // add by chandra for how maney attends on 31/1/2020
            let attendesZeroChuch = dict["num_Subscribed"].stringValue
//            if attendesZeroChuch == "0"{
//
//                showMessage(bodyText: "At least one attendees should be subscribed to initiate call.",theme:.warning,presentationStyle:.center,duration:.seconds(seconds: 0.2) )
//
//            }else{
                /*Added by yasodha on 4/6/2020 starts here */
               // startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))//commented by yasodha

//                guard let viewController:UIViewController = UIStoryboard(name: "Call", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
//                return
//                }
//
//                self.title = "Call"
//                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Call", style: .plain, target: nil, action: nil)
//                self.navigationController?.pushViewController(viewController, animated: true)

                let endPoint = Endpoints.classStartedEndpoint + userId! + "/" + "\(dict["Class_id"].intValue)"
                actionName = "startClass"
                hitServer(params: [:], endPoint: endPoint ,action: actionName, httpMethod: .get)
                
                startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
                let hostURL = dict["hostURL"].stringValue
                if hostURL == ""{
                    self.stopAnimating()
                    
                    // showMessage(bodyText: "Not part of zoom meeting.. call.",theme:.warning,presentationStyle:.center,duration:.seconds(seconds: 0.2) )
                showMessage(bodyText: "Not part of zoom meeting.. call.",theme: .warning)
                return

                }else if let url = NSURL(string:dict["hostURL"].stringValue){
                UIApplication.shared.openURL(url as URL)

                }
                print("hostURL: \(dict["hostURL"].stringValue)")
                self.stopAnimating()


                /*Added by yasodha on 4/6/2020 ends here */
                //startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
                //                call(with: QBRTCConferenceType.video, index: sender.tag, tap: 1)
           // }
            //call(with: QBRTCConferenceType.video, index: sender.tag) // commented by chandra 31/1/2020
            
            
        }else if actionName == "tab2" {
            
            print(" Join ")
            //                showMessage(bodyText: "Work in Progress",theme: .success,presentationStyle: .center, duration: .seconds(seconds: 1))
            //startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
            //            call(with: QBRTCConferenceType.video, index: sender.tag, tap: 2)
            /*Added by yasodha on 4/6/2020 starts here */

          //  startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))//commented by yasodha
//            guard let viewController:UIViewController = UIStoryboard(name: "Call", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
//            return
//            }
//
//            self.title = "Call"
//            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Call", style: .plain, target: nil, action: nil)
//            self.navigationController?.pushViewController(viewController, animated: true)

            let dict = secondTabDataSet[sender.tag]
            let endPoint = Endpoints.classStartedEndpoint + userId! + "/" + "\(dict["Class_id"].intValue)"
            actionName = "Joinclass"
            hitServer(params: [:], endPoint: endPoint ,action: actionName, httpMethod: .get)
            
            startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
            let hostURL = dict["hostURL"].stringValue
            if hostURL == ""{
                self.stopAnimating()
            // showMessage(bodyText: "Not part of zoom meeting.. call.",theme:.warning,presentationStyle:.center,duration:.seconds(seconds: 0.2) )
            showMessage(bodyText: "Not part of zoom meeting.. call.",theme: .warning)
            return

            }else if let url = NSURL(string:dict["hostURL"].stringValue){
            UIApplication.shared.openURL(url as URL)


            }

            print("hostURL: \(dict["hostURL"].stringValue)")
            self.stopAnimating()
            /*Added by yasodha on 4/6/2020 ends here */
            
        }else {
            
            print(" subscribe ")
            let dict = thirdTabDataSet[sender.tag]
            if NetworkReachabilityManager()?.isReachable ?? false {
                //Internet connected,Go ahead
//                let data = UserDefaults.standard.string(forKey: "QuickBlockID")
//                print(data!)
//                guard let ID = UserDefaults.standard.string(forKey: "QuickBlockID")
//                    else {
//                        return
//                }
//                let endPoint = Endpoints.quickBlockRegisterEndPoint + userId! + "/" + "\(dict["Class_id"].intValue)/" + "0"
//                actionName = "subscribe"
//                hitServer(params: [:], endPoint: endPoint ,action: actionName, httpMethod: .get)
                var count = 0
                for value in subcribed
                {
                    if value == dict["Class_id"].stringValue
                    {
                        count = count + 1
                    }
                    
                }
                if count == 0 {
                    let endPoint = Endpoints.subscribeClassEndPoint + userId! + "/" + "\(dict["Class_id"].intValue)"
                    actionName = "subscribe"
                    classIdString = dict["Class_id"].stringValue
                    hitServer(params: [:], endPoint: endPoint ,action: actionName, httpMethod: .get)
                    subcribed.append(dict["Class_id"].stringValue)
                }
                
            }else {
                //NO Internet connection, just return
                showMessage(bodyText: "No internet connection",theme: .warning)
            }
        }
        //   }//else
        
    }
    @objc func onSubcriptionBtnClicked(sender: UIButton) {
        print("onSubcriptionBtnClicked classID = \(sender.tag)")
        print("Unsubscribe ")
        
         let objectToRemove = "\(sender.tag)"
        if let idx = subcribed.firstIndex(of: objectToRemove) {
                  subcribed.remove(at: idx)
              }
              
        if NetworkReachabilityManager()?.isReachable ?? false {
            //Internet connected,Go ahead
            let endPoint = Endpoints.unsubscribeClassEndPoint + userId! + "/" + "\(sender.tag)"
            actionName = "unsubscribe"
            hitServer(params: [:], endPoint: endPoint ,action: actionName, httpMethod: .get)
        }else {
            //NO Internet connection, just return
            showMessage(bodyText: "No internet connection",theme: .warning)
        }
    }
    @objc func onWhiteBoardBthClicked(sender: UIButton) {
        
         previousViewController = "WhiteBoard"

        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
                       return
                   }
        //self.navigationController?.pushViewController(sharingVC, animated: true)

//        guard let viewController:UIViewController = UIStoryboard(name: "Call", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
//            return
//        }
        
        self.title = "Call"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Call", style: .plain, target: nil, action: nil)
//        self.navigationItem.rightBarButtonItem?.isEnabled = false
        viewController.viewFinalImageButton.title = ""
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    /*Added by yasodha on 4/5/2020 starts here */
    
    @objc func onInfoBtnClicked(sender: UIButton) {
        previousViewController = "MyClassInfoVC"
        let vc = storyboard?.instantiateViewController(withIdentifier: "myclassInfo") as! MyClassInfoVC
        vc.title = "MyClass Info"
        vc.classID = "\(sender.tag)"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /*Added by yasodha on 4/5/2020 ends here */
    
    
    
}
extension MyClassVC: UITableViewDelegate {
    
}
extension MyClassVC {
    private func hitServer(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        // startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC")) // commented by veeresh on 5/march/2020
        /* added by veeresh on 5th march 2020 */
        segmentedControl.isUserInteractionEnabled = false
        var shim = UIImageView()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: shim = UIImageView(image: UIImage(named: "Asset 65")!) ; shim.contentMode = .topLeft
        case .pad: shim = UIImageView(image: UIImage(named: "Asset 65")!) ; shim.contentMode = .scaleToFill
        case .unspecified: shim = UIImageView(image: UIImage(named: "my-group-mobile")!)
        case .tv: shim = UIImageView(image: UIImage(named: "my-group-ipad")!) ; shim.contentMode = .topLeft
        case .carPlay: shim = UIImageView(image: UIImage(named: "my-group-mobile")!)
        }//scaleAspectFill
        classTableView.backgroundView = shim  /* added by veeresh on 26/2/2020 */
        shim.startShimmering()
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){[weak self] result in
            guard let _self = self else {
                return
            }
            /* added by veeresh on 5th march 2020 */
            _self.classTableView.backgroundView = UIView()
            shim.stopShimmering()
            shim.removeFromSuperview()
            switch result {
            case let .success(json,_):
                _self.segmentedControl.isUserInteractionEnabled = true
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                   // showMessage(bodyText: msg,theme: .error)//commented by yasodha
                   // _self.subcribed.removeLast()
                    
                    if let idx = _self.subcribed.firstIndex(of: _self.classIdString) {
                    _self.subcribed.remove(at: idx)
                        _self.classIdString = ""
                     }
                    
                    if msg == "No enough points to subscribe for class, Buy points."
                    {
                        let alert = UIAlertController(title: "Buy Points", message: "You don't have enough points to subscribe for class, Do you want to buy points?", preferredStyle: UIAlertController.Style.alert)
                        
                        // show the alert
                        _self.present(alert, animated: true, completion: nil)
                        
                        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { action in
                            //Added
                            let story = UIStoryboard.init(name: "Main", bundle: nil)
                            let paymentVC = story.instantiateViewController(withIdentifier: "paymentvc") as! PaymentVC
                            //        paymentVC.params = params
                            _self.navigationController?.pushViewController(paymentVC, animated: true)
                            
                            //
                        }))//alert
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: { action in
                            
                            return
                            
                        }))

                        
                    }else{
                        showMessage(bodyText: msg,theme: .error)
                    }
                    
                    
                    
                    
                }
                else {
                    /*Added by yasodha on 27/1/2020 - starts*/
                    self!.actionName = action
                    //after coming from the Zoom
                    if self!.actionName == "startClass" || self!.actionName == "Joinclass"{
                        if self!.actionName == "startClass"{
                            self!.actionName = "tab1"
                            
                        }else if self!.actionName == "Joinclass"{
                            self!.actionName = "tab2"
                            
                        }
                        
                        return
                    }
                    
                    if self!.actionName == "Expired Classes" {
                        _self.expClassData.removeAll()
                        _self.expClassData.append(contentsOf: json["ControlsData"]["ClassList"].arrayValue)
                        
                        
                    }
                    if self!.actionName == "AttendedClasses" {
                        _self.classesAttendedData.removeAll()
                        _self.classesAttendedData.append(contentsOf: json["ControlsData"]["lsv_classattended"].arrayValue)
                        
                    }
                    /*Added by yasodha on 27/1/2020 - ends*/
                    
                    
                    if _self.actionName == "tab1" {
                        _self.firstTabDataSet.removeAll()
                        _self.firstTabDataSet.append(contentsOf: json["ControlsData"]["ClassList"].arrayValue)
                        // if _self.firstTabDataSet.count > 0 {
                        // _self.classTableView.reloadData()
                        // }
                    }else if _self.actionName == "tab2" {
                        _self.secondTabDataSet.removeAll()
                        _self.secondTabDataSet.append(contentsOf: json["ControlsData"]["ClassList"].arrayValue)
                        
                    }else if _self.actionName == "tab3" {
                        _self.thirdTabDataSet.removeAll()
                        _self.thirdTabDataSet.append(contentsOf: json["ControlsData"]["ClassList"].arrayValue)
                        
                    }else if _self.actionName == "tab4" {
                        _self.firstTabDataSet.removeAll()
                        
                    }
                        
                    else if _self.actionName == "subscribe" {
                        // showMessage(bodyText: msg,theme: .success) /*  Commented By Ranjeet on 19th March 2020 *
                        showMessage(bodyText: "You have subscribed to this class",theme: .success) /*  Updated By Ranjeet on 19th March 2020 */
                        
                        _self.startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
                        _self.activeTabIndex = 1
                        _self.hitService()
                        _self.segmentupUIControl()
                        _self.stopAnimating()
                        
                        
                        //                        _self.actionName = "tab3" //commented by yashodha on 21st may
                        //                        _self.hitServer(params: [:], endPoint: _self.globalListEndPoint ,action: _self.actionName, httpMethod: .get)
                    }else if _self.actionName == "unsubscribe" {
                        // showMessage(bodyText: msg,theme: .success) /*  Commented By Ranjeet on 19th March 2020 */
                        showMessage(bodyText: "You have unsubscribed from this class",theme: .success)  /*  Updated By Ranjeet on 19th March 2020 */
                        _self.actionName = "tab2"
                        _self.hitServer(params: [:], endPoint: _self.globalListEndPoint ,action: _self.actionName, httpMethod: .get)
                    }else if _self.actionName == "deleteMyClass" {
                        _self.actionName = "tab1"
                        _self.firstTabDataSet.remove(at: _self.deletedItemIndex)
                    }else if _self.actionName == "deleteExpClass" {
                        _self.actionName = "Expired Classes"
                        _self.expClassData.remove(at: _self.deletedItemIndex)
                    }
                    
                    _self.classTableView.reloadData()
                    
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
}
extension MyClassVC: LoadMoreControlDelegate {
    func loadMoreControl(didStartAnimating loadMoreControl: LoadMoreControl) {
        print("didStartAnimating")
        tablePageIndex = (tablePageIndex + noOfItemsInaPage)
        // hitService()
    }
    
    func loadMoreControl(didStopAnimating loadMoreControl: LoadMoreControl) {
        print("didStopAnimating")
    }
}

extension MyClassVC {
    
    func getTimeZoneName(timeZoneID: Int) -> String? {
        
        let resultArray = timeZoneArrayJSON.filter { json -> Bool in
            return json["_zoneid"].intValue == timeZoneID
        }
        if resultArray.count > 0 {
            return resultArray[0]["_text"].stringValue
        }
        return nil
    }
}


// MARK: - QBChatDelegate
//extension MyClassVC: QBChatDelegate {
//    func chatRoomDidReceive(_ message: QBChatMessage, fromDialogID dialogID: String) {
//        chatManager.updateDialog(with: dialogID, with: message)
//        self.dialog = dialogID
//        chatManager.loadDialog(withID: dialogID, completion: { chatDialogin in
//            self.chatDialog = chatDialogin
//        })
//
//    }
//
//    func chatDidReceive(_ message: QBChatMessage) {
//        guard let dialogID = message.dialogID else {
//            return
//        }
//        chatManager.updateDialog(with: dialogID, with: message)
//        chatManager.loadDialog(withID: dialogID, completion: { chatDialogin in
//            self.chatDialog = chatDialogin
//        })
//        self.dialog = dialogID
//    }
//
//    func chatDidReceiveSystemMessage(_ message: QBChatMessage) {
//        guard let dialogID = message.dialogID else {
//            return
//        }
//        if let _ = chatManager.storage.dialog(withID: dialogID) {
//            return
//        }
//        chatManager.updateDialog(with: dialogID, with: message)
//        self.dialog = dialogID
//        chatManager.loadDialog(withID: dialogID, completion: { chatDialogin in
//            self.chatDialog = chatDialogin
//        })
//    }
//
//    func chatServiceChatDidFail(withStreamError error: Error) {
//    }
//
//    func chatDidAccidentallyDisconnect() {
//    }
//
//    func chatDidNotConnectWithError(_ error: Error) {
//    }
//
//    func chatDidDisconnectWithError(_ error: Error) {
//    }
//
//    func chatDidConnect() {
//        if QBChat.instance.isConnected == true {
//            chatManager.updateStorage()
//        }
//    }
//
//    func chatDidReconnect() {
//        //        SVProgressHUD.show(withStatus: "Connected")
//        if QBChat.instance.isConnected == true {
//            chatManager.updateStorage()
//        }
//    }
//}

// MARK: - ChatManagerDelegate
//extension MyClassVC: ChatManagerDelegate {
//    func chatManager(_ chatManager: ChatManager, didUpdateChatDialog chatDialog: QBChatDialog) {
//
//    }
//
//    func chatManager(_ chatManager: ChatManager, didFailUpdateStorage message: String) {
//    }
//
//    func chatManager(_ chatManager: ChatManager, didUpdateStorage message: String) {
//
//        QBChat.instance.addDelegate(self)
//    }
//
//    func chatManagerWillUpdateStorage(_ chatManager: ChatManager) {
//
//    }
//}

extension MyClassVC {
    func amAppend(str:String) -> String{
        var temp = str
        var strArr = str.characters.split{$0 == ":"}.map(String.init)
        var hour = Int(strArr[0])!
        var min = Int(strArr[1])!
        if(hour > 12 || hour == 12 ){
            
            if hour == 12 {}
            else{
                hour = hour - 12
            }
            // hour = hour - 12
            if hour == 0 {
                strArr[0]  = "0\(hour)"
            }else{
                strArr[0]  = "\(hour)"
                
            }
            if min < 10 {
                strArr[1]  = "0\(min)"
            }else{
                strArr[1]  = "\(min)"
                
            }
            
            temp = strArr[0] + ":" + strArr[1] + "PM"
            
            // temp = temp + "PM"
        }
        else{
            temp = temp + "AM"
        }
        return temp
    }
    func getCurrentTimeZoneName() -> String {

    // //1
    // let item = TimeZone.current.identifier
    // timeZone = item ?? ""
    //
    // let abbreviationDictionary = TimeZone.abbreviationDictionary
    // print("\(abbreviationDictionary)")
    // print(timeZone)
    // let key = (abbreviationDictionary.filter { $0.value == timeZone }).first?.key
    // print("Keyvalue : \(key!)")

    // return key ?? ""

    // return "\(timezone1)" ?? ""

    let item = TimeZone.current.localizedName(for: .standard, locale: .current) ?? ""


    return item
    }
    
}
