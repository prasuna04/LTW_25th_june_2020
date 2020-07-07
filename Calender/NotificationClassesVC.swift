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
    let loggedInUserID = UserDefaults.standard.string(forKey: "userID")
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
        
    }
    @IBAction func whiteBoardButton(_ sender : UIButton){
        
    }
    @IBAction func unsubscribeButton(_ sender : UIButton) {
        
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
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: "Icon awesome-chalkboard-teacher")
            let attachmentString = NSAttributedString(attachment: attachment)
            var myString = NSMutableAttributedString(string: i.teacherName) // Veeresh, please add tutor name in this empty space.
            myString.append(attachmentString)
            cell.tutorNameLabel.attributedText = myString
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
        
       // cell.tutorNameLabel.text = ""
       
        return cell

    }
    

    
   

}
