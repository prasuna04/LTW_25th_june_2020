//  ContentSegmentHandlerVC.swift
//  LTW
//  Created by Ranjeet Raushan on 18/12/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import SwiftyJSON
import Alamofire

class ContentSegmentHandlerVC: UIViewController,UISearchControllerDelegate,UISearchBarDelegate, UISearchResultsUpdating,UIPopoverPresentationControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
         performSearch()
         if isOpen{
             isOpen = false
             dismiss(animated: true) {
                 
             }
         }
    }
    var isOpen = false
    var segmentedControl = UISegmentedControl()
    var activeTabIndex = 0
    let searchControl = UISearchController(searchResultsController: nil)
    var searchView = UIView()
    var buttonBar:UIView!
    var searchDataForAakaQuestionVC :String!
    var tabelViewController: ArrayChoiceTableViewControllerToSearchQuestion<JSON,String>?
    let transiton = SlideInTransition()
    var isPopUpDismissed: Bool = true
    //Screen width.
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    //Screen height
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    @IBOutlet weak var baseContainerView:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextviewcontroller = storyboard.instantiateViewController(withIdentifier: "home") as! HomeVC
        nextviewcontroller.fromMoreBtn = true
        self.baseContainerView.addSubview(nextviewcontroller.view)
        self.addChild(nextviewcontroller)
        
        self.searchControl.hidesNavigationBarDuringPresentation = false
        self.searchControl.searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchControl.dimsBackgroundDuringPresentation = true
        searchControl.extendedLayoutIncludesOpaqueBars = true // Added By Ranjeet on 6th Dec 2019
        searchControl.edgesForExtendedLayout = .all // Added By Ranjeet on 6th Dec 2019
            // Include the search bar within the navigation bar.
            // self.navigationItem.titleView = self.searchControl.searchBar
        searchView  = self.searchControl.searchBar
        searchView.backgroundColor = UIColor.init(hex: "2DA9EC")
        searchView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
        self.view.addSubview(searchView)
        self.definesPresentationContext = true
        searchControl.searchResultsUpdater = self as UISearchResultsUpdating
        searchControl.searchBar.placeholder = " Enter Search Phrase" // Don't remove gap here because intensionally i place this to keep the gap between image and text
        searchControl.searchBar.setImage(UIImage(named: "topsearch"), for: .search, state: .normal)
        searchControl.delegate = self
        searchControl.searchBar.delegate = self
        if let textField = searchControl.searchBar.value(forKey: "searchField") as? UITextField {
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
            textField.attributedPlaceholder = NSAttributedString(string: " Enter Search Phrase", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }
        segmentupUIControl()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isOpen = false
        if (self.navigationController?.navigationBar) != nil {
            navigationController?.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
            navigationController?.view.backgroundColor = UIColor.init(hex: "2DA9EC")// to resolve black bar problem appears on navigation bar when pushing view controller
        }
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "My Content"
    }
    override func viewWillDisappear(_ animated: Bool) {
          if isOpen == true {
                  isOpen = false
                  dismiss(animated: true) {
                  }
              }
    }
    
    func performSearch(){
        if searchControl.searchBar.text?.isEmpty ?? true
        {
            print("Search key is Empty")
            searchDataForAakaQuestionVC = ""
        }
        if isFiltering() {
            var searchKey = searchControl.searchBar.text!
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
             //   activityIndicator.stopAnimating();
                //loader.removeFromSuperview()
            }
        }// isFiltering
    }
    
    private func segmentupUIControl() {
        // Container view
        let view = UIView(frame: CGRect(x: 0, y: 40 , width: UIScreen.main.bounds.width, height: 45))
        view.backgroundColor = UIColor.init(hex:"2DA9EC")
        
        segmentedControl = UISegmentedControl()
        // Add segments
        segmentedControl.insertSegment(withTitle: "Questions That You Can Answer", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Questions That You Asked", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "Answers That You Provided", at: 2, animated: true)
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
        //searchView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: UIControl.Event.valueChanged)
        
        // Constrain the top of the button bar to the bottom of the segmented control
        //        buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        //        buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        //        // Constrain the button bar to the left side of the segmented control
        //        buttonBar.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor).isActive = true
        //        // Constrain the button bar to the width of the segmented control divided by the number of segments
        //        buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
        
        /*Added by chandra 15/5/2020 starts here */
        self.buttonBar.frame.origin.x = (UIScreen.main.bounds.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
        self.buttonBar.frame.origin.y = 40
        self.buttonBar.frame.size.width = (UIScreen.main.bounds.width / CGFloat(self.segmentedControl.numberOfSegments))
        self.buttonBar.frame.size.height = 5
        /*Added by chandra 15/5/2020 ends here */
        
        self.view.addSubview(view)
        view.topAnchor.constraint(equalTo: searchView.bottomAnchor).isActive = true
    }
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.3) {[unowned self] in
            self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
            
        }
        print("Selected segment index = \(self.segmentedControl.selectedSegmentIndex)")
        //classTableView.setContentOffset(.zero, animated: true)
        
        activeTabIndex = self.segmentedControl.selectedSegmentIndex
        if activeTabIndex == 0{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //            let nextviewcontroller = storyboard.instantiateViewController(withIdentifier: "QuestionsThatCanYouAnsweredVC") as! QuestionsThatCanYouAnsweredVC
            let nextviewcontroller = storyboard.instantiateViewController(withIdentifier: "home") as! HomeVC
            nextviewcontroller.fromMoreBtn = true
           // let a =  ; a?.frame.origin.y = 45
            self.baseContainerView.addSubview(nextviewcontroller.view)
            self.addChild(nextviewcontroller)
        }else if activeTabIndex == 1{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextviewcontroller = storyboard.instantiateViewController(withIdentifier: "contntqstinsasked") as! ContentQuestionsAskedVC
            self.baseContainerView.addSubview(nextviewcontroller.view)
            self.addChild(nextviewcontroller)
            
        }else if activeTabIndex == 2{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextviewcontroller = storyboard.instantiateViewController(withIdentifier: "AnswerThatYouProvidedVC") as! AnswerThatYouProvidedVC
            self.baseContainerView.addSubview(nextviewcontroller.view)
            self.addChild(nextviewcontroller)
        }
        
    }
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
           self.showPopup(self.tabelViewController!, sourceView: self.searchControl.searchBar)
           self.isPopUpDismissed = false
       }
       func isFiltering() -> Bool {
           return searchControl.isActive && !searchBarIsEmpty()
       }
       func searchBarIsEmpty() -> Bool {
           // Returns true if the text is empty or nil
           return searchControl.searchBar.text?.isEmpty ?? true
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
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
           .none
       }
     func hitService(withBodyData data: [String: Any],toEndPoint url: String,using httpMethod: HTTPMethod,dueToAction requestType: String){
           print("EndPoint = \(url)"); print("BodyData = \(data)");print("Action = \(requestType)")
           let header = ["Content-Type": "application/json",
                         "Api-key": "55EBA8DAFFB956A359B07C4DAB2CE3EE"]
          // activityIndicator.startAnimating()
           let manager = Alamofire.SessionManager.default
           manager.session.configuration.timeoutIntervalForRequest = 10
           manager.request(url, method: httpMethod, parameters: data.isEmpty ? nil: data, encoding: JSONEncoding.default, headers: header).responseJSON {[unowned self] response in
            //   self.activityIndicator.stopAnimating()
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

extension ContentSegmentHandlerVC: UIViewControllerTransitioningDelegate {
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
