//  ClassAttended.swift
//  LTW
//  Created by vaayoo on 01/04/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import UIKit
import Alamofire
import NVActivityIndicatorView

class ClassDeliveredOrAttendedVC: UIViewController, UITableViewDataSource, UITableViewDelegate, GroupCell, NVActivityIndicatorViewable {
    
    var studentClassesEndPoint : String!
    var tutorClassesEndPoint : String!
    var perSonType : Int!
    var globalListEndPoint : String!
    
    let userId = UserDefaults.standard.string(forKey: "userID")
    
    typealias DownloadComplete = () -> ()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(ClassDeliveredOrAttendedVC.handleRefresh(_:)),for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    var cellDatas = [AttendedOrDeliveredClassData]()
    
    @IBOutlet weak var AttendedOrDeliveredClassTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AttendedOrDeliveredClassTableView.dataSource = self
        AttendedOrDeliveredClassTableView.delegate = self
        print(perSonType)
        
        print("DeepakKumar\(Endpoints.StudentClassesEndPoint + userId! + "/" + ((UserDefaults.standard.string(forKey: "personalprofile"))!) + "?searchText=\("")")")
        
        if perSonType == 1 {
            print("************** Student*****************")
            // UserDefaults.standard.set(personalprofile.userID, forKey: "personalprofile")
            if studentClassesEndPoint == "Class Attended"{
                globalListEndPoint = Endpoints.StudentClassesEndPoint + userId! + "/" + ((UserDefaults.standard.string(forKey: "personalprofile"))!) + "?searchText=\("")"
            }
        }else if perSonType == 3 {
            print("************* Teacher ****************")
            if tutorClassesEndPoint == "Classes Delivered"{
                globalListEndPoint = Endpoints.TutorClassesEndPoint + userId! + "/" + ((UserDefaults.standard.string(forKey: "personalprofile"))!) + "?searchText=\("")"
            }
        }
        print("globalListEndPoint",globalListEndPoint)
        print("Deepak Kumar",(UserDefaults.standard.string(forKey: "personalprofile"))!)
        
        //        downloadRequestedClassInformation{}
        hitServer(globalListEndPoint: globalListEndPoint)
        
        self.AttendedOrDeliveredClassTableView.addSubview(self.refreshControl) //Added by dk for refreshing.
        
