//  KeyViewController.swift
//  Created by vaayoo on 26/11/19.
//  Copyright © 2019 Vaayoo. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON
import SwiftMessages
import NVActivityIndicatorView
import CoreServices
import  AVKit
import AVFoundation


class KeyViewController: UIViewController ,UITextViewDelegate, UITextFieldDelegate,UIImagePickerControllerDelegate,
UINavigationControllerDelegate,NSLayoutManagerDelegate,NVActivityIndicatorViewable  {
    

    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet var newSubView: UIView!
    @IBOutlet weak var tollBar: UIToolbar!
    var customView=UIView()
    let picker = UIImagePickerController()
    var keyboardFrame = CGRect()
    var answerId =  "" // pass this answerId to write the answer
    var questionID: String!
    let textViewPlaceHolder =  "Write your Answer Here" //Text View PlaceHolder Handling
    var urlPath = ""
    var isVideo = false
    var localImage = [UIImage]()
    var finalAnswerString = String()
    var imagepicker = ImagePicker()
    var localImgUrl=[String]()
    var imagePicker = ImagePicker()
    var scribbledImg : UIImage?//()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.layoutManager.delegate = self
        picker.delegate=self
        textView.delegate=self
        textView.becomeFirstResponder()
//        updateNavigationController() //for updating the title bar names and properties
        textView.text = textViewPlaceHolder
 
        //to calculate keyboard height and frame of keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        tollBar.removeFromSuperview() //don't comment this we will get error
        textView.inputAccessoryView = tollBar //inserting the tabbar on top of keyboard
        print("running")
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true 
          updateNavigationController()
    }
    func updateNavigationController() {
    navigationItem.title = "ANSWER"
    let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    navigationController?.navigationBar.titleTextAttributes = textAttributes

    if (self.navigationController?.navigationBar) != nil {
    navigationController?.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC") // making navigation bar color as blue
    navigationController?.view.backgroundColor = UIColor.init(hex:"2DA9EC")
    // to resolve black bar problem appears on navigation bar when pushing view controller
    }
    self.rightBarButton.tintColor = .white
    }
    
    
    //this delegate function is used to give a line spacing
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 15
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
    
    //on click of keyboard when the textView is not the first responder
    @IBAction func keybord2(_ sender: UIBarButtonItem) {
        textView.becomeFirstResponder()
        if sender.tag == 2 {
            let barbutton = UIBarButtonItem()
            barbutton.tag = 2
            onBarButtonPressed(barbutton)
        }
        // onBarButtonPressed()
    }
    
    @IBAction func navigationBarButtonPressed(_ sender: UIBarButtonItem){
        switch sender.tag {
        case 1 : newSubView.removeFromSuperview()
        textView.resignFirstResponder()
          _ = navigationController?.popViewController(animated: true)
           // dismiss(animated: true, completion: nil) // when cancel button is pressed dismissing the VC
        case 2:

            let html = textView.textStorage.attributedString2Html
//            let setHeightUsingCSS = "<head><style type=\"text/css\"> img{ max-height: 100%; max-width: 100% !important; width: auto; height: auto;} </style> </head><body> \(html!) </body>"
           //the above code is css which is used to make image height and width proper
            print(html!)
            if (html?.contains("img src"))!{
                 finalAnswerString=replaceFileName(String: html!, with: uploadImagesToServer())
            }
            else {
                 let myAttribute = [ NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14) ]
                finalAnswerString=NSAttributedString(string: textView.text,attributes: myAttribute).attributedString2Html!  //++++++edited
                print(finalAnswerString)
            }
            textView.resignFirstResponder()
                validiate() //here where the answer will be binded
                textView.text=nil
        default:
            print("it will not come here i know ")
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardFrame = keyboardSize) //we are taking the keyboard frame
            print("x=\(keyboardSize.origin.x) and   y=\(keyboardSize.origin.y)")
            print("height=\(keyboardSize.height)  and   width= \(keyboardSize.width)")
            tollBar.isHidden=false
            textView.font = UIFont.systemFont(ofSize: 14) //to solve font issue after adding attributed text
        }
    }
    
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
        picker.modalPresentationStyle = .fullScreen     //presenting as fullscreen
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.init(hex: "2DA9EC")]
        picker.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")// Background color
        picker.navigationBar.tintColor = .blue // Cancel button ~ any UITabBarButton items
        picker.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.blue
        ]
        present(picker,animated: true, completion: nil)
    }
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //this will be called when user press cancel button
        newSubView.removeFromSuperview()
        dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      //  var image = UIImage.init
        let image = info[.originalImage] as! UIImage                     //**************have to change here
