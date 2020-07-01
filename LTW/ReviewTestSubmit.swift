//  ReviewTestSubmit.swift
//  LTW
//  Created by Ranjeet Raushan on 03/10/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView

protocol AddEditAnswerProtocol: class {
    func loadProperQues(index: Int,scheduledTestTime: Int, takenTestTime: Int)
}

class ReviewTestSubmit: UIViewController, NVActivityIndicatorViewable {
    @IBOutlet private weak var testTitleLabel: UILabel!
    @IBOutlet weak var testTimeLabel: UILabel!
    @IBOutlet weak var qATabelView:UITableView!
    @IBOutlet weak var exitBtn: UIButton!
    
    var params: [String: Any]!
    private var questionArray : [[String:Any]] = []
    var testTitle: String!
    var testTimeTaken: String!
    weak var delegate: AddEditAnswerProtocol?
    
    var timer: Timer?
    var scheduledTestTime = 0 // secs
    var takenTestTime = 0 //secs
    
    var contentSize : CGFloat!
    var html :NSAttributedString!
    
    var cache : NSCache<AnyObject, AnyObject>!
    var ansCache: NSCache<AnyObject, AnyObject>!
    var ansAttributedString : NSAttributedString!
    var questionLblHeight :CGFloat!
    var ansLblHeight :CGFloat!
    var refreshTableview =  0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Review Test"
        testTitleLabel.text = testTitle
        // testTimeLabel.text = ""
        print("Params count = \(params!)")
        questionArray =  params["AnswerDTOs"] as? [[String:Any]] ?? []
        startOtpTimer()
        self.navigationItem.hidesBackButton = true
        self.cache = NSCache()
        self.ansCache =  NSCache()
        
       
        qATabelView.rowHeight = UITableView.automaticDimension
        qATabelView.estimatedRowHeight = UITableView.automaticDimension

        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("**** View will appeare first *****")
//            startAnimating(type: .lineScale, color: UIColor.init(hex: "2DA9EC")) /* Added By Yashoda on 8th Jan 2020 */
//            qATabelView.dataSource = self
//            qATabelView.delegate =  self
//            qATabelView.reloadData(){
//            print(" ******* Loaded completed ******* ")
//
//            self.stopAnimating()
   //     }
      
    }
    
    
    
    @IBAction func submitAnswers(_ sender: UIButton) {
        if NetworkReachabilityManager()?.isReachable ?? false {
            params["TimeTaken"] = self.timeFormatted(self.takenTestTime)
            self.replaceImgPath() /* Added By Yashoda on 8th Jan 2020 */
            self.hitServer(params: params, endPoint: Endpoints.answerTestUrl  ,action: "SubmitAns", httpMethod: .post)
        }else {
            showMessage(bodyText: "No internet connection",theme: .warning)
        }
    }
    
    /*Added by yasodha to replace local img path to thumbnails path on 8th Jan 2020 - starts here*/
       
       func replaceImgPath() {
           
           let question = params["AnswerDTOs"] as? [[String:Any]] ?? [[String:Any]]()
           
           var myNewDictArray = [[String:Any]]()
           var queDict :[String : Any]!
           for dict  in  question {
               
               queDict = dict
               let studentAnswer = dict["StudentAnswer"] as! String
               //   print("dic:::::::::: \(dict)")
               var  replacedAns = String()
               if studentAnswer.contains("<p") || studentAnswer.contains("<!DOCTYPE") || studentAnswer.contains("<head><style")
               {
                   replacedAns =  replaceNames(str: studentAnswer, with:  uploadImagesToServer(str : studentAnswer))
                   print(replacedAns)
                   queDict.updateValue(replacedAns, forKey: "StudentAnswer")
                   
               }else
               {
               }
               
               print("dict \(queDict)")
               myNewDictArray.append(queDict)
               
           }
           
           params["AnswerDTOs"] =  myNewDictArray
           print( params["AnswerDTOs"])
           
           
           
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
           var result = String()
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
               imageurls.append(String( res.replacingOccurrences(of: "\"file://", with: "")))
              // print(res)
               // htmlStr.substring(with: (in: range)
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
       
       /* Added by yasodha to replace local img path to thumbnails path on 8th Jan 2020 - ends here */
    
    
    @IBAction func onExitBtnClick(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Are you sure, you want to Exit the Test? Your answers will not be saved.", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            for viewContoller in self.navigationController!.viewControllers as Array {
                 
                if  viewContoller .isKind(of: MyTestVC.self) {
                    self.navigationController?.popToViewController(viewContoller, animated: true)
                }
               
               
                
                /* Added By Yashoda on 19th Dec 2019 - starts here */
                if  viewContoller .isKind(of: NotificationVC.self) {
                self.navigationController?.popToViewController(viewContoller, animated: true)
                                      
                }
                /* Added By Yashoda on 19th Dec 2019 - ends here */
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        // below 3 lines are for iPAD
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        self.present(alert, animated: true, completion: nil)
        
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
        //        } else {
        //              invalidaiteTimer()
        //        }
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
        //        let seconds: Int = totalSeconds % 60
        //        let minutes: Int = (totalSeconds / 60) % 60
        //        return String(format: "%02d:%02d", minutes, seconds)
        
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
extension ReviewTestSubmit: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return questionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "qacell") as! ReviewTestSubmitCell
        
        
        
        let dict = questionArray[indexPath.row]
        cell.quesNoLabel.text = "Question:\(indexPath.row + 1)"
        cell.tag = indexPath.row
        //cell.questionLabel.text = dict["Question"] as? String
        
       // cell.questionLabel.attributedText = getAttributedString(htmlString: dict["Question"] as! String)
      //  cell.questionLabel.font = UIFont(name:"Roboto-Medium", size: 20.0)
        cell.marksLbl.text =  dict["QuestionMarks"] as! String
        
        if (self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil){
            // 2
            // Use cache
            print("Cached image used, no need to download it")
           cell.questionLabel.attributedText = self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? NSAttributedString
           cell.questionLabel.font  =  UIFont(name:"Roboto-Medium", size: 17.0)
           cell.questionLabel.textColor = UIColor.darkGray
            
           let questionLblHeight = DynamicLabelSize.height(text:   cell.questionLabel.attributedText! , font:  cell.questionLabel.font, width: self.view.frame.width)
                                                            
           cell.questionLblHeight.constant =  questionLblHeight
            
        }else{
       // cell.questionLabel.attributedText = getAttributedString(htmlString: dict["Question"] as! String)
        let str1 = dict["Question"] as! String
      //  var questionLblHeight :CGFloat
            
                loadMenu(category: str1,completion:{(recipe:NSAttributedString?) in
                                               DispatchQueue.main.async {
                                                
                                                if  cell.tag == indexPath.row {
                                                cell.questionLabel.attributedText =  recipe
                                                cell.questionLabel.font  =  UIFont(name:"Roboto-Medium", size: 17.0)
                                                cell.questionLabel.textColor = UIColor.darkGray


                                                self.cache.setObject(recipe!, forKey: (indexPath as NSIndexPath).row as AnyObject)

                                                   // sleep(2)
                                                let questionLblHeight = DynamicLabelSize.height(text:   cell.questionLabel.attributedText! , font:  cell.questionLabel.font, width: self.view.frame.width)

                                                 cell.questionLblHeight.constant =  questionLblHeight
                                             
                                                 let index = IndexPath(row: indexPath.row, section: 0)
                                                 tableView.reloadRows(at: [index], with: .automatic)

                                                
                                                }
                                                  // self.qATabelView.reloadData()
                                               }
                                           })

            
        }
        
//        print("EditAnswerBtn ::: \(cell.editAnswerBtn.frame.height)")
        
        if dict["StudentAnswer"] as? String == "" {
            
            cell.answerLblHeight.constant = 22.67
          
            cell.answerLabel.isHidden = true
            cell.editAnswerBtn.isHidden = true
            cell.writeAnswerBtn.isHidden = false
            cell.answerTitleLabel.text = "Not Answered"
            cell.answerTitleLabel.textColor = UIColor.red
        }else {
            
            
            cell.answerTitleLabel.text = "Answered"
            cell.answerTitleLabel.textColor = UIColor.black
            cell.answerLabel.isHidden = false
            
            
             if (self.ansCache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil){
                       // 2
                       // Use cache
                       print("Cached image used, no need to download it")
                        //  cell.answerLabel.attributedText  = self.ansCache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? NSAttributedString
                
                    
                     //Dynamic label height
                if  cell.tag == indexPath.row {
                
                      cell.answerLabel.attributedText  = self.ansCache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? NSAttributedString
                      cell.answerLabel.font =  UIFont(name:"Roboto-Medium", size: 17.0)
                      cell.answerLabel.textColor = UIColor.darkGray
                    
                    let labelHeight = DynamicLabelSize.height(text:  cell.answerLabel.attributedText! , font: cell.answerLabel.font , width: self.view.frame.width)
                     
                      cell.answerLblHeight.constant =  labelHeight
                    
                    
                }
                                             
                   }else{
                  // cell.questionLabel.attributedText = getAttributedString(htmlString: dict["Question"] as! String)
                            let studentAnswerStr = dict["StudentAnswer"] as? String
                            studentAnswer(category: studentAnswerStr!,completion:{(recipe:NSAttributedString?) in
                                                          DispatchQueue.main.async {
                                                            
                                                           if  cell.tag == indexPath.row {

                                                           cell.answerLabel.attributedText =  recipe
                                                           cell.answerLabel.font =  UIFont(name:"Roboto-Medium", size: 17.0)
                                                           cell.answerLabel.textColor = UIColor.darkGray
                                                           self.ansCache.setObject(recipe!, forKey: (indexPath as NSIndexPath).row as AnyObject)
                                                                
                                                            
                                                           // sleep(2)
                                                            
                                                            let labelHeight = DynamicLabelSize.height(text:  cell.answerLabel.attributedText! , font:cell.answerLabel.font, width: self.view.frame.width)
                                                              cell.answerLblHeight.constant =  labelHeight

//                                                            cell.ContainerView.sizeToFit()
//                                                            cell.ContainerView.layoutIfNeeded()
//                                                            cell.ContainerView.translatesAutoresizingMaskIntoConstraints = false

                                                            let index = IndexPath(row: indexPath.row, section: 0)
                                                            tableView.reloadRows(at: [index], with: .automatic)
                                                          //  self.refreshTableview = 1
                                                           }
                                                            
                                                            //relod
                                                          }
                                                      })
                
     
                
                       
                       
                   }
            
            
//             var labelHeight = DynamicLabelSize.height(text:  cell.answerLabel.attributedText! , font:UIFont.systemFont(ofSize: 14), width: self.view.frame.width)
//
//            if labelHeight == 0.0 || labelHeight < 22.67
//            {
//
//                labelHeight =  22.67
//            }
//
//            cell.answerLblHeight.constant =  labelHeight
                        
       /******************************************Commented by yasodha ******************************************/
                     
//            let str = dict["StudentAnswer"] as? String
//
//
//            if str!.contains("<p") || str!.contains("<!DOCTYPE") || str!.contains("<head><style")
//                       {
//
//                       cell.answerLabel.attributedText = getAttributedString(htmlString: str!)
//                        var labelHeight = DynamicLabelSize.height(text:  cell.answerLabel.attributedText! , font:UIFont.systemFont(ofSize: 14), width: view.frame.width)
//                       cell.answerLblHeight.constant =  labelHeight
//
//                      // cell.answerLabel.attributedText =  studentAnswerAttributedString
//
//
//                       }else
//                       {
//                        cell.answerLabel.text = dict["StudentAnswer"] as? String
//                        var labelHeight = DynamicLabelSize.height(text:  cell.answerLabel.attributedText! , font: UIFont.systemFont(ofSize: 14), width: view.frame.width)
//                        cell.answerLblHeight.constant =  labelHeight
//                       }
//
//
//
                          /******************************************Commented by yasodha ******************************************/
            
            
            /* yasodha added 27 Dec 2019 - ends here */
                     
            
            
            cell.editAnswerBtn.isHidden = false
            cell.writeAnswerBtn.isHidden = true
        }
        
        cell.writeAnswerBtn.tag = indexPath.row
        cell.writeAnswerBtn.addTarget(self, action: #selector(onWriteAnswerClicked), for: .touchUpInside)
        cell.editAnswerBtn.tag = indexPath.row
        cell.editAnswerBtn.addTarget(self, action: #selector(onEditAnswerClicked), for: .touchUpInside)
        

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                 
        return UITableView.automaticDimension
        
        }
     
    
    
    func loadMenu(category: String, completion:@escaping(NSAttributedString?)->Swift.Void)
    {
        
        
        //        let recipe = category.html2Attributed
        //        completion(recipe)
        
        DispatchQueue.global(qos: .background).async {
            
            let recipe = category.html2Attributed
              // let recipe = getAttributedString(htmlString:category)
          //  DispatchQueue.main.async {
                
                completion(recipe)
                
         //   }
            
        }
        
    }
    
      func studentAnswer(category: String, completion:@escaping(NSAttributedString?)->Swift.Void)
       {
           
           
           //        let recipe = category.html2Attributed
           //        completion(recipe)
           
           DispatchQueue.global(qos: .background).async {
               
         let recipe = category.html2Attributed
           // let recipe = getAttributedString(htmlString:category)
            
             //  DispatchQueue.main.async {
                   
                   completion(recipe)
                   
            //   }
               
           }
           
       }


    
    @objc func onWriteAnswerClicked(sender: UIButton) {
        print("onWriteAnswerClicked index = \(sender.tag)")
        delegate?.loadProperQues(index: sender.tag, scheduledTestTime: scheduledTestTime, takenTestTime: takenTestTime)
        navigationController?.popViewController(animated: true)
    }
    @objc func onEditAnswerClicked(sender: UIButton) {
        print("onEditAnswerClicked  = \(sender.tag)")
        delegate?.loadProperQues(index: sender.tag, scheduledTestTime: scheduledTestTime, takenTestTime: takenTestTime)
        navigationController?.popViewController(animated: true)
    }
}
extension ReviewTestSubmit: UITableViewDelegate {
    
}
extension ReviewTestSubmit {
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
                        
                        /*  Added by yasodha on 19/12/2019 - starts here    */
                        
                        //  showMessage(bodyText: msg,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 1))//yasodha
                        
                        var count = self.navigationController!.viewControllers.count
                        for viewContoller in self.navigationController!.viewControllers as Array {
                            
                            if  viewContoller .isKind(of: MyTestVC.self) {
                                    ModelData.shared.isAttandTV = false
                                 ModelData.shared.answerSubmitted = "Yes"
                                
                                self.navigationController?.popToViewController(viewContoller, animated: true)
                                count = 1
                            }
                            
                        }
                        if count != 1 {
                            /* Added by chandra on 3rd jan 2020 starts here  */
                            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "notification") as! NotificationVC
                            secondViewController.notificationclick = true
                            self.navigationController?.pushViewController(secondViewController, animated: true)
                            /* Added by chandra on 3rd jan 2020 ends here  */
                        }
                                          }
                }
                break
            case .failure(let error as NSError):
                print("MyError = \(error.localizedDescription)")
                break
            }
        }
    }
}

/* Added by yasodha to get image ranges in string on 8th Jan 2020 - starts here */
extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        var indices: [Index] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                    indices.append(range.lowerBound)
                    startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                        index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return indices
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                    result.append(range)
                    startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                        index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

extension UITableView {
    func reloadData(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData()})
        {_ in completion() }
    }
}




/* Added by yasodha to get image ranges in string on 8th Jan 2020 - ends here */
