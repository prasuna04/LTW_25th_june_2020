//
//  MyClassInfoVC.swift
//  LTW
//
//  Created by yashoda on 04/05/20.
//  Copyright © 2020 vaayoo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import NVActivityIndicatorView
// add by chandrasekhar
class MyClassInfoVC: UIViewController,NVActivityIndicatorViewable {
    let userId = UserDefaults.standard.string(forKey: "userID")
    var jsondict:[[String:Any]]?
    var classID : String!
    
    @IBOutlet weak var tbl_info: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        hitapiForFollwUsers()
        //let add = UIBarButtonItem(image: UIImage(named: "plus-1"), style: .done, target: self, action: #selector(addM))
       // self.navigationItem.rightBarButtonItem = add
    }
    override func viewWillAppear(_ animated: Bool) {
        hitapiForFollwUsers()
        guard let navigationController = navigationController else { return }
        navigationController.view.backgroundColor = UIColor.init(hex:"2DA9EC")
        if (self.navigationController?.navigationBar) != nil {
            navigationController.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        }
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Class Info"
        tbl_info.dataSource = self
        tbl_info.delegate = self
        hitapiForFollwUsers()
       
        
    }
   
    func hitapiForFollwUsers(){
       // let url = Endpoints.followUserList + (userId ?? "") /* Added By Chandra on 3rd Jan 2020 */
        //api/class/ClassSubsribersDetails/{UserID}/{ClassID}
        let url = Endpoints.classInfo + (userId ?? "") + "/" + classID /* Added By Chandra on 3rd Jan 2020 */
        
        
        print(url)
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        Alamofire.request(url ).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                self.stopAnimating()
                DispatchQueue.main.async {
                    if let message = swiftyJsonVar["message"].string{
                        if message == "Subscribed to class successfully."{
                            if let userFollow = swiftyJsonVar["ControlsData"]["subscribersList"].arrayObject as? [[String:Any]]{
                                self.jsondict = userFollow
                                print(self.jsondict!)
                            }else{
                                AppConstants().ShowAlert(vc: self, title:"Message", message:"There is no data!")
                            }
                        }
                    }
                    self.tbl_info.reloadData()
                    self.stopAnimating()
                }
            }
        }
    }
   
    @objc func cellTappedMethod(_ sender:AnyObject){
        let index = jsondict![sender.view.tag]
        let userId = index["UserID"] as! String
        let vc = storyboard?.instantiateViewController(withIdentifier: "personalprofile") as! PersonalProfileVC
        vc.userID = userId
        self.navigationController?.pushViewController(vc, animated: true)
        
        }
}
extension MyClassInfoVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsondict?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl_info.dequeueReusableCell(withIdentifier: "InfoCell") as! MyClassInfoCell
        // add by chandrasekhar
        cell.selectionStyle = .none
        let dict = jsondict?[indexPath.row]
        cell.lblName.text = "\(dict?["FirstName"] as? String ?? "") \(dict?["LastName"] as? String ?? "")"
        
        let stringUrl = dict?["ProfileUrl"] as? String ?? ""
        let thumbnail = stringUrl.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
        cell.imgProfile?.sd_setImage(with: URL.init(string:thumbnail ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
        
        // let imagurl = URL(string: dict?["ProfileUrl"] as? String ?? "")
        // cell.imgProfile.sd_setImage(with: imagurl, placeholderImage: UIImage(named: "small"), options: [], completed:nil)
//        let btnFollowbtn = dict?["isFollowing"] as? Bool
//        cell.btnFollow.tag = indexPath.row
//        cell.btnFollow.backgroundColor = .clear
//        cell.btnFollow.layer.cornerRadius = cell.btnFollow.frame.height / 2
//        cell.btnFollow.layer.borderWidth = 1
//        cell.btnFollow.layer.borderColor = UIColor.init(hex: "007AFF").cgColor
        let PersonType = dict?["PersonType"] as? Int
        cell.status.textColor = UIColor.init(hex: "2DA9EC")
        if PersonType == 1{
            cell.status.text = "Student"
        }else if PersonType == 2{
            cell.status.text = "Parent"
        }else{
            cell.status.text = "Teacher"
        }
        
//        if btnFollowbtn == true{
//            cell.btnFollow.setTitle("UnFollow", for: .normal)
//        }else{
//            cell.btnFollow.setTitle("Follow", for: .normal)
//        }
//        // tbl_followUser.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
//        cell.btnFollow.addTarget(self, action: #selector(followBtn), for: .touchUpInside)
//
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTappedMethod(_:)))
              cell.imgProfile.isUserInteractionEnabled = true
              cell.imgProfile.tag = indexPath.row
              cell.imgProfile.addGestureRecognizer(tapGestureRecognizer)
        return cell
    }
}



















