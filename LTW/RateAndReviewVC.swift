//  RateAndReviewVC.swift
//  LTW
//  Created by vaayoo on 12/02/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import UIKit
import Alamofire
import Foundation

//import Cosmos

class RateAndReviewVC: UIViewController {

   
    @IBOutlet weak var cosmos2: CosmosView!
    @IBOutlet weak var cosmos: CosmosView!
    @IBOutlet weak var tutorProfileImgView: UIImageView!{
        didSet{
            tutorProfileImgView.setRounded()
            tutorProfileImgView.layer.shadowColor = UIColor.gray.cgColor
            tutorProfileImgView.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
            tutorProfileImgView.layer.shadowRadius = 5.0
            tutorProfileImgView.layer.shadowOpacity = 0.8
        }
    }
   
 
    @IBOutlet weak var rateClassView: curvedView!
    @IBOutlet weak var rateTutorView: curvedView!
    @IBOutlet weak var tutorReviewTF: UITextField!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var classSubjectlbl: UILabel!
    @IBOutlet weak var classReviewTF: UITextField!
    @IBOutlet weak var classSubCatLbl: UILabel!
    @IBOutlet weak var ClassTitle: UILabel!
    var classId : Int = 1890
    var userId = String()
    var TutorUserID = String()
    var param =  [String: Any]()
    var classParam = [String: Any]()
    var isTutor : Bool =  false
    var isClass : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNavigationController()
        cosmos.didFinishTouchingCosmos  = {rating in
            print(rating)
            self.param["Rating"] = rating
        }
        cosmos2.didFinishTouchingCosmos  = {rating in
                   self.classParam["Rating"] = rating
               }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       // rateTutorView.frame = CGRect(x: 20, y: 20 , width: self.view.frame.width - 40 , height: 273)
      //  self.view.addSubview(rateTutorView)
        fetchApi()
        //callSecondView()
        cosmos.settings.fillMode = .half
         cosmos2.settings.fillMode = .half
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.ClassTitle.text = "Title : "
        self.classSubCatLbl.text = "Subject : "
        self.classSubjectlbl.text = "Sub Subject : "
        //_ = navigationController?.popViewController(animated: true)
    }
    @IBAction func onTutorSubmitClick(_ sender: UIButton) {
        let endPoint = Endpoints.RateTutorEndPoint
        param["UserID"] = userId

        param["class_id"] = classId
        param["TutorUserID"] =  TutorUserID
        param["Review"] = tutorReviewTF.text
        if !param.keys.contains("Rating"){
            self.param["Rating"] = 2.5
        }
        hitApi(endPoint: endPoint,param : param)
        tutorReviewTF.text = ""
        isTutor = true
        sender.isEnabled = false
        rateTutorView.alpha = 0.7
        rateTutorView.isUserInteractionEnabled = false
        if isTutor && isClass {
            _ = navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func onClassSubmitClick(_ sender: UIButton){
        let endPoint = Endpoints.rateClass
         classParam["UserID"] = userId
        classParam["Review"] = classReviewTF.text
        classParam["class_id"] = classId
        if !classParam.keys.contains("Rating"){
                   self.classParam["Rating"] = 2.5
               }
        hitApi(endPoint: endPoint,param : classParam)
        classReviewTF.text = ""
        isClass = true
        rateClassView.alpha = 0.7
        rateClassView.isUserInteractionEnabled = false
        if isTutor && isClass {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    func updateNavigationController() {
    navigationItem.title = "RATE AND REVIEW"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    navigationController?.navigationBar.titleTextAttributes = textAttributes

    if (self.navigationController?.navigationBar) != nil {
    navigationController?.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC") // making navigation bar color as blue
    navigationController?.view.backgroundColor = UIColor.init(hex:"2DA9EC")
    // to resolve black bar problem appears on navigation bar when pushing view controller
    }
    }
    func fetchApi(){
        let   url=URL(string: Endpoints.GetClassTutorInfoToRateEndPoint + "\(classId)")
        print(url)
        Alamofire.request(url!).responseJSON { response in
            let json =   response.result.value as! Dictionary<String,Any>
            if  json["message"] as! String == "Success" &&  json["error"]  as! Bool == false{
                let ControlsData = json["ControlsData"] as! Dictionary<String,Any>
                let lsv_classtutorinfo = ControlsData["lsv_classtutorinfo"] as! [Dictionary<String,Any>]
                for i in lsv_classtutorinfo{
                    let imgUrl = i["Profile"] as! String
                    self.tutorProfileImgView.sd_setImage(with: URL.init(string: imgUrl),placeholderImage:UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload])
                    self.fullNameLbl.text =  i["TutorName"] as? String ?? ""
                    self.ClassTitle.attributedText = self.attStr( with: self.ClassTitle.text!,for: i["ClassTitle"] as? String ?? "")
                    self.classSubCatLbl.attributedText = self.attStr(with: self.classSubCatLbl.text! , for: i["SubTopic"] as? String ?? "")
                    self.classSubjectlbl.attributedText = self.attStr(with: self.classSubjectlbl.text!, for: i["Subject"] as? String ?? "")
                }
            }
            else
            {
                print("some internal error")
            }
        }
        
    }
    
    func attStr(with text : String,for str : String)-> NSAttributedString {
        let attrs1 = [NSAttributedString.Key.font :  UIFont.systemFont(ofSize: 13.0) , NSAttributedString.Key.foregroundColor : UIColor.init(named: "white_black_color")]
        let attrs2 = [NSAttributedString.Key.font :  UIFont.systemFont(ofSize: 13.0) , NSAttributedString.Key.foregroundColor : UIColor.init(hex: "2DA9EC")]
        let attributedString1 = NSMutableAttributedString(string:text, attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:str, attributes:attrs2)
        attributedString1.append(attributedString2)
        return attributedString1
    }
    func hitApi(endPoint : String , param data :  [String: Any] ){
        let header = ["Content-Type": "application/json"]
        let   url=URL(string: endPoint )
        Alamofire.request(url!,method : .post,parameters: data.isEmpty ? nil: data,  encoding: JSONEncoding.default, headers: header).responseJSON { response in
            let json =   response.result.value as! Dictionary<String,Any>
            if  json["message"] as! String == "Success" &&  json["error"]  as! Int == 0 {
                showMessage(bodyText: "Successfully rate submited ",theme:.success,presentationStyle:.center,duration:.seconds(seconds: 0.2) )
            }
            else {
                showMessage(bodyText: "problem will submiting",theme:.error,presentationStyle:.center,duration:.seconds(seconds: 0.3) )
            }
        }
    }
}

