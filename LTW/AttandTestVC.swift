//  AttandTestVC.swift
//  LTW
//  Created by manjunath Hindupur on 29/07/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView

final class AttandTestVC: UIViewController,NVActivityIndicatorViewable , UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSLayoutManagerDelegate { /* Added  UITextFieldDelegate, UIImagePickerControllerDelegate , UINavigationControllerDelegate, NSLayoutManagerDelegate By Yashoda on 3rd Jan 2020 */
    
    
    
  @IBOutlet weak var marksLbl: UILabel!
    
    @IBOutlet weak var questionLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var testTitleLabel: UILabel!
    @IBOutlet weak var testTimeLabel: UILabel!
    @IBOutlet weak var quesNoLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var option1Btn: UIButton!
    @IBOutlet weak var option2Btn: UIButton!
    @IBOutlet weak var option3Btn: UIButton!
    @IBOutlet weak var option4Btn: UIButton!
    
    @IBOutlet weak var optionalAnsContainerView: CardView!
    @IBOutlet weak var textAnswerContainerView: CardView!
    @IBOutlet weak var textAnswerViewTopConst: NSLayoutConstraint!//10
    @IBOutlet weak var textAnswerTextView: UITextView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var backBtnTopConsToQuesCardview: NSLayoutConstraint! //  10 + 180 + 30
    
    @IBOutlet weak var btmIndxCollView: UICollectionView!
    private var selectedOptionalAnsIndex = -1
    private var questionType = 1
    private var numberOfQues: Int = 10
    private var activeIndex = 0
    var testID: String!
    var testDuration: String!
    private let userId = UserDefaults.standard.string(forKey: "userID")
    private let textViewAnsHint =  "Enter your Answer"
    private var questionArray : [[String:Any]] = []
    private var questionArrayJSON : [JSON] = []
    
    var timer: Timer?
    private var scheduledTestTime = 0 // secs
    private var takenTestTime = 0 //secs
    
    /* Addded by yasodha to implement inline in AttandTestVC on 1/1/2020 */
    
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
    var answerId =  "" // pass this answerId to write the answer
    var questionID: String!
    //  let textViewPlaceHolder =  "Write your Answer Here" //Text View PlaceHolder Handling//yasodha
    var urlPath = ""
    var isVideo = false
    var localImage = [[String : UIImage]]()
    var finalAnswerString = String()
    var imagepicker = ImagePicker()
    var localImgUrl=[String]()
    var imagePicker = ImagePicker()
    var backbtnClicked = false
    
