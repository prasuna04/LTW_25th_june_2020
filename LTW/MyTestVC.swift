// MyTestVC.swift
// LTW
// Created by Ranjeet Raushan on 24/04/19.
// Copyright © 2019 vaayoo. All rights reserved.


import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView

class MyTestVC: UIViewController,UISearchControllerDelegate,NVActivityIndicatorViewable {
    //    var refreshControl = UIRefreshControl()
    @IBOutlet weak var tableviewTopHightCostrain:NSLayoutConstraint!
    var activityIndicator: LoadMoreControl!
    @IBOutlet weak var MyTestListTV: UITableView!
    @IBOutlet weak var textFieldSearch: UITextField!
    var number_Of_Attendees : Int! //Added by yasodha 5/3/2020
    var activeTabIndex = 1//updated by yasodha
    var presseddeleteBtn:Bool!
    var encoded:String?
    var endPointUrl:String!
    var delete:Bool! /* Added By Chandra on 3rd Jan 2020 */
    var segmentedControl = UISegmentedControl()
    var buttonBar:UIView!
    //    add by chandra sekhar
    let personType = UserDefaults.standard.string(forKey: "persontyp")!
    var personTypechuck:Int!
    
    /*Added by yasodha on 27/1/2020 - starts*/
    var tutorTestsEndPoint : String!
    var studentTestTakenEndPoint : String!
    var perSonType :Int!
    /*Added by yasodha on 29/1/2020 -starts here*/
    private var testDataSet = [JSON](){
    didSet {
    //if !firstTabDataSet.isEmpty {
    MyTestListTV.reloadData()
    // }
    }
    }
    var actionTest = "testDataSet"
   /*Added by yasodha on 29/1/2020 -ends here*/
     var views  = UIView()
    
    @IBOutlet weak var navigationSearchBar: UIView!
    /*Added by yasodha on 27/1/2020 - ends*/
    
    
    //    add by chandra sekhar
    @IBOutlet weak var addFloatingButton: UIButton!{
        didSet {
            addFloatingButton.layer.shadowColor = UIColor.gray.cgColor
            addFloatingButton.layer.shadowOffset = CGSize(width: 5, height: 5)
            addFloatingButton.layer.shadowRadius = 5
            addFloatingButton.layer.shadowOpacity = 1.0
            addFloatingButton.layer.cornerRadius = addFloatingButton.frame.height / 2
        }
    }
    @IBOutlet var createTestssPan: UIPanGestureRecognizer! // Added By Ranjeet
    var tableViewDataSource = [JSON]()
    var testAttendedData =  [JSON]()
    var filteredtableViewDataSource: Array<JSON> = []
    let userId = UserDefaults.standard.string(forKey: "userID")
    var search : Bool?
    private var tablePageIndex0 = 1
    private var tablePageIndex1 = 1
    private var tablePageIndex2 = 1
    private var noOfItemsInaPage = 5
    private var presentSegmentIndex = 0
    //    private var tablePageIndex = 1
    //    private var noOfItemsInaPage = 10
    private var deletedItemIndex = -1
      //For refresh control
    /*Added by yasodha 27/3/2020 starts here */
       lazy var refreshControl: UIRefreshControl = {
         let refreshControl = UIRefreshControl()
             refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
             refreshControl.addTarget(self, action: #selector(MyTestVC.handleRefresh(_:)),for: UIControl.Event.valueChanged)
             return refreshControl
         }()
    /*Added by yasodha ends here */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = LoadMoreControl(scrollView: MyTestListTV, spacingFromLastCell: 20, indicatorHeight: 60)
        activityIndicator?.delegate = self
        navigationItem.title = "Tests"
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
            NSAttributedString(string: " Search with Title/Grades", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        /* Added by yasoda on 27/1/2020 for Teacher and Student Personal Detailes*/
        if self.navigationController?.viewControllers.previous is PersonalProfileVC {
            addFloatingButton.isHidden = true /* Remove  Create Test button  when redirecting from User Details Screen By Ranjeet on 1st Feb 2020  */
            textFieldSearch.isHidden = true//Added by yasodha on 8/5/2020
            if currentReachabilityStatus != .notReachable {
                
                
                if perSonType == 1 {
                    print("************** Student*****************")
                    
                    if studentTestTakenEndPoint == "Tests Taken"{ //Changed by Chandra on 20/03/2020.
                        
                        hitServer(params: [:], endPoint: Endpoints.StudentTestTakenEndPoint + userId! + "/" + (UserDefaults.standard.string(forKey: "personalprofile")!) + "?searchText=\("")" , action: "testDataSet", httpMethod: .get)
                        
                        
                    }
                    
                }else if perSonType == 3 {
                    print("************* Teacher ****************")
                    if tutorTestsEndPoint == "Tests Created"{
                        
                        hitServer(params: [:], endPoint: Endpoints.TutorTestsEndPoint + userId! + "/" + (UserDefaults.standard.string(forKey: "personalprofile")!) + "?searchText=\("")" , action: "testDataSet", httpMethod: .get)
                    }
                    
                }
                                
                
            } else {
                showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
                })
            }
            /* Added by yasoda on 18/1/2020 for Teacher and Student Personal Detailes*/
            self.MyTestListTV.addSubview(self.refreshControl)//Added by yasodha on 8/5/2020
        }else {
            
            tableViewDataSource.removeAll()
            testAttendedData.removeAll()//Added by yasodha
            
            MyTestListTV.reloadData()
            if personType == "1"{
                addFloatingButton.isHidden = true
                //             segmentupUIControl()
                personTypechuck = 1
            }else{
                addFloatingButton.isHidden = false
                //             segmentupUIControl()
                personTypechuck = 2
            }
           
            /* Moving Floating Button Code  - starts here[ Added By Ranjeet ] */
            self.addFloatingButton.frame = CGRect(x:self.view.frame.width - 80 , y: self.view.frame.height - 230 , width: 80 , height: 80 )
            /* Moving Floating Button Code - ends here[ Added By Ranjeet ] */
//            self.hitApiForPullToRefresh()
//            self.MyTestListTV.addSubview(self.refreshControl) //Added by yasodha for pull to refresh
            UserDefaults.standard.set(false, forKey: "TutorSkipInTest")
            
            
            
        }//else
        
