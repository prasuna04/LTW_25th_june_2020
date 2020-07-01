//  QuestionsThatCanYouAnsweredVC.swift
//  LTW
//  Created by Ranjeet Raushan on 12/12/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import NVActivityIndicatorView

enum PersonTypeForQuestionsThatCanYouAnsweredVC : Int {
    case Student = 1 // why i am using 1 here because another two person type will automatically take 2 & 3 and if i  will not put 1 here  it will consider 0 automatically and another two person type will become 1 and 2 and we will get wrong information.
    case Parent
    case Teacher
}

class QuestionsThatCanYouAnsweredVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    let subjects = UserDefaults.standard.array(forKey: "subjectArray") as! [String]
    var catagery:Int!
    @IBOutlet weak var tableView: UITableView!
    
    
    var questionsThatYouAnsweredList:  Array<JSON> = []
    var refreshControl = UIRefreshControl() // pull to refresh
    var userID: String!
    var questionID: String! // Added By Yashoda
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userID =  UserDefaults.standard.string(forKey: "userID")
        
        /* Commented By Yashoda on 20th Dec 2019 - starts here */
        //        tableView.delegate = self
        //        tableView.dataSource = self
        //        DispatchQueue.main.async {
        //            self.tableView.reloadData()
        //        }
        /* Commented By Yashoda on 20th Dec 2019 - ends here */
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(QuestionsThatCanYouAnsweredVC.pullToRefreshHitApiForQustonsThatUCanAnswrd),for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    //Added By Yashoda on 20th Dec 2019 - starts here
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let screenSize = UIScreen.main.bounds.size
        self.view.bounds.size = screenSize
        self.view.frame.origin.x = 0
        self.view.frame.origin.y = 0
    }
    //Added By Yashoda on 20th Dec 2019 - ends here
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /* Added By Yashoda on 20th Dec 2019 - starts here */
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true // Added By Yashoda on 20th Dec 2019
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        /* Don't Delete below single line commented code for future reference */
        // tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0) /* Programatically you can give constraints like this , actually  i already given constraints from storyboard so here it is not required */
        /* Added By Yashoda on 20th Dec 2019 - ends  here */
        
        if currentReachabilityStatus != .notReachable {
            hitServer(params: [:], endPoint: Endpoints.questionsThatCanYouAnsweredEndPoint + (self.userID!),  action: "QuestionsThatCanYouAnswered", httpMethod: .get)
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
            })
        }
    }
    //pull to refresh
    @objc func pullToRefreshHitApiForQustonsThatUCanAnswrd() {
        refreshControl.endRefreshing()
        if currentReachabilityStatus != .notReachable {
            hitServer(params: [:], endPoint: Endpoints.questionsThatCanYouAnsweredEndPoint + (self.userID!),  action: "QuestionsThatCanYouAnswered", httpMethod: .get)
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
                self.pullToRefreshHitApiForQustonsThatUCanAnswrd()
                self.refreshControl.endRefreshing()
            })
        }
    }
    /* Added by yasodha on 30/1/2020 -  starts here */
    @objc func uiViewWithImageTapped(sender: UITapGestureRecognizer) {
        print("uiViewWithImageTapped")
        let personalprofile = storyboard?.instantiateViewController(withIdentifier: "personalprofile") as! PersonalProfileVC
        var qstnAnsrdList: JSON
        qstnAnsrdList = questionsThatYouAnsweredList[sender.view!.tag]
        
        personalprofile.userID = qstnAnsrdList["UserID"].stringValue
        navigationController?.pushViewController(personalprofile, animated: false) /* comment this line when animation not required */
    }
    /*Added by yasodha on 30/1/2020 starts  - ends here */
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsThatYouAnsweredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! QuestionsThatCanYouAnsweredCell
        var qstnAnsrdList: JSON
        qstnAnsrdList = questionsThatYouAnsweredList[indexPath.row]
        // Added by dk on 19th june 2020.
        cell.trophyGrades.text = "\(qstnAnsrdList["AnswerPoints"].intValue) Points"
//        cell.subjctLbl.font = UIFont.boldSystemFont(ofSize: 13.0)/* I tried to put
//         "Roboto-Bold" , but it was not working properly so let it be boldSystemFont only to get the bold text  */
        cell.gradeLbl.text = qstnAnsrdList["Grade"].stringValue
        var dateString = qstnAnsrdList["AskedOn"].stringValue
        dateString = dateString.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        // For Decimal value
        cell.datLbl.text = DateHelper.localToUTC(date: dateString, fromFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "MMM dd, yyyy")
