//  MyFollowUseer2ViewController.swift
//  LTW
//  Created by Vaayoo on 22/10/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import NVActivityIndicatorView
//add by chandraSekhar
class MyFollowUseer2ViewController: UIViewController,NVActivityIndicatorViewable {
let userId = UserDefaults.standard.string(forKey: "userID")
    var jsondict:[[String:Any]]?
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        hitapiForFollwUsers()
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
        navigationItem.title = "My Followers"
    }
    func hitapiForFollwUsers(){
        let url = Endpoints.followingUserList + (userId ?? "") /* Added By Chandra on 3rd Jan 2020 */
        print(url)
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        Alamofire.request(url ).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                self.stopAnimating()
                DispatchQueue.main.async {
                    if let message = swiftyJsonVar["message"].string{
                        if message == "Success"{
                            if let userFollow = swiftyJsonVar["ControlsData"]["userFollow"].arrayObject as? [[String:Any]]{
                                self.jsondict = userFollow
                            }else{
                                AppConstants().ShowAlert(vc: self, title:"Message", message:"There is no data!")
                            }
                        }
                    }
                   self.tableview.reloadData()
                    self.stopAnimating()
                }
            }
        }
    }
    @objc func followBtn(sender:UIButton){
        let dict = jsondict?[sender.tag]
        let useridfollow = "\(dict?["UserID"] as? String ?? "")"

        let url = Endpoints.unFollowFollowingUser + (userId ?? "") + "/\(useridfollow)" /* Added By Chandra on 3rd Jan 2020 */
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        Alamofire.request(url , method: .get, parameters: nil , encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                DispatchQueue.main.async{
                    self.hitapiForFollwUsers()
                    self.stopAnimating()
                }
        }
    }
    @objc func ImgTapped(sender:AnyObject){
        let index = jsondict![sender.view.tag]
        let userId = index["UserID"] as! String
        print(userId)
         let vc = storyboard?.instantiateViewController(withIdentifier: "personalprofile") as! PersonalProfileVC
        vc.userID = userId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension MyFollowUseer2ViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsondict?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFollowUser2TableViewCell") as! MyFollowUser2TableViewCell
        let dict = jsondict?[indexPath.row]
        cell.lblName.text = "\(dict?["FirstName"] as? String ?? "") \(dict?["LastName"] as? String ?? "")"
        cell.selectionStyle = .none
        let stringUrl =  dict?["ProfileUrl"] as? String
        let thumbnail = stringUrl?.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-") ?? ""
        cell.imgProfile.sd_setImage(with: URL.init(string:thumbnail ), placeholderImage: UIImage(named: "small"), options: [], completed:nil)
        let btnFollowbtn = dict?["isFollowing"] as? Bool
        cell.btnFollow.tag = indexPath.row
        cell.btnFollow.backgroundColor = .clear
        cell.btnFollow.layer.cornerRadius = cell.btnFollow.frame.height / 2
        cell.btnFollow.layer.borderWidth = 1
        cell.btnFollow.layer.borderColor = UIColor.init(hex: "007AFF").cgColor
        let PersonType = dict?["PersonType"] as? Int
        cell.status.textColor = UIColor.init(hex: "2DA9EC")
        if PersonType == 1{
            cell.status.text = "Student"
        }else if PersonType == 2{
            cell.status.text = "Parent"
        }else{
            cell.status.text = "Teacher"
        }
        if btnFollowbtn == true{
            cell.btnFollow.setTitle("Remove", for: .normal)
        }else{
            cell.btnFollow.setTitle("Follow", for: .normal)
        }
        cell.btnFollow.addTarget(self, action: #selector(followBtn), for: .touchUpInside)
        let gasture = UITapGestureRecognizer(target: self, action: #selector(ImgTapped))
        cell.imgProfile.tag = indexPath.row
        cell.imgProfile.isUserInteractionEnabled = true
        cell.imgProfile.addGestureRecognizer(gasture)
        return cell
    }
}