        //self.MyTestListTV.register(UINib.init(nibName: "TestAttendedCell", bundle: nil), forCellReuseIdentifier: "testAttentedCell")
        
    }
    
      /*Added by yasodha 23/3/2020 start here */
    //For pull to refresh tableview
        @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
            if self.navigationController?.viewControllers.previous is PersonalProfileVC {//Added by yasodha on 8/5/2020
                
                self.hitApiForPullToRefresh()
                refreshControl.endRefreshing()
            }else{
                
                /*added by yasodha on 16/4/2020 starts here*/
                tablePageIndex0 = 1
                tablePageIndex1 = 1
                tablePageIndex2 = 1
                /*added by yasodha on 16/4/2020 ends here */
                self.hitApiForPullToRefresh()
                refreshControl.endRefreshing()
                
            }
        }
         /*Added by yasodha 23/3/2020 end here */
    
    
    override func viewWillDisappear(_ animated: Bool) {
        MyTestListTV.isHidden = false
       views.stopShimmering()
        views.removeFromSuperview()
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let navigationController = navigationController else { return }
        navigationController.view.backgroundColor = UIColor.init(hex:"2DA9EC")
        if (self.navigationController?.navigationBar) != nil {
            navigationController.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        }
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        /*Added by yasodha on 27/1/2020 starts */
        if self.navigationController?.viewControllers.previous is PersonalProfileVC {
            
                if tutorTestsEndPoint == "Tests Created"{
                navigationItem.title = "TEST CREATED"
            }else if studentTestTakenEndPoint == "Tests Attended"{
                navigationItem.title = "TEST TAKEN"
                
            }
            
        }
        else {/*Added by yasodha on 27/1/2020 ends here */
            navigationItem.title = "Tests"
            activeTabIndex = 0
            if personType == "1"{
                segmentupUIControl()
                tableviewTopHightCostrain.constant = 40
            }else{
                 navigationItem.title = "MyTest"
                 tableviewTopHightCostrain.constant = 0
//                segmentupUIControl()
            }
            /*Added by yasodha on 16/4/2020 starts here */
            tablePageIndex0 = 1
            tablePageIndex1 = 1
            tablePageIndex2 = 1
            /*Added by yasodha on 16/4/2020 ends here */
            
            self.hitApiForPullToRefresh()//uncommented by yasodha
            self.MyTestListTV.addSubview(self.refreshControl) 
            ModelData.shared.isAttandTV = false//added by yasodha 24/3/2020
            ModelData.shared.isClickReviewAnswer = false
            addFloatingButton.isUserInteractionEnabled = true//added by yasodha
            
        }//else
        self.MyTestListTV.allowsSelection = false
    }
    override func viewDidLayoutSubviews() {
        if self.navigationController?.viewControllers.previous is PersonalProfileVC {
            // navigationSearchBar.removeFromSuperview()
            navigationSearchBar.heightAnchor.constraint(equalToConstant: 0).isActive = true
            MyTestListTV.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
            MyTestListTV.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            MyTestListTV.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
            MyTestListTV.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            MyTestListTV.reloadData()
        }
       
    }
    
    
    /* Added by yasodha on 2/Jan/2020  - starts here */
    override func willMove(toParent parent: UIViewController?)
    {
        if self.navigationController?.viewControllers.previous is PersonalProfileVC {}
        else {
            if parent == nil
            {
                
//                UIApplication.shared.keyWindow!.rootViewController!.dismiss(animated: true, completion: nil) /* Commented By Yashoda on 27th Feb 2020 */
//                UIApplication.shared.keyWindow?.rootViewController = VSCore().launchHomePage(index: 0) /* Commented By Yashoda on 27th Feb 2020 */
                navigationController!.popToViewController((navigationController?.viewControllers[1])!, animated: false) /* Added By Yashoda on 27th Feb 2020 */
                
            }
        }//else
    }
    /* Added by yasodha on 2/Jan/2020- ends here */
    
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
            finalPoint.y = min(max(finalPoint.y, 160), self.view.bounds.size.height - 40)
            
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
    @IBAction func onFloatingButtonClick(_ sender: UIButton) {
        /********************************Commented by yasodha ********************************/
//        print("Floating button clicked")
//        let createNewTestVC = storyboard?.instantiateViewController(withIdentifier: "createnewtest") as! CreateNewTestVC
//        self.navigationController?.pushViewController(createNewTestVC, animated: true)
                
        /****************************************Commented by yasodha***************************************************/
        addFloatingButton.isUserInteractionEnabled = false
        
        let url = URL(string: Endpoints.userProfileEndPoint + (userId!))
        Alamofire.request(url!).responseJSON{ response in
            let dict = response.result.value as! Dictionary<String,Any>
            let controlsData = dict["ControlsData"] as? [String:Any]
            let tutorInfo   = controlsData?["tutorInfo"]
                        
            if  let id = tutorInfo as? NSNull
            {
                
                UserDefaults.standard.set(true, forKey: "Tutor")
                //  UserDefaults.standard.synchronize()
                let tutorSignUpVC = self.storyboard?.instantiateViewController(withIdentifier: "TutorSignUpVC") as! TutorSignUpVC
                self.navigationController?.pushViewController(tutorSignUpVC, animated: true)
                
            }
            else  {
                
                //  UserDefaults.standard.set(false, forKey: "TutorSkipInTest")
                print("Floating button clicked")
                let createNewTestVC = self.storyboard?.instantiateViewController(withIdentifier: "createnewtest") as! CreateNewTestVC
                self.navigationController?.pushViewController(createNewTestVC, animated: true)
            }
            
        }
        
    }
    /* Moving Floating Button Code - ends here[ Added By Ranjeet ] */
     func segmentupUIControl() {
        // Container view
        let view = UIView(frame: CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width, height: 45))
        view.backgroundColor = UIColor.init(hex:"2DA9EC")
        
        segmentedControl = UISegmentedControl()
        if personType == "1"{
            segmentedControl.insertSegment(withTitle: "TEST ATTENDED", at: 0, animated: true)
            segmentedControl.insertSegment(withTitle: "AVAILABLE TEST", at: 1, animated: true)
        }else{
           segmentedControl.insertSegment(withTitle: "MY TESTS", at: 0, animated: true)
        }
        // Add segments
        
        
        // First segment is selected by default
        segmentedControl.selectedSegmentIndex = 0
        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = UIColor.init(hex:"2DA9EC")
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
        
        if personType == "1"{
             buttonBar.backgroundColor = UIColor.orange
        }else{
             buttonBar.backgroundColor = UIColor.clear
        }
        
//        buttonBar.backgroundColor = UIColor.orange
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
        
        /*commented by yasodha */
        
//        // Constrain the top of the button bar to the bottom of the segmented control
//        buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
//        buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
//        // Constrain the button bar to the left side of the segmented control
//        buttonBar.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor).isActive = true
//        // Constrain the button bar to the width of the segmented control divided by the number of segments
//        buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
//
        
        /*Added by yasodha 24/3/2020 starts here */
          if ModelData.shared.isAttandTV == true{
                  activeTabIndex = 1
                  segmentedControl.selectedSegmentIndex = 1
                 // hitApiForPullToRefresh() // 7th may commented
                  
//                  buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
//                  buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
//                  // Constrain the button bar to the left side of the segmented control
//                  buttonBar.rightAnchor.constraint(equalTo: segmentedControl.rightAnchor).isActive = true
//                  // Constrain the button bar to the width of the segmented control divided by the number of segments
//                  buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
                                               
               /*Added by chandra 15/5/2020 starts here */
                                        self.buttonBar.frame.origin.x = (UIScreen.main.bounds.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
                                        self.buttonBar.frame.origin.y = 40
                                        self.buttonBar.frame.size.width = (UIScreen.main.bounds.width / CGFloat(self.segmentedControl.numberOfSegments))
                                        self.buttonBar.frame.size.height = 5
                                  /*Added by chandra 15/5/2020 ends here */
               
          }else if ModelData.shared.answerSubmitted == "Yes" || ModelData.shared.isClickReviewAnswer == true{
                         
                         // segmentedControl.selectedSegmentIndex = 0//commented by yasodha
                  
                                  ModelData.shared.answerSubmitted = ""
                                  segmentedControl.selectedSegmentIndex = 0
                               //   hitApiForPullToRefresh() //commented onn 7th may
                        
//                                  buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
//                                  buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
//                                  // Constrain the button bar to the left side of the segmented control
//                                  buttonBar.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor).isActive = true
//                                  // Constrain the button bar to the width of the segmented control divided by the number of segments
//                                  buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
            
            /*Added by chandra 15/5/2020 starts here */
                                     self.buttonBar.frame.origin.x = (UIScreen.main.bounds.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
                                     self.buttonBar.frame.origin.y = 40
                                     self.buttonBar.frame.size.width = (UIScreen.main.bounds.width / CGFloat(self.segmentedControl.numberOfSegments))
                                     self.buttonBar.frame.size.height = 5
                               /*Added by chandra 15/5/2020 ends here */
                        
                         
                }else{
                                  activeTabIndex = 1
                                  segmentedControl.selectedSegmentIndex = 1
                                  //hitApiForPullToRefresh() //commented onn 7th may
                                  
//                                  buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
//                                  buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
//                                  // Constrain the button bar to the left side of the segmented control
//                                  buttonBar.rightAnchor.constraint(equalTo: segmentedControl.rightAnchor).isActive = true
//                                  // Constrain the button bar to the width of the segmented control divided by the number of segments
//                                  buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
            
            /*Added by chandra 15/5/2020 starts here */
                                     self.buttonBar.frame.origin.x = (UIScreen.main.bounds.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
                                     self.buttonBar.frame.origin.y = 40
                                     self.buttonBar.frame.size.width = (UIScreen.main.bounds.width / CGFloat(self.segmentedControl.numberOfSegments))
                                     self.buttonBar.frame.size.height = 5
                               /*Added by chandra 15/5/2020 ends here */
                                                               
                  }
              
              
        
        
           /*Added by yasodha 24/3/2020 ends here */
        
        
        self.view.addSubview(view)
    }
    
    
//    private func segmentupUIControl1() {
//        // Container view
//        let view = UIView(frame: CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width, height: 45))
//        view.backgroundColor = UIColor.init(hex:"2DA9EC")
//
//        segmentedControl = UISegmentedControl()
//        // Add segments
//        segmentedControl.insertSegment(withTitle: "MY TEST", at: 0, animated: true)
//        segmentedControl.insertSegment(withTitle: "TEST ATTENDED", at: 1, animated: true)
//        segmentedControl.insertSegment(withTitle: "AVAILABLE TEST", at: 2, animated: true)
//        // First segment is selected by default
//        segmentedControl.selectedSegmentIndex = 0
//        if #available(iOS 13.0, *) {
//            segmentedControl.selectedSegmentTintColor = UIColor.init(hex:"2DA9EC")
//        } else {
//            // Fallback on earlier versions
//        }
//
//        // This needs to be false since we are using auto layout constraints
//        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
//
//        // Add lines below selectedSegmentIndex
//        segmentedControl.backgroundColor = .clear
//        segmentedControl.tintColor = .clear
//
//
//        buttonBar = UIView()
//        // This needs to be false since we are using auto layout constraints
//        buttonBar.translatesAutoresizingMaskIntoConstraints = false
//        buttonBar.backgroundColor = UIColor.orange
//
//        // Add lines below the segmented control's tintColor
//        segmentedControl.setTitleTextAttributes([
//            NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 15)!,
//            NSAttributedString.Key.foregroundColor: UIColor.white
//        ], for: .normal)
//
//        segmentedControl.setTitleTextAttributes([
//            NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 18)!,
//            NSAttributedString.Key.foregroundColor: UIColor.white
//        ], for: .selected)
//
//        // Add the segmented control to the container view
//        view.addSubview(segmentedControl)
//        view.addSubview(buttonBar)
//
//        // Constrain the segmented control to the top of the container view
//        segmentedControl.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        // Constrain the segmented control width to be equal to the container view width
//        segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        // Constraining the height of the segmented control to an arbitrarily chosen value
//        segmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
//        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: UIControl.Event.valueChanged)
//
//        // Constrain the top of the button bar to the bottom of the segmented control
//        buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
//        buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
//        // Constrain the button bar to the left side of the segmented control
//        buttonBar.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor).isActive = true
//        // Constrain the button bar to the width of the segmented control divided by the number of segments
//        buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
//
//        self.view.addSubview(view)
//    }
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.3) {[unowned self] in
            self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)

        }
        
        activeTabIndex = self.segmentedControl.selectedSegmentIndex
        hitApiForPullToRefresh()
        
        
    
        
