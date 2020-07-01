//  MyFollowedVC.swift
//  LTW
//  Created by Ranjeet Raushan on 09/06/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage
import NVActivityIndicatorView

class MyFollowedVC: UIViewController, UITableViewDataSource,UITableViewDelegate, NVActivityIndicatorViewable {
    
    
    @IBOutlet weak var tableView: UITableView!

    var myFollowed: Array<JSON> = []
    var userID: String!
    var followID: String!
    var deletedIndexPath: IndexPath?
    var rightBarButton: UIBarButtonItem!
    
    
    var refreshControl = UIRefreshControl() // pull to refresh
  
    /* Follow Category Right Bar Button Code Starts Here */
    lazy  var followCatgryRightBarButtonItem:UIBarButtonItem = {
        let barBtn = UIBarButtonItem(image: UIImage(named: "follow_category"), style: .plain, target: self, action: #selector(MyFollowedVC.onFollowCatgryRightBarButtonItem(sender:)))
        return barBtn
    }()
    /* Follow Category Right Bar Button Code Ends Here */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userID =  UserDefaults.standard.string(forKey: "userID")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if (self.navigationController?.navigationBar) != nil {
//            navigationController?.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
//        }
//        self.navigationController?.navigationBar.topItem?.title = " "
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        navigationItem.title = "Follow"
        
        
        guard let navigationController = navigationController else { return }
         navigationController.view.backgroundColor = UIColor.white
         if (self.navigationController?.navigationBar) != nil {
             navigationController.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
         }
         self.navigationController?.navigationBar.topItem?.title = " "
         navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
         navigationItem.title = "Follow Category"
        
        
         self.navigationItem.rightBarButtonItem = followCatgryRightBarButtonItem // For Follow  Category Right Bar Button
        // pull to refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(MyFollowedVC.hitApi),for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        if currentReachabilityStatus != .notReachable {
            hitServer(params: [:], endPoint: Endpoints.myFollowedEndPoint + (self.userID!),  action: "myFollowed", httpMethod: .get)
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
            })
        }
    }
    
    //pull to refresh
    @objc func hitApi() {
        refreshControl.endRefreshing()
        if currentReachabilityStatus != .notReachable {
            hitServer(params: [:], endPoint: Endpoints.myFollowedEndPoint + (self.userID!),  action: "myFollowed", httpMethod: .get)
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
                self.hitApi()
                self.refreshControl.endRefreshing()
            })
        }
    }

    @objc private func onFollowCatgryRightBarButtonItem(sender: UIBarButtonItem){
        print("Follow Category Right Bar Button Clicked")
        let followCtgry = storyboard?.instantiateViewController(withIdentifier: "followCtgry") as! AddtoFollowCategoryVC
        navigationController?.pushViewController(followCtgry, animated: true)
    }

    @objc func statusBtnSelected(sender: UIButton){
        let refreshAlert = UIAlertController(title: "Unfollow Category", message: "Are you sure you want to unfollow this ?", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("statusBtn Clicked")
            let index = sender.tag
            self.userID =  UserDefaults.standard.string(forKey: "userID")
            self.followID = self.myFollowed[index]["FollowID"].stringValue
            self.deletedIndexPath = IndexPath(item: sender.tag, section: 0)
             print("ON delete from local UI = \(self.deletedIndexPath!.row)")
            let isIndexValid = self.myFollowed.indices.contains(self.deletedIndexPath!.row)
            if self.currentReachabilityStatus != .notReachable {
                if isIndexValid{
                    self.followID = self.myFollowed[self.deletedIndexPath!.row]["FollowID"].stringValue
                    self.hitServer1(params: [:], endPoint: Endpoints.unfollowCatgryEndPoint + "/" + (self.userID!) + "/" + (self.followID!) ,action: "UnFollowCategoryAction", httpMethod: .get)
                }
            }
            else {
                showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
                })
            }
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in
        }))
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFollowed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyFollowedCell
        var followedList: JSON
        followedList = myFollowed[indexPath.row]
        cell.subjctLbl.text = followedList["SubjectName"].stringValue
        cell.sub_subjctLbl.text =  followedList["SubSubjectName"].stringValue
        cell.grdsLbl.text = followedList["GradeName"].stringValue
        cell.statusBtn.tag = indexPath.row
        cell.statusBtn.addTarget(self, action: #selector(statusBtnSelected(sender:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    private func hitServer(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){ [weak self] result in
            guard let _self = self else {
                return
            }
            _self.stopAnimating()
            switch result {
            case let .success(json,requestType):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }
                else {
                    _self.parseNDispayListData(json: json["ControlsData"]["FollowedList"], requestType: requestType)
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    private func hitServer1(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){ [weak self] result in
            guard let _self = self else {
                return
            }
            _self.stopAnimating()
            switch result {
            case let .success(json,_):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }
                else {
                    print("Before delete from local UI = \(_self.deletedIndexPath!.row)")
                    _self.myFollowed.remove(at: _self.deletedIndexPath!.row)
                    _self.tableView.reloadData()
                    showMessage(bodyText: "Unfollowed Successfully",theme: .success,presentationStyle: .center, duration: .seconds(seconds: 1))
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    private func parseNDispayListData(json: JSON,requestType: String){
        myFollowed = json.arrayValue
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

