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
        cell.classTitle.text = i.tittle
        cell.classDate.text = i.key
        cell.grades.text = i.grade
        cell.timings.text = "\(i.startDate) TO \(i.endDate)"
        cell.subject.text = i.topic
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