//        let MyAttribute = [ NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17) ]
//        let MyAttrString = NSAttributedString(string: "\n", attributes: MyAttribute)
//        var NewPosition = textView.endOfDocument
//        textView.selectedTextRange = textView.textRange(from: NewPosition, to: NewPosition)
//        textView.textStorage.insert(MyAttrString, at: textView.selectedRange.location)
//        NewPosition = textView.endOfDocument
//        textView.selectedTextRange = textView.textRange(from: NewPosition, to: NewPosition)
//
//        //create and NSTextAttachment and add your image to it.
//        let attachment = NSTextAttachment()
//       // localImage.append(image)
                                                            //++++++++++++++++++++++++++++
        let vc = storyboard?.instantiateViewController(withIdentifier: "ImageEditForScriblingANdCropVC") as! ImageEditForScriblingANdCropVC
        vc.backgroundImgPassed = image
        vc.Delegate = self
       // vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
        picker.dismiss(animated: true, completion: nil)
       // picker.present(vc,animated: true, completion: nil)
                                                            //+++++++++++++++++++++++++++
//        attachment.image = scribbledImg ?? image
//        print(imagepicker.getUniqueFileName())
//        //calculate new size. (-20 because I want to have a litle space on the right of picture)
//        let newImageWidth = (self.textView.bounds.size.width - 20 )
//        let scale = newImageWidth/image.size.width
//        let newImageHeight = image.size.height * scale
//        //resize this
//        attachment.bounds = CGRect.init(x: 10, y: 0, width: newImageWidth, height: newImageHeight-50 )
//        //put your NSTextAttachment into and attributedString
//        let attString = NSAttributedString(attachment: attachment)
//        //add this attributed string to the current position.
//        textView.textStorage.insert(attString, at: textView.selectedRange.location)
//        //textView.text.append("\n")
//        newSubView.removeFromSuperview()
////        picker.dismiss(animated: true, completion: nil)
//        textView.becomeFirstResponder()
//        let myAttribute = [ NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17) ]
//               let myAttrString = NSAttributedString(string: "\n", attributes: myAttribute)
//               var newPosition = textView.endOfDocument
//               textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
//               textView.textStorage.insert(myAttrString, at: textView.selectedRange.location)
//               newPosition = textView.endOfDocument
//               textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
//       // textView.resignFirstResponder()
    }
    
    private func validiate(){
        
        if NetworkReachabilityManager()?.isReachable ?? false {
            //Internet connected,Go ahead
            guard let writeAnswr = textView.text,!writeAnswr.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
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
                "Answers": finalAnswerString,      //assinging the final html format answer data to dictionary
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
    
    
    
    
    
    
    
    
    //this action will exicute when the tollbar button item is pressed
    @IBAction func onBarButtonPressed(_ sender: UIBarButtonItem){
        switch sender.tag {
        case 1: textView.becomeFirstResponder()
                newSubView.removeFromSuperview()
                print("keyboard pressed")
        case 2: CreateSubView()
                print("camera pressed")
        case 3: attachmentClicked()
                print("Link pressed")
        default: print("it won't come here ")
        }
    }
    func attachmentClicked(){
        let alertController = UIAlertController(title: "Add a Link", message: "", preferredStyle: .alert)
            // alertController.addTextField { (textField : UITextField!) -> Void in
            //     textField.placeholder = "Enter the Link"
            // }
            alertController.addTextField { (textField) in
                 textField.placeholder = "Enter the Link"
            }
       
            let saveAction = UIAlertAction(title: "Add", style: .default, handler: { alert -> Void in
                let firstTextField = alertController.textFields![0] as UITextField
                let attr = NSMutableAttributedString(string: firstTextField.text!)
                attr.addAttribute(.link, value: URL(fileURLWithPath: firstTextField.text!) , range: NSRange(location: 0, length:firstTextField.text!.count ))
                self.textView.textStorage.insert(attr, at: self.textView.selectedRange.location)
                let myAttribute = [ NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14) ]
                           let myAttrString = NSAttributedString(string: "  ", attributes: myAttribute)
                           var newPosition = self.textView.endOfDocument
                           self.textView.selectedTextRange = self.textView.textRange(from: newPosition, to: newPosition)
                           self.textView.textStorage.insert(myAttrString, at: self.textView.selectedRange.location)
                           newPosition = self.textView.endOfDocument
                           self.textView.selectedTextRange = self.textView.textRange(from: newPosition, to: newPosition)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
            
        
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: false, completion: nil)
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
           // UIApplication.shared.canOpenURL(URL)
          // let urls : URL? = URL
          // if let videoURL = urls{
              UIApplication.shared.canOpenURL(URL)
          // }
           // UIApplication.shared.open(URL, options: [:], completionHandler: nil)
           return false
       }
    func findImage(textStorage: NSTextStorage) {
        //this function is used to find number of images present in the textView storage and stored in a images array
        for idx in 0 ..< textStorage.string.count {
            if
                let attr = textStorage.attribute(NSAttributedString.Key.attachment, at: idx, effectiveRange: nil),
                let attachment = attr as? NSTextAttachment,
                let image = attachment.image {

                localImage.append(image)
            }
        }
        return
    }
    func uploadImagesToServer() -> [String] {
        findImage(textStorage: textView.textStorage) //to count the images and store in array
        storeImgInLocal()  //to store the images in local 'Document' file
        var arr = [String]()
        for url in localImgUrl {
            if !url.isEmpty //&& url.contains("var")
            {
                arr.append(url)  //appending all local image directory to upload multiple img at a time
            }
        }
        // here we are uploading the images to the server
        AzureUploadUtil().uploadBlobToContainer(filePathArray: arr)
        var imageUrls = [String]()
        for urls in localImgUrl {
            if !urls.isEmpty //&& urls.contains("var")
            {
                let urlFilePath = (urls  as NSString).lastPathComponent
                imageUrls.append("https://ltwuploadcontent.blob.core.windows.net/thumbnails/md-\(urlFilePath)")
            }
            else {
                imageUrls = localImgUrl
            }
        }
        return imageUrls
    }
    func replaceFileName(String str:String,with names: [String]) -> String{
        //this is used to replace the Img src file to uploaded urls
        let imgsrc = "img src=\"file:///Attachment"
        var result = String()
        for i in 0..<names.count {
            if i == 0 {
                result=str.replacingOccurrences(of: "img src=\"file:///Attachment.png\"", with: "img src=\"\(names[i])\"")
                print(result)
            }
            else {
                print(result)
                result=result.replacingOccurrences(of: "\(imgsrc)_\(i).png\"", with: "img src=\"\(names[i])\"")
                print(result)
            }
        }
        
        return result
    }
    func storeImgInLocal(){
        // for number of img present in the img array we are storing that in phone 'document' folder
        for image in localImage{
            let imageFolder = imagePicker.getImagesFolder()
            let uniqueFileName = imagePicker.getUniqueFileName()
            let finalPath = URL.init(fileURLWithPath: "\(String(describing: imageFolder))/\(String(describing: uniqueFileName))")
            do {
                
                try image.jpegData(compressionQuality: 0.1)?.write(to: finalPath, options: .atomic)
                localImgUrl.append("\(String(describing: imageFolder))/\(String(describing: uniqueFileName))")
            }
            catch {
                let fetchError = error as NSError
                print(fetchError)
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        guard let navigationController = navigationController else { return }
        navigationController.view.backgroundColor = UIColor.init(hex:"2DA9EC")
        if (self.navigationController?.navigationBar) != nil {
            navigationController.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        }
    }
    
    
    
    
    
    
    //creating the new subview on top of the keyboardlayer
    func CreateSubView (){
        // newSubView.removeFromSuperview()
        //creating subview as of keyboard size and subtracting the height of tabbar form height
        newSubView.frame = CGRect(x: keyboardFrame.origin.x, y: keyboardFrame.origin.y+45 , width: keyboardFrame.width, height: keyboardFrame.height-40 )
        customView.backgroundColor = UIColor.lightGray
        newSubView.layer.zPosition = CGFloat(MAXFLOAT)
        let windowsCount = UIApplication.shared.windows.count
        UIApplication.shared.windows[windowsCount-1].addSubview(newSubView)
    }
    
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

    
}


extension NSAttributedString {
    var attributedString2Html: String? {
        do {
            let htmlData = try self.data(from: NSRange(location: 0, length: self.length), documentAttributes:[.documentType: NSAttributedString.DocumentType.html]);
            return String.init(data: htmlData, encoding: String.Encoding.utf8)
        } catch {
            print("error:", error)
            return nil
        }
    }
}

extension String {
    var html2Attributed: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
}
extension KeyViewController{
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
                  
                    showMessage(bodyText: msg,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.01))
//                    self.writeAnswrTextVw.text = self.textViewPlaceHolder
//                    self.writeAnswrTextVw.textColor = UIColor.gray
//                    self.refreshAnsVC!() // to reload the Answer List in Answer VC from Write Answer VC
                    _ = self.navigationController?.popViewController(animated: true)
                   // self.dismiss(animated: true, completion: nil)
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
      }
    }

extension KeyViewController {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
        }
        /*  Added By Ranjeet on 27th March 2020 - starts here  */
        if #available(iOS 13.0, *) {
            textView.textColor = UIColor.label
        } else {
            // Fallback on earlier versions
        }
        /*  Added By Ranjeet on 27th March 2020 - ends here  */
    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = textViewPlaceHolder
