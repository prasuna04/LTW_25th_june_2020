//  RequestClassSegmentHandlerVC.swift
//  LTW
//  Created by Ranjeet Raushan on 21/02/20.
//  Copyright © 2020 vaayoo. All rights reserved.

class RequestClassSegmentHandlerVC: UIViewController {
var segmentedControl = UISegmentedControl()
var activeTabIndex = 0
var buttonBar:UIView!
var teacherListUserID: String!
    
    var fname: String!
    var lname: String!
    var schol: String!
    var personType: String!
    
    @IBOutlet weak var baseContainerViewForRequstClassSegmntHndler:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextviewcontroller = storyboard.instantiateViewController(withIdentifier: "requestforaclass") as! RequestForAClassVC
        nextviewcontroller.teacherListUserID = self.teacherListUserID
        nextviewcontroller.fname = fname
        nextviewcontroller.lname = lname
        nextviewcontroller.schol = schol
        nextviewcontroller.personType = personType
        
        self.baseContainerViewForRequstClassSegmntHndler.addSubview(nextviewcontroller.view)
        self.addChild(nextviewcontroller)
        segmentupUIControl()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.navigationController?.navigationBar) != nil {
        navigationController?.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        navigationController?.view.backgroundColor = UIColor.init(hex: "2DA9EC")// to resolve black bar problem appears on navigation bar when pushing view controller
            }
            self.navigationController?.navigationBar.topItem?.title = " "
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationItem.title = "Request A Teacher"
    }
    
    private func segmentupUIControl() {
        // Container view
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45))
        view.backgroundColor = UIColor.init(hex:"2DA9EC")
        
        segmentedControl = UISegmentedControl()
        // Add segments
        segmentedControl.insertSegment(withTitle: "Request A Class", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Available Classes", at: 1, animated: true)
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
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 0 // for multiple lines in segment text
        
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
        
        // Constrain the top of the button bar to the bottom of the segmented control
        buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        // Constrain the button bar to the left side of the segmented control
        buttonBar.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor).isActive = true
        // Constrain the button bar to the width of the segmented control divided by the number of segments
        buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
        
        self.view.addSubview(view)
    }
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.3) {[unowned self] in
            self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
            }
        print("Selected segment index = \(self.segmentedControl.selectedSegmentIndex)")
        
        activeTabIndex = self.segmentedControl.selectedSegmentIndex
        if activeTabIndex == 0{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextviewcontroller = storyboard.instantiateViewController(withIdentifier: "requestforaclass") as! RequestForAClassVC
            nextviewcontroller.teacherListUserID = self.teacherListUserID
            nextviewcontroller.fname = fname
            nextviewcontroller.lname = lname
            nextviewcontroller.schol = schol
            nextviewcontroller.personType = personType
            self.baseContainerViewForRequstClassSegmntHndler.addSubview(nextviewcontroller.view)
            self.addChild(nextviewcontroller)
        }else if activeTabIndex == 1{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextviewcontroller = storyboard.instantiateViewController(withIdentifier: "tutorAvailableClass") as! TutorAvailableClass
            nextviewcontroller.teacherListUserID = self.teacherListUserID
            self.baseContainerViewForRequstClassSegmntHndler.addSubview(nextviewcontroller.view)
            self.addChild(nextviewcontroller)
    }
  }
}
