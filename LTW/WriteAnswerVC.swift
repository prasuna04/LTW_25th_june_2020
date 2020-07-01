//  WriteAnswerVC.swift
//  LTW
//  Created by Ranjeet Raushan on 17/09/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON
import SwiftMessages
import NVActivityIndicatorView



class WriteAnswerVC: UIViewController , NVActivityIndicatorViewable{

    @IBOutlet weak var writeAnswrTextVw: UITextView!
    @IBOutlet weak var submitAnsBtn: UIButton!
        {
        didSet{
            submitAnsBtn.layer.cornerRadius = submitAnsBtn.frame.height / 12
        }
    }
     var answerId =  "" // pass this answerId to write the answer
     var questionID: String!
     let textViewPlaceHolder =  "Write your Answer Here" //Text View PlaceHolder Handling
     var urlPath = ""
     var isVideo = false
    
    var refreshAnsVC : (() -> ())? // to reload the Answer List in Answer VC from Write Answer VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* Text View PlaceHolder Handling - From here */
        writeAnswrTextVw.delegate = self
        writeAnswrTextVw.text = textViewPlaceHolder
   }
    /*How to get the current date and post it to the server - starts here */
    func currentDateInUTC() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let ansDate = Date()
        let result = dateFormatter.string(from: ansDate)
        let finalAnswerDate =  self.localToUTC(date: result, formatter:dateFormatter )
        return finalAnswerDate
    }
    func localToUTC(date:String, formatter: DateFormatter) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: dt!)
    }
    /*How to get the current date and post it to the server - ends here */
    @IBAction func onCloseBtnlClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onSubmitAnswrBtnClick(_ sender: UIButton) {
        validiate()
    }
    private func validiate(){
        
        if NetworkReachabilityManager()?.isReachable ?? false {
            //Internet connected,Go ahead
            guard let writeAnswr = writeAnswrTextVw.text,!writeAnswr.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                showMessage(bodyText: "Please write your Answer",theme: .warning)
                return
            }
            if writeAnswr == textViewPlaceHolder {
                showMessage(bodyText: "Please write your Answer",theme: .warning)
                return
            }
            
            let param:[String: Any] = [
                "UserId": UserDefaults.standard.string(forKey: "userID")!,
                "AnswerId":answerId,
                "QuestionID":questionID! ,
                "Answers": writeAnswrTextVw.text!,
                "UpVote": 0,
                "DownVote": 0,
                "UrlPath": urlPath,
                "IsVideo": isVideo,
                "AnswerDate": currentDateInUTC()
            ]
            hitServerForAnswerSubmit(params: param, endPoint: Endpoints.writeAnswerAnswrAndSubmitUrl)
        }else {
            //NO Internet connection, just return
            showMessage(bodyText: "No internet connection",theme: .warning)
        }
    }
}
extension WriteAnswerVC{
private func hitServerForAnswerSubmit(params: [String:Any],endPoint: String) {
    startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
    LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: .post, dueToAction: "AnswerSubmit"){[unowned self] result in
        self.stopAnimating()
        switch result {
        case let .success(json, _):
            let msg = json["message"].stringValue
            if json["error"].intValue == 1 {
                showMessage(bodyText: msg,theme: .error)
            }else {
              
                showMessage(bodyText: "Answer Added Successfully",theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.01))
                self.writeAnswrTextVw.text = self.textViewPlaceHolder
                self.writeAnswrTextVw.textColor = UIColor.gray
                self.refreshAnsVC!() // to reload the Answer List in Answer VC from Write Answer VC
                self.dismiss(animated: true, completion: nil)
            }
            break
        case .failure(let error):
            print("MyError = \(error)")
            break
        }
    }
  }
}
/* Text View PlaceHolder Handling - From here */
extension WriteAnswerVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
        }
        textView.textColor = UIColor.black
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = UIColor.gray
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
}
/* Text View PlaceHolder Handling - Till here */
