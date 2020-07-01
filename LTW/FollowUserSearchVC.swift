// FollowUserSearchVC.swift
// LTW
// Created by Vaayoo on 04/10/19.
// Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class FollowUserSearchVC: UIViewController,NVActivityIndicatorViewable {
    @IBOutlet weak var txt_search: UITextField!
    @IBOutlet weak var tableview: UITableView!
    var geturl:String?
    var useridfollow:String?
    let userId = UserDefaults.standard.string(forKey: "userID")
    var reload: ((_ str: String) -> Void)?
    var jsondict:[[String:Any]]?
    override func viewDidLoad() {
        super.viewDidLoad()
                   txt_search.layer.cornerRadius = 20
                   txt_search.layer.borderWidth = 1.5
                   txt_search.layer.borderColor = UIColor.white.cgColor
                   txt_search.leftViewMode = UITextField.ViewMode.always
                   let views = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
                   views.backgroundColor = UIColor.clear
                   let imageView1 = UIImageView(frame: CGRect(x: 10, y:10, width: 20, height: 20))
                   let image = UIImage(named: "topsearch")
                   imageView1.image = image
                   views.addSubview(imageView1)
                   txt_search.leftView = views
                   txt_search.tintColor = .white
                   txt_search.attributedPlaceholder =
                   NSAttributedString(string: " Enter FirstName/LastName/Email Id", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

    }
    
     @IBAction func btnSearch(_ sender: UIButton){
         self.hitapi()
     }
//    @objc func tappedMe(){ // commented by chandra for searchBar Ui chnged
//        self.hitapi()
//    }
    
    func hitapi(){
        let encoded = txt_search.text!.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        let url = Endpoints.searchAndFollowUser + "\(userId!)?searchtext=" + "\(encoded ?? "")" /* Added By Chandra on 3rd Jan 2020 */
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
                                AppConstants().ShowAlert(vc: self, title:"Message", message:"Entr Firstname/lastname/Email id")
                            }
                        }
                    }
                    self.tableview.reloadData()
                    self.stopAnimating()
                    self.txt_search.resignFirstResponder()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Search User"
    }
    @objc func followBtn(sender:UIButton){
        let dict = jsondict?[sender.tag]
        let btn1 = dict?["isFollowing"] as? Bool
        useridfollow = "\(dict?["UserID"] as? String ?? "")"
        if btn1 == false {
//             geturl = "http://ltwservice-staging.azurewebsites.net/api/Users/FollowUser/\(userId ?? "")/\(useridfollow ?? "")/1" //(staging server)
//             geturl = "http://ltwservice.azurewebsites.net/api/Users/FollowUser/\(userId ?? "")/\(useridfollow ?? "")/1" //(production server)
            geturl = "\(Endpoints.userFollowEndPoint)\(UserDefaults.standard.string(forKey: "userID")!)/\(useridfollow ?? "")/\(1)" /* Added By Chandra on 3rd Jan 2020 */
        }else{
//            geturl = "http://ltwservice-staging.azurewebsites.net/api/Users/FollowUser/\(userId ?? "")/\(useridfollow ?? "")/0" //(staging server)
//            geturl = "http://ltwservice.azurewebsites.net/api/Users/FollowUser/\(userId ?? "")/\(useridfollow ?? "")/0" //(production server)
            geturl = "\(Endpoints.userFollowEndPoint)\(UserDefaults.standard.string(forKey: "userID")!)/\(useridfollow ?? "")/\(0)" /* Added By Chandra on 3rd Jan 2020 */
        }
        let url1 = geturl
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        Alamofire.request(url1 ?? "", method: .get, parameters: nil , encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                
                DispatchQueue.main.async{
                    self.hitapi()
                }
        }
    }
    @objc func ImgTapped(sender:AnyObject){
        let index = jsondict![sender.view.tag]
        let userId = index["UserID"] as! String
        let vc = storyboard?.instantiateViewController(withIdentifier: "personalprofile") as! PersonalProfileVC
        vc.userID = userId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension FollowUserSearchVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsondict?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followUserSerchTableViewCell") as! followUserSerchTableViewCell
        let dict = jsondict?[indexPath.row]
        cell.name.text = "\(dict?["FirstName"] as? String ?? "") \(dict?["LastName"] as? String ?? "")"
//        let imagurl = URL(string: dict?["ProfileUrl"] as? String ?? "")
//        cell.profileview.sd_setImage(with: imagurl, placeholderImage: UIImage(named: "small"), options: [], completed:nil)
        let stringUrl = dict?["ProfileUrl"] as? String ?? ""
        let thumbnail = stringUrl.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
        cell.profileview?.sd_setImage(with: URL.init(string:thumbnail ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
        
        
        let PersonType = dict?["PersonType"] as? Int
        cell.status.textColor = UIColor.init(hex: "2DA9EC")
        if PersonType == 1{
            cell.status.text = "Student"
        }else if PersonType == 2{
            cell.status.text = "Parent"
        }else{
            cell.status.text = "Teacher"
        }
        
        let btn = dict?["isFollowing"] as? Bool
        cell.followUnfollowBtn.tag = indexPath.row
        cell.followUnfollowBtn.backgroundColor = .clear
        cell.followUnfollowBtn.layer.cornerRadius = cell.followUnfollowBtn.frame.height / 2
        cell.followUnfollowBtn.layer.borderWidth = 1
        cell.followUnfollowBtn.layer.borderColor = UIColor.init(hex: "2DA9EC").cgColor
        if btn == true{
            cell.followUnfollowBtn.setTitle("Unfollow",for: .normal)
        }else{
            cell.followUnfollowBtn.setTitle("Follow",for: .normal)
        }
        cell.followUnfollowBtn.addTarget(self, action: #selector(followBtn), for: .touchUpInside)
        var gastureTap = UITapGestureRecognizer(target: self, action: #selector(ImgTapped))
        cell.profileview.isUserInteractionEnabled = true
        cell.profileview.tag = indexPath.row
        cell.profileview.addGestureRecognizer(gastureTap)
        
        
        return cell
    }
}
