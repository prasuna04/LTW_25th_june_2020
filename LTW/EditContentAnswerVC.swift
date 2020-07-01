//  EditContentAnswerVC.swift
//  LTW
//  Created by Ranjeet Raushan on 31/12/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView

class EditContentAnswerVC: UIViewController, NVActivityIndicatorViewable , UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, NSLayoutManagerDelegate  {
    /* Added UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, NSLayoutManagerDelegate By Yashoda on 10th Jan 2020 */

    @IBOutlet weak var questionsLbl: UILabel!
    @IBOutlet weak var answerstxtVw: UITextView!
    
    var userID: String!
    var questionID: String!
    var answerId: String!
    var questions: String!
    var answers: String!
    
    /* Added by yasodha to implement inline in EditContentAnswerVC on 9/1/2020 - starts here */
          
          @IBOutlet weak var rightBarButton: UIBarButtonItem!
          //  @IBOutlet weak var textView: UITextView!//yasodha
          @IBOutlet weak var leftBarButton: UIBarButtonItem!
          @IBOutlet weak var rightButton: UIButton!
          @IBOutlet weak var leftButton: UIButton!
          @IBOutlet var newSubView: UIView!
          @IBOutlet weak var tollBar: UIToolbar!
          var customView=UIView()
          let picker = UIImagePickerController()
          var keyboardFrame = CGRect()
       //   var answerId =  "" // pass this answerId to write the answer /* Commented By Yashoda on 10th Jan 2020 */
       //   var questionID: String!  /* Commented By Yashoda on 10th Jan 2020 */
       //   let textViewPlaceHolder =  "Write your Answer Here" /* Text View PlaceHolder Handling -  Commented By Yashoda on 10th   Jan 2020 */
          var urlPath = ""
          var isVideo = false
          var localImage = [[String : UIImage]]()
          var finalAnswerString = String()
          var imagepicker = ImagePicker()
          var localImgUrl=[String]()
          var imagePicker = ImagePicker()
          var backbtnClicked = false
          
          /* Added by yasodha to implement inline in EditContentAnswerVC on 9/1/2020 - ends here */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionsLbl.text = questions
       //  answerstxtVw.text = answers /* Commented By Yashoda on 10th Jan 2020 */
        
        /* Added by yasodha on 9/1/2020 - starts here*/
               DispatchQueue.global(qos: .background).async {
                                         // do your job here
                               let htmlData =  self.answers.html2Attributed
                                      
                                         DispatchQueue.main.async {
                                             // update ui here
                                       //   self.tableView.reloadData()//yasodha
                                          
                                           self.answerstxtVw.attributedText = htmlData
                                      }
                                      
                   }
                /* Added by yasodha on 9/1/2020 - ends here */
        
