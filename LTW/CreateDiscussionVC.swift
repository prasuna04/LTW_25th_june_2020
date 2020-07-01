//  CreateDiscussionVC.swift
//  LTW
//  Created by Vaayoo on 24/09/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import SwiftMessages
import NVActivityIndicatorView
class CreateDiscussionVC: UIViewController, UITextFieldDelegate,NVActivityIndicatorViewable {
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txt_title: UITextField!
    @IBOutlet weak var txt_desc: UITextView!
    var groupId: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_desc.text = "Add description:" /* Added By Chandra on 25th Oct */
    }
    
    @IBAction func btn_submit(_ sender: Any) {
        if txt_title.text!.count > 0{
            if txt_desc.text == "Add description:"
            {
                txt_desc.text = ""
            }
            let params = [
                "GroupID": groupId,
                "DiscussionTitle": txt_title.text!,
                "Description": txt_desc.text ?? "",
                "CreatedBy": (UserDefaults.standard.object(forKey: "userID") as! String)
            ]
            hitServer(params: params as [String : Any], action: "CreateDiscussion")
        }
    }
    private func hitServer(params: [String:Any],action: String) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: Endpoints.createDiscussion, using: .post, dueToAction: action){ result in
            self.stopAnimating()
            self.txt_desc.text = "Add description:"
            switch result {
                
            case let .success(json,_):
                
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }else {
                    //                    showMessage(bodyText: msg ,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.01))
                    self.navigationController?.popViewController(animated: true)
                    showMessage(bodyText: "Discussion Created Successfully" ,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.01))
                }
                
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
}
extension CreateDiscussionVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        if newLength > 0 // have text, so don't show the placeholder
        {
            
            if textView == txt_desc && textView.text == "Add description:"
            {
                if text.utf16.count == 0
                {
                    return false
                }
                textView.text = ""
                textView.textColor = UIColor.black
                /*  Added By Ranjeet on 31st March 2020 - starts  here  */
                if #available(iOS 13.0, *) {
                    textView.textColor = UIColor.label
                } else {
                    // Fallback on earlier versions
                }
                /*  Added By Ranjeet on 31st March 2020 - ends here  */
            }
            return true
        }
        else  // no text, so show the placeholder
        {
            textView.text = "Add description:"
            textView.textColor = UIColor.init(hex: "909191")
            /*  Added By Ranjeet on 31st March 2020 - starts  here  */
            if #available(iOS 13.0, *) {
                textView.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
            }
            /*  Added By Ranjeet on 31st March 2020 - ends here  */

            return false
        }
    }
    /* Added By Chandra on 25th Oct - from here */
    func textViewDidBeginEditing(_ textView: UITextView) {
        txt_desc.text.removeAll()
    }
    /* Added By Chandra on 25th Oct - till here */
}
