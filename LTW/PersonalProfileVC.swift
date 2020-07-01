//  PersonalProfileVC.swift
//  LTW
//  Created by Ranjeet Raushan on 23/09/19.
//  Copyright © 2019 vaayoo. All rights reserved.


import UIKit
import SDWebImage
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView
import SwiftMessages
import AVFoundation
import AVKit
import SafariServices

enum PersonTypeForPersoanlProfileVC: Int {
    case Student = 1 // why i am using 1 here because another two person type will automatically take 2 & 3 and if i  will not put 1 here  it will consider 0 automatically and another two person type will become 1 and 2 and we will get wrong information.
    case Parent
    case Teacher
}
class PersonalProfileVC: UIViewController,NVActivityIndicatorViewable {
     var boards = ["1":"CBSE","2":"ICSE","3":"IGCSE","4":"IB","5":"Others","6":"US Common Core"] // add by chandra
    @IBOutlet weak var topHightConstraintToRatiogStudent: NSLayoutConstraint!
    // add by chandra for showing the points
    @IBOutlet weak var pointsLbl: UILabel! // add by chandra for points
     var firistNamepass:String!
     var lastNamepass:String!
     var ratingpass:Int!
     var userIdPass:String!
    var personalProfileUrl:String!
    //    add by chandra start here
    var MainvideoUrlArr = [JSON]() // for videos checking
    var uploadVideosArr = [JSON]()
    var linkVideosArr = [JSON]()
    var onlyLinkVideosArr = [String]()
    var tutorInfo:JSON!
    var chuckdata:JSON!
     var views = UIView()
    @IBOutlet weak var review: UIButton!
    @IBOutlet weak var demoLinksHight: NSLayoutConstraint!
    @IBOutlet weak var demoClassVideosHight: NSLayoutConstraint!
    @IBOutlet weak var collectionView2:UICollectionView!
    @IBOutlet weak var collectionView:UICollectionView!
    var TutorDemoVideos = [JSON]()
    var randomList = [String]()
    let subjects = UserDefaults.standard.array(forKey: "subjectArray") as! [String]
    @IBOutlet weak var totalHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var hightConstrainForViewTwo: NSLayoutConstraint!
    @IBOutlet weak var hightConstraintForViewOne: NSLayoutConstraint!
    @IBOutlet weak var cardViewOne: UIView!
    @IBOutlet weak var cardViewTwo: UIView!
//    @IBOutlet weak var cardViewThree: UIView!
    @IBOutlet weak var demoClassVideos: UILabel!
    @IBOutlet weak var demoClassLinks: UILabel!
    
    @IBOutlet weak var cardViewFour: CardView!
    @IBOutlet weak var cosmos: CosmosView!
    @IBOutlet weak var currentEducation: UILabel!
    @IBOutlet weak var school1: UILabel!
    @IBOutlet weak var grades: UILabel!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var workExperience: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var aboutYourProfession: UITextView!
    //    ends here
    @IBOutlet weak var prsonalPrflCardView: CardView!
    @IBOutlet weak var profileIV: UIImageView!{
        didSet{
            profileIV.setRounded()
            profileIV.layer.shadowColor = UIColor.gray.cgColor
            profileIV.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
            profileIV.layer.shadowRadius = 5.0
            profileIV.layer.shadowOpacity = 0.8
        }
    }
    // new add by chandra start here
     @IBOutlet weak var bord: UILabel!
     @IBOutlet weak var occupation: UILabel!
    // new add by chandra ends here
    @IBOutlet weak var prsonsFrstNm: UILabel!{
        didSet{
            prsonsFrstNm.font = UIFont.boldSystemFont(ofSize: 16.0)/* I tried to put
             "Roboto-Bold" , but it was not working properly so let it be boldSystemFont only to get the bold text  */
        }
    }
    @IBOutlet weak var prsonLstNm: UILabel!{
        didSet{
            prsonLstNm.font = UIFont.boldSystemFont(ofSize: 16.0)
        }
    }
    @IBOutlet weak var prsonTyp: UILabel!{
        didSet{
            prsonTyp.font = UIFont.boldSystemFont(ofSize: 16.0)
        }
    }
    @IBOutlet weak var school: UILabel!{
        didSet{
            school.font = UIFont.boldSystemFont(ofSize: 16.0)
        }
    }
    @IBOutlet weak var followUnfollowUserBtn: UIButton!
    
//    @IBOutlet weak var rewardsStackViewtopersonTypAndScholSeprtorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var folowBtnToPrsonTypAndScholSprtrHgtConstnt: NSLayoutConstraint!
    @IBOutlet weak var numberOfQuesnsAskdLbl:UILabel!
    @IBOutlet weak var numberOfQuesnsAnsrdLbl:UILabel!
    @IBOutlet weak var clsTknLbl:UILabel!
    @IBOutlet weak var testDlvrdLbl:UILabel!
    