        /* Added by yasodha to implement inline in EditContentAnswerVC on 9/1/2020 - starts here */
                 answerstxtVw.layoutManager.delegate = self
                picker.delegate = self
                //to calculate keyboard height and frame of keyboard
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
                tollBar.removeFromSuperview() //don't comment this we will get error
                answerstxtVw.inputAccessoryView = tollBar //inserting the tabbar on top of keyboard
                
             
                //This is to add Done Button on inline keyboard
                let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AttandTestVC.dismissKeyboard))
                tollBar.items?.append(flexBarButton)
                tollBar.items?.append(doneBarButton)
                self.answerstxtVw.inputAccessoryView = tollBar
                
                /* Added by yasodha to implement inline in EditContentAnswerVC on 9/1/2020  - ends here */
        
        /* Right Bar Button Code Starts Here */
          let submitRightBarButton = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(onsubmitRightBarButtonClick))
          self.navigationItem.rightBarButtonItem  = submitRightBarButton
        /* Right Bar Button Code Ends Here */
        
    }
    
    /* Added By Yashoda on 9/1/2020 - starts here */
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            answerstxtVw.isUserInteractionEnabled = true
            answerstxtVw.isScrollEnabled = true
            answerstxtVw.scrollsToTop = true
            answerstxtVw.font = UIFont.systemFont(ofSize: 14)
            answerstxtVw.textColor = UIColor.black /* Added By Ranjeet on 14th April 2020 */
            /* Added By Ranjeet on 14th April 2020  - starts here (Don't remove )*/
            if #available(iOS 13.0, *) {
                answerstxtVw.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
            }
            /* Added By Ranjeet on 14th April 2020  - ends here (Don't remove )*/

        }
        /* Added By Yashoda on on 9/1/2020 - ends here */
        
        /* Addded by yasodha to implement inline in EditContentAnswerVC on 1/1/2020 */
        
        //this delegate function is used to give a line spacing
        func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
            return 15
        }
        
        @objc func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                print(keyboardFrame = keyboardSize) //we are taking the keyboard frame
                print("x=\(keyboardSize.origin.x) and   y=\(keyboardSize.origin.y)")
                print("height=\(keyboardSize.height)  and   width= \(keyboardSize.width)")
                tollBar.isHidden=false
                
                answerstxtVw.font = UIFont.systemFont(ofSize: 14.0) /* to solve font issue after adding attributed text - Added By Yashoda */
                
                answerstxtVw.textColor = UIColor.black /* Added By Ranjeet on 14th April 2020 (Don't remove) */
                
                /* Added By Ranjeet on 14th April 2020 - starts here(Don't remove) */
                if #available(iOS 13.0, *) {
                    answerstxtVw.textColor = UIColor.label
                } else {
                    // Fallback on earlier versions
                }
                /* Added By Ranjeet on 14th April 2020 - ends  here (Don't remove) */
            }
        }
        
        /* Added by yasodha on 3/1/2020 for add Done Button on Keyboard - starts here */
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
        /* Added by yasodha on 3/1/2020 for add Done Button on Keyboard - ends here */
        
        func dispCamera(){          //this function will open the camera
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen  //presenting it as fullscreen
            present(picker,animated: true,completion: nil)
        }
        
        func dispLibrary(){         //this function will open the camera
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            //        picker.modalPresentationStyle = .fullScreen     //presenting as fullscreen
            present(picker,animated: true, completion: nil)
            let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.init(hex: "2DA9EC")]
            picker.navigationBar.titleTextAttributes = textAttributes
        }
        private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
            //this will be called when user press cancel button
            newSubView.removeFromSuperview()
            dismiss(animated: true, completion: nil)
        }
        
        internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            backbtnClicked = false
            //  var image = UIImage.init
            let image = info[.originalImage] as! UIImage
            
            /* Added By Yashoda on 17th April 2020 - starts here */
            let vc = storyboard?.instantiateViewController(withIdentifier: "ImageEditForScriblingANdCropVC") as! ImageEditForScriblingANdCropVC
            vc.backgroundImgPassed = image
            vc.Delegate = self
            // vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
            picker.dismiss(animated: true, completion: nil)

            /* Added By Yashoda on 17th April 2020 - ends  here */
            
          /*******************************Commented by yasodha on 16/4/2020 starts here*************************************/
            
