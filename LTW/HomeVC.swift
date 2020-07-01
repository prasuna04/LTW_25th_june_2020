//  HomeVC.swift
//  LTW
//  Created by Ranjeet Raushan on 21/04/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage
import SwiftMessages
import NVActivityIndicatorView
import MessageUI
//import Quickblox
//import QuickbloxWebRTC
enum PersonTypeForHomeVC : Int {
    case Student = 1 // why i am using 1 here because another two person type will automatically take 2 & 3 and if i  will not put 1 here  it will consider 0 automatically and another two person type will become 1 and 2 and we will get wrong information.
    case Parent
    case Teacher
}
enum FilterEnum: String {
    case Science = "Science"
    case Technology = "Technology"
    case English = "English"
    case Maths = "Maths"
    case Grade = "Grade"
}
class HomeVC: UIViewController,UITableViewDataSource, UITableViewDelegate,UISearchControllerDelegate,UISearchBarDelegate, NVActivityIndicatorViewable,MFMailComposeViewControllerDelegate,notification, UIPopoverPresentationControllerDelegate{ /* Added notification  By Chandra on 3rd Jan 2020 */
     /* Added  UIPopoverPresentationControllerDelegate By Veeresh on 25th Feb 2020 */
    
    
    /* Added By Chandra on 3rd Jan 2020 - starts here */
    var a : Int!
    func ststus(reviewans: Int) {
        self.a = reviewans
    }
    /* Added By Chandra on 3rd Jan 2020 - ends  here */
    
    /* Related to search By Mukesh - starts here */
    var tabelViewController: ArrayChoiceTableViewControllerToSearchQuestion<JSON,String>?; /* Added  String By Chandra on 22nd Jan 2020  */
    
    var isPopUpDismissed: Bool = true
    //Screen width.
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    //Screen height
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    var activityIndicator : NVActivityIndicatorView! // search related
    /* Related to search By Mukesh - ends here */
    private var notificationList = [JSON]() // add by chandra for getting count of notifacitions
    var countBoll = [Bool]() // add by chandra for getting count of notifacitions
    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var viewRltdToNotGrpClsTestContnt: UIView!
    
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var myGroupBtn: UIButton!
    @IBOutlet weak var myClassBtn: UIButton!
    @IBOutlet weak var myTestBtn: UIButton!
    @IBOutlet weak var myContentBtn: UIButton!
    @IBOutlet weak var topQstnsAndAnsrsForULbl: UILabel!
        {
        didSet{
            topQstnsAndAnsrsForULbl.font = UIFont.boldSystemFont(ofSize: 14.0) /* I tried to put
             "Roboto-Bold" , but it was not working properly so let it be boldSystemFont only to get the bold text  */
        }
    }
    
    @IBOutlet weak var moveUpBtn: UIButton!{
        didSet{
            moveUpBtn.layer.masksToBounds = false
            moveUpBtn.layer.shadowColor = UIColor.black.cgColor
            moveUpBtn.layer.shadowOffset = CGSize.zero
            moveUpBtn.layer.shadowRadius = 5
            moveUpBtn.layer.shadowOpacity = 1.0
        }
    }
    
    @IBOutlet weak var moveUpHeight: NSLayoutConstraint!
    @IBAction func onUpBtnPressed(_ sender : UIButton){
    tableView.scrollToRow(at: IndexPath(row: 1, section: 0), at: .top , animated: true)
    }
    
