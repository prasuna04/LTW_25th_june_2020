/* Freshly Integrated Chandra Build On 8th  Jan 2019 starts  here  */

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import SwiftMessages
import NVActivityIndicatorView
class MyGroupsVC: UIViewController,NVActivityIndicatorViewable,UISearchBarDelegate,vm {
     var callbackdata:Int!
    // add by chandra for auto referh on 6th_april_2020 start here to
    func ststus(reviewans: Int) {
        print(reviewans)
        activeTabIndex = 0
        notificationInt = 0
        autoUpdate = reviewans
    }
      // add by chandra for auto referh on 6th_april_2020 ends here to
      var autoUpdate:Int!      // add by chandra for auto referh on 6th_april_2020
      var subscribeCount:Int!  // add by chandra for newly edit
      var notificationInt:Int!
      var encoded:String?
      var endPointUrl:String!
      var buttonBar:UIView!
      var segmentedControl = UISegmentedControl()
      var activeTabIndex = 2
      let subjects = UserDefaults.standard.array(forKey: "subjectArray") as! [String]
      var search : Bool?
      private static let publicGroupMode = "Public" // added By Chandra on 3rd Dec 2019
      @IBOutlet weak var textFieldSearch: UITextField!
      let loguserId = UserDefaults.standard.string(forKey: "userID")
      @IBOutlet weak var scroLlVw: UIScrollView!
      @IBOutlet weak var contentVwforMyGrPs: UIView!
      @IBOutlet weak var viewContnedToGleAndCretNewGrpBtn: UIView!
      @IBOutlet weak var creaTeNewGrupDiscsnBtn: UIButton!{
          didSet {
              creaTeNewGrupDiscsnBtn.layer.shadowColor = UIColor.gray.cgColor
              creaTeNewGrupDiscsnBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
              creaTeNewGrupDiscsnBtn.layer.shadowRadius = 5
              creaTeNewGrupDiscsnBtn.layer.shadowOpacity = 1.0
              creaTeNewGrupDiscsnBtn.layer.cornerRadius = creaTeNewGrupDiscsnBtn.frame.height / 2
          }
      }
       @IBOutlet var createGrupsPan: UIPanGestureRecognizer! // Added By Ranjeet
      @IBOutlet weak var taBleView: UITableView!
      var myGrupsList: Array<JSON> = []
      var myTableViewDataArray: Array<JSON> = []

    //  var refreshControl = UIRefreshControl() // pull to refresh /* Commented By Ranjeet on 3rd Jan 2020 */
      var userID: String!
      var sharedType1 = 1// For Public Group
      var sharedType2 = 2 // For Private Group
      var createdBy: String!
      var discussionID: String!
      var subjectId: Int!
      var sub_subjectId: Int!
      var deletedIndexPath: IndexPath?
    // add by chandra for scrolling
      private var tablePageIndex0 = 1
      private var tablePageIndex1 = 1
      private var tablePageIndex2 = 1
      private var noOfItemsInaPage = 5
      private var presentSegmentIndex = 0
   // private var isDataOver : Bool = false
    
      var activityIndicator: LoadMoreControl?
    
