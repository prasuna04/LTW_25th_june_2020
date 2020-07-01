//  AccountVC.swift
//  LTW
//  Created by Ranjeet Raushan on 22/04/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import SDWebImage
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView
import SwiftMessages
import SafariServices


enum PersonTypeForAccountVC: Int {
    case Student = 1 // why i am using 1 here because another two person type will automatically take 2 & 3 and if i  will not put 1 here  it will consider 0 automatically and another two person type will become 1 and 2 and we will get wrong information.
    case Parent
    case Teacher
}
class AccountVC: UIViewController,NVActivityIndicatorViewable {
    let personTypeFor = UserDefaults.standard.string(forKey: "persontyp")
    var TutorDemoVideos = [JSON]()
    var uploadVideosArr = [JSON]()
    var boards = ["1":"CBSE","2":"ICSE","3":"IGCSE","4":"IB","5":"Others","6":"US Common Core"]
    @IBOutlet weak var pointsPurchasedCustomView: CustomView!
    @IBOutlet weak var pointsHightCostraintStack: NSLayoutConstraint!
    @IBOutlet weak var cardView1HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profiLeIV: UIImageView!{
        didSet{
            profiLeIV.setRounded()
            profiLeIV.layer.shadowColor = UIColor.gray.cgColor
            profiLeIV.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
            profiLeIV.layer.shadowRadius = 5.0
            profiLeIV.layer.shadowOpacity = 0.8
        }
    }
    
    @IBOutlet weak var profileEditBtn: UIButton!
    
    @IBOutlet weak var person1stNameLbl: UILabel!
    /* Commented By Ranjeet on 12th May 2020 - starts here */
//        {
//        didSet{
//            person1stNameLbl.font = UIFont.boldSystemFont(ofSize: 16.0)/* I tried to put
//             "Roboto-Bold" , but it was not working properly so let it be boldSystemFont only to get the bold text  */
//        }
//    }
    /* Commented By Ranjeet on 12th May 2020 - ends here */
    @IBOutlet weak var personLstNameLbl: UILabel!
    /* Commented By Ranjeet on 12th May 2020 - starts here */
//        {
//        didSet{
//            personLstNameLbl.font = UIFont.boldSystemFont(ofSize: 16.0)
//        }
//    }
    /* Commented By Ranjeet on 12th May 2020 - ends here */
    @IBOutlet weak var personTypLbl: UILabel!
    /* Commented By Ranjeet on 12th May 2020 - starts here */
//        {
//        didSet{
//            personTypLbl.font = UIFont.boldSystemFont(ofSize: 16.0)
//        }
//    }
    /* Commented By Ranjeet on 12th May 2020 - ends here */
    @IBOutlet weak var scholLbl: UILabel!
    /* Commented By Ranjeet on 12th May 2020 - starts here */
//        {
//        didSet{
//            scholLbl.font = UIFont.boldSystemFont(ofSize: 16.0)
//        }
//    }
    /* Commented By Ranjeet on 12th May 2020 - ends here */
    @IBOutlet weak var emaIlLbl: UILabel!
    /* Commented By Ranjeet on 12th May 2020 - starts here */
//        {
//        didSet{
//            emaIlLbl.font = UIFont.boldSystemFont(ofSize: 16.0)
//        }
//    }
    /* Commented By Ranjeet on 12th May 2020 - ends here */
    @IBOutlet weak var cosmos: CosmosView! //Added By Ranjeet on 23rd April 2020
    @IBOutlet weak var review: UIButton! //Added By Ranjeet on 23rd April 2020
    @IBOutlet weak var myPointsTitleLbl: UILabel!{
        didSet{
            myPointsTitleLbl.font = UIFont.boldSystemFont(ofSize: 16.0)
            myPointsTitleLbl.attributedText = myPointsTitleLbl.text!.getUnderLineAttributedText()
        }
    }
    @IBOutlet weak var myPointsLbl: UILabel!
    @IBOutlet weak var transferPointsTitleLbl: UILabel!{
        didSet{
            transferPointsTitleLbl.font = UIFont.boldSystemFont(ofSize: 16.0)
            transferPointsTitleLbl.attributedText = transferPointsTitleLbl.text!.getUnderLineAttributedText()
        }
    }
    /* Added by Ranjeet on 12th June 2020 - starts here */
    