//            textView.textColor = UIColor.gray
//        }
//    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
}
extension UIImagePickerController {
       open override func viewWillLayoutSubviews() {
          super.viewWillLayoutSubviews()
        /*  Added By Ranjeet on 27th March 2020 - starts here  */
        if #available(iOS 13.0, *) {
            self.navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor.label
        } else {
            // Fallback on earlier versions
        }
        /*  Added By Ranjeet on 27th March 2020 - ends here  */
           self.navigationBar.topItem?.rightBarButtonItem?.isEnabled = true
           if (self.navigationController?.navigationBar) != nil {
           navigationController?.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC") // making navigation bar color as blue
           navigationController?.view.backgroundColor = UIColor.init(hex:"2DA9EC")
           // to resolve black bar problem appears on navigation bar when pushing view controller
        }
    }
}

extension KeyViewController : EditImgSender {
    
    
    func getImg(EditedImg: UIImage) {
       // self.scribbledImg = scribbleImg
        let MyAttribute = [ NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14) ]
         let MyAttrString = NSAttributedString(string: "\n", attributes: MyAttribute)
        var NewPosition = self.textView.endOfDocument
        self.textView.selectedTextRange = self.textView.textRange(from: NewPosition, to: NewPosition)
        self.textView.textStorage.insert(MyAttrString, at: textView.selectedRange.location)
         NewPosition = textView.endOfDocument
         textView.selectedTextRange = textView.textRange(from: NewPosition, to: NewPosition)
         