    //Added by Deepak on 19th March 2020.
    lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(MyGroupsVC.handleRefresh(_:)),for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
        activityIndicator = LoadMoreControl(scrollView: taBleView, spacingFromLastCell: 20, indicatorHeight: 60)
        activityIndicator?.delegate = self
        self.taBleView.rowHeight = UITableView.automaticDimension
        self.taBleView.estimatedRowHeight = 108.0
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
            NSAttributedString(string: " Search by Group Name/Grades", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        taBleView.delegate = self
        taBleView.dataSource = self
        userID = UserDefaults.standard.string(forKey: "userID")
        myGrupsList.removeAll()
        

        /* Commented By Ranjeet on 3rd Jan 2020  - start here */
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refreshControl.addTarget(self, action: #selector(MyGroupsVC.hitApiForPullToRefresh),for: .valueChanged)
//        taBleView.addSubview(refreshControl)
        /* Commented By Ranjeet on 3rd Jan 2020 - ends here*/
        taBleView.reloadData()
//        activityIndicator = LoadMoreControl(scrollView: taBleView, spacingFromLastCell: 10, indicatorHeight: 60)
//        activityIndicator.delegate = self
        if activeTabIndex == 2{
            segmentupUIControl()
            hitApiForPullToRefresh()
        }else if notificationInt == 2{
            activeTabIndex = 2
            segmentupUIControl()
            hitApiForPullToRefresh()
        }
        //Added By Deepak Kumar on 19th March 2020. STARTS HERE
        let swipeLeft = UISwipeGestureRecognizer(target : self, action : #selector(self.swipeGesture))
            swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
           
            let swipeRight = UISwipeGestureRecognizer(target : self, action : #selector(self.swipeGesture))
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
           
            taBleView.addGestureRecognizer(swipeLeft)
            taBleView.addGestureRecognizer(swipeRight)
        
           self.taBleView.addSubview(self.refreshControl)
        //Added By Deepak Kumar on 19th March 2020. ENDS HERE.
    }
    
    //Added By Deepak Kumar on 19th March 2020.
    @objc func swipeGesture(_ sender : UISwipeGestureRecognizer?) {
       if let swipeGesture = sender {
           switch swipeGesture.direction {
           case UISwipeGestureRecognizer.Direction.right :
               print("DK Swiped Right")
               if segmentedControl.selectedSegmentIndex == 2 {
                    segmentedControl.selectedSegmentIndex = 1
                    activeTabIndex = segmentedControl.selectedSegmentIndex
                    hitApiForPullToRefresh()
                    UIView.animate(withDuration: 0.3) {[unowned self] in
                        self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) *     CGFloat(self.segmentedControl.selectedSegmentIndex)
                    }
               }
                else if segmentedControl.selectedSegmentIndex == 1 {
                    segmentedControl.selectedSegmentIndex = 0
                    activeTabIndex = segmentedControl.selectedSegmentIndex
                    hitApiForPullToRefresh()
                    UIView.animate(withDuration: 0.3) {[unowned self] in
                        self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) *     CGFloat(self.segmentedControl.selectedSegmentIndex)
                    }
                    
                }
               
           case UISwipeGestureRecognizer.Direction.left :
               print("DK Swiped Left")
               if segmentedControl.selectedSegmentIndex == 0 {
                    segmentedControl.selectedSegmentIndex = 1
                    activeTabIndex = segmentedControl.selectedSegmentIndex
                    hitApiForPullToRefresh()
                    UIView.animate(withDuration: 0.3) {[unowned self] in
                        self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) *     CGFloat(self.segmentedControl.selectedSegmentIndex)
                    }
               }
                else if segmentedControl.selectedSegmentIndex == 1 {
                    segmentedControl.selectedSegmentIndex = 2
                    activeTabIndex = segmentedControl.selectedSegmentIndex
                    hitApiForPullToRefresh()
                    UIView.animate(withDuration: 0.3) {[unowned self] in
                        self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) *     CGFloat(self.segmentedControl.selectedSegmentIndex)
                    }
                    
                }
           default:
               break
           }
       }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
       
        hitApiForPullToRefresh()
        refreshControl.endRefreshing()
    }
    //Added by Deepak on 19th March 2020, ends here.!
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // add by chandra for auto referh on 11th_may_2020
        if self.callbackdata == 2{
            if self.segmentedControl.selectedSegmentIndex == 2 {
                self.segmentedControl.selectedSegmentIndex = 1
                self.activeTabIndex = self.segmentedControl.selectedSegmentIndex
                self.hitApiForPullToRefresh()
                UIView.animate(withDuration: 0.3) {[unowned self] in
                    self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
                }
            }
            
        }
        // add by chandra for auto referh on 11th_may_2020
//     add by chandra for auto referh on 6th_april_2020
        if autoUpdate == 1{
            myGrupsList.removeAll()
            taBleView.reloadData()
            tablePageIndex0 = 1
            activeTabIndex = 0
            if activeTabIndex == 0{
                segmentupUIControl()
                hitApiForPullToRefresh()
                       }
            autoUpdate = 0
        }
        
//        add by chandra for auto referh on 6th_april_2020
        // add by chandra for info start here to
        if self.navigationController?.viewControllers.previous is GroupInfoViewController {
            activeTabIndex = 1
            segmentedControl.selectedSegmentIndex = 1
            if #available(iOS 13.0, *) {
                //segmentedControl.selectedSegmentTintColor = .orange  // commented by chandra for remove the orange colour
            } else {
                // Fallback on earlier versions
            }
            hitApiForPullToRefresh()
        }
        // add by chandra for info start here to
        
