//  ContentQuestionsAskedVC.swift
//  LTW
//  Created by Ranjeet Raushan on 20/07/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import SwiftMessages
import NVActivityIndicatorView

class ContentQuestionsAskedVC: UIViewController,UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    @IBOutlet weak var scrollVw: UIScrollView!
    @IBOutlet weak var contentVw: UIView!
    @IBOutlet weak var tableView: UITableView!
    var userID: String!
    var questionID: String! // one way (questionID)
    var contentListForAskedQues: Array<JSON> = []
    var refreshControl = UIRefreshControl() // pull to refresh
    var askedOn: String!
    var question_html: String!
    var questionId: String! // another way (questionId)
    var questions: String!
    var subjectName: String!
    var sub_SubjectName: String!
    var sub_subjectId: Int!
    var subjectId: Int!
    var tags: String!
    var searchTags: String!
    var deletedIndexPath: IndexPath?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userID =  UserDefaults.standard.string(forKey: "userID")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        /* Don't Delete below single line commented code for future reference */
        // tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -120, right: 0) /* Programatically you can give constraints like this , actually  i already given constraints from storyboard so here it is not required */
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(ContentQuestionsAskedVC.pullToRefreshHitApiForQuestionsAsked),for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.navigationController?.navigationBar) != nil {
             navigationController?.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
             navigationController?.view.backgroundColor = UIColor.init(hex: "2DA9EC")// to resolve black bar problem appears on navigation bar when pushing view controller
                 }
                 self.navigationController?.navigationBar.topItem?.title = " "
                 navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                 navigationItem.title = "Questions Asked"
        
        /*Added by yasodha on 12/1/2020 to get previous-viewcontroller - starts here */
        if self.navigationController?.viewControllers.previous is PersonalProfileVC {
    
            if currentReachabilityStatus != .notReachable {
//                hitServer(params: [:], endPoint: Endpoints.profileUserAskedQuestions + ((UserDefaults.standard.string(forKey: "UserID"))!),  action: "ContntAskdQstn", httpMethod: .get)
                hitServer(params: [:], endPoint: Endpoints.profileUserAskedQuestions + ((UserDefaults.standard.string(forKey: "personalprofile"))!),  action: "ContntAskdQstn", httpMethod: .get)
            } else {
                showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
                })
            }
            
        } else {
            /* Added By Ranjeet - starts here */
            if currentReachabilityStatus != .notReachable {
                hitServer(params: [:], endPoint: Endpoints.contentQstonAskdEndPoint + (self.userID!),  action: "ContntAskdQstn", httpMethod: .get)
            } else {
                showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
                })
            }
             /* Added By Ranjeet - ends here */
            
        }
        /* Added by yasodha on 12/1/2020 to get previous-viewcontroller - ends here */
    }
    
        override func viewDidLayoutSubviews() {
         if self.navigationController?.viewControllers.previous is PersonalProfileVC {
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        }
    }
    /* added by yasodha on 17/12/2019  - starts here */
        override func willMove(toParent parent: UIViewController?)
         {
            if self.navigationController?.viewControllers.previous is PersonalProfileVC {}
            else {
                if parent == nil
                 {
                 UIApplication.shared.keyWindow!.rootViewController!.dismiss(animated: true, completion: nil)
                 UIApplication.shared.keyWindow?.rootViewController = VSCore().launchHomePage(index: 0)
                    }//parent

            }
    }
    /* added by yasodha on 17/12/2019- ends here */
     
    //pull to refresh
    @objc func pullToRefreshHitApiForQuestionsAsked() {
        refreshControl.endRefreshing()
if self.navigationController?.viewControllers.previous is PersonalProfileVC {
           if currentReachabilityStatus != .notReachable {
               hitServer(params: [:], endPoint: Endpoints.profileUserAskedQuestions + ((UserDefaults.standard.string(forKey: "personalprofile"))!),  action: "ContntAskdQstn", httpMethod: .get)
           } else {
               showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
               })
               self.pullToRefreshHitApiForQuestionsAsked()
               self.refreshControl.endRefreshing()/* Added By Ranjeet - ends here */
           }
   

           
       } else {
           /* Added By Ranjeet - starts here */
           if currentReachabilityStatus != .notReachable {
               hitServer(params: [:], endPoint: Endpoints.contentQstonAskdEndPoint + (self.userID!),  action: "ContntAskdQstn", httpMethod: .get)
           } else {
               showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
               })
            self.pullToRefreshHitApiForQuestionsAsked()
            self.refreshControl.endRefreshing()/* Added By Ranjeet - ends here */
           }
          
           
       }
    }

    // delete functionality
    @objc func deleteBtnSelected(sender: UIButton){
//        sender.springAnimation(btn: sender)// add by chandra for spring animation to the button
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
                   let refreshAlert = UIAlertController(title: "Delete", message: "Are you sure, you want to delete the question?", preferredStyle: UIAlertController.Style.alert)
                   refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                   print("Delete Button Clicked")
                   let index = sender.tag
                   self.questionID = self.contentListForAskedQues[index]["QuestionID"].stringValue
                   self.deletedIndexPath = IndexPath(item: sender.tag, section: 0)
                        let isIndexValid = self.contentListForAskedQues.indices.contains(self.deletedIndexPath!.row)
                   if self.currentReachabilityStatus != .notReachable {
                       if isIndexValid{
                       self.questionID =  self.contentListForAskedQues[self.deletedIndexPath!.row]["QuestionID"].stringValue
                       self.hitServerForDelete(params: [:], endPoint: Endpoints.deleteContntQstonAskdBtnEndPoint + (self.questionID!) ,action: "contntQuestnDelete", httpMethod: .get)
                       }
                   } else {
                       showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
                       })
                   }
                       }))
                   refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in
                   }))
            self.present(refreshAlert, animated: true, completion: nil)
