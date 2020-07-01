//  TutorSignUpVC.swift
//  LTW
//  Created by Vaayoo USA on 28/01/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import UIKit
import NVActivityIndicatorView
import SwiftyJSON
import Alamofire
import MobileCoreServices
import AssetsLibrary
import Photos
import AVFoundation
import MediaPlayer
import AVKit
import IQKeyboardManagerSwift
import  SafariServices
//import PDFKit
import PDFReader
class TutorSignUpVC: UIViewController,UITextFieldDelegate,SelectionDelegate,UITextViewDelegate,NVActivityIndicatorViewable ,UIImagePickerControllerDelegate,UINavigationControllerDelegate,VideoServiceDelegate{
    var data:Double!
    var dataSpeed:Double = 0.0
    var chandraS:Bool!
    var urlString:String! //add by chandra 
    @IBOutlet weak var scrollSubview: UIView!
    @IBOutlet weak var scrollVW: UIScrollView!
    @IBOutlet weak var linkTableview: UITableView!
    @IBOutlet weak var submitBtnTopHightConstraint: NSLayoutConstraint! // add by chandra
    @IBOutlet weak var hightConstraintForContainerView: NSLayoutConstraint!
    @IBOutlet weak var hightConstraintForTableview: NSLayoutConstraint!
    @IBOutlet weak var briefTextVW: UITextView!
    @IBOutlet weak var linkedInTF: UITextField!
    @IBOutlet weak var associationLb: UILabel!
    @IBOutlet weak var occupationLb: UILabel!
    @IBOutlet weak var experienceTF: UITextField!
    @IBOutlet weak var gradesLb: UILabel!
    @IBOutlet weak var subjectsLb: UILabel!
    @IBOutlet weak var boardsLb: UILabel!

    @IBOutlet weak var weekendsTimeLb: UILabel!
    @IBOutlet weak var weekdaysTimeLb: UILabel!
    
    @IBOutlet weak var uploadSpeedTFConstraint: NSLayoutConstraint! //Added By DK!

    @IBOutlet weak var internetLb: UILabel! // Added on 31st Jan 2020

    /* Added By Deepak on 26th  March  2020 - starts here */
    @IBOutlet weak var uploadSpeedTF: UITextField! {
        didSet{
            uploadSpeedTF.keyboardType = UIKeyboardType.decimalPad //added by dk on 26th march 2020.
            uploadSpeedTF.isUserInteractionEnabled = false
        }
    }
     /* Added By Deepak on 26th  March  2020 - ends here */
   
      /* Added By Deepak on 26th  March  2020 - starts here */
    @IBOutlet weak var downloadSpeedTF: UITextField! {
        didSet{
            downloadSpeedTF.keyboardType = UIKeyboardType.decimalPad //added by dk on 26th march 2020.
            downloadSpeedTF.isHidden = true // added by dk on 14th April 2020.
            downloadSpeedTF.isUserInteractionEnabled = false
        }
    }
  /* Added By Deepak on 26th  March  2020 - ends  here */

    @IBOutlet weak var uploadSpBtn: UIButton!
    @IBOutlet weak var downloadSpBtn: UIButton! {
        didSet{
            downloadSpBtn.isHidden = true //Added by Dk on 16th april 2020.
        }
    }
    @IBOutlet weak var dleteResume: UIButton!
    @IBOutlet weak var uploadResumeBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var tableVW: UITableView!
    @IBOutlet weak var addVideoBtn: UIButton!
    @IBOutlet weak var addVideoHgt: NSLayoutConstraint!
    @IBOutlet weak var mainSubvwHgt: NSLayoutConstraint!
    @IBOutlet weak var uploadtableVW: UITableView!
    @IBOutlet weak var uploadAddVideoBtn: UIButton!
    @IBOutlet weak var uploadAddVideoHgt: NSLayoutConstraint!
     @IBOutlet weak var resumeImg: UIImageView!
    
//     add by chandra
     @IBOutlet weak var collectionView: UICollectionView!
    var videosArray = [String]()
    var addVideo = [[String:Any]]()
    var finalPath:String = ""
    var resumeurl:String!
    var selectedLb = 0
    var addVideosDict = [["DemoVideoID":0,"UserID":UserDefaults.standard.string(forKey: "userID")!,"VideoTitle":"","VideoUrl":"","uploadedDate":AppConstants().currentDateInUTC()]] as [[String : Any]]
    var uploadVideosDict = [["DemoVideoID":0,"UserID":UserDefaults.standard.string(forKey: "userID")!,"VideoTitle":"","VideoUrl":"","uploadedDate":AppConstants().currentDateInUTC()]] as [[String : Any]]
    var uploadIndex = 0
    
    //list of data to display
    var association = ["1":"Primary source of Income","2":"Passion for learning and teaching","3":"Others"]
    var occupation = ["1":"Teacher","2":"Professional","3":"Student","4":"Not working","5":"Other"]
    var grads = ["1":"1st","2":"2nd","3":"3rd","4":"4th","5":"5th","6":"6th","7":"7th","8":"8th","9":"9th","10":"10th","11":"11th","12":"12th","13":"UnderGraduates","14":"Graduates"]
    var subjects = ["1":"Science","2":"Technology","3":"English","4":"Maths"]
    var board = ["1":"CBSE","2":"ICSE","3":"IGCSE","4":"IB","5":"Others","6":"US Common Core"]
    var timings = ["1":"6-7am","2":"7-8am","3":"8-9am","4":"9-10am", "5":"11-12am","6": "12-1pm","7":"2-3pm","8":"3-4pm","9":"4-5pm","10":"5-6pm","11":"6-7pm","12":"7-8pm","13":"8-9pm","14":"9-10pm"] // Modified By Ranjeet on 1st Feb 2020
    var internet = ["1":"Broad band","2":"Wifi","3":"Dongle","4":"Mobile","5":"Cable","6":"Other"] // Added on 31st Jan 2020
    let subjectLi = UserDefaults.standard.array(forKey: "subjectArray") as! [String]

    lazy var selectionAss = [String:String]()
    lazy var selectionOccup = [String:String]()
    lazy var selectiongrads = [String:String]()
    lazy  var selectionsubj = [String:String]()
    lazy  var selectionboard = [String:String]()
    lazy  var selectionWeekendTm = [String:String]()
    lazy  var selectionWeekdayTm = [String:String]()
    lazy  var selectionInternet = [String:String]() // Added on 31st Jan 2020
    var isEdit = false
    var tutorDetails:JSON!
    var videosArr1 = [[String:Any]]()
    var videosArr2 = [[String:Any]]()
    var linkVideosArr = [Dictionary<String,Any>]()
    // to check speed in device
    typealias speedTestCompletionHandler = (_ megabytesPerSecond: Double? , _ error: Error?) -> Void
       var speedTestCompletionBlock : speedTestCompletionHandler?
       var startTime: CFAbsoluteTime!
       var stopTime: CFAbsoluteTime!
       var bytesReceived: Int!
    var docsArray = [String]() // Added By Ranjeet on 5th Feb 2020