//        taBleView.reloadData() // add by chandra sekhar
        guard let navigationController = navigationController else { return }
        navigationController.view.backgroundColor = UIColor.init(hex:"2DA9EC")
        if (self.navigationController?.navigationBar) != nil {
            navigationController.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        }
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Groups"
//        commented by chandra if tap on the in info btn it will go the info form and we came to the my group show the same previous form in my group
//        activeTabIndex = 0
//         segmentupUIControl()
//        hitApiForPullToRefresh()
//        if activeTabIndex == 0{
//            segmentupUIControl()
//            hitApiForPullToRefresh()
//        }else if notificationInt == 2{
//            activeTabIndex = 2
//            segmentupUIControl()
//            hitApiForPullToRefresh()
//        }
        taBleView.reloadData()
    }
    private func segmentupUIControl(){
        // Container view
        let view = UIView(frame: CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width, height: 45))
        view.backgroundColor = UIColor.init(hex:"2DA9EC")
        
        segmentedControl = UISegmentedControl()
        // Add segments
        segmentedControl.insertSegment(withTitle: "MY GROUPS", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "SUBSCRIBED GROUPS", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "AVAILABLE GROUPS", at: 2, animated: true)
        // First segment is selected by default
        // add by chandra for notification start here
                if notificationInt == 2{
                   segmentedControl.selectedSegmentIndex = 2
                }else if activeTabIndex == 2{
                    segmentedControl.selectedSegmentIndex = 2
                    notificationInt = 2
                }else{
                    activeTabIndex = 0
                    segmentedControl.selectedSegmentIndex = 0
        }
                 // add by chandra for notification ends here

      //  segmentedControl.selectedSegmentIndex = 0
        presentSegmentIndex =  0
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
        }else if activeTabIndex == 0{
            /*Added by chandra 15/5/2020 starts here */
                                     self.buttonBar.frame.origin.x = (UIScreen.main.bounds.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
                                     self.buttonBar.frame.origin.y = 40
                                     self.buttonBar.frame.size.width = (UIScreen.main.bounds.width / CGFloat(self.segmentedControl.numberOfSegments))
                                     self.buttonBar.frame.size.height = 5
                               /*Added by chandra 15/5/2020 ends here */
            // Constrain the top of the button bar to the bottom of the segmented control
//                   buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
//                   buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
//                   // Constrain the button bar to the left side of the segmented control
//                   buttonBar.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor).isActive = true
//                   // Constrain the button bar to the width of the segmented control divided by the number of segments
//                   buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
        }
//        // Constrain the top of the button bar to the bottom of the segmented control
//        buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
//        buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
//        // Constrain the button bar to the left side of the segmented control
//        buttonBar.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor).isActive = true
//        // Constrain the button bar to the width of the segmented control divided by the number of segments
//        buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
//
        self.view.addSubview(view)
    }
    

    @IBAction func onCreateNewGrUpDscsnClk(_ sender: UIButton){
        let createnewgrupdscsn = storyboard?.instantiateViewController(withIdentifier: "createnewgrupdscsn") as! CreateNewGrupDscsnVC
        createnewgrupdscsn.delegate = self // add by chandra for auto refresh on 6th_april_2020
        navigationController?.pushViewController(createnewgrupdscsn, animated: true)
    }
    @IBAction func OnSearchClickBtn(sender:UIButton) {
//        searchBar.resignFirstResponder()
//        searchBar.text = nil
                search = true
                textFieldSearch.resignFirstResponder() // hides the keyboard.
                let searchText = textFieldSearch.text
                if searchText?.count == 0{
                    encoded = "".addingPercentEncoding(withAllowedCharacters: .alphanumerics)
                }else{
                    encoded = searchText!.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
                }
                encoded = searchText!.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
                if activeTabIndex == 0{
                    tablePageIndex0  = 1 // add by chandra
                    endPointUrl = Endpoints.myGroupsList + loguserId! + "/\(tablePageIndex0)" + "/\(noOfItemsInaPage)?searchtext=" + "\(encoded ?? "")"
                    hitServer(params: [:], endPoint: endPointUrl, action: "MY GROUP", httpMethod: .get)
                    
                }else if activeTabIndex == 1{
                     tablePageIndex1  = 1
                   endPointUrl = Endpoints.subscribedGroup + loguserId! + "/\(tablePageIndex1)" + "/\(noOfItemsInaPage)?searchtext=" + "\(encoded ?? "")"
                    hitServer(params: [:], endPoint: endPointUrl, action: "SUBSCRIBED GROUP", httpMethod: .get)
                    
                }else if activeTabIndex == 2{
                     tablePageIndex2  = 1
                    endPointUrl = Endpoints.availableGroup + loguserId! + "/\(tablePageIndex2)" + "/\(noOfItemsInaPage)?searchtext=" + "\(encoded ?? "")"
                    hitServer(params: [:], endPoint: endPointUrl, action: "AVAILABLE GROUP", httpMethod: .get)
                }
    }
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
       
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.3) {[unowned self] in
            self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
            
        }
        print("Selected segment index = \(self.segmentedControl.selectedSegmentIndex)")
        //classTableView.setContentOffset(.zero, animated: true)
        
        activeTabIndex = self.segmentedControl.selectedSegmentIndex
        encoded = ""
