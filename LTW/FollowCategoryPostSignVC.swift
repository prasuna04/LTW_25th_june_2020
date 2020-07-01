//
//  FollowCategoryPostSignVC.swift
//  LTW
//
//  Created by Vaayoo on 23/04/20.
//  Copyright © 2020 vaayoo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class FollowCategoryPostSignVC: UIViewController,NVActivityIndicatorViewable {

    
    @IBOutlet weak var gradeStackView: UIStackView!
    var grades : [Int] = []
    var subjectIds = [Int]()
    
    @IBOutlet weak var nextBtn: UIButton!{
        didSet{
            nextBtn.layer.cornerRadius = 16
            nextBtn.layer.borderWidth = 2
            nextBtn.layer.borderColor = UIColor.orange.cgColor
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateGrades()
       
        // Do any additional setup after loading the view.
    }
    func updateGrades(){
          var subView  = [UIView()]
          let stackSubs = gradeStackView.subviews
          subView = stackSubs[0].subviews
          subView += stackSubs[1].subviews
          var lGrade = UserDefaults.standard.array(forKey: "grades") as! [String]
          for i in 0..<lGrade.count {
            if lGrade[i].contains("UnderGraduates") || lGrade[i].contains("Under Graduates") {  lGrade[i] = "13" }
            else if lGrade[i].contains("Graduates") {  lGrade[i] = "14" }
            else {
                lGrade[i] = "\(lGrade[i].replacingOccurrences(of: "th", with: ""))".replacingOccurrences(of: "st", with: "").replacingOccurrences(of: "rd", with: "").replacingOccurrences(of: "nd", with: "")
            }
          }
          for i in 0..<lGrade.count{
              let j : Any  = Int(lGrade[i])!
              let k = (j as! Int) - 1
              grades.append(k + 1)
              (subView[k] as! UIButton).isSelected.toggle()
          }
        //hhhhh
      }
    
    @IBAction func onNextBtnClicked(_ sender: UIButton) {
        validiate()
        
    }
    @IBAction func onGradeClick(_ sender: UIButton){
        if grades.contains(sender.tag){
            let index = grades.index(of: sender.tag)!
            grades.remove(at: index)
        }
        else {
            grades.append(sender.tag)
        }
        sender.isSelected.toggle()
    }
    @IBAction func onSubjectClick(_ sender : UIButton){
        if subjectIds.contains(sender.tag){
            let index = subjectIds.index(of: sender.tag)!
            subjectIds.remove(at: index)
        }
        else {
            subjectIds.append(sender.tag)
        }
        sender.isSelected.toggle()
    }
    func isSubject(_ no : Int)->Bool{
        let j = no == 1 ? 1 : no == 2 ? 14 : no == 3 ? 20 : 28
        let k = no == 1 ? 13 : no == 2 ? 19 : no == 3 ? 27 : 38
        for i in j...k{
            if subjectIds.contains(i){ return true}
        }
        return false
    }

    func validiate(){
        // validiation of Grade selection
        if grades.isEmpty {
            showMessage(bodyText: "Follow at least one Grade",theme: .warning)
            return
        }
        // validiation of sub_Subject selection
        if subjectIds.isEmpty {
            showMessage(bodyText: "Follow at least one in each Subject",theme: .warning)
            return
        }
        if  isSubject(1) && isSubject(2) && isSubject(3) && isSubject(4) {
            nextBtn.isUserInteractionEnabled = false
            let  gradesSubSubjectsList = getGradeList()
            var gradeString = [String]()
            var gradeStrServer = [String]()
            for i in grades {
               // if i==13 || i==14 { continue }
                gradeString.append(gradesSubSubjectsList[i-1]["Grades"].stringValue)
                gradeStrServer.append("\(i)" )
            }
//            for i in gradeString {
//                if i == "UnderGraduates"{
//                    let index = gradeString.index(of: "UnderGraduates")!
//                    gradeString.remove(at: index)
//                    gradeString.append("UnderGraduates")
//                }
//
//            }
//            if gradeStrServer.contains("14") {
//                gradeStrServer.remove(at: gradeStrServer.index(of: "14")!)
//                gradeStrServer.append("Graduates")
//            }
//            if gradeStrServer.contains("13"){
//                gradeStrServer.remove(at: gradeStrServer.index(of: "13")!)
//                gradeStrServer.append("UnderGraduates")
//            }
            
            let params:[String:Any] = ["UserID": UserDefaults.standard.string(forKey: "userID")!,
                                       "Sub_SubjectID": subjectIds,
                                       "GradeID": gradeStrServer,
            ]
            callService(params: params)
            let defaults = UserDefaults.standard
            defaults.set(gradeString, forKey: "grades")
            // defaults.set(gradeString, forKey: "FollowGrades")
            defaults.set(subjectIds,forKey: "FollowCategory")
        }
        else {
            showMessage(bodyText: "Follow at least one in each Subject",theme: .warning)
        }
        
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
       // startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
           startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
           LTWClient.shared.hitService(withBodyData: params, toEndPoint: Endpoints.addToFolowCatgryEndPoint, using: .post, dueToAction: action){ result in
            self.stopAnimating()
            UserDefaults.standard.set(false, forKey: "PostSignUpFollowCategoryPage")
            UserDefaults.standard.synchronize()
            UIApplication.shared.keyWindow!.rootViewController!.dismiss(animated: true, completion: nil)
            UIApplication.shared.keyWindow?.rootViewController = VSCore().launchHomePage(index: 0)
              // self.stopAnimating()
            /*   switch result {
               case let .success(json,_):
                
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                   // showMessage(bodyText: msg,theme: .error)
                }else {
                    
                    //showMessage(bodyText: msg ,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.01))
                }
                break
               case .failure(let error):
                print("MyError = \(error)")
                break
            }*/
           }
       }
}