//        })
       
        
    }
    
    // edit functionality
    @objc func editBtnSelected(sender: UIButton){
            print("Edit Button Clicked")
//        sender.springAnimation(btn: sender)// add by chandra for spring animation to the button
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
            let index = sender.tag
                       let askquestionWithText = self.storyboard?.instantiateViewController(withIdentifier: "askquestionwithtext") as! AskQuestionWithTextVC
                       askquestionWithText.questionID = self.contentListForAskedQues[index]["QuestionID"].stringValue
                       askquestionWithText.userID = self.userID
                       askquestionWithText.isEditMode = true
                       self.navigationController?.pushViewController(askquestionWithText, animated: true)
//        })
        
           
    }
    
    private func callService(params: [String: Any]){
        if currentReachabilityStatus != .notReachable {
            self.hitServerForEditByPost(params:params ,action: "ContentQuestionAskedEditByPost" )
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
                self.callService(params: params)
            })
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentListForAskedQues.count
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentQuestionAskedCell", for: indexPath) as! ContentQuestionsAskedCell
            var contentAskedList: JSON
            contentAskedList = contentListForAskedQues[indexPath.row]
        
        /*Added by yasodha on 12/1/2020 to get previous-viewcontroller - starts here */
        if self.navigationController?.viewControllers.previous is PersonalProfileVC {
            cell.editBtn.isHidden = true
            cell.deltBtn.isHidden = true
            
        } else {
            
            cell.editBtn.isHidden = false
            cell.deltBtn.isHidden = false
            
        }
        /*Added by yasodha on 12/1/2020 to get previous-viewcontroller - ends here */
        
            var dateString = contentAskedList["AskedOn"].stringValue
            dateString = dateString.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
            // For Decimal value
            cell.askedOnDateLbl.text = "Asked on:\(DateHelper.localToUTC(date: dateString, fromFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "MMM dd, yyyy"))"
            cell.questionsAskedLbl.text = contentAskedList["Questions"].stringValue
