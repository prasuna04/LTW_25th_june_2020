//  AskQuestionWithTextVC.swift
//  LTW
//  Created by Ranjeet Raushan on 26/04/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import SwiftMessages
import NVActivityIndicatorView

// Tags Creation Related
 fileprivate let tagsField = WSTagsField()

//let subjects = UserDefaults.standard.array(forKey: "subjectArray") as! [String] // Category or Subject
//let sub_Subjects = UserDefaults.standard.array(forKey: "sub_SubjectArray1") as! [String] // Sub_Category or Sub_Subject

/* Dont delete above two lines related to subjects & sub_Subjects declaration because this both two things declared globally in CreateNewTestVC by Mukesh , here why we should not delete these two parameters  because we keeping it for future understanding reference */

class AskQuestionWithTextVC: UIViewController, NVActivityIndicatorViewable {
    @IBOutlet weak var scrollVw: UIScrollView!
    @IBOutlet weak var contentVw: UIView!
    @IBOutlet weak var askQstnDescrptonTV: UITextView!
    @IBOutlet weak var catBtn: UIButton!
    @IBOutlet weak var subCatBtn: UIButton!
    @IBOutlet weak var tagListView: TagListView!
  
    @IBOutlet fileprivate weak var tagsView: UIView!
    
    @IBOutlet weak var submitBtn: UIButton!
    {
        didSet{
            submitBtn.layer.cornerRadius = submitBtn.frame.height / 12
        }
    }
    // Screen width.
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    var isSubjectSelected = false
    var userID: String!
    var subjectId: Int!
    var sub_subjectId: Int!
    var questions: String!
    var question_html: String!
    var tags: String!
    var searchTags: String!
    var questionID: String! // one way (questionID)
    
    var question:String? = nil // Added By Yashoda on 16th Dec 2019
    
//    let textViewPlaceHolder =  "Ask your Question Here" //Text View PlaceHolder Handling /* Commented By Yashoda on 16th Dec 2019 */
      var  textViewPlaceHolder =  "Ask your Question Here" //Text View PlaceHolder Handling /* Added By Yashoda on 16th Dec 2019 */
    
    // grades Related
    var arrTagList : [String] = []
    var arrTag : [Int] = []
    var selectArr :[String] = []
    var isEditMode: Bool = false
    
