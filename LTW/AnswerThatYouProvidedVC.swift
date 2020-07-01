//  AnswerThatYouProvidedVC.swift
//  LTW
//  Created by Ranjeet Raushan on 17/12/19.
//  Copyright © 2019 vaayoo. All rights reserved.


import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import NVActivityIndicatorView

enum PersonTypeForAnswerThatYouProvidedVC : Int {
    case Student = 1 // why i am using 1 here because another two person type will automatically take 2 & 3 and if i  will not put 1 here  it will consider 0 automatically and another two person type will become 1 and 2 and we will get wrong information.
    case Parent
    case Teacher
}

class AnswerThatYouProvidedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
 let subjects = UserDefaults.standard.array(forKey: "subjectArray") as! [String]
    var catagery:Int!
    @IBOutlet weak var tableView: UITableView!
    

    var answrsThatUProvidedList:  Array<JSON> = []
    var refreshControl = UIRefreshControl() // pull to refresh
    var userID: String!
    var answerID: String!
    var questionID: String!
    var deletedIndexPath: IndexPath?
     
    override func viewDidLoad() {
        super.viewDidLoad()
        userID =  UserDefaults.standard.string(forKey: "userID")
        tableView.delegate = self
        tableView.dataSource = self
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        /* Don't Delete below single line commented code for future reference */
      
        // tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0) /* Programatically you can give constraints like this , actually  i already given constraints from storyboard so here it is not required */
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(AnswerThatYouProvidedVC.pullToRefreshHitApiForAnswersThatUProvided),for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*Added by yasodha on 12/1/2020 to get previous-viewcontroller*/
        if self.navigationController?.viewControllers.previous is PersonalProfileVC {
            if (self.navigationController?.navigationBar) != nil {
                navigationController?.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
                navigationController?.view.backgroundColor = UIColor.init(hex: "2DA9EC")// to resolve black bar problem appears on navigation bar when pushing view controller
            }
            self.navigationController?.navigationBar.topItem?.title = " "
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationItem.title = "User Answered"

        if currentReachabilityStatus != .notReachable {
        hitServer(params: [:], endPoint: Endpoints.profileUserAnsweredQuestions + ((UserDefaults.standard.string(forKey: "personalprofile"))!), action: "ContntAskdQstn", httpMethod: .get)

        } else {
        showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
        })
        }

        } else {

        /* Ranjeet Code - starts here */
               if currentReachabilityStatus != .notReachable {
                   hitServer(params: [:], endPoint: Endpoints.answrsThatuProvidedEndPoint + (self.userID!),  action: "AnswersThatYouProvided", httpMethod: .get)
               } else {
                   showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
                   })
               }
               /* Ranjeet Code - ends here */
        }
        /*Added by yasodha on 12/1/2020 to get previous-viewcontroller*/
       
    }
    
    //pull to refresh
    @objc func pullToRefreshHitApiForAnswersThatUProvided() {
         refreshControl.endRefreshing()  /* Added By Ranjeet  */
        if self.navigationController?.viewControllers.previous is PersonalProfileVC {
            
            if currentReachabilityStatus != .notReachable {
                //    hitServer(params: [:], endPoint: Endpoints.profileUserAnsweredQuestions + (self.userID!),  action: "ContntAskdQstn", httpMethod: .get)
                hitServer(params: [:], endPoint: Endpoints.profileUserAnsweredQuestions + ((UserDefaults.standard.string(forKey: "personalprofile"))!),  action: "ContntAskdQstn", httpMethod: .get)
                
            } else {
                showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
                  
                })
                self.pullToRefreshHitApiForAnswersThatUProvided()
                self.refreshControl.endRefreshing()
            }
            
        } else {
                /* Added By Ranjeet - starts here */
            if currentReachabilityStatus != .notReachable {
                hitServer(params: [:], endPoint: Endpoints.answrsThatuProvidedEndPoint + (self.userID!),  action: "AnswersThatYouProvided", httpMethod: .get)
            } else {
                showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
                })
                self.pullToRefreshHitApiForAnswersThatUProvided()
                self.refreshControl.endRefreshing()
            }
                /* Added By Ranjeet - ends here */
        }
    }
    
    override func viewDidLayoutSubviews() {
     if self.navigationController?.viewControllers.previous is PersonalProfileVC {
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
}
    // delete functionality
    @objc func deleteBtnSelected(sender: UIButton){
        sender.springAnimation(btn: sender)// add by chandra for spring animation to the button
                      
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
            let refreshAlert = UIAlertController(title: "Delete", message: "Are you sure, you want to delete the question?", preferredStyle: UIAlertController.Style.alert)
                  refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                  print("Delete Button Clicked")
                  let index = sender.tag
                  self.answerID = self.answrsThatUProvidedList[index]["AnswerID"].stringValue
                  self.deletedIndexPath = IndexPath(item: sender.tag, section: 0)
                       let isIndexValid = self.answrsThatUProvidedList.indices.contains(self.deletedIndexPath!.row)
                  if self.currentReachabilityStatus != .notReachable {
                      if isIndexValid{
                      self.answerID =  self.answrsThatUProvidedList[self.deletedIndexPath!.row]["AnswerID"].stringValue
                      self.hitServerForDeleteAnswerThatYouProvided(params: [:], endPoint: Endpoints.deleteanswerThatUProvdedEndPoint + (self.answerID!) + "/" + (self.userID!) ,action: "DeleteAnswerThatYouProvided", httpMethod: .get)
                      }
                  } else {
                      showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
                      })
                  }
                      }))
                  refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in
                  }))
            self.present(refreshAlert, animated: true, completion: nil)
        })
        
      
        
    }
    
    @objc func editBtnSelected(sender: UIButton){
        sender.springAnimation(btn: sender)// add by chandra for spring animation to the button
               
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
            let dict = self.answrsThatUProvidedList[sender.tag]
                  let questions = dict["Questions"].stringValue
                  let answers = dict["Answers"].stringValue
            let editContntAnswr = self.storyboard?.instantiateViewController(withIdentifier: "editcontentanswer") as! EditContentAnswerVC
            self.questionID = dict["QuestionID"].stringValue
            self.answerID = dict["AnswerID"].stringValue
                  editContntAnswr.answerId = self.answerID
                  editContntAnswr.questionID = self.questionID
                  editContntAnswr.questions = questions
                  editContntAnswr.answers = answers
            self.navigationController?.pushViewController(editContntAnswr, animated: true)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answrsThatUProvidedList.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AnswerThatYouProvidedCell
        var answrsProvistList: JSON
        answrsProvistList = answrsThatUProvidedList[indexPath.row]
        
        /*Added by yasodha on 12/1/2020 to get previous-viewcontroller - starts here */
        if self.navigationController?.viewControllers.previous is PersonalProfileVC {
            cell.editBtn.isHidden = true
            cell.deleteBtn.isHidden =  true
            
        } else {
            
            cell.editBtn.isHidden = false
            cell.deleteBtn.isHidden = false
            
        }
        /*Added by yasodha on 12/1/2020 to get previous-viewcontroller - ends here */
          cell.subjctLbl.font = UIFont.boldSystemFont(ofSize: 13.0)/* I tried to put
          "Roboto-Bold" , but it was not working properly so let it be boldSystemFont only to get the bold text  */
          cell.gradeLbl.text = answrsProvistList["Grade"].stringValue
          var dateString = answrsProvistList["AskedOn"].stringValue
          dateString = dateString.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
          // For Decimal value
          cell.datLbl.text = DateHelper.localToUTC(date: dateString, fromFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "MMM dd, yyyy")
          cell.datLbl.font = UIFont.boldSystemFont(ofSize: 13.0)/* I tried to put
          "Roboto-Bold" , but it was not working properly so let it be boldSystemFont only to get the bold text  */
          cell.scholLbl.text = answrsProvistList["School"].stringValue
          let typeOfPersonForQuestionsThatCanYouAnsweredVC = PersonTypeForAnswerThatYouProvidedVC.init(rawValue: answrsProvistList["PersonType"].intValue)
          if typeOfPersonForQuestionsThatCanYouAnsweredVC != nil{
              cell.prsonTypLbl.text = "\(String(describing: typeOfPersonForQuestionsThatCanYouAnsweredVC!))"
              cell.prsonTypLbl.font = UIFont.boldSystemFont(ofSize: 13.0)/* I tried to put
              "Roboto-Bold" , but it was not working properly so let it be boldSystemFont only to get the bold text  */
          }
          cell.prsonNmLbl.text = answrsProvistList["FullName"].stringValue
          cell.prsonNmLbl.font = UIFont.boldSystemFont(ofSize: 13.0)/* I tried to put
          "Roboto-Bold" , but it was not working properly so let it be boldSystemFont only to get the bold text  */
          
          let stringUrl = answrsProvistList["ProfileURL"].stringValue
          let thumbnail = stringUrl.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
          cell.imgVw?.sd_setImage(with: URL.init(string:thumbnail ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
        /*Added by yasodha on 31/1/2020 starts here */
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.uiViewWithImageTapped))
                cell.imgVw.tag = indexPath.row
                // UserDefaults.standard.set( indexPath.row, forKey: "Profil_UserID_Question")//yasodha
                
                tap.numberOfTapsRequired = 1
                cell.imgVw.isUserInteractionEnabled = true
                cell.imgVw.addGestureRecognizer(tap)
         /*Added by yasodha on 31/1/2020 ends here */

                  
         cell.whatIsYourQstnLbl.text = answrsProvistList["Questions"].stringValue
         cell.whatIsYourQstnLbl.font = UIFont.boldSystemFont(ofSize: 16.0)/* I tried to put
                     "Roboto-Bold" , but it was not working properly so let it be boldSystemFont only to get the bold text  */
          cell.whatIsYourQstnLbl.textColor = UIColor.darkGray
          self.catagery = answrsProvistList["SubjectID"].intValue
          cell.subjctLbl.text = self.subjects[self.catagery-1]
        
        /* Added by yasodha on 9/1/2020 - starts here */
               
               cell.answerLbl.isHidden = true
               let lblString = answrsProvistList["Answers"].stringValue//yasodha
               if lblString.isEmpty{
                   cell.answerLbl.isHidden = true
                   
               }else{
                           
                           
                           if lblString.contains("<p") || lblString.contains("<!DOCTYPE") || lblString.contains("<head><style")
                           {
                               //  self.getAttributedString(htmlString:answrsProvistList["Answers"].stringValue , indexPath: indexPath)//yasodha
                               
                              DispatchQueue.global(qos: .background).async {
                                  // do your job here
                              let htmlData =  (answrsProvistList["Answers"].stringValue).html2Attributed
                               
                                  DispatchQueue.main.async {
                                      // update ui here
                                //   self.tableView.reloadData()//yasodha
                                   cell.answerLbl.isHidden = false
                                   cell.answerLbl.attributedText =  htmlData
                                   
                               }
                               
                              }
                               
               
                               
                           }else
                           {
                               cell.answerLbl.isHidden = false
                               cell.answerLbl.text = answrsProvistList["Answers"].stringValue//yasodha
                               
                           }
                   
                   
               }
               
                /* Added by yasodha on 9/1/2020 - ends here */
      
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnSelected(sender:)), for: .touchUpInside)
        
        cell.editBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(editBtnSelected(sender:)), for: .touchUpInside)
        
          return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let ansWersVC = storyboard?.instantiateViewController(withIdentifier: "answer") as! AnswersVC
               print("cell clicked")
               ansWersVC.userID = self.userID
               questionID = answrsThatUProvidedList[indexPath.row]["QuestionID"].stringValue
               ansWersVC.questionID = self.questionID
               navigationController?.pushViewController(ansWersVC, animated: true)
    }
    /*Added by yasodha on 30/1/2020 -  starts here */
          @objc func uiViewWithImageTapped(sender: UITapGestureRecognizer) {
                 print("uiViewWithImageTapped")
                 let personalprofile = storyboard?.instantiateViewController(withIdentifier: "personalprofile") as! PersonalProfileVC
                var qstnAnsrdList: JSON
                qstnAnsrdList = answrsThatUProvidedList[sender.view!.tag]
                personalprofile.userID = qstnAnsrdList["UserID"].stringValue
                 navigationController?.pushViewController(personalprofile, animated: false) /* comment this line when animation not required */
             }
             
         /*Added by yasodha on 30/1/2020 -  ends here */
    
    func getAttributedString(htmlString: String ,indexPath :IndexPath) {
        DispatchQueue.global(qos: .background).async {
            let htmlData = NSString(string: htmlString).data(using: String.Encoding.unicode.rawValue)
            // let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 40.0)! ]
            
            print("string------> %@ ",htmlString)
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
            
            
            do{
                let attributedString = try NSMutableAttributedString(data: htmlData!, options: options, documentAttributes: nil)
                if indexPath.row < self.answrsThatUProvidedList.count
                {
                    var dict = self.answrsThatUProvidedList[indexPath.row]
                    dict["Answers"].stringValue = attributedString.string
                    self.answrsThatUProvidedList.remove(at: indexPath.row)
                    self.answrsThatUProvidedList.insert(dict, at: indexPath.row)
                    
                    DispatchQueue.main.async {
                        
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                    }
                }
            }catch
            {
                showMessage(bodyText: "Bad html text",theme: .error, duration: .seconds(seconds: 0.1))
                
            }
    }
   }
}

