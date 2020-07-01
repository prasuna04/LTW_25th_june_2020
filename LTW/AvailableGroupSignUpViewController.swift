//
//  AvailableGroupSignUpViewController.swift
//  LTW
//
//  Created by Vaayoo on 22/04/20.
//  Copyright © 2020 vaayoo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import SwiftMessages
import NVActivityIndicatorView

class AvailableGroupSignUpViewController: UIViewController,NVActivityIndicatorViewable{
    var myGrupsList: Array<JSON> = []
    @IBOutlet weak var taBleView: UITableView!
    @IBOutlet weak var nextBtn: UIButton!{didSet{
        nextBtn.backgroundColor = .clear
        nextBtn.layer.cornerRadius = nextBtn.frame.height / 2
        nextBtn.layer.borderWidth = 1
        nextBtn.layer.borderColor = UIColor.init(hex: "FFAE00").cgColor
        }
    }
    let subjects = UserDefaults.standard.array(forKey: "subjectArray") as! [String]
    let loguserId = UserDefaults.standard.string(forKey: "userID")
    private var tablePageIndex = 1
    private var noOfItemsInaPage = 5
    var activityIndicator: LoadMoreControl?
    var endPointUrl:String!
    var encoded:String?
    
    var subscribedClassCount : Int! = 0 //Added by DK.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myGrupsList.removeAll()
        activityIndicator = LoadMoreControl(scrollView: taBleView, spacingFromLastCell: 20, indicatorHeight: 60)
        activityIndicator?.delegate = self
        navigationItem.title = "AVAILABLE GROUP"
       // hitserver()
    }
    override func viewWillAppear(_ animated: Bool) {
        hitserver()
    }
    func hitserver(){
        let url = Endpoints.signupAvailableGroup + loguserId! + "/\(tablePageIndex)" + "/\(noOfItemsInaPage)"
        print(url)
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        Alamofire.request(url ).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                self.stopAnimating()
                self.activityIndicator?.stop()
                if let message = swiftyJsonVar["message"].string{
                    if message == "Success"{
                        let lsv_group = swiftyJsonVar["ControlsData"]["lsv_group"].arrayValue
                        if lsv_group.count == 0{
                           let followCategory = self.storyboard?.instantiateViewController(withIdentifier: "FollowCategoryPostSignVC") as! FollowCategoryPostSignVC
                            followCategory.modalPresentationStyle = .fullScreen
                            self.present(followCategory, animated: true, completion: nil)
                        }
                        self.myGrupsList.append(contentsOf: lsv_group)
                        DispatchQueue.main.async {
                            self.taBleView.reloadData()
                        }
                    }
                }
                self.taBleView.reloadData()
                self.stopAnimating()
                
            }else{
                self.stopAnimating()
            }
        }
    }
    @objc func cellTappedMethod(_ sender:AnyObject){
        print("Group info tapped")
        let index = myGrupsList[sender.view.tag]
        let DiscussionID = index["DiscussionID"].stringValue
        let SharedType = index["SharedType"].intValue
        let vc = storyboard?.instantiateViewController(withIdentifier: "GroupInfoViewController") as! GroupInfoViewController
        vc.discussionid = DiscussionID
        vc.userid = loguserId
        vc.imgeurl = index["TopicUrl"].stringValue
        vc.sharedtype = SharedType
        vc.signUpgroup = 0
        vc.title = "Group Info"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func exitgroup(sender: UIButton){
        let dict = myGrupsList[sender.tag]
        let DiscussionID = "\(dict["DiscussionID"].string ?? "")"
        let userId = UserDefaults.standard.string(forKey: "userID")
        let url1 = Endpoints.publicGroupJoin + "\(DiscussionID )/\(userId ?? "")"
        print(url1)
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        Alamofire.request(url1 , method: .get, parameters: nil , encoding: JSONEncoding.default)
            .responseJSON { response in
                self.stopAnimating()
                let swiftyJsonVar = JSON(response.result.value!)
                let msg = swiftyJsonVar["message"].stringValue
                print(msg)
                if msg == "Joined public group" {
                    print(response)
                    self.myGrupsList.remove(at: sender.tag)
                    DispatchQueue.main.async{
                        showMessage(bodyText: "Subscribed Group Successfully",theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.01))
                        self.taBleView.reloadData()
                    }
                    
                    self.subscribedClassCount += 1
                }else {
                    showMessage(bodyText: "Please Try Again!",theme: .warning)
                }
        }
        
    }
    @IBAction func onNextBtn(_ sender: UIButton) {
        if self.subscribedClassCount != 0 {
            UserDefaults.standard.set(true, forKey: "PostSignUpFollowCategoryPage")
            UserDefaults.standard.set(false, forKey: "PostSignupGroupPage")
            UserDefaults.standard.synchronize()
            let followCategory = self.storyboard?.instantiateViewController(withIdentifier: "FollowCategoryPostSignVC") as! FollowCategoryPostSignVC
            followCategory.modalPresentationStyle = .fullScreen
            self.present(followCategory, animated: true, completion: nil)
        }else {
            showMessage(bodyText: "Please Join Atleast One Group!",theme: .warning)
        }
    }
    
}
extension AvailableGroupSignUpViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGrupsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AvailableGroupSignUpTableViewCell", for: indexPath) as! AvailableGroupSignUpTableViewCell
        var groupList: JSON!
        if myGrupsList.count > 0 {
            groupList = myGrupsList[indexPath.row]
            cell.groupName.text = groupList["Title"].stringValue.uppercased()
            cell.grupCreatedBy.text = "\(groupList["CreatedBy"].stringValue)"
            
        }
        cell.grupCreatedBy.text = "\(groupList["CreatedBy"].stringValue)"
        cell.noOfParticipants.text = "\(groupList["NoSubscribers"].intValue)"
        var dateString = groupList["CreatedDate"].stringValue
        dateString = dateString.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        // For Decimal value
        cell.createdOn.text = "\(DateHelper.localToUTC(date: dateString, fromFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "MMM dd, yyyy"))"
        
        let catagery = groupList["SubjectID"].intValue
        let subcatagery = groupList["Sub_SubjectID"].intValue
        let subSubjectName = getSubjectName(with: subcatagery)
        cell.topicSubTopic.text = "\(self.subjects[catagery-1]) /\(subSubjectName ?? "")"
        let stringUrl = groupList["TopicUrl"].stringValue
        let thumbnail = stringUrl.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
        cell.grupImg?.sd_setImage(with: URL.init(string:thumbnail ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTappedMethod(_:)))
        cell.grupImg.isUserInteractionEnabled = true
        cell.grupImg.tag = indexPath.row
        cell.grupImg.addGestureRecognizer(tapGestureRecognizer)
        
        let SharedType = groupList["SharedType"].intValue
        if SharedType == 1{
            cell.PublicAndPrivate.isSelected = false
        }else{
            cell.PublicAndPrivate.isSelected = true
        }
        cell.exitgroupBtn.addTarget(self, action: #selector(exitgroup), for: .touchUpInside)
        cell.exitgroupBtn.tag = indexPath.row
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        activityIndicator?.didScroll()
        print("activityIndicator")
        
    }
}
//add by chandra for scrolling the tableview
extension AvailableGroupSignUpViewController: LoadMoreControlDelegate {
    func loadMoreControl(didStartAnimating loadMoreControl: LoadMoreControl) {
        print("didStartAnimating")
        tablePageIndex = (tablePageIndex + noOfItemsInaPage)
        self.hitserver()
    }
    
    func loadMoreControl(didStopAnimating loadMoreControl: LoadMoreControl) {
        print("didStopAnimating")
    }
}