    override func viewDidLoad() {
        super.viewDidLoad()
        uploadSpeedTFConstraint.constant = 5  /* Added By Dk on 17th  April  2020 */

        collectionView.delegate = self
        collectionView.dataSource = self
        // add by chandra for skip in tutor sign up form start here to
//         self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip",style: .plain, target: self,action: #selector(rightHandAction))
        // add by chandra for skip in tutor sign up form ends here to
        
        if isEdit == true{
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "",style: .plain, target: self,action: #selector(rightHandAction))
            let resumeUrl = tutorDetails["ResumeURL"].stringValue
            if resumeUrl.contains("pdf")  {
               //fileName = "ic_pdf"
                resumeImg.image = UIImage.init(named: "ic_pdf")
            }
            else if resumeUrl.contains("doc")  {
                resumeImg.image = UIImage.init(named: "ic_dox")
                //fileName = "ic_dox"
            }
            else if resumeUrl.contains("docx")  {
                resumeImg.image = UIImage.init(named: "ic_dox")
               // fileName = "ic_dox";
            }
            else if resumeUrl.contains("txt")  {
                resumeImg.image = UIImage.init(named: "ic_txt")
               // fileName = "ic_txt";
            }
            else if resumeUrl.contains("ppt")  {
                resumeImg.image = UIImage.init(named: "ic_ppt")
                //fileName = "ic_ppt";
            }
            else if resumeUrl.contains("xlsx")  {
                resumeImg.image = UIImage.init(named: "ic_xl")
               // fileName = "ic_xl";
            }
            else if resumeUrl.contains("xLs")  {
                resumeImg.image = UIImage.init(named: "ic_anonymous")
               // fileName = "ic_anonymous"
            }
            else{
                 resumeImg.image = UIImage.init(named: "ic_anonymous")
               // fileName = "ic_anonymous"
            }
            // add by chandra for hide the resume
            if docsArray.count != 0{
                submitBtnTopHightConstraint.constant = 100
                 resumeImg.isHidden = false
                dleteResume.isHidden = false
            }else if resumeUrl.count > 0{
                submitBtnTopHightConstraint.constant = 100
                resumeImg.isHidden = false
                dleteResume.isHidden = false
            }
            else{
                submitBtnTopHightConstraint.constant = 15
                resumeImg.isHidden = true
                dleteResume.isHidden = true
                
            }
        }else{
           submitBtnTopHightConstraint.constant = 15
            resumeImg.isHidden = true
            dleteResume.isHidden = true
        }
        hightConstraintForContainerView.constant = 0
        if isEdit == true{
             self.title = "Edit Tutor SignUp"
            submitBtn.setTitle("UPDATE", for: .normal) // ADD By chandra
        }else{
             self.title = "Tutor SignUp"
            submitBtn.setTitle("SUBMIT", for: .normal) // add by chandra
        }
        navigationController?.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        // Do any additional setup after loading the view.
        briefTextVW.text = "Brief description of yourself"
        briefTextVW.textColor = UIColor.lightGray
        briefTextVW.delegate = self
        linkedInTF.delegate = self
        addTapGesture(sender: associationLb)
        addTapGesture(sender: occupationLb)
        addTapGesture(sender: gradesLb)
        addTapGesture(sender: subjectsLb)
        addTapGesture(sender: boardsLb)
        addTapGesture(sender: weekendsTimeLb)
        addTapGesture(sender: weekdaysTimeLb)
        addTapGesture(sender: internetLb) // Added on 31st Jan 2020
        tableVW.delegate = self
        tableVW.dataSource = self
        uploadtableVW.delegate = self
        uploadtableVW.dataSource = self
        print(isEdit)
        if isEdit{
             /*  Updated By Ranjeet on 27th March 2020 - starts here */
            boardsLb.textColor = UIColor.black /* Added By Ranjeet on 9th April 2020 */
            if #available(iOS 13.0, *) {
                boardsLb.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
            }
             weekdaysTimeLb.textColor = UIColor.black /* Added By Ranjeet on 9th April 2020 */
            if #available(iOS 13.0, *) {
                weekdaysTimeLb.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
            }
            weekendsTimeLb.textColor = UIColor.black /* Added By Ranjeet on 9th April 2020 */
            if #available(iOS 13.0, *) {
                weekendsTimeLb.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
            }
            uploadSpeedTF.textColor = UIColor.black /* Added By Ranjeet on 9th April 2020 */
            if #available(iOS 13.0, *) {
                uploadSpeedTF.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
            }
            downloadSpeedTF.textColor = UIColor.black /* Added By Ranjeet on 9th April 2020 */
            if #available(iOS 13.0, *) {
                downloadSpeedTF.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
            }
            internetLb.textColor = UIColor.black /* Added By Ranjeet on 9th April 2020 */
            if #available(iOS 13.0, *) {
                internetLb.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
            }
            briefTextVW.textColor = UIColor.black /* Added By Ranjeet on 9th April 2020 */
            if #available(iOS 13.0, *) {
                briefTextVW.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
            }
            linkedInTF.textColor = UIColor.black /* Added By Ranjeet on 9th April 2020 */
            if #available(iOS 13.0, *) {
                linkedInTF.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
            }
            associationLb.textColor  = UIColor.black /* Added By Ranjeet on 9th April 2020 */
            if #available(iOS 13.0, *) {
                associationLb.textColor  = UIColor.label
            } else {
                // Fallback on earlier versions
            }
            occupationLb.textColor  = UIColor.black /* Added By Ranjeet on 9th April 2020 */
            if #available(iOS 13.0, *) {
                occupationLb.textColor  = UIColor.label
            } else {
                // Fallback on earlier versions
            }
            experienceTF.textColor  = UIColor.black /* Added By Ranjeet on 9th April 2020 */
            if #available(iOS 13.0, *) {
                experienceTF.textColor  = UIColor.label
            } else {
                // Fallback on earlier versions
            }
            gradesLb.textColor  = UIColor.black /* Added By Ranjeet on 9th April 2020 */
            if #available(iOS 13.0, *) {
                gradesLb.textColor  = UIColor.label
            } else {
                // Fallback on earlier versions
            }
            subjectsLb.textColor  = UIColor.black /* Added By Ranjeet on 9th April 2020 */
            if #available(iOS 13.0, *) {
                subjectsLb.textColor  = UIColor.label
            } else {
                // Fallback on earlier versions
            }
             /*  Updated By Ranjeet on 27th March 2020 - ends here */
            briefTextVW.text = tutorDetails?["TutorDescription"].stringValue
            linkedInTF.text = tutorDetails?["LinkedInUrl"].stringValue
            associationLb.text = association[(tutorDetails?["LTWAssociation"].stringValue)!]
            // add by chandra for display the videos start here
            linkVideosArr = tutorDetails?["TutorDemoVideos"].arrayObject as! [[String:Any]]
            for i in 0..<linkVideosArr.count{
                let checkVideos  = linkVideosArr[i]
                let data = checkVideos["VideoUrl"] as! String
                if data.contains("ltwuploadcontent"){
                    videosArr2.append(linkVideosArr[i])
                }else{
                    videosArr1.append(linkVideosArr[i])
                }
            }
//            print("uploadvideos>>\(uploadVideosArr.count)")
//            print("linkVideos>>\(linkVideosArr.count)")
//            for i in 0..<TutorDemoVideos.count{
//                let index = TutorDemoVideos[i]
               // linkVideosArr = TutorDemoVideos
            //}
            print(index)
            print("linkVideos>>\(linkVideosArr.count)")
            collectionView.reloadData()
            if linkVideosArr.count == 0{
              hightConstraintForContainerView.constant = 0
            }else{
              hightConstraintForContainerView.constant = 190
            }
//    add by chandra for display the videos  ends here
            // for selection
            selectionAss[(tutorDetails?["LTWAssociation"].stringValue)!] = associationLb.text
      // current CurrentOccupation code start here
            let currentOccupation = tutorDetails?["CurrentOccupation"].stringValue
            let arrCurrentOccupation = currentOccupation?.split(separator: ",").map{String($0)}
            if arrCurrentOccupation?.count != 0{
                occupationLb.text?.removeAll()
            }
            for i in arrCurrentOccupation!{
                let index = occupation[i]
                occupationLb.text? = index!
            }
    selectionOccup[(tutorDetails?["CurrentOccupation"].stringValue)!] = occupationLb.text //  // current CurrentOccupation code ends here
             experienceTF.text = tutorDetails?["WorkExperience"].stringValue
            let res = tutorDetails["TutorCanTeach"].stringValue
            // commented by chandra start here 6 may 2020
//            let str = res.split(separator: ",")
//            print(str) // ["3", "1", "5", "2", "4"]
//                           for i in 0..<str.count {
//                               let temp = str[i]
//                               if temp.contains("13"){
//                                   res = res.replacingOccurrences(of: "13", with: "UnderGradute")
//                               }
//                               else if temp.contains("14"){
//                                   res = res.replacingOccurrences(of: "14", with: "Gradute")
//                               }
////                                else if temp.contains("1"){
////                                    res = res.replacingOccurrences(of: "1", with: "1st")
////                                }
////                                else if temp.contains("2"){
////                                    res = res.replacingOccurrences(of: "2", with: "2nd")
////                                }
////                                else if temp.contains("3"){
////                                    res = res.replacingOccurrences(of: "3", with: "3rd")
////                                }
//                               else {
//                                   res = res.replacingOccurrences(of: temp, with: "\(temp)th")
//                               }
//                           }
// commented by chandra ends here 6 may 2020
            // add by chandra start here to 6 may
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
            for (index,element) in str.enumerated()
            {
                selectiongrads["\(element)"] = "\(values[index])"
            }
            let string = res1.joined(separator: ",")
            gradesLb.text? = "\(string)"
//            let values = res.split(separator: ",")
//            print(values)
//            for (index,element) in str.enumerated()
//            {
//            selectiongrads["\(element)"] = "\(values[index])"
//            }
            
