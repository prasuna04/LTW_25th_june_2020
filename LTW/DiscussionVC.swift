//  DiscussionVC.swift
//  LTW
//  Created by Vaayoo on 24/09/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import SwiftMessages
import NVActivityIndicatorView

class DiscussionVC: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var tbl_discussion: UITableView!
    @IBOutlet weak var btnCreateDiscussion: UIButton!{
        didSet{
            btnCreateDiscussion.layer.shadowColor = UIColor.gray.cgColor
                       btnCreateDiscussion.layer.shadowOffset = CGSize(width: 5, height: 5)
                       btnCreateDiscussion.layer.shadowRadius = 5
                       btnCreateDiscussion.layer.shadowOpacity = 1.0
                       btnCreateDiscussion.layer.cornerRadius = btnCreateDiscussion.frame.height / 2

        }
    }
     @IBOutlet var createDscsnPan: UIPanGestureRecognizer! // Added By Ranjeet
    var groupId: String?
    var userID: String!
    var naviTitle: String?
    var discussionList = [JSON]()
    var refreshControl = UIRefreshControl() // pull to refresh /* Added By Ranjeet */
    override func viewDidLoad() {
        super.viewDidLoad()
          userID = UserDefaults.standard.string(forKey: "userID")
//        if currentReachabilityStatus != .notReachable {
//            let point = "\(Endpoints.discussionList)\(groupId!)\(userID!)" /* Added By Chandra on 3rd Jan 2020 */
//            hitServer(params: [:], endPoint: point,  action: "myDiscussionList", httpMethod: .get)
//        } else {
//            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
//            })
//        }
        /* Added By Ranjeet - from here */
        // pull to refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(DiscussionVC.hitApiForDiscussionVC),for: .valueChanged)
        tbl_discussion.addSubview(refreshControl)
        DispatchQueue.main.async {
            self.tbl_discussion.reloadData()
        }
        /* Added By Ranjeet - till here */
        
        /* Moving Floating Button Code  - starts here[ Added By Ranjeet ] */
         self.btnCreateDiscussion.frame = CGRect(x:self.view.frame.width - 80 , y: self.view.frame.height - 230 , width: 80 , height: 80 )
        /* Moving Floating Button Code - ends here[ Added By Ranjeet ] */
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
    /*  Added By Chandra on 24- Oct-2019 - from here  */
    override func viewWillAppear(_ animated: Bool) {
        
        // add by chandrasekhar
        if currentReachabilityStatus != .notReachable {
            let point = "\(Endpoints.discussionList)\(groupId!)"  /* Added By Chandra on 3rd Jan 2020 */
            hitServer(params: [:], endPoint: point, action: "myDiscussionList", httpMethod: .get)
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
            })
        }
        DispatchQueue.main.async {
            self.tbl_discussion.reloadData()
        }
        
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = naviTitle!
    }
    /*  Added By Chandra on 24- Oct-2019 - till here  */
    
    /* Added By Ranjeet - from here */
    //pull to refresh
    @objc func hitApiForDiscussionVC() {
        refreshControl.endRefreshing()
        if currentReachabilityStatus != .notReachable {
            let point = "\(Endpoints.discussionList)\(groupId!)" /* Added By Chandra on 3rd Jan 2020 */
            hitServer(params: [:], endPoint: point,  action: "myDiscussionList", httpMethod: .get)
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
                self.hitApiForDiscussionVC()
                self.refreshControl.endRefreshing()
            })
        }
    }
    /* Added By Ranjeet - till here */
    @IBAction func btn_createDiscussion(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "createDiscussion") as! CreateDiscussionVC
        
        vc.title = "Create Discussion"  /*  Added By Chandra on 24- Oct-2019 */
        vc.groupId = groupId!
        navigationController?.pushViewController(vc, animated: true)
    }
    //discussion
    
    func parseDiscussionList(json: JSON, requestType: String){
        discussionList = json.arrayValue
        DispatchQueue.main.async {
            self.tbl_discussion.reloadData()
        }
    }
    
}
extension DiscussionVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discussionList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl_discussion.dequeueReusableCell(withIdentifier: "discCell") as! DiscussionCell
        // add by chandra starts here to
        let data = discussionList[indexPath.row]["ActiveCount"].intValue
        if data == 0{
            cell.hightForTheCountLbl.constant = 0
            cell.countView.isHidden = true
        }else{
             cell.hightForTheCountLbl.constant = 26
            cell.countView.isHidden = false
        }
        cell.countLbl.text = "\(discussionList[indexPath.row]["ActiveCount"].intValue)Messages"
        // add by chandra ends here to
        cell.lbl.text = discussionList[indexPath.row]["DiscussionTitle"].stringValue
        cell.lbl1.text = discussionList[indexPath.row]["Description"].stringValue /* Added By Chandra on 11th-Nov-2019 */
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "chat") as! ChatVC
        vc.discussionId = discussionList[indexPath.row]["GDiscussionID"].stringValue
        vc.naviTitle = discussionList[indexPath.row]["DiscussionTitle"].stringValue
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension DiscussionVC{
    private func hitServer(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){ [weak self] result in
            guard let _self = self else {
                return
            }
            _self.stopAnimating()
            
            switch result{
            case let .success(json,requestType):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }
                else {
                    _self.parseDiscussionList(json: json["ControlsData"]["lsv_discussion"], requestType: requestType) /* added by Mukesh on 25th Oct */
                    _self.navigationItem.title = json["ControlsData"]["GroupTitle"].string  /* added by Mukesh on 25th Oct */
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
}