    var refreshHome: (() -> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagsField.removeTags()

        /*Added By Yashoda on 16th Dec 2019 - starts here */
        question = UserDefaults.standard.string(forKey: "question")
        askQstnDescrptonTV.delegate = self
        if question == nil || question!.count == 0 {
          askQstnDescrptonTV.text = textViewPlaceHolder
        }else{
            
              askQstnDescrptonTV.text =  question!
        }
         UserDefaults.standard.removeObject(forKey: "question")
       /*Added By Yashoda on 16th Dec 2019 - ends here */
        
        /* Text View PlaceHolder Handling - From here */
        askQstnDescrptonTV.delegate = self
//        askQstnDescrptonTV.text = textViewPlaceHolder /* Commented By Yashoda on 21st Dec 2019 */
         /* Text View PlaceHolder Handling - Till here */

        userID =  UserDefaults.standard.string(forKey: "userID")

        // grades Realated
        tagListView.delegate = self
        arrTagList = ["1st", "2nd", "3rd","4th", "5th","6th","7th","8th","9th", "10th","11th","12th", "UnderGraduates","Graduates"]
        arrTag = Array(repeating: 0, count: arrTagList.count)
        
        
        // Tags Creation Related
        
        tagsField.frame = tagsView.bounds
        tagsView.addSubview(tagsField)
        tagsField.cornerRadius = 12.0
        tagsField.spaceBetweenLines = 10
        tagsField.spaceBetweenTags = 10
        tagsField.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        tagsField.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tagsField.placeholder = "Add Tags like School name, Author name, Publisher etc."
        tagsField.placeholderColor = .lightGray
        tagsField.placeholderAlwaysVisible = false
        tagsField.returnKeyType = .send
        tagsField.delimiter = ""
        
        
        tagsField.onDidAddTag = { field, tag in
            print("DidAddTag", tag.text)
        }
        
        tagsField.onDidRemoveTag = { field, tag in
            print("DidRemoveTag", tag.text)
        }
        
        tagsField.onDidChangeText = { _, text in
            print("DidChangeText")
        }
        
        tagsField.onDidChangeHeightTo = { _, height in
            print("HeightTo", height)
        }
        
        tagsField.onValidateTag = { tag, tags in
            // custom validations, called before tag is added to tags list
            return tag.text != "#" && !tags.contains(where: { $0.text.uppercased() == tag.text.uppercased() })
        }
        
        if !isEditMode {
            //add code goes here
          
        }else {
            //Edit code goes here
            askQstnDescrptonTV.textColor = UIColor.black
            /*  Added By 27th March 2020 - starts here */
            if #available(iOS 13.0, *) {
                askQstnDescrptonTV.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
            }
            /*  Added By 27th March 2020 - ends here */
               submitBtn.setTitle("Update", for: .normal)
            
            if currentReachabilityStatus != .notReachable {
                hitServer(params: [:], action: "contntQuestnEditByGet", httpMethod: .get, endPoint: Endpoints.editUserAskedQuestionGetEndPoint  + "/" + (self.questionID!))
            } else {
                showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
                })
            }
        }
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                   //getting data from Homeview
                    question = UserDefaults.standard.string(forKey: "question") /* Added by yasodha on 17/12/2019 */
             guard let navigationController = navigationController else { return }
              navigationController.view.backgroundColor = UIColor.init(hex:"2DA9EC")
              if (self.navigationController?.navigationBar) != nil {
                  navigationController.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
              }
              self.navigationController?.navigationBar.topItem?.title = " "
              navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if isEditMode {
             navigationItem.title = "Edit Question"
        }else {
             navigationItem.title = "Ask a Question"
        }
    }
    
    // Tags Creation Related
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tagsField.frame = tagsView.bounds
    }

 // Category or Subject
    @IBAction func onCatBtnClick(_ sender: UIButton) {
        let controller = ArrayChoiceTableViewController(subjects){[unowned self] (selectedSubject) in
            self.catBtn.setTitle(String(describing: selectedSubject ), for: .normal)
            self.catBtn.setTitleColor(UIColor.black, for: .normal)
            if #available(iOS 13.0, *) {
                self.catBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            self.isSubjectSelected = true
            self.onSubCatBtnClick(self.subCatBtn)
        }
         controller.preferredContentSize = CGSize(width: self.screenWidth - 20, height: 200)
        showPopup(controller, sourceView: sender)
    }
    var subSubjectListData: [String] = sub_Subjects
    // Sub_Category or Sub_ Subject
    @IBAction func onSubCatBtnClick(_ sender: UIButton) {
        subSubjectListData = []
        guard let selectCategory = catBtn.title(for: .normal), selectCategory != "Select Category" else{
                  showMessage(bodyText: "Plaese select category first",theme: .warning)
                  return
              }
        let subIndex = subjects.firstIndex(where: {$0 == catBtn.title(for: .normal)!})!
        switch subIndex {
        case 0:
            subSubjectListData = UserDefaults.standard.array(forKey: "sub_SubjectArray1") as! [String]
        case 1:
            subSubjectListData = UserDefaults.standard.array(forKey: "sub_SubjectArray2") as! [String]
        case 2:
            subSubjectListData = UserDefaults.standard.array(forKey: "sub_SubjectArray3") as! [String]
        case 3:
            subSubjectListData = UserDefaults.standard.array(forKey: "sub_SubjectArray4") as! [String]
            
        default:
            break
        }
        
        if isSubjectSelected {
            self.subCatBtn.setTitle(String(describing: subSubjectListData[0] ), for: .normal)
            self.subCatBtn.setTitleColor(UIColor.black, for: .normal)
            if #available(iOS 13.0, *) {
                self.subCatBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
            isSubjectSelected = false
        }
        
        let controller = ArrayChoiceTableViewController(subSubjectListData){[unowned self ](selectedSubSubject) in
            self.subCatBtn.setTitle(String(describing: selectedSubSubject ), for: .normal)
            self.subCatBtn.setTitleColor(UIColor.black, for: .normal)
            if #available(iOS 13.0, *) {
                self.subCatBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
        }
        controller.preferredContentSize =  CGSize(width: self.screenWidth - 20, height: self.screenHeight / 3)
        showPopup(controller, sourceView: sender)
    }
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    @IBAction func onSeletGradesBtnOrDropDownClick(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TagListVC") as! TagListVC
        vc.delegate = self
        vc.arrTag = arrTag
        vc.tag = 0
        vc.arrTagList = arrTagList
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onSubmitBtnClick(_ sender: UIButton) {
        validateFields()
    }
    
    private func validateFields() {
        
        guard let askQstnDsrn = askQstnDescrptonTV.text,!askQstnDsrn.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showMessage(bodyText: "Enter A Question",theme: .warning)
            return
        }
        if askQstnDsrn == textViewPlaceHolder {
            showMessage(bodyText: "Enter A Question",theme: .warning)
            return
        }
        guard let askQstnDsrn1 = askQstnDescrptonTV.text, askQstnDsrn1 != "Question_html" else{
            showMessage(bodyText: "Enter A Question",theme: .warning)
            return
        }

        guard let selectCategory = catBtn.title(for: .normal), selectCategory != "Select Category" else{
            showMessage(bodyText: "Enter Subject and category",theme: .warning)
            return
        }

        guard let selectSub_Category = subCatBtn.title(for: .normal), selectSub_Category != "Select Sub Category" else{
            showMessage(bodyText: "Please select sub_category",theme: .warning)
            return
        }
        guard !selectArr.isEmpty else {
            showMessage(bodyText: "Select One or More grades",theme: .warning)
            return
        }
        
        var tagString = ""
        for tags in selectArr{
         tagString += tags + ","
        }
        
        if !tagString.isEmpty{
        tagString.removeLast()
        }
       /* Create(Search) tags validation starts here  - Don't delete it because in future might same requirement comes to change */
//        guard !tagsField.tags.map({$0.text}).isEmpty else {
//            showMessage(bodyText: "Please enter tags",theme: .warning)
//            return
//        }
       /* Create(Search) tags validation ends here - Don't delete it because in future might same requirement comes to change  */
        
        var tagSearchString = ""
        for searchTags in tagsField.tags.map({$0.text}){
            tagSearchString += searchTags + ","
        }
        if !tagSearchString.isEmpty{
        tagSearchString.removeLast()
        }
        print("List of Tags Strings:", tagsField.tags.map({$0.text}))
        let params:[String:Any] = ["UserID": UserDefaults.standard.string(forKey: "userID")!,
                                   "Question_html": askQstnDsrn1,
                                   "Questions": askQstnDsrn,
                                   "SubjectName": selectCategory,
                                   "Sub_SubjectName": selectSub_Category,
                                   "SubjectID":(
                                    subjects.firstIndex(where: {$0 == catBtn.title(for: .normal)!})! + 1),
                                   "Sub_SubjectID": getSubSubjectID(subSubjectName: subCatBtn.title(for: .normal)! ) ?? 0 ,
                                   "Tags": tagString ,
                                   "SearchTags": tagSearchString]
        callService(params: params)
    }
    
    private func callService(params: [String: Any]){
        if currentReachabilityStatus != .notReachable {
            if !isEditMode {
                       //add code goes here
                     self.hitServer(params:params ,action: "Ask Question", httpMethod: .post, endPoint: Endpoints.askQstnEndPoint )
                   }else {
                       //Edit code goes here
                      var param1: [String:Any]  = params
                      param1["QuestionID"] = self.questionID!
                      self.hitServer(params:param1 ,action: "Ask Question", httpMethod: .post, endPoint: Endpoints.editUserAskedQuestionPostEndPoint )
                   }
            
            
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
                self.callService(params: params)
            })
        }
    }
    private func hitServer(params: [String:Any],action: String, httpMethod: HTTPMethod, endPoint: String) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){ result in
             self.stopAnimating()
            switch result {
            case let .success(json,requestType):
                
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }else {
                    tagsField.removeTags()
                    if action == "Ask Question" {
                       // self.navigationController?.popViewController(animated: true) /* Don't delete this line, future might */
                                                                                       /* reuse when need to redirect to Home Screen */
                        let myContent = self.storyboard?.instantiateViewController(withIdentifier: "contntqstinsasked") as! ContentQuestionsAskedVC
                        myContent.userID = self.userID
                        self.navigationController?.pushViewController(myContent, animated: true)
                        self.refreshHome?()
                   // showMessage(bodyText:msg ,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.01)) /* Don't delete this line, future might */
                                                                                                         /* reuse when need to implement this functionality again */
                    }
                    else if action == "contntQuestnEditByGet" {
                        self.parseNDispayListEditGetData(json: json["ControlsData"]["lsv_questiondetails"], requestType: requestType)
                    }
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    private func parseNDispayListEditGetData(json: JSON,requestType: String){
       askQstnDescrptonTV.text = json["Question_html"].string//Questions
       catBtn.setTitle("", for: .normal)
       subCatBtn.setTitle("", for: .normal)
        
        let tagsString = json["Tags"].stringValue
        let tagsArray = tagsString.split(separator: ",")
        for tag in tagsArray {
            
            tagListView.addTag(String(tag) )
                   selectArr.append(String(tag))
                   //arrTag[index] = 1
                  /* disable the tags which is already selected while sign up */
                  for i in 0..<arrTagList.count {
                      
                      for j in 0..<selectArr.count {
                          
                          if selectArr[j] == arrTagList[i]{
                              
                              arrTag[i] = 1
                              break
                          }
                      }
                      
                  }
                  print(arrTag)
            /* disable the tags which is already selected while sign up - ends here */

            
        }
        let stringJSON = json["SearchTags"].stringValue
        let _json = JSON.init(parseJSON: stringJSON)
        let searchTag = _json.arrayValue
       
        /* Commented By Dk on 26th April 2020 - starts here */
//        for tag in searchTag {
//       // print("searchTag = \(searchTag)")
//            tagsField.addTag(tag.stringValue)
//        }
        /* Commented By Dk on 26th April 2020 - starts here */
        
       /* Updated By Dk on 26th April 2020 - starts here */
        for tag in searchTag {
            if tag.stringValue != "" {
                tagsField.addTag(tag.stringValue)
            }
        }
        /* Updated By Dk on 26th April 2020 - starts here */
        
        let subjetID = json["SubjectID"].intValue
        catBtn.setTitle(subjects[subjetID-1], for: .normal)
        let sub_SubjectID = json["Sub_SubjectID"].intValue
        let subSubjectName = getSubjectName(with: sub_SubjectID)
        subCatBtn.setTitle(subSubjectName, for: .normal)
    }
    
}


/* grades Related - From Here */
extension AskQuestionWithTextVC : TagListVCDelegate {
    func setTagItems(strName: String, index: Int ,Tag:Int) {
        tagListView.addTag(strName)
        selectArr.append(strName)
        arrTag[index] = 1
    }
}

extension AskQuestionWithTextVC : TagListViewDelegate {
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
        let index = arrTagList.firstIndex(of: title)
        selectArr.remove(at: selectArr.index(of: title)!)
        arrTag[index!] = 0
     }
}
/* grades Related - Till Here */



/* Text View PlaceHolder Handling - From here */
extension AskQuestionWithTextVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
        }
                    textView.textColor = UIColor.black
        /*  Added By Ranjeet on 27th March 2020 - starts here */
        if #available(iOS 13.0, *) {
            textView.textColor = UIColor.label
        } else {
            // Fallback on earlier versions
        }
        /*  Added By Ranjeet on 27th March 2020 - ends here */
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


 /*
 Future Reference:
 https://stackoverflow.com/questions/27652227/text-view-uitextview-placeholder-swift   -  [ Text View (UITextView) Placeholder Swift ]
 */

