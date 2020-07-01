//  GroupInfoViewController.swift
//  LTW
//  Created by vaayoo on 15/10/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView

protocol segmenthide:class {
    func ststus(reviewans:Int)
}
class GroupInfoViewController: UIViewController,NVActivityIndicatorViewable {
     var callback: ((Int?)->())?
    let subjects = UserDefaults.standard.array(forKey: "subjectArray") as! [String]
    //    let sub_Subjects = UserDefaults.standard.array(forKey: "sub_SubjectArray1") as! [String]
    var imgeurl:String!
    var prasentIndex:Int!
    var userid:String!
    var discussionid:String!
    var sharedtype:Int!
    var jsondict:[[String:Any]]?
    var prtitle:String!
    var catagery:Int!
    var subcatagery:Int!
    var discription:String!
    var TopicUrl:String!
    var nofmembers:Int!
    var grpuserid:String!
    var DiscussionID:String!

    let loguserId = UserDefaults.standard.string(forKey: "userID")
    var signUpgroup:Int! /* Added By Chandra  on 24th April 2020  */

    @IBOutlet weak var tableview:UITableView!
        {
        didSet {
            tableview.tableFooterView = UIView(frame: .zero)
        }
    }
    @IBOutlet weak var topicurlimg:UIImageView!{didSet{
        topicurlimg.setRounded()
        }}
    @IBOutlet weak var exitgroup:UIButton!
        {didSet{
            exitgroup.backgroundColor = .clear
            exitgroup.layer.cornerRadius = exitgroup.frame.height / 2
            exitgroup.layer.borderWidth = 1
            exitgroup.setTitle("Exit Group", for: .normal)
            exitgroup.layer.borderColor = UIColor.init(hex: "FFAE00").cgColor
        }}
    @IBOutlet weak var editbtn:UIButton!
    @IBOutlet weak var prijectTitlelbl:UILabel!
    @IBOutlet weak var subjectidlbl :UILabel!
    @IBOutlet weak var subsubjectidlbl:UILabel!
    @IBOutlet weak var discriptionlbl:UITextView!
    @IBOutlet weak var howmanyMembersCount:UILabel!
    weak var delegate: segmenthide?
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.ststus(reviewans: 1)
        if prasentIndex == 2{
            exitgroup.setTitle("Subscribe", for: .normal)
        }
            /* Added By Chandra on 24th April  2020 - starts here  */
            else if signUpgroup == 0{
             exitgroup.setTitle("Subscribe", for: .normal)
            }
            /* Added By Chandra on 24th April  2020 - ends here  */
        else{
            exitgroup.setTitle("UnSubscribe", for: .normal)
        }
        // Add chandrasekhar
        discriptionlbl.isEditable = false
        if sharedtype == 1{
            callapi()
        }else{
            callapi()
        }
        exitgroup.addTarget(self, action: #selector(exitgroupBtn), for: .touchUpInside)
        editbtn.addTarget(self, action: #selector(editbtnBtn), for: .touchUpInside)
        let thumbnail = self.imgeurl.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
        self.topicurlimg.sd_setImage(with: URL.init(string:thumbnail), placeholderImage: UIImage(named: "account-active"), options: [], completed:nil)
    }
    
    func callapi() {
        let url = Endpoints.groupInfoWithListOfUser + "\(discussionid ?? "")/\(userid ?? "")" /* Added By Chandra on 3rd Jan 2020 */
        print(url)
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        Alamofire.request(url ).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                self.stopAnimating()
                DispatchQueue.main.async {
                    if let msg = swiftyJsonVar["message"].string{
                        if swiftyJsonVar["error"].intValue == 1 {
                            showMessage(bodyText: msg,theme: .error)
                        }else{
                            if let lsv_group = swiftyJsonVar["ControlsData"]["groupInfo"]["UsersList"].arrayObject as? [[String:Any]]{
                                let data = swiftyJsonVar["ControlsData"]["groupInfo"]
                                self.prtitle = data["Title"].stringValue
                                self.catagery = data["SubjectID"].intValue
                                self.subcatagery = data["Sub_SubjectID"].intValue
                                self.discription = data["Description"].stringValue
                                self.TopicUrl = data["TopicUrl"].stringValue
                                self.grpuserid = data["UserID"].stringValue
                                print(self.TopicUrl )
                                self.DiscussionID = data["DiscussionID"].stringValue
                                self.jsondict = lsv_group
                                self.nofmembers = self.jsondict?.count
                            }
                            if self.discription == "Add description(optional)"{
                                self.discriptionlbl.text = ""
                            }else{
                                self.discriptionlbl.text = self.discription
                            }
                            let subSubjectName = getSubjectName(with: self.subcatagery)
                            self.prijectTitlelbl.text = self.prtitle
                            self.subjectidlbl.text = self.subjects[self.catagery-1]
                            self.subsubjectidlbl.text = subSubjectName
                            //                            self.discriptionlbl.text = self.discription
                            self.howmanyMembersCount.text = "\(self.nofmembers ?? 0) participants"
                        }
                    }
                    self.tableview.reloadData()
                    self.stopAnimating()
                    
                }
            }
        }
    }
    @objc func deleteBtn(sender:UIButton){
        let refreshAlert = UIAlertController(title: "Delete", message: "Are you sure, You want to delete this Group Member?", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("delete button is selected")
            let dict1 = self.jsondict?[sender.tag]
            let removeUserId = "\(dict1?["UserID"] as? String ?? "")"
            let exiturl = Endpoints.deleteGroupEndPoint + "\(self.DiscussionID ?? "")/\(self.grpuserid ?? "")/\(removeUserId )"
            Alamofire.request(exiturl , method: .get, parameters: nil , encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response)
                    self.jsondict?.remove(at: sender.tag)
                    DispatchQueue.main.async{
                        if self.sharedtype == 1{
                            self.callapi()
                        }else{
                            self.callapi()
                        }
                        self.tableview.reloadData()
                    }
            }
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    @objc func editbtnBtn(sender:UIButton){
        print("editbtn button is selected")
        let editurl = Endpoints.groupInfo + "\(DiscussionID ?? "")/\(loguserId ?? "")"
        Alamofire.request(editurl , method: .get, parameters: nil , encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                DispatchQueue.main.async{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "createnewgrupdscsn") as! CreateNewGrupDscsnVC
                    let swiftyJsonVar = JSON(response.result.value!)
                    let data = swiftyJsonVar["ControlsData"]["groupInfo"]
                    let catagery1 = data["SubjectID"].intValue
                    vc.catgery = self.subjects[catagery1-1]
                    let subcatagery1 = data["Sub_SubjectID"].intValue
                    let subSubjectName = getSubjectName(with: subcatagery1)
                    vc.subcategery = subSubjectName
                    vc.stringUrl = data["TopicUrl"].stringValue
                    vc.groupName = data["Title"].stringValue
                    vc.emailids = data["Emailids"].stringValue
                    vc.oldGrades = data["Grades"].stringValue
                    let Seperated = vc.emailids?.split(separator: ";").map { String($0) }
                    vc.Oldemailids = Seperated
                    vc.DiscussionID1 = data["DiscussionID"].stringValue
                    vc.Description = data["Description"].stringValue
                    vc.SharedType1 = data["SharedType"].intValue
                    vc.EditGroup = "Group Edit"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
        }
    }
    
    @objc func exitgroupBtn(sender:UIButton){
        if prasentIndex == 2{
            let url1 = Endpoints.publicGroupJoin + "\(DiscussionID ?? "" )/\(loguserId ?? "")" /* Added By Chandra on 3rd Jan 2020 */
            
            print(url1)
            startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
            Alamofire.request(url1 , method: .get, parameters: nil , encoding: JSONEncoding.default)
                .responseJSON { response in
                    self.stopAnimating()
                    let createnewgrupdscsn = self.storyboard?.instantiateViewController(withIdentifier: "mygroup") as! MyGroupsVC
                   // self.navigationController?.pushViewController(createnewgrupdscsn, animated: true)
                    self.navigationController?.popViewController(animated: true)
                    print(response)
                    self.callback?(2)// add  by chandra
                    DispatchQueue.main.async{
                        // self.hitApiForPullToRefresh()
                        // self.taBleView.reloadData()
                    }
            }
        }
        /* Added By Chandra on 24th April 2020 - starts here  here */
            else if signUpgroup == 0{
                        let url1 = Endpoints.publicGroupJoin + "\(DiscussionID ?? "" )/\(loguserId ?? "")" /* Added By Chandra on 3rd Jan 2020 */
                        
                        print(url1)
                        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
                        Alamofire.request(url1 , method: .get, parameters: nil , encoding: JSONEncoding.default)
                            .responseJSON { response in
                                self.stopAnimating()
                               let tourDemo = self.storyboard?.instantiateViewController(withIdentifier: "AvailableGroupSignUpViewController") as! AvailableGroupSignUpViewController
                                    self.navigationController?.pushViewController(tourDemo, animated: false)
                                print(response)
                                DispatchQueue.main.async{
                                   showMessage(bodyText: "Subscribe Successfully",theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.01))
                                }
                        }
                    }

/* Added By Chandra on 24th April 2020 - ends here */
            
        else{
            print("exitgroup button is selected")
         
            let exiturl = Endpoints.exitPublicGroup + "\(DiscussionID ?? "" )/\(loguserId ?? "")" /* Added By Chandra on 3rd Jan 2020 */
            
            Alamofire.request(exiturl , method: .get, parameters: nil , encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response)
                    self.navigationController?.popViewController(animated: true)
                    DispatchQueue.main.async{
                        if self.sharedtype == 1{
                            self.callapi()
                        }else{
                            self.callapi()
                        }
                    }
            }
        }
    }
}
extension GroupInfoViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsondict?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupInfoTableViewCell") as! GroupInfoTableViewCell
        let dict = jsondict?[indexPath.row]
        cell.name.text = "\(dict?["FirstName"] as? String ?? "") \(dict?["LastName"] as? String ?? "")"
        let PersonType = dict?["PersonType"] as? Int
        cell.personType.textColor = UIColor.init(hex: "2DA9EC")
        if PersonType == 1{
            cell.personType.text = "Student"
        }else if PersonType == 2{
            cell.personType.text = "Teacher"
        }else{
            cell.personType.text = "Teacher"
        }
        let useridOfList = dict?["UserID"] as? String
        let stringUrl = dict?["ProfileUrl"] as? String ?? ""
        let thumbnail = stringUrl.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
        cell.profileimg?.sd_setImage(with: URL.init(string:thumbnail ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
        if grpuserid == loguserId{
            if(loguserId == useridOfList){
                cell.delete.isHidden = true
            }
            else{
                cell.delete.isHidden = false
            }
            editbtn.isHidden = false
            exitgroup.isHidden = true
        }else{
            cell.delete.isHidden = true
            editbtn.isHidden = true
            exitgroup.isHidden = false
        }
        cell.delete.tag = indexPath.row
        cell.delete.addTarget(self, action: #selector(deleteBtn), for: .touchUpInside)
        return cell
    }
}