//            /* yasodha*/
//            let imageFolder = imagePicker.getImagesFolder()
//            let uniqueFileName = imagePicker.getUniqueFileName()
//            let finalPath = URL.init(fileURLWithPath: "\(String(describing: imageFolder))/\(String(describing: uniqueFileName))")
//            var tempImagePath = String()
//            do {
//
//                try image.jpegData(compressionQuality: 0.1)?.write(to: finalPath, options: .atomic)
//                tempImagePath.append("\(String(describing: imageFolder))/\(String(describing: uniqueFileName))")
//                print("localImageUrl path ::::::: \(tempImagePath)")
//
//                localImgUrl.append(tempImagePath)
//            }
//            catch {
//                let fetchError = error as NSError
//                print(fetchError)
//            }
//            /* yasodha*/
//            let MyAttribute = [ NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14) ]
//            let MyAttrString = NSAttributedString(string: "\n", attributes: MyAttribute)
//            var NewPosition =  answerstxtVw.endOfDocument
//            answerstxtVw.selectedTextRange =  answerstxtVw.textRange(from: NewPosition, to: NewPosition)
//            answerstxtVw.textStorage.insert(MyAttrString, at:  answerstxtVw.selectedRange.location)
//            NewPosition =  answerstxtVw.endOfDocument
//            answerstxtVw.selectedTextRange =  answerstxtVw.textRange(from: NewPosition, to: NewPosition)
//
//            //create and NSTextAttachment and add your image to it.
//            let attachment = NSTextAttachment()
//            // localImage.append(image)
//
//            //attachment.image = image
//            //                attachment.image = UIImage(contentsOfFile: tempImagePath)
//            attachment.image =  image
//            attachment.fileWrapper = try? FileWrapper.init(url: finalPath, options: .immediate)
//            print(imagepicker.getUniqueFileName())
//            //calculate new size. (-20 because I want to have a litle space on the right of picture)
//            let newImageWidth = (self.answerstxtVw.bounds.size.width - 20 )
//            let scale = newImageWidth/image.size.width
//            let newImageHeight = image.size.height * scale
//            //resize this
//            //           attachment.bounds = CGRect.init(x: 10, y: 0, width: newImageWidth, height: newImageHeight-50) / Commented By Yashoda on 8th Jan 2020 /
//            attachment.bounds = CGRect.init(x: 0, y: 0, width: self.answerstxtVw.bounds.size.width/1.05, height: self.answerstxtVw.bounds.size.width/1.05) /* Modified By Yashoda on 8th Jan 2020 */
//
//
//            //put your NSTextAttachment into and attributedString
//            let attString = NSAttributedString(attachment: attachment)
//            //add this attributed string to the current position.
//            answerstxtVw.textStorage.insert(attString, at:  answerstxtVw.selectedRange.location)
//            //textView.text.append("\n")
//            newSubView.removeFromSuperview()
//            picker.dismiss(animated: true, completion: nil)
//            answerstxtVw.becomeFirstResponder()
//            let myAttribute = [ NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14) ]
//            let myAttrString = NSAttributedString(string: "\n", attributes: myAttribute)
//            var newPosition =  answerstxtVw.endOfDocument
//            answerstxtVw.selectedTextRange =  answerstxtVw.textRange(from: newPosition, to: newPosition)
//            answerstxtVw.textStorage.insert(myAttrString, at:  answerstxtVw.selectedRange.location)
//            newPosition =  answerstxtVw.endOfDocument
//            answerstxtVw.selectedTextRange =  answerstxtVw.textRange(from: newPosition, to: newPosition)
//            //textAnswerTextView.resignFirstResponder()
//
//
            
              /*******************************Commented by yasodha on 16/4/2020 ends here*************************************/
                      
            
        }
        
        
        //creating the new subview on top of the keyboardlayer
        func CreateSubView (){
            
            print("comming to createSubview")
            // newSubView.removeFromSuperview()
            //creating subview as of keyboard size and subtracting the height of tabbar form height
            newSubView.frame = CGRect(x: keyboardFrame.origin.x, y: keyboardFrame.origin.y+45 , width: keyboardFrame.width, height: keyboardFrame.height-40 )
            newSubView.backgroundColor = UIColor.lightGray
            newSubView.layer.zPosition = CGFloat(MAXFLOAT)
            
            let windowsCount = UIApplication.shared.windows.count
            UIApplication.shared.windows[windowsCount-1].addSubview(newSubView)
            
        }
        
        
        
        //this action will exicute when the tollbar button item is pressed
        @IBAction func onBarButtonPressed(_ sender: UIBarButtonItem){
            switch sender.tag {
            case 1:  answerstxtVw.becomeFirstResponder()
            newSubView.removeFromSuperview()
            print("keyboard pressed")
            case 2: CreateSubView()
            print("*********** camera pressed *************")
            default: print("it won't come here ")
            }
        }

    /*Added by yasodha to replace local img path to thumbnails path on 9th Jan 2020 - ends here */
        
    func replaceNames(str : String, with names: [String])-> String {
        var imageurls = [String]()
        let startigRange = str.ranges(of: "img src=")
        let endingRange = str.ranges(of: ".jpg\" alt")
        let temp = str.components(separatedBy: "src")
        for i in 0..<temp.count-1{
            let start = startigRange[i].upperBound
            let end = endingRange[i].lowerBound
            let range = start...end
            let res = String(str[range]) + "jpg"
            imageurls.append(String( res))
            // print(res)
            // htmlStr.substring(with: (in: range)
        }
        var result = str
        for i in 0..<names.count {
            if i == 0 {
                result = str.replacingOccurrences(of: imageurls[i], with: "\""+names[i])
            }
            else{
                result = result.replacingOccurrences(of: imageurls[i], with: "\""+names[i])
            }
        }
        return result
    }
    func uploadImagesToServer(str : String) -> [String] {
        var imageurls = [String]()
        let startigRange = str.ranges(of: "img src=")
        let endingRange = str.ranges(of: ".jpg\" alt")
        let temp = str.components(separatedBy: "src")
        for i in 0..<temp.count-1{
            let start = startigRange[i].upperBound
            let end = endingRange[i].lowerBound
            let range = start...end
            let res = String(str[range]) + "jpg"
            if res.contains("\"file:///md-") {
            /*Already in the server*/

            imageurls.append(String( res.replacingOccurrences(of: "\"file:///md-", with: "")))

            }else{
            imageurls.append(String( res.replacingOccurrences(of: "\"file://", with: "")))
            }
//            add by yasodha ends here  /* 27/1/20202*/
        }
        
        // here we are uploading the images to the server
        AzureUploadUtil().uploadBlobToContainer(filePathArray: imageurls)
        var imageUrls = [String]()
        for urls in imageurls {
            if !urls.isEmpty //&& urls.contains("var")
            {
                let urlFilePath = (urls  as NSString).lastPathComponent
                imageUrls.append("https://ltwuploadcontent.blob.core.windows.net/thumbnails/md-\(urlFilePath)")
            }
            else {
                imageUrls = imageurls
            }
        }
        return imageUrls
    }

    /*Added by yasodha to replace local img path to thumbnails path on 9th Jan 2020 - ends here */

        
        // when button on the subview are pressed
    @IBAction func buttonAction(sender: UIButton!) {
        newSubView.removeFromSuperview()
        switch sender.tag {
        case 1: dispCamera()
        print("camera is pressed")
        case 2: dispLibrary()
        print("library is pressed")
        case 3:
            guard let sharingVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
                return
            }
            sharingVC.Delegate = self
            self.navigationController?.pushViewController(sharingVC, animated: true)
        default:
            print("it won't come here i know")
        }
        print("Button tapped")
    }
        
        /* Addded by yasodha to implement inline in EditContentAnswerVC on 1/1/2020 */
     
    
    /* Right Bar Button  Function Code Starts Here */
    @objc func onsubmitRightBarButtonClick(){
        validiate()
    }
    /* Right Bar Button  Function Code Ends  Here */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navigationController = navigationController else { return }
             if (self.navigationController?.navigationBar) != nil {
                 navigationController.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
             }
             self.navigationController?.navigationBar.topItem?.title = " "
             navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
             navigationItem.title = "Edit Answers"
        
         /*Added by yasodha 24/4/2020 starts here */
                     let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
                     navigationController.navigationBar.titleTextAttributes = textAttributes
                     
                     /*Added by yasodha 24/4/2020 ends here */
        
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
    
    private func validiate(){
        
        /* validation code written By Ranjeet,  commented By Yashoda on 27th Jan 2020 - starts here */
        //        guard let writeAnswr = answerstxtVw.text,!writeAnswr.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
        //            showMessage(bodyText: "Answers can't be empty!",theme: .warning)
        //            return
        //        }
        /* validation code written By Ranjeet, commented By Yashoda on 27th Jan 2020 - ends here */
        
        
        
        /*Added by yasodha start here 27/1/20202 */
        let html = answerstxtVw.textStorage.attributedString2Html
        let writeAnswr = replaceNames(str:html!, with: uploadImagesToServer(str : html!))
        let editData = writeAnswr.htmlToString
        
        if editData.isEmpty{
            
            showMessage(bodyText: "Answers can't be empty!",theme: .warning)
            return
            
        }else{/*Added by yasodha ends here 27/1/20202*/
            
            
            
            navigationController?.popViewController(animated: true)
            if NetworkReachabilityManager()?.isReachable ?? false {
                //Internet connected,Go ahead
                let param:[String: Any] = [
                    "AnswerId": answerId!,
                    "QuestionID":questionID!,
                    "UserId": UserDefaults.standard.string(forKey: "userID")!,
                    "Answers": writeAnswr,
                    "AnswerDate": currentDateInUTC()
                ]
                hitServerForAnswerSubmit(params: param, endPoint: Endpoints.editAnswerThatUProvidedEndPoints  + (UserDefaults.standard.string(forKey: "userID")!))
            }else {
                //NO Internet connection, just return
                showMessage(bodyText: "No internet connection",theme: .warning)
            }
        }
        
    }
}
extension EditContentAnswerVC{
private func hitServerForAnswerSubmit(params: [String:Any],endPoint: String) {
    startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
    LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: .post, dueToAction: "EditedAnswerSubmit"){ result in
        self.stopAnimating()
        switch result {
        case let .success(json, _):
            let msg = json["message"].stringValue
            if json["error"].intValue == 1 {
                showMessage(bodyText: msg,theme: .error)
            }else {
                showMessage(bodyText: "Answer Updated Successfully",theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.01))
            }
            break
        case .failure(let error):
            print("MyError = \(error)")
            break
      }
    }
  }
}
/*Added by yasodha on 16/4/2020 starts here */
extension EditContentAnswerVC : EditImgSender {
    func getImg(EditedImg : UIImage ) {
         /* yasodha*/
                    let imageFolder = imagePicker.getImagesFolder()
                    let uniqueFileName = imagePicker.getUniqueFileName()
                    let finalPath = URL.init(fileURLWithPath: "\(String(describing: imageFolder))/\(String(describing: uniqueFileName))")
                    var tempImagePath = String()
                    do {

                        try EditedImg.jpegData(compressionQuality: 0.1)?.write(to: finalPath, options: .atomic)
                        tempImagePath.append("\(String(describing: imageFolder))/\(String(describing: uniqueFileName))")
                        print("localImageUrl path ::::::: \(tempImagePath)")

                        localImgUrl.append(tempImagePath)
                    }
                    catch {
                        let fetchError = error as NSError
                        print(fetchError)
                    }
                    /* yasodha*/
                    let MyAttribute = [ NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14) ]
                    let MyAttrString = NSAttributedString(string: "\n", attributes: MyAttribute)
                    var NewPosition =  answerstxtVw.endOfDocument
                    answerstxtVw.selectedTextRange =  answerstxtVw.textRange(from: NewPosition, to: NewPosition)
                    answerstxtVw.textStorage.insert(MyAttrString, at:  answerstxtVw.selectedRange.location)
                    NewPosition =  answerstxtVw.endOfDocument
                    answerstxtVw.selectedTextRange =  answerstxtVw.textRange(from: NewPosition, to: NewPosition)