//        if personType != "1" {
//            print("Selected segment index = \(self.segmentedControl.selectedSegmentIndex)")
//            //classTableView.setContentOffset(.zero, animated: true)
//            activeTabIndex = self.segmentedControl.selectedSegmentIndex
//            encoded = ""
//            if activeTabIndex == 0{
//                if(presentSegmentIndex != 0)
//                {
//                    presentSegmentIndex = 0
//                    tablePageIndex0 = 1
//                }
//                tableViewDataSource.removeAll()
//                MyTestListTV.reloadData()
//
//                 endPointUrl = Endpoints.myTests + userId! + "/\(tablePageIndex0)" + "/\(noOfItemsInaPage)?searchtext=" + "\(encoded ?? "")"
//
//                hitServer(params: [:], endPoint: endPointUrl, action: "MyTests", httpMethod: .get)
//
//            }
//        }else{
//            print("Selected segment index = \(self.segmentedControl.selectedSegmentIndex)")
//            //classTableView.setContentOffset(.zero, animated: true)
//            activeTabIndex = self.segmentedControl.selectedSegmentIndex
//             if activeTabIndex == 0{
//               // tableViewDataSource.removeAll()
//                testAttendedData.removeAll()
//
//                MyTestListTV.reloadData()
//                if(presentSegmentIndex != 0)
//                {
//                    presentSegmentIndex = 0
//                    tablePageIndex1 = 1
//                }
//                 endPointUrl = Endpoints.testTakenByYou + userId! + "/\(tablePageIndex1)" + "/\(noOfItemsInaPage)?searchtext=" + "\(encoded ?? "")"
//                hitServer(params: [:], endPoint: endPointUrl, action: "TestTakenByYou", httpMethod: .get)
//
//            }else if activeTabIndex == 1{
//                tableViewDataSource.removeAll()
//                 MyTestListTV.reloadData()
//                if(presentSegmentIndex != 1)
//                {
//                    presentSegmentIndex = 1
//                    tablePageIndex2 = 1
//                }
//                endPointUrl = Endpoints.testAvailableForYou + userId! + "/\(tablePageIndex2)" + "/\(noOfItemsInaPage)?searchtext=" + "\(encoded ?? "")"
//
//                hitServer(params: [:], endPoint: endPointUrl, action: "TestAvailableForYou", httpMethod: .get)
//            }
//
//
//        }
        
        
        
        
    }
    @IBAction func OnSearchClickBtn(sender:UIButton) {
        search = true
        textFieldSearch.resignFirstResponder() // hides the keyboard.
        self.tableViewDataSource.removeAll()//added by yasodha
        self.testAttendedData.removeAll()//added by yasodha
        let searchText = textFieldSearch.text
        if searchText?.count == 0{
            encoded = "".addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        }else{
            encoded = searchText!.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        }
        // encoded = searchText!.addingPercentEncoding(withAllowedCharacters: .alphanumerics) /* Commented By Yashoda on 4th March 2020 */
        
        
        if personType != "1"{
            if activeTabIndex == 0{
                 tablePageIndex0 = 1//added by yasodha
                endPointUrl = Endpoints.myTests + userId! + "/\(tablePageIndex0)" + "/\(noOfItemsInaPage)?searchtext=" + "\(encoded ?? "")"
                hitServer(params: [:], endPoint: endPointUrl, action: "MyTests", httpMethod: .get)
            }
        }else{
            if activeTabIndex == 0{
                 tablePageIndex1 = 1//added by yasodha
                 endPointUrl = Endpoints.testTakenByYou + userId! + "/\(tablePageIndex1)" + "/\(noOfItemsInaPage)?searchtext=" + "\(encoded ?? "")"
                hitServer(params: [:], endPoint: endPointUrl, action: "TestTakenByYou", httpMethod: .get)
                
            }else if activeTabIndex == 1{
                tablePageIndex2 = 1 //added by yasodha
                endPointUrl = Endpoints.testAvailableForYou + userId! + "/\(tablePageIndex2)" + "/\(noOfItemsInaPage)?searchtext=" + "\(encoded ?? "")"
                
                hitServer(params: [:], endPoint: endPointUrl, action: "TestAvailableForYou", httpMethod: .get)
                
            }
        }
         
    }
    
    
    @objc func hitApiForPullToRefresh() {
       
        /*Added by yasodha on 28/1/2020*/
        if self.navigationController?.viewControllers.previous is PersonalProfileVC {
            if currentReachabilityStatus != .notReachable {
                                
                if perSonType == 1 {
                    print("************** Student*****************")
                    
                    if studentTestTakenEndPoint == "Tests Taken"{//Added by yasodha on 8/5/2020
                    testDataSet.removeAll()
                        hitServer(params: [:], endPoint: Endpoints.StudentTestTakenEndPoint + userId! + "/" + (UserDefaults.standard.string(forKey: "personalprofile")!) + "?searchText=\("")" , action: "testDataSet", httpMethod: .get)
                                                
                    }
                    
                    
                }else if perSonType == 3 {
                    print("************* Teacher ****************")
                    
                    if tutorTestsEndPoint == "Tests Created"{""
                         testDataSet.removeAll()
                        hitServer(params: [:], endPoint: Endpoints.TutorTestsEndPoint + userId! + "/" + (UserDefaults.standard.string(forKey: "personalprofile")!) + "?searchText=\("")" , action: "testDataSet", httpMethod: .get)
                    }
                    
                    
                }
                
                
                
            } else {
                showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
                })
            }
            /* Added by yasoda on 18/1/2020 for Teacher and Student Personal Detailes*/
            
        }else {
            let searchText = textFieldSearch.text
            if searchText?.count == 0{
                encoded = "".addingPercentEncoding(withAllowedCharacters: .alphanumerics)
            }else{
                encoded = searchText!.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
            }
            
            /*Added by yasodha on 28/1/2020 - ends here */
          
            
            if personType != "1"{
                if activeTabIndex == 0{
                    tablePageIndex0 = 1
                    tableViewDataSource.removeAll()
                    testAttendedData.removeAll()
                    endPointUrl = Endpoints.myTests + userId! + "/\(tablePageIndex0)" + "/\(noOfItemsInaPage)?searchtext=" + "\(encoded ?? "")"
                    hitServer(params: [:], endPoint: endPointUrl, action: "MyTests", httpMethod: .get)
                }
            }else{
                
//               if ModelData.shared.isAttandTV == true{
////                                activeTabIndex = 1
////
//
//                    }
                if ModelData.shared.isAttandTV == true{
                    activeTabIndex = 1
                    
                }else if ModelData.shared.isClickReviewAnswer == true {
                    activeTabIndex = 0
                }
                
                if activeTabIndex == 0{
                    tablePageIndex1 = 1
                    tableViewDataSource.removeAll()
                    testAttendedData.removeAll()
                    endPointUrl = Endpoints.testTakenByYou + userId! + "/\(tablePageIndex1)" + "/\(noOfItemsInaPage)?searchtext=" + "\(encoded ?? "")"
                    hitServer(params: [:], endPoint: endPointUrl, action: "TestTakenByYou", httpMethod: .get)
                    
                }else if activeTabIndex == 1{
                    tablePageIndex2 = 1
                    tableViewDataSource.removeAll()
                    testAttendedData.removeAll()
                    endPointUrl = Endpoints.testAvailableForYou + userId! + "/\(tablePageIndex2)" + "/\(noOfItemsInaPage)?searchtext=" + "\(encoded ?? "")"
                    
                    hitServer(params: [:], endPoint: endPointUrl, action: "TestAvailableForYou", httpMethod: .get)
                    
                }
            }
            
        }//else
        
    }
    @objc func hitApiForMyTest() {
        //        refreshControl.endRefreshing()
        
        if personType != "1"{
            if activeTabIndex == 0{
                endPointUrl = Endpoints.myTests + userId! + "/\(tablePageIndex0)" + "/\(noOfItemsInaPage)?searchtext=" + "\(encoded ?? "")"
                hitServer(params: [:], endPoint: endPointUrl, action: "MyTests", httpMethod: .get)
            }
        }else{
            if activeTabIndex == 0{
                 endPointUrl = Endpoints.testTakenByYou + userId! + "/\(tablePageIndex1)" + "/\(noOfItemsInaPage)?searchtext=" + "\(encoded ?? "")"
                hitServer(params: [:], endPoint: endPointUrl, action: "TestTakenByYou", httpMethod: .get)
                
            }else if activeTabIndex == 1{
                endPointUrl = Endpoints.testAvailableForYou + userId! + "/\(tablePageIndex2)" + "/\(noOfItemsInaPage)?searchtext=" + "\(encoded ?? "")"
                
                hitServer(params: [:], endPoint: endPointUrl, action: "TestAvailableForYou", httpMethod: .get)
                
            }
        }
        
    }
    
    private func hitServer(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
      //  startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))   // commeted by veeresh on 19/2/2020
        /// added by veeresh on 19/2/2020 /
        segmentedControl.isUserInteractionEnabled = false
        var shim = UIImageView()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: shim = UIImageView(image: UIImage(named: "my-group-mobile")!) ; shim.contentMode = .topLeft
        case .pad: shim = UIImageView(image: UIImage(named: "my-group-ipad")!) ; shim.contentMode = .scaleToFill
        case .unspecified: shim = UIImageView(image: UIImage(named: "my-group-mobile")!)
        case .tv: shim = UIImageView(image: UIImage(named: "my-group-ipad")!) ; shim.contentMode = .topLeft
        case .carPlay: shim = UIImageView(image: UIImage(named: "my-group-mobile")!)
        }//scaleAspectFill
         /* added by veeresh on 26/2/2020 */
