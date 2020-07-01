//  RatingAndReviewContainerViewController.swift
//  LTW
//  Created by Vaayoo on 21/02/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import UIKit

class RatingAndReviewContainerViewController: UIViewController {
     var profileUrl:String!
     var profileUserId:String!
     var firstName:String!
     var lastName:String!
     var rating:Int!
    var segmentedControl = UISegmentedControl()
    var buttonBar:UIView!
    var activeTabIndex:Int!
    @IBOutlet weak var baseContainerView:UIView!
    @IBOutlet weak var segmentView:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
         segmentupUIControl()
         navigationItem.title = "Ratings & Reviews"
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let tutorVc = storyBoard.instantiateViewController(withIdentifier: "TutorRatingAndReviewViewController") as! TutorRatingAndReviewViewController
         tutorVc.profilId = profileUserId
        self.baseContainerView.addSubview(tutorVc.view)
        self.addChild(tutorVc)
    }
    private func segmentupUIControl(){
        // Container view
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45))
        view.backgroundColor = UIColor.init(hex:"2DA9EC")
        segmentedControl = UISegmentedControl()
        // Add segments
        segmentedControl.insertSegment(withTitle: "TUTOR REVIEW", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "CLASS REVIEW", at: 1, animated: true)
        // First segment is selected by default
        segmentedControl.selectedSegmentIndex = 0
        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = UIColor.init(hex:"2DA9EC")
        } else {
            // Fallback on earlier versions
        }
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.backgroundColor = .clear
        segmentedControl.tintColor = .clear
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 0
        buttonBar = UIView()
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = UIColor.orange
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 15)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .normal)
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .selected)
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
//        buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
//        buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
//        // Constrain the button bar to the left side of the segmented control
//        buttonBar.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor).isActive = true
//        // Constrain the button bar to the width of the segmented control divided by the number of segments
//        buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
        
        self.buttonBar.frame.origin.x = (UIScreen.main.bounds.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
               self.buttonBar.frame.origin.y = 40
               self.buttonBar.frame.size.width = (UIScreen.main.bounds.width / CGFloat(self.segmentedControl.numberOfSegments))
               self.buttonBar.frame.size.height = 5
        
        //self.view.addSubview(view)
        self.segmentView.addSubview(view)
    }
   @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
       UIView.animate(withDuration: 0.3) {[unowned self] in
           self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
           
       }
       print("Selected segment index = \(self.segmentedControl.selectedSegmentIndex)")
        activeTabIndex = self.segmentedControl.selectedSegmentIndex
       
    if activeTabIndex == 0{
        self.buttonBar.frame.origin.x = (UIScreen.main.bounds.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
               self.buttonBar.frame.origin.y = 40
               self.buttonBar.frame.size.width = (UIScreen.main.bounds.width / CGFloat(self.segmentedControl.numberOfSegments))
               self.buttonBar.frame.size.height = 5
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let tutorVc = storyBoard.instantiateViewController(withIdentifier: "TutorRatingAndReviewViewController") as! TutorRatingAndReviewViewController
        tutorVc.profilId = profileUserId
        self.baseContainerView.addSubview(tutorVc.view)
        self.addChild(tutorVc)
    }else{
        self.buttonBar.frame.origin.x = (UIScreen.main.bounds.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
        self.buttonBar.frame.origin.y = 40
        self.buttonBar.frame.size.width = (UIScreen.main.bounds.width / CGFloat(self.segmentedControl.numberOfSegments))
        self.buttonBar.frame.size.height = 5
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let tutorVc = storyBoard.instantiateViewController(withIdentifier: "ClassRatingAndReviewViewController") as! ClassRatingAndReviewViewController
        tutorVc.profilId = profileUserId
        self.baseContainerView.addSubview(tutorVc.view)
        self.addChild(tutorVc)
        
    }
       
   }

}
