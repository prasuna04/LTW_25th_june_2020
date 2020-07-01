//  AddTestQuestionVC.swift
//  LTW
//  Created by manjunath Hindupur on 12/07/19.
//  Copyright © 2019 vaayoo. All rights reserved.


// Chandra build********************************************

import UIKit
import NVActivityIndicatorView
import Alamofire
import SwiftyJSON

//var objAns = ["A","B","C","D"]
var objAns = [String]()
var objAnsClick = false
var obj1,obj2,obj3,obj4 : String!

let TextOptions = ["Text","Objective"]

class AddTestQuestionVC: UIViewController,NVActivityIndicatorViewable, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSLayoutManagerDelegate { /* Added UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSLayoutManagerDelegate By Yashoda on 3rd Jan 2020 */
    //   @IBOutlet weak var quesTypeLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    //    @IBOutlet weak var questionTypeSwitchBtn: UISwitch!
    @IBOutlet weak var quesContainerView: UIView!
    @IBOutlet weak var btmIndxCollView: UICollectionView!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var questionTypeBtn : UIButton!
    
    
    
    // @IBOutlet weak var textQues: TextQues!
    var textQues: TextQues! ; var objectiveQues: ObjectiveQues!
    var newTestMode: String!
    let textViewQuesHint =  "Enter question"
    let textViewAnsHint =  "Enter Answer (Will only be displayed after the test is taken during review)"
    var quesType: Int = 1 // 1 for text & 2 for objective
    var numberOfQues: Int = 10
    //var testID: String? = "8dce4d32-4df6-477b-824d-635f0d62e742"//commented by yasodha
    var testID: String?
    var questionArray : [[String:Any]]!
    //private var questionArray : [[String:Any]] = []
    private var questionArrayJSON : [JSON] = []
    private let userId = UserDefaults.standard.string(forKey: "userID")
    
    var activeIndex = 0
    var goingForwards = false
    
    
    var isEditTestQuestion:Bool = false
    var isEditTestQuesDisplay:Bool = false
    
    //For copyofTest
    var isCopyOfTestClick = false
    var parentTestID: String?
    var backButtonOn:Bool = true
    
    
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
    var deleteQuestionCalled = false
    //For find which textfield is active Question or  answer
    var textFieldTag :Int!
    var addAndDeleteQuestionCalled = false
    
