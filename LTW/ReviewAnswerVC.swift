// ReviewAnswerVC.swift
// Task1
// Created by vaayoo on 16/11/19.
// Copyright © 2019 Vaayoo. All rights reserved.

import UIKit
import Alamofire
import NVActivityIndicatorView

class ReviewAnswerVC: UIViewController , UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,NVActivityIndicatorViewable {
    
    //to store the objects of answeModel for numer of data present in the response
    var answerModel = [AnswerModel]()
    private var model : model! //this model is used to store the data recived from the previous view controller
    var models : model {
        get {
            return model
        } set {
            model = newValue
        }
    }
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var enterScoreTF: UITextField!
     @IBOutlet weak var marksLbl: UILabel!//yasodha
     var totalMarksCout :Double!//yasodha
    /*Added by yasodha 7/4/2020 starts here */
     var isNotificationOn = false
     var testIdFrmNotification:String!
     var userIDFrmNotification:String!
    
     /*Added by yasodha 7/4/2020 eneds here */
    
    

    
    @IBAction func onSubmitPressed(_ sender: UIButton) {
        if !enterScoreTF.text!.isEmpty{
            let submitScore : Double = Double(enterScoreTF.text!)! //getting score value from the text Field
            if submitScore >= 0 && submitScore <= totalMarksCout { // checking for the submitted score in range
                //this is the url for passing the submitted score
                /*Added by yasodha on 4/5/2020 starts here  */
                 var url :URL!
                               if isNotificationOn == true{
                                   url = URL(string: Endpoints.ReviewTestScoreEndPoint+"\(String(describing: testIdFrmNotification!))/\(String(describing: userIDFrmNotification!))?score=\(submitScore)")!
                                   
                               }else{
                                   url = URL(string: Endpoints.ReviewTestScoreEndPoint+"\(models.testId)/\(models.UserId)?score=\(submitScore)")!
                                   
                               }
                               /*Added by yasodha 4/5/2020 ends here */
                
                
               // let url = URL(string: Endpoints.ReviewTestScoreEndPoint+"\(models.testId)/\(models.UserId)?score=\(submitScore)")  /* Updated  By Veeresh on 17th April  2020 */
                print(url!) //printing the url
                //to submit the score requesting the api with submitted score
                Alamofire.request(url!).responseJSON{ response in
                    let result = response.result.value as! Dictionary<String,Any>
                    let temp = result["message"] as? String
                    if temp=="Score updated successfully." {
                        self.navigationController?.popViewController(animated: true) //desmissing the "test Answer" page
                    }
                }
            }
            else {
                //**************THIS CHANGES ARE MADE HERE FOR SHAKING THE SUBMIT BUTTON*****************
                submitBtn.shake(duration: 0.5, values: [-12.0, 12.0, -12.0, 12.0, -6.0, 6.0, -3.0, 3.0, 0.0])
                enterScoreTF.text = nil //if the entered answer is not in given range clearing the textField for new value
            }
        }
    }
    //assining the table cell count as array count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answerModel.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cells=tableView.dequeueReusableCell(withIdentifier: "AnswersCell", for: indexPath) as? AnswersCell {
            let temp = answerModel[indexPath.row]
              cells.updateLable(indexPath.row,temp.questionTitle,temp.yourAnswer,temp.questionMarks) //added by yasodha 20/3/2020
            return cells
        }
        return UITableViewCell()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var testTitle: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterScoreTF.delegate = self //assigning a enterScoreTF delegate to self
        enterScoreTF.maxLength = 9//added by yasodha
        //for making back button nil to show only the back symbol
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        fetchData() // calling the function for fetching the data from the API
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "REVIEW ANSWER" //assigning the navigation bar title with value
        tableView.delegate=self
        tableView.dataSource=self
        // the below lines are used to open and close keyboard along with the view upside
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //for showing the keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    //for hideing the keyboard
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
   /************************************Commented by yasodha 24/4/2020 **********************************/
    