//        searchBar.text = nil
        if activeTabIndex == 0{
           
            if(presentSegmentIndex != 0){
            
             //   isDataOver = false
            presentSegmentIndex = 0
            tablePageIndex0 = 1
            }
            myGrupsList.removeAll()
            taBleView.reloadData()
           endPointUrl = Endpoints.myGroupsList + loguserId! + "/\(tablePageIndex0)" + "/\(noOfItemsInaPage)?searchtext=" + "\(encoded ?? "")"
            
            hitServer(params: [:], endPoint: endPointUrl, action: "MY GROUP", httpMethod: .get)
            
        }else if activeTabIndex == 1{
            myGrupsList.removeAll()
            taBleView.reloadData()
            if(presentSegmentIndex != 1){
            
                //isDataOver = false
                presentSegmentIndex = 1
            tablePageIndex1 = 1
            }
           endPointUrl = Endpoints.subscribedGroup + loguserId! + "/\(tablePageIndex1)" + "/\(noOfItemsInaPage)?searchtext=" + "\(encoded ?? "")"
            hitServer(params: [:], endPoint: endPointUrl, action: "SUBSCRIBED GROUP", httpMethod: .get)
            
        }else if activeTabIndex == 2{
            myGrupsList.removeAll()
            taBleView.reloadData()
            if(presentSegmentIndex != 2){
           
            //isDataOver = false
           presentSegmentIndex = 2
           tablePageIndex2 = 1
           }
            endPointUrl = Endpoints.availableGroup + loguserId! + "/\(tablePageIndex2)" + "/\(noOfItemsInaPage)?searchtext=" + "\(encoded ?? "")"
            hitServer(params: [:], endPoint: endPointUrl, action: "AVAILABLE GROUP", httpMethod: .get)
        }
    }
    @objc func deleteBtnSelected(sender: UIButton){
//        sender.springAnimation(btn: sender)// add by chandra for spring animation to the button
        let refreshAlert = UIAlertController(title: "Delete", message: "Are you sure that you want to Delete this Group?", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Delete Button Clicked")
            let index = sender.tag
            self.discussionID = self.myGrupsList[index]["DiscussionID"].stringValue
            self.deletedIndexPath = IndexPath(item: sender.tag, section: 0)
            let isIndexValid = self.myGrupsList.indices.contains(self.deletedIndexPath!.row)
            if self.currentReachabilityStatus != .notReachable {
                if isIndexValid{
                    self.hitServerForDeleteGroup(params: [:], endPoint: Endpoints.deleteGrupBtnEndPoint + (self.discussionID!) + "/" + (self.userID!) ,action: "deleteGroup", httpMethod: .get)
                }
            } else {
                showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
                })
            }
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)
        
    }
        @objc func editBtnSelected(sender: UIButton){
//            sender.springAnimation(btn: sender)// add by chandra for spring animation to the button
            // showMessage(bodyText: "Work in Progress",theme: .success,presentationStyle: .center, duration: .seconds(seconds: 1))
            let indexPath = IndexPath.init(row: 0, section: 0)// add by chandra new 22 may
            let cell = taBleView.cellForRow(at: indexPath) as! MyGroupsCell// add by chandra new 22 may
            cell.isUserInteractionEnabled = false// add by chandra new 22 may
            sender.isUserInteractionEnabled = false// add by chandra new 22 may
            sender.isMultipleTouchEnabled = false // add by chandra new 22 may
            let indexOfEdit = myGrupsList[sender.tag]
            let DiscussionID = indexOfEdit["DiscussionID"].stringValue
            subscribeCount = indexOfEdit["NoSubscribers"].intValue // add by chandra
            let editurl = Endpoints.groupInfo + "\(DiscussionID)/\(loguserId!)"
            Alamofire.request(editurl , method: .get, parameters: nil , encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response)
                    DispatchQueue.main.async{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "createnewgrupdscsn") as! CreateNewGrupDscsnVC
                        let swiftyJsonVar = JSON(response.result.value!)
                        let data = swiftyJsonVar["ControlsData"]["groupInfo"]
                        let catagery1 = data["SubjectID"].intValue
                        vc.catgery = self.subjects[catagery1-1]
                        let subcatagery1 = data["Sub_SubjectID"].intValue
                        let subSubjectName = getSubjectName(with: subcatagery1)
                        // cell.topicSubTopic.text = "\(self.subjects[catagery-1]) /\(subSubjectName ?? "")"
                        vc.subcategery = subSubjectName
                        vc.stringUrl = data["TopicUrl"].stringValue
                        vc.groupName = data["Title"].stringValue
                        vc.emailids = data["Emailids"].stringValue
                        // let simple = vc.emailids?.split(separator: ";")
                        // print(simple!)
                         vc.NoSubscribers = self.subscribeCount
                        if data["SharedType"].intValue == 2{
                            let Seperated = vc.emailids?.split(separator: ";").map { String($0) }
                            vc.Oldemailids = Seperated
                        }else{
                           vc.Oldemailids = [""]
                        }
//                        let Seperated = vc.emailids?.split(separator: ";").map { String($0) }
//                        vc.Oldemailids = Seperated // commented by chandra
                        vc.DiscussionID1 = data["DiscussionID"].stringValue
                        vc.Description = data["Description"].stringValue
                        vc.SharedType1 = data["SharedType"].intValue
                         vc.EditGroup = "Group Edit"
                        vc.EditGroup = "Group Edit"
                        vc.oldGrades = data["Grades"].stringValue
                        vc.editType1 = 1
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
            }
        }
    @objc func groupInfo(sender: UIButton){
//        sender.springAnimation(btn: sender)// add by chandra for spring animation to the button
            if self.activeTabIndex == 2{
                       print("Group info tapped")
                let index = self.myGrupsList[sender.tag]
                       let DiscussionID = index["DiscussionID"].stringValue
                       let SharedType = index["SharedType"].intValue
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupInfoViewController") as! GroupInfoViewController
                       vc.discussionid = DiscussionID
                vc.userid = self.userID
                       vc.sharedtype = SharedType
                       vc.prasentIndex = 2
                       vc.imgeurl = index["TopicUrl"].stringValue
                       vc.title = "Group Info"
                vc.callback = { text in
                    print(text)
                    self.callbackdata = text
                }
                       self.navigationController?.pushViewController(vc, animated: true)
                   }else{
                       print("Group info tapped")
                let index = self.myGrupsList[sender.tag]
                       let DiscussionID = index["DiscussionID"].stringValue
                       let SharedType = index["SharedType"].intValue
                       // api/GroupInfoWithListOfUser/{DiscussionID}/{UserID}/{SharedType}
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupInfoViewController") as! GroupInfoViewController
                       vc.discussionid = DiscussionID
                vc.userid = self.userID
                       vc.sharedtype = SharedType
                       vc.imgeurl = index["TopicUrl"].stringValue
                       vc.title = "Group Info"
                       self.navigationController?.pushViewController(vc, animated: true)
                   }
        
        
    }
    @objc func hitApiForPullToRefresh() {
//        refreshControl.endRefreshing()
      if activeTabIndex == 0{
          myGrupsList.removeAll()
        // add by deapak on 19 mar 2020
        taBleView.reloadData()
        tablePageIndex0 = 1
         endPointUrl = Endpoints.myGroupsList + loguserId! + "/\(tablePageIndex0)" + "/\(noOfItemsInaPage)?searchtext=" + "\(encoded ?? "")"
          hitServer(params: [:], endPoint: endPointUrl, action: "MY GROUP", httpMethod: .get)
          
      }else if activeTabIndex == 1{
          myGrupsList.removeAll()
        // add by deapak on 19 mar 2020
               taBleView.reloadData()
         tablePageIndex1  = 1 // add by chandra
         endPointUrl = Endpoints.subscribedGroup + loguserId! + "/\(tablePageIndex1)" + "/\(noOfItemsInaPage)?searchtext=" + "\(encoded ?? "")"
          hitServer(params: [:], endPoint: endPointUrl, action: "SUBSCRIBED GROUP", httpMethod: .get)
          
      }else if activeTabIndex == 2{
          myGrupsList.removeAll()
        // add by deapak on 19 mar 2020
               taBleView.reloadData()
         tablePageIndex2  = 1 // add by chandra
          endPointUrl = Endpoints.availableGroup + loguserId! + "/\(tablePageIndex2)" + "/\(noOfItemsInaPage)?searchtext=" + "\(encoded ?? "")"
          hitServer(params: [:], endPoint: endPointUrl, action: "AVAILABLE GROUP", httpMethod: .get)
          
      }
    }
    @objc func exitgroup(sender: UIButton){
        if activeTabIndex == 1{
//            let index = myGrupsList[sender.tag]
//            let DiscussionID = index["DiscussionID"].stringValue
//            print("exitgroup button is selected")
//            let exiturl = Endpoints.exitPublicGroup + "\(DiscussionID )/\(loguserId ?? "")"
//
//            Alamofire.request(exiturl , method: .get, parameters: nil , encoding: JSONEncoding.default)
//                .responseJSON { response in
//                    print(response)
////                    self.myGrupsList.remove(at: sender.tag)
//                    if self.myGrupsList.count != 0{
//                        self.myGrupsList.remove(at: sender.tag)
//                    }else{
//
//                    }
//                    DispatchQueue.main.async{
//                    self.taBleView.reloadData() //change the chandra
////                     self.hitApiForMyGroups() // uncommented by chandra
////                    self.hitApiForPullToRefresh()
//
//                    }
            
                        if self.myGrupsList.count != 0{
                            let index = self.myGrupsList[sender.tag]
                            let DiscussionID = index["DiscussionID"].stringValue
            //               onUnsubscribeButton(index: sender.tag, discussionId: DiscussionID)
                            print("exitgroup button is selected")
                            let exiturl = Endpoints.exitPublicGroup + "\(DiscussionID )/\(self.loguserId ?? "")"
                            Alamofire.request(exiturl , method: .get, parameters: nil , encoding: JSONEncoding.default)
                                .responseJSON { response in
                                    print(response)
                                     showMessage(bodyText: "Group Unsubscribed",theme: .success)
                                    if self.myGrupsList.count != 0{
                                        //   self.myGrupsList.remove(at: sender.tag)
                                        self.myGrupsList.removeAll()
                                        self.hitApiForPullToRefresh()
                                    }else{

                                    }
                            }
                        }
            
            
            
        }else if activeTabIndex == 2{
            let dict = myGrupsList[sender.tag]
            let DiscussionID = "\(dict["DiscussionID"].string ?? "")"
            let userId = UserDefaults.standard.string(forKey: "userID")
            let url1 = Endpoints.publicGroupJoin + "\(DiscussionID )/\(userId ?? "")"
            print(url1)
            startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
            Alamofire.request(url1 , method: .get, parameters: nil , encoding: JSONEncoding.default)
                .responseJSON { response in
                    self.stopAnimating()
//                    let createnewgrupdscsn = self.storyboard?.instantiateViewController(withIdentifier: "mygroup") as! MyGroupsVC
//                    self.navigationController?.pushViewController(createnewgrupdscsn, animated: true)
                    let swiftyJsonVar = JSON(response.result.value!)
                    let msg = swiftyJsonVar["message"].stringValue
                    print(msg)
                    print(response)
                    self.myGrupsList.remove(at: sender.tag)
                    DispatchQueue.main.async{
//                        self.hitApiForPullToRefresh()
                        self.taBleView.reloadData()
                        if self.segmentedControl.selectedSegmentIndex == 2 {
                            self.segmentedControl.selectedSegmentIndex = 1
                            self.activeTabIndex = self.segmentedControl.selectedSegmentIndex
                            self.hitApiForPullToRefresh()
                                           UIView.animate(withDuration: 0.3) {[unowned self] in
                                               self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) *     CGFloat(self.segmentedControl.selectedSegmentIndex)
                                           }
                                      }
                    }
            }
        }
    }
    @objc func DiscussionVC(sender: UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "discussion") as! DiscussionVC
        let dict = myGrupsList[sender.tag]
        vc.groupId = dict["DiscussionID"].stringValue
        vc.naviTitle = dict["Title"].stringValue
        navigationController?.pushViewController(vc, animated: true)
    }
    