    @IBOutlet weak var askqustnBtn: UIButton!{
        didSet{
            askqustnBtn.layer.shadowColor = UIColor.black.cgColor
            askqustnBtn.layer.shadowOffset = CGSize.zero
            askqustnBtn.layer.shadowRadius = 5
            askqustnBtn.layer.shadowOpacity = 1.0
        }
    }
    @IBOutlet weak var filterQstnBtn: UIButton!
        {
        didSet{
            filterQstnBtn.layer.shadowColor = UIColor.gray.cgColor
            filterQstnBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
            filterQstnBtn.layer.shadowRadius = 5
           // filterQstnBtn.layer.shadowOpacity = 1.0
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var askquestionsPan: UIPanGestureRecognizer!
    @IBOutlet weak var viewRltdToNotGrpClsTestContntHight: NSLayoutConstraint!   /* Added By Chandra on 22nd Jan 2020  */ /* While scrolling up view and tab bar  should hide , while come down  view and tab bar should show */
    private var searchBar: UISearchBar! // Added By Ranjeet on 6th Dec 2019
    let searchController = UISearchController(searchResultsController: nil)
    var homeElementList: Array<JSON> = []
    var userID: String!
    var quserID: String!
    var homePageIndex = 0 /* Updated By Ranjeet on 12th March 2020  , cause after  creating question , after refreshing , on Home Page that questions was not listing out quickly  */
    var noOfItemsInaPage = 20
    var globalEndPoint:String!
    var questionID: String!
    var createDate: String!
    var upVote: Int!
    // var downVote: Int! /* Don't delete downvote functionality , future might reuse somewhere else */
    var commentsCount: Int!
    var noViews: Int!
    var personType: Int!
    var questions:String!
    var question_html: String!
    var tags: String!
    var answers: String!
    var profileURL: String!
    var firstName: String!
    var lastName: String!
    var urlPath: String!
    var quserid: String!
    var refreshControl = UIRefreshControl() // pull to refresh
    var activityIndicatorForHome: LoadMoreControl! // dynamic page loading
    var deletedIndexPath: IndexPath?
    var isEmpty: Bool? /* if answers not available in Home Screen then remove the separator line between qstns & answrs, also remove ansrs label */
    var lastContentOffset: CGFloat = 0  /* Added By Chandra on 22nd Jan 2020  */
    
    
    var filterType: String!
    //= FilterEnum.Science.rawValue
    let transiton = SlideInTransition()
    var isOpen = false
    var isMenuOpened = false
    lazy var filterVC : HomeFilterListVC  = {
        let filtervc =  storyboard?.instantiateViewController(withIdentifier: "filtervc") as! HomeFilterListVC
        filtervc.filterType = filterType
        filtervc.delegate = self
        return filtervc
    }()
    
    static var subjectIDs = ""
    static var subSubjectIDs = ""
    static var gradesNames = ""
    private var scienceSubSubjecIDst: [String]?
    private var technologySubSubjectIDs: [String]?
    private var englishSubSubjectIDs: [String]?
    private var mathsSubSubjectIDs: [String]?
    private var gradeSubSubjectIDs: [String]?
    var answerLblCache: NSCache<AnyObject, AnyObject>!//Added by yasodha
    
    var isEditMode: Bool = false
    var searchDataForAakaQuestionVC :String! // Added By Yashoda on 17th Dec 2019
    var label = UILabel()
    @IBOutlet weak var notificationStack: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        label = UILabel(frame: CGRect(x: 40, y: -3, width: 22, height: 22))
               label.layer.cornerRadius =  label.frame.width/2
               label.layer.masksToBounds = true
               label.textAlignment = .center
               label.textColor = UIColor.white
               label.font = UIFont.systemFont(ofSize: 9)
               label.backgroundColor = UIColor.red
               self.notificationStack.addSubview(label)
               userID = UserDefaults.standard.string(forKey: "userID")
        label.isHidden = true // add by chandra 
        // extendedLayoutIncludesOpaqueBars = true // Commented By Ranjeet on 6th Dec 2019 , don't delete this line , future might reuse
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        /* Commented By Ranjeet on 28th Jan - starts here */
        //        /* Table View Border Width and Border Color Concept Starts Here */
        //        tableView.layer.borderColor = UIColor.init(hex: "DCDCDC").cgColor
        //        tableView.layer.borderWidth = 1.0
        //        /* Table View Border Width and Border Color Concept Ends Here */
        /* Commented By Ranjeet on 28th Jan - starts here */
        
        userID =  UserDefaults.standard.string(forKey: "userID")
        tableView.delegate = self
        tableView.dataSource = self
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        // pull to refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(HomeVC.hitApiForPullToRefresh),for: .valueChanged)
        tableView.addSubview(refreshControl)
        searchController.searchBar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 15) // Added By Ranjeet on 6th Dec 2019
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchController.dimsBackgroundDuringPresentation = true
        searchController.extendedLayoutIncludesOpaqueBars = true // Added By Ranjeet on 6th Dec 2019
        searchController.edgesForExtendedLayout = .all // Added By Ranjeet on 6th Dec 2019
        // Include the search bar within the navigation bar.
        self.navigationItem.titleView = self.searchController.searchBar
        
        self.definesPresentationContext = true
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        searchController.searchBar.placeholder = " Enter Search Phrase" // Don't remove gap here because intensionally i place this to keep the gap between image and text
        searchController.searchBar.setImage(UIImage(named: "topsearch"), for: .search, state: .normal)
        searchController.delegate = self
        searchController.searchBar.delegate = self
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.setPlaceHolderColor(color: "FFFFFF")
            textField.borderStyle = UITextField.BorderStyle.roundedRect
            textField.tintColor = UIColor.white
            textField.textColor = UIColor.white
            textField.layer.cornerRadius = 18 // Modified By Ranjeet on 23rd Jan 2020
            textField.layer.opacity = 5 // Added By Manju on 23rd Jan 2020
            textField.clipsToBounds = true // Added By Ranjeet on 6th Dec 2019
            textField.backgroundColor = UIColor.clear // Modified By Ranjeet on 6th Jan 2020
            textField.layer.borderWidth = 1 // Modified By Ranjeet on 23rd Jan 2020
            textField.layer.borderColor = UIColor.white.cgColor // Added By Ranjeet on 6th Jan 2020
            textField.leftViewMode = UITextField.ViewMode.always // Added By Ranjeet on 6th Jan 2020
        }
        
