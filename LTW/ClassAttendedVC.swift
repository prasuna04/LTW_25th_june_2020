//  ClassAttendedVC.swift
//  LTW
//  Created by vaayoo on 10/02/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import UIKit
import Alamofire
import NVActivityIndicatorView


class ClassAttendedVC: UIViewController , UITableViewDelegate, UITableViewDataSource,NVActivityIndicatorViewable{
    
    var models = [classAttendeesModel]()
    
    @IBOutlet weak var tableView: UITableView!
    var userId = String()
    
    @IBAction func onReviewButtonPressed(_ sender: UIButton ) {
        let vc =  storyboard?.instantiateViewController(withIdentifier: "RateAndReviewVC") as! RateAndReviewVC
        vc.classId = models[sender.tag].classId
        vc.userId = userId
        vc.TutorUserID = models[sender.tag].userId
        print(models[sender.tag].classId)
        self.navigationController?.pushViewController(vc, animated: true )
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        updateNavigationController()
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchApi()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassAttendeesCell", for: indexPath) as! ClassAttendeesCell
        let model = models[indexPath.row]
        cell.title.text = model.title
        if model.subjectID <= 4 {
            cell.subject.text = subjects[model.subjectID-1]
        }else {
            cell.subject.text = "Invalid Subject Name"
        }
        cell.subCategory.text = getSubjectName(with:model.subSubjectID)
        cell.date.text = model.date
        cell.time.text = model.time
        cell.pointsEarned.text = String(model.pointsCharged)
        cell.noOfAttendees.text = String(model.noAttendees)
        cell.reviewButton.tag = indexPath.row
        return cell
    }
    func updateNavigationController() {
        navigationItem.title = "RATE AND REVIEW"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        if (self.navigationController?.navigationBar) != nil {
            navigationController?.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC") // making navigation bar color as blue
            navigationController?.view.backgroundColor = UIColor.init(hex:"2DA9EC")
            // to resolve black bar problem appears on navigation bar when pushing view controller
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func fetchApi(){
        models = [classAttendeesModel]()
        let   url=URL(string: Endpoints.classAttended + "\(userId)" + "?searchText=")
        print(url!)
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        Alamofire.request(url!).responseJSON { response in
            self.stopAnimating()
            let json =   response.result.value as! Dictionary<String,Any>
            print(json)
            if  json["message"] as! String == "Success" &&  json["error"]  as! Bool == false{
                let ControlsData = json["ControlsData"] as! Dictionary<String,Any>
                let lsv_classtutorinfo = ControlsData["lsv_classattended"] as! [Dictionary<String,Any>]
                for i in lsv_classtutorinfo{
                    let temp = classAttendeesModel(title: i["title"] as? String ?? "", subjectID: i["SubjectID"] as? Int ?? 0, subSubjectID: i["Sub_SubjectID"] as? Int ?? 0, timezone: i["timezone"] as? Int ?? 0, userId: i["UserID"] as? String ?? "", classId: i["Class_id"] as? Int ?? 0, pointsCharged: i["Pay_points"] as? Int ?? 0, noAttendees: i["num_Subscribed"] as? Int ?? 0, time: "\(String(describing: i["start_time"]!)) - \(String(describing: i["end_time"]!))", date: i["UTC_ClassDatetime"] as? String ?? "")
                    temp.date = DateHelper.localToUTC(date: temp.date , fromFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "dd-MMM-yyyy")
                    self.models.append(temp)
                }
            }
            self.tableView.reloadData()
        }
        
    }
}

class classAttendeesModel{
    var title : String
    var subjectID : Int
    var subSubjectID : Int
    var timezone : Int
    var userId : String
    var classId : Int
    var pointsCharged : Int
    var noAttendees : Int
    var time : String
    var date : String
    
    init(title : String, subjectID : Int, subSubjectID : Int, timezone : Int, userId : String, classId : Int, pointsCharged : Int, noAttendees : Int , time : String, date : String){
        self.title=title
        self.subjectID=subjectID
        self.subSubjectID=subSubjectID
        self.timezone=timezone
        self.userId=userId
        self.classId=classId
        self.pointsCharged=pointsCharged
        self.noAttendees=noAttendees
        self.time=time
        self.date=date
    }
}
