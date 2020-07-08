//  AnswersVC.swift
//  LTW
//  Created by Ranjeet Raushan on 02/05/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON
import SwiftMessages
import SDWebImage
import NVActivityIndicatorView
import WebKit /* Added By Veeresh on 26th Dec 2019 */

enum PersonTypeForAnswersVC : Int {
    case Student = 1 // why i am using 1 here because another two person type will automatically take 2 & 3 and if i  will not put 1 here  it will consider 0 automatically and another two person type will become 1 and 2 and we will get wrong information.
    case Parent
    case Teacher
}

class AnswersVC: UIViewController, NVActivityIndicatorViewable, UITableViewDelegate, UITableViewDataSource  , WKNavigationDelegate{  /* Added UIWebViewDelegate, WKNavigationDelegate By Veeresh on 26th Dec 2019 */
    
    @IBOutlet weak var scrollVw: UIScrollView!
    @IBOutlet weak var contentVw: UIView!
    @IBOutlet weak var personImgVew: UIImageView!{
        didSet{
            personImgVew.setRounded()
            personImgVew.clipsToBounds = true
        }
    }
    
    
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var whatIsUrQstnLbl: UILabel!
    @IBOutlet weak var followUnfollowQstnBtn: UIButton!
    
    
    @IBOutlet weak var personNamLbl: UILabel!
    @IBOutlet weak var schoolLbl: UILabel!
    @IBOutlet weak var personTypeLbl: UILabel!
    @IBOutlet weak var numAnswrLbl: UILabel!
    @IBOutlet weak var writeAnSwerBtn: UIButton!{
        didSet{
            writeAnSwerBtn.backgroundColor = .clear
            writeAnSwerBtn.layer.cornerRadius = writeAnSwerBtn.frame.height / 2
            writeAnSwerBtn.layer.borderWidth = 1
            writeAnSwerBtn.layer.borderColor = UIColor.init(hex: "2DA9EC").cgColor
        }
    }
    @IBOutlet weak var trophy: UIImageView!
    @IBOutlet weak var answerPointsLbl: UILabel!
    @IBOutlet weak var tabLeView: UITableView!
    var answrElmntLst: Array<JSON> = []
    var userID: String!
    var auserid: String!
    var questionID: String!
    var answerID: String!
    var downVote: Int!
    var upVote: Int!
    var refreshControl = UIRefreshControl() // pull to refresh
    var userIdForQstn: String!
    /* Added By Veeresh on 19th Dec 2019 - starts here */
    var homePageIndex = 1
    var noOfItemsInaPage = 20
    var contentHeights : [CGFloat] = [0.0, 0.0]
    var content : [UILabel] = [UILabel(),UILabel()]   //added by veeresh on 30 th jan 2020
    var loaded = false
    /* Added By Veeresh on 19th Dec 2019 - ends here */
    var deletedIndexPath: IndexPath?
    var views = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Table View Border Width and Border Color Concept Starts Here */
        tabLeView.layer.borderColor = UIColor.init(hex: "DCDCDC").cgColor
        tabLeView.layer.borderWidth = 1.0
        /* Table View Border Width and Border Color Concept Ends Here */
        
        /* remove unwanted cells - starts here */
        self.tabLeView.tableFooterView = UIView()
        /* remove unwanted cells - ends here */
        
        tabLeView.delegate = self
        tabLeView.dataSource = self
        
        // pull to refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(AnswersVC.hitApi),for: .valueChanged)
        tabLeView.addSubview(refreshControl)
        