//                 gradesLb.text? = res
//            selectiongrads[(tutorDetails?["TutorCanTeach"].stringValue)!] = gradesLb.text // add by chandra
            
            let TutorSubjectTeach = tutorDetails["TutorSubjectTeach"].stringValue
            let tutorSubjectTeach = TutorSubjectTeach.split(separator: ",")
            print(tutorSubjectTeach) //["4", "1", "2", "3"]
            if tutorSubjectTeach.count != 0{
                subjectsLb.text!.removeAll()
            }
                    for i in TutorSubjectTeach.split(separator: ","){
                               if(subjectsLb.text!.isEmpty)
                               {
                                   subjectsLb.text! = self.subjectLi[(Int(i) ?? 0)-1]
                               }
                               else
                               {
                                   subjectsLb.text! += "," + self.subjectLi[(Int(i) ?? 0)-1]
                               }
                           }
            let subjectsdata = subjectsLb.text!.split(separator: ",")
            print(subjectsdata)
                       for (index,element) in tutorSubjectTeach.enumerated()
                       {
                       selectionsubj["\(element)"] = "\(subjectsdata[index])"
                       }
//selectionsubj[(tutorDetails?["TutorSubjectTeach"].stringValue)!] =  subjectsLb.text // add by chandra
         print(tutorDetails)
            print(subjectsLb.text!)
            // bord can teach start here
    let data = tutorDetails?["BoardsCanTeach"].stringValue
    let dataTwo = data?.split(separator: ",").map { String($0) }
           
            if dataTwo?.count != 0{
                 boardsLb.text!.removeAll()
            }
            for i in dataTwo!{
                let bordsLblData = board[i]!
                if(boardsLb.text!.isEmpty){
                        boardsLb.text! = bordsLblData
                }else{
                        boardsLb.text! += "," + bordsLblData
                    }
            }
            
            let dataStr =  boardsLb.text
            let boardsdata = dataStr!.split(separator: ",")
            for (index,element) in dataTwo!.enumerated()
                                  {
                                  selectionboard["\(element)"] = "\(boardsdata[index])"
                                  }
   
//                selectionboard[(tutorDetails?["BoardsCanTeach"].stringValue)!] =   boardsLb.text! // add by chandra
                
           
           // bord can teach ends  here
     
            
// week days code start  here

            
            if (tutorDetails?["Weekdays"].stringValue.count)! > 0 {
              weekdaysTimeLb.text = ""//tutorDetails?["Weekdays"].stringValue
            }
            let weekdays = tutorDetails?["Weekdays"].stringValue
            let arrWeekdays = weekdays?.split(separator: ",").map{String($0)}
            print(arrWeekdays!)
            if arrWeekdays?.count != 0{
                 weekdaysTimeLb.text!.removeAll()
            }
            for i in arrWeekdays!{
                let index = timings[i]!
                if (weekdaysTimeLb.text!.isEmpty){
                    weekdaysTimeLb.text! = index
                }else{
                    weekdaysTimeLb.text! += "," + index
                }
            }
            print( weekdaysTimeLb.text!)
            let weekDays = weekdaysTimeLb.text!.split(separator: ",")
            for (index,element) in arrWeekdays!.enumerated()
                            {
                                selectionWeekdayTm["\(element)"] = "\(weekDays[index])"
                                    }
// selectionWeekdayTm[(tutorDetails?["Weekdays"].stringValue)!] = weekdaysTimeLb.text // add by chandra
// week days code ends   here
            
            
    // weekEnds code start here
            if (tutorDetails?["WeekEnds"].stringValue.count)! > 0 {
              weekendsTimeLb.text = "" //tutorDetails?["WeekEnds"].stringValue
            }
            let weekEnds = tutorDetails?["WeekEnds"].stringValue
            let arrWeekEnds = weekEnds?.split(separator: ",").map{String($0)}
            if arrWeekdays?.count != 0{
                 weekendsTimeLb.text!.removeAll()
            }
            for i in arrWeekEnds!{
                let index = timings[i]
                if (weekendsTimeLb.text!.isEmpty){
                    weekendsTimeLb.text! = index!
                }else{
                    weekendsTimeLb.text! += "," + index!
                }
            }
            
            let weekEndsdata =  weekendsTimeLb.text!.split(separator: ",")
            for (index,element) in arrWeekEnds!.enumerated()
                {
                    selectionWeekendTm["\(element)"] = "\(weekEndsdata[index])"
                        }
// selectionWeekendTm[(tutorDetails?["WeekEnds"].stringValue)!] = weekendsTimeLb.text // add by chandra
      // weekEnds code ends here
            

// InternetConnection code start here
     let internetConnectionCheck = tutorDetails?["InternetConnection"].stringValue
            if  tutorDetails?["InternetConnection"].stringValue == "0" {
                internetLb.textColor = UIColor.lightGray
               internetLb.text = "Internet Connection"
            }else{
                let dictInternetConnectionCheck = internetConnectionCheck?.split(separator: ",").map{String($0)}
                           if dictInternetConnectionCheck?.count != 0{
                                internetLb.text!.removeAll()
                           }
                           for i in dictInternetConnectionCheck! {
                               let index = internet[i]
                              internetLb.textColor = UIColor.black /* Added By Ranjeet on 9th April 2020 */
                            if #available(iOS 13.0, *) {
                                internetLb.textColor = UIColor.label
                            } else {
                                // Fallback on earlier versions
                            }
                              internetLb.text = index
                           }
            }
 selectionInternet[(tutorDetails?["InternetConnection"].stringValue)!] = internetLb.text // add by chandra
// InternetConnection code ends here
//uploadSpeedTF.text = tutorDetails?["uploadSpeed"].stringValue
//downloadSpeedTF.text = tutorDetails?["downloadSpeed"].stringValue
    uploadSpeedTF.text = tutorDetails?["downloadSpeed"].stringValue // add by chandra
        }
       
        // abb by chandra for view doc start here
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resumeTappedMethod(_:)))
         resumeImg.isUserInteractionEnabled = true
         resumeImg.addGestureRecognizer(tapGestureRecognizer)
        // abb by chandra for view doc ends
        
    }
// add by chandra for skip in tutor form start here to
//    @objc func rightHandAction() {
//           print("right bar button action")
//           UserDefaults.standard.set(true, forKey: "Skip") //Bool
//         self.title = ""
//        let group = self.storyboard?.instantiateViewController(withIdentifier: "AvailableGroupSignUpViewController") as! AvailableGroupSignUpViewController
//        group.modalPresentationStyle = .fullScreen
//        self.present(group, animated: true, completion: nil)
//        // commented by chandra for home screen
////           UIApplication.shared.keyWindow!.rootViewController!.dismiss(animated: true, completion: nil)
////           UIApplication.shared.keyWindow?.rootViewController = VSCore().launchHomePage(index: 0)
//       }
//    add by chandra for skip in tutor form ends here
   
    func checkForSpeedTest() {
           testDownloadSpeedWithTimout(timeout: 5.0) { (speed, error) in //updated by dk on 16th april 2020.
               print("Download Speed:", speed ?? "NA")
               print("Speed Test Error:", error ?? "NA")
               self.data = speed
            if self.data < 0.0 {
                self.data = 2.67 //Dummy Speed, if speed is not detected.
            }
               DispatchQueue.main.async {
                    self.downloadSpeedTF.text = "\(round(self.data * 4.0)/4.0) Mb/sec"
                    self.uploadSpeedTF.text = "\(round(self.data * 4.0)/4.0) Mb/sec"
                self.dataSpeed = round(self.data * 4.0)/4.0
               }
           }
       }
     func testDownloadSpeedWithTimout(timeout: TimeInterval, withCompletionBlock: @escaping speedTestCompletionHandler) {
            guard let url = URL(string: "https://images.apple.com/v/imac-with-retina/a/images/overview/5k_image.jpg") else { return }
            startTime = CFAbsoluteTimeGetCurrent()
            stopTime = startTime
            bytesReceived = 0
            speedTestCompletionBlock = withCompletionBlock
            let configuration = URLSessionConfiguration.ephemeral
            configuration.timeoutIntervalForResource = timeout
            let session = URLSession.init(configuration: configuration, delegate: self, delegateQueue: nil)
            session.dataTask(with: url).resume()
        }
        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
            bytesReceived! += data.count
            stopTime = CFAbsoluteTimeGetCurrent()
        }
        func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            let elapsed = stopTime - startTime
            if let aTempError = error as NSError?, aTempError.domain != NSURLErrorDomain && aTempError.code != NSURLErrorTimedOut && elapsed == 0  {
                speedTestCompletionBlock?(nil, error)
                return
            }
            let speed = elapsed != 0 ? Double(bytesReceived) / elapsed / 1024.0 / 1024.0 : -1
            speedTestCompletionBlock?(speed, nil)
        }

    /* Right Bar Button  Function Code Starts Here By Ranjeet on 1st Feb 2020*/