    /* Addded by yasodha to implement inline in AttandTestVC on 1/1/2020 */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.navigationController?.navigationBar) != nil {
            navigationController?.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        }
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "My Test"
        
        
        textAnswerTextView.delegate = self
        textAnswerTextView.text = textViewAnsHint
        textAnswerTextView.textColor = UIColor.init(hex: "909191")
        loadUIforQuesType(type: questionType)
        hitServer(params: [:], endPoint: Endpoints.getAllTestQuesUrl + "/" + testID! + "/" + userId!, action: "GetAllQuestion", httpMethod: .get) /* Added userID By Chandra on 3rd Jan 2020 */
        let timeComponent = testDuration.split(separator: ":")
        scheduledTestTime = ( Int(String(timeComponent[0]))! * 3600 + Int(String(timeComponent[1]))! * 60 )
        
        setBackBtn(active: false)
        
        /* Addded by yasodha to implement inline in AttandTestVC on 1/1/2020 */
        textAnswerTextView.layoutManager.delegate = self
        picker.delegate = self
        //to calculate keyboard height and frame of keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        tollBar.removeFromSuperview() //don't comment this we will get error
        textAnswerTextView.inputAccessoryView = tollBar //inserting the tabbar on top of keyboard
        
        /*added by yasodha to implement inline in AttandTestVC on 1/1/2020 */
        
        /* added by yasodha on 3/1/2020 for add Done Button on Keyboard*/
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AttandTestVC.dismissKeyboard))
        tollBar.items?.append(flexBarButton)
        tollBar.items?.append(doneBarButton)
        self.textAnswerTextView.inputAccessoryView = tollBar
        
        /* Added by yasodha on 3/1/2020 for add Done Button on Keyboard*/
        
          ModelData.shared.isAttandTV = true
        
    }
    
       override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(true)
         /*Added by yasodha 7/4/2020 starts here */
         let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
         navigationController!.navigationBar.titleTextAttributes = textAttributes
         
           /*Added by yasodha 7/4/2020 ends here */
     }
     
    
    
    
    
    
    /* Added By Yashoda on 3rd Jan 2020 - starts here */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        /*addded by yasodha to implement inline in AttandTestVC on 1/1/2020 */
        textAnswerTextView.isUserInteractionEnabled = true
        textAnswerTextView.isScrollEnabled = true
        textAnswerTextView.scrollsToTop = true
        textAnswerTextView.font = UIFont.systemFont(ofSize: 14.0)
        /*addded by yasodha to implement inline in AttandTestVC on 1/1/2020 */
        
    }
    
    /* Added By Yashoda on 3rd Jan 2020 - ends here */
    
    /* Addded by yasodha to implement inline in AttandTestVC on 1/1/2020 */
    
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
            
            textAnswerTextView.font = UIFont.systemFont(ofSize: 14.0) //to solve font issue after adding attributed text//yasodha
            
            
        }
    }
    
    /* added by yasodha on 3/1/2020 for add Done Button on Keyboard */
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    /* added by yasodha on 3/1/2020 for add Done Button on Keyboard */
    
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
        /*Added by yasodha for scribbling on 3/3/2020 starts here */
         let vc = storyboard?.instantiateViewController(withIdentifier: "ImageEditForScriblingANdCropVC") as! ImageEditForScriblingANdCropVC
                vc.backgroundImgPassed = image
                vc.Delegate = self
               // vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
                picker.dismiss(animated: true, completion: nil)
        /*added by yasodha 3/3/2020 ends here */
        
        
        /*
        /* yasodha*/
        let imageFolder = imagePicker.getImagesFolder()
        let uniqueFileName = imagePicker.getUniqueFileName()
        let finalPath = URL.init(fileURLWithPath: "\(String(describing: imageFolder))/\(String(describing: uniqueFileName))")
        var tempImagePath = String()
        do {
            
            try image.jpegData(compressionQuality: 0.1)?.write(to: finalPath, options: .atomic)
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
        var NewPosition =  textAnswerTextView.endOfDocument
        textAnswerTextView.selectedTextRange =  textAnswerTextView.textRange(from: NewPosition, to: NewPosition)
        textAnswerTextView.textStorage.insert(MyAttrString, at:  textAnswerTextView.selectedRange.location)
        NewPosition =  textAnswerTextView.endOfDocument
        textAnswerTextView.selectedTextRange =  textAnswerTextView.textRange(from: NewPosition, to: NewPosition)
        
        //create and NSTextAttachment and add your image to it.
        let attachment = NSTextAttachment()
        // localImage.append(image)
        
        //attachment.image = image
        //                attachment.image = UIImage(contentsOfFile: tempImagePath)
        attachment.image =  image
        attachment.fileWrapper = try? FileWrapper.init(url: finalPath, options: .immediate)
        print(imagepicker.getUniqueFileName())
        //calculate new size. (-20 because I want to have a litle space on the right of picture)
        let newImageWidth = (self.textAnswerTextView.bounds.size.width - 20 )
        let scale = newImageWidth/image.size.width
        let newImageHeight = image.size.height * scale
        //resize this
        //           attachment.bounds = CGRect.init(x: 10, y: 0, width: newImageWidth, height: newImageHeight-50) /* Commented By Yashoda on 8th Jan 2020 */
        attachment.bounds = CGRect.init(x: 0, y: 0, width: self.textAnswerTextView.bounds.size.width/1.05, height: self.textAnswerTextView.bounds.size.width/1.05) /* Modified By Yashoda on 8th Jan 2020 */
        
        
        //put your NSTextAttachment into and attributedString
        let attString = NSAttributedString(attachment: attachment)
        //add this attributed string to the current position.
        textAnswerTextView.textStorage.insert(attString, at:  textAnswerTextView.selectedRange.location)
        //textView.text.append("\n")
        newSubView.removeFromSuperview()
        picker.dismiss(animated: true, completion: nil)
        textAnswerTextView.becomeFirstResponder()
        let myAttribute = [ NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14) ]
        let myAttrString = NSAttributedString(string: "\n", attributes: myAttribute)
        var newPosition =  textAnswerTextView.endOfDocument
        textAnswerTextView.selectedTextRange =  textAnswerTextView.textRange(from: newPosition, to: newPosition)
        textAnswerTextView.textStorage.insert(myAttrString, at:  textAnswerTextView.selectedRange.location)
        newPosition =  textAnswerTextView.endOfDocument
        textAnswerTextView.selectedTextRange =  textAnswerTextView.textRange(from: newPosition, to: newPosition)
        //textAnswerTextView.resignFirstResponder()
 *///commented by yasodha
        
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
        case 1:  textAnswerTextView.becomeFirstResponder()
        newSubView.removeFromSuperview()
        print("keyboard pressed")
        case 2: CreateSubView()
        print("************ camera pressed **************")
        default: print("it won't come here ")
        }
    }
    
    func findImage(textStorage: NSTextStorage) {
        //this function is used to find number of images present in the textView storage and stored in a images array
        localImage = []
        for idx in 0 ..< textStorage.string.count {
            if
                let attr = textStorage.attribute(NSAttributedString.Key.attachment, at: idx, effectiveRange: nil),
                let attachment = attr as? NSTextAttachment
            {
                
                localImage.append([attachment.fileWrapper!.filename ?? "" : UIImage()])
                print(localImage)
                
            }
        }
        return
    }
    
    
    func uploadImagesToServer() -> [String] {
        findImage(textStorage:  textAnswerTextView.textStorage) //to count the images and store in array
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
    func replaceFileName(String str:String,with names: [[String :UIImage]]) -> String{
        //this is used to replace the Img src file to uploaded urls
        let imgsrc = "img src=\"file:///Attachment"
        var strr = str
        var result = String(imgsrc)
        
        for i in 0..<names.count {
            
            let dict = names[i]
            let fileName = dict.first?.key
            let mainPath = ImagePicker().getImagesFolder()
            let appendImagePath = "\(mainPath)/\(fileName!)"
            result = strr.replacingOccurrences(of: "img src=\"file:///\(fileName ?? "")\"", with: "img src=\"file://\(appendImagePath)\"")
            strr = result
            print(result)
        }
        
        return result
    }
    func storeImgInLocal(){
        // for number of img present in the img array we are storing that in phone 'document' folder
        localImgUrl = []
        for dict in localImage{
            
            let image = dict.first?.value
            let imageFolder = imagePicker.getImagesFolder()
            let uniqueFileName = dict.first?.key
            
            localImgUrl.append("\(String(describing: imageFolder))/\(String(describing: uniqueFileName))")
        }
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
    
    
    
    /* Addded by yasodha to implement inline in AttandTestVC on 1/1/2020 */
    
    private func loadUIforQuesType(type questionType: Int ) {
        if questionType == 1 {
            optionalAnsContainerView.isHidden = true
            textAnswerContainerView.isHidden = false
            textAnswerViewTopConst.constant = 10
            
        } else {
            optionalAnsContainerView.isHidden = false
            textAnswerContainerView.isHidden = true
        }
        /* Getting the height of Text Answer in Attend VC  as per the device height or size  - starts here */
        let screenSize = UIScreen.main.bounds /* Added By Veeresh on 31st Jan 2020 */
           backBtnTopConsToQuesCardview.constant = screenSize.height - ( questionLabel.frame.height + 366 )  /* Added By Veeresh on 31st Jan 2020 */
        /* Getting the height of Text Answer in Attend VC  as per the device height or size  - ends here */
    }
    
    @IBAction func onOptionsBtnClick(_ sender: UIButton?) {
        option1Btn.isSelected = false
        option2Btn.isSelected = false
        option3Btn.isSelected = false
        option4Btn.isSelected = false
        if let sender = sender {
            sender.isSelected = true
            selectedOptionalAnsIndex = sender.tag }
        else {
            selectedOptionalAnsIndex = -1
        }
    }
    @IBAction func backBtnClick(_ sender: UIButton) {
        print("Back Clicked")
        /* Added By Yashoda on 8th JAn 2020 - starts here */
        
      //  startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))//yasodha
        
        insertItemToList() // Added By Yashoda on 8th Jan 2020
        localImgUrl = []
        backbtnClicked = true
        
        /* Added By Yashoda on 8th JAn 2020 - ends here */
        print("Back Clicked")
        textAnswerTextView.resignFirstResponder()
        let indexPath = IndexPath(row: activeIndex - 1, section: 0)
        collectionView(btmIndxCollView, didSelectItemAt: indexPath)
     //   stopAnimating()  /* Added By Yashoda on 8th JAn 2020 */
    }
    
    @IBAction func nextBtnClick(_ sender: UIButton) {
        localImgUrl = [] /* Added By Yashoda on 8th Jan 2020 */
        textAnswerTextView.resignFirstResponder()
        if sender.title(for: .normal) == "Next" {
           // startAnimating(type: .lineScale, color: UIColor.init(hex: "2DA9EC")) /* Added By Yashoda on 8th Jan 2020 */
            let indexPath = IndexPath(row: activeIndex + 1, section: 0)
            collectionView(btmIndxCollView, didSelectItemAt: indexPath)
         //   self.stopAnimating() /* Added By Yashoda on 8th Jan 2020 */
        }else {
            
           
            
            _ = insertItemToList()
            let attandedQuesList = questionArray.filter { (dict) -> Bool in
                return dict["StudentAnswer"] as! String != ""
            }
                   self.invalidaiteTimer()
            let params: [String: Any] = [
                "TestID": self.testID!,
                "UserID": self.userId!,
                "TimeTaken": self.timeFormatted(self.takenTestTime),
                "AnswerDTOs": self.questionArray
            ]
                   //reviewtestSubmitVC
            // testTimeLabel.text = ""
            let vc = storyboard?.instantiateViewController(withIdentifier: "reviewtestSubmitVC") as! ReviewTestSubmit
            vc.delegate = self
            vc.params = params
            vc.testTitle = testTitleLabel.text
            //vc.testTimeTaken = "00:05:00"
            
            vc.scheduledTestTime = scheduledTestTime// secs
            vc.takenTestTime =  takenTestTime//secs
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    private func setBackBtn(active: Bool) {
        if active {
            backBtn.isUserInteractionEnabled = true
            backBtn.backgroundColor = UIColor.init(hex: "48DA00")
            backBtn.isHidden = false // commented By Yashoda on 19th Dec 2019
            
            
        }else {
            backBtn.isUserInteractionEnabled = false
            backBtn.backgroundColor = .gray
            backBtn.isHidden = true // commented By Yashoda on 19th Dec 2019
        }
    }
    private func setNextBtn(to title: String){
        nextBtn.setTitle(title, for: .normal)
    }
    
    
    private func startOtpTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        //print(self.scheduledTestTime)
        self.testTimeLabel.text = self.timeFormatted(self.scheduledTestTime) // will show timer
        self.takenTestTime += 1
        // if totalTime != 0 {
        scheduledTestTime -= 1 // decrease counter timer
        if scheduledTestTime < 10 {
            self.testTimeLabel.textColor = UIColor.red
        }
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let hours = Int(totalSeconds) / 3600
        let minutes = Int(totalSeconds) / 60 % 60
        let seconds = Int(totalSeconds) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        invalidaiteTimer()
    }
    
    private func invalidaiteTimer(){
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
    }
}
extension AttandTestVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tQIndexCell", for: indexPath) as! TQIndexCell
        cell.indexBtn.setTitle("\(indexPath.row + 1)", for: .normal)
        if  activeIndex == indexPath.row {
                      cell.indexBtn.setBackgroundImage(UIImage(named: "yellow.png"), for: .normal)
        }else {
                      let answer = questionArray[indexPath.row]["StudentAnswer"] as? String ?? ""
            if !answer.isEmpty {
                cell.indexBtn.setBackgroundImage(UIImage(named: "green.png"), for: .normal)
            }else {
                cell.indexBtn.setBackgroundImage(UIImage(named: "white.png"), for: .normal)
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                
       startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))//yasodha
        if activeIndex == indexPath.row &&  ModelData.shared.isFromReviewTestSubmit == false { //For last index
            loadDataForType(index: indexPath.row) /* Added By Yashoda on 24 Mar 2020 */
            stopAnimating()//Added by yasodha
            return
        }
        if  ModelData.shared.isFromReviewTestSubmit == true{
             loadDataForType(index: indexPath.row)
             ModelData.shared.isFromReviewTestSubmit = false
        }
        
        let result =   insertItemToList()
        if result == "move" {
            activeIndex = indexPath.row
            self.btmIndxCollView.reloadData()
        } else {
            return
        }
                
        loadDataForType(index: indexPath.row)
        setNextPrevBtn()
        self.btmIndxCollView.scrollToItem(at: IndexPath(row: indexPath.row, section: 0), at: .right, animated: false)
        stopAnimating()  /* Added By Yashoda on 24 Mar 2020 */
        
    }
    private func setNextPrevBtn() {
        if activeIndex == questionArrayJSON.count - 1 {
            setNextBtn(to: "Submit")
        }else{
            setNextBtn(to: "Next")
        }
        if activeIndex == 0 {
            setBackBtn(active: false)
        }else {
            setBackBtn(active: true)
        }
        
    }
     private func loadDataForType(index: Int) {
              
        let dict = questionArrayJSON[index].dictionaryValue
        let quesType = dict["QuestionType"]?.intValue
        quesNoLabel.text = "Question\(index + 1)"
        marksLbl.text = dict["QuestionMarks"]?.stringValue//Added by yasodha 19/3/2020
        questionLabel.attributedText = getAttributedString(htmlString: dict["Question"]?.stringValue ?? "")
        questionLabel.font = UIFont(name:"Roboto-Medium", size: 20.0)
        questionLabel.textColor = UIColor.black /* Added By Ranjeet on 26th March 2020 */
        /*  Updated By Ranjeet on 26th March 2020 - starts here */
               if #available(iOS 13.0, *) {
                questionLabel.textColor = UIColor.label
                
               } else {
                   // Fallback on earlier versions
               }
               /*   Updated By Ranjeet on 26th March 2020 - ends here */
        //questionLabel.attributedText = getAttributedString(htmlString: dict["Question"]!.stringValue)
        let answer = questionArray[index]["StudentAnswer"] as? String ?? ""
        if quesType == 1 {
            //load view with data for text question
            loadUIforQuesType(type: quesType!)
            if !answer.isEmpty {
                //  textAnswerTextView.text = answer /* Commented By Yashoda on 3rd Jan 2020 */
                //textAnswerTextView.attributedText = getAttributedString(htmlString: answer)
                textAnswerTextView.attributedText = answer.html2Attributed /* Added By Yashoda on 3rd Jan 2020 */
                textViewDidBeginEditing(textAnswerTextView)
            }else {
                //textViewDidEndEditing(textAnswerTextView)
                textAnswerTextView.text = textViewAnsHint
                textAnswerTextView.textColor = UIColor.init(hex: "909191")
            }
        }else {
            //load view with data for objective question
            loadUIforQuesType(type: quesType!)
            let optionaArray = dict["OptionList"]!.arrayValue
                var i = 0
                var option1 : String!
                var option2: String!
                var option3: String!
                var option4: String!

                while i < optionaArray.count {
                switch i {
                case 0:
                option1 = optionaArray[0].stringValue
                case 1:
                option2 = optionaArray[1].stringValue
                case 2:
                option3 = optionaArray[2].stringValue
                case 3:
                option4 = optionaArray[3].stringValue

                default:
                print("completed giving values")
                }
                i = i+1

                }
                /*Added by yasodha on 24/2/2020 starts here */
                
                option1Btn.setTitle(option1, for: .normal)
                option2Btn.setTitle(option2, for: .normal)
                
                if option3 == "" || option3 == nil{
                    
                    option3Btn.isHidden = true
                }else{
                    option3Btn.isHidden = false
                    option3Btn.setTitle(option3, for: .normal)
                    
                }
                
                if option4 == "" || option4 == nil{
                    
                    option4Btn.isHidden = true
                }else{
                    option4Btn.isHidden = false
                    option4Btn.setTitle(option4, for: .normal)
                    
                }
              
                /*Added by yasodha on 24/2/2020 ends here */
                               
               
                if option1 == answer {
                    onOptionsBtnClick(option1Btn)
                }else if option2 == answer {
                    onOptionsBtnClick(option2Btn)
                }else if option3 == answer {
                    onOptionsBtnClick(option3Btn)
                }else if option4 == answer {
                    onOptionsBtnClick(option4Btn)
                }else {
                    onOptionsBtnClick(nil)
                }
        }
    }
        
  
    private func insertItemToList() -> String {
            let quesType = questionArrayJSON[activeIndex]["QuestionType"].intValue
            if quesType == 1 {
               if backbtnClicked != true
                {
                    backbtnClicked = false
                                        
                    let html =  textAnswerTextView.textStorage.attributedString2Html
                    /*Added By Yashoda on 8th  Jan 2020 - starts here */
                    
                    let height = self.textAnswerTextView.bounds.size.width/1.05
                    let width = self.textAnswerTextView.bounds.size.width/1.05
                    let setHeightUsingCSS = "<head><style type=\"text/css\"> img{ max-height: 100%; max-width: 100% !important; width:\(width); height: \(height);} </style> </head><body> \(html!) </body>"
                   
                    
                    /* Added By Yashoda on 8th  Jan 2020 - ends here */
                    
                    //the above code is css which is used to make image height and width proper
                    print(html!)
                    
                    // if (html?.contains("img src"))!{  /* Commented By Yashoda on 8th  Jan 2020 */
                    if (setHeightUsingCSS.contains("img src")){ /* Modified By Yashoda on 8th  Jan 2020 */
                        findImage(textStorage: textAnswerTextView.textStorage)
                        storeImgInLocal()
                        finalAnswerString = replaceFileName(String: setHeightUsingCSS, with: localImage) /* Modified By Yashoda on 8th  Jan 2020 */
                        
                    }
                    else {
                        if  textAnswerTextView.text == textViewAnsHint{
                            
                            finalAnswerString = ""
                            
                        }else{
                            finalAnswerString = textAnswerTextView.text
                        }
                        
                        
                    }
                                        
                    textAnswerTextView.resignFirstResponder()
                    //validiate() //here where the answer will be binded yasodha
                    textAnswerTextView.text=nil
                    
                    /* Added By Yashoda on 8th Jan 2020 - starts here */
                    /************************Commented by yasodha  on 1/6/2020 starts here*************************/
                    
//                let answer = questionArray[activeIndex]["StudentAnswer"] as? String ?? ""
//                if finalAnswerString == "" &&  !answer.isEmpty{
//
//                    print("if condition index : \(activeIndex) ")
//
//
//                  //  questionArray[activeIndex]["StudentAnswer"] = finalAnswerString
//                    }else{
//                         print("else if condition index : \(activeIndex) ")
//                        questionArray[activeIndex]["StudentAnswer"] = finalAnswerString
//
//                    }
//
//
//  /           ************************Commented by yasodha on 1/6/2020 end here *************************///
//
                    /* Added By Yashoda on 8th Jan 2020 - ends here */
                                        
                     questionArray[activeIndex]["StudentAnswer"] = finalAnswerString /* Commented By Yashoda on 8th Jan 2020 */
                                                            
                }else
                {
                    
                }
                /*Added By Yashoda on 3rd Jan 2020 - ends  here */
                
                //  } /* Commented  By Yashoda on 3rd Jan 2020 */
                // questionArray[activeIndex]["StudentAnswer"] = ans   /* Commented  By Yashoda on 3rd Jan 2020 */
                
            } else if quesType == 2 {
                guard selectedOptionalAnsIndex != -1 else {return "move"}
                questionArray[activeIndex]["StudentAnswer"] = questionArrayJSON[activeIndex]["OptionList"][selectedOptionalAnsIndex].stringValue
                
            }
            return "move"
        }
}
extension AttandTestVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if [textViewAnsHint].contains(textView.text) {
            textView.text = nil
        }
        textView.textColor = UIColor.black /* Added By Ranjeet on 13th April 2020 */
        /*  Updated By Ranjeet on 26th March 2020 - starts here */
        if #available(iOS 13.0, *) {
            textView.textColor = UIColor.label
        } else {
            // Fallback on earlier versions
        }
        /*   Updated By Ranjeet on 26th March 2020 - ends here */
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            // textView.text = textViewAnsHint /* Commented By Yashoda on 3rd Jan 2020 */
            textView.textColor = UIColor.init(hex: "909191")
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        backbtnClicked = false  /* Added By Yashoda on 3rd Jan 2020 */
        return true
        
    }
    
}
extension AttandTestVC {
    private func hitServer(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){[unowned self] result in
            self.stopAnimating()
            switch result {
            case let .success(json,_):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }
                else {
                    if action == "SubmitAns" {
                        showMessage(bodyText: msg,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 1))
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.bindData(json: json)
                    }
                }
                break
            case .failure(let error as NSError):
                print("MyError = \(error.localizedDescription)")
                break
            }
        }
    }
    
    private func bindData(json: JSON) {
        testTitleLabel.text = json["ControlsData"]["TestTitle"].stringValue
        questionArrayJSON = json["ControlsData"]["lsv_testQuestion"].arrayValue
        /*Commented by yasodha */
//        for quesJson in questionArrayJSON {
//            var quesDict: [String: Any] = [:]
//            quesDict["TestID"] = testID
//            quesDict["UserID"] = userId
//            quesDict["QuestionID"] = quesJson["QuestionID"].stringValue
//            quesDict["Question"] = quesJson["Question"].stringValue
//            quesDict["StudentAnswer"] = ""
//            questionArray.append(quesDict)
//        }
//
        /* Added by yasodha 28/3/2020 starts here*/
         for quesJson in questionArrayJSON {
                           var quesDict: [String: Any] = [:]
                           quesDict["TestID"] = testID
                           quesDict["UserID"] = userId
                           quesDict["QuestionID"] = quesJson["QuestionID"].stringValue
                           quesDict["Question"] = quesJson["Question"].stringValue
                           quesDict["QuestionMarks"] = quesJson["QuestionMarks"].stringValue
                           quesDict["StudentAnswer"] = ""
                           questionArray.append(quesDict)
                       }
        /*Added by yasodha ends here */
        
        if questionArrayJSON.count > 0 {
            loadDataForType(index: 0)
            btmIndxCollView.reloadData()
            setNextPrevBtn()
            startOtpTimer()
        }
        
    }
}


