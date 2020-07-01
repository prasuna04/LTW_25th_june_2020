//  TutorAvailableClass.swift
//  LTW
//  Created by Ranjeet Raushan on 21/02/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView
class TutorAvailableClass: UIViewController, UITableViewDataSource,UITableViewDelegate,NVActivityIndicatorViewable {
    @IBOutlet weak var tutorClassTableView: UITableView!
    var teacherListUserID: String!
    var userID: String!
    private var tutorAvailableClassArraList = [JSON]()
    /*commented by dk on 16th april 2020.*/
     /*{
        didSet {
            tutorClassTableView.reloadData()
        }
    }*/
    /* added by dk on 16th april 2020.*/
    lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(TutorAvailableClass.handleRefresh(_:)),for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userID =  UserDefaults.standard.string(forKey: "userID")
        tutorClassTableView.delegate = self
        tutorClassTableView.dataSource = self
        /*commenetd by deepak on 16th april 2020.*/
//        if currentReachabilityStatus != .notReachable {
//            hitServer(params: [:], endPoint: Endpoints.tutorAvailableClassEndPoint + (self.userID!) + "/" + (self.teacherListUserID!),  action: "tutorAvailableClass", httpMethod: .get)
//
//        } else {
//            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
//            })
//        }
        self.tutorClassTableView.addSubview(self.refreshControl) //Added by dk for refreshing.
    }
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    if currentReachabilityStatus != .notReachable {
        hitServer(params: [:], endPoint: Endpoints.tutorAvailableClassEndPoint + (self.userID!) + "/" + (self.teacherListUserID!),  action: "tutorAvailableClass", httpMethod: .get)
            
    } else {
        showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
        })
        }
    }
    
    
    //added by dk on 16th april 2020.
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
    //        tutorAvailableClassArraList.removeAll()
    //        tutorClassTableView.reloadData()
            hitServer(params: [:], endPoint: Endpoints.tutorAvailableClassEndPoint + (self.userID!) + "/" + (self.teacherListUserID!),  action: "tutorAvailableClass", httpMethod: .get)
                refreshControl.endRefreshing()
            }

    @objc func subscribeBtnBtnSelected(sender: UIButton){
        print("subscribeBtnBtnSelected")
        let index = sender.tag
        let classID = "\(tutorAvailableClassArraList[index]["Class_id"].intValue)"
//        guard let ID = UserDefaults.standard.string(forKey: "QuickBlockID") else { return } /*  Added By Ranjeet on 27th March 2020 */
        if sender.currentTitle == "Subscribe" {
            self.hitServerForSubscribeAvailableRequest(params: [:], endPoint: Endpoints.subscribeClassEndPoint + (self.userID!) + "/" + classID,action: "subscribe", httpMethod: .get) /*  Added By Ranjeet on 27th March 2020 */
            } else if sender.currentTitle == "Unsubscribe" {
            
            self.hitServerForUnsubscribeAvailableRequest(params: [:], endPoint: Endpoints.unsubscribeClassEndPoint + (self.userID!) + "/" + classID,action: "unsubscribe", httpMethod: .get)
        }
        /* Below commenetd by dk on 16th april 2020*/
//        tutorAvailableClassArraList.removeAll()
//
//        DispatchQueue.main.async {
//            self.tutorClassTableView.reloadData()
//        }
//        hitServer(params: [:], endPoint: Endpoints.tutorAvailableClassEndPoint + (self.userID!) + "/" + (self.teacherListUserID!),  action: "tutorAvailableClass", httpMethod: .get)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.hitServer(params: [:], endPoint: Endpoints.tutorAvailableClassEndPoint + (self.userID!) + "/" + (self.teacherListUserID!),  action: "tutorAvailableClass", httpMethod: .get)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tutorAvailableClassArraList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TutorAvailableClassCell
        var availableTutorDataList: JSON
        availableTutorDataList = tutorAvailableClassArraList[indexPath.row]
        cell.nameLabel.text = availableTutorDataList["fullname"].stringValue
        cell.titleLabel.text = availableTutorDataList["title"].stringValue
        cell.timeLabel.text = "\(availableTutorDataList["start_time"].stringValue) - \(availableTutorDataList["end_time"].stringValue)"
        cell.pointsCharegedLabel.text = availableTutorDataList["Pay_points"].stringValue
        cell.numberOfAttendeesLabel.text = availableTutorDataList["num_Subscribed"].stringValue
        let stringUrl = availableTutorDataList["profileURL"].stringValue
        let thumbnail = stringUrl.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
        cell.profileImg?.sd_setImage(with: URL.init(string:thumbnail ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
        cell.profileImg.setRounded()
        cell.profileImg.contentMode = .scaleAspectFill
        
        if availableTutorDataList["SharedType"].intValue == 1 {
            cell.publicBtn.isSelected = false
        }else {
            cell.publicBtn.isSelected = true
        }
        if availableTutorDataList["SubjectID"].intValue <= 4 {
            cell.subjectNameLabel.text = subjects[availableTutorDataList["SubjectID"].intValue-1]
        }else {
            cell.subjectNameLabel.text = "Invalid Subject Name"
        }
        cell.subSubjectNameLabel.text = getSubjectName(with: availableTutorDataList["Sub_SubjectID"].intValue)!
        cell.dateLabel.text = DateHelper.localToUTC(date: availableTutorDataList["date"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "dd-MMM-yyyy")
           // Subscribe Tutor Available Class
        cell.SsubscribeBtn.tag = indexPath.row
        
        if availableTutorDataList["isSubcribed"].boolValue == true
        {
            cell.SsubscribeBtn.setTitle("Unsubscribe", for: .normal)
            cell.SsubscribeBtn.backgroundColor = .clear
            cell.SsubscribeBtn.layer.borderColor = UIColor.init(hex: "2DA9EC").cgColor
            cell.SsubscribeBtn.setTitleColor(.init(hex: "2DA9EC"), for: .normal)
        }
        else if availableTutorDataList["isSubcribed"].boolValue == false
        {
            
            cell.SsubscribeBtn.setTitle("Subscribe", for: .normal)
            cell.SsubscribeBtn.backgroundColor = .init(hex: "228B22")
            cell.SsubscribeBtn.setTitleColor(.white, for: .normal)
        }
        cell.SsubscribeBtn.addTarget(self, action: #selector(subscribeBtnBtnSelected(sender:)), for: .touchUpInside)
        
        
        return cell
    }
    
    private func hitServer(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
//        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC")) //Commented by dk on 16th april 2020.
        
        //below added by dk on 16th april 2020.
        tutorAvailableClassArraList.removeAll()
        tutorClassTableView.reloadData()
        
        var shim = UIImageView()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: shim = UIImageView(image: UIImage(named: "Asset 65")!) ; shim.contentMode = .topLeft
        case .pad: shim = UIImageView(image: UIImage(named: "Asset 65")!) ; shim.contentMode = .scaleToFill
        case .unspecified: shim = UIImageView(image: UIImage(named: "my-group-mobile")!)
        case .tv: shim = UIImageView(image: UIImage(named: "my-group-ipad")!) ; shim.contentMode = .topLeft
        case .carPlay: shim = UIImageView(image: UIImage(named: "my-group-mobile")!)
        }//scaleAspectFill
         tutorClassTableView.backgroundView = shim  /* added by veeresh on 26/2/2020 */
                shim.startShimmering()
        //Addition end here
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){ [weak self] result in
            guard let _self = self else {
                return
            }
            _self.tutorClassTableView.backgroundView = UIView()
            shim.stopShimmering()
            shim.removeFromSuperview()
//            _self.stopAnimating()//Commeneted by dk on 16th april 2020.
            switch result {
            case let .success(json,requestType):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }
                else {
                    _self.parseNDispayListData(json: json["ControlsData"]["ClassList"], requestType: requestType)
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    private func parseNDispayListData(json: JSON,requestType: String){
        tutorAvailableClassArraList.append(contentsOf: json.arrayValue)
        DispatchQueue.main.async {
            self.tutorClassTableView.reloadData()
        }
    }
}
extension TutorAvailableClass {
    
    private func hitServerForSubscribeAvailableRequest(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){[weak self] result in
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
                    showMessage(bodyText: "You have subscribed to this class",theme: .success, duration: .seconds(seconds: 0.5))
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    
     private func hitServerForUnsubscribeAvailableRequest(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod){
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){[weak self] result in
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
                    showMessage(bodyText: "You have Unsubscribed the class.",theme: .success, duration: .seconds(seconds: 0.5))
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
}