        if studentClassesEndPoint ==   "Class Attended"{
            navigationItem.title = "Class Taken"
        }else if tutorClassesEndPoint == "Classes Delivered"{
            navigationItem.title = "Classes Delivered"
        }
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        cellDatas.removeAll()
        AttendedOrDeliveredClassTableView.reloadData()
        //        downloadRequestedClassInformation(){}
        hitServer(globalListEndPoint: globalListEndPoint)
        refreshControl.endRefreshing()
    }
    func hitServer(globalListEndPoint : String) {
        var shim = UIImageView()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: shim = UIImageView(image: UIImage(named: "Asset 65")!) ; shim.contentMode = .topLeft
        case .pad: shim = UIImageView(image: UIImage(named: "Asset 65")!) ; shim.contentMode = .scaleToFill
        case .unspecified: shim = UIImageView(image: UIImage(named: "my-group-mobile")!)
        case .tv: shim = UIImageView(image: UIImage(named: "my-group-ipad")!) ; shim.contentMode = .topLeft
        case .carPlay: shim = UIImageView(image: UIImage(named: "my-group-mobile")!)
        }//scaleAspectFill
        AttendedOrDeliveredClassTableView.backgroundView = shim  /* added by veeresh on 26/2/2020 */
        shim.startShimmering()
        downloadRequestedClassInformation(url: globalListEndPoint){
            self.AttendedOrDeliveredClassTableView.backgroundView = UIView()
            shim.stopShimmering()
            shim.removeFromSuperview()
        }
        
        
    }
    // Downloading data from server starts here. and adding it to celldatas array.
    
    private func downloadRequestedClassInformation(url :  String, completed : @escaping DownloadComplete) {
        print("Deepak Kumar url ", globalListEndPoint)
        //            print("Deepak Kumar searchURl " , searchUrl!)
        Alamofire.request(globalListEndPoint).responseJSON {
            response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject>{
                if let controlsData = dict["ControlsData"] as? Dictionary<String, AnyObject> {
                    if let lsvGrp = controlsData["ClassList"] as? [Dictionary<String, Any>]{
                        print(lsvGrp)
                        if lsvGrp.count != 0 {
                            for obj in lsvGrp {
                                let cellData = AttendedOrDeliveredClassData(attendedOrDeliveredClassDict : obj as Dictionary<String, AnyObject>)
                                self.cellDatas.append(cellData)
                                print("appendData>>\(self.cellDatas)")
                            }
                        }
                        else {
                            return
                        }
                        self.AttendedOrDeliveredClassTableView.reloadData()
                    }
                }
            }
            completed()
        }
    } //downloading data from server ends here
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttendedOrDeliveredClassCells", for: indexPath) as! AttendedOrDeliveredClassCells
        let data = cellDatas[indexPath.row]
        cell.updateCell(attendedOrDeliveredClassData: data)
        //        cell.personType = perSonType
        cell.cellDelegate = self
        cell.subscribeOrExpiredButton.tag = indexPath.row
        cell.reviewButton.tag = indexPath.row
        return cell
    }
    
    func onAcceptButton(index: Int) { // this function works for subscribe button
        if NetworkReachabilityManager()?.isReachable ?? false {
            //Internet connected,Go ahead
//            guard let quickBloxID = UserDefaults.standard.string(forKey: "QuickBlockID")
//                else {
//                    return
//            }
//            let endPoint = Endpoints.quickBlockRegisterEndPoint + userId! + "/" + "\(cellDatas[index].classId)/" + "0"
            let endPoint = Endpoints.subscribeClassEndPoint+userId!+"/\(cellDatas[index].classId)"
            print(endPoint)
            
            Alamofire.request(endPoint).responseJSON { response in
                print(response.request!)   // original url request
                print(response.response!) // http url response
                print(response.result)  // response serialization result
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                if "\(response.result)" == "SUCCESS"{
                    showMessage(bodyText: "Class Subscribed",theme: .success)
                    self.cellDatas.removeAll()
                    self.AttendedOrDeliveredClassTableView.reloadData()
                    //                    self.downloadRequestedClassInformation{}
                    self.hitServer(globalListEndPoint: self.globalListEndPoint)
                }
                else {
                    showMessage(bodyText: "Error",theme: .error)
                }
            }
            
        }else {
            //NO Internet connection, just return
            showMessage(bodyText: "No internet connection",theme: .warning)
        }
    }
    
    func onUnsubscribeButton(index : Int) {
        if NetworkReachabilityManager()?.isReachable ?? false {
            let endPoint = Endpoints.unsubscribeClassEndPoint + userId! + "/" + "\(cellDatas[index].classId)"
            print(endPoint)
            startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
            Alamofire.request(endPoint).responseJSON { response in
                self.stopAnimating()
                let json = response.result.value as? [String: Any]
                if "\(response.result)" == "SUCCESS"{
                    if json!["error"] as? Bool  == false {
                        showMessage(bodyText: "Unsubscribed Successfully!",theme: .success)
                        self.cellDatas.removeAll()
                        self.AttendedOrDeliveredClassTableView.reloadData()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.hitServer(globalListEndPoint: self.globalListEndPoint)
                        }
                    }else{
                        showMessage(bodyText: json!["message"] as! String,theme: .error)
                    }
                }
                else {
                    showMessage(bodyText: "Error",theme: .error)
                }
            }
        }
    }
    
    func onDeclineButton(index: Int) {
        print("Reviews Tapped!")
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let containerView = storyBoard.instantiateViewController(withIdentifier: "RatingAndReviewContainerViewController") as! RatingAndReviewContainerViewController
        let data1 = cellDatas[index].userId
        print(data1)
        containerView.profileUserId = data1
        self.navigationController?.pushViewController(containerView, animated: true)
    }
    
}