        DispatchQueue.main.async {
            self.tabLeView.reloadData()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.views.stopShimmering()
        self.views.removeFromSuperview()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        answerPointsLbl.isHidden = true
        trophy.isHidden = true
        //contentHeights = [0.0,0.0] // commented by veeresh on 17th-Jan-2020
        guard let navigationController = navigationController else { return }
        navigationController.view.backgroundColor = UIColor.init(hex: "2DA9EC")
        if (self.navigationController?.navigationBar) != nil {
            navigationController.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        }
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Answers"
        userID =  UserDefaults.standard.string(forKey: "userID")
        if currentReachabilityStatus != .notReachable {
            hitServer(params: [:], endPoint: Endpoints.getSearchQstnEndPoint + (self.questionID!) + "/" + (self.userID!) ,action: "getSearchQstn", httpMethod: .get)
            
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
            })
        }
    }
    //pull to refresh
    @objc func hitApi() {
        refreshControl.endRefreshing()
        if currentReachabilityStatus != .notReachable {
            hitServer(params: [:], endPoint: Endpoints.getSearchQstnEndPoint + (self.questionID!) + "/" + (self.userID!) ,action: "getSearchQstn", httpMethod: .get)
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
                self.hitApi()
                self.refreshControl.endRefreshing()
            })
        }
    }
    // on follow Question Button Click
    @IBAction func onFollowQstnBtnClk(_ sender: UIButton) {
        if self.currentReachabilityStatus != .notReachable {
            if !sender.isSelected {
                self.hitServer3(params: [:], endPoint: Endpoints.followQstnInAnswrsScreen + (self.userID!) + "/" +  (self.questionID!),  action: "follow Qstns In Answrs Screen", httpMethod: .get)
            }
            else{
                self.hitServer3(params: [:], endPoint: Endpoints.unFollowQstnInAnswrsScreen + (self.userID!) + "/" +  (self.questionID!),  action: "unFollow Qstns In Answrs Screen", httpMethod: .get)
            }
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
            })
        }
    }
    
    @IBAction func onWriteAnswrBtnClk(_ sender: UIButton) {
        
        /*commented by veeresh starts here /19/12/19 */
        //        let writeAnsr = storyboard?.instantiateViewController(withIdentifier: "writeanswer") as! WriteAnswerVC
        //        writeAnsr.questionID = self.questionID
        //        writeAnsr.modalTransitionStyle = .crossDissolve
        //        writeAnsr.modalPresentationStyle = .overCurrentContext
        //
        //        /*  to reload the Answer List in Answer VC from Write Answer VC - starts here */
        //        writeAnsr.refreshAnsVC = {[weak self] in
        //            guard let _self = self else {return}
        //            _self.viewWillAppear(true)
        //        }
        //        /*  to reload the Answer List in Answer VC from Write Answer VC - ends here */
        //
        //        self.present(writeAnsr, animated: true, completion: nil)
        /* commented by veeresh ends here /19/12/19 */
        
        /* below code is added by veeresh on 19/12/19 - starts here */
        let inlineKeyboard = storyboard?.instantiateViewController(withIdentifier: "KeyViewController") as! KeyViewController
        inlineKeyboard.questionID = self.questionID
        //        let nav = UINavigationController(rootViewController: inlineKeyboard)
        //        nav.modalPresentationStyle = .fullScreen    /* Added By Veeresh on 2nd jan 2020 */
        self.navigationController?.pushViewController(inlineKeyboard, animated: false)//addede by veeresh on 17/01/2020
        //  self.present(nav, animated: true, completion: nil)
        /* below code is added by veeresh on 19/12/19 - ends here */
    }
    
   /*  Modified By Ranjeet on 11th March 2020 - starts here  */
       // UpVote Button Action
       @objc func upVoteBtnSelected(sender: UIButton){
           let index = sender.tag
           userID =  UserDefaults.standard.string(forKey: "userID")
           auserid = answrElmntLst[index]["AUserID"].stringValue
           answerID = answrElmntLst[index]["AnswerID"].stringValue
           if userID == auserid{
               showMessage(bodyText: "For your own Answer You Can't Upvote", theme: .warning, duration: .seconds(seconds: 0.5))
           }
           else {
         
           answrElmntLst[index]["UpVote"].intValue = (answrElmntLst[index]["UpVote"].intValue + 1)
           upVote = answrElmntLst[index]["UpVote"].intValue
           print("upVote = \(upVote!)")
           sender.setTitle("\(upVote!)", for: .normal)
           print("clicked answerID = \(answerID!)")
           if answerID != nil {
           hitServer1(params: [:], endPoint: Endpoints.ansUpVoteEndPoint + (self.answerID!) + "/" + (self.userID!) ,action: "AnswerUpVoteAction", httpMethod: .get)
             }
               sender.isEnabled = false
               sender.isUserInteractionEnabled = false
           }
       }
           /*  Modified By Ranjeet on 11th March 2020 - ends here  */
    
    
    // Report Offensive Button
    @objc func reportOffensiveBtnSelected(sender: UIButton){
        print("answers clicked")
        userID = UserDefaults.standard.string(forKey: "userID")
        let index = sender.tag
        answerID = answrElmntLst[index]["AnswerID"].stringValue
        auserid = answrElmntLst[index]["AUserID"].stringValue
        self.deletedIndexPath = IndexPath(item: sender.tag, section: 0)
        let isIndexValid = answrElmntLst.indices.contains(self.deletedIndexPath!.row)
        if userID == auserid{
            showMessage(bodyText: "You can't report your own answer offensive.",theme: .warning, duration: .seconds(seconds: 0.5)) /*  Updated By Ranjeet on 12th March 2020 */
            return
        }
        else{
            let refreshAlert = UIAlertController(title: "Report Offensive", message: "Are you sure you want to report offensive?", preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                if isIndexValid{
                    self.hitServerForReportOffensive(params: [:], endPoint: Endpoints.answerReportOffensiveEndPoint + (self.answerID!) + "/" + (self.userID!) ,action: "ReportOffensiveAction", httpMethod: .get)
                }
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in
            }))
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answrElmntLst.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as! AnswerCell
        var ansList: JSON
        ansList  = answrElmntLst[indexPath.row]
        cell.personNameLbl.text = ansList["FirstName"].stringValue
        
        /* Commented By Veeresh on 19th Dec 2019 - starts here */
        //        cell.textAnswerLbl.text = ansList["Answers"].stringValue
        //
        //        /* html text to label text conversion in table view cell */
        //        if let data = ansList["Answers"].stringValue.data(using: String.Encoding.unicode){
        //            try? cell.textAnswerLbl.attributedText =
        //                NSAttributedString(data: data,
        //                                   options: [.documentType:NSAttributedString.DocumentType.html],
        //                                   documentAttributes: nil)
        //        } else {
        //            // for default cases
        //        }
        //        cell.textAnswerLbl.font = UIFont(name:"Roboto-Medium", size: 20.0)
        //        cell.textAnswerLbl.textColor = UIColor.darkGray
        //        /* html text to label text conversion in table view cell */
        /* Commented By Veeresh on 19th Dec 2019 - ends here */
        
        /* Added By Veeresh on 26th Dec 2019 - Starts here */
        /* Added By Veeresh on 30 jan 2020 - Starts here */
        contentHeights.append(0.0)
        content.append(UILabel())
        content[indexPath.row].numberOfLines = 0
        DispatchQueue.main.async{
            let rect = ansList["Answers"].stringValue.html2Attributed!.boundingRect(with: CGSize(width: self.view.frame.width - 40, height: 10000), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
            self.content[indexPath.row].frame = rect
        }
        /* Added By Veeresh on 30 jan 2020 - Starts here */
        cell.webView.scrollView.isScrollEnabled = true 
        cell.webView.tag = indexPath.row
        cell.webView.navigationDelegate = self
        let htmlString = ansList["Answers"].string!
        //let fontSize = 100
        //let fontSetting = "<span style=\"font-size: \(fontSize)\"</span>"
        //let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
        let htmlStart = "<HTML><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"></HEAD><BODY>"
        let htmlEnd = "</BODY></HTML>"
        
        // let setHeightUsingCSS = "<head><style type=\"text/css\"> img{ max-height: 100%; max-width: \(self.view.frame.width) !important; width: auto; height: auto;} </style> </head><body> \(htmlString!) </body>"
        let HtmlString = "\(htmlStart)\(htmlString)\(htmlEnd)"
        print(HtmlString)
        cell.webView.loadHTMLString(/*fontSetting+headerString+*/HtmlString , baseURL: nil)
        // cell.webView.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: contentHeights[indexPath.row])
        cell.webView.scrollView.bounces = false
        
        /* Added By Veeresh on 26th Dec 2019 - Ends here */
        
        let typeOfPersonForAnswersVC = PersonTypeForAnswersVC.init(rawValue: ansList["PersonType"].intValue)
        if typeOfPersonForAnswersVC != nil{
            cell.personTypLbl.text = "\(String(describing: typeOfPersonForAnswersVC!))"
        }
        cell.scholLbl.text = ansList["School"].stringValue
        var dateString = ansList["AnswerDate"].stringValue
        dateString = dateString.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        // For Decimal value
        cell.datLbl.text = DateHelper.localToUTC(date: dateString, fromFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "MMM dd, yyyy")
        let stringUrlForAnswersList = ansList["ProfileURL"].stringValue
        let thumbnailForAnswersList = stringUrlForAnswersList.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
        cell.personImgVw?.sd_setImage(with: URL.init(string:thumbnailForAnswersList),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
        // View tap related to  image
        /*Added by yasodha on 31/1/2020 starts here */
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.uiViewWithImageTapped))
        /* Added by yasodha on 30/1/2020 starts here*/
        cell.personImgVw.isUserInteractionEnabled = true
        tap1.numberOfTapsRequired = 1
        cell.personImgVw.tag = indexPath.row
        cell.personImgVw.addGestureRecognizer(tap1)
        /*Added by yasodha on 31/1/2020 ends here */
        
        /* let tap1 = UITapGestureRecognizer(target: self, action: #selector(uiViewWithImageTapped))
         cell.viewRelatedToImageInAnsrsScreen.tag = indexPath.row
         tap1.numberOfTapsRequired = 1
         cell.viewRelatedToImageInAnsrsScreen.isUserInteractionEnabled = true
         cell.viewRelatedToImageInAnsrsScreen.addGestureRecognizer(tap1)
         */
        
        
        
        
        
        /* Don't delete below note , it's a very strict warning to follow without commit this mistake once again in future .
         note: Don't load the image in DispatchQueue.main.async(){} cause it's freezing the UI most of the times and one more thing SDWebImage only handling all the threading related functionality in their own way. */
        
       /*  Modified By Ranjeet on 11th March 2020 - starts here  */
               // up vote
               cell.upVoteBtn.tag = indexPath.row
               cell.upVoteBtn.addTarget(self, action: #selector(upVoteBtnSelected(sender:)), for: .touchUpInside)
               cell.upVoteBtn.setTitle("\(ansList["UpVote"].intValue)", for: .normal)
               cell.upVoteBtn.isEnabled = true
               cell.upVoteBtn.isUserInteractionEnabled = true
                 /*  Modified By Ranjeet on 11th March 2020 - ends here  */
        
        // report offensive
        cell.spamBtn.tag = indexPath.row
        cell.spamBtn.addTarget(self, action: #selector(reportOffensiveBtnSelected(sender:)), for: .touchUpInside)
        return cell
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //navigationAction.request.url
        if let url = navigationAction.request.url {
           
            UIApplication.shared.openURL(url)
             decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    /* Added Below two table View And Web View Method Implemented By Veeresh on 26th Dec 2019 - starts here */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if contentHeights[indexPath.row] != 0 {
            print(contentHeights[indexPath.row])
            return contentHeights[indexPath.row]+180//tableView.frame.height//-contentHeights[indexPath.row]           //++++++++++++edited
        }
        return 200
        //        return CGFloat()
    }
    
    //changes made by veeresh on 30th jan 2020 starts from here******
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //webView.frame.size.height = 1 / Commented By Veeresh on 27th Dec 2019 /
        // webView.scrollView.isScrollEnabled=false / Commented By Veeresh on 2nd Jan 2020 /
        if (contentHeights[webView.tag] != 0.0)
        {
            return
        }
        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    print("here")
                    self.contentHeights[webView.tag] = self.content[webView.tag].frame.height
                    self.tabLeView.reloadRows(at: [IndexPath(row: webView.tag, section: 0)], with: .none) // Added By Veeresh on 2nd Jan 2020 /
                    print("the now =\(self.contentHeights[webView.tag]) the new =\(webView.scrollView.contentSize.height)")
                })
            }
            
        })
        tabLeView.reloadRows(at: [IndexPath(row: webView.tag, section: 0)], with: .none)
    }
    //changes made by veeresh on 30th jan 2020 ends here******
    
    
    /* Added Below two table View And Web View Method Implemented By Veeresh on 26th Dec 2019 - ends here */
    // If there is no data in table view
    private func NoItem(count: Int){
        if count > 0{
            tabLeView.backgroundView = nil
        }
        else {
            let noItemView  = UIView.fromNib() as NoListItem
            noItemView.frame = CGRect.init(x: tabLeView.bounds.midX, y: tabLeView.bounds.midY, width: tabLeView.bounds.size.width, height: tabLeView.bounds.size.height)
            tabLeView.backgroundView  = noItemView
            tabLeView.separatorStyle  = .none
        }
    }
    @objc func uiViewWithImageTapped(sender: UITapGestureRecognizer) {
        print("uiViewWithImageTapped")
        let personalprofile = storyboard?.instantiateViewController(withIdentifier: "personalprofile") as! PersonalProfileVC
        let obj = answrElmntLst[(sender.view?.tag)!]
        userID = obj["AUserID"].stringValue
        personalprofile.userID = self.userID
        navigationController?.pushViewController(personalprofile, animated: true)
    }
    /*Added by yasodha on 31/1/2020 starts here*/
    @objc func personImgVewTappedMethod(sender: UITapGestureRecognizer){
        print("*personImgVewTappedMethod*")
        let personalprofile = storyboard?.instantiateViewController(withIdentifier: "personalprofile") as! PersonalProfileVC
        
        UserDefaults.standard.string(forKey: "personImgVewAnswer")
        personalprofile.userID = UserDefaults.standard.string(forKey: "personImgVew_Answer")
        navigationController?.pushViewController(personalprofile, animated: true)
        
    }
    
    /*Added by yasodha on 31/1/2020 ends here */
    
    
}
extension AnswersVC {
    func hideEverything(_ no : Int){
    let cond = (no == 1 ? true : false )
    tabLeView.isHidden = cond   /* Added By Veeresh on 10th April 2020 */
    personImgVew.isHidden = cond
    personNamLbl.isHidden=cond
    personTypeLbl.isHidden=cond
    followUnfollowQstnBtn.isHidden=cond
    numAnswrLbl.isHidden=cond
    schoolLbl.isHidden=cond
    whatIsUrQstnLbl.isHidden=cond
    writeAnSwerBtn.isHidden=cond
    cardView.isHidden=cond
    }
    private func hitServer(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        //startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))  /* Commented  By Veeresh on 21st Feb 2020  */
        /* Added  By Veeresh on 21st Feb 2020 - starts here */
      var shim = UIImageView()
       views = UIView()
       switch UIDevice.current.userInterfaceIdiom {
       case .phone: shim = UIImageView(image: UIImage(named: "answers-iphone")) ; shim.contentMode = .scaleToFill
       shim.frame=CGRect(x: 0, y: 0, width: self.view.frame.width - 20, height: self.view.frame.height - 90)
       views.frame=CGRect(x: 10, y: 0, width: self.view.frame.width - 20, height: self.view.frame.height - 110)
       case .pad: shim = UIImageView(image: UIImage(named: "answers-ipad")) ; shim.contentMode = .scaleToFill
       views.frame=CGRect(x: 10, y: 0, width: self.view.frame.width - 10, height: self.view.frame.height - 110)
       shim.frame=CGRect(x: 0, y: 0, width: self.view.frame.width - 20, height: self.view.frame.height - 200)
       case .unspecified: shim = UIImageView(image: UIImage(named: "my-group-mobile")!)
       case .tv: shim = UIImageView(image: UIImage(named: "my-group-ipad")!) ; shim.contentMode = .topLeft
       case .carPlay: shim = UIImageView(image: UIImage(named: "my-group-mobile")!)
       }//scaleAspectFill
       views.alpha = 1
       views.addSubview(shim)
//       views.pinAllEdges(ofSubview: shim)
       views.backgroundColor = UIColor.white
       views.layer.zPosition = CGFloat(MAXFLOAT)
       view.addSubview(views)
       view.bringSubviewToFront(views)
       hideEverything(1)
       views.startShimmering()
       shim.startShimmering()
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){ result in
           self.hideEverything(0)
            self.views.stopShimmering()
            self.views.removeFromSuperview()
            /* Added  By Veeresh on 21st Feb 2020 - ends here */
            
            //self.stopAnimating()  /* Commented By Veeresh on 21st Feb 2020  */
            switch result {
            case let .success(json,requestType):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }
                else  {
                    print(json["ControlsData"])
                    self.parseNDispayListData1(json: json["ControlsData"]["lsv_Que"], requestType: requestType)
                    self.parseNDispayListData2(json: json["ControlsData"]["lsv_Qanswers"], requestType: requestType)
                    self.numAnswrLbl.text = "\(json["ControlsData"]["Answer_Count"].intValue) Answer"
                    self.answerPointsLbl.isHidden = false
                    self.trophy.isHidden = false
                    self.answerPointsLbl.text = "\(json["ControlsData"]["lsv_Que"]["AnswerPoints"].intValue) Points"
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    
    // upVote Action
    private func hitServer1(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){ result in
            switch result {
            case let .success(json,_):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }
                else  {
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    
    //follow Qstn In Answrs Screen
    private func hitServer3(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
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
                    if requestType == "follow Qstns In Answrs Screen" {
                        self.followUnfollowQstnBtn.isSelected = !self.followUnfollowQstnBtn.isSelected
                        showMessage(bodyText: "Question Followed Successfully",theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.01))
                    }
                    else if requestType == "unFollow Qstns In Answrs Screen"{
                        self.followUnfollowQstnBtn.isSelected = !self.followUnfollowQstnBtn.isSelected
                        showMessage(bodyText: "Question UnFollowed Successfully",theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.01))
                    }
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    
    // report offensive
    
    private func hitServerForReportOffensive(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){[weak self] result in
            guard let _self = self else {
                return
            }
            _self.stopAnimating()
            switch result {
            case let .success(json,_):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }
                else  {
                    _self.answrElmntLst.remove(at: _self.deletedIndexPath!.row)
                    _self.tabLeView.reloadData()
                    showMessage(bodyText: "Successfully Reported Offensive",theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.01))
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    
    private func parseNDispayListData1(json: JSON,requestType: String){
        whatIsUrQstnLbl.text = json["Question"].stringValue
        //        // html text to label text conversion in table view cell
        //        if let data = json["Question_html"].stringValue.data(using: String.Encoding.unicode){
        //            try? whatIsUrQstnLbl.attributedText =
        //                NSAttributedString(data: data,
        //                                   options: [.documentType:NSAttributedString.DocumentType.html],
        //                                   documentAttributes: nil)
        //
        //        } else {
        //            // for default cases
        //        }
        whatIsUrQstnLbl.font = UIFont.boldSystemFont(ofSize: 16.0)/* I tried to put
         "Roboto-Bold" , but it was not working properly so let it be boldSystemFont only to get the bold text  */
        whatIsUrQstnLbl.textColor = UIColor.darkGray
        
        personNamLbl.text =  json["FirstName"].stringValue
        schoolLbl.text = json["School"].stringValue
        UserDefaults.standard.set(json["UserID"].stringValue, forKey: "personImgVew_Answer")//yasodha
        
        let stringUrlForQstnsInAnsrsScreen = json["ProfileUrl"].stringValue
        let thumbnailForQstnsInAnsrsScreen = stringUrlForQstnsInAnsrsScreen.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
        self.personImgVew?.sd_setImage(with: URL.init(string:thumbnailForQstnsInAnsrsScreen),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
        /*Added by yasodha on 31/1/2020 starts here */
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.personImgVewTappedMethod))
        self.personImgVew.isUserInteractionEnabled = true
        self.personImgVew.addGestureRecognizer(tapGestureRecognizer)
        /*Added by yasodha on 31/1/2020 ends here */
        
        
        
        
        
        /* Don't delete below note , it's a very strict warning to follow without commit this mistake once again in future .
         note: Don't load the image in DispatchQueue.main.async(){} cause it's freezing the UI most of the times and one more thing SDWebImage only handling all the threading related functionality in their own way. */
        
        let typeOfPersonForAnswersVC = PersonTypeForAnswersVC.init(rawValue: json["PersonType"].intValue)
        if typeOfPersonForAnswersVC != nil{
            personTypeLbl.text = "\(String(describing: typeOfPersonForAnswersVC!))"
            
            if json["isFollow"].intValue == 1 {
                followUnfollowQstnBtn.isSelected = true
            }else {
                followUnfollowQstnBtn.isSelected = false
            }
            userIdForQstn = json["UserID"].stringValue
            if userID == userIdForQstn
            {
                followUnfollowQstnBtn.isHidden = true
            }
            else{
                followUnfollowQstnBtn.isHidden = false
            }
        }
    }
    private func parseNDispayListData2(json: JSON,requestType: String){
        answrElmntLst = json.arrayValue
        DispatchQueue.main.async {
            self.tabLeView.reloadData()
            self.NoItem(count: self.answrElmntLst.count) // If there is no data in table view
        }
    }
}
//added by veeresh on 19/2/2020
extension UIView {
    
    func startShimmering() {
        let light = UIColor.white.cgColor
        let alpha = UIColor.white.withAlphaComponent(0.4).cgColor
        let gradient = CAGradientLayer()
        gradient.colors = [alpha, light, alpha]
        gradient.frame = CGRect(x: -self.bounds.size.width, y: 0, width: 3 * self.bounds.size.width, height: self.bounds.size.height)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.8)
        gradient.locations = [0.4, 0.5, 0.6]
        self.layer.mask = gradient
        let animation = CABasicAnimation(keyPath: "locations")
        
        
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 1.2
        animation.repeatCount = HUGE
        gradient.add(animation, forKey: "shimmer")
    }
    
    
    func stopShimmering(){
        self.layer.mask = nil
    }
    
    
    func startShimmering1() {
        let light = UIColor.white.cgColor
        let alpha = UIColor.white.withAlphaComponent(0.4).cgColor
        let gradient = CAGradientLayer()
        gradient.colors = [alpha, light, alpha]
        gradient.frame = CGRect(x: 0, y: 0, width: 3 * self.bounds.size.width, height: self.bounds.size.height)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.locations = [0,0.4,0.8, 1]
        self.layer.mask = gradient
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 1.5
        animation.repeatCount = HUGE
        gradient.add(animation, forKey: "shimmer")
    }
    
    
    func stopShimmering1(){
        self.layer.mask = nil
    }
}