    // @IBOutlet weak var testTknLbl:UILabel! /* Commented By Ranjeet on 27th Jan 2020 */
    
    var personType : Int!
    
    /* Added By Yashoda  on 17th Jan 2020 - starts here */
    @IBOutlet weak var numberOfQuesnsAskdLblTouch: UILabel!
    @IBOutlet weak var numberOfQuesnsAnsrdLblTouch: UILabel!
    @IBOutlet weak var clsTypeLbl: UILabel!//yasodha
    @IBOutlet weak var testTypeLbl: UILabel!//yasodha
    /* Added By Yashoda  on 17th Jan 2020 - ends here */
    
    var userID: String!
    var quserID: String!
    override func viewDidLoad() {
        super.viewDidLoad()

        cosmos.settings.updateOnTouch = false
        cosmos.settings.fillMode = .precise
        /*
         Don't delete below comment , this is for future reference.
         In this screen don't read the userID from userDefaults , cause from Previous(Home)
         screen i am passing quserid , so no need to read global userID from user defaults i.e,
         userID =  UserDefaults.standard.string(forKey: "userID")
         */
                if currentReachabilityStatus != .notReachable {
       
                    let endpoint = Endpoints.userProfileEndPoint  + (self.userID) + "?LoggedInUserID=" + (UserDefaults.standard.string(forKey: "userID")!)
                    UserDefaults.standard.set(self.userID!, forKey: "personalprofile")//yasodha
                    hitServer(params: [:], endPoint:  endpoint  ,  action: "personalProfile", httpMethod: .get)   /* Added By Yashoda on 27th Jan 2020 */
                } else {
                    showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
                    })
                }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
         views.removeFromSuperview()
                   views.stopShimmering()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.navigationController?.navigationBar) != nil {
            navigationController?.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
            navigationController?.view.backgroundColor = UIColor.init(hex: "2DA9EC") /* to resolve black bar problem appears on navigation bar when pushing view controller */
        }
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
          navigationItem.title = "Profile" /*  Added By Ranjeet on 31st March 2020 */
    }
    
    @IBAction func onReviewBtnClick(_ sender: UIButton) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let containerView = storyBoard.instantiateViewController(withIdentifier: "RatingAndReviewContainerViewController") as! RatingAndReviewContainerViewController
        containerView.profileUserId = userIdPass
        self.navigationController?.pushViewController(containerView, animated: true)
    }
    
    @IBAction func onFollowUnfollowUserBtnClk(_ sender: UIButton) {
        if self.currentReachabilityStatus != .notReachable {
            if !sender.isSelected {
                let endPoint1 = "\(Endpoints.userFollowEndPoint)\(UserDefaults.standard.string(forKey: "userID")!)/\(self.userID!)/\(1)"
                self.hitServerForFollowUsers(params: [:], endPoint: endPoint1 ,  action: "followUser", httpMethod: .get)
            }
            else{
                let endPoint2 = "\(Endpoints.userFollowEndPoint)\(UserDefaults.standard.string(forKey: "userID")!)/\(self.userID!)/\(0)"
                self.hitServerForFollowUsers(params: [:], endPoint: endPoint2,  action: "unFollowUser", httpMethod: .get)
            }
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
            })
        }
    }
}
func getThumbnailFrom(path: URL) -> UIImage? {
    do {
        let asset = AVURLAsset(url: path , options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
        let thumbnail = UIImage(cgImage: cgImage)
        return thumbnail
    } catch let error {
        print("*** Error generating thumbnail: \(error.localizedDescription)")
        return nil
    }
}
extension PersonalProfileVC{
    func hideEverything(_ no : Int){
    let cond = (no == 1 ? true : false )
    prsonalPrflCardView.isHidden=cond
    cardViewOne.isHidden=cond
    demoClassVideos.isHidden=cond
    cardViewTwo.isHidden=cond
//    cardViewThree.isHidden=cond
    cardViewFour.isHidden=cond
    }
    private func hitServer(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
       // startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        /* added by veeresh on 28th march atart here */
        // Asset 20
       var shim = UIImageView()
        views = UIView()
        views = UIView()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: shim = UIImageView(image: UIImage(named: "Asset 63-iphone")) ; shim.contentMode = .scaleToFill
        views.frame=CGRect(x: 10, y: 0, width: self.view.frame.width - 20, height: self.view.frame.height - 70)
        shim.frame=CGRect(x: 0, y: 0, width: self.view.frame.width - 20, height: self.view.frame.height - 90)
        case .pad: shim = UIImageView(image: UIImage(named: "Asset 60")) ; shim.contentMode = .scaleToFill
        views.frame=CGRect(x: 10, y: 0, width: self.view.frame.width - 10, height: self.view.frame.height - 90)
        shim.frame=CGRect(x: 0, y: 0, width: self.view.frame.width - 20, height: self.view.frame.height - 200)
        case .unspecified: shim = UIImageView(image: UIImage(named: "my-group-mobile")!)
        case .tv: shim = UIImageView(image: UIImage(named: "my-group-ipad")!) ; shim.contentMode = .topLeft
        case .carPlay: shim = UIImageView(image: UIImage(named: "my-group-mobile")!)
        }
        views.addSubview(shim)
//        views.pinAllEdges(ofSubview: shim)
        views.backgroundColor = UIColor.white
        views.layer.zPosition = CGFloat(MAXFLOAT)
        view.addSubview(views)
        view.bringSubviewToFront(views)
        views.startShimmering()
        hideEverything(1)
        //self.view.addSubview(shim)
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){ [weak self] result in
            guard let _self = self else {
                return
            }
           _self.hideEverything(0)
            _self.views.removeFromSuperview()
            _self.views.stopShimmering()
           // _self.stopAnimating()
            switch result {
            case let .success(json,requestType):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }
                else {
                    _self.chuckdata = json["ControlsData"]["tutorInfo"]
                    print( _self.chuckdata)
                    if _self.chuckdata.isEmpty {
                        print("datanil")
                        _self.totalHightConstraint.constant = 25
                        _self.cardViewOne.isHidden = true
                        _self.demoClassLinks.isHidden = true
                        _self.demoClassVideos.isHidden = true
                    }else{
                        // add by chandra for occupation display 18 2020
                        var res = json["ControlsData"]["tutorInfo"]["CurrentOccupation"].stringValue
                        let str = res.split(separator: ",")
                        for i in 0..<str.count {
                        let temp = str[i]
                        if temp.contains("1"){
                            res = res.replacingOccurrences(of: "1", with: "Teacher")
                        }
                        else if temp.contains("2"){
                            res = res.replacingOccurrences(of: "2", with: "Professional")
                            } else if temp.contains("3"){
                            res = res.replacingOccurrences(of: "3", with: "Student")
                            }else if temp.contains("4"){
                            res = res.replacingOccurrences(of: "4", with: "Not working")
                            } else if temp.contains("4"){
                            res = res.replacingOccurrences(of: "5", with: "Other")
                            }
                        }
                        self!.occupation.text = res
                        // add by chandra for occupation display 18 2020
                        // add by chandra for bords display 18 2020
                        let data = json["ControlsData"]["tutorInfo"]["BoardsCanTeach"].stringValue
                        let dataTwo = data.split(separator: ",").map { String($0) }
                               
                        if dataTwo.count != 0{
                            _self.bord.text!.removeAll()
                                }
                        for i in dataTwo{
                            let bordsLblData = self!.boards[i]!
                            if(self!.bord.text!.isEmpty){
                                self!.bord.text! = bordsLblData
                                    }else{
                                self!.bord.text! += "," + bordsLblData
                                        }
                                }
                        // add by chandra for bords display 18 2020
                         _self.tutorInfo = json["ControlsData"]["tutorInfo"]
                        let rating = json["ControlsData"]["tutorInfo"]["Rating"].intValue
                        self!.ratingpass = rating //self. add by chandra
                        self!.cosmos.rating =  rating == 0 ? 2.5 : Double(rating) /* added by veeresh on 3rd april 2020 */
                        let ReviewCount = json["ControlsData"]["tutorInfo"]["ReviewCount"].intValue // add by chandra
                        self?.review.setTitle("\(ReviewCount) Review", for: .normal)// add by chandra
                         _self.TutorDemoVideos = json["ControlsData"]["tutorInfo"]["TutorDemoVideos"].arrayValue
                        
                        for i in 0..<self!.TutorDemoVideos.count{
                            let checkVideos  = self!.TutorDemoVideos[i]
                            let data = checkVideos["VideoUrl"].stringValue
                            if data.contains("ltwuploadcontent"){
                                _self.uploadVideosArr.append(self!.TutorDemoVideos[i])
                                if _self.uploadVideosArr.count == 0{
                                    _self.hightConstraintForViewOne.constant = 200
                                }else{
                                    _self.hightConstraintForViewOne.constant = 350
                                }
                               
                            }else{
                                _self.uploadVideosArr.append(self!.TutorDemoVideos[i])
                                if _self.linkVideosArr.count == 0{
                                    _self.hightConstraintForViewOne.constant = 200
                                }else{
                                    _self.hightConstraintForViewOne.constant = 350
                                }
                               
                            }
                        }
                        _self.collectionView.reloadData()
//                        _self.collectionView2.reloadData()
                        
                        for i in 0..<self!.TutorDemoVideos.count{
                            let index = self!.TutorDemoVideos[i]
                            let url = index["VideoUrl"].stringValue
                            if url.contains("ltwuploadcontent"){
                                print(url)
                            }else{
                                self!.onlyLinkVideosArr.append(url)
                               print(self!.onlyLinkVideosArr.append(url))
                            }
                        }
                    }
                    _self.parseNDispayListData(json: json["ControlsData"]["ProfileData"], requestType: requestType) // Changed UserData to ProfileData by Yashoda on 27th Jan 2020
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    private func parseNDispayListData(json: JSON,requestType: String){
        let stringUrlForPrsnalProfile = json["ProfileUrl"].stringValue
        let thumbnailForPersonalProfile = stringUrlForPrsnalProfile.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
        self.profileIV?.sd_setImage(with: URL.init(string:thumbnailForPersonalProfile ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
        /* Don't delete below note , it's a very strict warning to follow without commit this mistake once again in future.
         note: Don't load the image in DispatchQueue.main.async(){} cause it's freezing the UI most of the times and one more thing SDWebImage only handling all the threading related functionality in their own way. */
        
        prsonsFrstNm.text = json["FirstName"].stringValue
        firistNamepass = json["FirstName"].stringValue
        prsonLstNm.text = json["LastName"].stringValue
        lastNamepass = json["LastName"].stringValue
        personType = json["PersonType"].intValue
        userIdPass = json["UserID"].stringValue
        personalProfileUrl = json["ProfileUrl"].stringValue
        // add by chandra for displaying my points
               let stringValue = "Points: \(json["MyPoints"].stringValue)"
               let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
               attributedString.setColor(color: UIColor.init(hex: "2DA9EC"), forText: "Points")
               pointsLbl.attributedText = attributedString
               // add by chandra for displaying my points
        print(userIdPass)
        
        let PersonType = json["PersonType"].stringValue
                if PersonType == "1"{
                    cosmos.isHidden = true
                    review.isHidden = true
                    topHightConstraintToRatiogStudent.constant = 0
                }else{
                    cosmos.isHidden = false
                    review.isHidden = false
                    topHightConstraintToRatiogStudent.constant = 51
                }
        
        let typeOfPersonForPersonalProfileVC = PersonTypeForPersoanlProfileVC.init(rawValue: json["PersonType"].intValue)
        if typeOfPersonForPersonalProfileVC != nil{
            prsonTyp.text = "\(String(describing: typeOfPersonForPersonalProfileVC!))"
        }
        school.text = json["Schools"].stringValue
        if json["isFollowing"].intValue == 1 {
            followUnfollowUserBtn.isSelected = true
        }else {
            followUnfollowUserBtn.isSelected = false
        }
        if userID ==  UserDefaults.standard.string(forKey: "userID")                   {
            followUnfollowUserBtn.isHidden = true
            folowBtnToPrsonTypAndScholSprtrHgtConstnt.constant = 0
//            rewardsStackViewtopersonTypAndScholSeprtorHeightConstraint.constant =  5
//            self.prsonalPrflCardView.frame.size.height =  230
        }
        else{
            followUnfollowUserBtn.isHidden = false
            folowBtnToPrsonTypAndScholSprtrHgtConstnt.constant = 45
            //folowBtnToPrsonTypAndScholSprtrHgtConstnt.constant = 55
           // self.prsonalPrflCardView.frame.size.height = 285
        }
        numberOfQuesnsAskdLbl.text = json["QuestionAsked"].stringValue
        numberOfQuesnsAnsrdLbl.text = json["AnswerGiven"].stringValue
        //
        //        clsTknLbl.text = json["ClassDelivered"].stringValue  /* Commented  By Yashoda on 27th Jan 2020  */
        //        testDlvrdLbl.text = json["TestsConducted"].stringValue  /* Commented  By Yashoda on 27th Jan 2020  */
        
        /* Added By Yashoda on 27th Jan 2020 - starts  here */
        if json["PersonType"].intValue == 1{
            clsTypeLbl.text = "Class Attended"
           // testTypeLbl.text = "Tests Attended" /*  Commented By Ranjeet on 19th March 2020 */
            testTypeLbl.text = "Tests Taken" /*  Updated By Ranjeet on 19th March 2020 */
            clsTknLbl.text = json["ClassAttended"].stringValue
            testDlvrdLbl.text = json["TestsAttended"].stringValue
            //            add by chandra start
//            totalHightConstraint.constant = 25
            totalHightConstraint.constant = 10
            hightConstrainForViewTwo.constant = 25
            cardViewOne.isHidden = true
            demoClassLinks.isHidden = true
            demoClassVideos.isHidden = true
            //            ends
            
        }else if json["PersonType"].intValue == 3{
          //  clsTypeLbl.text = "Class Created" /*  Commented By Ranjeet on 19th March 2020 */
              clsTypeLbl.text = "Classes Delivered" /*  Commented By Ranjeet on 19th March 2020 */
            testTypeLbl.text = "Tests Created"
            clsTknLbl.text = json["ClassCreated"].stringValue
            testDlvrdLbl.text = json["TestsCreated"].stringValue
            //            add chandra start
            self.school1.text = json["Schools"].stringValue
            currentEducation.text = json["Education"].stringValue
            country.text = json["Country"].stringValue
            state.text = json["State"].stringValue
            
            if chuckdata.isEmpty{
                print("chuckdataisEmpty")
            }else{
                totalHightConstraint.constant = 590
                var res = tutorInfo["TutorCanTeach"].stringValue
                let str = res.split(separator: ",")
                var res1 = [String]()
//                for i in 0..<str.count {
//                    let temp = str[i]
//                    if temp.contains("13"){
//                        res = res.replacingOccurrences(of: "13", with: "UnderGradute")
//                    }
//                    else if temp.contains("14"){
//                        res = res.replacingOccurrences(of: "14", with: "Gradute")
//                    }
//                    else {
//                        res = res.replacingOccurrences(of: temp, with: "\(temp)th")
//                    }
//                }
                
                for i in 0..<str.count {
                    let temp1 = Int(str[i])
                    if temp1 == 1 {
                        res1.append("1st")
                    } else if temp1 == 2 {
                        res1.append("2nd")
                    } else if temp1 == 3 {
                        res1.append("3rd")
                    }
                    else if temp1 == 4 {
                        res1.append("4th")
                    }else if temp1 == 5 {
                        res1.append("5th")
                    }else if temp1 == 6 {
                        res1.append("6th")
                    }else if temp1 == 7 {
                        res1.append("7th")
                    }else if temp1 == 8 {
                        res1.append("8th")
                    }else if temp1 == 9 {
                        res1.append("9th")
                    }else if temp1 == 10{
                        res1.append("10th")
                    }
                    else if temp1 == 11{
                        res1.append("11th")
                    }else if temp1 == 12{
                        res1.append("12th")
                    }
                    else if temp1 == 13 {
                        res1.append("UnderGraduates")
                    }else if temp1 == 14 {
                        res1.append("Graduates")
                    }else{
                        if res1.count != 0{
                            //  res1.append("\(String(describing: temp1))th")
                        }else{
                            //   res1.append("\(temp1!)th")
                        }
                        
                    }
                }
                let string = res1.joined(separator: ",")
                self.grades.text? = "\(string)"
                self.workExperience.text = "\(tutorInfo["WorkExperience"].intValue)"
                let TutorSubjectTeach = tutorInfo["TutorSubjectTeach"].stringValue
                for i in TutorSubjectTeach.split(separator: ","){
                    if(subject.text!.isEmpty)
                    {
                        subject.text! = self.subjects[(Int(i) ?? 0)-1]
                    }
                    else
                    {
                        subject.text! += "," + self.subjects[(Int(i) ?? 0)-1]
                    }
                    
                }
                aboutYourProfession.text = tutorInfo["TutorDescription"].stringValue
                aboutYourProfession.isEditable = false
                aboutYourProfession.isSelectable = false
                cardViewOne.isHidden = false
                demoClassLinks.isHidden = false
                demoClassVideos.isHidden = false
            }
            // ends here
        }
        /* Added By Yashoda on 27th Jan 2020 - ends   here */
        
        /* Added By Yashoda  on 17th Jan 2020 - starts here */
        
        numberOfQuesnsAskdLbl.isUserInteractionEnabled = true
        numberOfQuesnsAskdLbl.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(numberOfQuesnsAskd(gesture:))))
        numberOfQuesnsAskdLblTouch.isUserInteractionEnabled = true
        numberOfQuesnsAskdLblTouch.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(numberOfQuesnsAskd(gesture:))))
        numberOfQuesnsAnsrdLbl.isUserInteractionEnabled = true
        numberOfQuesnsAnsrdLbl.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(  numberOfQuesnsAnsrd(gesture:))))
        numberOfQuesnsAnsrdLblTouch.isUserInteractionEnabled = true
        numberOfQuesnsAnsrdLblTouch.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(  numberOfQuesnsAnsrd(gesture:))))
        
        clsTypeLbl.isUserInteractionEnabled = true
        clsTypeLbl.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(  numberOfQuesnsAnsrd(gesture:))))
        clsTypeLbl.isUserInteractionEnabled = true
        clsTypeLbl.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(   clsType(gesture:))))
        
        testTypeLbl.isUserInteractionEnabled = true
        testTypeLbl.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(  numberOfQuesnsAnsrd(gesture:))))
        testTypeLbl.isUserInteractionEnabled = true
        testTypeLbl.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(    testType(gesture:))))
        
    }
    
    /* Added By Yashoda on 17th Jan 2020 - starts here */
    
    
    @objc func numberOfQuesnsAskd(gesture: UITapGestureRecognizer) {
        print("***** numberOfQuesnsAskd ********")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextviewcontroller = storyboard.instantiateViewController(withIdentifier: "contntqstinsasked") as! ContentQuestionsAskedVC
        self.navigationController?.pushViewController(nextviewcontroller, animated: true)
        
    }
    
    @objc func numberOfQuesnsAnsrd(gesture: UITapGestureRecognizer) {
        print("***** numberOfQuesnsAnsrd *******")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextviewcontroller = storyboard.instantiateViewController(withIdentifier: "AnswerThatYouProvidedVC") as! AnswerThatYouProvidedVC
        
        self.navigationController?.pushViewController(nextviewcontroller, animated: true)
        
    }
    
    /* Updated  By Deepak on 3rd Aprl 2020 - starts here */
    @objc func clsType(gesture: UITapGestureRecognizer) {
            print("**** ClassAttended/Delivered ******")
             let nextviewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ClassDeliveredOrAttendedVC") as! ClassDeliveredOrAttendedVC
            if personType == 1{
                nextviewcontroller.studentClassesEndPoint = clsTypeLbl.text
                nextviewcontroller.perSonType = personType
            }else if personType == 3{
                nextviewcontroller.tutorClassesEndPoint = clsTypeLbl.text
                nextviewcontroller.perSonType = personType
            }
            self.navigationController?.pushViewController(nextviewcontroller, animated: true)
        }
      /* Updated  By Deepak on 3rd Aprl 2020 - ends  here */
    
    @objc func testType(gesture: UITapGestureRecognizer) {
        print("***** numberOfQuesnsAnsrd *******")
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextviewcontroller = storyboard.instantiateViewController(withIdentifier: "mytest") as! MyTestVC
        if personType == 1{
            
            nextviewcontroller.studentTestTakenEndPoint = testTypeLbl.text
            nextviewcontroller.perSonType = personType
        }else if personType == 3{
            
            nextviewcontroller.tutorTestsEndPoint = testTypeLbl.text
            nextviewcontroller.perSonType = personType
        }
        
        self.navigationController?.pushViewController(nextviewcontroller, animated: true)
        
    }
    
    /* Added By Yashoda on 17th Jan 2020 - ends  here */
    
    // Follow Unfollow Users Related
    private func hitServerForFollowUsers(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){[weak self] result in
            guard let _self = self else {
                return
            }
            _self.stopAnimating()
            switch result {
            case let .success(json,requestType):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }
                else {
                    if requestType == "followUser" {
                        _self.followUnfollowUserBtn.isSelected = !_self.followUnfollowUserBtn.isSelected
                        showMessage(bodyText: "User Followed Successfully",theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.01))
                    }
                    else if requestType == "unFollowUser"{
                        _self.followUnfollowUserBtn.isSelected = !_self.followUnfollowUserBtn.isSelected
                        showMessage(bodyText: "User UnFollowed Successfully",theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.01))
                    }
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
}

