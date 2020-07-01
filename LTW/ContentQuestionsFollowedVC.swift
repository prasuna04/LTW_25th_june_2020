//  ContentQuestionsFollowedVC.swift
//  LTW
//  Created by Ranjeet Raushan on 20/07/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import SwiftMessages
import NVActivityIndicatorView

class ContentQuestionsFollowedVC: UIViewController,UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    @IBOutlet weak var scrollVw: UIScrollView!
    @IBOutlet weak var contentVw: UIView!
    @IBOutlet weak var tableView: UITableView!
  
    var userID: String!
    var contentListForFollowedQues: Array<JSON> = []
    var refreshControl = UIRefreshControl() // pull to refresh
    var createdDate: String!
    var questionID: String!
    var questions: String!
    var question_html: String!
    var deletedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userID =  UserDefaults.standard.string(forKey: "userID")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let navigationController = navigationController else { return }
        navigationController.view.backgroundColor = UIColor.white 
        if (self.navigationController?.navigationBar) != nil {
            navigationController.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        }
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Questions Followed"
        
        //pull to refresh For Questions Asked
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(ContentQuestionsFollowedVC.hitApiForQuestionsFollowed),for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        if currentReachabilityStatus != .notReachable {
            hitServer(params: [:], endPoint: Endpoints.contentQstonFolowEndPoint + (self.userID!),  action: "ContentFollowedQuestions", httpMethod: .get)
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
            })
        }
    }
    
    @objc func hitApiForQuestionsFollowed() {
        refreshControl.endRefreshing()
        if currentReachabilityStatus != .notReachable {
        hitServer(params: [:], endPoint: Endpoints.contentQstonFolowEndPoint + (self.userID!),  action: "ContentFollowedQuestions", httpMethod: .get)
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
                self.hitApiForQuestionsFollowed()
                self.refreshControl.endRefreshing()
            })
        }
    }
    
    // unfollow functionality
    @objc func unfollowBtnSelected(sender: UIButton){
        let refreshAlert = UIAlertController(title: "Unfollow", message: "Are you sure you want unfollow this ?", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Unfollow Button Clicked")
            let index = sender.tag
            self.questionID = self.contentListForFollowedQues[index]["QuestionID"].stringValue
            self.deletedIndexPath = IndexPath(item: sender.tag, section: 0)
            let isIndexValid = self.contentListForFollowedQues.indices.contains(self.deletedIndexPath!.row)
            if self.currentReachabilityStatus != .notReachable {
                if isIndexValid{
                    self.questionID =  self.contentListForFollowedQues[self.deletedIndexPath!.row]["QuestionID"].stringValue
                    self.hitServerForUnfollow(params: [:], endPoint: Endpoints.unFollowQstnInAnswrsScreen + (self.userID!) + "/" +  (self.questionID!) ,action: "contntFollowedQstnUnfollow", httpMethod: .get)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentListForFollowedQues.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Content Questions Followed
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentQuestionFollowedCell", for: indexPath) as! ContentQuestionsFollowedCell
        var contentFolowedList: JSON
        contentFolowedList = contentListForFollowedQues[indexPath.row]
        var dateString = contentFolowedList["CreatedDate"].stringValue
        dateString = dateString.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        // For Decimal value
        cell.askedOnDateLbl.text = "Asked on:\(DateHelper.localToUTC(date: dateString, fromFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "MMM dd, yyyy"))"
        cell.questionsAskedLbl.text = contentFolowedList["Questions"].stringValue
        if let data = contentFolowedList["Question_html"].stringValue.data(using: String.Encoding.unicode){
            try? cell.questionsAskedLbl.attributedText =
                NSAttributedString(data: data,
                                   options: [.documentType:NSAttributedString.DocumentType.html],
                                   documentAttributes: nil)
            
        } else {
            // for default cases
        }
        cell.questionsAskedLbl.font = UIFont(name:"Roboto-Medium", size: 16.0)
        cell.questionsAskedLbl.textColor = UIColor.init(hex:"2DA9EC")
        cell.contntUnfollowBtn.tag = indexPath.row
        cell.contntUnfollowBtn.addTarget(self, action: #selector(unfollowBtnSelected(sender:)), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ansWersVC = storyboard?.instantiateViewController(withIdentifier: "answer") as! AnswersVC
        print("cell clicked")
        questionID = contentListForFollowedQues[indexPath.row]["QuestionID"].stringValue
        ansWersVC.questionID = self.questionID
        navigationController?.pushViewController(ansWersVC, animated: true)
    }
}
extension ContentQuestionsFollowedVC {
    private func hitServer(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){ result in
            self.stopAnimating()
            switch result {
            case let .success(json,requestType):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }
                else {
                    self.parseNDispayListData(json: json["ControlsData"]["QueListFollowing"], requestType: requestType)
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    //delete functionality
    private func hitServerForUnfollow(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
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
                    self.contentListForFollowedQues.remove(at: self.deletedIndexPath!.row)
                    self.tableView.reloadData()
                    showMessage(bodyText: "Successfully Unfollowed",theme: .success,presentationStyle: .center, duration: .seconds(seconds: 1))
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    private func parseNDispayListData(json: JSON,requestType: String){
        contentListForFollowedQues = json.arrayValue
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