//    //it is a delegate function which is written to accept only the decimal value in the textField
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField.text != "" || string != "" {
//            let res = (textField.text ?? "") + string
//            return Double(res) != nil
//        }
//        return true
//    }
     /************************************Commented by yasodha 24/4/2020 **********************************/
    
    
    /*Added by yasodha on 24/4/2020 starts here*/
        //For restricted decimal placeses to two
         func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
               
               print("Text string isshouldChangeCharactersIn :: \(textField.text)")
        
               if string.isEmpty { return true }
                
           
            
               let currentText = textField.text ?? ""
               let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
               
               // Use our string extensions to check if the string is a valid double and
               // only has the specified amount of decimal places.
               return replacementText.isValidDouble(maxDecimalPlaces: 2)
            
               
           }
        
    /*Added by yasodha on 24/4/2020 ends here */

    
    
    
    //---------------the below is to request api and store response-----------------------------------
    func fetchData() {
         startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
      //  let url = URL(string: Endpoints.reviewTestUrl+"\(models.testId)/\(models.UserId)") /* Added By Veeresh on 26th Dec 2019 *///commented by yasodha
           /*Added by yasodha 7/4/2020 starts here */
             var url: URL!
             if isNotificationOn == true{
                 url = URL(string: Endpoints.reviewTestUrl+"\(String(describing: testIdFrmNotification!))/\(String(describing: userIDFrmNotification!))")
                 
             }else{
                 url = URL(string: Endpoints.reviewTestUrl+"\(models.testId)/\(models.UserId)")
                 
             }
             /*Added by yasodha 7/4/2020 ends here */
             
        
        Alamofire.request(url!).responseJSON{response in
            self.stopAnimating()
            let result = response.result.value as? Dictionary<String,Any>
            print("\(String(describing: result!["message"])) and \(String(describing: result!["error"]))") //printing value of response
            let message=result!["message"] as? String
            let error=result!["error"] as? Bool
            if message=="Success" && error! == false{
                let ControlsData = result!["ControlsData"] as? Dictionary<String,Any>
                let TestInfo = ControlsData!["TestInfo"] as? Dictionary<String,Any>
                //print(TestInfo)
                self.testTitle.text = (TestInfo!["TestTitle"] as? String)!
                let QuestionList = TestInfo!["QuestionList"] as? [Dictionary<String,Any>]
                //print(QuestionList)
                self.totalMarksCout = 0
                for i in QuestionList!
                {
                    print("marks::::\(String(describing: i["QuestionMarks"]!))")
                    let marksDouble : Double = Double((String(describing: i["QuestionMarks"]!)))!//added by yasodha
                    self.totalMarksCout = marksDouble + self.totalMarksCout
                    
                    // creating the object for as number of data present in the response
                    self.answerModel.append(AnswerModel(questionId: i["QuestionID"] as? String ?? "", questionTitle: i["QuestionTitle"] as? String ?? "", yourAnswer: i["YourAnswer"] as? String ?? "",questionMarks :(String(describing: i["QuestionMarks"]!)) ))//Added by yasodha 20/3/2020
                }
                //  let str = "/" + String(describing: self.totalMarksCout!)//added by yasodha
                 // self.marksLbl.text =  str//added by yasodha
                if self.totalMarksCout!.isInt == true {
                    self.marksLbl.text = String(format:"%.0f", self.totalMarksCout!)//It wont show decimal places
                    
                }else{
                    self.marksLbl.text = String(format:"%.2f", self.totalMarksCout!)//It will show two decimal places
                    
                }
            }
            self.tableView.reloadData()
        }
    }
}

/*
 ********************
 ADD THIS CHANGE IN REAL PROJECT
 THE BELOW CODE
 CHECK WEATHER THEY HAVE SAME EXTENSION AS THIS OR NOT
 */
extension UIView {
    func shake(duration: TimeInterval = 0.5, values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        
        // Swift 4.2 and above
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        // Swift 4.1 and below
        // animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        
        animation.duration = duration // You can set fix duration
        animation.values = values // You can set fix values here also
        self.layer.add(animation, forKey: "shake")
    }
}
