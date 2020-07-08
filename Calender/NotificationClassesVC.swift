//
//  NotificationClasses.swift
//  LTW
//
//  Created by vaayoo on 01/07/20.
//  Copyright © 2020 vaayoo. All rights reserved.
//

import UIKit
import Alamofire
class NotificationClassesVC: UIViewController, UITableViewDataSource, UITableViewDelegate{

    
    @IBOutlet weak var notificationClassesTableView : UITableView!
    var classDict : [LTWEvents]!
    let personType = UserDefaults.standard.string(forKey: "persontyp")
    let userID = UserDefaults.standard.string(forKey: "userID")
    var actionName : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationClassesTableView.delegate = self
        notificationClassesTableView.dataSource = self
        notificationClassesTableView.reloadData()
        print(classDict)
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    @IBAction func joinButton(_ sender : UIButton){
        let p : Int = Int(personType!)!
        if p == 1 {
            let endPoint = Endpoints.classStartedEndpoint + userID! + "/" + "\(classDict[sender.tag].classId)"
            actionName = "StudentJoin"
            hitServer(params: [:], endPoint: endPoint ,action: actionName, httpMethod: .get)
            let hostURL = classDict[sender.tag].hostUrl
            if hostURL == ""{
                // showMessage(bodyText: "Not part of zoom meeting.. call.",theme:.warning,presentationStyle:.center,duration:.seconds(seconds: 0.2) )
                showMessage(bodyText: "Not part of zoom meeting.. call.",theme: .warning)
                return
            }else if let url = NSURL(string:classDict[sender.tag].hostUrl){
                UIApplication.shared.openURL(url as URL)
            }
        }
        else {
            let endPoint = Endpoints.classStartedEndpoint + userID! + "/" + "\(classDict[sender.tag].classId)"
            actionName = "TeacherJoin"
            hitServer(params: [:], endPoint: endPoint ,action: actionName, httpMethod: .get)
            let hostURL = classDict[sender.tag].hostUrl
            if hostURL == ""{
                // showMessage(bodyText: "Not part of zoom meeting.. call.",theme:.warning,presentationStyle:.center,duration:.seconds(seconds: 0.2) )
                showMessage(bodyText: "Not part of zoom meeting.. call.",theme: .warning)
                return
                
            }else if let url = NSURL(string:classDict[sender.tag].hostUrl){
                UIApplication.shared.openURL(url as URL)
                
            }
            print("hostURL: \(classDict[sender.tag].hostUrl)")
        }
    }
    @IBAction func whiteBoardButton(_ sender : UIButton){
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
            return
        }
        self.title = "Call"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // self.navigationItem.rightBarButtonItem?.isEnabled = false
        viewController.viewFinalImageButton.title = ""
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    var unsubSuccess : Int!
    @IBAction func unsubscribeButton(_ sender : UIButton) {
        if NetworkReachabilityManager()?.isReachable ?? false {
            //Internet connected,Go ahead
            let endPoint = Endpoints.unsubscribeClassEndPoint + userID! + "/" + "\(classDict[sender.tag].classId)"
            actionName = "Classunsubscribe"
            hitServer(params: [:], endPoint: endPoint ,action: actionName, httpMethod: .get)
            if unsubSuccess == 1 {
                classDict.remove(at: sender.tag)
                notificationClassesTableView.reloadData()
            }
        }else {
            //NO Internet connection, just return
            showMessage(bodyText: "No internet connection",theme: .warning)
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classDict.count
//        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let i = classDict[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationClassesCell", for: indexPath) as! NotificationClassesCell
        if personType == "1"{ //student
            cell.subscribeUnsubscribeButton.isHidden = false
            cell.tutorNameLabel.isHidden = false
            // Attachment for tutor whiteboard image befor tutor name.
            let teacherFirstName = (i.teacherName).split(separator: " ")
//            let attachment = NSTextAttachment()
//            attachment.image = UIImage(named: "Icon awesome-chalkboard-teacher")
//            let attachmentString = NSAttributedString(attachment: attachment)
//        let myString = NSMutableAttributedString(string: String(teacherFirstName[0]))
//            let addedString = attachmentString+ "\(myStrinf)"
            cell.tutorNameLabel.text = String(teacherFirstName[0])
        }else{
            cell.subscribeUnsubscribeButton.isHidden = true
            cell.tutorNameLabel.isHidden = true
            cell.tutorNameLabel.text = ""
        }
        cell.classTitle.text = i.tittle
        cell.classDate.text = i.key
        cell.grades.text = i.grade
        cell.timings.text = "\(i.startDate) To \(i.endDate)"
        cell.subject.text = i.topic
        cell.joinButton.tag = indexPath.row
        cell.whiteboardButton.tag = indexPath.row
        cell.subscribeUnsubscribeButton.tag = indexPath.row
        return cell
    }
    
    //HitServer Function Goes Here.
    func hitServer(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        self.unsubSuccess = 0
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
                        _self.unsubSuccess = 1
                        showMessage(bodyText: "You have unsubscribed from this class",theme: .success)  /*  Updated By Ranjeet on 19th March 2020 */
                    }
                }
            default : break
            }
            
            
        }
    }
    
    

    
   

}