    @IBOutlet weak var craeteAccountBtn: UIButton!
    @IBOutlet weak var encashBtn: UIButton!
    /* Added by Ranjeet on 12th June 2020 - ends here */
    
    @IBOutlet weak var enterMailTF: UITextField!{
        didSet{
            enterMailTF.useUnderline()
            
        }
    }
    @IBOutlet weak var enterPointsTF: UITextField!{
        didSet{
            enterPointsTF.useUnderline()
        }
    }
    
    @IBOutlet weak var buyPointsBtn: UIButton!
        {
        didSet{
            buyPointsBtn.layer.cornerRadius = buyPointsBtn.frame.height / 12
        }
    }
    @IBOutlet weak var transferPointsBtn: UIButton!
        {
        didSet{
            transferPointsBtn.layer.cornerRadius = transferPointsBtn.frame.height / 12
        }
    }
    @IBOutlet weak var badgesEarnedCountLbl: UILabel!
    @IBOutlet weak var qustnsAskedCountLbl: UILabel!
    @IBOutlet weak var answrGvnCountLbl: UILabel!
//    @IBOutlet weak var pointsGandCountLbl: UILabel!
    @IBOutlet weak var pointsPurchasedCountLbl: UILabel!
    @IBOutlet weak var pointsUsedCountLbl: UILabel!
    @IBOutlet weak var clasesDlvrdCountLbl: UILabel!
    @IBOutlet weak var tstCondctdCountLbl: UILabel!
    
    @IBOutlet weak var classAttendeesStack: UIStackView! /* Added By Veeresh on 14th Feb 2020 */
    
    @IBOutlet weak var classDelivOrTaken: UILabel! /* Added By Veeresh on 14th Feb 2020 */
    
    @IBOutlet weak var testTakenOrCreated: UILabel! /* Added By Veeresh on 14th Feb 2020 */
    
    /* Added By Ranjeet on 9th April 2020 - starts here */
    
    @IBOutlet weak var demoClassVideosHight: NSLayoutConstraint!
    @IBOutlet weak var collectionView:UICollectionView!
    
    
    @IBOutlet weak var totalHightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var hightConstrainForViewTwo: NSLayoutConstraint!
    @IBOutlet weak var hightConstraintForViewOne: NSLayoutConstraint!
    @IBOutlet weak var cardViewOne: UIView!
    @IBOutlet weak var cardViewTwo: UIView!
    @IBOutlet weak var demoClassVideos: UILabel!
    @IBOutlet weak var demoClassLinks: UILabel!
    @IBOutlet weak var currentEducation: UILabel!
    @IBOutlet weak var school1: UILabel!
    @IBOutlet weak var grades: UILabel!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var workExperience: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var aboutYourProfession: UITextView!{
        didSet{
            aboutYourProfession.isEditable = false
            aboutYourProfession.isSelectable = false 
        }
    }
    @IBOutlet weak var bord: UILabel!
    @IBOutlet weak var occupation: UILabel!
    
    @IBOutlet weak var buyAndTrnsfrPontsToEmailNSLConstraint: NSLayoutConstraint!
    /* Added By Ranjeet on 9th April 2020 - ends here */
    
    @IBOutlet weak var tutoringPointsHeadingLabel: UILabel!{
        didSet{
            tutoringPointsHeadingLabel.isHidden = true
            tutoringPointsHeadingLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
            tutoringPointsHeadingLabel.attributedText = tutoringPointsHeadingLabel.text!.getUnderLineAttributedText()
        }
    }
    @IBOutlet weak var tutoringPointsLabel: UILabel!{
        didSet{
            tutoringPointsLabel.isHidden = true
        }
    }
    @IBOutlet weak var tutoringPointstrophyImage: UIImageView!{
        didSet{
            tutoringPointstrophyImage.isHidden = true
        }
    }
    
    
    var userID: String!
    var fromUserID: String! // use it for transfer points only
    var tutorInfo :JSON!
    var personType : Int = Int(UserDefaults.standard.string(forKey: "persontyp")!) ?? 1 /* Added By Veeresh on 14th Feb 2020 */
    var views = UIView()
    var ratingpass:Int!  /* Added By Ranjeet on 23rd April 2020  */
   