//       @objc func onTimeBeingRightBarBtnClick(){
//    UIApplication.shared.keyWindow!.rootViewController!.dismiss(animated: true, completion: nil)
//                                         UIApplication.shared.keyWindow?.rootViewController = VSCore().launchHomePage(index: 0)
//       }
       /* Right Bar Button  Function Code Ends  Here  By Ranjeet on 1st Feb 2020*/
    override func viewWillAppear(_ animated: Bool) {
        if !isEdit{
            self.navigationItem.setHidesBackButton(true, animated:true);
        }
    }
    @objc func resumeTappedMethod(_ sender:AnyObject){
        //add for view resume
        let resumedata = tutorDetails?["ResumeURL"].stringValue
        if resumedata != nil&&resumedata != ""{
            let webVc = storyboard?.instantiateViewController(withIdentifier: "WebVC") as! WebVC
            webVc.myTitle = "openDoc"
            webVc.documentUrl = resumedata
            self.startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
            self.navigationController?.pushViewController(webVc, animated: true)
            
            
        }else{
            print("resume\(String(describing: resumedata))")
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(false, animated:true);
    }
    private func addUnderLines(){
//        briefTextVW.useUnderline() // commented by chandra 
        // add by chandra for text view ui issue start here to
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: linkedInTF.bounds.size.width, height: 1)
        topBorder.backgroundColor = UIColor.init(hex: "2DA9EC").cgColor
        linkedInTF.layer.addSublayer(topBorder)
        // add by chandra for text view ui issue ends here to
        
        linkedInTF.useUnderline()
        associationLb.useUnderline()
        occupationLb.useUnderline()
        experienceTF.useUnderline()
        experienceTF.useUnderline()
        gradesLb.useUnderline()
        subjectsLb.useUnderline()
        boardsLb.useUnderline()
        internetLb.useUnderline()
        weekendsTimeLb.useUnderline()
        weekdaysTimeLb.useUnderline()
        uploadSpeedTF.useUnderline()
        downloadSpeedTF.useUnderline()
        internetLb.useUnderline()  // Added on 31st Jan 2020
        uploadSpBtn.boderForBtn(color: UIColor.init(hex: "2DA9EC"))
        downloadSpBtn.boderForBtn(color: UIColor.init(hex: "2DA9EC"))
        submitBtn.backgroundColor = UIColor.init(hex: "60A200")
        uploadResumeBtn.boderForBtn(color: UIColor.init(hex: "2DA9EC"))
        
    }
    
    override func viewDidLayoutSubviews() {
       self.addUnderLines()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.resignFirstResponder()
        self.removeChild()
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField.tag > 5
//        {
//            let index = textField.tag - 6
//            var dict = uploadVideosDict[index]
//            dict["VideoTitle"] = textField.text
//            uploadVideosDict[index] = dict
//
//        }else
//        {
//            var dict = addVideosDict[textField.tag]
//                  if textField.placeholder == "Video Title"
//                  {
//                      dict["VideoTitle"] = textField.text
//                    addVideosDict[textField.tag] = dict
//                  }else if textField.placeholder == "Video Link"
//                  {
//                      dict["VideoUrl"] = textField.text
//                    addVideosDict[textField.tag] = dict
//
//                  }
//        }
        
        if textField.tag > 5
        {
            let index = textField.tag - 6
            var dict = uploadVideosDict[index]
            dict["VideoTitle"] = textField.text
            uploadVideosDict[index] = dict
            
        }else
        {
            var dict = addVideosDict[textField.tag]
            if textField.placeholder == "Video Title"{
                dict["VideoTitle"] = textField.text
                addVideosDict[textField.tag] = dict
            }else if textField.placeholder == "Video Link"{
               // chandraS = isValidUrl(url:textField.text ?? "") // add by chandra
                    chandraS = verifyUrl(urlString: textField.text ?? "")
                    dict["VideoUrl"] = textField.text
                    addVideosDict[textField.tag] = dict
               
                
                
            }
        }
        
        
        
        
    }
     /*  Updated By Ranjeet on 27th March 2020 - starts here */
    func doneBtnClicked(str: [String:String]) {
        switch selectedLb {
        case 1: //Association
            selectionAss = str
             associationLb.textColor = UIColor.black /* Added By Ranjeet on 9th April 2020 */
            if #available(iOS 13.0, *) {
                associationLb.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
            }
            associationLb.text = str.values.joined(separator: ",")
            break
        case 2://Occupation
            selectionOccup = str
             occupationLb.textColor = UIColor.black /* Added By Ranjeet on 9th April 2020 */
            if #available(iOS 13.0, *) {
                occupationLb.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
            }
            occupationLb.text = str.values.joined(separator: ",")
            break
        case 3://grads
            selectiongrads = str
            gradesLb.textColor = UIColor.black /* Added By Ranjeet on 9th April 2020 */
            if #available(iOS 13.0, *) {
                gradesLb.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
            }
            gradesLb.text = str.values.joined(separator: ",")
            break
        case 4://subjects
            selectionsubj = str
            subjectsLb.textColor = UIColor.black /* Added By Ranjeet on 9th April 2020 */
            if #available(iOS 13.0, *) {
                subjectsLb.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
            }
            subjectsLb.text = str.values.joined(separator: ",")
            break
        case 5://Boards
            selectionboard = str
            boardsLb.textColor = UIColor.black /* Added By Ranjeet on 9th April 2020 */
            if #available(iOS 13.0, *) {
                boardsLb.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
            }
            boardsLb.text = str.values.joined(separator: ",")
            break
        case 6://weekdaytiming
            selectionWeekdayTm = str
            weekdaysTimeLb.textColor = UIColor.black /* Added By Ranjeet on 9th April 2020 */
            if #available(iOS 13.0, *) {
                weekdaysTimeLb.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
            }
            weekdaysTimeLb.text =  str.values.joined(separator: ",")
            break
        case 7://weekendtiming
            selectionWeekendTm = str
            weekendsTimeLb.textColor = UIColor.black /* Added By Ranjeet on 9th April 2020 */
            if #available(iOS 13.0, *) {
                weekendsTimeLb.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
            }
            weekendsTimeLb.text = str.values.joined(separator: ",")
            break
            case 8://weekendtiming
            selectionInternet = str
            internetLb.textColor = UIColor.black /* Added By Ranjeet on 9th April 2020 */
            if #available(iOS 13.0, *) {
                internetLb.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
            }
            internetLb.text = str.values.joined(separator: ",")
            break
        default:
            break
        }
         /*  Updated By Ranjeet on 27th March 2020 - ends here */
        selectedLb = 0
        self.removeChild()
      }
      func calcelBtnClinked() {
          self.removeChild()
      }
    func addTapGesture(sender:UILabel){
        let tap = UITapGestureRecognizer(target: self, action: #selector(TutorSignUpVC.tapFunction))
        sender.addGestureRecognizer(tap)
        
    }
    @objc func tapFunction(gesture:UITapGestureRecognizer){
//        let lbframe = gesture.location(in: self.view)
        let controller:SelectionVC = self.storyboard!.instantiateViewController(withIdentifier: "SelectionVC") as! SelectionVC
        controller.delegate = self
        switch gesture.view?.tag {
        case 1: //Association
            selectedLb = 1
            controller.view.frame = CGRect.init(x: self.view.center.x - (self.view.frame.width - 50)/2, y: self.view.center.y - self.view.frame.size.height/2 + 100 , width: self.view.frame.width - 50 , height: CGFloat(association.count * 60) )
            controller.dictList = association
            controller.selectDict =  selectionAss
            controller.strType = true
            break
        case 2://Occupation
            selectedLb = 2
            controller.view.frame = CGRect.init(x: self.view.center.x - (self.view.frame.width - 50)/2, y: self.view.center.y - self.view.frame.size.height/2 + 100, width: self.view.frame.width - 50 , height: CGFloat(occupation.count * 60))
            controller.dictList = occupation
            controller.selectDict =  selectionOccup
            controller.strType = true
            break
            
        case 3://grads
            selectedLb = 3
            if CGFloat(grads.count * 60) > self.view.frame.size.height - 100
            {
                controller.view.frame = CGRect.init(x: self.view.center.x - (self.view.frame.width - 50)/2, y: self.view.center.y - self.view.frame.size.height/2 + 100 , width: self.view.frame.width - 50 , height: self.view.frame.size.height - 150)
            }else
            {
                controller.view.frame = CGRect.init(x: self.view.center.x - (self.view.frame.width - 50)/2, y: self.view.center.y - CGFloat(grads.count * 60)/2, width: self.view.frame.width - 50 , height: CGFloat(grads.count * 60) )
            }
            controller.dictList = grads
            controller.selectDict =  selectiongrads
            controller.strType = false
            break
        case 4://subjects
            selectedLb = 4
            controller.view.frame = CGRect.init(x: self.view.center.x - (self.view.frame.width - 50)/2, y: self.view.center.y - self.view.frame.size.height/2 + 100, width: self.view.frame.width - 50 , height: CGFloat(subjects.count * 60))
            controller.dictList = subjects
            controller.selectDict =  selectionsubj
            controller.strType = false
            break
        case 5://Boards
            selectedLb = 5
            controller.view.frame = CGRect.init(x: self.view.center.x - (self.view.frame.width - 50)/2, y: self.view.center.y - self.view.frame.size.height/2 + 100 , width: self.view.frame.width - 50 , height: CGFloat(board.count * 60))
            controller.dictList = board
            controller.selectDict =  selectionboard
            controller.strType = false
            break
        case 6://weekdaytiming
            selectedLb = 6
            if CGFloat(timings.count * 60) > self.view.frame.size.height - 100
            {
                controller.view.frame = CGRect.init(x: self.view.center.x - (self.view.frame.width - 50)/2, y: self.view.center.y - self.view.frame.size.height/2 + 100, width: self.view.frame.width - 50 , height: self.view.frame.size.height - 150)
            }else
            {
                controller.view.frame = CGRect.init(x: self.view.center.x - (self.view.frame.width - 50)/2, y: self.view.center.y - CGFloat(timings.count * 60)/2, width: self.view.frame.width - 50 , height: CGFloat(timings.count * 60) )
            }
            controller.dictList = timings
            controller.selectDict =  selectionWeekdayTm
            controller.strType = false
            break
        case 7://weekendtiming
            selectedLb = 7
            if CGFloat(timings.count * 60) > self.view.frame.size.height - 100
            {
                controller.view.frame = CGRect.init(x: self.view.center.x - (self.view.frame.width - 50)/2, y: self.view.center.y - self.view.frame.size.height/2 + 100 , width: self.view.frame.width - 50 , height: self.view.frame.size.height - 150)
            }else
            {
                controller.view.frame = CGRect.init(x: self.view.center.x - (self.view.frame.width - 50)/2, y: self.view.center.y - CGFloat(timings.count * 60)/2, width: self.view.frame.width - 50 , height: CGFloat(timings.count * 60) )
            }
           
            controller.dictList = timings
            controller.selectDict =  selectionWeekendTm
            controller.strType = false
            break
            case 8://subjects
            selectedLb = 8
            controller.view.frame = CGRect.init(x: self.view.center.x - (self.view.frame.width - 50)/2, y: self.view.center.y - self.view.frame.size.height/2 + 100, width: self.view.frame.width - 50 , height: CGFloat(internet.count * 60))
            controller.dictList = internet
            controller.selectDict =  selectionInternet
            controller.strType = true
        default:
            break
        }
        controller.willMove(toParent: self)
        self.view.addSubview(controller.view)
        self.addChild(controller)
        controller.didMove(toParent: self)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.removeChild()
        if briefTextVW.textColor == UIColor.lightGray {
            briefTextVW.text = ""
            briefTextVW.textColor = UIColor.black /* Added By Ranjeet on 9th April 2020 */
            /*  Updated By Ranjeet on 27th March 2020 - starts here */
            if #available(iOS 13.0, *) {
                briefTextVW.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
            }
            /*  Updated By Ranjeet on 27th March 2020 - ends here */
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if briefTextVW.text == "" {
            briefTextVW.text = "Brief description of yourself"
            briefTextVW.textColor = UIColor.lightGray
        }
    }
    func validateData()
    {
        if briefTextVW.text == "Brief description of yourself" || briefTextVW.text == ""  || briefTextVW.text.isEmpty || briefTextVW.text.trimmingCharacters(in: .whitespaces).isEmpty
        {
          //  showMessage(bodyText: "Please enter brief description",theme: .warning) /*  Commented By Ranjeet on 19th March 2020 */
            showMessage(bodyText: "Enter brief description to introduce yourself",theme: .warning) /*  Updated By Ranjeet on 19th March 2020 */
            return
        }
        
        if selectionAss.count < 1 {
            showMessage(bodyText: "Please select association with LearnTeachWorld",theme: .warning)
            return
        }

        if selectionOccup.count < 1 {
           // showMessage(bodyText: "Please select current occupation",theme: .warning) /*  Commented By Ranjeet on 19th March 2020 */
            showMessage(bodyText: "Select Current Profession",theme: .warning) /*  Updated  By Ranjeet on 19th March 2020 */
            return
        }
        
        guard let workExp = experienceTF.text, !workExp.trimmingCharacters(in: .whitespaces).isEmpty else {
            // showMessage(bodyText: "Enter work experience",theme: .warning) /*  Commented By Ranjeet on 19th March 2020 */
            showMessage(bodyText: "Enter your Professional Experience",theme: .warning) /*  Updated By Ranjeet on 19th March 2020 */
            return
        }
        if selectionboard.count < 1 {
            //  showMessage(bodyText: "Please select Board",theme: .warning) /*  Commented By Ranjeet on 19th March 2020 */
            showMessage(bodyText: "Select Entrance Exam board",theme: .warning) /*  Updated By Ranjeet on 19th March 2020 */
            return
        }
        
      if selectiongrads.count < 1  {
            showMessage(bodyText: "Please select Grades",theme: .warning)
            return
        }
         if selectionsubj.count < 1 {
            showMessage(bodyText: "Please select Subjects",theme: .warning)
            return
        }
        if selectionboard.count < 1 {
            
            showMessage(bodyText: "Please select Board",theme: .warning)
            return
            
        }
        var addVideo = addVideosDict
        //to check both title and URL
        for (index , element) in addVideosDict.enumerated() {
            if (element["VideoTitle"] as! String == ""  &&  element["VideoUrl"] as! String == ""){
                 addVideo.remove(at: index)
                print("one is both empty")
            }else if chandraS != true {
                showMessage(bodyText: "Enter Valid URL",theme: .warning)
             return
            }
            else if (element["VideoTitle"] as! String != "" && element["VideoUrl"] as! String != ""){
            
            }else if (element["VideoTitle"] as! String != "" ||  element["VideoUrl"] as! String != ""){
                showMessage(bodyText: "Please enter both title and URL link",theme: .warning)
                return
            }
        }
        
        var uploadVideo = uploadVideosDict
    
        for (index , element) in uploadVideosDict.enumerated() {
            
            if (element["VideoTitle"] as! String == ""  &&  element["VideoUrl"] as! String == ""){
                 uploadVideo.remove(at: index)
                print("one is both empty")
                if videosArray.contains(element["VideoUrl"]as! String){
                    videosArray.remove(at:videosArray.index(of:element["VideoUrl"] as! String)!)
                }
            }else if (element["VideoTitle"] as! String != "" && element["VideoUrl"] as! String != ""){
                uploadVideo[index]["VideoUrl"] = "https://ltwuploadcontent.blob.core.windows.net/videos/" + (element["VideoUrl"] as! NSString).lastPathComponent
                videosArray.append(element["VideoUrl"]as! String)

            }else if (element["VideoTitle"] as! String != "" ||  element["VideoUrl"] as! String != "")
            {
                showMessage(bodyText: "Please enter both title and URL link",theme: .warning)
                return
            }
        }
        
        addVideo += uploadVideo
        
        submitBtn.isEnabled = false
        let params: [String:Any] =  [
            "TutorID": "",
            "UserID": UserDefaults.standard.string(forKey: "userID")!,
            "TutorDescription": briefTextVW.text!,
            "LinkedInUrl": linkedInTF.text!,
            "LTWAssociation": selectionAss.keys.joined(separator: ","),
            "CurrentOccupation": selectionOccup.keys.joined(separator: ","),
            "WorkExperience": workExp,
            "TutorCanTeach": selectiongrads.keys.joined(separator: ","),
            "TutorSubjectTeach": selectionsubj.keys.joined(separator: ","),
            "BoardsCanTeach": selectionboard.keys.joined(separator: ","),
            "Weekdays": selectionWeekdayTm.keys.joined(separator: ","),
            "WeekEnds": selectionWeekendTm.keys.joined(separator: ","),
            "InternetConnection": selectionInternet.keys.joined(separator: ","),
            "uploadSpeed": "",
            "downloadSpeed": dataSpeed, // add by chandra new
            "ResumeURL":UserDefaults.standard.object(forKey: "resume") as? String ?? "",
            "TutorDemoVideos":addVideo
            ]
        hitSever(params: params)
               
    }
 // add by chandra for update the tutor info
   func validateDataForEdit() {
        if briefTextVW.text == "Brief description of yourself" || briefTextVW.text == ""  || briefTextVW.text.isEmpty || briefTextVW.text.trimmingCharacters(in: .whitespaces).isEmpty
        {
            showMessage(bodyText: "Please enter brief description",theme: .warning)
            return
        }
        if selectionAss.count < 1 {
            showMessage(bodyText: "Please select association with LearnTeachWorld",theme: .warning)
            return
        }
        if selectionOccup.count < 1 {
            showMessage(bodyText: "Please select current occupation",theme: .warning)
            return
        }
        guard let workExp = experienceTF.text, !workExp.trimmingCharacters(in: .whitespaces).isEmpty else {
            showMessage(bodyText: "Enter work experience",theme: .warning)
            return
        }
        if selectionboard.count < 1 {
            
            showMessage(bodyText: "Please select Board",theme: .warning)
            return
        }
      if selectiongrads.count < 1  {
            showMessage(bodyText: "Please select Grades",theme: .warning)
            return
        }
         if selectionsubj.count < 1 {
            showMessage(bodyText: "Please select Subjects",theme: .warning)
            return
        }
        if selectionboard.count < 1 {
            
            showMessage(bodyText: "Please select Board",theme: .warning)
            return
            
        }
        addVideo = addVideosDict
        //to check both title and URL
        for (index , element) in addVideosDict.enumerated() {
            print("\(index): \(element)")
            if (element["VideoTitle"] as! String == ""  &&  element["VideoUrl"] as! String == "")
            {
                addVideo.remove(at: index)
                print("one is both empty")
            }else if chandraS != true {
                showMessage(bodyText: "Enter Valid URL",theme: .warning)
             return
            }
            else if (element["VideoTitle"] as! String != "" && element["VideoUrl"] as! String != ""){
               
            }else if (element["VideoTitle"] as! String != "" ||  element["VideoUrl"] as! String != ""){
                showMessage(bodyText: "Please enter both title and URL link",theme: .warning)
                return
            }
        }
        var uploadVideo = uploadVideosDict
        for (index , element) in uploadVideosDict.enumerated() {
            
            if (element["VideoTitle"] as! String == ""  &&  element["VideoUrl"] as! String == "")
            {
                 uploadVideo.remove(at: index)
                print("one is both empty")
                if videosArray.contains(element["VideoUrl"]as! String)
                {
                    videosArray.remove(at:videosArray.index(of:element["VideoUrl"] as! String)!)
                }
              
            }else if (element["VideoTitle"] as! String != "" && element["VideoUrl"] as! String != "")
            {
                uploadVideo[index]["VideoUrl"] = "https://ltwuploadcontent.blob.core.windows.net/videos/" + (element["VideoUrl"] as! NSString).lastPathComponent
                videosArray.append(element["VideoUrl"]as! String)
                

            }else if (element["VideoTitle"] as! String != "" ||  element["VideoUrl"] as! String != "")
            {
                showMessage(bodyText: "Please enter both title and URL link",theme: .warning)
                return
            }
        }
        addVideo += uploadVideo
        submitBtn.isEnabled = false
        //"bb197b3c-80e4-48bf-81b2-a04ac96ad693"
        let params: [String:Any] =  [
            "TutorID": "",
            "UserID": UserDefaults.standard.string(forKey: "userID")!,
            "TutorDescription": briefTextVW.text!,
            "LinkedInUrl": linkedInTF.text!,
            "LTWAssociation": selectionAss.keys.joined(separator: ","),
            "CurrentOccupation": selectionOccup.keys.joined(separator: ","),
            "WorkExperience": workExp,
            "TutorCanTeach": selectiongrads.keys.joined(separator: ","),
            "TutorSubjectTeach": selectionsubj.keys.joined(separator: ","),
            "BoardsCanTeach": selectionboard.keys.joined(separator: ","),
            "Weekdays": selectionWeekdayTm.keys.joined(separator: ","),
            "WeekEnds": selectionWeekendTm.keys.joined(separator: ","),
            "InternetConnection": selectionInternet.keys.joined(separator: ","),
            "uploadSpeed": "",
            "downloadSpeed": dataSpeed, // add by chandra new
            "ResumeURL": UserDefaults.standard.object(forKey: "resume") as? String ?? "" ,
            "TutorDemoVideos":addVideos()
            ]
        hitSeverForEdit(params: params)
           
    }
    func addVideos()->[[String:Any]]{
        //let addedVideos : [[String:Any]] = []
        linkVideosArr += addVideo
        return linkVideosArr
    }
    func hitSever(params :[String:Any]){
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: Endpoints.tutorSignUp, using: .post, dueToAction: "TutorSignUp"){ result in
            self.stopAnimating()
            self.submitBtn.isEnabled = true
            switch result {
            case let .success(json,_):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                    
                }else {
                    UserDefaults.standard.set(params, forKey: "tutorInfo")
                    AzureUpload().uploadBlobToContainer(filePathArray: self.videosArray, containerType: "Videos")
                    AzureUpload().uploadBlobToContainer(filePathArray: self.docsArray, containerType: "tutorresume") // add by chandra for doc
                    UserDefaults.standard.set(self.selectiongrads.keys.joined(separator: ","), forKey: "teaching")
                    UserDefaults.standard.set(self.linkedInTF.text!, forKey: "linkedinUrl")
                    UserDefaults.standard.set(self.experienceTF.text!, forKey: "workExp")
                    UserDefaults.standard.set(false, forKey: "Tutor")
                    UserDefaults.standard.set(true, forKey: "PostSignupGroupPage")
                    UserDefaults.standard.synchronize()
                    /* commented by veeresh on 5th march 2020 */
//                    UIApplication.shared.keyWindow!.rootViewController!.dismiss(animated: true, completion: nil)
//                    UIApplication.shared.keyWindow?.rootViewController = VSCore().launchHomePage(index: 0)
                    /* added by veeresh on 5th march 2020 */

                    /* Commented  By Veeresh on 24th April 2020 - starts here */
 //                   print("tour demo") // tourSlidesVC
//                    let tourDemo = self.storyboard?.instantiateViewController(withIdentifier: "tourSlidesVC") as! tourSlidesVC
//                    tourDemo.modalPresentationStyle = .fullScreen
//                    self.present(tourDemo, animated: true, completion: nil)
                    /* Commented By Veeresh on 24th April 2020 - ends here */
                    
                    /* Added By Veeresh on 24th April 2020 - starts here */
                    
                    let group = self.storyboard?.instantiateViewController(withIdentifier: "AvailableGroupSignUpViewController") as! AvailableGroupSignUpViewController
                                        group.modalPresentationStyle = .fullScreen
                                        self.present(group, animated: true, completion: nil)
                    /* Added By Veeresh on 24th April 2020 - ends  here */

                    /* Launch Home Page  Till Here */
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    // add by chandra for updateTutor
    func hitSeverForEdit(params :[String:Any]){
         startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
         LTWClient.shared.hitService(withBodyData: params, toEndPoint: Endpoints.updateTutorInfo, using: .post, dueToAction: "TutorSignUp"){ result in
             self.stopAnimating()
             self.submitBtn.isEnabled = true
             switch result {
             case let .success(json,_):
                 
                 let msg = json["message"].stringValue
                 if json["error"].intValue == 1 {
                     showMessage(bodyText: msg,theme: .error)
                     
                 }else {
                    print(self.docsArray)
                      AzureUpload().uploadBlobToContainer(filePathArray: self.docsArray, containerType: "tutorresume") // add by chandra for doc
                     UserDefaults.standard.set(params, forKey: "tutorInfo")
                     AzureUpload().uploadBlobToContainer(filePathArray: self.videosArray, containerType: "Videos")
                     UserDefaults.standard.set(self.selectiongrads.keys.joined(separator: ","), forKey: "teaching")
                     UserDefaults.standard.set(self.linkedInTF.text!, forKey: "linkedinUrl")
                     UserDefaults.standard.set(self.experienceTF.text!, forKey: "workExp")
                     UserDefaults.standard.set(false, forKey: "Tutor")
                    self.navigationController?.popViewController(animated: true)
                     /* Launch Home Page  Till Here */
                 }
                 break
             case .failure(let error):
                 print("MyError = \(error)")
                 break
             }
         }
     }
    @IBAction func onDownloadSpeedBtnClick(_ sender: UIButton) {
        checkForSpeedTest()
    }
    @IBAction func onUploadSpeedBtnClick(_ sender: Any) { //Added by dk on 16th april 2020.
        checkForSpeedTest()
    }
    @IBAction func onSubmitBtnClick(_ sender: UIButton) {
        if submitBtn.titleLabel?.text == "UPDATE"{
            print("UPDATE >>>> /")
             validateDataForEdit()
        }else{
//            UserDefaults.standard.set(false, forKey: "Skip") //Bool // add by chandra for skip in tutor form
           print("SUBMIT >>>> /")
             validateData()
        }
    }
    @objc func onUploadVideoBtnClick(_ sender: UIButton) {
        
        uploadIndex = sender.tag - 6
        let alert = UIAlertController.init(title: "Top", message: "Message", preferredStyle: .actionSheet)

        let recordVideo = UIAlertAction.init(title: "Record Video", style: .default) { (Action) in
//            let count = self.videosArray.count
//            if count < 1
//            {
                VideoService.instance.launchVideoRecorder(in: self, cameratype: "Video", local: true, completion: {
                })
                VideoService.instance.delegate = self
                
//            }else{
//
//                AppConstants().ShowAlert(vc: self, title: "Message", message: "Only one video can upload")
//
//            }
        }
        let chooseVideo = UIAlertAction.init(title: "Choose Video", style: .default) { (Action) in
//           let count = self.videosArray.count
//            if count < 1
//            {
                VideoService.instance.launchVideoRecorder(in: self, cameratype: "Video", local: false, completion: {
                })
                VideoService.instance.delegate = self
//            }else
//            {
//                AppConstants().ShowAlert(vc: self, title: "Message", message: "Only one video can upload")
//
//            }
        }
        
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
      
        alert.addAction(recordVideo)
        alert.addAction(chooseVideo)
//        alert.addAction(chooseDocument)
        alert.addAction(cancel)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        self.present(alert, animated: true, completion: nil)

     }

    func videoDidFinishSaving(obj: [String : Any]) {
        
        
        if let object = obj["filePath"] as? String{
//            videosArray.append(object)
            uploadVideosDict[uploadIndex]["VideoUrl"] = object
        }
        uploadtableVW.reloadData()
        
    }
    @objc func handleTap1(gesture: UITapGestureRecognizer){
       
//     playVideo(file: videosArray[0])
            
        
    }
    func playVideo(file: String){
        let videoFolderPath = AppConstants().getVideosFolder()
        let videoPath = "\(videoFolderPath)/\((file as NSString).lastPathComponent)"
        let isExist = FileManager.default.fileExists(atPath: videoPath)
        if isExist
        {
            playMovie(url: URL.init(fileURLWithPath: videoPath))
        }
        else{
            //                NSString *url_str= [file stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            //                url = [NSURL URLWithString:url_str];
            //                player = [AVPlayer playerWithURL:url];
            playMovie(url: URL.init(string: file)!)
        }
    }
    private func playMovie(url: URL) {
        //guard let url = videoURL else { return }
        
        let player = AVPlayer.init(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        
        present(vc, animated: true) {
            vc.player?.play()
        }
    }
    
    func imagePickerdidfinishLoaded(withData mediaData: [String : Any], and imagestamp: String) {
           
       }
       
       func dismissMediaDeviceView() {
           
       }
       
       func imagePickerdidCancelled() {
           
       }
    
    @IBAction func onAddVideoBtnClick(_ sender: UIButton) {
//       add by chandra on 9 mar endes here
         view.endEditing(true)
        let element = addVideosDict[addVideoBtn.tag]
        if ((element["VideoTitle"] as! String).trimmingCharacters(in: .whitespaces).isEmpty ||  (element["VideoUrl"] as! String).trimmingCharacters(in: .whitespaces).isEmpty ){
          showMessage(bodyText: "please enter both title and link",theme: .warning)
        }
        else{
            addVideosDict += videosArr1
            if addVideosDict.count < 5{
             addVideosDict.append(["DemoVideoID":0,"UserID":UserDefaults.standard.string(forKey: "userID")!,"VideoTitle":"","VideoUrl":"","uploadedDate":AppConstants().currentDateInUTC()])
            addVideoHgt.constant = CGFloat(175 * addVideosDict.count)
            mainSubvwHgt.constant = mainSubvwHgt.constant + addVideoHgt.constant - 250
//                tableVW.reloadData()
                for (index,element) in videosArr1.enumerated(){
                    print("chandra sekhar\(index)")
                    addVideosDict.remove(at: index)
                }
                addVideoBtn.tag+=1
                tableVW.reloadData()
            }else{
                showMessage(bodyText: "Only 5 videos can upload",theme: .warning)
             }
        } 
                
       }
    @IBAction func onAddUploadVideoBtnClick(_ sender: UIButton) {
        //       add by chandra on 9/mar/2020 endes here
//         textField.resignFirstResponder()
         view.endEditing(true)
        let element = uploadVideosDict[uploadAddVideoBtn.tag]
        if ((element["VideoTitle"] as! String).trimmingCharacters(in: .whitespaces).isEmpty || element["VideoUrl"] as! String == ""){
          showMessage(bodyText: "please enter both title and link",theme: .warning)
        }else{
             uploadVideosDict += videosArr2
            if uploadVideosDict.count < 5{
                uploadVideosDict.append(["DemoVideoID":0,"UserID":UserDefaults.standard.string(forKey: "userID")!,"VideoTitle":"","VideoUrl":"","uploadedDate":AppConstants().currentDateInUTC()])
                uploadAddVideoHgt.constant = CGFloat(200 * uploadVideosDict.count)
                mainSubvwHgt.constant = mainSubvwHgt.constant + uploadAddVideoHgt.constant - 300
//                uploadtableVW.reloadData()
                for (index,element) in videosArr2.enumerated(){
                    print("chandra sekhar\(index)")
                    uploadVideosDict.remove(at: index)
                }
                uploadAddVideoBtn.tag+=1
                uploadtableVW.reloadData()
                           }else{
                               showMessage(bodyText: "Only 5 videos can upload",theme: .warning)
                }
         }
    }
    @IBAction func onUploadResumeBtnClick(_ sender: UIButton){
        let alert = UIAlertController.init(title: "Top", message: "Message", preferredStyle: .actionSheet)
        let chooseDocument = UIAlertAction.init(title: "Choose Document", style: .default) { (Action) in
            let documentProviderMenu = UIDocumentPickerViewController.init(documentTypes: ["public.text", "public.zip-archive", "com.pkware.zip-archive","public.composite-content"], in: .import)
                documentProviderMenu.delegate = self as? UIDocumentPickerDelegate
             /*  Updated By Ranjeet on 27th March 2020 - starts here */
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: .normal) /* Added By Ranjeet on 9th April 2020 */

            if #available(iOS 13.0, *) {
                UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.label], for: .normal)
            } else {
                // Fallback on earlier versions
            }
             /*  Updated By Ranjeet on 27th March 2020 - ends here */
                
                self.present(documentProviderMenu, animated: true, completion: nil)
            
        }
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(chooseDocument)
        alert.addAction(cancel)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        self.present(alert, animated: true, completion: nil)
    }
    @objc func deleteBtnPressed(sender:UIButton){
        let index = linkVideosArr[sender.tag]
        self.linkVideosArr.remove(at: sender.tag)
        collectionView.reloadData()
        print("removedSucessfully")
    }
}
extension UIViewController{
    func removeChild() {
        if  self.children.count >= 1{
        self.children.forEach {
                $0.willMove(toParent: nil)
                $0.view.removeFromSuperview()
                $0.removeFromParent()
           }
       }
    }
}