extension AnswerThatYouProvidedVC {
private func hitServer(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
   // startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC")) /* Commented By Veeresh on 21st Feb */
   var shim = UIImageView()
               switch UIDevice.current.userInterfaceIdiom {
               case .phone: shim = UIImageView(image: UIImage(named: "my-content-mobile")!)
               case .pad: shim = UIImageView(image: UIImage(named: "my-content_1")!)// ; shim.contentMode = .topLeft
               case .unspecified: shim = UIImageView(image: UIImage(named: "my-content-mobile")!)
               case .tv: shim = UIImageView(image: UIImage(named: "my-content_1")!) ; shim.contentMode = .topLeft
               case .carPlay: shim = UIImageView(image: UIImage(named: "my-content-mobile")!)
               }//scaleAspectFill
        if answrsThatUProvidedList.count < 1 {
            tableView.backgroundView = shim
//             tableView.pinAllEdges(ofSubview: shim)
        }
               shim.startShimmering()
    LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){ result in
        self.tableView.backgroundView = UIView()
        shim.stopShimmering()
        shim.removeFromSuperview()
      //  self.stopAnimating()
        switch result {
        case let .success(json,requestType):
            let msg = json["message"].stringValue
            if json["error"].intValue == 1 {
                showMessage(bodyText: msg,theme: .error)
            }
            else {
              self.parseNDispayListData(json: json["ControlsData"]["AskedQuestionList"], requestType: requestType)
                }
            break
        case .failure(let error):
            print("MyError = \(error)")
            break
        }
     }
  }
    //delete functionality
     private func hitServerForDeleteAnswerThatYouProvided(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
         startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
         LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){ result in
             self.stopAnimating()
             switch result {
             case let .success(json,_):
                 let msg = json["message"].stringValue
                 if json["error"].intValue == 1 {
                     showMessage(bodyText: msg,theme: .error)
                 }
                 else {
                     self.answrsThatUProvidedList.remove(at: self.deletedIndexPath!.row)
                     self.tableView.reloadData()
                    showMessage(bodyText: "Successfully Deleted",theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.1))
                 }
                 break
             case .failure(let error):
                 print("MyError = \(error)")
                 break
             }
         }
     }
    private func parseNDispayListData(json: JSON,requestType: String){
        answrsThatUProvidedList = json.arrayValue
        
        /* Commented Ranjeet Code By Yashoda on 10th Jan 2019 - starts here */
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
        /* Commented Ranjeet Code By Yashoda on 10th Jan 2019 - ends here */
        
        self.tableView.reloadData() /* Added By Yashoda on 10th Jan 2019 */
    }
}

/* Added By Yashoda on 17th Dec 2020 - starts here */

extension Array where Iterator.Element == UIViewController {
    var previous: UIViewController? {
        if self.count > 1 {
            return self[self.count - 2]
        }
        return nil
    }
}