//add by chandra start here
extension PersonalProfileVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collectionView2{
            if linkVideosArr.count == 0{
                demoLinksHight.constant = 0
                hightConstraintForViewOne.constant = 200
                demoClassLinks.isHidden = true
                demoClassVideos.isHidden = true
            }else{
                demoLinksHight.constant = 130
                demoClassLinks.isHidden = false
                demoClassVideos.isHidden = false
                hightConstraintForViewOne.constant = 350
            }
            return linkVideosArr.count
        }else{
            if uploadVideosArr.count == 0{
                hightConstraintForViewOne.constant = 200
                demoClassVideosHight.constant = 0
                demoClassLinks.isHidden = true
                demoClassVideos.isHidden = true
            }else{
                 hightConstraintForViewOne.constant = 350
                demoClassVideosHight.constant = 130
                demoClassLinks.isHidden = false
                demoClassVideos.isHidden = false
            }
            return uploadVideosArr.count
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView2{
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "LinksCollectionViewCell", for: indexPath) as! LinksCollectionViewCell
            let dict = linkVideosArr[indexPath.row]
            cell2.videoTitle2.text = dict["VideoTitle"].stringValue
            let storedurl = dict["VideoUrl"].stringValue
            let convertingStringTourl = URL(string: storedurl)
            if convertingStringTourl != nil{
                cell2.thumbNailImage2.image = getThumbnailFrom(path: convertingStringTourl!)
            }
            let image = UIImage(named: "play")
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 0, y: 0, width: cell2.playicon2.frame.size.width, height: cell2.playicon2.frame.size.height)
            cell2.playicon2.addSubview(imageView)
            return cell2
        }else{
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "DemoClassVideosCollectionViewCell", for: indexPath)as! DemoClassVideosCollectionViewCell
            let dict = uploadVideosArr[indexPath.row]
            cell1.videoTitle.text = dict["VideoTitle"].stringValue
            let storedurl = dict["VideoUrl"].stringValue
            let convertingStringTourl = URL(string: storedurl)
            // add by chandra for display videos
            if storedurl.contains("ltwuploadcontent"){
               cell1.thumbNailImage.image = getThumbnailFrom(path: convertingStringTourl!)
            }else{
                cell1.thumbNailImage.image = UIImage.init(named: "gVideo_selected") // add by chandra for videos
            }