    var questionMarks :String!
    /* Addded by yasodha to implement inline in AttandTestVC on 1/1/2020 */
    
    
    /*Added by yasodha 25/2/20202 starts here */
    @IBAction func deleteQuestion(_ sender: Any) {
        
        //showAlertButtonTapped()
        //  create the alert
        let alert = UIAlertController(title: "Delete Question", message: "Would you like to delete the question", preferredStyle: UIAlertController.Style.alert)
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { action in
            
            
            if self.questionArray.count == 1{
                showMessage(bodyText: "At least one question should be there",theme: .warning)
                return
            }
            
            self.deleteQuestionCalled = true
            self.addAndDeleteQuestionCalled = true//added by yasodha
            
            print("Enter into Delete")
            print("Index ::: \(self.activeIndex)")
            print("questionArray :::::::; \(self.questionArray)")
            self.questionArray!.remove(at: self.activeIndex)
            print("ofter remove  question Arrayis  :::::::; \(self.questionArray)")
            
            
            self.numberOfQues = self.questionArray!.count
            
            if self.questionArray.count == self.activeIndex {
                let indexPath = IndexPath(row: self.activeIndex - 1 , section: 0)
                self.collectionView(self.btmIndxCollView, didSelectItemAt: indexPath)
            }else{
                let indexPath = IndexPath(row: self.activeIndex , section: 0)
                self.collectionView(self.btmIndxCollView, didSelectItemAt: indexPath)
            }
        }))//alert
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: { action in
            
            return
            
        }))//alert
        
        
    }
    
    /*Added by yasodha 25/2/2020 ends here */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionArray = Array<Dictionary<String,Any>>(repeating: [:],count: numberOfQues)
        setupUI()
        //setBackBtn(active: false)
        if isEditTestQuestion == true {
            //submitBtn.setTitle("Update", for: .normal)
            hitServer(params: [:], endPoint: "\(Endpoints.getTestQuestionsEndPoint)\(testID!)", dueToAction: "get_test_data", method: .get)
        }else {
            
            /*Added by yasodha starts here 29/2/2020  */
            if isCopyOfTestClick == true {
                hitServer(params: [:], endPoint: "\(Endpoints.getTestQuestionsEndPoint)\(parentTestID!)", dueToAction: "get_test_data", method: .get)
                
            }else{
                self.setNextPrevBtn()
            }
            /*Added by yasodha ends  here 29/2/2020  */
            
            //self.setNextPrevBtn()//commented by yasodha
        }
        
        
        /*addded by yasodha to implement inline in AttandTestVC on 1/1/2020 */
        textQues.answerTV.layoutManager.delegate = self
        textQues.questionTV.layoutManager.delegate = self
        objectiveQues.questionTV.layoutManager.delegate = self
        
        picker.delegate = self
        //to calculate keyboard height and frame of keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        tollBar.removeFromSuperview() //don't comment this we will get error
        
        textQues.answerTV.inputAccessoryView = tollBar //inserting the tabbar on top of keyboard
        textQues.questionTV.inputAccessoryView = tollBar //inserting the tabbar on top of keyboard
        objectiveQues.questionTV.inputAccessoryView = tollBar
        
        
        /* added by yasodha on 3/1/2020 for add Done Button on Keyboard*/
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AttandTestVC.dismissKeyboard))
        tollBar.items?.append(flexBarButton)
        tollBar.items?.append(doneBarButton)
        self.textQues.answerTV.inputAccessoryView = tollBar
        textQues.questionTV.inputAccessoryView = tollBar
        objectiveQues.questionTV.inputAccessoryView = tollBar
        
        /* added by yasodha on 3/1/2020 for add Done Button on Keyboard*/
        textQues.marksTextField.delegate = self
        objectiveQues.marksTextField.delegate = self
    }
    
    
    
    /* Added By Yashoda on 3rd Jan 2020 - starts here */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        /*addded by yasodha to implement inline in AttandTestVC on 1/1/2020 */
        //  tollBar.isHidden = true//added by yasodha
        textQues.answerTV.isUserInteractionEnabled = true
        textQues.answerTV.isScrollEnabled = true
        textQues.answerTV.scrollsToTop = true
        textQues.answerTV.font = UIFont.systemFont(ofSize: 14.0)
        
        //  tollBar.isHidden = true//added by yasodha
        textQues.questionTV.isUserInteractionEnabled = true
        textQues.questionTV.isScrollEnabled = true
        textQues.questionTV.scrollsToTop = true
        textQues.questionTV.font = UIFont.systemFont(ofSize: 14.0)
        
        //  tollBar.isHidden = true//added by yasodha
        objectiveQues.questionTV.isUserInteractionEnabled = true
        objectiveQues.questionTV.isScrollEnabled = true
        objectiveQues.questionTV.scrollsToTop = true
        objectiveQues.questionTV.font = UIFont.systemFont(ofSize: 14.0)
        /*addded by yasodha to implement inline in AttandTestVC on 1/1/2020 ends here*/
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navigationController = navigationController else { return }
        navigationController.view.backgroundColor = UIColor.init(hex:"2DA9EC")
        if (self.navigationController?.navigationBar) != nil {
            navigationController.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        }
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Add Test Questions"
        /*Added by yasodha 7/4/2020 starts here */
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController.navigationBar.titleTextAttributes = textAttributes
        
        /*Added by yasodha 7/4/2020 ends here */
        
        textQues.answerContainerView.isHidden = false
        /*Added by yasodha on 25/2/2020 starts here */
        let button1 = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(addQuestion)) // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.rightBarButtonItem  = button1
        
        /*For marks underline textView */
        var bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textQues.marksTextField.frame.height - 1, width: textQues.marksTextField.frame.width, height: 1.5)
        bottomLine.backgroundColor = UIColor(hex: "2DA9EC").cgColor
        textQues.marksTextField.borderStyle = UITextField.BorderStyle.none
        textQues.marksTextField.layer.addSublayer(bottomLine)
        textQues.marksTextField.keyboardType = .decimalPad//yasodha
        textQues.marksTextField.maxLength = 9//yasodha
        
        let bottomLine1 = CALayer()
        bottomLine1.frame = CGRect(x: 0.0, y: objectiveQues.marksTextField.frame.height - 1, width: objectiveQues.marksTextField.frame.width , height: 1.5)
        bottomLine1.backgroundColor = UIColor(hex: "2DA9EC").cgColor
        objectiveQues.marksTextField.borderStyle = UITextField.BorderStyle.none
        objectiveQues.marksTextField.layer.addSublayer(bottomLine1)
        objectiveQues.marksTextField.keyboardType = .decimalPad//yasodha
        objectiveQues.marksTextField.maxLength = 9//yasodha
        /*For marks underline textView ends here*/
        
        /*Added by yasodha on 25/2/2020 ends here */
    }
    
    /*Added by yasodha for move to Mytests 7/4/2020 */
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated);
        if self.isMovingFromParent
        {
            //On click of back or swipe back
            
            if backButtonOn == true {          navigationController!.popToViewController((navigationController?.viewControllers[1])!, animated: true)
            }
        }
        if self.isBeingDismissed
        {
            //Dismissed
        }
    }
    
    /* Added by yasodha for move to Mytests end here */
    
    
    
    
    
    
    
    @objc func addQuestion(){
        
        
        // validiate()
        var tutoQues = textQues.questionTV.text
        var tutoAnswer = textQues.answerTV.text
        var marks = textQues.marksTextField.text
        
        var tutorObjQuestion = objectiveQues.questionTV.text
        // let tutoAnswerObj =
        var marksObj = objectiveQues.marksTextField.text
        
        //For validation
        if quesType == 1{
            
            if tutoQues ==  "Enter question"{
                tutoQues = ""
            }
            if tutoAnswer == "Enter Answer (Will only be displayed after the test is taken during review)"{
                tutoAnswer = ""
                
            }
            if tutoQues?.count == 0 && tutoAnswer?.count == 0 && marks?.count == 0{//We can go to next screen
                
                
            }else {
                
                if tutoQues?.count == 0 && tutoAnswer?.count != 0{
                    stopAnimating()
                    showMessage(bodyText: "please enter the question",theme: .warning)
                    return
                }
                if tutoQues?.count != 0 && marks?.count == 0{
                    stopAnimating()
                    showMessage(bodyText: "Grade points should not be empty",theme: .warning)
                    //   addAndDeleteQuestionCalled = false
                    return
                }
                  /*Added by yasodha 11/4/2020 starts here */
                if marks == "0"{
                                    showMessage(bodyText: "Grade points should be greater than zero",theme: .warning)
                                    return 
                }
               /*Added by yasodha 11/4/2020 ends here */
                
                
                
            }
            
        }else{//For Objective type
            if tutorObjQuestion ==  "Enter question"{
                tutorObjQuestion = ""
            }
            
            
            if tutorObjQuestion?.count == 0 && objectiveQues.objQues1TF.text == "" &&  objectiveQues.objQues2TF.text == "" &&  objectiveQues.objQues3TF.text == "" &&  objectiveQues.objQues4TF.text == "" && marksObj?.count == 0{//We can go to next screen
                
                
            }else {
                
                if  tutorObjQuestion?.count == 0 && (objectiveQues.objQues1TF.text != "" || objectiveQues.objQues2TF.text != "" ||  objectiveQues.objQues3TF.text != "" || objectiveQues.objQues4TF.text != ""){
                    stopAnimating()
                    showMessage(bodyText: "please enter the question",theme: .warning)
                    return
                }
                if tutorObjQuestion?.count != 0 && marksObj?.count == 0{
                    stopAnimating()
                    showMessage(bodyText: "Grade points should not be empty",theme: .warning)
                    //   addAndDeleteQuestionCalled = false
                    return
                }
                  /*Added by yasodha 11/4/2020 starts here */
                if marks == "0"{
                                    showMessage(bodyText: "Grade points should be greater than zero",theme: .warning)
                                    return
                    }
                /*Added by yasodha 11/4/2020 ends here */
                
                /*Objective validation starts here */
                
                if objectiveQues.objQues1TF.text == "" &&  objectiveQues.objQues2TF.text == "" &&  objectiveQues.objQues3TF.text == "" &&  objectiveQues.objQues4TF.text == ""
                {
                    
                    stopAnimating()
                    showMessage(bodyText: "Please add minimum two options",theme: .warning)
                    
                    return
                    
                }
                
                guard let option1 = objectiveQues.objQues1TF.text, !option1.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    stopAnimating()
                    showMessage(bodyText: "please add first option",theme: .warning)
                    return
                }
                
                guard let option2 = objectiveQues.objQues2TF.text, !option2.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    stopAnimating()
                    showMessage(bodyText: "please add second option",theme: .warning)
                    return
                }
                
                guard let option3 = objectiveQues.objQues3TF.text?.trimmingCharacters(in: .whitespacesAndNewlines) else{
                    // stopAnimating()
                    showMessage(bodyText: "please add third option",theme: .warning)
                    return
                }
                
                guard let option4 = objectiveQues.objQues4TF.text?.trimmingCharacters(in: .whitespacesAndNewlines) else{
                    //  stopAnimating()
                    showMessage(bodyText: "please enter last options.",theme: .warning)
                    return
                }
                
                
                if option3 == "" && option4 != ""{
                    stopAnimating()
                    showMessage(bodyText: "please add third option",theme: .warning)
                    return
                    
                }
                
                /* Added by yasodha on 24/2/2020 ends here */
                
                
                
            }
            
            
        }
        
        // till here
        
        
        
        
        addAndDeleteQuestionCalled = true
        let hrPart = "0" ; let minPart = "0"
        
        questionArray!.insert(["TutorAnswer": "", "TestID": testID, "Reason": "", "Que_Options": [], "QuestionType": 1, "QuestionExpiryTime":"\(hrPart):\(minPart)", "Question": ""], at: activeIndex + 1)
        /*For key board inline this code*/
        
        textQues.answerTV.layoutManager.delegate = self
        picker.delegate = self
        textQues.answerTV.inputAccessoryView = tollBar //inserting the tabbar on top of keyboard
        
        textQues.questionTV.layoutManager.delegate = self
        picker.delegate = self
        textQues.questionTV.inputAccessoryView = tollBar //inserting the tabbar on top of keyboard
        
        objectiveQues.questionTV.layoutManager.delegate = self
        picker.delegate = self
        objectiveQues.questionTV.inputAccessoryView = tollBar //inserting the tabbar on top of keyboard
        
        
        /*added by yasodha to implement inline in AttandTestVC on 1/1/2020 */
        
        numberOfQues = questionArray!.count
        
        if questionArray.count == activeIndex {
            let indexPath = IndexPath(row: activeIndex - 1 , section: 0)
            collectionView(btmIndxCollView, didSelectItemAt: indexPath)
        }else if questionArray.count > activeIndex{
            let indexPath = IndexPath(row: activeIndex + 1 , section: 0)
            collectionView(btmIndxCollView, didSelectItemAt: indexPath)
        }else{
            let indexPath = IndexPath(row: activeIndex , section: 0)
            collectionView(btmIndxCollView, didSelectItemAt: indexPath)
        }
        setQuesTypeView(quesType: 1)
    }
    
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //    }
    //
    //
    
    
    
    /* Addded by yasodha to implement inline in AttandTestVC on 1/1/2020  - starts here */
    
    //this delegate function is used to give a line spacing
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 15
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardFrame = keyboardSize) //we are taking the keyboard frame
            print("x=\(keyboardSize.origin.x) and   y=\(keyboardSize.origin.y)")
            print("height=\(keyboardSize.height)  and   width= \(keyboardSize.width)")
            
            tollBar.isHidden = false
            
            textQues.answerTV.font = UIFont.systemFont(ofSize: 14.0) //to solve font issue after adding attributed text//yasodha
            textQues.questionTV.font = UIFont.systemFont(ofSize: 14.0) //to solve font issue after adding attributed text//yasodha 9/3/2020
            objectiveQues.questionTV.font = UIFont.systemFont(ofSize: 14.0) //to solve font issue after adding attributed text//yasodha
            
        }
    }
    
    /* added by yasodha on 3/1/2020 for add Done Button on Keyboard*/
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    /* added by yasodha on 3/1/2020 for add Done Button on Keyboard*/
    
    
    
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
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ImageEditForScriblingANdCropVC") as! ImageEditForScriblingANdCropVC
        vc.backgroundImgPassed = image
        vc.Delegate = self
        // vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
        picker.dismiss(animated: true, completion: nil)
        
        
        
        
        /* //Commented for scribling images
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
         
         if textFieldTag == 0 {
         print(" ************ Enter answer *********** ")
         
         let MyAttribute = [ NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14) ]
         let MyAttrString = NSAttributedString(string: "\n", attributes: MyAttribute)
         var NewPosition =    textQues.answerTV.endOfDocument
         textQues.answerTV.selectedTextRange =    textQues.answerTV.textRange(from: NewPosition, to: NewPosition)
         textQues.answerTV.textStorage.insert(MyAttrString, at:    textQues.answerTV.selectedRange.location)
         NewPosition =    textQues.answerTV.endOfDocument
         textQues.answerTV.selectedTextRange =    textQues.answerTV.textRange(from: NewPosition, to: NewPosition)
         
         //create and NSTextAttachment and add your image to it.
         let attachment = NSTextAttachment()
         // localImage.append(image)
         
         //attachment.image = image
         //                attachment.image = UIImage(contentsOfFile: tempImagePath)
         attachment.image =  image
         attachment.fileWrapper = try? FileWrapper.init(url: finalPath, options: .immediate)
         print(imagepicker.getUniqueFileName())
         //calculate new size. (-20 because I want to have a litle space on the right of picture)
         let newImageWidth = (self.textQues.answerTV.bounds.size.width - 20 )
         let scale = newImageWidth/image.size.width
         let newImageHeight = image.size.height * scale
         //resize this
         //        attachment.bounds = CGRect.init(x: 10, y: 0, width: newImageWidth, height: newImageHeight-50)  /* Commented By YAshoda */
         attachment.bounds = CGRect.init(x: 0, y: 0, width: self.textQues.answerTV.bounds.size.width/1.05, height: self.textQues.answerTV.bounds.size.width/1.05)//yasodha
         
         
         
         //put your NSTextAttachment into and attributedString
         let attString = NSAttributedString(attachment: attachment)
         //add this attributed string to the current position.
         textQues.answerTV.textStorage.insert(attString, at:    textQues.answerTV.selectedRange.location)
         //textView.text.append("\n")
         newSubView.removeFromSuperview()
         picker.dismiss(animated: true, completion: nil)
         textQues.answerTV.becomeFirstResponder()
         let myAttribute = [ NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14) ]
         let myAttrString = NSAttributedString(string: "\n", attributes: myAttribute)
         var newPosition =    textQues.answerTV.endOfDocument
         textQues.answerTV.selectedTextRange =    textQues.answerTV.textRange(from: newPosition, to: newPosition)
         textQues.answerTV.textStorage.insert(myAttrString, at:    textQues.answerTV.selectedRange.location)
         newPosition =    textQues.answerTV.endOfDocument
         textQues.answerTV.selectedTextRange =    textQues.answerTV.textRange(from: newPosition, to: newPosition)
         //textAnswerTextView.resignFirstResponder()
         
         }else if textFieldTag == 1{
         
         
         
         
         /*Added by yasodha 9/3/20202 starts here (Inline to question) */
         let MyAttributeQues = [ NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14) ]
         let MyAttrStringQues = NSAttributedString(string: "\n", attributes: MyAttributeQues)
         var NewPositionQues =    textQues.questionTV.endOfDocument
         textQues.questionTV.selectedTextRange =    textQues.questionTV.textRange(from: NewPositionQues, to: NewPositionQues)
         textQues.questionTV.textStorage.insert(MyAttrStringQues, at:    textQues.questionTV.selectedRange.location)
         NewPositionQues =    textQues.questionTV.endOfDocument
         textQues.answerTV.selectedTextRange =    textQues.questionTV.textRange(from: NewPositionQues, to: NewPositionQues)
         
         //create and NSTextAttachment and add your image to it.
         let attachmentQues = NSTextAttachment()
         // localImage.append(image)
         
         //attachment.image = image
         //                attachment.image = UIImage(contentsOfFile: tempImagePath)
         attachmentQues.image =  image
         attachmentQues.fileWrapper = try? FileWrapper.init(url: finalPath, options: .immediate)
         print(imagepicker.getUniqueFileName())
         //calculate new size. (-20 because I want to have a litle space on the right of picture)
         let newImageWidthQues = (self.textQues.questionTV.bounds.size.width - 20 )
         let scaleQues = newImageWidthQues/image.size.width
         let newImageHeightQues = image.size.height * scaleQues
         //resize this
         //        attachment.bounds = CGRect.init(x: 10, y: 0, width: newImageWidth, height: newImageHeight-50)  /* Commented By YAshoda */
         attachmentQues.bounds = CGRect.init(x: 0, y: 0, width: self.textQues.questionTV.bounds.size.width/1.05, height: self.textQues.questionTV.bounds.size.width/1.05)//yasodha
         
         
         
         //put your NSTextAttachment into and attributedString
         let attStringQues = NSAttributedString(attachment:  attachmentQues)
         //add this attributed string to the current position.
         textQues.questionTV.textStorage.insert(attStringQues, at:   textQues.questionTV.selectedRange.location)
         //textView.text.append("\n")
         newSubView.removeFromSuperview()
         picker.dismiss(animated: true, completion: nil)
         textQues.questionTV.becomeFirstResponder()
         let myAttributeQues = [ NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14) ]
         let myAttrStringQues = NSAttributedString(string: "\n", attributes: myAttributeQues)
         var newPositionQues =    textQues.questionTV.endOfDocument
         textQues.questionTV.selectedTextRange =    textQues.questionTV.textRange(from: newPositionQues, to: newPositionQues)
         textQues.questionTV.textStorage.insert(myAttrStringQues, at:    textQues.questionTV.selectedRange.location)
         newPositionQues =    textQues.questionTV.endOfDocument
         textQues.questionTV.selectedTextRange =    textQues.questionTV.textRange(from: newPositionQues, to: newPositionQues)
         
         
         
         /*Added by yasodha 9/3/20202 ends here (Inline to question) */
         
         }else{
         /*Added by yasodha 9/3/20202 starts here (Inline to question) */
         let MyAttributeObjQues = [ NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14) ]
         let MyAttrStringObjQues = NSAttributedString(string: "\n", attributes: MyAttributeObjQues)
         var NewPositionObjQues =    objectiveQues.questionTV.endOfDocument
         objectiveQues.questionTV.selectedTextRange =    objectiveQues.questionTV.textRange(from: NewPositionObjQues, to: NewPositionObjQues)
         objectiveQues.questionTV.textStorage.insert(MyAttrStringObjQues, at:    objectiveQues.questionTV.selectedRange.location)
         NewPositionObjQues =    objectiveQues.questionTV.endOfDocument
         objectiveQues.questionTV.selectedTextRange =    objectiveQues.questionTV.textRange(from: NewPositionObjQues, to: NewPositionObjQues)
         
         //create and NSTextAttachment and add your image to it.
         let attachmentObjQues = NSTextAttachment()
         // localImage.append(image)
         
         //attachment.image = image
         //                attachment.image = UIImage(contentsOfFile: tempImagePath)
         attachmentObjQues.image =  image
         attachmentObjQues.fileWrapper = try? FileWrapper.init(url: finalPath, options: .immediate)
         print(imagepicker.getUniqueFileName())
         //calculate new size. (-20 because I want to have a litle space on the right of picture)
         let newImageWidthObjQues = (self.objectiveQues.questionTV.bounds.size.width - 20 )
         let scaleQues = newImageWidthObjQues/image.size.width
         let newImageHeightObjQues = image.size.height * scaleQues
         //resize this
         //        attachment.bounds = CGRect.init(x: 10, y: 0, width: newImageWidth, height: newImageHeight-50)  /* Commented By YAshoda */
         attachmentObjQues.bounds = CGRect.init(x: 0, y: 0, width: self.objectiveQues.questionTV.bounds.size.width/1.05, height: self.objectiveQues.questionTV.bounds.size.width/1.05)//yasodha
         
         
         //put your NSTextAttachment into and attributedString
         let attStringObjQues = NSAttributedString(attachment:  attachmentObjQues)
         //add this attributed string to the current position.
         self.objectiveQues.questionTV.textStorage.insert(attStringObjQues, at:   self.objectiveQues.questionTV.selectedRange.location)
         //textView.text.append("\n")
         newSubView.removeFromSuperview()
         picker.dismiss(animated: true, completion: nil)
         self.objectiveQues.questionTV.becomeFirstResponder()
         let myAttributeObjQues = [ NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14) ]
         let myAttrStringObjQues = NSAttributedString(string: "\n", attributes:  myAttributeObjQues)
         var newPositionObjQues =    self.objectiveQues.questionTV.endOfDocument
         self.objectiveQues.questionTV.selectedTextRange =    objectiveQues.questionTV.textRange(from: newPositionObjQues, to: newPositionObjQues)
         self.objectiveQues.questionTV.textStorage.insert(myAttrStringObjQues, at:    self.objectiveQues.questionTV.selectedRange.location)
         newPositionObjQues =    self.objectiveQues.questionTV.endOfDocument
         self.objectiveQues.questionTV.selectedTextRange =    self.objectiveQues.questionTV.textRange(from: newPositionObjQues, to: newPositionObjQues)
         
         
         /*Added by yasodha 9/3/20202 ends here (Inline to question)*/
         
         
         }
         
         */
        
        
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
        case 1:    textQues.answerTV.becomeFirstResponder()
        textQues.questionTV.becomeFirstResponder()//For question added by yasodha 9/3/2020
        objectiveQues.questionTV.becomeFirstResponder()//For objective question
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
        findImage(textStorage:    textQues.answerTV.textStorage) //to count the images and store in array
        //  findImage(textStorage:    textQues.questionTV.textStorage) //to count the images and store in array
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
            
            //                    let urlFilePath = URL.init(string: names[i] as! String)
            //                    let fileName = urlFilePath?.lastPathComponent
            let mainPath = ImagePicker().getImagesFolder()
            let appendImagePath = "\(mainPath)/\(fileName!)"
            //                    if i == 0 {
            //                    if str.contains(imgsrc)
            //                    {
            //                        result=str.replacingOccurrences(of: "img src=\"file:///Attachment.png\"", with: "img src=\"file://\(appendImagePath)\"")
            //                        print(result)
            //                    }else
            //                    {
            //                        //
            result = strr.replacingOccurrences(of: "img src=\"file:///\(fileName ?? "")\"", with: "img src=\"file://\(appendImagePath)\"")
            
            
            /*Added by yasodha on 26/2/2020 starts here */
            if   result.contains("\"file:///md-") {
                /*Already in the server*/
                print("File Name is :::::::::::\(fileName)")
                result = result.replacingOccurrences(of: "\"file:///md-", with: "\"https://ltwuploadcontent.blob.core.windows.net/thumbnails/md-")
                
            }
            
            /*Added by yasodha on 26/2/2020 ends here */
            
            
            
            
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
    
    
    
    /* Addded by yasodha to implement inline in AttandTestVC on 1/1/2020 - ends here */
    
    /* Added By Yashoda on 3rd Jan 2020 - ends here */
    
    private func setupUI() {
        textQues  = UIView.fromNib() as TextQues
        objectiveQues  = UIView.fromNib() as ObjectiveQues
        textQues.frame = quesContainerView.bounds
        quesContainerView.addSubview(textQues)
        textQues.questionTV.delegate = self
        textQues.questionTV.text = textViewQuesHint
        textQues.answerTV.delegate = self
        textQues.answerTV.text = textViewAnsHint
        objectiveQues.questionTV.delegate = self
        objectiveQues.questionTV.text = textViewQuesHint
        
        textQues.hrBtn.addTarget(self, action: #selector(AddTestQuestionVC.onTextQuesHrBtnClick),for: .touchUpInside)
        
        textQues.hrDownArrBtn.addTarget(self, action: #selector(AddTestQuestionVC.onTextQuesHrBtnClick),for: .touchUpInside)
        
        textQues.minBtn.addTarget(self, action: #selector(AddTestQuestionVC.onTextQuesMinBtnClick),for: .touchUpInside)
        textQues.minDownArrBtn.addTarget(self, action: #selector(AddTestQuestionVC.onTextQuesMinBtnClick),for: .touchUpInside)
        
        textQues.writeAnswerBtn.addTarget(self, action: #selector(AddTestQuestionVC.onTextQuesWriteAnsBtnClick),for: .touchUpInside)
        
        //  textQues.writeAnswerBtn.addTarget(self, action: #selector(AddTestQuestionVC.onTextQuesWriteAnsBtnClick),for: .touchUpInside)
        
        objectiveQues.objQues1TF.useUnderline()
        objectiveQues.objQues2TF.useUnderline()
        objectiveQues.objQues3TF.useUnderline()
        objectiveQues.objQues4TF.useUnderline()
        objectiveQues.objQues1TF.leftViewMode = .always
        objectiveQues.objQues1TF.leftView = getLabel(with: "A)")
        objectiveQues.objQues2TF.leftViewMode = .always
        objectiveQues.objQues2TF.leftView = getLabel(with: "B)")
        objectiveQues.objQues3TF.leftViewMode = .always
        objectiveQues.objQues3TF.leftView = getLabel(with: "C)")
        objectiveQues.objQues4TF.leftViewMode = .always
        objectiveQues.objQues4TF.leftView = getLabel(with: "D)")
        
        objectiveQues.hrBtn.addTarget(self, action: #selector(AddTestQuestionVC.onObjQuesHrBtnClick),for: .touchUpInside)
        
        objectiveQues.hrDownArrBtn.addTarget(self, action: #selector(AddTestQuestionVC.onObjQuesHrBtnClick),for: .touchUpInside)
        
        objectiveQues.minBtn.addTarget(self, action: #selector(AddTestQuestionVC.onObjQuesMinBtnClick),for: .touchUpInside)
        objectiveQues.minDownArrBtn.addTarget(self, action: #selector(AddTestQuestionVC.onObjQuesMinBtnClick),for: .touchUpInside)
        
        objectiveQues.answerDropDownBtn.addTarget(self, action: #selector(AddTestQuestionVC.onObjAnsDropDownBtnClick),for: .touchUpInside)
        objectiveQues.answerDownArrBtn.addTarget(self, action: #selector(AddTestQuestionVC.onObjAnsDropDownBtnClick),for: .touchUpInside)
        
        objectiveQues.writeAnswerBtn.addTarget(self, action: #selector(AddTestQuestionVC.onObjWriteAnsBtnClick),for: .touchUpInside)
    }
    private func getLabel(with text: String) -> UILabel {
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        lbl.textAlignment = .center //For left alignment
        lbl.text = text
        lbl.textColor = .black
        /* Added By Ranjeet on 13th April 2020 - starts here (Please don't remove it )*/
        if #available(iOS 13.0, *) {
            lbl.textColor = .label
        } else {
            // Fallback on earlier versions
        }
        /* Added By Ranjeet on 13th April 2020 - ends  here (Please don't remove it )*/
        // lbl.backgroundColor = .lightGray//If required
        lbl.font = UIFont.systemFont(ofSize: 18)
        //To display multiple lines in label
        lbl.numberOfLines = 0 //If you want to display only 2 lines replace 0(Zero) with 2.
        //lbl.lineBreakMode = .byWordWrapping //Word Wrap
        // OR
        //lbl.lineBreakMode = .byCharWrapping //Charactor Wrap
        
        //lbl.sizeToFit()//If required
        //yourView.addSubview(lbl)
        return lbl
    }
    @objc private func onTextQuesHrBtnClick() {
        print("onTextQuesHrBtnClick btn clicked")
        let controller = ArrayChoiceTableViewController(hrs){ (hr) in
            self.textQues.hrBtn.setTitle(String(describing: hr), for: .normal)
            // print("Month index = \((hrs.index(of: hr)! + 1))")
            self.textQues.hrBtn.setTitleColor(UIColor.black, for: .normal)
            /* Added By Ranjeet on 13th April 2020 - starts here (Please don't remove it )*/
            if #available(iOS 13.0, *) {
                self.textQues.hrBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            /* Added By Ranjeet on 13th April 2020 - ends  here (Please don't remove it )*/
        }
        controller.preferredContentSize = CGSize(width: 75, height: 200)
        showPopup(controller, sourceView: textQues.hrBtn)
        
    }
    @objc private func onTextQuesMinBtnClick() {
        print("onTextQuesMinBtnClick btn clicked")
        
        let controller = ArrayChoiceTableViewController(mins){ (min) in
            self.textQues.minBtn.setTitle(String(describing: min), for: .normal)
            //print("Month index = \((mins.index(of: min)! + 1))")
            self.textQues.minBtn.setTitleColor(UIColor.black, for: .normal)
            /* Added By Ranjeet on 13th April 2020 - starts here (Please don't remove it )*/
            if #available(iOS 13.0, *) {
                self.textQues.minBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            
            /* Added By Ranjeet on 13th April 2020 - ends here (Please don't remove it )*/
        }
        controller.preferredContentSize = CGSize(width: 75, height: 200)
        showPopup(controller, sourceView: textQues.minBtn)
    }
    
    @objc private func onTextQuesWriteAnsBtnClick() {
        textQues.answerContainerView.isHidden = false
        
        print("onTextQuesWriteAnsBtnClick btn clicked")
        textQues.writeAnswerBtn.isSelected = !textQues.writeAnswerBtn.isSelected
        if textQues.writeAnswerBtn.isSelected {
            //            textQues.answerContainerView.isHidden = false
        }else {
            //            textQues.answerContainerView.isHidden = true
        }
    }
    
    @objc private func onObjQuesHrBtnClick() {
        print("onObjQuesHrBtnClick btn clicked")
        let controller = ArrayChoiceTableViewController(hrs){ (hr) in
            self.objectiveQues.hrBtn.setTitle(String(describing: hr), for: .normal)
            self.objectiveQues.hrBtn.setTitleColor(UIColor.black, for: .normal)
            /* Added By Ranjeet on 13th April 2020 - starts here (Please don't remove it )*/
            if #available(iOS 13.0, *) {
                self.objectiveQues.hrBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            /* Added By Ranjeet on 13th April 2020 - ends here (Please don't remove it )*/
        }
        controller.preferredContentSize = CGSize(width: 75, height: 200)
        showPopup(controller, sourceView: objectiveQues.hrBtn)
    }
    @objc private func onObjQuesMinBtnClick() {
        print("onObjQuesMinBtnClick btn clicked")
        let controller = ArrayChoiceTableViewController(mins){ (min) in
            self.objectiveQues.minBtn.setTitle(String(describing: min), for: .normal)
            self.objectiveQues.minBtn.setTitleColor(UIColor.black, for: .normal)
            /* Added By Ranjeet on 13th April 2020 - starts here (Please don't remove it )*/
            if #available(iOS 13.0, *) {
                self.objectiveQues.minBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            /* Added By Ranjeet on 13th April 2020 - ends here (Please don't remove it )*/
        }
        controller.preferredContentSize = CGSize(width: 75, height: 200)
        showPopup(controller, sourceView: objectiveQues.minBtn)
    }
    
    @objc private func onObjAnsDropDownBtnClick() {
        print("onAnswerDropDownBtnClick btn clicked")
        
        objAnsClick = true
        //  insertItemToList()
        let str = "  Taylor Swift  "
        let trimmed = str.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        /*Added by yasodha 3/3/2020 starts here */
        let option1 = objectiveQues.objQues1TF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let option2 = objectiveQues.objQues2TF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let option3 = objectiveQues.objQues3TF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let option4 = objectiveQues.objQues4TF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        objAns.removeAll()
        if option1  != "" && option1  != " "{
            
            objAns.append("A")
        }
        if option2  != "" && option2  != " "{
            objAns.append("B")
            
        }
        if option3  != "" && option3  != " "{
            objAns.append("C")
            
        }
        if option4  != "" && option4  != " "{
            objAns.append("D")
            
        }
        /*Added by yasodha 3/3/2020 starts here */
        
        let controller = ArrayChoiceTableViewController(objAns){ (min) in
            self.objectiveQues.answerDropDownBtn.setTitle(String(describing: min), for: .normal)
            self.objectiveQues.answerDropDownBtn.setTitleColor(UIColor.black, for: .normal)
            /* Added By Ranjeet on 13th April 2020 - starts here (Please don't remove it )*/
            if #available(iOS 13.0, *) {
                self.objectiveQues.answerDropDownBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            /* Added By Ranjeet on 13th April 2020 - ends here (Please don't remove it )*/
        }
        /*Added by yasodha 3/3/2020 starts here */
        if objAns.count == 1{
            controller.preferredContentSize = CGSize(width: 75, height: 50)
        }
        if objAns.count == 2{
            controller.preferredContentSize = CGSize(width: 75, height: 100)
        }
        if objAns.count == 3{
            controller.preferredContentSize = CGSize(width: 75, height: 150)
        }
        
        if objAns.count == 4{
            controller.preferredContentSize = CGSize(width: 75, height: 200)
        }
        
        // controller.preferredContentSize = CGSize(width: 75, height: 200)//commented by yasodha
        
        /*Added by yasodha 3/3/2020 ends here */
        
        showPopup(controller, sourceView: objectiveQues.answerDropDownBtn)
    }
    @objc private func onObjWriteAnsBtnClick() {
        print("onObjWriteAnsBtnClick btn clicked")
        
        objectiveQues.writeAnswerBtn.isSelected = !objectiveQues.writeAnswerBtn.isSelected
        if objectiveQues.writeAnswerBtn.isSelected {
            objectiveQues.ansDropdownContainer.isHidden = false
        }else {
            objectiveQues.ansDropdownContainer.isHidden = true
        }
    }
    
    
    
    @IBAction func onQuesTypeToggleClick(_ sender: UISwitch) {
    }
    
    @IBAction func onQuesTypeBtnlicked(_ sender : UIButton)
    {
        let controller = ArrayChoiceTableViewController(TextOptions){[unowned self] (selectedSubject) in
            
            
            if String(describing: selectedSubject ) == "Text" {
                
                //  self.questionTypeBtn.setTitle("Text ", for: .normal)//commented by yasodha
                self.questionTypeBtn.setTitle("Text Question    ", for: .normal)
                
                self.setQuesTypeView(quesType: 1)
                
            }else {
                
                self.questionTypeBtn.setTitle("Objective ", for: .normal)
                self.setQuesTypeView(quesType: 2)
                
            }
            self.questionTypeBtn.setTitleColor(UIColor.white, for: .normal)
            
            
        }
        // controller.preferredContentSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 200)//commented yasodha
        controller.preferredContentSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 95)//Added by yasodha
        showPopup(controller, sourceView: sender)
    }
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    
    @IBAction func onSubmitBtnClick(_ sender: UIButton) {
        //  _ = insertItemToList()//commented by yasodha
        print("Endpoints = \(Endpoints.addQuesEndPoint)")
        let filteredQuesArr = questionArray!.filter { $0.count != 0 }
        print("filteredQuesArr count = \(filteredQuesArr.count)")
        print("Body packet = \(filteredQuesArr)")
        if filteredQuesArr.count == 0 {
            showMessage(bodyText: "Please enter atleast one question.",theme: .warning)
            return
        }
        /*Added by yasodha 26/2/2020 starts here*/
        var quesArrWithInline:[[String:Any]] = []//yasodha
        quesArrWithInline = replaceImgPath(params:filteredQuesArr)//yasodha
        
        if isEditTestQuestion == true {
            uploadDataToServer(endPoint: Endpoints.editTestQuestionsEndPoint, dataToUpload:  quesArrWithInline)//yasodha
        }else {
            uploadDataToServer(endPoint: Endpoints.addQuesEndPoint, dataToUpload:  quesArrWithInline)//yasodha
        }
        
        /*Added by yasodha 26/2/2020 ends here*/
        
        
        
        
    }
    @IBAction func backBtnClick(_ sender: UIButton) {
        //   startAnimating(type: .lineScale, color: UIColor.init(hex: "2DA9EC")) /* Added By Yashoda on 8th Jan 2020 */
        print("Back Clicked")
        // textAnswerTextView.resignFirstResponder()
        let indexPath = IndexPath(row: activeIndex - 1, section: 0)
        collectionView(btmIndxCollView, didSelectItemAt: indexPath)
        //    stopAnimating()  /* Added By Yashoda on 8th Jan 2020 */
    }
    
    @IBAction func nextBtnClick(_ sender: UIButton) {
        //textAnswerTextView.resignFirstResponder()
        if sender.title(for: .normal) == "Next" {
            //   startAnimating(type: .lineScale, color: UIColor.init(hex: "2DA9EC")) /* Added By Yashoda on 8th Jan 2020 */
            //   validiate()
            let indexPath = IndexPath(row: activeIndex + 1, section: 0)
            collectionView(btmIndxCollView, didSelectItemAt: indexPath)
            //  stopAnimating() /* Added By Yashoda on 8th Jan 2020 */
        }else {
            //  let indexPath = IndexPath(row: activeIndex, section: 0)
            //    collectionView(btmIndxCollView, didSelectItemAt: indexPath)
            
            // _ = insertItemToList()//last index load
            
            backButtonOn = false//added by yasodha
            let result =   insertItemToList()
            
            if result == "move" {
                
                print("Endpoints = \(Endpoints.addQuesEndPoint)")
                var filteredQuesArr = questionArray!.filter { $0.count != 0 }
                print("filteredQuesArr count = \(filteredQuesArr.count)")
                print("Body packet = \(filteredQuesArr)")
                
                if filteredQuesArr.count == 0 {
                    showMessage(bodyText: "Please Enter at least one Question",theme: .warning)
                    return
                }
                
                /*Added by yasodha For remove empty question data 31/3/2020 */
                var arryOfDict :[[String:Any]] = []//yasodha
                
                var  i:Int = 0
                for  dict in filteredQuesArr{
                    let ques = dict["Question"] as? String
                    
                    if ques!.isEmpty {}else{
                        
                        arryOfDict.insert(dict, at: i)
                        i = i + 1
                    }
                    //   i = i + 1
                    
                }
                
                filteredQuesArr = arryOfDict
                /*Added by yasodha For remove empty question data 31/3/2020 ends here  */
                //ends here
                
                /* Commented By Yashoda on 8th Jan 2020 - starts here */
                var quesArrWithInline:[[String:Any]] = []//yasodha
                quesArrWithInline = replaceImgPath(params:filteredQuesArr)//yasodha
                
                /*Added by yasodha */
                if isEditTestQuestion == true {
                    uploadDataToServer(endPoint: Endpoints.editTestQuestionsEndPoint, dataToUpload:  quesArrWithInline)//yasodha
                }else {
                    uploadDataToServer(endPoint: Endpoints.addQuesEndPoint, dataToUpload:  quesArrWithInline)//yasodha
                }
                
                
                
                /* Commented By Yashoda on 8th Jan 2020 - ends here */
            }//if
        }
    }
    
    /*Validation starts here */
    
    private  func validiate() {
        
        
        
    }
    
    /*validation ends here */
    
    
    
    
    /*Added by yasodha to replace local img path to thumbnails path 8th Jan 2020  - starts here */
    
    func replaceImgPath(params: [[String:Any]])->[[String:Any]] {
        
        let question = params
        
        var myNewDictArray = [[String:Any]]()
        var queDict :[String : Any]!
        for dict  in  question {
            
            queDict = dict
            let studentAnswer = dict["TutorAnswer"] as! String
            //   print("dic:::::::::: \(dict)")
            var  replacedAns = String()
            if studentAnswer.contains("<p") || studentAnswer.contains("<!DOCTYPE") || studentAnswer.contains("<head><style")
            {
                replacedAns =  replaceNames(str: studentAnswer, with:  uploadImagesToServer(str : studentAnswer))
                
                /*Added by yasodha on 26/2/2020 starts here */
                replacedAns = replacedAns.replacingOccurrences(of: "md-md-", with: "md-")
                replacedAns = replacedAns.replacingOccurrences(of: "alt=\"md-", with: "alt=\"")
                
                /*Added by yasodha on 26/2/2020 ends here */
                
                
                print(replacedAns)
                queDict.updateValue(replacedAns, forKey: "TutorAnswer")
                
            }else
            {
            }
            
            /*Added by yasodha  10/3/2020 starts here  */
            //For inline Question
            let tutorQuestion = dict["Question"] as! String
            //   print("dic:::::::::: \(dict)")
            var  replacedQues = String()
            if tutorQuestion.contains("<p") || tutorQuestion.contains("<!DOCTYPE") || tutorQuestion.contains("<head><style")
            {
                replacedQues =  replaceNames(str: tutorQuestion, with:  uploadImagesToServer(str : tutorQuestion))
                
                /*Added by yasodha on 26/2/2020 starts here */
                replacedQues =  replacedQues.replacingOccurrences(of: "md-md-", with: "md-")
                replacedQues =  replacedQues.replacingOccurrences(of: "alt=\"md-", with: "alt=\"")
                
                /*Added by yasodha on 26/2/2020 ends here */
                
                
                print(replacedQues)
                queDict.updateValue(replacedQues, forKey: "Question")
                
            }else
            {
            }
            
            /*Added by yasodha  10/3/2020 ends here  */
            
            
            print("dict \(queDict)")
            myNewDictArray.append(queDict)
            
        }
        
        return myNewDictArray
        
        
        
    }
    
    
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
        // var result = String()//commented by yasodha
        /*Added by yasodha on 26/2/2020 Stars here */
        
        var result = str//add yasodha
        
        if isEditTestQuestion == true{
            
            if names.count < imageurls.count
            {
                var imageUrls_new =  [String]()
                //  let imageUrls_new = imageurls
                
                for  i in 0..<imageurls.count{
                    
                    let image_name = (imageurls[i] as NSString)
                    
                    if image_name.contains("https://ltwuploadcontent.blob.core.windows.net/thumbnails/md-"){
                        
                    }else{
                        imageUrls_new.append(imageurls[i])
                    }
                    
                }
                
                imageurls = imageUrls_new
                
                
            }
            
            //For replace image path local to server
            for  i in 0..<names.count{
                
                //let Lastname_name = (names[i] as NSString).lastPathComponent//commented by yasodha
                var Lastname_name = (names[i] as NSString).lastPathComponent//commented by yasodha
                Lastname_name = Lastname_name.replacingOccurrences(of: "md-", with: "")
                let image_name = (imageurls[i] as NSString).lastPathComponent
                
                if Lastname_name == image_name{
                    result = str.replacingOccurrences(of: imageurls[i], with: "\""+names[i])
                    
                }
                
                // result = str.replacingOccurrences(of: imageurls[i], with: "\""+names[i])
            }
            
        }else {
            
            /*Added by yasodha on 26/2/2020 ends here */
            
            
            
            for i in 0..<names.count {
                if i == 0 {
                    result = str.replacingOccurrences(of: imageurls[i], with: "\""+names[i])
                }
                else{
                    result = result.replacingOccurrences(of: imageurls[i], with: "\""+names[i])
                }
            }
            
        }//else
        return result
    }
    func uploadImagesToServer(str : String) -> [String] {
        var imageurls =  [String]()
        let startigRange = str.ranges(of: "img src=")
        let endingRange = str.ranges(of: ".jpg\" alt")
        let temp = str.components(separatedBy: "src")
        
        imageurls.removeAll()//Added by yasodha for edit text
        
        for i in 0..<temp.count-1{
            let start = startigRange[i].upperBound
            let end = endingRange[i].lowerBound
            let range = start...end
            let res = String(str[range]) + "jpg"
            
            /*Added by yasodha on 3/2/20202 Starts here */
            if res.contains("\"https://ltwuploadcontent.blob.core.windows.net/thumbnails/md-") {
                
            }else if res.contains("\"file:///md-") {
                
            }else{
                imageurls.append(String( res.replacingOccurrences(of: "\"file://", with: "")))
            }
            
        }
        
        // here we are uploading the images to the server
        
        if imageurls.count == 0 {
            return  imageurls
            
        }//added by yasodha for edittext
        
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
    
    /*Added by yasodha to replace local img path to thumbnails path on 8th Jan 2020 - ends here */
    
    /* Added By Yashoda on 8th Jan 2020 - ends here */
    private func setBackBtn(active: Bool) {
        if active {
            backBtn.isUserInteractionEnabled = true
            backBtn.backgroundColor = UIColor.init(hex: "48DA00")
            backBtn.isHidden = false /* Added By Yashoda on 8th Jan 2020 - ends here */
        }else {
            backBtn.isUserInteractionEnabled = false
            backBtn.backgroundColor = .gray
            backBtn.isHidden = true /* Added By Yashoda on 8th Jan 2020 - ends here */
        }
    }
    private func setNextBtn(to title: String){
        nextBtn.setTitle(title, for: .normal)
    }
    
}

extension AddTestQuestionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfQues
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tQIndexCell", for: indexPath) as! TQIndexCell
        cell.indexBtn.setTitle("\(indexPath.row + 1)", for: .normal)
        if  activeIndex == indexPath.row {
            cell.indexBtn.backgroundColor = UIColor.init(hex: "FFAE00")
            cell.indexBtn.setTitleColor(UIColor.white, for: .normal)
            applyFloatingRoundShadow(view: cell.indexBtn)
        }else {
            cell.indexBtn.backgroundColor = UIColor.init(hex: "FFFFFF")
            cell.indexBtn.setTitleColor(UIColor.gray, for: .normal)
            cell.indexBtn.layer.shadowColor = UIColor.init(hex: "FFFFFF").cgColor
            cell.indexBtn.layer.masksToBounds = false
            cell.indexBtn.layer.shadowRadius = 0
            cell.indexBtn.layer.shadowOpacity = 0
            cell.indexBtn.layer.cornerRadius = 0
        }
        
        // cell.backgroundColor = activeIndex == indexPath.row ? UIColor.green : UIColor.red
        
        
        return cell
    }
    
    func setQuesTypeView(quesType: Int) {
        if  quesType == 1 {
            //        questionTypeSwitchBtn.setOn(false, animated: true)
            //         quesTypeLbl.text = "Text"
            self.questionTypeBtn.setTitle("Text Question    ", for: .normal)
            
            self.quesType = quesType
            objectiveQues.removeFromSuperview()
            textQues.frame = quesContainerView.bounds
            quesContainerView.addSubview(textQues)
            // clear value from each  controll and set to default mode
            textQues.questionTV.text = textViewQuesHint
            textQues.questionTV.resignFirstResponder()
            textQues.questionTV.textColor = UIColor.init(hex: "909191")
            textQues.hrBtn.setTitle("hr", for: .normal)
            textQues.hrBtn.setTitleColor(UIColor.init(hex: "2DA9EC"), for: .
                normal)
            textQues.minBtn.setTitle("min", for: .normal)
            textQues.minBtn.setTitleColor(UIColor.init(hex: "2DA9EC"), for: .
                normal)
            
            textQues.writeAnswerBtn.isSelected = false
            textQues.answerContainerView.isHidden = false
            textQues.answerTV.text = textViewAnsHint
            textQues.answerTV.resignFirstResponder()
            textQues.answerTV.textColor = UIColor.init(hex: "909191")
            
        }else {
            //   questionTypeSwitchBtn.setOn(true, animated: true)
            // quesTypeLbl.text = "Objective"
            self.questionTypeBtn.setTitle("Objective ", for: .normal)
            
            self.quesType = quesType
            
            textQues.removeFromSuperview()
            textQues.writeAnswerBtn.titleLabel?.text = ""
            
            objectiveQues.frame = quesContainerView.bounds
            quesContainerView.addSubview(objectiveQues)
            // clear value from each  controll and set to default mode
            objectiveQues.questionTV.text = textViewQuesHint
            objectiveQues.questionTV.resignFirstResponder()
            objectiveQues.questionTV.textColor = UIColor.init(hex: "909191")
            objectiveQues.hrBtn.setTitle("hr", for: .normal)
            objectiveQues.hrBtn.setTitleColor(UIColor.init(hex: "2DA9EC"), for: .
                normal)
            objectiveQues.minBtn.setTitle("min", for: .normal)
            objectiveQues.minBtn.setTitleColor(UIColor.init(hex: "2DA9EC"), for: .
                normal)
            objectiveQues.writeAnswerBtn.isSelected = false
            objectiveQues.ansDropdownContainer.isHidden = true
            objectiveQues.answerDropDownBtn.setTitle("Ans", for: .normal)
            objectiveQues.objQues1TF.text = ""
            objectiveQues.objQues2TF.text = ""
            objectiveQues.objQues3TF.text = ""
            objectiveQues.objQues4TF.text = ""
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // startAnimating(type: .lineScale, color: UIColor.init(hex: "2DA9EC")) /* Added By Yashoda on 12 Mar 2020 */
        
        
        
        if self.isEditTestQuesDisplay == true{//First time EditTestQuestion display no need to call insertItemToList method
            self.isEditTestQuesDisplay = false
        }else{
            
            let result =   insertItemToList()
            
            if result == "move" {
                activeIndex = indexPath.row
                self.btmIndxCollView.reloadData()
            } else {
                return
            }
        }
        // setQuesTypeView(quesType: self.quesType) // ignore if user press same btn activeIndex = indexPath.row
        
        
        let quesDict = questionArray![indexPath.row]
        
        if !quesDict.isEmpty {
            
            //Bind previous data to views
            let quesType = quesDict["QuestionType"] as! Int
            if  quesType == 1 {
                //present corresponding view
                setQuesTypeView(quesType: quesType)
                // bind data to view
                // textQues.questionTV.text = (quesDict["Question"] as! String)
                textQues.questionTV.attributedText = (quesDict["Question"] as! String).html2Attributed /* Added By Yashoda on 9th Mar 2020 */
                
                textQues.questionTV.textColor = UIColor.init(hex: "000000")
                let qExpiryTime = quesDict["QuestionExpiryTime"] as! String
                let qExpiryTimeArr = qExpiryTime.split(separator: ":")
                textQues.hrBtn.setTitle(String(qExpiryTimeArr[0]), for: .normal)
                textQues.hrBtn.setTitleColor(UIColor.init(hex: "000000"), for: .
                    normal)
                textQues.minBtn.setTitle(String(qExpiryTimeArr[1]), for: .normal)
                textQues.minBtn.setTitleColor(UIColor.init(hex: "000000"), for: .
                    normal)
                let ans = quesDict["TutorAnswer"] as! String
                
                startAnimating(type: .lineScale, color: UIColor.init(hex: "2DA9EC")) /* Added By Yashoda on 18 Mar 2020 */
                if !ans.isEmpty {
                    textQues.writeAnswerBtn.isSelected = true
                    textQues.answerContainerView.isHidden = false
                    // textQues.answerTV.text = ans /* Commented By Yashoda on 8th Jan 2020 */
                    textQues.answerTV.attributedText = ans.html2Attributed /* Added By Yashoda on 8th Jan 2020 */
                    textQues.answerTV.textColor = UIColor.init(hex: "000000")
                    
                }else {
                    textQues.answerTV.text = textViewAnsHint
                    textQues.answerTV.textColor = UIColor.init(hex: "909191")
                }
                
                textQues.marksTextField.text = quesDict["QuestionMarks"] as? String
                
                
                //    textQues.marksTextField.text = quesDict["QuestionMarks"] as? String
                
            } else if  quesType == 2 {
                
                startAnimating(type: .lineScale, color: UIColor.init(hex: "2DA9EC")) /* Added By Yashoda on 12 Mar 2020 */
                //present corresponding view
                setQuesTypeView(quesType: quesType)
                // bind data to view
                //objectiveQues.questionTV.text = (quesDict["Question"] as! String)
                
                let objQues = quesDict["Question"] as! String
                if !objQues.isEmpty {
                    
                    objectiveQues.questionTV.attributedText = objQues.html2Attributed /* Added By Yashoda on 8th Jan 2020 */
                    
                    
                }else {
                    objectiveQues.questionTV.text = textViewAnsHint
                    
                }
                objectiveQues.marksTextField.text = quesDict["QuestionMarks"] as? String//yasodha
                
                objectiveQues.questionTV.textColor = UIColor.init(hex: "000000")
                let qExpiryTime = quesDict["QuestionExpiryTime"] as! String
                let qExpiryTimeArr = qExpiryTime.split(separator: ":")
                objectiveQues.hrBtn.setTitle(String(qExpiryTimeArr[0]), for: .normal)
                objectiveQues.hrBtn.setTitleColor(UIColor.init(hex: "000000"), for: .normal)
                objectiveQues.minBtn.setTitle(String(qExpiryTimeArr[1]), for: .normal)
                objectiveQues.minBtn.setTitleColor(UIColor.init(hex: "000000"), for: .normal)
                let ans = quesDict["TutorAnswer"] as! String
                
                
                if !ans.isEmpty {
                    objectiveQues.writeAnswerBtn.isSelected = true
                    objectiveQues.ansDropdownContainer.isHidden = false
                    objectiveQues.answerDropDownBtn.setTitle(ans, for: .normal)
                }else {
                    
                }
                // set options too
                let objAns = quesDict["Que_Options"] as! [String]
                var i = 0
                while i < objAns.count {
                    switch i {
                    case 0:
                        objectiveQues.objQues1TF.text = objAns[0]
                    case 1:
                        objectiveQues.objQues2TF.text = objAns[1]
                    case 2:
                        objectiveQues.objQues3TF.text = objAns[2]
                    case 3:
                        objectiveQues.objQues4TF.text = objAns[3]
                        
                    default:
                        print("completed giving values")
                    }
                    i = i+1
                    
                }
                
                
                /*Added by yasodha on 26/2/2020 ends here */
                
                
                
            }
        }else {
            setQuesTypeView(quesType: self.quesType)
        }
        setNextPrevBtn()
        self.btmIndxCollView.scrollToItem(at: IndexPath(row: indexPath.row, section: 0), at: .right, animated: false)
        scrollView.setContentOffset(.zero, animated: true)
        
        stopAnimating()  /* Added By Yashoda on 12 Mar 2020 */
        
    }
    private func setNextPrevBtn() {
        if activeIndex == questionArray.count - 1 {
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
    
    private func insertItemToList() -> String {
        
        if quesType == 1 {
            /*  guard let ques = textQues.questionTV.text,!ques.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, ques != textViewQuesHint else {
             return "move"
             }*/ //commented by yasodha
            
            /*Added by yasodha 9/3/2020 Inline to the question */
            let htmlQue =  textQues.questionTV.textStorage.attributedString2Html
            let heigh_of_questionTV = self.textQues.questionTV.bounds.size.width/1.05
            let width_of_questionTV = self.textQues.questionTV.bounds.size.width/1.05
            let setHeightUsingCSS_for_questionTV = "<head><style type=\"text/css\"> img{ max-height: 100%; max-width: 100% !important; width:\(width_of_questionTV); height: \(heigh_of_questionTV);} </style> </head><body> \(htmlQue!) </body>"
            //the above code is css which is used to make image height and width proper
            
            /* Added on 8th jan */
            //the above code is css which is used to make image height and width proper
            print(htmlQue!)
            var tutoQues = ""
            
            
            if (setHeightUsingCSS_for_questionTV.contains("img src")){
                
                findImage(textStorage: textQues.questionTV.textStorage)
                storeImgInLocal()
                tutoQues = replaceFileName(String: setHeightUsingCSS_for_questionTV, with: localImage)
                
            }
            else {
                
                //   tutoQues = textQues.questionTV.text
                if  textQues.questionTV.text == textViewQuesHint{
                    
                    tutoQues = ""
                    
                }else{
                    // tutoQues = textQues.questionTV.text
                    tutoQues = textQues.questionTV.text.trimmingCharacters(in: .whitespacesAndNewlines) //added by yasodha
                    
                }
                
                
            }
            
            
            //    textQues.questionTV.resignFirstResponder()
            //validiate() //here where the answer will be binded yasodha
            //        textQues.questionTV.text=nil
            
            
            /*Added by yasodha 9/3/2020 ends here */
            
            
            var hrPart = "0" ; var minPart = "0"
            if textQues.hrBtn.title(for: .normal) != "hr" {
                hrPart = "\(Int(textQues.hrBtn.title(for: .normal)!)!)"
            }
            if textQues.minBtn.title(for: .normal) != "min" {
                minPart = "\(Int(textQues.minBtn.title(for: .normal)!)!)"
            }
            var tutoAns = ""
            /* Added on 8th jan */
            let html =  textQues.answerTV.textStorage.attributedString2Html
            let height = self.textQues.answerTV.bounds.size.width/1.05
            let width = self.textQues.answerTV.bounds.size.width/1.05
            let setHeightUsingCSS = "<head><style type=\"text/css\"> img{ max-height: 100%; max-width: 100% !important; width:\(width); height: \(height);} </style> </head><body> \(html!) </body>"
            //the above code is css which is used to make image height and width proper
            
            /* Added on 8th jan */
            //the above code is css which is used to make image height and width proper
            print(html!)
            
            if (setHeightUsingCSS.contains("img src")){
                
                findImage(textStorage: textQues.answerTV.textStorage)
                storeImgInLocal()
                finalAnswerString = replaceFileName(String: setHeightUsingCSS, with: localImage)
                
            }
            else {
                // finalAnswerString = textQues.answerTV.text
                
                if  textQues.answerTV.text == textViewAnsHint{
                    
                    finalAnswerString = ""
                    
                }else{
                    //finalAnswerString = textQues.answerTV.text
                    finalAnswerString = textQues.answerTV.text.trimmingCharacters(in: .whitespacesAndNewlines)//added by yasodha
                    
                }
                
            }
            
            let marks = textQues.marksTextField.text
            
            
            
            /* if marks?.count == 0 && addAndDeleteQuestionCalled != true{
             stopAnimating()
             showMessage(bodyText: "marks should not be emty",theme: .warning)
             addAndDeleteQuestionCalled = false
             return "doNotMove"
             }*/
            
            
            
            
            
            
            
            //For validation
            
            if tutoQues ==  "Enter question"{
                tutoQues = ""
            }
            if finalAnswerString == "Enter Answer (Will only be displayed after the test is taken during review)"{
                finalAnswerString = ""
                
            }
            
            
            if tutoQues.count == 0 && finalAnswerString.count == 0 && marks?.count == 0{//We can go to next screen
                
                
            }else {
                
                if tutoQues.count == 0 && finalAnswerString.count != 0{
                    stopAnimating()
                    showMessage(bodyText: "please enter the question",theme: .warning)
                    return "doNotMove"
                }
                if tutoQues.count != 0 && marks?.count == 0{
                    stopAnimating()
                    showMessage(bodyText: "Grade points should not be empty",theme: .warning)
                    //   addAndDeleteQuestionCalled = false
                    return "doNotMove"
                }
                  /*Added by yasodha 11/4/2020 starts here */
                               if marks == "0"{
                                    showMessage(bodyText: "Grade points should be greater than zero",theme: .warning)
                                    return "doNotMove"
                                  }
                                /*Added by yasodha 11/4/2020 ends here */
                
            }
            // till here
            
            
            
            // questionMarks = textQues.marksTextField.text
            
            textQues.questionTV.resignFirstResponder()
            textQues.questionTV.text = nil
            textQues.answerTV.resignFirstResponder()
            textQues.answerTV.text=nil
            tutoAns = finalAnswerString
            textQues.marksTextField.resignFirstResponder()
            textQues.marksTextField.text=nil
            
            
            let dict: [String: Any] = [
                "TestID": testID!,
                "QuestionType": quesType,
                "Question": tutoQues,
                "Que_Options": [],
                "QuestionExpiryTime":  "\(hrPart):\(minPart)",
                "TutorAnswer": tutoAns,
                "Reason": "",
                "QuestionMarks": marks
            ]
            
            
            
            
            /*Added by yasodha 26/2/2020 starts here */
            //questionArray[activeIndex] = dict
            
            if deleteQuestionCalled == true {
                deleteQuestionCalled = false
                
            }
            else{
                questionArray[activeIndex] = dict
            }
            /*Added by yasodha 26/2/2020 ends here */
            
            
        } else if quesType == 2 {
            
            // guard let ques = objectiveQues.questionTV.text,!ques.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, ques != textViewQuesHint else {return "move"}//commented by yasodha
            
            
            let html =  objectiveQues.questionTV.textStorage.attributedString2Html
            let height = self.objectiveQues.questionTV.bounds.size.width/1.05
            let width = self.objectiveQues.questionTV.bounds.size.width/1.05
            let setHeightUsingCSS = "<head><style type=\"text/css\"> img{ max-height: 100%; max-width: 100% !important; width:\(width); height: \(height);} </style> </head><body> \(html!) </body>"
            //the above code is css which is used to make image height and width proper
            
            /* Added on 8th jan */
            //the above code is css which is used to make image height and width proper
            print(html!)
            var tutorObjQuestion = ""
            
            if (setHeightUsingCSS.contains("img src")){
                
                findImage(textStorage: objectiveQues.questionTV.textStorage)
                storeImgInLocal()
                tutorObjQuestion = replaceFileName(String: setHeightUsingCSS, with: localImage)
                
            }
            else {
                // tutorObjQuestion = objectiveQues.questionTV.text
                tutorObjQuestion = objectiveQues.questionTV.text.trimmingCharacters(in: .whitespacesAndNewlines)
                
            }
            let marks = objectiveQues.marksTextField.text
            
            
            //For validation
            
            if tutorObjQuestion ==  "Enter question"{
                tutorObjQuestion = ""
            }
            
            
            if tutorObjQuestion.count == 0 && objectiveQues.objQues1TF.text == "" &&  objectiveQues.objQues2TF.text == "" &&  objectiveQues.objQues3TF.text == "" &&  objectiveQues.objQues4TF.text == "" && marks?.count == 0{//We can go to next screen
                
                
            }else {
                
                if  tutorObjQuestion.count == 0 && (objectiveQues.objQues1TF.text != "" || objectiveQues.objQues2TF.text != "" ||  objectiveQues.objQues3TF.text != "" || objectiveQues.objQues4TF.text != ""){
                    stopAnimating()
                    showMessage(bodyText: "please enter the question",theme: .warning)
                    return "doNotMove"
                }
                if tutorObjQuestion.count != 0 && marks?.count == 0{
                    stopAnimating()
                    showMessage(bodyText: "Grade points should not be empty",theme: .warning)
                    //   addAndDeleteQuestionCalled = false
                    return "doNotMove"
                }
                  /*Added by yasodha 11/4/2020 starts here */
                if marks == "0"{
                    showMessage(bodyText: "Grade points should be greater than zero",theme: .warning)
                    return "doNotMove"
                    }
                                /*Added by yasodha 11/4/2020 ends here */
                
                
                /*Objective validation starts here */
                
                if objectiveQues.objQues1TF.text == "" &&  objectiveQues.objQues2TF.text == "" &&  objectiveQues.objQues3TF.text == "" &&  objectiveQues.objQues4TF.text == ""
                {
                    
                    stopAnimating()
                    showMessage(bodyText: "Please add minimum two options",theme: .warning)
                    
                    return "doNotMove"
                    
                }
                
                guard let option1 = objectiveQues.objQues1TF.text, !option1.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    stopAnimating()
                    showMessage(bodyText: "please add first option",theme: .warning)
                    return "doNotMove"
                }
                
                guard let option2 = objectiveQues.objQues2TF.text, !option2.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    stopAnimating()
                    showMessage(bodyText: "please add second option",theme: .warning)
                    return "doNotMove"
                }
                
                guard let option3 = objectiveQues.objQues3TF.text?.trimmingCharacters(in: .whitespacesAndNewlines) else{
                    // stopAnimating()
                    showMessage(bodyText: "please add third option",theme: .warning)
                    return "doNotMove"
                }
                
                guard let option4 = objectiveQues.objQues4TF.text?.trimmingCharacters(in: .whitespacesAndNewlines) else{
                    //  stopAnimating()
                    showMessage(bodyText: "please enter last options.",theme: .warning)
                    return "doNotMove"
                }
                
                
                if option3 == "" && option4 != ""{
                    stopAnimating()
                    showMessage(bodyText: "please add third option",theme: .warning)
                    return "doNotMove"
                    
                }
                
                /* Added by yasodha on 24/2/2020 ends here */
                
                
                objAns.removeAll()
                if option1  != "" {
                    
                    objAns.append(option1)
                }
                if option2  != "" {
                    objAns.append(option2)
                    
                }
                if option3  != "" {
                    objAns.append(option3)
                    
                }
                if option4  != ""{
                    objAns.append(option4)
                    
                }
                
                
                /*Objective validation ends here */
                
            }
            // till here
            var hrPart = "0" ; var minPart = "0"
            if objectiveQues.hrBtn.title(for: .normal) != "hr" {
                hrPart = "\(Int(objectiveQues.hrBtn.title(for: .normal)!)!)"
            }
            if objectiveQues.minBtn.title(for: .normal) != "min" {
                minPart = "\(Int(objectiveQues.minBtn.title(for: .normal)!)!)"
            }
            var  ans = ""
            if objectiveQues.answerDropDownBtn.title(for: .normal) != "Ans" {
                
                ans = "\(String(objectiveQues.answerDropDownBtn.title(for: .normal)!))"
            }
            
            
            
            objectiveQues.questionTV.resignFirstResponder()
            objectiveQues.questionTV.text=nil
            objectiveQues.marksTextField.text=nil
            objectiveQues.marksTextField.resignFirstResponder()
            
            let dict: [String: Any] = [
                "TestID": testID!,
                "QuestionType": quesType,
                "Question": tutorObjQuestion,
                "Que_Options": objAns,
                "QuestionExpiryTime":  "\(hrPart):\(minPart)",
                "TutorAnswer": ans,
                "Reason": "",
                "QuestionMarks": marks
            ]
            
            
            /*Added by yasodha 26/2/2020 statrs here  */
            if deleteQuestionCalled == true {
                deleteQuestionCalled = false
                
            }
            else{
                questionArray[activeIndex] = dict
            }
            /*Added by yasodha 26/2/2020 ends here  */
            
            
        }
        return "move"
    }
}
extension AddTestQuestionVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if [textViewQuesHint,textViewAnsHint].contains(textView.text) {
            textView.text = nil
        }
        /*Added  by yasodha starts here 10/3/2020 */
        if (textView.tag == 0) {
            textFieldTag = 0 //selectedTextField is an UITextfield variable
        }else if(textView.tag == 1){
            textFieldTag = 1
            
        }else {
            
            textFieldTag = 2
            
        }
        /*Added  by yasodha ends 10/3/2020 */
        textView.textColor = UIColor.black
        /* Added By Ranjeet on 13th April 2020 - starts here (Please don't remove it )*/
        if #available(iOS 13.0, *) {
            textView.textColor = UIColor.label
        } else {
            // Fallback on earlier versions
        }
        /* Added By Ranjeet on 13th April 2020 - ends here (Please don't remove it )*/
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if  textView == textQues.answerTV {
                //    textView.text = textViewAnsHint /* Commented By Yashoda on 3rd Jan 2020 */
            }else {
                //textView.text = textViewQuesHint
            }
            textView.textColor = UIColor.init(hex: "909191")
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        backbtnClicked = false /* Added By Yashoda on 3rd Jan 2020 */
        return true
    }
    /*Added by yasodha  */
    func textViewDidChange(_ textView: UITextView){
        print("entered text:\(textView.text)")
    }
    
    
    
}
extension AddTestQuestionVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /*Added by yasodha 25/3/2020 starts here */
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print("Text string isshouldChangeCharactersIn :: \(textField.text)")
        
        if string.isEmpty { return true }
        
        
        // Build the full current string: TextField right now only contains the
        // previous valid value. Use provided info to build up the new version.
        // Can't just concat the two strings because the user might've moved the
        // cursor and delete something in the middle.
        
        let currentText = textField.text ?? ""
        
        let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Use our string extensions to check if the string is a valid double and
        // only has the specified amount of decimal places.
        return replacementText.isValidDouble(maxDecimalPlaces: 2)
        
    }
    
    
}

extension String {
    func isValidDouble(maxDecimalPlaces: Int) -> Bool {
        // Use NumberFormatter to check if we can turn the string into a number
        // and to get the locale specific decimal separator.
        let formatter = NumberFormatter()
        formatter.allowsFloats = true // Default is true, be explicit anyways
        let decimalSeparator = formatter.decimalSeparator ?? "."  // Gets the locale specific decimal separator. If for some reason there is none we assume "." is used as separator.
        
        // Check if we can create a valid number. (The formatter creates a NSNumber, but
        // every NSNumber is a valid double, so we're good!)
        if formatter.number(from: self) != nil {
            // Split our string at the decimal separator
            let split = self.components(separatedBy: decimalSeparator)
            
            // Depending on whether there was a decimalSeparator we may have one
            // or two parts now. If it is two then the second part is the one after
            // the separator, aka the digits we care about.
            // If there was no separator then the user hasn't entered a decimal
            // number yet and we treat the string as empty, succeeding the check
            let digits = split.count == 2 ? split.last ?? "" : ""
            
            // Finally check if we're <= the allowed digits
            return digits.characters.count <= maxDecimalPlaces    // TODO: Swift 4.0 replace with digits.count, YAY!
        }
        
        return false // couldn't turn string into a valid number
    }
}


/*Added by yasodha 25/3/2020 ends here */






extension AddTestQuestionVC {
    
    func uploadDataToServer(endPoint: String, dataToUpload: [[String: Any]]){
        
        // let url = Endpoints.addQuesEndPoint
        
        var request = URLRequest(url: URL.init(string: endPoint)!)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let dataToSync = dataToUpload
        request.httpBody = try! JSONSerialization.data(withJSONObject: dataToSync)
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        Alamofire.request(request).responseJSON{ (response) in
            
            print("Success: \(response)")
            self.stopAnimating()
            switch response.result{
            case .success(let value):
                let statusCode: Int = (response.response?.statusCode)!
                switch statusCode{
                case 200:
                    // completionHandler(true)
                    //print("Sussess")//["SUCCESS"]["message"]
                    
                    if self.isEditTestQuestion == true {
                        
                    }else {
                        //showMessage(bodyText: JSON(value)["message"].stringValue,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 1))
                    }
                    
                    
                    
                    
                    self.goingForwards = true
                    for viewContoller in self.navigationController!.viewControllers as Array {
                        if  viewContoller.isKind(of: MyTestVC.self) || viewContoller.isKind(of: InfoOrHelpOrShortcutVC.self){
                            self.navigationController?.popToViewController(viewContoller, animated: true)
                        }
                        
                    }
                    break
                    
                    
                default:
                    //completionHandler(false)
                    print("fail")
                    break
                }
                break
            case .failure:
                //completionHandler(false)
                print("failure")
                break
            }
        }
    }
    
}

extension AddTestQuestionVC {
    
    private func hitServer(params: [String:Any],endPoint: String, dueToAction action: String,method: HTTPMethod) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: method, dueToAction: action){[unowned self] result in
            self.stopAnimating()
            switch result {
            case let .success(json, _):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }else {
                    // showMessage(bodyText: msg,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 1))
                    
                    // testTitleLabel.text = json["ControlsData"]["TestTitle"].stringValue
                    self.questionArrayJSON = json["ControlsData"]["lsv_testQuestion"].arrayValue
                    for (index,quesJson) in self.questionArrayJSON.enumerated() {
                        print("\(quesJson["OptionList"].arrayValue)")
                        
                        /* Added By Yashoda on 16th April 2020 - start shere */
                        
                        if self.isCopyOfTestClick == true {
                            let dict: [String: Any] = [
                                "TestID": self.testID!,
                                "QuestionType": quesJson["QuestionType"].intValue,
                                "Question": quesJson["Question"].stringValue,
                                "Que_Options": quesJson["OptionList"].arrayValue.map { $0.stringValue},
                                "QuestionExpiryTime": quesJson["QuestionExpTime"].stringValue,
                                "TutorAnswer": quesJson["TutorAnswer"].stringValue,
                                "Reason": quesJson["Reason"].stringValue,
                                "QuestionMarks": quesJson["QuestionMarks"].stringValue
                            ]
                            
                            self.questionArray[index] = dict
                        }else{
                            
                            
                            let dict: [String: Any] = [
                                "TestID": quesJson["TestID"].stringValue,
                                "QuestionType": quesJson["QuestionType"].intValue,
                                "Question": quesJson["Question"].stringValue,
                                "Que_Options": quesJson["OptionList"].arrayValue.map { $0.stringValue},
                                "QuestionExpiryTime": quesJson["QuestionExpTime"].stringValue,
                                "TutorAnswer": quesJson["TutorAnswer"].stringValue,
                                "Reason": quesJson["Reason"].stringValue,
                                "QuestionMarks": quesJson["QuestionMarks"].stringValue
                            ]
                            
                            self.questionArray[index] = dict
                            
                        }
                        
                        /* Added By Yashoda on 16th April 2020 - ends here */
                    }
                    if self.questionArray.count >= 0 {
                        self.isEditTestQuesDisplay = true
                        let indexPath = IndexPath(row: 0, section: 0)
                        self.collectionView(self.btmIndxCollView, didSelectItemAt: indexPath)
                        self.setNextPrevBtn()
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

//For edit image
/*Added by yasodha 1/4/2020 starts here */
extension AddTestQuestionVC : EditImgSender {
    func getImg(EditedImg: UIImage) {
        // self.scribbledImg = scribbleImg
        let imageFolder = imagePicker.getImagesFolder()
        let uniqueFileName = imagePicker.getUniqueFileName()
        let finalPath = URL.init(fileURLWithPath: "\(String(describing: imageFolder))/\(String(describing: uniqueFileName))")
        var tempImagePath = String()
        do {
            
            /*   try image.jpegData(compressionQuality: 0.1)?.write(to: finalPath, options: .atomic)
             tempImagePath.append("\(String(describing: imageFolder))/\(String(describing: uniqueFileName))")
             print("localImageUrl path ::::::: \(tempImagePath)")*/
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
        
        if textFieldTag == 0 {
            print(" ************ Enter answer *********** ")
            
            let MyAttribute = [ NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14) ]
            let MyAttrString = NSAttributedString(string: "\n", attributes: MyAttribute)
            var NewPosition =    textQues.answerTV.endOfDocument
            textQues.answerTV.selectedTextRange =    textQues.answerTV.textRange(from: NewPosition, to: NewPosition)
            textQues.answerTV.textStorage.insert(MyAttrString, at:    textQues.answerTV.selectedRange.location)
            NewPosition =    textQues.answerTV.endOfDocument
            textQues.answerTV.selectedTextRange =    textQues.answerTV.textRange(from: NewPosition, to: NewPosition)
            
            //create and NSTextAttachment and add your image to it.
            let attachment = NSTextAttachment()
            // localImage.append(image)
            
            //attachment.image = image
            //                attachment.image = UIImage(contentsOfFile: tempImagePath)
            attachment.image =  EditedImg
            attachment.fileWrapper = try? FileWrapper.init(url: finalPath, options: .immediate)
            print(imagepicker.getUniqueFileName())
            //calculate new size. (-20 because I want to have a litle space on the right of picture)
            let newImageWidth = (self.textQues.answerTV.bounds.size.width - 20 )
            let scale = newImageWidth/EditedImg.size.width
            let newImageHeight = EditedImg.size.height * scale
            //resize this
            //        attachment.bounds = CGRect.init(x: 10, y: 0, width: newImageWidth, height: newImageHeight-50)  /* Commented By YAshoda */
            attachment.bounds = CGRect.init(x: 0, y: 0, width: self.textQues.answerTV.bounds.size.width/1.05, height: self.textQues.answerTV.bounds.size.width/1.05)//yasodha
            
            
            
            //put your NSTextAttachment into and attributedString
            let attString = NSAttributedString(attachment: attachment)
            //add this attributed string to the current position.
            textQues.answerTV.textStorage.insert(attString, at:    textQues.answerTV.selectedRange.location)
            //textView.text.append("\n")
            newSubView.removeFromSuperview()
            picker.dismiss(animated: true, completion: nil)
            textQues.answerTV.becomeFirstResponder()
            let myAttribute = [ NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14) ]
            let myAttrString = NSAttributedString(string: "\n", attributes: myAttribute)
            var newPosition =    textQues.answerTV.endOfDocument
            textQues.answerTV.selectedTextRange =    textQues.answerTV.textRange(from: newPosition, to: newPosition)
            textQues.answerTV.textStorage.insert(myAttrString, at:    textQues.answerTV.selectedRange.location)
            newPosition =    textQues.answerTV.endOfDocument
            textQues.answerTV.selectedTextRange =    textQues.answerTV.textRange(from: newPosition, to: newPosition)
            //textAnswerTextView.resignFirstResponder()
            
        }else if textFieldTag == 1{
            
            
            
            
            /*Added by yasodha 9/3/20202 starts here (Inline to question) */
            let MyAttributeQues = [ NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14) ]
            let MyAttrStringQues = NSAttributedString(string: "\n", attributes: MyAttributeQues)
            var NewPositionQues =    textQues.questionTV.endOfDocument
            textQues.questionTV.selectedTextRange =    textQues.questionTV.textRange(from: NewPositionQues, to: NewPositionQues)
            textQues.questionTV.textStorage.insert(MyAttrStringQues, at:    textQues.questionTV.selectedRange.location)
            NewPositionQues =    textQues.questionTV.endOfDocument
            textQues.answerTV.selectedTextRange =    textQues.questionTV.textRange(from: NewPositionQues, to: NewPositionQues)
            
            //create and NSTextAttachment and add your image to it.
            let attachmentQues = NSTextAttachment()
            // localImage.append(image)
            
            //attachment.image = image
            //                attachment.image = UIImage(contentsOfFile: tempImagePath)
            attachmentQues.image =  EditedImg
            attachmentQues.fileWrapper = try? FileWrapper.init(url: finalPath, options: .immediate)
            print(imagepicker.getUniqueFileName())
            //calculate new size. (-20 because I want to have a litle space on the right of picture)
            let newImageWidthQues = (self.textQues.questionTV.bounds.size.width - 20 )
            let scaleQues = newImageWidthQues/EditedImg.size.width
            let newImageHeightQues = EditedImg.size.height * scaleQues
            //resize this
            //        attachment.bounds = CGRect.init(x: 10, y: 0, width: newImageWidth, height: newImageHeight-50)  /* Commented By YAshoda */
            attachmentQues.bounds = CGRect.init(x: 0, y: 0, width: self.textQues.questionTV.bounds.size.width/1.05, height: self.textQues.questionTV.bounds.size.width/1.05)//yasodha
            
            
            
            //put your NSTextAttachment into and attributedString
            let attStringQues = NSAttributedString(attachment:  attachmentQues)
            //add this attributed string to the current position.
            textQues.questionTV.textStorage.insert(attStringQues, at:   textQues.questionTV.selectedRange.location)
            //textView.text.append("\n")
            newSubView.removeFromSuperview()
            picker.dismiss(animated: true, completion: nil)
            textQues.questionTV.becomeFirstResponder()
            let myAttributeQues = [ NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14) ]
            let myAttrStringQues = NSAttributedString(string: "\n", attributes: myAttributeQues)
            var newPositionQues =    textQues.questionTV.endOfDocument
            textQues.questionTV.selectedTextRange =    textQues.questionTV.textRange(from: newPositionQues, to: newPositionQues)
            textQues.questionTV.textStorage.insert(myAttrStringQues, at:    textQues.questionTV.selectedRange.location)
            newPositionQues =    textQues.questionTV.endOfDocument
            textQues.questionTV.selectedTextRange =    textQues.questionTV.textRange(from: newPositionQues, to: newPositionQues)
            
            
            
            /*Added by yasodha 9/3/20202 ends here (Inline to question) */
            
        }else{
            /*Added by yasodha 9/3/20202 starts here (Inline to question) */
            let MyAttributeObjQues = [ NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14) ]
            let MyAttrStringObjQues = NSAttributedString(string: "\n", attributes: MyAttributeObjQues)
            var NewPositionObjQues =    objectiveQues.questionTV.endOfDocument
            objectiveQues.questionTV.selectedTextRange =    objectiveQues.questionTV.textRange(from: NewPositionObjQues, to: NewPositionObjQues)
            objectiveQues.questionTV.textStorage.insert(MyAttrStringObjQues, at:    objectiveQues.questionTV.selectedRange.location)
            NewPositionObjQues =    objectiveQues.questionTV.endOfDocument
            objectiveQues.questionTV.selectedTextRange =    objectiveQues.questionTV.textRange(from: NewPositionObjQues, to: NewPositionObjQues)
            
            //create and NSTextAttachment and add your image to it.
            let attachmentObjQues = NSTextAttachment()
            // localImage.append(image)
            
            //attachment.image = image
            //                attachment.image = UIImage(contentsOfFile: tempImagePath)
            attachmentObjQues.image =  EditedImg
            attachmentObjQues.fileWrapper = try? FileWrapper.init(url: finalPath, options: .immediate)
            print(imagepicker.getUniqueFileName())
            //calculate new size. (-20 because I want to have a litle space on the right of picture)
            let newImageWidthObjQues = (self.objectiveQues.questionTV.bounds.size.width - 20 )
            let scaleQues = newImageWidthObjQues/EditedImg.size.width
            let newImageHeightObjQues = EditedImg.size.height * scaleQues
            //resize this
            //        attachment.bounds = CGRect.init(x: 10, y: 0, width: newImageWidth, height: newImageHeight-50)  /* Commented By YAshoda */
            attachmentObjQues.bounds = CGRect.init(x: 0, y: 0, width: self.objectiveQues.questionTV.bounds.size.width/1.05, height: self.objectiveQues.questionTV.bounds.size.width/1.05)//yasodha
            
            
            //put your NSTextAttachment into and attributedString
            let attStringObjQues = NSAttributedString(attachment:  attachmentObjQues)
            //add this attributed string to the current position.
            self.objectiveQues.questionTV.textStorage.insert(attStringObjQues, at:   self.objectiveQues.questionTV.selectedRange.location)
            //textView.text.append("\n")
            newSubView.removeFromSuperview()
            picker.dismiss(animated: true, completion: nil)
            self.objectiveQues.questionTV.becomeFirstResponder()
            let myAttributeObjQues = [ NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14) ]
            let myAttrStringObjQues = NSAttributedString(string: "\n", attributes:  myAttributeObjQues)
            var newPositionObjQues =    self.objectiveQues.questionTV.endOfDocument
            self.objectiveQues.questionTV.selectedTextRange =    objectiveQues.questionTV.textRange(from: newPositionObjQues, to: newPositionObjQues)
            self.objectiveQues.questionTV.textStorage.insert(myAttrStringObjQues, at:    self.objectiveQues.questionTV.selectedRange.location)
            newPositionObjQues =    self.objectiveQues.questionTV.endOfDocument
            self.objectiveQues.questionTV.selectedTextRange =    self.objectiveQues.questionTV.textRange(from: newPositionObjQues, to: newPositionObjQues)
            
            
            /*Added by yasodha 9/3/20202 ends here (Inline to question)*/
            
            
        }
        
        
        
    }
}


/*Added by yasodha ends here */