         //create and NSTextAttachment and add your image to it.
         let attachment = NSTextAttachment()
        // localImage.append(image)
         attachment.image = EditedImg // ?? image
                print(imagepicker.getUniqueFileName())
                //calculate new size. (-20 because I want to have a litle space on the right of picture)
                let newImageWidth = (self.textView.bounds.size.width - 20 )
                let scale = newImageWidth/EditedImg.size.width
                let newImageHeight = EditedImg.size.height * scale
                //resize this
                attachment.bounds = CGRect.init(x: 10, y: 0, width: newImageWidth, height: newImageHeight-50 )
                //put your NSTextAttachment into and attributedString
                let attString = NSAttributedString(attachment: attachment)
                //add this attributed string to the current position.
                textView.textStorage.insert(attString, at: textView.selectedRange.location)
                //textView.text.append("\n")
                newSubView.removeFromSuperview()
        //        picker.dismiss(animated: true, completion: nil)
                textView.becomeFirstResponder()
                let myAttribute = [ NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14) ]
                       let myAttrString = NSAttributedString(string: "\n", attributes: myAttribute)
                       var newPosition = textView.endOfDocument
                       textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
                       textView.textStorage.insert(myAttrString, at: textView.selectedRange.location)
                       newPosition = textView.endOfDocument
                       textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
                textView.resignFirstResponder()
    }
}
