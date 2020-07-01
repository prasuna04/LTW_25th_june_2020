//  SegmentVCForMyClasses.swift
//  LTW
//  Created by Ranjeet Raushan on 05/07/19.
//  Copyright © 2019 vaayoo. All rights reserved.


import UIKit
import SDWebImage
enum TabIndex2 : Int {
    case firstChildTab = 0
    case secondChildTab = 1
}
class SegmentVCForMyClasses: UIViewController {
    
    @IBOutlet weak var contentClassesCiew: UIView!
    @IBOutlet weak var segmnetedClassesContUIView: UIView!
    @IBOutlet weak var segmentClassesControl: Segment!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var index: Int = 0
    var userID: String!
    var questionID: String!
    
    var currentViewController: UIViewController?
    lazy var firstChildTabVC: UIViewController? = {
        let firstChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "createNewclass")
        return firstChildTabVC
    }()
    
    lazy var secondChildTabVC : UIViewController? = {
        let secondChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "clasesscheduled")
        return secondChildTabVC
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let View1 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.segmnetedClassesContUIView.frame.size.height))
        self.segmnetedClassesContUIView.insertSubview(View1, at: 0)
        segmentClassesControl.selectedSegmentIndex = TabIndex2.firstChildTab.rawValue
        displayCurrentTab(TabIndex2.firstChildTab.rawValue)
        self.navigationController?.navigationBar.isTranslucent = true
        
        // Segment related
        
        segmnetedClassesContUIView.layer.cornerRadius = segmentClassesControl.frame.height/2
        segmnetedClassesContUIView.layer.shadowColor = UIColor.white.cgColor
        segmnetedClassesContUIView.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        segmnetedClassesContUIView.layer.masksToBounds = false
        segmnetedClassesContUIView.layer.shadowRadius = 5.0
        segmnetedClassesContUIView.layer.shadowOpacity = 0.8
        segmentClassesControl.layer.cornerRadius = segmentClassesControl.frame.height/2
        segmentClassesControl.layer.borderColor = UIColor.init(hex: "2DA9EC").cgColor;
        segmentClassesControl.layer.borderWidth = 1.0;
        segmentClassesControl.layer.masksToBounds = true;
        segmentClassesControl.selectedSegmentIndex = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.navigationController?.navigationBar) != nil {
            navigationController?.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        }
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "My Classes"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewController = currentViewController {
            currentViewController.viewWillDisappear(animated)
        }
    }
    
    // MARK: - Switching Tabs Functions
    
    @IBAction func swiTchClassesTabs(_ sender: UISegmentedControl) {
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParent()
        
        displayCurrentTab(sender.selectedSegmentIndex)
    }
    
    func displayCurrentTab(_ tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            index = tabIndex
            self.addChild(vc)
            vc.didMove(toParent: self)
            vc.view.frame = self.contentClassesCiew.bounds
            self.contentClassesCiew.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case TabIndex2.firstChildTab.rawValue :
            vc = firstChildTabVC
        case TabIndex2.secondChildTab.rawValue :
            vc = secondChildTabVC
        default:
            return nil
        }
        return vc
    }
}


/* Future Reference :
 https://ahmedabdurrahman.com/2015/08/31/how-to-switch-view-controllers-using-segmented-control-swift/ - [  How to Switch View Controllers using Segmented Control ]
 */
