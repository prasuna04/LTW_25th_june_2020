//  FollowCategoryVC.swift
//  LTW
//  Created by Ranjeet Raushan on 10/06/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import SwiftMessages
import NVActivityIndicatorView


class AddtoFollowCategoryVC: UIViewController,NVActivityIndicatorViewable {
    
    //scroll View
@IBOutlet weak var scrolView: UIScrollView!
/* added by veeresh on 30th apr 2020 */
    @IBOutlet weak var scienceCardView: CardView!
    
    @IBOutlet weak var mathsCardView: CardView!
    @IBOutlet weak var englishCardView: CardView!
    @IBOutlet weak var technologyCardView: CardView!
    @IBOutlet weak var gradeStackView: UIStackView!
    
    /* added by veeresh on 30th apr 2020 */
    // content View
@IBOutlet weak var contentView: UIView!
 
    var userID: String!
    var sub_subjectId: [Int] = [] // Collection of  Array Int
    var gradeId: [String] = [] // Collection of  Array String
    
    /* Follow Right Bar Button Code Starts Here */
    lazy  var followRightBarButtonItem:UIBarButtonItem = {
        let barBtn = UIBarButtonItem(image: UIImage(named: "follow"), style: .plain, target: self, action: #selector(AddtoFollowCategoryVC.onFollowRightBarButtonItem(sender:)))
        return barBtn
    }()
    /* Follow Right Bar Button Code Ends Here */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateGrades()
        if isKeyPresentInUserDefaults(key: "FollowCategory") {
            updateSubjects()
        }
    }
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    func updateGrades(){
        var subView  = [UIView()]
                let stackSubs = gradeStackView.subviews
                subView = stackSubs[0].subviews
                subView += stackSubs[1].subviews
                var lGrade = UserDefaults.standard.array(forKey: "grades") as! [String]
                for i in 0..<lGrade.count {
                  if lGrade[i].contains("UnderGraduates") || lGrade[i].contains("UnderGraduates") {  lGrade[i] = "13" }
                  else if lGrade[i].contains("Graduates") {  lGrade[i] = "14" }
                  else {
                      lGrade[i] = "\(lGrade[i].replacingOccurrences(of: "th", with: ""))".replacingOccurrences(of: "st", with: "").replacingOccurrences(of: "rd", with: "").replacingOccurrences(of: "nd", with: "")
                  }
                }
                for i in 0..<lGrade.count{
                    let j : Any  = Int(lGrade[i])!
                    let k = (j as! Int) - 1
                    gradeId.append("\(k + 1)")
                    (subView[k] as! UIButton).isSelected.toggle()
                }
            }
       func updateSubjects(){
           var subView  = scienceCardView.subviews
           subView += technologyCardView.subviews
           subView += englishCardView.subviews
           subView += mathsCardView.subviews
           let lGrade = UserDefaults.standard.array(forKey: "FollowCategory") as! [Int]
           for i in 0..<lGrade.count{
               let j : Any  = Int(lGrade[i])
               let k = (j as! Int) - 1
               sub_subjectId.append(k + 1)
               (subView[k] as! UIButton).isSelected.toggle()
           }
       }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.navigationController?.navigationBar) != nil {
            navigationController?.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        }
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Follow Category"
        self.navigationItem.rightBarButtonItem = followRightBarButtonItem // For Follow Right Bar Button
    }

    
    @objc private func onFollowRightBarButtonItem(sender: UIBarButtonItem){
        
        print("Follow  Right Bar Button Clicked")
        validiate()
    }
    @IBAction func onAllSub_SubjectBtnActnClk(_ sender: UIButton) {
        if sub_subjectId.contains(sender.tag) {
            sub_subjectId = sub_subjectId.filter { $0 != sender.tag }
        } else {
             sub_subjectId.append(sender.tag)
        }
        sender.isSelected.toggle()
    }

    @IBAction func onGradesBtnActnClk(_ sender: UIButton) {
        if gradeId.contains("\(sender.tag)") {
            gradeId = gradeId.filter { $0 != "\(sender.tag)"}
        } else {
            gradeId.append("\(sender.tag)")
        }
        sender.isSelected.toggle()
    }
    
    @IBAction func onFollowBtnClick(_ sender: UIButton) {
        validiate()
    }
    private func getGradeList() -> [JSON] {
           let stringJSON = UserDefaults.standard.string(forKey: "gradeList")!
           let json = JSON.init(parseJSON: stringJSON)
           // let SubSubjectJSONArray = json.arrayValue
           // let selectedSubSubjectJSON = SubSubjectJSONArray.filter { json -> Bool in
           // return json["SubjectID"].intValue == subjectID
           // }
        return json.arrayValue
    }
    func validiate(){
            // validiation of Grade selection
             if gradeId.isEmpty {
                         showMessage(bodyText: "Follow at least one Grade",theme: .warning)
                         return
                     }
            // validiation of sub_Subject selection
             else if sub_subjectId.isEmpty {
                 showMessage(bodyText: "Follow at least one Subject",theme: .warning)
                 return
             }
         // Here for sub_subjectId & gradeId - defining the tags in storyboard , so no need to write Code and assign it .
         let  gradesSubSubjectsList = getGradeList()
         var gradeString = [String]()
        for i in gradeId {
            let int = Int(i)!
            gradeString.append(gradesSubSubjectsList[int-1]["Grades"].stringValue)
        }
        
        
        
        
         /* added by veeresh on 30th apr 2020 */
//        if gradeId.contains("14") {
//            gradeId.remove(at: gradeId.index(of: "14")!)
//            gradeId.append("Graduates")
//        }
//        if gradeId.contains("13"){
//            gradeId.remove(at: gradeId.index(of: "13")!)
//            gradeId.append("UnderGraduates")
//        }
        let defaults = UserDefaults.standard
        defaults.set(gradeString, forKey: "grades")
        defaults.set(sub_subjectId,forKey: "FollowCategory")
         /* added by veeresh on 30th apr 2020 */
        let params:[String:Any] = ["UserID": UserDefaults.standard.string(forKey: "userID")!,
                                   "Sub_SubjectID": sub_subjectId,
                                   "GradeID": gradeId,
        ]
        callService(params: params)
    }
    
    private func callService(params: [String: Any]){
        if currentReachabilityStatus != .notReachable {
            self.hitServer(params:params ,action: "Follow Category" )
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
                self.callService(params: params)
            })
        }
    }
    private func hitServer(params: [String:Any],action: String) {
        print(params)
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: Endpoints.addToFolowCatgryEndPoint, using: .post, dueToAction: action){ result in
            self.stopAnimating()
            switch result {
            case let .success(json,_):
                
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }else {
                    self.navigationController?.popViewController(animated: true)
                    //showMessage(bodyText: msg ,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.01))
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
}