//            MyTestListTV.backgroundView = shim  /* added by veeresh on 26/2/2020 */
//        shim.startShimmering()  /* added by veeresh on 26/2/2020 */
//
        /*Added by yasodha 6/4/2020 starts here */
        if tableViewDataSource.count < 1 || testDataSet.count < 1 || testAttendedData.count < 1{
              MyTestListTV.reloadData()
              MyTestListTV.backgroundView = shim
              shim.frame = MyTestListTV.frame
              shim.startShimmering()

              }
              /*Added by yasodha 6/4/2020 ends here */
        
        
        
        
        
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){ [weak self] result in
            guard let _self = self else {
                return
            }
             /* added by veeresh on 19/2/2020 */
           _self.MyTestListTV.backgroundView = UIView()
          
//        shim.stopShimmering()
//        shim.removeFromSuperview()
             /* added by veeresh on 19/2/2020 */
         //   _self.stopAnimating()  // commeted by veeresh on 19/2/2020
            //            _self.refreshControl.endRefreshing()
            _self.activityIndicator.stop()
            
            switch result {
            case let .success(json,requestType):
                _self.segmentedControl.isUserInteractionEnabled = true
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }
                else {
                    /* Added by yasodha on 28/1/2020 starts here*/
                    self!.actionTest = action
                    
                    if self!.actionTest == "testDataSet" {
                        _self.testDataSet.removeAll()
                        _self.testDataSet.append(contentsOf: json["ControlsData"]["lsv_test"].arrayValue)
                        
                    }else{
                        _self.parseNDispayListData(json: json["ControlsData"]["lsv_test"], requestType: requestType)
                        // self?.taBleView.reloadData()
                    }
                     /* Added by yasodha on 28/1/2020 endss here*/
                    // _self.parseNDispayListData(json: json["ControlsData"]["lsv_test"], requestType: requestType)//commented by yasodha
                    //                self?.taBleView.reloadData()
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
            
            shim.stopShimmering()
            shim.removeFromSuperview()
            
        }
    }
    private func parseNDispayListData(json: JSON,requestType: String){
        /* Commented  By Chandra on 3rd Jan 2020 - starts here */
        //       self.tableViewDataSource.removeAll()
        //           tableViewDataSource.append(contentsOf: json.arrayValue)
        //       print(tableViewDataSource)
        //           DispatchQueue.main.async {
        //               self.MyTestListTV.reloadData()
        //           }
        /* Commented  By Chandra on 3rd Jan 2020 - ends here */
        
        /* Added By Chandra on 3rd Jan 2020 - starts here */
        
        DispatchQueue.global(qos: .background).async {
            
            if self.delete == true {
                
            }else{
                //            self.tableViewDataSource.removeAll()
            }
            
            
            if self.search == true{
                /*Added by yasodha on 25/4/2020 starts here */
                if self.actionTest == "TestTakenByYou" {
                    self.testAttendedData.append(contentsOf: json.arrayValue)
                } else{
                    self.tableViewDataSource.append(contentsOf: json.arrayValue)
                    
                }
                
                /*Added by yasodha end here */
                // self.tableViewDataSource.append(contentsOf: json.arrayValue)//commented by yasodha
                
                
            }else{
                
                if self.actionTest == "TestTakenByYou" {
                    self.tableViewDataSource.removeAll()
                    self.testAttendedData.append(contentsOf: json.arrayValue)
                    
                }else{
                    
                    self.testAttendedData.removeAll()
                    self.tableViewDataSource.append(contentsOf: json.arrayValue)
                    if self.delete == true{
                        
                    }else{
                        if self.tableViewDataSource.count == 0{
                        }
                    }
                    
                }
                
                
            }
            
            
            DispatchQueue.main.async {
                
                if (self.tableViewDataSource.count == 0 && self.search == true) &&  self.actionTest != "TestTakenByYou"{
                    showMessage(bodyText: "data is not found",theme: .error)
                    self.search = false
                    
                }else if self.testAttendedData.count == 0 && self.search == true  && self.actionTest == "TestTakenByYou"{
                    showMessage(bodyText: "data is not found",theme: .error)
                    self.search = false
                }
                //updated by yasodha
                self.MyTestListTV.reloadData()
            }
        }
        
        /* Added By Chandra on 3rd Jan 2020 - ends here */
    }
    @objc func onReviewTestBtnClick(sender: UIButton) {
        let dict = self.tableViewDataSource[sender.tag]
        let attendeesViewController = storyboard?.instantiateViewController(withIdentifier: "attendeesViewController") as! AttendeesViewController
        attendeesViewController.testId = dict["TestID"].stringValue
        self.navigationController?.pushViewController(attendeesViewController, animated: true)
        
    }
    @objc func onTestStartReviewBtnClick(sender: UIButton) {
        
        
      
            self.peformCellOrBtnClick(sender.tag)
        
        
    }
    @objc func onDeleteTestBtnClick(sender: UIButton) {
        /*Added by yasodh 3/4/2020 starts here */
        let alert = UIAlertController(title: "Delete Test", message: "Would you like to delete the Test", preferredStyle: UIAlertController.Style.alert)
               
               // show the alert
               self.present(alert, animated: true, completion: nil)
               
               alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { action in
                               
                   let dict = self.tableViewDataSource[sender.tag]
                   //        sender.springAnimation(btn: sender)// add by chandra for spring animation to the button
                   //        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                   if dict["UserID"].string == self.userId! {
                       print("Delete test")
                       //{TestID}/{UserID}
                       self.deletedItemIndex = sender.tag
                       self.hitServer(params: [:], endPoint: Endpoints.deleteTestEndPoint + dict["TestID"].stringValue + "/" + self.userId! ,action: "deleteMyTest", httpMethod: .get)
                       self.tableViewDataSource.remove(at: self.deletedItemIndex)
                    self.MyTestListTV.reloadData()//Added by yasodha
                       
                   }else {
                       if dict["IsTaken"].intValue == 0{
                           print("Attnend test")
                       }else {
                           print("Review test test")
                       }
                   }
                   self.delete = true
                   
                   //    })
               }))//alert
               alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: { action in
                   
                   return
                   
               }))
               /*Added by yasodha 3/4/2020 ends here */
    }
    private func peformCellOrBtnClick(_ index: Int) {
        print("Button taped")
        /*Added by yasodha on 31/1/2020 starts here */
        
        if self.navigationController?.viewControllers.previous is PersonalProfileVC {
            // dict = self.testDataSet[index]
            let dict = self.testDataSet[index]
            if dict["UserID"].string == userId! {
                let createNewTestVC = storyboard?.instantiateViewController(withIdentifier: "createnewtest") as! CreateNewTestVC
                createNewTestVC.isEditTest = true
                createNewTestVC.testID = dict["TestID"].stringValue
                
                UserDefaults.standard.set(dict["NoAttendees"].int, forKey: "noOfAttentees")//yasodha 28/1/2020
                
                self.navigationController?.pushViewController(createNewTestVC, animated: true)
                
            }else {
                
                if dict["IsTaken"].intValue == 0{
                    // perform action for Start test
                    let attandTestVC = storyboard?.instantiateViewController(withIdentifier: "answertestvc") as! AttandTestVC
                    attandTestVC.testID = self.testDataSet[index]["TestID"].stringValue
                    
                    attandTestVC.testDuration = self.testDataSet[index]["Duration"].stringValue
                    
                    navigationController?.pushViewController(attandTestVC, animated: true)
                }else {
                    //perform action for Review test
                    print("Review test")
                    let reviewTestVC = storyboard?.instantiateViewController(withIdentifier: "reviewtestvc") as! ReviewTestVC
                    reviewTestVC.testID = self.testDataSet[index]["TestID"].stringValue
                    reviewTestVC.testTitle = self.testDataSet[index]["TestTitle"].stringValue
                    //reviewTestVC.scoreDisplay = self.tableViewDataSource[index]["score"].int//yasodha
                    
                    navigationController?.pushViewController(reviewTestVC, animated: true)
                }
            }
            
            
            
            
        }else{
            /*Added by yasodha on 31/1/2020 ends here */
            
            
            
          //  let dict = self.tableViewDataSource[index]
          //  if dict["UserID"].string == userId! {//Teacher
            if actionTest == "MyTests"{
                
                let dict = self.tableViewDataSource[index]
                number_Of_Attendees = dict["NoAttendees"].int

                if number_Of_Attendees == 0 {
                //showMessage(bodyText: "Work in Progress",theme: .success,presentationStyle: .center, duration: .seconds(seconds: 1))
                let createNewTestVC = storyboard?.instantiateViewController(withIdentifier: "createnewtest") as! CreateNewTestVC
                createNewTestVC.isEditTest = true
                createNewTestVC.testID = dict["TestID"].stringValue

                UserDefaults.standard.set(dict["NoAttendees"].int, forKey: "noOfAttentees")//yasodha 28/1/2020

                self.navigationController?.pushViewController(createNewTestVC, animated: true)

                }else {
                let alert = UIAlertController(title: "", message: "\(number_Of_Attendees!) students have subscribed for this class, would you like to create a copy of this test?", preferredStyle: UIAlertController.Style.alert)

                // show the alert
                self.present(alert, animated: true, completion: nil)
                alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { action in
                let createNewTestVC = self.storyboard?.instantiateViewController(withIdentifier: "createnewtest") as! CreateNewTestVC
                createNewTestVC.isEditTest = true
                createNewTestVC.testID = dict["TestID"].stringValue

                UserDefaults.standard.set(dict["NoAttendees"].int, forKey: "noOfAttentees")//yasodha 28/1/2020

                self.navigationController?.pushViewController(createNewTestVC, animated: true)

                }))//alert

                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: { action in

                }))//alert

                }//else
                /*Added by yasodha 5/3/2020 ends here */
                
            }else {
                
               // if dict["IsTaken"].intValue == 0{
                
                if actionTest == "TestAvailableForYou" {
                    // perform action for Start test
                    //answertestvc
                    let attandTestVC = storyboard?.instantiateViewController(withIdentifier: "answertestvc") as! AttandTestVC
                    attandTestVC.testID = self.tableViewDataSource[index]["TestID"].stringValue
                    
                    attandTestVC.testDuration = self.tableViewDataSource[index]["Duration"].stringValue
                    
                    navigationController?.pushViewController(attandTestVC, animated: true)
                }else {
                    //perform action for Review test
                    print("Review test")
                    let reviewTestVC = storyboard?.instantiateViewController(withIdentifier: "reviewtestvc") as! ReviewTestVC
//                    reviewTestVC.testID = self.tableViewDataSource[index]["TestID"].stringValue
//                    reviewTestVC.testTitle = self.tableViewDataSource[index]["TestTitle"].stringValue
                      reviewTestVC.testID = self.testAttendedData[index]["TestID"].stringValue
                      reviewTestVC.testTitle = self.testAttendedData[index]["TestTitle"].stringValue
                    
                    
                    //reviewTestVC.scoreDisplay = self.tableViewDataSource[index]["score"].int//yasodha
                    
                    navigationController?.pushViewController(reviewTestVC, animated: true)
                }
            }
            
        }//else
    }
    func setborderForBtn(btn:UIButton){
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = (btn.frame.height / 2)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.init(hex: "FFD700").cgColor
    }
    @objc func cellTappedMethod(_ sender:AnyObject){
        print("you tap image number: \(sender.view.tag)")
        print("you are tapped on image you will get the imge info from ranjeet view controller ")
        if self.navigationController?.viewControllers.previous is PersonalProfileVC {}//Added by yasodha on 31/1/2020
        else{
//            let index = tableViewDataSource[sender.view.tag]
//
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "personalprofile") as! PersonalProfileVC
//            vc.userID = tableViewDataSource[sender.view.tag]["UserID"].stringValue
//            self.navigationController?.pushViewController(vc, animated: true)
            if actionTest == "TestTakenByYou"{
            let index = testAttendedData[sender.view.tag]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "personalprofile") as! PersonalProfileVC
            vc.userID = testAttendedData[sender.view.tag]["UserID"].stringValue
            self.navigationController?.pushViewController(vc, animated: true)
            }else{
            let index = tableViewDataSource[sender.view.tag]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "personalprofile") as! PersonalProfileVC
            vc.userID = tableViewDataSource[sender.view.tag]["UserID"].stringValue
            self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension MyTestVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.navigationController?.viewControllers.previous is PersonalProfileVC {
            
        if actionTest == "testDataSet"{
                return testDataSet.count
            }
        }else if self.actionTest == "TestTakenByYou" {
            return testAttendedData.count
            
        }
        else{
            return tableViewDataSource.count
            
        }
        
        return 0
        
        // return tableViewDataSource.count//commented by yasodha
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "myTestCell") as! MyTestCell
        let dict: JSON
        if self.navigationController?.viewControllers.previous is PersonalProfileVC {
            
            //dict = self.tableViewDataSource[indexPath.row]
            var cell = tableView.dequeueReusableCell(withIdentifier: "myTestCell") as! MyTestCell
            // tableView.rowHeight = 250
           // tableView.rowHeight = screenHeight/2.8
            
            dict = self.testDataSet[indexPath.row]
            /* Thumbnail related image Added By Ranjeet - From Here */
            let stringUrl = dict["ProfileUrl"].stringValue
            let thumbnail = stringUrl.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
            cell.uiImageView?.sd_setImage(with: URL.init(string:thumbnail ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTappedMethod(_:)))
            cell.uiImageView.isUserInteractionEnabled = true
            cell.uiImageView.tag = indexPath.row
            cell.uiImageView.addGestureRecognizer(tapGestureRecognizer)
            
            cell.createdByNameLabel.text = dict["CreatedBy"].stringValue
            cell.titleNameLabel.text = dict["TestTitle"].stringValue
            cell.topicSubtopicValueLabel.text = "\(dict["SubjectName"].stringValue) | \(dict["SubTopicName"].stringValue)"
            cell.noOFQuesBtn.setTitle(dict["NoQuestions"].stringValue == "" ? "0" : dict["NoQuestions"].stringValue, for: .normal)
            cell.timeBtn.setTitle(dict["Duration"].stringValue, for: .normal)
            cell.applicableBtn.setTitle(dict["ExpiryDate"].stringValue, for: .normal)
            cell.reviewTestBTn.isHidden = true
            
            
            if dict["ExpiryDate"].stringValue == "" {
                cell.applicableBtn.isHidden = true
                                
            }else {
                cell.applicableBtn.isHidden =  false
                
            }
            
            
            /**************************************************************************/
            
            if personType == "1" { //User login type
                /* Student*/
                                
                if dict["IsTaken"].intValue == 0 {
                    cell.testStartBTn.setImage(UIImage.init(named: ""), for: .normal)/*add by chandra on 13 dec*/
                    cell.testTakenBtn.isHidden = true/*add by chandra on 13 dec*/
                    cell.testTakenBtn.setTitle("Not yet Taken", for: .normal)
                    cell.testTakenBtn.isSelected = false
                    cell.testStartBTn.setTitleColor(.orange, for: .normal)/*add by chandra on 13 dec*/
                    cell.testStartBTn.setTitle("Start Test", for: .normal)
                    setborderForBtn(btn: cell.testStartBTn)/*add by chandra on 13 dec*/
                }else {
                    cell.testStartBTn.setImage(UIImage.init(named: ""), for: .normal)/*add by chandra on 13 dec*/
                    cell.testTakenBtn.isHidden = true/*add by chandra on 13 dec*/
                    cell.testTakenBtn.setTitle("Taken", for: .normal)
                    cell.testTakenBtn.isSelected = true
                    cell.testStartBTn.setTitleColor(.orange, for: .normal)/*add by chandra on 13 dec*/
                    setborderForBtn(btn: cell.testStartBTn)/*add by chandra on 13 dec*/
                    cell.testStartBTn.setTitle("Review Answers", for: .normal)
                    cell.testStartBTn.setImage(UIImage.init(named: ""), for: .normal)
                }
                cell.testStartBTn.contentHorizontalAlignment = .center
                cell.testStartBTn.tag = indexPath.row
                cell.testStartBTn.addTarget(self, action: #selector(onTestStartReviewBtnClick), for: .touchUpInside)
                
            }
            else{
                /* Teacher*/
                
                cell.testStartBTn.isHidden = true
                cell.testTakenBtn.isHidden = true
                
            }
            
            
            return cell
            
        }else {
            
            
            // "MyTests"
            
            //TestTakenByYou
            
            //"TestAvailableForYou"
            
            
            if  self.actionTest == "MyTests"{//teacher
                let cell = tableView.dequeueReusableCell(withIdentifier: "myTestCell") as! MyTestCell
                //  tableView.rowHeight = 240
               // tableView.rowHeight = screenHeight/3
                                
                if tableViewDataSource.count > 0 {
                    
                    dict = self.tableViewDataSource[indexPath.row]
                    
                    /* Thumbnail related image Added By Ranjeet - From Here */
                    let stringUrl = dict["ProfileUrl"].stringValue
                    let thumbnail = stringUrl.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
                    cell.uiImageView?.sd_setImage(with: URL.init(string:thumbnail ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTappedMethod(_:)))
                    cell.uiImageView.isUserInteractionEnabled = true
                    cell.uiImageView.tag = indexPath.row
                    cell.uiImageView.addGestureRecognizer(tapGestureRecognizer)
                    cell.createdByNameLabel.text = dict["CreatedBy"].stringValue
                    cell.titleNameLabel.text = dict["TestTitle"].stringValue
                    cell.topicSubtopicValueLabel.text = "\(dict["SubjectName"].stringValue) | \(dict["SubTopicName"].stringValue)"
                    cell.noOFQuesBtn.setTitle(dict["NoQuestions"].stringValue == "" ? "0" : dict["NoQuestions"].stringValue, for: .normal)
                    cell.timeBtn.setTitle(dict["Duration"].stringValue, for: .normal)
                    cell.applicableBtn.setTitle(dict["ExpiryDate"].stringValue, for: .normal)
                    
                    if dict["SharedType"].stringValue == "1" {
                        cell.testModeBtn.isSelected = false
                    }else {
                        cell.testModeBtn.isSelected = true
                    }
                    
                    
                    if dict["ExpiryDate"].stringValue == "" {
                        cell.applicableBtn.isHidden = true
                        
                        
                    }else {
                        cell.applicableBtn.isHidden =  false
                        
                    }
                    
                    
                    if personType != "1"{
                        cell.testTakenBtn.isUserInteractionEnabled = true
                        cell.testTakenBtn.setImage(UIImage.init(named: "Asset 12"), for: .normal)/*add by chandra on 13 dec*/
                        cell.testTakenBtn.isHidden = false/*add by chandra on 13 dec*/
                        cell.testTakenBtn.setTitle("Delete", for: .normal)
                        cell.testTakenBtn.isSelected = false
                        cell.testStartBTn.setTitleColor(UIColor.init(hex: "00994c"), for: .normal)/*add by chandra on 13 dec*/
                        
                        cell.testStartBTn.setTitle("Edit", for: .normal)
                        cell.testStartBTn.setImage(UIImage.init(named: "edit-1"), for: .normal)/*add by chandra on 13 dec*/
                        cell.testStartBTn.backgroundColor = .clear
                        cell.testStartBTn.layer.cornerRadius = (cell.testStartBTn.frame.height / 2)
                        cell.testStartBTn.layer.borderWidth = 0
                        cell.testStartBTn.layer.borderColor = UIColor.init(hex: "FFD700").cgColor
                        
                        /*Updated by yasodha */
                        cell.ratingView.isHidden = true
                        cell.hightForTheRatingView.constant = 0
                        cell.hightForTheNameBtn.constant = 0
                        cell.widthForTheuiImageView.constant = 0
                        
                        /*updated by yasodha */
                        
                        
                    }
                    
                    
                    let noAttendees = dict["NoAttendees"].intValue
                    if dict["UserID"].string == userId && noAttendees > 0 {
                        cell.reviewTestBTn.isHidden = false
                        cell.reviewTestBTn.setTitle(" \(noAttendees) Attended ", for: .normal)
                    }else {
                        cell.reviewTestBTn.isHidden = true
                        cell.reviewTestBTn.setTitle(" \(noAttendees) Attended ", for: .normal)
                        
                    }
                    
                    cell.reviewTestBTn.tag = indexPath.row
                    cell.reviewTestBTn.addTarget(self, action: #selector(onReviewTestBtnClick), for: .touchUpInside)
                    
                    cell.testTakenBtn.tag = indexPath.row
                    cell.testTakenBtn.addTarget(self, action: #selector(onDeleteTestBtnClick), for: .touchUpInside)
                    
                    cell.testStartBTn.tag = indexPath.row
                    cell.testStartBTn.addTarget(self, action: #selector(onTestStartReviewBtnClick), for: .touchUpInside)
                    
                    
                    return cell
                    
                }
            }
            
            
            if  self.actionTest == "TestAvailableForYou"{//teacher
                
                //   let cell = tableView.dequeueReusableCell(withIdentifier: "myTestCell") as! MyTestCell
                self.MyTestListTV.register(UINib.init(nibName: "AvailableTestCell", bundle: nil), forCellReuseIdentifier: "availableTestCell")
                let cell = tableView.dequeueReusableCell(withIdentifier: "availableTestCell", for: indexPath) as! AvailableTestCell
                //  tableView.rowHeight = 286
                
                //tableView.rowHeight = screenHeight/2.55
                
                print("Screen width = \(screenWidth), screen height = \(screenHeight)")
                                
                
                
                if tableViewDataSource.count > 0 {
                    
                    dict = self.tableViewDataSource[indexPath.row]
                    
                    /* Thumbnail related image Added By Ranjeet - From Here */
                    let stringUrl = dict["ProfileUrl"].stringValue
                    let thumbnail = stringUrl.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
                    cell.uiImageView?.sd_setImage(with: URL.init(string:thumbnail ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTappedMethod(_:)))
                    cell.uiImageView.isUserInteractionEnabled = true
                    cell.uiImageView.tag = indexPath.row
                    cell.uiImageView.addGestureRecognizer(tapGestureRecognizer)
                    cell.createdByNameLabel.text = dict["CreatedBy"].stringValue
                    cell.titleNameLabel.text = dict["TestTitle"].stringValue
                    cell.topicSubtopicValueLabel.text = "\(dict["SubjectName"].stringValue) | \(dict["SubTopicName"].stringValue)"
                    cell.noOFQuesBtn.setTitle(dict["NoQuestions"].stringValue == "" ? "0" : dict["NoQuestions"].stringValue, for: .normal)
                    cell.timeBtn.setTitle(dict["Duration"].stringValue, for: .normal)
                    cell.applicableBtn.setTitle(dict["ExpiryDate"].stringValue, for: .normal)
                    
                    if dict["SharedType"].stringValue == "1" {
                        cell.testModeBtn.isSelected = false
                    }else {
                         cell.testModeBtn.isSelected = true
                        cell.testModeBtn.setImage(UIImage(named: "private-lock"), for: .normal)
                        cell.testModeBtn.setTitle("Private", for: .normal)
                    }
                    /*This is for Public and Private */
                    if dict["ExpiryDate"].stringValue == "" {
                        cell.applicableBtn.isHidden = true
                     //   cell.leadingToTimeAndMode.constant = 230
                        
                    }else {
                        cell.applicableBtn.isHidden =  false
                       // cell.leadingToTimeAndMode.constant = 257
                    }
                    
                    
                    
                    if #available(iOS 13.0, *) {
                        if UITraitCollection.current.userInterfaceStyle == .dark {
                            print("Dark mode")
                            cell.titleNameLbl.textColor = .white
                            cell.topicSubTopicLabel.textColor = .white
                        }
                        else {
                            print("Light mode")
                        }
                    }
                    
                    cell.testStartBTn.tag = indexPath.row
                    cell.testStartBTn.addTarget(self, action: #selector(onTestStartReviewBtnClick), for: .touchUpInside)
                    
                    cell.ratingView.isHidden = false
                    cell.ratingView.rating = dict["Rating"].intValue == 0 ? 2.5 : Double(dict["Rating"].intValue)/* Updated By Veeresh on 3rd April 2020 */
                    cell.hightForTheNameBtn.constant = 21
                    cell.hightForTheRatingView.constant = 23
                    cell.widthForTheuiImageView.constant = 60
                    return cell
                    
                }
            }
            
            
            
            if  self.actionTest == "TestTakenByYou"{//teacher
                
                self.MyTestListTV.register(UINib.init(nibName: "TestAttendedCell", bundle: nil), forCellReuseIdentifier: "testAttentedCell")
                let cell = tableView.dequeueReusableCell(withIdentifier: "testAttentedCell", for: indexPath) as! TestAttendedCell
                //tableView.rowHeight = 286
                
                //tableView.rowHeight = screenHeight/2.55
                
                //Checking data of Availabletest
                if activeTabIndex == 0 && tableViewDataSource.count > 0 {
                    tableViewDataSource.removeAll()
                }
                
                
                if testAttendedData.count > 0 {
                    dict = self.testAttendedData[indexPath.row]
                    let stringUrl = dict["ProfileUrl"].stringValue
                    let thumbnail = stringUrl.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
                    cell.uiImageView?.sd_setImage(with: URL.init(string:thumbnail ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTappedMethod(_:)))
                    cell.uiImageView.isUserInteractionEnabled = true
                    cell.uiImageView.tag = indexPath.row
                    cell.uiImageView.addGestureRecognizer(tapGestureRecognizer)
                    cell.createdByNameLabel.text = dict["CreatedBy"].stringValue
                    cell.titleNameLabel.text = dict["TestTitle"].stringValue
                    cell.topicSubtopicValueLabel.text = "\(dict["SubjectName"].stringValue) | \(dict["SubTopicName"].stringValue)"
                    cell.noOFQuesBtn.setTitle(dict["NoQuestions"].stringValue == "" ? "0" : dict["NoQuestions"].stringValue, for: .normal)
                    cell.timeBtn.setTitle(dict["Duration"].stringValue, for: .normal)
                    cell.applicableBtn.setTitle(dict["ExpiryDate"].stringValue, for: .normal)
                    
                    if dict["SharedType"].stringValue == "1" {
                        cell.testModeBtn.isSelected = false
                    }else {
                        cell.testModeBtn.isSelected = true
                        cell.testModeBtn.setImage(UIImage(named: "private-lock"), for: .normal)
                        cell.testModeBtn.setTitle("Private", for: .normal)
                    }
                    //Adjuesting Time and Mode Leading based on expirydate
                    if dict["ExpiryDate"].stringValue == "" {
                        cell.applicableBtn.isHidden = true
                        //cell.leadingToTimeAndMode.constant = 230
                    }else {
                        cell.applicableBtn.isHidden = false
                       // cell.leadingToTimeAndMode.constant = 257
                    }
                    
                    if #available(iOS 13.0, *) {
                        if UITraitCollection.current.userInterfaceStyle == .dark {
                            print("Dark mode")
                            cell.titleNameLbl.textColor = .white
                            cell.topicSubTopicLabel.textColor = .white
                        }
                        else {
                            print("Light mode")
                        }
                    }
                    
                    cell.reviewTestBTn.tag = indexPath.row
                    cell.reviewTestBTn.addTarget(self, action: #selector(onTestStartReviewBtnClick), for: .touchUpInside)
                    
                    
                    cell.ratingView.isHidden = false
                    cell.ratingView.rating = dict["Rating"].intValue == 0 ? 2.5 : Double(dict["Rating"].intValue)/* Updated By Veeresh on 3rd April 2020 */
                    cell.hightForTheNameBtn.constant = 21
                    cell.hightForTheRatingView.constant = 23
                    cell.widthForTheuiImageView.constant = 60
                    
                    
                    return cell
                    
                    
                }
                
            }
            
            
            
            
            
            
            
            
            
            
            
     /*******************************************Commented by yasodha**********************************************/
            

//                if tableViewDataSource.count > 0 {
//
//
//                    dict = self.tableViewDataSource[indexPath.row]
//                    /* Thumbnail related image Added By Ranjeet - From Here */
//                    let stringUrl = dict["ProfileUrl"].stringValue
//                    let thumbnail = stringUrl.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
//                    cell.uiImageView?.sd_setImage(with: URL.init(string:thumbnail ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
//                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTappedMethod(_:)))
//                    cell.uiImageView.isUserInteractionEnabled = true
//                    cell.uiImageView.tag = indexPath.row
//                    cell.uiImageView.addGestureRecognizer(tapGestureRecognizer)
//                    cell.createdByNameLabel.text = dict["CreatedBy"].stringValue
//                    cell.titleNameLabel.text = dict["TestTitle"].stringValue
//                    cell.topicSubtopicValueLabel.text = "\(dict["SubjectName"].stringValue) | \(dict["SubTopicName"].stringValue)"
//                    cell.noOFQuesBtn.setTitle(dict["NoQuestions"].stringValue == "" ? "0" : dict["NoQuestions"].stringValue, for: .normal)
//                    cell.timeBtn.setTitle(dict["Duration"].stringValue, for: .normal)
//                    cell.applicableBtn.setTitle(dict["ExpiryDate"].stringValue, for: .normal)
//                        if personType != "1"{
//                        cell.ratingView.isHidden = true
//                        cell.hightForTheRatingView.constant = 0
//                        cell.hightForTheNameBtn.constant = 0
//                        cell.widthForTheuiImageView.constant = 0
//                    }else{
//                        if activeTabIndex == 0{
//                            cell.ratingView.isHidden = false
//                            cell.ratingView.rating = dict["Rating"].intValue == 0 ? 2.5 : Double(dict["Rating"].intValue)/* Updated By Veeresh on 3rd April 2020 */
//                            cell.hightForTheNameBtn.constant = 21
//                            cell.hightForTheRatingView.constant = 23
//                            cell.widthForTheuiImageView.constant = 60
//                        }else if activeTabIndex == 1{
//                            cell.ratingView.isHidden = false
//                             cell.ratingView.rating = dict["Rating"].intValue == 0 ? 2.5 : Double(dict["Rating"].intValue)/* Updated By Veeresh on 3rd April 2020 */
//                            cell.hightForTheNameBtn.constant = 21
//                            cell.hightForTheRatingView.constant = 23
//                            cell.widthForTheuiImageView.constant = 60
//                        }
//                    }
//                    if dict["SharedType"].stringValue == "1" {
//                        cell.testModeBtn.isSelected = false
//                    }else {
//                        cell.testModeBtn.isSelected = true
//                    }
//
//                    if personType != "1"{
//                        cell.testTakenBtn.isUserInteractionEnabled = true
//                        cell.testTakenBtn.setImage(UIImage.init(named: "Asset 12"), for: .normal)/*add by chandra on 13 dec*/
//                        cell.testTakenBtn.isHidden = false/*add by chandra on 13 dec*/
//                        cell.testTakenBtn.setTitle("Delete", for: .normal)
//                        cell.testTakenBtn.isSelected = false
//                        cell.testStartBTn.setTitleColor(UIColor.init(hex: "00994c"), for: .normal)/*add by chandra on 13 dec*/
//
//                        cell.testStartBTn.setTitle("Edit", for: .normal)
//                        cell.testStartBTn.setImage(UIImage.init(named: "edit-1"), for: .normal)/*add by chandra on 13 dec*/
//                        cell.testStartBTn.backgroundColor = .clear
//                        cell.testStartBTn.layer.cornerRadius = (cell.testStartBTn.frame.height / 2)
//                        cell.testStartBTn.layer.borderWidth = 0
//                        cell.testStartBTn.layer.borderColor = UIColor.init(hex: "FFD700").cgColor
//                    }else{
//                        cell.testTakenBtn.isUserInteractionEnabled = false
//                        if dict["IsTaken"].intValue == 0 && activeTabIndex == 1 {
//                            cell.testStartBTn.setImage(UIImage.init(named: ""), for: .normal)/*add by chandra on 13 dec*/
//                            cell.testTakenBtn.isHidden = true/*add by chandra on 13 dec*/
//                            cell.testTakenBtn.setTitle("Not yet Taken", for: .normal)
//                            cell.testTakenBtn.isSelected = false
//                            cell.testStartBTn.setTitleColor(.orange, for: .normal)/*add by chandra on 13 dec*/
//                            cell.testStartBTn.setTitle("Start Test", for: .normal)
//                            setborderForBtn(btn: cell.testStartBTn)/*add by chandra on 13 dec*/
//                        }else if activeTabIndex == 0 && activeTabIndex != 1{
//                            cell.testStartBTn.setImage(UIImage.init(named: ""), for: .normal)/*add by chandra on 13 dec*/
//                            cell.testTakenBtn.isHidden = true/*add by chandra on 13 dec*/
//                            cell.testTakenBtn.setTitle("Taken", for: .normal)
//                            cell.testTakenBtn.isSelected = true
//                            cell.testStartBTn.setTitleColor(.orange, for: .normal)/*add by chandra on 13 dec*/
//                            setborderForBtn(btn: cell.testStartBTn)/*add by chandra on 13 dec*/
//                            cell.testStartBTn.setTitle("Review Answers", for: .normal)
//                            cell.testStartBTn.setImage(UIImage.init(named: ""), for: .normal)
//                        }
//                    }
//                    let noAttendees = dict["NoAttendees"].intValue
//                    if dict["UserID"].string == userId && noAttendees > 0 {
//                        cell.reviewTestBTn.isHidden = false
//                        cell.reviewTestBTn.setTitle(" \(noAttendees) Attended ", for: .normal)
//                    }else {
//                        cell.reviewTestBTn.isHidden = true
//                        cell.reviewTestBTn.setTitle(" \(noAttendees) Attended ", for: .normal)
//
//                    }
//
//                    cell.reviewTestBTn.tag = indexPath.row
//                    cell.reviewTestBTn.addTarget(self, action: #selector(onReviewTestBtnClick), for: .touchUpInside)
//
//                    cell.testTakenBtn.tag = indexPath.row
//                    cell.testTakenBtn.addTarget(self, action: #selector(onDeleteTestBtnClick), for: .touchUpInside)
//
//                    cell.testStartBTn.tag = indexPath.row
//                    cell.testStartBTn.addTarget(self, action: #selector(onTestStartReviewBtnClick), for: .touchUpInside)
//                }
//
//
        }//else
                    
        tableView.rowHeight = 0
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.navigationController?.viewControllers.previous is PersonalProfileVC {
            if personType == "1"{
                return 280
            }
            else{
                return 250
            }
            
            // return 250
            
        }else{
            if personType == "1"{
                return 286
            }
            else{
                return 230
            }
            
        }
    }
    
    
    // add by chandra for scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        activityIndicator?.didScroll()
        print("activityIndicator")
        
    }
}
//add by chandra for scrolling the tableview
extension MyTestVC: LoadMoreControlDelegate {
    func loadMoreControl(didStartAnimating loadMoreControl: LoadMoreControl) {
        print("didStartAnimating")
        /*Added by yasodha on 28/1/2020 starts here */
        if self.navigationController?.viewControllers.previous is PersonalProfileVC {}
        else{
             /*Added by yasodha on 28/1/2020 ends here */
            if personType != "1"{
                if activeTabIndex == 0{
                    tablePageIndex0 = (tablePageIndex0 + noOfItemsInaPage)
                }
            }else{
                if activeTabIndex == 0{
                    tablePageIndex1 = (tablePageIndex1 + noOfItemsInaPage)
                }else if activeTabIndex == 1{
                    tablePageIndex2 = (tablePageIndex2 + noOfItemsInaPage)
                }
            }
            hitApiForMyTest()
        }//else
    }
    
    func loadMoreControl(didStopAnimating loadMoreControl: LoadMoreControl) {
        print("didStopAnimating")
    }
}