extension TutorSignUpVC:UITableViewDelegate,UITableViewDataSource,URLSessionDelegate, URLSessionDataDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableVW{
            return addVideosDict.count
      }
      else{
        return uploadVideosDict.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableVW
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TutorAddVideoCell") as! TutorAddVideoCell
            
            if addVideosDict.count - 1 == indexPath.row
            {
                cell.deleteBtn.isHidden = true
                
            }else
            {
                cell.deleteBtn.isHidden = false
                
            }
            cell.deleteBtn.addTarget(self, action: #selector(deleteAddVideoBtnClicked(sender:)), for: .touchUpInside)
            cell.videoLinkTF.delegate = self
            cell.videoTitleTF.delegate = self
            cell.videoLinkTF .tag = indexPath.row
            cell.videoTitleTF.tag = indexPath.row
            addVideoBtn.tag = indexPath.row // commented by chandra 12th
            cell.deleteBtn.tag = indexPath.row
            cell.videoLinkTF.useUnderline()
            cell.videoTitleTF.useUnderline()
            let dict = addVideosDict[indexPath.row]
            return cell
            
        }
        else{
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "TutorUploadVideoCell") as! TutorUploadVideoCell
            let dict = uploadVideosDict[indexPath.row]
            if uploadVideosDict.count - 1 == indexPath.row
            {
                cell.deleteBtn.isHidden = true
                
            }else
            {
                cell.deleteBtn.isHidden = false
                
            }
            cell.deleteBtn.addTarget(self, action: #selector(deleteUploadVideoBtnClicked(sender:)), for: .touchUpInside)
            cell.uploadVideoTitleTF.delegate = self
            cell.uploadVideoTitleTF .tag = indexPath.row + 6
            cell.deleteBtn.tag = indexPath.row
            cell.uploadVideoTitleTF.useUnderline()
            cell.uploadVideoBtn.tag = indexPath.row + 6
            cell.uploadVideoBtn.addTarget(self, action: #selector(onUploadVideoBtnClick(_:)), for: .touchUpInside)
            
            cell.uploadVideoBtn.setImage(UIImage.init(named: "Asset 33"), for: .normal)
            
                    let videoFolderPath = AppConstants().getVideosFolder()
                    
                    if (dict["VideoUrl"] as! String).contains("var")
                    {
                        
                        let videoPath = (videoFolderPath as String) + "/".appending((dict["VideoUrl"] as! NSString).lastPathComponent)
                        
                        let fileExists = FileManager.default.fileExists(atPath:videoPath )
                        
                        if fileExists
                        {
                            DispatchQueue.main.async {
                                
                                let singleFrameImage = UIImage().generateThumbnail(path: URL.init(fileURLWithPath: videoPath))
//                                cell.uploadVideoBtn.imageView?.image = singleFrameImage
                                cell.uploadVideoBtn.setImage(singleFrameImage, for: .normal)

            //                    let anIndex = self.videosArray.firstIndex(of: obj["filePath"] as! String)
            //
            //                        self.videoImg.image = singleFrameImage
            //                        let vidImage = UIImageView.init(frame: CGRect.init(x: self.videoImg.frame.size.width/2-10, y: self.videoImg.frame.size.height/2-10, width: 20, height: 20))
            //                        vidImage.image = UIImage.init(named: "playbutton")
            //                        self.videoImg.addSubview(vidImage)
            //                        self.videoImg.isUserInteractionEnabled = true
            //                        self.videoImg.setCorner()
            //                        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap1(gesture:)))
            //                        gesture1.numberOfTapsRequired = 1
            //                        self.videoImg.addGestureRecognizer(gesture1)
                                
                                
                            }
                        }
                    }
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == tableVW
        {
            
            return 175
            
        }else
        {
            return 200
            
        }
        
    }
    
    @objc func deleteAddVideoBtnClicked(sender:UIButton) {
        sender.isEnabled = false
        let index = sender.tag
        addVideosDict.remove(at: index)
        let indexPath = IndexPath.init(row: index, section: 0)
        let cell = tableVW.cellForRow(at: indexPath) as! TutorAddVideoCell
        cell.videoLinkTF.text = nil
        cell.videoTitleTF.text = nil
        tableVW.beginUpdates()
        tableVW.deleteRows(at: [indexPath], with: .none)
        tableVW.endUpdates()
        if addVideosDict.count == 0{
        addVideosDict.append(["DemoVideoID":0,"UserID":"","VideoTitle":"","VideoUrl":"","uploadedDate":""])
        }
       tableVW.reloadData()
        addVideoHgt.constant = CGFloat(175 * addVideosDict.count)
        mainSubvwHgt.constant = mainSubvwHgt.constant + addVideoHgt.constant - 250
        sender.isEnabled = true
    }
    @objc func deleteUploadVideoBtnClicked(sender:UIButton) {
        sender.isEnabled = false
        let index = sender.tag
        uploadVideosDict.remove(at: index)
        let indexPath = IndexPath.init(row: index, section: 0)
        let cell = tableVW.cellForRow(at: indexPath) as! LinkTableViewCell
        cell.linkTitle.text = nil
        uploadtableVW.beginUpdates()
        uploadtableVW.deleteRows(at: [indexPath], with: .none)
        uploadtableVW.endUpdates()
        if uploadVideosDict.count == 0{
            uploadVideosDict.append(["DemoVideoID":0,"UserID":"","VideoTitle":"","VideoUrl":"","uploadedDate":""])
        }
        uploadtableVW.reloadData()
        uploadAddVideoHgt.constant = CGFloat(200 * uploadVideosDict.count)
        mainSubvwHgt.constant = mainSubvwHgt.constant + uploadAddVideoHgt.constant - 300
        sender.isEnabled = true
    }
    func getFileName(str: String) -> String{
        var fileName = ""
        if str == "pdf" {
            fileName = "ic_pdf"
        }
        else if str == "doc" {
            fileName = "ic_dox"
        }
        else if str == "docx" {
            fileName = "ic_dox";
        }
        else if str == "txt" {
            fileName = "ic_txt";
        }
        else if str == "ppt" {
            fileName = "ic_ppt";
        }
        else if str == "xlsx" {
            fileName = "ic_xl";
        }
        else if str == "xLs" {
            fileName = "ic_anonymous"
        }
        else{
            fileName = "ic_anonymous"
        }
        return fileName
    }
    
    func saveFile(url: URL, fileName: String) -> String {
        let datePdf = try? Data.init(contentsOf: url)
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        var documentsDirectory = paths[0]
        //Create PDF_Documents directory
        documentsDirectory = "\(documentsDirectory)/PDF_Documents"
        do
        {
            try FileManager.default.createDirectory(atPath: documentsDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
        let filePath = "\(documentsDirectory)/\(fileName)"
        do{
            try datePdf?.write(to: URL.init(fileURLWithPath: filePath), options: .atomic)
        }
        catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
        print(filePath)
        return filePath
    }
    @IBAction func deleteResume(_ sender: UIButton) {
        dleteResume.isHidden = true
        UserDefaults.standard.set("", forKey: "resume")
        submitBtnTopHightConstraint.constant = 15
        resumeImg.isHidden = true
    }
}
extension TutorSignUpVC: UIDocumentPickerDelegate{
func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .normal)
}
func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .normal)
    print(url)
    let fileName = "\(AppConstants().getUniqueDocumentFileName()).\(url.pathExtension)"
    let name = getFileName(str: url.pathExtension)
    resumeImg.image = UIImage.init(named: name)
    resumeurl = saveFile(url: url, fileName: fileName)
    docsArray.removeAll()
    docsArray.append(resumeurl)
    if docsArray.count != 0{
        submitBtnTopHightConstraint.constant = 100
        resumeImg.isHidden = false
        dleteResume.isHidden = false
    }else{
        submitBtnTopHightConstraint.constant = 15
        resumeImg.isHidden = true
        dleteResume.isHidden = true
    }
    let urlFilePath = (resumeurl as NSString).lastPathComponent
     finalPath = "https://ltwuploadcontent.blob.core.windows.net/tutorresume/\(urlFilePath)"
     UserDefaults.standard.set(self.finalPath, forKey: "resume")
    print("finalPath>>>>>\(finalPath)")
    }
 }

