//
//  NotificationClasses.swift
//  LTW
//
//  Created by vaayoo on 01/07/20.
//  Copyright © 2020 vaayoo. All rights reserved.
//

import UIKit

class NotificationClassesVC: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var classDict =  [LTWEvents]()
     let personTypeForCalendar = UserDefaults.standard.string(forKey: "persontyp")
    @IBOutlet weak var notificationClassesTableView : UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        notificationClassesTableView.reloadData()
        print(classDict)
    }
    @IBAction func joinButton(_ sender : UIButton){
         let p : Int = Int(personTypeForCalendar!)!
        if p == 1 {
                    let endPoint = Endpoints.classStartedEndpoint + userID + "/" + "\(classDict[sender.tag].classId)"
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
            let endPoint = Endpoints.classStartedEndpoint + userID + "/" + "\(classDict[sender.tag].classId)"
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
    @IBAction func unsubscribeButton(_ sender : UIButton) {
         if NetworkReachabilityManager()?.isReachable ?? false {
                    //Internet connected,Go ahead
            
            let endPoint = Endpoints.unsubscribeClassEndPoint + userID + "/"  + "\(classDict[sender.tag].classId)"
                    actionName = "Classunsubscribe"
                    hitServer(params: [:], endPoint: endPoint ,action: actionName, httpMethod: .get)
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
        cell.classTitle.text = i.tittle
        cell.classDate.text = i.key
        cell.grades.text = i.grade
        cell.timings.text = "\(i.startDate) TO \(i.endDate)"
        cell.subject.text = i.topic
        cell.joinButton.tag = indexPath.row
        cell.whiteboardButton.tag = indexPath.row
        cell.subscribeUnsubscribeButton.tag = indexPath.row
       // cell.tutorNameLabel.text = ""
        // Attachment for tutor whiteboard image befor tutor name.
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "Icon awesome-chalkboard-teacher")
        let attachmentString = NSAttributedString(attachment: attachment)
        var myString = NSMutableAttributedString(string: " Deepak") // Veeresh, please add tutor name in this empty space.
        myString.append(attachmentString)
        cell.tutorNameLabel.attributedText = myString
        return cell

    }

    
   

}