                    //create and NSTextAttachment and add your image to it.
                    let attachment = NSTextAttachment()
                    // localImage.append(image)

                    //attachment.image = image
                    //                attachment.image = UIImage(contentsOfFile: tempImagePath)
                    attachment.image =  EditedImg
                    attachment.fileWrapper = try? FileWrapper.init(url: finalPath, options: .immediate)
                    print(imagepicker.getUniqueFileName())
                    //calculate new size. (-20 because I want to have a litle space on the right of picture)
                    let newImageWidth = (self.answerstxtVw.bounds.size.width - 20 )
                    let scale = newImageWidth/EditedImg.size.width
                    let newImageHeight = EditedImg.size.height * scale
                    //resize this
                    //           attachment.bounds = CGRect.init(x: 10, y: 0, width: newImageWidth, height: newImageHeight-50) / Commented By Yashoda on 8th Jan 2020 /
                    attachment.bounds = CGRect.init(x: 0, y: 0, width: self.answerstxtVw.bounds.size.width/1.05, height: self.answerstxtVw.bounds.size.width/1.05) /* Modified By Yashoda on 8th Jan 2020 */


                    //put your NSTextAttachment into and attributedString
                    let attString = NSAttributedString(attachment: attachment)
                    //add this attributed string to the current position.
                    answerstxtVw.textStorage.insert(attString, at:  answerstxtVw.selectedRange.location)
                    //textView.text.append("\n")
                    newSubView.removeFromSuperview()
                    picker.dismiss(animated: true, completion: nil)
                    answerstxtVw.becomeFirstResponder()
                    let myAttribute = [ NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14) ]
                    let myAttrString = NSAttributedString(string: "\n", attributes: myAttribute)
                    var newPosition =  answerstxtVw.endOfDocument
                    answerstxtVw.selectedTextRange =  answerstxtVw.textRange(from: newPosition, to: newPosition)
                    answerstxtVw.textStorage.insert(myAttrString, at:  answerstxtVw.selectedRange.location)
                    newPosition =  answerstxtVw.endOfDocument
                    answerstxtVw.selectedTextRange =  answerstxtVw.textRange(from: newPosition, to: newPosition)
                    //textAnswerTextView.resignFirstResponder()
      
        
    }
    
   
    
}
/*Added by yasodha on 16/4/2020 ends here */