        /* left button bar concept starts here */
        let leftMenuImg = UIImage(named: "menu")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let leftBarMenuBtn = UIBarButtonItem(image: leftMenuImg, style: UIBarButtonItem.Style.plain, target: self, action: #selector(didTapLeftBarMenuBtn))
        self.navigationItem.leftBarButtonItems = [leftBarMenuBtn]
        /* left button bar concept ends here */
        
        /* right button bar concept starts here  - By Mukesh */
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 20))
        rightButton.setBackgroundImage(UIImage(named: "search-send"), for: .normal)
        rightButton.addTarget(self, action: #selector(didTapRightBarSearchSendBtn), for: .touchUpInside)
        // or use (view.frame.size.width)
        
        activityIndicator = NVActivityIndicatorView(frame: .zero)
        activityIndicator.frame.size = CGSize(width: 40, height: 40)
        activityIndicator.center = CGPoint(x: rightButton.bounds.midX, y: rightButton.bounds.midY);
        
        activityIndicator.type = . ballRotateChase // add your type
        activityIndicator.color = UIColor.green // add your color
        
        rightButton.addSubview(activityIndicator)
        // Bar button item
        let rightBarButtomItem = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightBarButtomItem
        /* right button bar concept ends here  - By Mukesh */
        
        /* dynamic page loading - starts here */
        activityIndicatorForHome = LoadMoreControl(scrollView: tableView, spacingFromLastCell: 10, indicatorHeight: 60)
        activityIndicatorForHome.delegate = self
        /*  dynamic page loading - ends here */
        HomeVC.setGradeToInitailState()
        loadDataFromServer()
        
        /* Moving Floating Button Code  - starts here */
        self.askqustnBtn.frame = CGRect(x:self.view.frame.width - 80 , y: self.view.frame.height - 230 , width: 80 , height: 80 )
        /* Moving Floating Button Code - ends here */
        
//        let profile = Profile()
//        if profile.isFull == true {
//            QBRTCClient.instance().add((UIApplication.shared.delegate as! AppDelegate))
//            (UIApplication.shared.delegate as! AppDelegate).connectToChat()
//        }
        
        
self.answerLblCache =  NSCache()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.countBoll.removeAll() // add by chandra for after integration
        let endPoint: String = "\(Endpoints.notificationListUrl)\(userID!)" // add by chandra for notification count
               hitServer11(params: [:], endPoint: endPoint ,action: "getAllTestList", httpMethod: .get) // add by chandra for notification count
        isPopUpDismissed = true// Added By Yasodha on 16th Dec 2019
        isOpen = false // This line Added By Manoj
        /* Navigation related code starts here */
        if (self.navigationController?.navigationBar) != nil {
            navigationController?.navigationBar.barTintColor = UIColor.init(hex: "4CB6EF")
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false // Added By Mukesh to disable screen swipe - (Globally Handling for whole project)
        }
    }
    
    
    
      //  add by chandra for display the  count of notificants
    private func hitServer11(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){[unowned self] result in
            switch result {
            case let .success(json,_):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }else{
                    //                        let isread = json["ControlsData"]["NotificationList"]["isRead"].boolValue
                    self.notificationList = json["ControlsData"]["NotificationList"].arrayValue
                    self.countBoll.removeAll()
                    for i in self.notificationList{
                        let isread = i["isRead"].boolValue
                        if isread == false{
                            self.countBoll.append(isread)
                        }
                    }
                    print("chandra sekhar\(self.countBoll.count)")
                    if self.countBoll.count == 0{
                        self.label.isHidden = true
                    }else{
                        self.label.isHidden = false
                        self.label.text = "\(self.countBoll.count)"
                    }
                    self.countBoll.removeAll() // add by chandra notification count is comming wrong
                    //self.label.text = "\(self.countBoll.count)"
                }
                
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    
    
    
    
    
    
    
    /* Added By Chandra on 11th-Nov-2019  - starts here */
    override func viewDidDisappear(_ animated: Bool) {
        if isOpen == true {
            isOpen = false
            dismiss(animated: true) {
            }
        }
    }
    /* Added By Chandra on 11th-Nov-2019  - ends here */
    
    private func loadDataFromServer() {
        resetTableData()
        globalEndPoint = getNormalEndPoint()
        //check internet
        if currentReachabilityStatus != .notReachable {
            hitServer(params: [:],homeLandingEndPoint: getNormalEndPoint())
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
            })
        }
    }
    
    //pull to refresh
    @objc func hitApi() {
        refreshControl.endRefreshing()
        if currentReachabilityStatus != .notReachable {
            hitServer(params: [:],homeLandingEndPoint: getNormalEndPoint())
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
                self.hitApi()
                self.refreshControl.endRefreshing()
            })
        }
    }
    //pull to refresh
    @objc func hitApiForPullToRefresh() {
        refreshControl.endRefreshing()
        //resetToInitialState()
        resetTableData()
        if currentReachabilityStatus != .notReachable {
            hitServer(params: [:],homeLandingEndPoint: getNormalEndPoint())
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
                self.hitApiForPullToRefresh()
                self.refreshControl.endRefreshing()
            })
        }
    }
    /* left button bar Added By Chandra[on 27th Nov 2019] - starts here */
    @objc func didTapLeftBarMenuBtn(sender: UIButton){
        print("CilckOnSideMenuButton")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuViewController = storyboard.instantiateViewController(withIdentifier: "SideMenuViewController") as! MenuViewController
        self.view.addSubview(menuViewController.view)
        self.addChild(menuViewController)
        openAndCloseMenu()
    }
    func openAndCloseMenu(){
        if(isMenuOpened){
            isMenuOpened = false
            print("CloseSideMenu")
            //            searchController.searchBar.isUserInteractionEnabled = true
            if self.children.count > 0{
                let viewControllers:[UIViewController] = self.children
                for viewContoller in viewControllers{
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                }
            }
        }
        else{
            //            searchController.searchBar.isUserInteractionEnabled = false
            isMenuOpened = true
            print("OpenSideMenu")
        }
    }
    /* left button bar Added By Chandra[on 27th Nov 2019] - ends here */
    
    /* right button bar concept starts here */
    @objc func didTapRightBarSearchSendBtn(sender: UIButton){
        print("Right Bar Button Clicked")
        
        /*Added By Yasodha  on 16/12/2019 - starts here  */
        print(searchDataForAakaQuestionVC)
        if searchDataForAakaQuestionVC == nil{
            searchDataForAakaQuestionVC = ""
            
        }
        UserDefaults.standard.set(searchDataForAakaQuestionVC!, forKey: "question")//passing search data to AskQuestionWithTextVC
        // askquestionwithtext
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "askquestionwithtext") as? AskQuestionWithTextVC
        self.navigationController?.pushViewController(vc!, animated: false) /* Made true to false by Ranjeet on 19th Jan 2020 */
        
        performSearch()
        /* Added By Yashoda  on 16/12/2019  - ends here */
    }
    
    
    /* right button bar concept ends here */
    
    func getNormalEndPoint() -> String {
        let grades = HomeVC.gradesNames
        let trimmedgrades = grades.removeWhitespace()
        
        
        return "\(Endpoints.filterEndpoint)\(userID!)/\(self.homePageIndex)/\(self.noOfItemsInaPage)?SubjectID=\(HomeVC.subjectIDs)&SubSubjectID=\(HomeVC.subSubjectIDs)&Grade=\(trimmedgrades)"
        
    }
    
    
    /* Moving Floating Button Code - starts here */
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
            finalPoint.y = min(max(finalPoint.y, 50), self.view.bounds.size.height - 230)
            
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
    /* Moving Floating Button Code - ends here */
    
    // on Click of Notifications
    @IBAction func onNotificationBtnClick(_ sender: UIButton) {
        let notification = storyboard?.instantiateViewController(withIdentifier: "notification") as! NotificationVC
        
        /* Added By Chandra on 3rd Jan 2020 - starts here */
        if a == 1{
            notification.notificationclick = true
        }
        notification.delegate = self
        /* Added By Chandra on 3rd Jan 2020 - ends here */
        
        // navigationController?.pushViewController(notification, animated: true) /* uncomment this line when animation required */
        navigationController?.pushViewController(notification, animated: false) /* comment this line when animation not required */
    }
    
    // on Click of My Groups
    @IBAction func onMyGroupBtnClick(_ sender: UIButton) {
        let mygroup = storyboard?.instantiateViewController(withIdentifier: "mygroup") as! MyGroupsVC
        // navigationController?.pushViewController(mygroup, animated: true) /* uncomment this line when animation required */
        navigationController?.pushViewController(mygroup, animated: false) /* comment this line when animation not required */
    }
    
    // on Click of My Classes
    @IBAction func onMyClassBtnClick(_ sender: UIButton) {
        let myclass = storyboard?.instantiateViewController(withIdentifier: "myclassvc") as! MyClassVC
        // navigationController?.pushViewController(myclass, animated: true) /* uncomment this line when animation required */
        navigationController?.pushViewController(myclass, animated: false) /* comment this line when animation not required */
    }
    
    // on Click of My Test
    @IBAction func onMyTestBtnClick(_ sender: UIButton) {
        let mytest = storyboard?.instantiateViewController(withIdentifier: "mytest") as! MyTestVC
        // navigationController?.pushViewController(mytest, animated: true) /* uncomment this line when animation required */
        navigationController?.pushViewController(mytest, animated: false) /* comment this line when animation not required */
    }
    
    // on Click of My Content
    @IBAction func onMyContentBtnClick(_ sender: UIButton) {
        //        let myContent = storyboard?.instantiateViewController(withIdentifier: "contntqstinsasked") as! ContentQuestionsAskedVC
        //        myContent.userID = self.userID
        //        // navigationController?.pushViewController(myContent, animated: true) /* uncomment this line when animation required */
        //        navigationController?.pushViewController(myContent, animated: false) /* comment this line when animation not required */
        let myContent = storyboard?.instantiateViewController(withIdentifier: "contentsegmenthandler") as! ContentSegmentHandlerVC
        //               myContent.userID = self.userID
        // navigationController?.pushViewController(myContent, animated: true) /* uncomment this line when animation required */
        navigationController?.pushViewController(myContent, animated: false) /* comment this line when animation not required */
    }
    // on Click of Ask Question Button Click
    @IBAction func onAskqustnBtnClick(_ sender: UIButton) {
        let askquestion = storyboard?.instantiateViewController(withIdentifier: "askquestionwithtext") as! AskQuestionWithTextVC
        askquestion.questionID = self.questionID
        askquestion.isEditMode = isEditMode
        askquestion.refreshHome = {[ unowned self ] in
            self.loadDataFromServer()
        }
        // navigationController?.pushViewController(askquestion, animated: true) /* uncomment this line when animation required */
        navigationController?.pushViewController(askquestion, animated: false) /* comment this line when animation not required */
        
    }
    
    // on Click of Filter Question Button Click
    @IBAction func onFilterQstnBtnClick(_ sender: UIButton){
        let filtervc = storyboard?.instantiateViewController(withIdentifier: "filtervc") as! HomeFilterListVC
        filtervc.filterType = filterType
        filtervc.delegate = self
        filtervc.scienceSubSubjecIDst = self.scienceSubSubjecIDst
        filtervc.technologySubSubjectIDs = self.technologySubSubjectIDs
        filtervc.englishSubSubjectIDs = self.englishSubSubjectIDs
        filtervc.mathsSubSubjectIDs = self.mathsSubSubjectIDs
        filtervc.gradeSubSubjectIDs = self.gradeSubSubjectIDs
        // navigationController?.pushViewController(filtervc, animated: true) /* uncomment this line when animation required */
        navigationController?.pushViewController(filtervc, animated: false) /* comment this line when animation not required */
    }
    
    /* Added By Chandra on 24th-Oct-2019 */
    @objc func upVoteBtnSelected(sender: UIButton){
        print("upvote Clicked")
        let index = sender.tag
        let quserid = homeElementList[index]["quserid"].stringValue
        questionID = homeElementList[index]["QuestionID"].stringValue
        userID = UserDefaults.standard.string(forKey: "userID")
        /* Added By Chandra - from here */
        if userID == quserid{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LikesViewController") as! LikesViewController
            vc.Qid = questionID
            vc.Uid = userID
            // navigationController?.pushViewController(vc, animated: true) /* uncomment this line when animation required */
            navigationController?.pushViewController(vc, animated: false) /* comment this line when animation not required */
            
            /* Added By Chandra - till here */
        }else{
            homeElementList[index]["UpVote"].intValue = (homeElementList[index]["UpVote"].intValue + 1)
            upVote = homeElementList[index]["UpVote"].intValue
            print("upVote = \(upVote!)")
            sender.setTitle("\(upVote!)", for: .normal)
            if questionID != nil{
                hitServer1(params: [:], endPoint: Endpoints.homeUpVoteEndPoint + (self.questionID!) + "/" + (self.userID!) ,action: "HomeUpVoteAction", httpMethod: .get)
            }
            sender.isEnabled = false
            sender.isUserInteractionEnabled = false
        }
    }
    /*  Added By Chandra on 24th-Oct-2019 */
    
    
    // comment btn
    @objc func commntBtnSelected(sender: UIButton){
        let ansWersVC = storyboard?.instantiateViewController(withIdentifier: "answer") as! AnswersVC
        let index = sender.tag
        self.questionID = self.homeElementList[index]["QuestionID"].stringValue
        ansWersVC.questionID = self.questionID
        // navigationController?.pushViewController(ansWersVC, animated: true) /* uncomment this line when animation required */
        navigationController?.pushViewController(ansWersVC, animated: false) /* comment this line when animation not required */
    }
    
    // report offensive
    @objc func reportOffensiveBtnSelected(sender: UIButton){
        userID = UserDefaults.standard.string(forKey: "userID")
        let index = sender.tag
        questionID = homeElementList[index]["QuestionID"].stringValue
        quserid = homeElementList[index]["quserid"].stringValue
        self.deletedIndexPath = IndexPath(item: sender.tag, section: 0)
        let isIndexValid = homeElementList.indices.contains(self.deletedIndexPath!.row)
        if userID == quserid{
            showMessage(bodyText: "You can't report your own question offensive.",theme: .warning, duration: .seconds(seconds: 1))
            return
        }
        else{
            let refreshAlert = UIAlertController(title: "Report Offensive", message: "Are you sure you want to report offensive?", preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                if isIndexValid{
                    self.hitServerForReportOffensive(params: [:], endPoint: Endpoints.homeReportOffensiveEndPoint + (self.questionID!) + "/" + (self.userID!) ,action: "ReportOffensiveAction", httpMethod: .get)
                }
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in
            }))
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeElementList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomeCell
        var homeList: JSON
        moveUpBtn.isHidden = false
        if indexPath.row > 15{
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.moveUpHeight.constant = 40
            })
        }
        else {
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.moveUpHeight.constant = 0
            })
        }
        if homeElementList.count > 0{
            homeList  = homeElementList[indexPath.row]
            cell.subjctLbl.text = homeList["SubjectName"].stringValue
//            cell.subjctLbl.font = UIFont.boldSystemFont(ofSize: 13.0)/* I tried to put
//             "Roboto-Bold" , but it was not working properly so let it be boldSystemFont only to get the bold text  */
            cell.gradLbl.text = homeList["Tags"].stringValue
             cell.answerPointsLbl.text = "\(homeList["AnswerPoints"].intValue) Points"
            var dateString = homeList["CreateDate"].stringValue
            dateString = dateString.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
            // For Decimal value
            cell.dateLbl.text = DateHelper.localToUTC(date: dateString, fromFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "MMM dd, yyyy")
//            cell.dateLbl.font = UIFont.boldSystemFont(ofSize: 13.0)/* I tried to put
//             "Roboto-Bold" , but it was not working properly so let it be boldSystemFont only to get the bold text  */
            cell.scholLbl.text = homeList["Schools"].stringValue
            let typeOfPersonForHomeVC = PersonTypeForHomeVC.init(rawValue: homeList["PersonType"].intValue)
            if typeOfPersonForHomeVC != nil{
                cell.prsnTyp.text = "\(String(describing: typeOfPersonForHomeVC!))"
//                cell.prsnTyp.font = UIFont.boldSystemFont(ofSize: 13.0)/* I tried to put
//                 "Roboto-Bold" , but it was not working properly so let it be boldSystemFont only to get the bold text  */
            }
            cell.personNameLbl.text = homeList["FirstName"].stringValue // only 1st Name
//            cell.personNameLbl.font = UIFont.boldSystemFont(ofSize: 13.0)/* I tried to put
//             "Roboto-Bold" , but it was not working properly so let it be boldSystemFont only to get the bold text  */
            
            let stringUrl = homeList["ProfileURL"].stringValue
            let thumbnail = stringUrl.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
            cell.personImgVw?.sd_setImage(with: URL.init(string:thumbnail ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
            
            /* Don't delete below note , it's a very strict warning to follow without commit this mistake once again in future.
             note: Don't load the image in DispatchQueue.main.async(){} cause it's freezing the UI most of the times and one more thing SDWebImage only handling all the threading related functionality in their own way. */
            
            // View tap  related to upper Part of Cell apart from image
            let tap = UITapGestureRecognizer(target: self, action: #selector(uiViewTapped))
            cell.viewRelatedToUpperPartOfCell.tag = indexPath.row
            tap.numberOfTapsRequired = 1
            cell.viewRelatedToUpperPartOfCell.isUserInteractionEnabled = true
            cell.viewRelatedToUpperPartOfCell.addGestureRecognizer(tap)
            
            // View tap related to  image
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(uiViewWithImageTapped))
            cell.viewRelatedToImage.tag = indexPath.row
            tap1.numberOfTapsRequired = 1
            cell.viewRelatedToImage.isUserInteractionEnabled = true
            cell.viewRelatedToImage.addGestureRecognizer(tap1)
            
            // View tap related to  answers
            let tap2 = UITapGestureRecognizer(target: self, action: #selector(uiViewWithAnswersTapped))
            cell.viewRelatedToAnswers.tag = indexPath.row
            tap2.numberOfTapsRequired = 1
            cell.viewRelatedToAnswers.isUserInteractionEnabled = true
            cell.viewRelatedToAnswers.addGestureRecognizer(tap2)
            
            
            // Questions
            cell.whatIsUrQustnLbl.text = homeList["Questions"].stringValue
            //            if let data = homeList["Question_html"].stringValue.data(using: String.Encoding.unicode){
            //                try? cell.whatIsUrQustnLbl.attributedText =
            //                    NSAttributedString(data: data,
            //                                       options: [.documentType:NSAttributedString.DocumentType.html],
            //                                       documentAttributes: nil)
            //
            //            } else {
            //                // for default cases
            //            }
//            cell.whatIsUrQustnLbl.font = UIFont.boldSystemFont(ofSize: 16.0)/* I tried to put
//             "Roboto-Bold" , but it was not working properly so let it be boldSystemFont only to get the bold text  */
            cell.whatIsUrQustnLbl.textColor = UIColor.darkGray
            
            /* Don't remove underline label code written below time being just uncomment it , later might useful somewhere else as per designer */
            //cell.whatIsUrQustnLbl.attributedText = cell.whatIsUrQustnLbl.text!.getUnderLineAttributedText() //underline label
            
            
            //  cell.answerLbl.text = homeList["Answers"].stringValue /* my code commented by Yashoda on 18th Dec 2019 */
            //            if let data = homeList["Answers"].stringValue.data(using: String.Encoding.unicode){
            //                try? cell.answerLbl.attributedText =
            //                    NSAttributedString(data: data,
            //                                       options: [.documentType:NSAttributedString.DocumentType.html],
            //                                       documentAttributes: nil)
            //
            //            } else {
            // for default cases
            // }
            
            /*
             cell.answerLbl.font = UIFont(name:"Roboto-Regular", size: 14.0)
             cell.answerLbl.textColor = UIColor.darkGray
             
             /* Don't Delete code from here - cause future might reuse */
             /* if answers not available in Home Screen then remove the separator line between qstns & answrs, also remove ansrs label - starts here */
             if cell.answerLbl.text?.isEmpty == true{
             cell.underlineView.isHidden = true
             cell.answerLbl.isHidden = true
             }
             else{
             cell.underlineView.isHidden = false
             cell.answerLbl.isHidden = false
             }
             /* if answers not available in Home Screen then remove the separator line between qstns & answrs, also remove ansrs label - ends here  */
             
             */
            /* Don't Delete code till  here - cause future might reuse */
            /*commented by yasodha on 28/1/2020 ends here*/
            
            /* Added by yasodha on 29/1/2020 -  stars here*/
            let str = homeList["Answers"].stringValue
            
            if str.isEmpty == true{
                
                //cell.answerLbl.lineBreakMode = .byWordWrapping
                
                cell.answerLbl.numberOfLines = 1
                // cell.underlineView.clipsToBounds = true
                cell.underlineView.isHidden = true
                cell.answerLbl.isHidden = true
                cell.answerVWHgt.constant = 0
            }
            else{
                //cell.answerLbl.heightAnchor.constraint(lessThanOrEqualToConstant: 0) .isActive = false
                
                cell.answerLbl.numberOfLines = 0
                cell.answerVWHgt.constant = 40
                cell.underlineView.isHidden = false
                cell.answerLbl.isHidden = false
                
                if (self.answerLblCache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil){
                    
                    cell.answerLbl.attributedText = self.answerLblCache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? NSAttributedString
                    cell.answerLbl.font  =  UIFont(name:"Roboto-Medium", size: 14.0)
                    cell.answerLbl.textColor = UIColor.darkGray
                    
                    
                }else if str.contains("<p") || str.contains("<!DOCTYPE") || str.contains("<head><style") || str.contains("<table") || str.contains("<div") || str.contains("<frame") || str.contains("<span") || str.contains("<mi>") || str.contains("<b>")               {
                    //self.getAttributedString(htmlString:homeList["Answers"].stringValue , indexPath: indexPath)
                    DispatchQueue.global(qos: .background).async {
                        
                        //var htmlData = str.htmlToString
                        let htmlData = str.htmlToAttributedString
                        print("AnswerLbl \(str.htmlToString)")
                        DispatchQueue.main.async {
                            //  cell.answerLbl.text = "\(htmlData)"
                            if  cell.tag == indexPath.row {
                                
                                cell.answerLbl.attributedText = htmlData
                                cell.answerLbl.font  =  UIFont(name:"Roboto-Medium", size: 14.0)
                                cell.answerLbl.textColor = UIColor.darkGray
                                self.answerLblCache.setObject(htmlData!, forKey: (indexPath as NSIndexPath).row as AnyObject)
                                
                            }
                            
                            /***********************   Added by yasodha *************************/
                            //                            cell.answerLbl.attributedText = htmlData
                            //                            cell.answerLbl.font  =  UIFont(name:"Roboto-Medium", size: 14.0)
                            //                            cell.answerLbl.textColor = UIColor.darkGray
                            //
                            //                            print("AnswerLbl \(htmlData)")
                        }
                        
                    }
                    
                }else
                {
                    
                    //                    cell.answerLbl.text = str.htmlToString  /* Commented  By Yashoa on 10th April 2020 */
                    cell.answerLbl.text = str /* Updated By Yashoa on 10th April 2020 */
                }
                
            }
            if cell.answerLbl.text == "Loading..." {
                cell.answerLbl.text = ""
               //  cell.answerVWHgt.constant = 0
            }
            /* Added by yasodha on 29/1/2020 - ends here */
            
            /*  Added By Chandra on 24th- Oct-2019 - from here  */
            //up vote
            cell.upVoteBtn.tag = indexPath.row
            cell.upVoteBtn.addTarget(self, action: #selector(upVoteBtnSelected(sender:)), for: .touchUpInside)
            cell.upVoteBtn.setTitle("\(homeList["UpVote"].intValue)", for: .normal)
            // add by chandra
            cell.upVoteBtn.isEnabled = true
            cell.upVoteBtn.isUserInteractionEnabled = true
            /*  Added By Chandra on 24th- Oct-2019 - till here  */
            
            
            
            //comments
            commentsCount = homeList["CommentsCount"].intValue
            cell.commntBtn.setTitle("\(commentsCount!)", for: .normal)
            cell.commntBtn.tag = indexPath.row
            cell.commntBtn.addTarget(self, action: #selector(commntBtnSelected(sender:)), for: .touchUpInside)
            
            //views(seen)
            noViews = homeList["NoViews"].intValue
            cell.viewsBtn.setTitle("\(noViews!)", for: .normal)
            
            // report offensive
            cell.spamBtn.tag = indexPath.row
            cell.spamBtn.addTarget(self, action: #selector(reportOffensiveBtnSelected(sender:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    
    func getAttributedString(htmlString: String ,indexPath :IndexPath) {
        
        DispatchQueue.global(qos: .background).async {
            let htmlData = NSString(string: htmlString).data(using: String.Encoding.unicode.rawValue)
            // let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 40.0)! ]
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
            do{
                let attributedString = try NSMutableAttributedString(data: htmlData!, options: options, documentAttributes: nil)
                if indexPath.row < self.homeElementList.count
                {
                    var dict = self.homeElementList[indexPath.row]
                    dict["Answers"].stringValue = attributedString.string
                    self.homeElementList.remove(at: indexPath.row)
                    self.homeElementList.insert(dict, at: indexPath.row)
                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                    }
                }
            }catch
            {
                showMessage(bodyText: "Bad html text",theme: .error, duration: .seconds(seconds: 0.1))
            }
        }
    }
    
    @objc func uiViewTapped(sender: UITapGestureRecognizer) {
        print("uiViewTapped")
        let ansWersVC = storyboard?.instantiateViewController(withIdentifier: "answer") as! AnswersVC
        let obj = homeElementList[(sender.view?.tag)!]
        questionID = obj["QuestionID"].stringValue
        ansWersVC.questionID = self.questionID
        // navigationController?.pushViewController(ansWersVC, animated: true) /* uncomment this line when animation required */
        navigationController?.pushViewController(ansWersVC, animated: false) /* comment this line when animation not required */
    }
    
    @objc func uiViewWithImageTapped(sender: UITapGestureRecognizer) {
        print("uiViewWithImageTapped")
        let personalprofile = storyboard?.instantiateViewController(withIdentifier: "personalprofile") as! PersonalProfileVC
        let obj = homeElementList[(sender.view?.tag)!]
        userID = obj["quserid"].stringValue
        personalprofile.userID = self.userID
        // navigationController?.pushViewController(personalprofile, animated: true) /* uncomment this line when animation required */
        navigationController?.pushViewController(personalprofile, animated: false) /* comment this line when animation not required */
    }
    
    @objc func uiViewWithAnswersTapped(sender: UITapGestureRecognizer) {
        print("uiViewWithAnswersTapped")
        let ansWersVC = storyboard?.instantiateViewController(withIdentifier: "answer") as! AnswersVC
        let obj = homeElementList[(sender.view?.tag)!]
        questionID = obj["QuestionID"].stringValue
        ansWersVC.questionID = self.questionID
        // navigationController?.pushViewController(ansWersVC, animated: true) /* uncomment this line when animation required */
        navigationController?.pushViewController(ansWersVC, animated: false) /* comment this line when animation not required */
    }
    /*  dynamic page loading - starts here */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if (actualPosition.y > 0){
            // Dragging down
            self.view.layoutIfNeeded() // force any pending operations to finish
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.viewRltdToNotGrpClsTestContntHight.constant = 80
                self.view.layoutIfNeeded()
            })
           // print("**unhide")
        }else{
            // Dragging up
            self.view.layoutIfNeeded() // force any pending operations to finish
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.viewRltdToNotGrpClsTestContntHight.constant = 0
                self.view.layoutIfNeeded()
            })
           // print("hide")
        }
        activityIndicatorForHome.didScroll()
    }
    
    static func setGradeToInitailState(){
        HomeVC.gradesNames = ""
        for grade in UserDefaults.standard.array(forKey: "grades") as! [String] {
            HomeVC.gradesNames = HomeVC.gradesNames + "\(grade),"
        }
        if HomeVC.gradesNames.count > 0 {
            HomeVC.gradesNames.removeLast()
        }
        // subjectIDs = ""
        // subSubjectIDs = ""
    }
    
    
    private func resetTableData(){
          homePageIndex = 0
        /*  Updated By Ranjeet on 12th March 2020  , cause after  creating question , after refreshing , on Home Page that questions was not listing out quickly  */
        homeElementList.removeAll()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension HomeVC {
    private func hitServer(params: [String:Any],homeLandingEndPoint: String) {
      //  startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))  // commeted by veeresh on 19/2/2020
         /* added by veeresh on 19/2/2020 */
        
        var shim = UIImageView()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: shim = UIImageView(image: UIImage(named: "mobile-new")!)
        case .pad: shim = UIImageView(image: UIImage(named: "tab-home")!)// ; shim.contentMode = .topLeft
        case .unspecified: shim = UIImageView(image: UIImage(named: "mobile-new")!)
        case .tv: shim = UIImageView(image: UIImage(named: "tab-home")!) ; shim.contentMode = .topLeft
        case .carPlay: shim = UIImageView(image: UIImage(named: "mobile-new")!)
        }//scaleAspectFill
                if homeElementList.count < 1 {   /* added by veeresh on 26/2/2020 */
                    tableView.backgroundView = shim  /* added by veeresh on 26/2/2020 */
                shim.startShimmering()  /* added by veeresh on 26/2/2020 */
                }

         /* added by veeresh on 19/2/2020 */
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: homeLandingEndPoint, using: .get, dueToAction: "HomeItems"){ [weak self] result in
            guard let _self = self else {
                return
            }
          //  _self.stopAnimating()  // commeted by veeresh on 19/2/2020
            _self.activityIndicatorForHome.stop()
            switch result {
            case let .success(json,requestType):
                
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }else {
                    let jsondata = json["ControlsData"]["lsv_Qanswers"]
                    print(jsondata)
                    if jsondata.count == 0{
                        showMessage(bodyText: "No more data available",theme:.warning,presentationStyle:.center,duration:.seconds(seconds: 0.2))
                        return
                    }else{
                        _self.parseNDispayListData(json: json["ControlsData"]["lsv_Qanswers"], requestType: requestType)
                    }
                    
                    
                }
                /* added by veeresh on 19/2/2020 */
                self!.tableView.backgroundView = UIView()
                shim.stopShimmering()
                shim.removeFromSuperview()
                 /* added by veeresh on 19/2/2020 */
                break
            case .failure(let error):
                print("MyError = \(error)")
                /* added by veeresh on 19/2/2020 */
                               self!.tableView.backgroundView = UIView()
                               shim.stopShimmering()
                               shim.removeFromSuperview()
                                /* added by veeresh on 19/2/2020 */
                break
            }
        }
    }
    
    private func hitServer1(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){ [weak self] result in
            guard self != nil else {
                return
            }
            switch result {
            case let .success(json,_):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }
                else  {
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    
    // report offensive
    
    private func hitServerForReportOffensive(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){[weak self] result in
            guard let _self = self else {
                return
            }
            _self.stopAnimating()
            _self.activityIndicatorForHome.stop()
            switch result {
            case let .success(json,_):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }
                else  {
                    _self.homeElementList.remove(at: _self.deletedIndexPath!.row)
                    _self.tableView.reloadData()
                    showMessage(bodyText: "Successfully Reported Offensive",theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.01))
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    private func parseNDispayListData(json: JSON,requestType: String){
        homeElementList.append(contentsOf: json.arrayValue)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

/* Related to search By Mukesh - starts here */
extension HomeVC: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    
    /* Added By Chandrashekhar on 11th Nov - From Here  */
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        /* Added By Chandra on 3rd Dec 2019 - starts  here */
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        /* Added By Chandra on 3rd Dec 2019 - ends here */
        performSearch()
        return true
        /*Added By Chandrashekhar on 11th Nov - Till Here */
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        performSearch()
        if isOpen{
            isOpen = false
            dismiss(animated: true) {
                
            }
        }
    }

    
    /* Added By Yashoda on 17th Dec 2019 - starts here */
    func performSearch(){
        if searchController.searchBar.text?.isEmpty ?? true
        {
            print("Search key is Empty")
            searchDataForAakaQuestionVC = ""
        }
        if isFiltering() {
            var searchKey = searchController.searchBar.text!
            searchDataForAakaQuestionVC = searchKey
            print("Search key = \(searchKey)")
            
            if searchKey.count >= 3 {
                searchKey.append("*")   /* Added by veeresh on 28th feb 2020 */
                searchKey = searchKey.replacingOccurrences(of: " ", with: "* ")   /* Added by veeresh on 28th feb 2020 */
                let encodeSearchKey  = searchKey.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
                // print("encodeSearchKey = \(encodeSearchKey)")
                let searchQuesUrl = Endpoints.searchQuestionUrl + encodeSearchKey
                
                
                hitService(withBodyData: [:], toEndPoint: searchQuesUrl, using: .get, dueToAction: "searchQues")
                //view.addSubview(loader);
            }else {
                // Abort all ongoing  network request
                Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
                    sessionDataTask.forEach { $0.cancel() }
                    uploadData.forEach { $0.cancel() }
                    downloadData.forEach { $0.cancel() }
                }
                dismissSearchList()
                activityIndicator.stopAnimating();
                //loader.removeFromSuperview()
            }
        }// isFiltering
    }
    
    
    /* Added By Yashoda on 17th Dec 2019 - ends here */
    func dismissSearchList() {
        if self.tabelViewController != nil {
            if  !tabelViewController!.isBeingDismissed {   /* Added By Veeresh  on 25th Feb  2020   */
                
            self.tabelViewController?.dismiss(animated: true, completion: nil)
            self.isPopUpDismissed = true
            }
        }
    }
    func showSearchList() {
        self.tabelViewController?.preferredContentSize = CGSize(width: self.screenWidth - 20, height: self.screenHeight / 3)
        self.showPopup(self.tabelViewController!, sourceView: self.searchController.searchBar)
        self.isPopUpDismissed = false
    }
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    func showPopup(_ controller: UIViewController, sourceView: UIView) {
        controller.modalPresentationStyle = .popover /* Added By Veeresh on 25th Feb 2020 */
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.delegate = self  /* Added By Veeresh on 25th Feb 2020 */
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
       // self.present(controller, animated: true) /* Commented By Veeresh on 25th Feb 2020 */
       /* Added By Veeresh on 25th Feb 2020  - starts here */
        if  !controller.isBeingDismissed && !controller.isBeingPresented{
                    self.present(controller, animated: false)
                       }
        /* Added By Veeresh on 25th Feb 2020  - ends here */
    }
     /* Added By Veeresh on 25th Feb 2020  - starts here */
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
     /* Added By Veeresh on 25th Feb 2020  - ends here */
    
    func hitService(withBodyData data: [String: Any],toEndPoint url: String,using httpMethod: HTTPMethod,dueToAction requestType: String){
        print("EndPoint = \(url)"); print("BodyData = \(data)");print("Action = \(requestType)")
        let header = ["Content-Type": "application/json",
                      "Api-key": "55EBA8DAFFB956A359B07C4DAB2CE3EE"]
        activityIndicator.startAnimating()
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 10
        manager.request(url, method: httpMethod, parameters: data.isEmpty ? nil: data, encoding: JSONEncoding.default, headers: header).responseJSON {[unowned self] response in
            self.activityIndicator.stopAnimating()
            switch(response.result) {
            case .success(let value):
                //print("Response = \(value)")
                /* Don't remove above commented line future might useful to print Response value */
                
                let json = JSON(value)
                print("Response = \(json)")
                let quesArrJSON = json["value"].arrayValue
                if quesArrJSON.count > 0 {
                    if self.tabelViewController == nil {
                        self.tabelViewController = ArrayChoiceTableViewControllerToSearchQuestion(quesArrJSON,searchString: self.searchDataForAakaQuestionVC){[unowned self] (selectedJSON) in  /* Added [  searchString: self.searchDataForAakaQuestionVC) ]By Chandra on 22nd Jan 2020  */

                            print("selectedJSON = \(selectedJSON)")
                            let ansWersVC = self.storyboard?.instantiateViewController(withIdentifier: "answer") as! AnswersVC
                            ansWersVC.questionID = selectedJSON["QuestionId"].stringValue
                            // self.navigationController?.pushViewController(ansWersVC, animated: true) /* uncomment this line when animation required */
                            self.navigationController?.pushViewController(ansWersVC, animated: false) /* comment this line when animation not required */
                            
                        }
                        self.showSearchList()
                    } else {
                        if self.isPopUpDismissed {
                            self.showSearchList()
                        }
                        self.tabelViewController!.values = quesArrJSON
                        self.tabelViewController!.searchString = self.searchDataForAakaQuestionVC   /* Added By Chandra on 22nd Jan 2020  */
                        self.tabelViewController?.tableView.reloadData()
                    }
                }else {
                    self.dismissSearchList()
                }
                
                break
            case .failure(let error):
                print("Failure : \(response.result.error!)")
                // print("let error : \(error.localizedDescription)")
                /* Don't remove above commented line future might useful to print error value */
                
                if error._code == NSURLErrorTimedOut {
                    showMessage(bodyText: "Timeout!",theme: .error)
                }
                break
            }
        }
    }
}
/* Related to search By Mukesh - ends here */

/*  dynamic page loading - starts here */
extension HomeVC: LoadMoreControlDelegate {
    func loadMoreControl(didStartAnimating loadMoreControl: LoadMoreControl) {
        print("didStartAnimating")
        homePageIndex =  (homePageIndex + noOfItemsInaPage)
        hitApi()
    }
    func loadMoreControl(didStopAnimating loadMoreControl: LoadMoreControl) {
        print("didStopAnimating")
    }
}
/*  dynamic page loading - ends here */
extension HomeVC: FilterQuestion {
    func filterQuestion(subjectIDs: String, subSubjectIDs: String, gradeNames: String) {
        print("subjectIDs = \(subjectIDs) subSubjectIDs = \(subSubjectIDs) gradeNames = \(gradeNames)")
        
        let encodedGradeNames = gradeNames.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        HomeVC.self.subjectIDs = subjectIDs;HomeVC.self.subSubjectIDs = subSubjectIDs ;HomeVC.self.gradesNames = encodedGradeNames
        resetTableData()
        //addTableView()
        // hitApi()
        // viewWillAppear(true)
        loadDataFromServer()
    }
    
    func previousFilterData(scienceSubSubjecIDst: [String]?, technologySubSubjectIDs: [String]?, englishSubSubjectIDs: [String]?, mathsSubSubjectIDs: [String]?, gradeSubSubjectIDs: [String]?) {
        self.scienceSubSubjecIDst = scienceSubSubjecIDst
        self.technologySubSubjectIDs = technologySubSubjectIDs
        self.englishSubSubjectIDs = englishSubSubjectIDs
        self.mathsSubSubjectIDs = mathsSubSubjectIDs
        self.gradeSubSubjectIDs = gradeSubSubjectIDs
    }
}

extension HomeVC: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isOpen = false
        transiton.isPresenting = false
        return transiton
    }
}

extension HomeVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
extension String {
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}