//        cell.datLbl.font = UIFont.boldSystemFont(ofSize: 13.0)/* I tried to put
//         "Roboto-Bold" , but it was not working properly so let it be boldSystemFont only to get the bold text  */
        cell.scholLbl.text = qstnAnsrdList["School"].stringValue
        let typeOfPersonForQuestionsThatCanYouAnsweredVC = PersonTypeForQuestionsThatCanYouAnsweredVC.init(rawValue: qstnAnsrdList["PersonType"].intValue)
        if typeOfPersonForQuestionsThatCanYouAnsweredVC != nil{
            cell.prsonTypLbl.text = "\(String(describing: typeOfPersonForQuestionsThatCanYouAnsweredVC!))"
//            cell.prsonTypLbl.font = UIFont.boldSystemFont(ofSize: 13.0)/* I tried to put
//             "Roboto-Bold" , but it was not working properly so let it be boldSystemFont only to get the bold text  */
        }
        cell.prsonNmLbl.text = qstnAnsrdList["FullName"].stringValue
        cell.prsonNmLbl.font = UIFont.boldSystemFont(ofSize: 13.0)/* I tried to put
         "Roboto-Bold" , but it was not working properly so let it be boldSystemFont only to get the bold text  */
        
        let stringUrl = qstnAnsrdList["ProfileURL"].stringValue
        let thumbnail = stringUrl.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
        cell.imgVw?.sd_setImage(with: URL.init(string:thumbnail ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
        
        
        /*Added by yasodha on 30/1/2020 starts here */
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.uiViewWithImageTapped))
        cell.imgVw.tag = indexPath.row
        // UserDefaults.standard.set( indexPath.row, forKey: "Profil_UserID_Question")//yasodha
        
        tap.numberOfTapsRequired = 1
        cell.imgVw.isUserInteractionEnabled = true
        cell.imgVw.addGestureRecognizer(tap)
        
        /*Added by yasodha on 30/1/2020 ends here */
        
        cell.whatIsYourQstnLbl.text = qstnAnsrdList["Questions"].stringValue
        cell.whatIsYourQstnLbl.font = UIFont.boldSystemFont(ofSize: 16.0)/* I tried to put
         "Roboto-Bold" , but it was not working properly so let it be boldSystemFont only to get the bold text  */
        cell.whatIsYourQstnLbl.textColor = UIColor.darkGray
        self.catagery = qstnAnsrdList["SubjectID"].intValue
        cell.subjctLbl.text = self.subjects[self.catagery-1]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ansWersVC = storyboard?.instantiateViewController(withIdentifier: "answer") as! AnswersVC
        print("cell clicked")
        questionID = questionsThatYouAnsweredList[indexPath.row]["QuestionID"].stringValue
        ansWersVC.questionID = self.questionID
        navigationController?.pushViewController(ansWersVC, animated: true)
    }
}

extension QuestionsThatCanYouAnsweredVC {
    private func hitServer(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        // startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))  /* Commented   By Veeresh on 21st Feb 2020  */
        /* Added  By Veeresh on 21st Feb 2020 - starts here */
        var shim = UIImageView()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: shim = UIImageView(image: UIImage(named: "my-content-mobile")!)
        case .pad: shim = UIImageView(image: UIImage(named: "my-content_1")!)// ; shim.contentMode = .topLeft
        case .unspecified: shim = UIImageView(image: UIImage(named: "my-content-mobile")!)
        case .tv: shim = UIImageView(image: UIImage(named: "my-content_1")!) ; shim.contentMode = .topLeft
        case .carPlay: shim = UIImageView(image: UIImage(named: "my-content-mobile")!)
        }//scaleAspectFill
        if questionsThatYouAnsweredList.count < 1 {   /* added by veeresh on 26/2/2020 */
            tableView.backgroundView = shim  /* added by veeresh on 26/2/2020 */
            shim.startShimmering()  /* added by veeresh on 26/2/2020 */
        }  /* added by veeresh on 26/2/2020 */
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){ result in
            self.tableView.backgroundView = UIView()
            shim.stopShimmering()
            shim.removeFromSuperview()
            /* Added  By Veeresh on 21st Feb 2020 - ends here */
            //  self.stopAnimating()  /* Commented By Veeresh on 21st Feb 2020 */
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
    private func parseNDispayListData(json: JSON,requestType: String){
        questionsThatYouAnsweredList = json.arrayValue
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
