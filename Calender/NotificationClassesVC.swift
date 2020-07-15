//
//  NotificationClasses.swift
//  LTW
//
//  Created by vaayoo on 01/07/20.
//  Copyright © 2020 vaayoo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class NotificationClassesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, GroupCell{
    
    @IBOutlet weak var notificationClassesTableView : UITableView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(ClassDeliveredOrAttendedVC.handleRefresh(_:)),for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    var classDict : [LTWEvents]!
    let personType = UserDefaults.standard.string(forKey: "persontyp")
    let userID = UserDefaults.standard.string(forKey: "userID")
    var actionName : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationClassesTableView.delegate = self
        notificationClassesTableView.dataSource = self
        self.notificationClassesTableView.addSubview(self.refreshControl)
//        notificationClassesTableView.reloadData()
        print(classDict)
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        notificationClassesTableView.reloadData()
        refreshControl.endRefreshing()
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classDict.count
//        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let i = classDict[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationClassesCell", for: indexPath) as! NotificationClassesCell
        let datef = DateFormatter()
        datef.dateFormat = "dd-MM-YYYY"
        let currentDate = Date()
        print( classDict[indexPath.row].key == datef.string(from: currentDate))
        if classDict[indexPath.row].key == datef.string(from: currentDate) {
            let classDate = "\(classDict[indexPath.row].key) \(classDict[indexPath.row].startDate)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-YYYY h:mm a"
            let classDate1 = dateFormatter.date(from: classDate)
            print(classDate1)
            if minutes(from: datef.date(from: classDict[indexPath.row].startDate)!) >= -30 && minutes(from: datef.date(from:  classDict[indexPath.row].startDate)!) <= 30 {
                cell.joinButton.isUserInteractionEnabled = true
                cell.joinButton.backgroundColor = UIColor.init(hex:"60A200")
            }
            else {
                cell.joinButton.isUserInteractionEnabled = false
                cell.joinButton.backgroundColor = UIColor.lightGray
            }
        }else {
            cell.joinButton.isUserInteractionEnabled = false
            cell.joinButton.backgroundColor = UIColor.lightGray
        }
        if personType == "1"{ //student
            cell.subscribeUnsubscribeButton.isHidden = false
            cell.tutorNameLabel.isHidden = false
            cell.whiteBoardImage.isHidden = false
            // Attachment for tutor whiteboard image befor tutor name.
            let teacherFirstName = (i.teacherName).split(separator: " ")
            //            let attachment = NSTextAttachment()
            //            attachment.image = UIImage(named: "Icon awesome-chalkboard-teacher")
            //            let attachmentString = NSAttributedString(attachment: attachment)
            //        let myString = NSMutableAttributedString(string: String(teacherFirstName[0]))
            //            let addedString = attachmentString+ "\(myStrinf)"
            cell.tutorNameLabel.text = String(teacherFirstName[0])
        }else{
            cell.whiteBoardImage.isHidden = true
            cell.subscribeUnsubscribeButton.isHidden = true
            cell.tutorNameLabel.isHidden = true
            cell.tutorNameLabel.text = ""
        }
        cell.cellDelegate = self
        cell.classTitle.text = i.tittle
        //        cell.classDate.text = i.key
        cell.classDate.text = DateHelper.formattDate(date: (DateHelper.getDateObj(from: i.key, fromFormat: "dd-MM-yyyy")), toFormatt: "EEEE, MMM d, yyyy")
        
        cell.grades.text = i.grade
        cell.timings.text = "\(i.startDate) To \(i.endDate) (\(getCurrentTimeZoneName()))"
        cell.subject.text = i.topic
        cell.joinButton.tag = indexPath.row
        cell.whiteboardButton.tag = indexPath.row
        cell.subscribeUnsubscribeButton.tag = indexPath.row
        return cell
    }
    func minutes(from date: Date) -> Int {
       let datef = DateFormatter()
        datef.dateFormat = "h:mm a"
        let str = datef.string(from: Date())
       // datef.date
        return Calendar.current.dateComponents([.minute], from: date, to: datef.date(from: str)!).minute ?? 0
    }
    
    //HitServer Function Goes Here.
    func hitServer(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){[weak self] result in
            guard let _self = self else {
                return
            }
            switch result
            {
            case let .success(json,_):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }
                else {
                    /*Added by yasodha on 27/1/2020 - starts*/
                    _self.actionName = action
                    //after coming from the Zoom
                    if _self.actionName == "startClass" || _self.actionName == "Joinclass"{
                    }
                    else if _self.actionName == "unsubscribe" {
                        // showMessage(bodyText: msg,theme: .success) /*  Commented By Ranjeet on 19th March 2020 */
                        showMessage(bodyText: "You have unsubscribed from this class",theme: .success)  /*  Updated By Ranjeet on 19th March 2020 */
                    }
                }
            default : break
            }
            
            
        }
    }
    func onAcceptButton(index: Int) {// function for join.
        let p : Int = Int(personType!)!
        if p == 1 {
            let endPoint = Endpoints.classStartedEndpoint + userID! + "/" + "\(classDict[index].classId)"
            actionName = "StudentJoin"
            hitServer(params: [:], endPoint: endPoint ,action: actionName, httpMethod: .get)
            let hostURL = classDict[index].hostUrl
            if hostURL == ""{
                // showMessage(bodyText: "Not part of zoom meeting.. call.",theme:.warning,presentationStyle:.center,duration:.seconds(seconds: 0.2) )
                showMessage(bodyText: "Not part of zoom meeting.. call.",theme: .warning)
                return
            }else if let url = NSURL(string:classDict[index].hostUrl){
                UIApplication.shared.openURL(url as URL)
            }
        }
        else {
            let endPoint = Endpoints.classStartedEndpoint + userID! + "/" + "\(classDict[index].classId)"
            actionName = "TeacherJoin"
            hitServer(params: [:], endPoint: endPoint ,action: actionName, httpMethod: .get)
            let hostURL = classDict[index].hostUrl
            if hostURL == ""{
                // showMessage(bodyText: "Not part of zoom meeting.. call.",theme:.warning,presentationStyle:.center,duration:.seconds(seconds: 0.2) )
                showMessage(bodyText: "Not part of zoom meeting.. call.",theme: .warning)
                return
                
            }else if let url = NSURL(string:classDict[index].hostUrl){
                UIApplication.shared.openURL(url as URL)
                
            }
            print("hostURL: \(classDict[index].hostUrl)")
        }
    }
    
    func onDeclineButton(index: Int) { // this function is predefined, so changing body to call whiteboard.
           guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
               return
           }
           self.title = "Call"
           self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
           // self.navigationItem.rightBarButtonItem?.isEnabled = false
           viewController.viewFinalImageButton.title = ""
           self.navigationController?.pushViewController(viewController, animated: true)
       
    }
    
    func onUnsubscribeButton(index: Int) {
        if NetworkReachabilityManager()?.isReachable ?? false {
            let endPoint = Endpoints.unsubscribeClassEndPoint + userID! + "/" + "\(classDict[index].classId)"
            print(endPoint)
            Alamofire.request(endPoint).responseJSON { response in
                print(response.request!)   // original url request
                print(response.response!) // http url response
                print(response.result)  // response serialization result
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                if "\(response.result)" == "SUCCESS"{
                    showMessage(bodyText: "Class Unsubscribed",theme: .success)
                    self.classDict.remove(at: index)
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        self.notificationClassesTableView.reloadData()
                    }
                }
                else {
                    showMessage(bodyText: "Error",theme: .error)
                }
            }
        }
    }
    func getCurrentTimeZoneName() -> String {
        let localizedName = TimeZone.current.localizedName(for: .standard, locale: .current) ?? ""
        if let path = Bundle.main.path(forResource: "timezones", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonarry = try JSON(data: data)
                var setName = false
                // print("Json array: \(jsonarry)")
                for item in jsonarry.array ?? [] {
                    if localizedName == item["value"].stringValue{
                        setName = true
                        print("Localized name is \(localizedName)")
                        return item["abbr"].stringValue
                    }
                }
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        return localizedName
    }
}