//    @available(iOS 13.0, *)
    @objc func cellTappedMethod(_ sender:AnyObject){
        if activeTabIndex == 2{
            print("Group info tapped")
           let index = myGrupsList[sender.view.tag]
            let DiscussionID = index["DiscussionID"].stringValue
            let SharedType = index["SharedType"].intValue
            // api/GroupInfoWithListOfUser/{DiscussionID}/{UserID}/{SharedType}
            let vc = storyboard?.instantiateViewController(withIdentifier: "GroupInfoViewController") as! GroupInfoViewController
            vc.discussionid = DiscussionID
            vc.userid = userID
            vc.sharedtype = SharedType
            vc.prasentIndex = 2
            vc.imgeurl = index["TopicUrl"].stringValue
            vc.title = "Group Info"
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            print("Group info tapped")
            let index = myGrupsList[sender.view.tag]
            let DiscussionID = index["DiscussionID"].stringValue
            let SharedType = index["SharedType"].intValue
            // api/GroupInfoWithListOfUser/{DiscussionID}/{UserID}/{SharedType}
            let vc = storyboard?.instantiateViewController(withIdentifier: "GroupInfoViewController") as! GroupInfoViewController
            vc.discussionid = DiscussionID
            vc.userid = userID
            vc.imgeurl = index["TopicUrl"].stringValue
            vc.sharedtype = SharedType
            vc.title = "Group Info"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func hitApiForMyGroups() {
        if activeTabIndex == 0{
        //            myGrupsList.removeAll()
                    endPointUrl = Endpoints.myGroupsList + loguserId! + "/\(tablePageIndex0)" + "/\(noOfItemsInaPage)?searchtext=" + "\(encoded ?? "")"
                    
                    hitServer(params: [:], endPoint: endPointUrl, action: "MY GROUP", httpMethod: .get)
                    
                }else if activeTabIndex == 1{
               endPointUrl = Endpoints.subscribedGroup + loguserId! + "/\(tablePageIndex1)" + "/\(noOfItemsInaPage)?searchtext=" + "\(encoded ?? "")"
                    hitServer(params: [:], endPoint: endPointUrl, action: "SUBSCRIBED GROUP", httpMethod: .get)
                    
                }else if activeTabIndex == 2{
        //            myGrupsList.removeAll()
                   endPointUrl = Endpoints.availableGroup + loguserId! + "/\(tablePageIndex2)" + "/\(noOfItemsInaPage)?searchtext=" + "\(encoded ?? "")"
                    hitServer(params: [:], endPoint: endPointUrl, action: "AVAILABLE GROUP", httpMethod: .get)
                    
                }
    }
    
}
extension MyGroupsVC {
private func hitServer(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
     /* added by veeresh on 19/2/2020 */
    //startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))   // commeted by veeresh on 19/2/2020
    /* added by veeresh on 19/2/2020 shimmering - starts here  */
    segmentedControl.isUserInteractionEnabled = false // add by chandra newly
    var shim = UIImageView()
    switch UIDevice.current.userInterfaceIdiom {
    case .phone: shim = UIImageView(image: UIImage(named: "my-group-mobile")!) ; shim.contentMode = .topLeft
    case .pad: shim = UIImageView(image: UIImage(named: "my-group-ipad")!) ; shim.contentMode = .scaleToFill
    case .unspecified: shim = UIImageView(image: UIImage(named: "my-group-mobile")!)
    case .tv: shim = UIImageView(image: UIImage(named: "my-group-ipad")!) ; shim.contentMode = .topLeft
    case .carPlay: shim = UIImageView(image: UIImage(named: "my-group-mobile")!)
    }//scaleAspectFill
    if myGrupsList.count < 1 {   /* added by veeresh on 26/2/2020 */
        taBleView.backgroundView = shim  /* added by veeresh on 26/2/2020 */
    shim.startShimmering()  /* added by veeresh on 26/2/2020 */
    }
    /* added by veeresh on 19/2/2020 - ends here */
    LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){ [weak self] result in
        guard let _self = self else {
            return
        }
         /* added by veeresh on 19/2/2020 */
       self!.taBleView.backgroundView = UIView()
        shim.stopShimmering()
        shim.removeFromSuperview()
         /* added by veeresh on 19/2/2020 */
      //  _self.stopAnimating()  // commeted by veeresh on 19/2/2020
        _self.activityIndicator!.stop()
        
        switch result {
        case let .success(json,requestType):
            _self.segmentedControl.isUserInteractionEnabled = true
            let msg = json["message"].stringValue
            if json["error"].intValue == 1 {
                showMessage(bodyText: msg,theme: .error)
            }
            else {
                let jsondata = json["ControlsData"]["lsv_group"]
                print(jsondata)
                if jsondata.count == 0{
//                    showMessage(bodyText: "No more data available",theme:.warning,presentationStyle:.center,duration:.seconds(seconds: 0.2) )
                    self?.parseNDispayListData(json: json["ControlsData"]["lsv_group"], requestType: requestType)
                    return
                }else{
                    _self.parseNDispayListData(json: json["ControlsData"]["lsv_group"], requestType: requestType)
                }
            }
            break
        case .failure(let error):
            print("MyError = \(error)")
            break
        }
    }
}
    private func hitServerForDeleteGroup(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){ [weak self] result in
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
                    _self.myGrupsList.remove(at: _self.deletedIndexPath!.row)
                    _self.taBleView.reloadData()
                    showMessage(bodyText: "Successfully Deleted",theme: .success,presentationStyle: .center, duration: .seconds(seconds: 1))
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
 private func parseNDispayListData(json: JSON,requestType: String){
    
//    self.myGrupsList.removeAll()
//    if(json.count < noOfItemsInaPage)
//    {
//        isDataOver = true
//    }
    
        //myGrupsList.append(contentsOf: json.arrayValue)
//    print(myGrupsList)
    if search == true{
            myGrupsList.removeAll()
            myGrupsList.append(contentsOf: json.arrayValue)
        if myGrupsList.count == 0{
             showMessage(bodyText: "Not Available",theme: .warning)
        }
            search = false
            
        }else{
             myGrupsList.append(contentsOf: json.arrayValue)
        }


        DispatchQueue.main.async {
        self.taBleView.reloadData()
        }
    }
}
extension MyGroupsVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGrupsList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! MyGroupsCell
            var groupList: JSON
         cell.isUserInteractionEnabled = true // add by chandra new 22 may
        if myGrupsList.count > 0 {
            groupList = myGrupsList[indexPath.row]
            createdBy = groupList["UserID"].stringValue // use it for CreateNewGrupDscsnVC class
            cell.groupName.text = groupList["Title"].stringValue.uppercased()
        if activeTabIndex == 0{
            cell.grupCreatedBy.text = "\(groupList["CreatedBy"].stringValue)".capitalized
            cell.grupCreatedByLblHight.constant = 0
        }else if activeTabIndex == 1{
            cell.grupCreatedBy.text = "\(groupList["CreatedBy"].stringValue)"
            cell.grupCreatedByLblHight.constant = 25
        }else if activeTabIndex == 2{
            cell.grupCreatedBy.text = "\(groupList["CreatedBy"].stringValue)"
            cell.grupCreatedByLblHight.constant = 25
        }
            cell.noOfParticipants.text = "\(groupList["NoSubscribers"].intValue)" // add by chandra for new
            cell.grupCreatedBy.text = "\(groupList["CreatedBy"].stringValue)"
            var dateString = groupList["CreatedDate"].stringValue
            dateString = dateString.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
            // For Decimal value
            cell.createdOn.text = "\(DateHelper.localToUTC(date: dateString, fromFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "MMM dd, yyyy"))"
            // add by chandra for diplay the count
            var CountButton =  groupList["ActiveCount"].intValue
            cell.countLbl.text = "\(groupList["ActiveCount"].intValue) Messages"
            // add by chandra sekhar 24/10
            let catagery = groupList["SubjectID"].intValue
            let subcatagery = groupList["Sub_SubjectID"].intValue
            let subSubjectName = getSubjectName(with: subcatagery)
            cell.topicSubTopic.text = "\(self.subjects[catagery-1]) /\(subSubjectName ?? "")"
            
            // Add by chandra
            let stringUrl = groupList["TopicUrl"].stringValue
            let thumbnail = stringUrl.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
            cell.grupImg?.sd_setImage(with: URL.init(string:thumbnail ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTappedMethod(_:)))
        cell.grupImg.isUserInteractionEnabled = true
        cell.grupImg.tag = indexPath.row
        cell.grupImg.addGestureRecognizer(tapGestureRecognizer)
            
            /* Don't delete below note , it's a very strict warning to follow without commit this mistake once again in future.
             note: Don't load the image in DispatchQueue.main.async(){} cause it's freezing the UI most of the times and one more thing SDWebImage only handling all the threading related functionality in their own way. */
            
            cell.groupInfo.tag = indexPath.row
            cell.groupInfo.addTarget(self, action: #selector(groupInfo), for: .touchUpInside)
            // add by chandrasekhar
            cell.exitgroupBtn.setTitle("ExitGroup", for: .normal)
            cell.exitgroupBtn.setTitleColor(UIColor.init(hex: "FFAE00"), for:.normal)
            cell.exitgroupBtn.tag = indexPath.row
        
        let SharedType = groupList["SharedType"].intValue
        if SharedType == 1{
            cell.PublicAndPrivate.isSelected = false
        }else{
            cell.PublicAndPrivate.isSelected = true
        }
            cell.exitgroupBtn.addTarget(self, action: #selector(exitgroup), for: .touchUpInside)
            cell.exitgroupBtn.tag = indexPath.row
        
            cell.DiscussionVC.addTarget(self, action: #selector(DiscussionVC), for: .touchUpInside)
            cell.grupDelteBtn.tag = indexPath.row
        
            cell.grupDelteBtn.addTarget(self, action: #selector(deleteBtnSelected(sender:)), for: .touchUpInside)
            
            cell.grupEditBtn.tag = indexPath.row
            cell.grupEditBtn.isUserInteractionEnabled = true // add by chandra new 22 may
            cell.grupEditBtn.addTarget(self, action: #selector(editBtnSelected(sender:)), for: .touchUpInside)

        if activeTabIndex == 0{
            if CountButton == 0{
                cell.hightForTheMessageView.constant = 5
                 cell.messageView.isHidden = true
            }else{
                cell.hightForTheMessageView.constant = 39 // add by chandrs for hideing the message view
                cell.messageView.isHidden = false // add by chandrs for hideing the message view
            }
        cell.exitgroupBtn.isHidden = true
        cell.groupInfo.isHidden = false
        cell.grupEditBtn.isHidden = false
        cell.grupDelteBtn.isHidden = false
        cell.hightForTheDeleteBtn.constant = 40
        cell.hightForTheExitBtn.constant = 0
            cell.DiscussionVC.isHidden = false
        }else if activeTabIndex == 1{
            
            if CountButton == 0{
                cell.hightForTheMessageView.constant = 5
                 cell.messageView.isHidden = true
            }else{
                cell.hightForTheMessageView.constant = 39 // add by chandrs for hideing the message view
                cell.messageView.isHidden = false // add by chandrs for hideing the message view
            }
            cell.exitgroupBtn.setTitle("Unsubscribe", for: .normal)
            cell.exitgroupBtn.isHidden = false
            cell.groupInfo.isHidden = false
            cell.grupEditBtn.isHidden = true
            cell.grupDelteBtn.isHidden = true
            cell.hightForTheExitBtn.constant = 30
            cell.hightForTheDeleteBtn.constant = 0
            cell.DiscussionVC.isHidden = false
        }else if activeTabIndex == 2{
            cell.exitgroupBtn.setTitle("Subscribe", for: .normal)
            cell.exitgroupBtn.isHidden = false
            cell.groupInfo.isHidden = false
            cell.grupEditBtn.isHidden = true
            cell.grupDelteBtn.isHidden = true
            cell.hightForTheExitBtn.constant = 30
            cell.hightForTheDeleteBtn.constant = 0
            cell.DiscussionVC.isHidden = true
            cell.hightForTheMessageView.constant = 5// add by chandrs for hideing the message view
            cell.messageView.isHidden = true // add by chandrs for hideing the message view
        }
    }
            return cell
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if activeTabIndex == 0{
            let vc = storyboard?.instantiateViewController(withIdentifier: "discussion") as! DiscussionVC
            vc.groupId = myGrupsList[indexPath.row]["DiscussionID"].stringValue
            vc.naviTitle = myGrupsList[indexPath.row]["Title"].stringValue
            navigationController?.pushViewController(vc, animated: true)
        }else if activeTabIndex == 1{
            let vc = storyboard?.instantiateViewController(withIdentifier: "discussion") as! DiscussionVC
            vc.groupId = myGrupsList[indexPath.row]["DiscussionID"].stringValue
            vc.naviTitle = myGrupsList[indexPath.row]["Title"].stringValue
            navigationController?.pushViewController(vc, animated: true)
        }else if activeTabIndex == 2{
            
        }
    
    }
// add by chandra for scrolling
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    activityIndicator?.didScroll()
    print("activityIndicator")

}
}
//add by chandra for scrolling the tableview
extension MyGroupsVC: LoadMoreControlDelegate {
    func loadMoreControl(didStartAnimating loadMoreControl: LoadMoreControl) {
        
//        if(!isDataOver)
//        {
        print("didStartAnimating")
        if activeTabIndex == 0{
            tablePageIndex0 = (tablePageIndex0 + noOfItemsInaPage)
        }else if activeTabIndex == 1{
            
            tablePageIndex1 = (tablePageIndex1 + noOfItemsInaPage)
        }else{
            tablePageIndex2 = (tablePageIndex2 + noOfItemsInaPage)
        }
        
        hitApiForMyGroups()
//        }
//        else
//        {
//            print("No more data to load......")
//        }
    }

    func loadMoreControl(didStopAnimating loadMoreControl: LoadMoreControl) {
        print("didStopAnimating")
    }
}

/* Freshly Integrated Chandra Build On 8th  Jan 2019 - ends  here  */
