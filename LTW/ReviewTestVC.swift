//  ReviewTestVC.swift
//  LTW
//  Created by manjunath Hindupur on 05/08/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView

class ReviewTestVC: UIViewController,NVActivityIndicatorViewable {
    
    @IBOutlet weak var marksLbl: UILabel!
    @IBOutlet weak var questionContainerHeightConst: NSLayoutConstraint!
    @IBOutlet private weak var testTitleLabel: UILabel!
    @IBOutlet weak var testTimeLabel: UILabel!
    @IBOutlet weak var btmIndxCollView: UICollectionView!
    @IBOutlet weak var questionNoLabel: UILabel!
    @IBOutlet weak var quesContainerView: NSLayoutConstraint!
    @IBOutlet weak var quesTV:
        UITextView! {
        didSet {setUpTextView(quesTV)}
    }
    @IBOutlet weak var yourAnswerContainerHeightConst: NSLayoutConstraint!
    @IBOutlet weak var yourAnsTV: UITextView!{
        didSet {setUpTextView(yourAnsTV)}
    }
    @IBOutlet weak var teacherAnsContainerHeightConst: NSLayoutConstraint!
    @IBOutlet weak var teacherAnsTV: UITextView!{
        didSet {setUpTextView(teacherAnsTV)}
    }
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    let userId = UserDefaults.standard.string(forKey: "userID")
    var testID: String!
    private var questionArrayJSON : [JSON] = []
    private var activeIndex = 0
    var testTitle: String = "Review Test"
    var scoreDisplay: String!   /* Added By Yashoda on 27th Jan 2020  */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.navigationController?.navigationBar) != nil {
            navigationController?.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        }
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = testTitle
        
        setContainerHeightBasedOnTextLenth(quesTV, containerCardView: quesContainerView)
      }
    /* Added By Yashoda on 27th Jan 2020 - starts  here */

    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(true)
             hitServer(params: [:], endPoint: Endpoints.reviewTestUrl  + testID + "/" + userId!, action: "getAnsForReview", httpMethod: .get)
       }

       override func viewDidAppear(_ animated: Bool) {
         navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)//yasodha
         navigationItem.rightBarButtonItem?.title = "Score:\(String(describing: scoreDisplay ?? ""))"//yasodha
       }
       private func setContainerHeightBasedOnTextLenth(_ textView: UITextView, maxHeight: CGFloat = 150.0,minHeight: CGFloat = 30, containerCardView: NSLayoutConstraint) {
        containerCardView.constant = min(maxHeight, max(minHeight, textView.contentSize.height))
        ModelData.shared.isClickReviewAnswer = true //added by yasodha 12/6/2020
    }
 
    
    private func setUpTextView(_ textView: UITextView){
        /* Updated By Ranjeet on 4th April 2020 - starts here */
         textView.backgroundColor = .white
        textView.textColor = .black
        textView.isEditable = false
        textView.isSelectable = false
        textView.layer.cornerRadius = 5// should be same as cardview radius
        textView.clipsToBounds = true
}
   /* Updated By Ranjeet on 4th April 2020 - ends here */
    private func setSizeOfAllTextView(){
  //      setContainerHeightBasedOnTextLenth(quesTV, containerCardView: quesContainerView)//commented by yasodha
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        startAnimating()//added by yasodha on 28th feb 2020
        print("Back Clicked")
        let indexPath = IndexPath(row: activeIndex - 1, section: 0)
        collectionView(btmIndxCollView, didSelectItemAt: indexPath)
        stopAnimating() //added by yasodha on 28th feb 2020
    }
    
    @IBAction func nextBtnClick(_ sender: UIButton) {
        //textAnswerTextView.resignFirstResponder()
        if sender.title(for: .normal) == "NEXT" {
            startAnimating()//added by yasodha on 28th feb 2020
            let indexPath = IndexPath(row: activeIndex + 1, section: 0)
            collectionView(btmIndxCollView, didSelectItemAt: indexPath)
            stopAnimating() //added by yasodha on 28th feb 2020
        }else {
            }
    }
    
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
     //   nextBtn.setTitle(title, for: .normal)   /* Commented  By Yashoda on 27th Jan 2020 */
          /* Added By Yashoda on 27th Jan 2020 - starts  here */
                if title == "LAST"{
                     nextBtn.isUserInteractionEnabled = false
                     nextBtn.isHidden = true
                }else{
                    nextBtn.isUserInteractionEnabled = true
                    nextBtn.isHidden = false
                    nextBtn.setTitle(title, for: .normal)
                    
                }
               /* Added By Yashoda on 27th Jan 2020 - ends  here */
    }
    
    
    
}
extension UITextView {
    func addCardEffect() {
        backgroundColor = UIColor.white
        clipsToBounds = false
        layer.shadowColor = UIColor.init(hex: "2DA9EC").cgColor
        layer.cornerRadius = 5
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 8
    }
}
extension ReviewTestVC {
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
                    if action == "getAnsForReview" {
                        // showMessage(bodyText: msg,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 1))
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
        testTitleLabel.text = json["ControlsData"]["TestInfo"]["TimeAllotted"].stringValue
        testTimeLabel.text =  json["ControlsData"]["TestInfo"]["TimeTaken"].stringValue
        questionArrayJSON = json["ControlsData"]["TestInfo"]["QuestionList"].arrayValue
        scoreDisplay =  json["ControlsData"]["TestInfo"]["score"].stringValue  /* Added By Yashoda on 27th Jan 2020  */

        
        if questionArrayJSON.count > 0 {
            loadData(index: 0)
            btmIndxCollView.reloadData()
            setNextPrevBtn()
        }
    }
}
extension ReviewTestVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionArrayJSON.count
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
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        activeIndex = indexPath.row
        self.btmIndxCollView.reloadData()
        loadData(index: indexPath.row)
        setNextPrevBtn()
    }
    
    private func setNextPrevBtn() {
        if activeIndex == questionArrayJSON.count - 1 {
            setNextBtn(to: "LAST")
        }else{
            setNextBtn(to: "NEXT")
        }
        if activeIndex == 0 {
            setBackBtn(active: false)
        }else {
            setBackBtn(active: true)
        }
        
    }
    
    
    private func loadData(index: Int) {
        let dict = questionArrayJSON[index].dictionaryValue
        questionNoLabel.text = "Question:\(index + 1)"
         marksLbl.text = dict["QuestionMarks"]?.stringValue//added by yaodha 20/3/2020
        
        
//        quesTV.text = dict["QuestionTitle"]?.stringValue
        /*Added by yasodha 10/3/2020 starts here */
        let tutorQues = dict["QuestionTitle"]?.stringValue
        if tutorQues!.contains("<p") || tutorQues!.contains("<!DOCTYPE") || tutorQues!.contains("<head><style")
        {
        // yourAnsTV.attributedText = getAttributedString(htmlString: yourAnswer!) / Commented By Yashoda on 10th Jan 2020 /
        quesTV.attributedText = tutorQues?.html2Attributed // Added By Yashoda on 10th Jan 2020 /

        questionContainerHeightConst.constant = (tutorQues?.html2Attributed!.boundingRect(with: CGSize(width: self.view.frame.width - 40, height: 10000), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height)!
        quesTV.isScrollEnabled = false//uncommented by yasodha
        }else
        {
        //quesTV.text = dict["QuestionTitle"]?.stringValue //commented by yasodha
               quesTV.attributedText = getAttributedString(htmlString: tutorQues!)
            
        setContainerHeightBasedOnTextLenth(quesTV, containerCardView: questionContainerHeightConst) //added by veeresh on 7/2/2020

        }


        /*Added by yasodha 10/3/2020 ends here */
        /*  yasodha added 31 Dec 2019 for inline data - starts here */
        let yourAnswer = dict["YourAnswer"]?.stringValue
        if yourAnswer!.contains("<p") || yourAnswer!.contains("<!DOCTYPE") || yourAnswer!.contains("<head><style")
        {
          //  yourAnsTV.attributedText = getAttributedString(htmlString: yourAnswer!) /* Commented By Yashoda on 10th Jan 2020 */
              yourAnsTV.attributedText = yourAnswer?.html2Attributed /* Added By Yashoda on 10th Jan 2020 */
               /* added by veeresh on 7/02/2020 */
            yourAnswerContainerHeightConst.constant = (yourAnswer?.html2Attributed!.boundingRect(with: CGSize(width: self.view.frame.width - 40, height: 10000), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height)!
            yourAnsTV.isScrollEnabled = false
            /* added by veeresh on 7/02/2020 */
        }else
        {
           // yourAnsTV.text = dict["YourAnswer"]?.stringValue
             yourAnsTV.attributedText = getAttributedString(htmlString: yourAnswer!)
            setContainerHeightBasedOnTextLenth(yourAnsTV, containerCardView: yourAnswerContainerHeightConst) //added by veeresh on 7/2/2020
            
        }
        
        let teacherAns = dict["TutorAnswer"]?.stringValue
        if teacherAns!.contains("<p") || teacherAns!.contains("<!DOCTYPE") || teacherAns!.contains("<head><style")
        {
           // teacherAnsTV.attributedText = getAttributedString(htmlString: teacherAns!) /* Commented By Yashoda on 10th Jan 2020 */
              teacherAnsTV.attributedText = teacherAns?.html2Attributed /* Added By Yashoda on 10th Jan 2020 */
             /* added by veeresh on 7/02/2020 */
            teacherAnsContainerHeightConst.constant = (teacherAns?.html2Attributed!.boundingRect(with: CGSize(width: self.view.frame.width - 40, height: 10000), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height)!
            teacherAnsTV.isScrollEnabled = false
              /* added by veeresh on 7/02/2020 */
        }else
        {
           // teacherAnsTV.text = dict["TutorAnswer"]?.stringValue
            teacherAnsTV.attributedText = getAttributedString(htmlString: teacherAns!)
            setContainerHeightBasedOnTextLenth(teacherAnsTV, containerCardView: teacherAnsContainerHeightConst) // added by veeres on 7/2/2020
        }
        
        
        /* yasodha added 31 Dec 2019 for inline data - ends here */
              setSizeOfAllTextView()
        
    }
}