    /* Added By Ranjeet on 9th April 2020 - starts here */
    var MainvideoUrlArr = [JSON]() // for videos checking
    
    var linkVideosArr = [JSON]()
    var onlyLinkVideosArr = [String]()
    var chuckdata:JSON!
    
    var randomList = [String]()
    let subjects = UserDefaults.standard.array(forKey: "subjectArray") as! [String]
    /* Added By Ranjeet on 9th April 2020 - ends  here */
    override func viewDidLoad() {
        super.viewDidLoad()
        cosmos.settings.updateOnTouch = false /* Added By Ranjeet on 23rd April 2020 */
        cosmos.settings.fillMode = .precise /* Added By Ranjeet on 23rd April 2020 */
        userID =  UserDefaults.standard.string(forKey: "userID")
        //uncommented by veeresh on 18th may 2020
       // let tap =  UITapGestureRecognizer(target: self, action: #selector(self.classAttendedTapped))
       // classAttendeesStack.addGestureRecognizer(tap)  /* Added By Veeresh on 14th Feb 2020 */
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        views.removeFromSuperview()
        views.stopShimmering()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /* Added By Veeresh on 14th Feb 2020 - starts here  */

        
        if  personType == 1 {
            cardView1HeightConstraint.constant = 475
            classDelivOrTaken.text = "Class Attended"
            testTakenOrCreated.text = "Test Attended"
            craeteAccountBtn.isHidden = true
            encashBtn.isHidden = true
            tutoringPointsLabel.isHidden = true
            tutoringPointsHeadingLabel.isHidden = true
            tutoringPointstrophyImage.isHidden = true
            pointsPurchasedCustomView.isHidden = false
        } 
        else {
            pointsPurchasedCustomView.isHidden = true
            cardView1HeightConstraint.constant = 575
            tutoringPointsLabel.isHidden = false
            tutoringPointsHeadingLabel.isHidden = false
            tutoringPointstrophyImage.isHidden = false
            
            classDelivOrTaken.text = "Classes Delivered"
            testTakenOrCreated.text = "Tests Conducted"
            let ID = UserDefaults.standard.string(forKey: "AccountID") ?? ""
            if ID != ""//
            {
            craeteAccountBtn.isHidden = true
                encashBtn.isHidden = false

            }else{
craeteAccountBtn.isHidden = false
            encashBtn.isHidden = true

            }
        }
        
        
        /* Added By Veeresh on 14th Feb 2020 - ends  here */
        if (self.navigationController?.navigationBar) != nil {
            navigationController?.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        }
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Profile"
        if currentReachabilityStatus != .notReachable {
            uploadVideosArr.removeAll() // add by chandra
            subject.text = "" // add by chandra
            hitServer(params: [:], endPoint: Endpoints.userProfileEndPoint + (self.userID!) ,  action: "userProfile", httpMethod: .get)
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
            })
        }
    }
    
    @IBAction func onProfileEditBtnClk(_ sender: UIButton) {
        let userprofileupdate = storyboard?.instantiateViewController(withIdentifier: "userprofileupdate") as! UserProfileUpdateVC
        //        userprofileupdate.isEdit = true /* Added By Chandra on 28th Feb 2020 */
        //        userprofileupdate.tutorDetails1 = tutorInfo /* Added By Chandra on 28th Feb 2020 */
        navigationController?.pushViewController(userprofileupdate, animated: true)
        
    }
    
    // Buy Points Btn Click
    @IBAction func onBuyPointsBtnClick(_ sender: UIButton) {
//        showMessage(bodyText: "Work in Progress",theme: .success,presentationStyle: .center, duration: .seconds(seconds: 1))
            let story = UIStoryboard.init(name: "Main", bundle: nil)
                let paymentVC = story.instantiateViewController(withIdentifier: "paymentvc") as! PaymentVC
        //        paymentVC.params = params
                navigationController?.pushViewController(paymentVC, animated: true)
        
    }
     @IBOutlet weak var scroolViewHoghtConstrain: NSLayoutConstraint!
    /* Added By Ranjeet on 12th June 2020 - starts here */
       @IBAction func onCreateAccountBtnClick(_ sender: UIButton) {
        
        let ID = UserDefaults.standard.string(forKey: "AccountID") ?? ""

        if ID != ""//
        {

            showMessage(bodyText: "you already have an account .",theme: .warning)

        }else
        {
        
                   let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StripeAccountVC") as! StripeAccountVC
                   self.navigationController?.pushViewController(vc, animated: true)
    }
          }
       
       @IBAction func onEncashBtnClick(_ sender: UIButton) {
        
        let ID = UserDefaults.standard.string(forKey: "AccountID") ?? ""
        
        if ID == ""//
        {
            
            showMessage(bodyText: "Please create stripe account for encash.",theme: .warning)

        }else
        {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EncashDetailsVC") as! EncashDetailsVC
            vc.points = tutoringPointsLabel.text
        self.navigationController?.pushViewController(vc, animated: true)
            
        }
       
              
       }
       /* Added By Ranjeet on 12th June 2020 - ends here */
    
    /* Added By Veeresh on 14th Feb 2020 - starts here */
    @objc func classAttendedTapped(sender: UITapGestureRecognizer) {
        if  personType == 1 {
            let vc =  storyboard?.instantiateViewController(withIdentifier: "ClassAttendedVC") as!  ClassAttendedVC
            vc.userId = self.userID
            self.navigationController?.pushViewController(vc, animated: true )
        }
    }
    /* Added By Veeresh on 14th Feb 2020 - ends  here */
    
    /* Added By Ranjeet on 23rd April 2020 - starts here */
    @IBAction func onReviewBtnClick(_ sender: UIButton) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let containerView = storyBoard.instantiateViewController(withIdentifier: "RatingAndReviewContainerViewController") as! RatingAndReviewContainerViewController
        containerView.profileUserId = userID
        self.navigationController?.pushViewController(containerView, animated: true)
    }
    /* Added By Ranjeet on 23rd April 2020 - ends here */
    
    // Transfer Points Btn Click
    @IBAction func onTransferPointsBtnClick(_ sender: UIButton) {
        validiateInputFields()
    }
    private func validiateInputFields(){
        guard let toUserEmailID = enterMailTF.text?.trim(), !toUserEmailID.isEmpty ,toUserEmailID.isValidEmail() else {
            showMessage(bodyText: "Please enter valid email .",theme: .warning)
            return
        }
        if enterPointsTF.text?.isEmpty ?? false {
            showMessage(bodyText: "Please enter points.", theme: .warning)
            return
        }
        
        fromUserID = UserDefaults.standard.string(forKey: "userID")!
        if currentReachabilityStatus != .notReachable {
            
            let endPoint = "\(Endpoints.transferPointsEndPoint)\(UserDefaults.standard.string(forKey: "userID")!)/\(enterMailTF.text!)/\(Int(enterPointsTF.text!)!)"
            hitServerForTransferPoints(params: [:], endPoint: endPoint ,  action: "transferPoints", httpMethod: .get)
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
            })
        }
    }
}
extension AccountVC {
    func hideEverything(_ no : Int){
        let cond = (no == 1 ? true : false )
        contentView.isHidden=cond
    }
    // user Profile related
    private func hitServer(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        // startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        /* added by veeresh on 28th feb 2020 starts here*/
        var shim = UIImageView()//Asset 62-iphone
        views = UIView()
        views = UIView()//personType
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: shim = UIImageView(image: UIImage(named: personType == 1 ? "Asset 62-iphone" : "Asset 63-iphone")) ; shim.contentMode = .scaleToFill
        shim.frame=CGRect(x: 0, y: 0, width: self.view.frame.width - 20, height: self.view.frame.height - 90)
        views.frame=CGRect(x: 10, y: 60, width: self.view.frame.width - 20, height: self.view.frame.height - 125)
        case .pad: shim = UIImageView(image: UIImage(named: personType == 1 ? "Asset 61" : "Asset 60")) ; shim.contentMode = .scaleToFill
        views.frame=CGRect(x: 10, y: 0, width: self.view.frame.width - 10, height: self.view.frame.height - 110)
        shim.frame=CGRect(x: 0, y: 50, width: self.view.frame.width - 20, height: self.view.frame.height - 200)
        case .unspecified: shim = UIImageView(image: UIImage(named: "my-group-mobile")!)
        case .tv: shim = UIImageView(image: UIImage(named: "my-group-ipad")!) ; shim.contentMode = .topLeft
        case .carPlay: shim = UIImageView(image: UIImage(named: "my-group-mobile")!)
        }
        views.addSubview(shim)
//        views.pinAllEdges(ofSubview: shim)
        views.backgroundColor = UIColor.white
        views.layer.zPosition = CGFloat(MAXFLOAT)
        view.addSubview(views)
        views.bringSubviewToFront(views)
        views.startShimmering()
        hideEverything(1)
        /* added by veeresh on 28th feb 2020 ends here*/
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
                    _self.tutorInfo = json["ControlsData"]["tutorInfo"] // add by chandra for getting profile data on 28th feb 2020
                    print(_self.tutorInfo)
                    
