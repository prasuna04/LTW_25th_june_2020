//  LikesViewController.swift
//  Created by vaayoo on 11/10/19.

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
// add by chandrasekhar
class LikesViewController: UIViewController,NVActivityIndicatorViewable {
    var Qid:String?
    var Uid:String?
    var geturl:String?
    var useridfollow:String?
    let userId = UserDefaults.standard.string(forKey: "userID")
    var jsondict:[[String:Any]]?
    @IBOutlet weak var tableview:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        hitapi()
    }
    
    func hitapi(){
        let url = "\(Endpoints.getLikedUserList)\(UserDefaults.standard.string(forKey: "userID")!)/\(Qid ?? "")/\(1)" /* Added By Chandra on 3rd Jan 2020 */
        print(url)
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        Alamofire.request(url ).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                self.stopAnimating()
                DispatchQueue.main.async {
                    let msg = swiftyJsonVar["message"].stringValue
                    if swiftyJsonVar["error"].intValue == 1 {
                        showMessage(bodyText: msg,theme: .error)
                    }else{
                        if let usersList = swiftyJsonVar["ControlsData"]["usersList"].arrayObject as? [[String:Any]]{
                            self.jsondict = usersList
                        }
                    }
                    self.tableview.reloadData()
                    self.stopAnimating()
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navigationController = navigationController else { return }
               navigationController.view.backgroundColor = UIColor.white
        if (self.navigationController?.navigationBar) != nil {
            navigationController.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        }
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "People Who Liked"
    }
    @objc func followBtn(sender:UIButton){
        let dict = jsondict?[sender.tag]
        let btn1 = dict?["isFollowing"] as? Bool
        useridfollow = "\(dict?["UserID"] as? String ?? "")"
        
        if btn1 == false {
            geturl = "\(Endpoints.userFollowEndPoint)\(UserDefaults.standard.string(forKey: "userID")!)/\(useridfollow ?? "")/\(1)" /* Added By Chandra on 3rd Jan 2020 */
            
        }else{
            geturl = "\(Endpoints.userFollowEndPoint)\(UserDefaults.standard.string(forKey: "userID")!)/\(useridfollow ?? "")/\(0)" /* Added By Chandra on 3rd Jan 2020 */
        }
        let url1 = geturl
        print(url1!)
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        Alamofire.request(url1 ?? "", method: .get, parameters: nil , encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                
                DispatchQueue.main.async{
                    self.hitapi()
                }
                
        }
    }
}
extension LikesViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsondict?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikesTableViewCell") as! LikesTableViewCell
        let dict = jsondict?[indexPath.row]
        cell.name.text = "\(dict?["FirstName"] as? String ?? "")\(dict?["LastName"] as? String ?? "")"
        let imagurl = URL(string: dict?["ProfileUrl"] as? String ?? "")
        cell.profileview.sd_setImage(with: imagurl, placeholderImage: UIImage(named: ""), options: [], completed:nil)
        let btn = dict?["isFollowing"] as? Bool
        cell.followUnfollowBtn.tag = indexPath.row
        cell.followUnfollowBtn.backgroundColor = .clear
        cell.followUnfollowBtn.layer.cornerRadius = cell.followUnfollowBtn.frame.height / 2
        cell.followUnfollowBtn.layer.borderWidth = 1
        cell.followUnfollowBtn.layer.borderColor = UIColor.init(hex: "007AFF").cgColor
        if btn == true{
            cell.followUnfollowBtn.setTitle("Unfollow",for: .normal)
        }else{
            cell.followUnfollowBtn.setTitle("Follow",for: .normal)
        }
        tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
        
        cell.followUnfollowBtn.addTarget(self, action: #selector(followBtn), for: .touchUpInside)
        return cell
    }
    
    
}