//            if let data = contentAskedList["Question_html"].stringValue.data(using: String.Encoding.unicode){
//                try? cell.questionsAskedLbl.attributedText =
//                    NSAttributedString(data: data,
//                                       options: [.documentType:NSAttributedString.DocumentType.html],
//                                       documentAttributes: nil)
//                
//            } else {
//                // for default cases
//            }
            cell.questionsAskedLbl.font = UIFont(name:"Roboto-Medium", size: 15.0) /*  Updated By Ranjeet on 26th March 2020 */
            cell.questionsAskedLbl.textColor = UIColor.init(hex:"2DA9EC")
            cell.deltBtn.tag = indexPath.row
            cell.deltBtn.addTarget(self, action: #selector(deleteBtnSelected(sender:)), for: .touchUpInside)
            
            cell.editBtn.tag = indexPath.row
            cell.editBtn.addTarget(self, action: #selector(editBtnSelected(sender:)), for: .touchUpInside)
            return cell
        }
    func tableView(_ tableView: UITableView, commit editingStyle:   UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            deletedIndexPath = indexPath
            questionID = contentListForAskedQues[deletedIndexPath!.row]["QuestionID"].stringValue
              self.hitServerForDelete(params: [:], endPoint: Endpoints.deleteContntQstonAskdBtnEndPoint + (self.questionID!) ,action: "contntQuestnDelete", httpMethod: .get)
            }
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ansWersVC = storyboard?.instantiateViewController(withIdentifier: "answer") as! AnswersVC
        print("cell clicked")
        questionID = contentListForAskedQues[indexPath.row]["QuestionID"].stringValue
        ansWersVC.questionID = self.questionID
        navigationController?.pushViewController(ansWersVC, animated: true)
      }
    }

extension ContentQuestionsAskedVC {
    private func hitServer(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
       // startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC")) /* Commented By Veeresh on 21st Feb 2020 */
        
        /* Added  By Veeresh on 21st Feb 2020 - starts here  */
        var shim = UIImageView()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: shim = UIImageView(image: UIImage(named: "question-thatyou-asked-mobile")!)
        case .pad: shim = UIImageView(image: UIImage(named: "question-thatyou-asked")!)// ; shim.contentMode = .topLeft
        case .unspecified: shim = UIImageView(image: UIImage(named: "question-thatyou-asked-mobile")!)
        case .tv: shim = UIImageView(image: UIImage(named: "question-thatyou-asked")!) ; shim.contentMode = .topLeft
        case .carPlay: shim = UIImageView(image: UIImage(named: "question-thatyou-asked-mobile")!)
        }//scaleAspectFill
         if contentListForAskedQues.count < 1 {   /* added by veeresh on 26/2/2020 */
                          tableView.backgroundView = shim  /* added by veeresh on 26/2/2020 */
                      shim.startShimmering()  /* added by veeresh on 26/2/2020 */
                      }  /* added by veeresh on 26/2/2020 */
     
       
         /* Added By Veeresh on 21st Feb 2020  - ends here */
        
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){ result in
            self.tableView.backgroundView = UIView()
            shim.stopShimmering()
            shim.removeFromSuperview()
            //self.stopAnimating()
            switch result {
            case let .success(json,requestType):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }
                else {
                    self.parseNDispayListData(json: json["ControlsData"]["AskedQuestionList"], requestType: requestType)
                    }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    
    //delete functionality
    private func hitServerForDelete(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){ result in
            self.stopAnimating()
            switch result {
            case let .success(json,_):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }
                else {
                    self.contentListForAskedQues.remove(at: self.deletedIndexPath!.row)
                    self.tableView.reloadData()
                    showMessage(bodyText: "Successfully Deleted",theme: .success,presentationStyle: .center, duration: .seconds(seconds: 1))
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    
    //edit functionality by Get
    private func hitServerForEditByGet(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){ result in
            self.stopAnimating()
            switch result {
            case let .success(json,_):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }
                else {
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    
    //edit functionality by Post
    private func hitServerForEditByPost(params: [String:Any],action: String) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: Endpoints.editUserAskedQuestionPostEndPoint, using: .post, dueToAction: action){ result in
            self.stopAnimating()
            switch result {
            case let .success(json,_):
                
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }else {
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }

    private func parseNDispayListData(json: JSON,requestType: String){
        contentListForAskedQues = json.arrayValue
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