                    let data = Int((_self.personTypeFor!))!
                    if data == 1{
                        
                    }else{
                        var res = _self.tutorInfo["TutorCanTeach"].stringValue
//                        let str = res.split(separator: ",")
//                        for i in 0..<str.count {
//                            let temp = str[i]
//                            if temp.contains("13"){
//                                res = res.replacingOccurrences(of: "13", with: "UnderGradute")
//                                print(res)
//                            }
//                            else if temp.contains("14"){
//                                res = res.replacingOccurrences(of: "14", with: "Gradute")
//                                print(res)
//                            }
//                            else {
//                                res = res.replacingOccurrences(of: temp, with: "\(temp)th")
//                                print(res)
//                            }
//                        }
//                        _self.grades.text? = res
                         let str = res.split(separator: ",")
                         print(str) // ["3", "1", "5", "2", "4"]
                         var res1 = [String]()
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
                                    //                        res1.append("\(String(describing: temp1))th")
                                }else{
                                    //   res1.append("\(temp1!)th")
                                }
                                
                            }
                        }
                         let values = res.split(separator: ",")
                         print(values)
                         print(res1)
                        
                         let string = res1.joined(separator: ",")
                         _self.grades.text? = "\(string)"
                        
                        _self.dataCall()
                    }
                    _self.parseNDispayListData(json: json["ControlsData"]["ProfileData"], requestType: requestType)
                    
                    
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    
    func dataCall() {
        var res = tutorInfo["CurrentOccupation"].stringValue
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
        self.occupation.text = res
        // add by chandra for bords display 18 2020
        let data = tutorInfo["BoardsCanTeach"].stringValue
        let dataTwo = data.split(separator: ",").map { String($0) }
        
        if dataTwo.count != 0{
            self.bord.text!.removeAll()
        }
        for i in dataTwo{
            let bordsLblData = self.boards[i]!
            if(self.bord.text!.isEmpty){
                self.bord.text! = bordsLblData
            }else{
                self.bord.text! += "," + bordsLblData
            }
        }
        
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
        /* Added By Ranjeet on 26th  April 2020 - starts here */
               let rating = tutorInfo["Rating"].intValue
               ratingpass = rating
               cosmos.rating =  rating == 0 ? 2.5 : Double(rating)
               let reviewCount = tutorInfo["ReviewCount"].intValue
              review.setTitle("\(reviewCount) Review", for: .normal)
        /* Added By Ranjeet on 26th April 2020 - starts here */
      
        aboutYourProfession.text = tutorInfo["TutorDescription"].stringValue
        
        TutorDemoVideos = tutorInfo["TutorDemoVideos"].arrayValue
        
        for i in 0..<self.TutorDemoVideos.count{
            let checkVideos  = self.TutorDemoVideos[i]
            let data = checkVideos["VideoUrl"].stringValue
            if data.contains("ltwuploadcontent"){
                uploadVideosArr.append(self.TutorDemoVideos[i])
            }else{
                uploadVideosArr.append(self.TutorDemoVideos[i])
            }
    
            collectionView.reloadData()
        }
       
        
        // Added By Ranjeet on 6th  may 2020 - starts here /
        if uploadVideosArr.count == 0 {
        print("chandra")
        demoClassVideosHight.constant = 0
        demoClassLinks.isHidden = true
        demoClassVideos.isHidden = true
        }
        else{
        demoClassLinks.isHidden = false
        demoClassVideos.isHidden = false
        demoClassVideosHight.constant = 130
        print("sekhar")
        }
        // Added By Ranjeet on 6 April 2020 - ends here /
        
        
        
        
    }
    // Transfer Points Related
    private func hitServerForTransferPoints(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
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
                else {
                    _self.hitServer(params: [:], endPoint: Endpoints.userProfileEndPoint + (_self.userID!) ,  action: "userProfile", httpMethod: .get)
                    showMessage(bodyText: "Points Transferred Successfully",theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.01))
                    _self.enterMailTF.text?.removeAll()
                    _self.enterPointsTF.text?.removeAll()
                    
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    
    private func parseNDispayListData(json: JSON,requestType: String){
        
        /*      Don't delete this binding image load related code, might in future it will get reuse
         
         self.profiLeIV?.sd_setImage(with: URL.init(string: (json["ProfileUrl"].stringValue)),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached]) */
        
        /* Don't delete below note , it's a very strict warning to follow without commit this mistake once again in future.
         note: Don't load the image in DispatchQueue.main.async(){} cause it's freezing the UI most of the times and one more thing SDWebImage only handling all the threading related functionality in their own way. */
        
        let data = Int((personTypeFor!))!
        if data == 1{
            scroolViewHoghtConstrain.constant = 800
        }else{
            scroolViewHoghtConstrain.constant = 1400
            school1.text = json["Schools"].stringValue
            country.text = json["Country"].stringValue
            state.text = json["State"].stringValue
            currentEducation.text = json["Education"].stringValue
        }
        person1stNameLbl.text = json["FirstName"].stringValue
        personLstNameLbl.text = json["LastName"].stringValue
        let typeOfPersonForAccountVC = PersonTypeForAccountVC.init(rawValue: json["PersonType"].intValue)
        if json["PersonType"].intValue == 1{
            pointsHightCostraintStack.constant = 5 // add by chandra
            buyAndTrnsfrPontsToEmailNSLConstraint.constant = 40// add by chandra
            totalHightConstraint.constant = 10
            cardViewOne.isHidden = true
            cardViewTwo.isHidden = true
            demoClassLinks.isHidden = true
            demoClassVideos.isHidden = true
//            buyAndTrnsfrPontsToEmailNSLConstraint.constant = 0
            review.isHidden = true
            cosmos.isHidden = true
            buyPointsBtn.isHidden = false
        }else{
            pointsHightCostraintStack.constant = 70
            totalHightConstraint.constant = 600
                        buyAndTrnsfrPontsToEmailNSLConstraint.constant = 15
            buyPointsBtn.isHidden = true
        }
        if typeOfPersonForAccountVC != nil{
            personTypLbl.text = "\(String(describing: typeOfPersonForAccountVC!))"
            print(personTypLbl.text!)
            
        }
        scholLbl.text = json["Schools"].stringValue
        emaIlLbl.text = json["EmailID"].stringValue
        myPointsLbl.text = "\(json["MyPoints"].intValue)"
        tutoringPointsLabel.text = "\(json["TutoringPoints"].intValue)"
        badgesEarnedCountLbl.text = "\(json["BadgesEarned"].intValue)"
        qustnsAskedCountLbl.text = "\(json["QuestionAsked"].intValue)"
        answrGvnCountLbl.text = "\(json["AnswerGiven"].intValue)"
       // pointsGandCountLbl.text = "\(json["PointsGained"].intValue)"
       /* commented by ranjeet on 8th june*/
        pointsPurchasedCountLbl.text = "\(json["PointsPurchased"].intValue)"
        pointsUsedCountLbl.text = "\(json["PointsUsed"].intValue)"
       
        /* Code modified  By Veeresh on 14th Feb 2020  - starts here */
        if  personType == 1 {
            clasesDlvrdCountLbl.text = "\( json["ClassAttended"].intValue)"
            tstCondctdCountLbl.text = "\(json["TestsAttended"].intValue)"
        }
        else {
            clasesDlvrdCountLbl.text = "\(json["ClassCreated"].intValue)"
            tstCondctdCountLbl.text = "\(json["TestsCreated"].intValue)"
            
        }
        
       
        /* Code modified By Veeresh on 14th Feb 2020 - ends here */
        
        /*Don't replace this code (done by Mukesh) - (by above binding related code) , cause it's giving exact & quick(faster) image after update the profile */
        if let profileImgLocalUrl = UserDefaults.standard.object(forKey: "profileImgLocalUrl") as? String {
            print("profileImgUrl = \(profileImgLocalUrl)")
            // self.profileImgLocalUrl = profileImgLocalUrl
            let fileName = (profileImgLocalUrl as NSString).lastPathComponent
            if (profileImgLocalUrl.contains("var")) {
                //read image from document directory
                let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
                let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
                let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
                if let dirPath = paths.first {
                    let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("Images/\(fileName)")
                    // profileImgUrl    String    "/var/mobile/Containers/Data/Application/0343BAFB-6313-437B-A775-ED43815A954F/Documents/Images/07212018062437504.jpg"
                    if let image = UIImage(contentsOfFile: imageURL.path) {
                        // use image
                        profiLeIV.image = image
                    }
                    else {
                        //or bind default image
                    }
                }
            }
        } else {
            if  let imgUrl =  UserDefaults.standard.string(forKey: "profileURL") {
                self.profiLeIV?.sd_setImage(with: URL.init(string: imgUrl),placeholderImage:UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload])
                
            }
        }
        /*Don't replace this code (done by Mukesh) - (by above binding related code) , cause it's giving exact & quick(faster) image after update the profile */
        
    }
    func isValidUrl(url: String) -> Bool {
          let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
          let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
          let result = urlTest.evaluate(with: url)
          print(result)
          return result
          }
}
extension AccountVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uploadVideosArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
        let image = UIImage(named: "play")
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: cell1.playicon.frame.size.width, height: cell1.playicon.frame.size.height)
        cell1.playicon.addSubview(imageView)
        return cell1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let dict = uploadVideosArr[indexPath.row]
//        let oneurl = dict["VideoUrl"].stringValue
//        if oneurl != ""{
//            let videoURL = URL(string:oneurl)!
//            if videoURL != nil{
//                let svc = SFSafariViewController(url: videoURL)
//                present(svc, animated: true, completion: nil)
//            }
//        }
//
        
        let dict = uploadVideosArr[indexPath.row]
        let oneurl = dict["VideoUrl"].stringValue
        let data = isValidUrl(url: oneurl)
        if data == true {
            if oneurl != ""{
                let videoURL = URL(string:oneurl)!
                if videoURL != nil{
                    let svc = SFSafariViewController(url: videoURL)
                    present(svc, animated: true, completion: nil)
                }
            }
        }else{
            showMessage(bodyText: "Invalid url",theme: .warning)
        }
        
        
    }
    
}