//            if convertingStringTourl != nil{
//                cell1.thumbNailImage.image = getThumbnailFrom(path: convertingStringTourl!)
//            }
            let image = UIImage(named: "play")
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 0, y: 0, width: cell1.playicon.frame.size.width, height: cell1.playicon.frame.size.height)
            cell1.playicon.addSubview(imageView)
            return cell1
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionView2{
            let dict = linkVideosArr[indexPath.row]
            let oneurl = dict["VideoUrl"].stringValue
            if oneurl != ""{
                let videoURL = URL(string:oneurl)!
                if videoURL != nil && oneurl != ""{
                    let svc = SFSafariViewController(url: videoURL)
                    present(svc, animated: true, completion: nil)
                }
            }
        }else{
            let dict = uploadVideosArr[indexPath.row]
            let oneurl = dict["VideoUrl"].stringValue
           // let data = isValidUrl(url: oneurl)
            let data = verifyUrl(urlString: oneurl)
            if data == true {
                if oneurl != ""{
                    let videoURL = URL(string:oneurl)!
                    if videoURL != nil{
                        let svc = SFSafariViewController(url: videoURL)
                        present(svc, animated: true, completion: nil)
                    }
                }
            }else{
                showMessage(bodyText: "Invalid URL",theme: .warning)
            }
            
            
            
        }
        
    }
    // add by chandra for validation for url
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    func isValidUrl(url: String) -> Bool {
    let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
    let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
    let result = urlTest.evaluate(with: url)
    print(result)
    return result
    }
}

// ends here
extension NSMutableAttributedString {

    func setColor(color: UIColor, forText stringValue: String) {
       let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }

}