extension AttandTestVC: AddEditAnswerProtocol {
    func loadProperQues(index: Int, scheduledTestTime: Int, takenTestTime: Int) {
        self.scheduledTestTime = scheduledTestTime
        self.takenTestTime = takenTestTime
        self.startOtpTimer()
        ModelData.shared.isFromReviewTestSubmit = true
        activeIndex = index
        let indexPath = IndexPath(row: activeIndex, section: 0)
        //collectionView(btmIndxCollView, didSelectItemAt: indexPath)
        collectionView(btmIndxCollView, didSelectItemAt: indexPath)
    }
    
    
}

/*Added by yasodha on 1/3/2020 starts here */
extension AttandTestVC : EditImgSender {
    func getImg(EditedImg: UIImage) {
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
              var NewPosition =  textAnswerTextView.endOfDocument
              textAnswerTextView.selectedTextRange =  textAnswerTextView.textRange(from: NewPosition, to: NewPosition)
              textAnswerTextView.textStorage.insert(MyAttrString, at:  textAnswerTextView.selectedRange.location)
              NewPosition =  textAnswerTextView.endOfDocument
              textAnswerTextView.selectedTextRange =  textAnswerTextView.textRange(from: NewPosition, to: NewPosition)
              
              //create and NSTextAttachment and add your image to it.
              let attachment = NSTextAttachment()
              // localImage.append(image)
              
              //attachment.image = image
              //                attachment.image = UIImage(contentsOfFile: tempImagePath)
              attachment.image =  EditedImg
              attachment.fileWrapper = try? FileWrapper.init(url: finalPath, options: .immediate)
              print(imagepicker.getUniqueFileName())
              //calculate new size. (-20 because I want to have a litle space on the right of picture)
              let newImageWidth = (self.textAnswerTextView.bounds.size.width - 20 )
              let scale = newImageWidth/EditedImg.size.width
              let newImageHeight = EditedImg.size.height * scale
              //resize this
              //           attachment.bounds = CGRect.init(x: 10, y: 0, width: newImageWidth, height: newImageHeight-50) /* Commented By Yashoda on 8th Jan 2020 */
              attachment.bounds = CGRect.init(x: 0, y: 0, width: self.textAnswerTextView.bounds.size.width/1.05, height: self.textAnswerTextView.bounds.size.width/1.05) /* Modified By Yashoda on 8th Jan 2020 */
              
              
              //put your NSTextAttachment into and attributedString
              let attString = NSAttributedString(attachment: attachment)
              //add this attributed string to the current position.
              textAnswerTextView.textStorage.insert(attString, at:  textAnswerTextView.selectedRange.location)
              //textView.text.append("\n")
              newSubView.removeFromSuperview()
              picker.dismiss(animated: true, completion: nil)
              textAnswerTextView.becomeFirstResponder()
              let myAttribute = [ NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14) ]
              let myAttrString = NSAttributedString(string: "\n", attributes: myAttribute)
              var newPosition =  textAnswerTextView.endOfDocument
              textAnswerTextView.selectedTextRange =  textAnswerTextView.textRange(from: newPosition, to: newPosition)
              textAnswerTextView.textStorage.insert(myAttrString, at:  textAnswerTextView.selectedRange.location)
              newPosition =  textAnswerTextView.endOfDocument
              textAnswerTextView.selectedTextRange =  textAnswerTextView.textRange(from: newPosition, to: newPosition)
              
              
              //textAnswerTextView.resignFirstResponder()
    }
}

/*Added by yasodha on 1/3/2020 ends here*/