extension TutorSignUpVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return linkVideosArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DisplayTutorVideosCollectionViewCell", for: indexPath) as! DisplayTutorVideosCollectionViewCell
        let dict = linkVideosArr[indexPath.row]
        cell.videoTitle2.text = dict["VideoTitle"] as! String
        let storedurl = dict["VideoUrl"] as! String
        let convertingStringTourl = URL(string: storedurl)
        if convertingStringTourl != nil{
            cell.thumbNailImage2.image = getThumbnailFrom(path: convertingStringTourl!)
        }
        let image = UIImage(named: "play")
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: cell.playicon2.frame.size.width, height: cell.playicon2.frame.size.height)
        cell.playicon2.addSubview(imageView)
        cell.deleteBtn.tag = indexPath.row
         uploadAddVideoBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnPressed(sender:)), for:.touchUpInside )
        
        if linkVideosArr.count == 0{
            hightConstraintForContainerView.constant = 0
          }else{
            hightConstraintForContainerView.constant = 190
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//         let dict = linkVideosArr[indexPath.row]
//                   let oneurl = dict["VideoUrl"] as! String
//                   if oneurl != ""{
//                       let videoURL = URL(string:oneurl)!
//                       if videoURL != nil && oneurl != ""{
//                           let svc = SFSafariViewController(url: videoURL)
//                           present(svc, animated: true, completion: nil)
//                               }
//                           }
        
        let dict = linkVideosArr[indexPath.row]
              let oneurl = dict["VideoUrl"] as! String
               let data = verifyUrl(urlString: oneurl)
              if data == true{
                  if oneurl != ""{
                  let videoURL = URL(string:oneurl)!
                  if videoURL != nil && oneurl != ""{
                      let svc = SFSafariViewController(url: videoURL)
                      present(svc, animated: true, completion: nil)
                  }
              }
              }else{
                  showMessage(bodyText: "Involid url",theme: .warning)
              }
        
    }
}

