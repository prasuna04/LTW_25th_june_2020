//  AttendedOrDeliveredClassCells.swift
//  LTW
//  Created by vaayoo on 01/04/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import UIKit

class AttendedOrDeliveredClassCells: UITableViewCell {
    
    //Initialisation Starts Here.
    @IBOutlet weak var classTitleLabel : UILabel!
    @IBOutlet weak var subjectLabel : UILabel!
    @IBOutlet weak var subTopicLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var timeLabel : UILabel!
    @IBOutlet weak var PointsLabel : UILabel!
    @IBOutlet weak var numberofAttendeesInClassLabel : UILabel!
    @IBOutlet weak var publicOrPrivateClassButton : UIButton!
    
    @IBOutlet weak var subscribeOrExpiredButton : UIButton! {
        didSet {
            subscribeOrExpiredButton.backgroundColor = .clear
            subscribeOrExpiredButton.setTitleColor(.white, for: .normal)
            subscribeOrExpiredButton.layer.cornerRadius = (subscribeOrExpiredButton.bounds.height - 10) / 2
            subscribeOrExpiredButton.layer.borderWidth = 1
            subscribeOrExpiredButton.layer.borderColor = UIColor.init(hex: "2DA9EC").cgColor
            subscribeOrExpiredButton.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        }
    }
    @IBOutlet weak var reviewButton : UIButton! {
        didSet {
            reviewButton.backgroundColor = .clear
            reviewButton.layer.cornerRadius = (reviewButton.bounds.height - 10) / 2
            reviewButton.layer.borderWidth = 1
            reviewButton.layer.borderColor = UIColor.init(hex: "2DA9EC").cgColor
            reviewButton.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        }
    }
    @IBOutlet weak var gradesOffered: UILabel!
    //Initialisation Ends Here.
    
    //Variable Declaration starts Here.
    
    var cellDelegate : GroupCell?
    
    // Variable Declaration Ends Here.
    
    func updateCell(attendedOrDeliveredClassData : AttendedOrDeliveredClassData){
        
        let personType = Int(UserDefaults.standard.string(forKey: "persontyp")!) ?? 1
        
        classTitleLabel.text = attendedOrDeliveredClassData.classTitle.capitalizingFirstLetter()
        
        subjectLabel.text = subjects[attendedOrDeliveredClassData.classSubjectID - 1]
        
        subTopicLabel.text = getSubjectName(with: attendedOrDeliveredClassData.classSubTopicID)
        
        //        if let reqDate = getDate(date : attendedOrDeliveredClassData.classCommencingDate.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression) ) {
        //            dateLabel.text = reqDate
        //        }
        
        let startDate = serverToLocal(date : String(attendedOrDeliveredClassData.classCommencingDate.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)))
        dateLabel.text = DateHelper.formattDate(date: startDate!, toFormatt: "MMMM dd,yyyy")
        
        let endDate = serverToLocal(date : String(attendedOrDeliveredClassData.classEndtime.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)))
        
        timeLabel.text = "\(DateHelper.formattDate(date: startDate!, toFormatt: "h:mm a")) - \(DateHelper.formattDate(date: endDate!, toFormatt: "h:mm a"))"
        
        //        timeLabel.text = "\(attendedOrDeliveredClassData.classStartTime) - \(attendedOrDeliveredClassData.classEndtime)"
        
        PointsLabel.text = "\(attendedOrDeliveredClassData.pointsPerSubscriber)"
        
        if attendedOrDeliveredClassData.publicorPrivateID == 1{
            publicOrPrivateClassButton.isSelected = false
        }
        else if attendedOrDeliveredClassData.publicorPrivateID == 2 {
            publicOrPrivateClassButton.isSelected = true
        }
        //Code for Time Comparison starts here.
        
        //        let dateWithStartTime = "\(DateHelper.formattDate(date: DateHelper.getDateObj(from: attendedOrDeliveredClassData.classCommencingDate, fromFormat: "yyyy-MM-dd'T'HH:mm:ss"), toFormatt: "yyyy-MM-dd"))T\(attendedOrDeliveredClassData.classStartTime):00"
        //2020-03-19T17:10:00
        
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" //Your date format
        //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") //Current time zone
        //according to date format your date string
        
        //        guard let startDate = dateFormatter.date(from: dateWithStartTime) else {
        //            fatalError()
        //        }
        //        let dateWithEndTime = "\(DateHelper.formattDate(date: DateHelper.getDateObj(from: attendedOrDeliveredClassData.classCommencingDate, fromFormat: "yyyy-MM-dd'T'HH:mm:ss"), toFormatt: "yyyy-MM-dd"))T\(attendedOrDeliveredClassData.classEndtime):00"
        //        print(dateWithEndTime)
        
        //        guard let endDate = dateFormatter.date(from: dateWithEndTime) else {
        //            fatalError()
        //        }
        let date = Date()
//        if  date > startDate! && date < endDate! {
//            subscribeOrExpiredButton.alpha  = 1
//            reviewButton.alpha = 1
//            subscribeOrExpiredButton.isHidden = true
//            reviewButton.isHidden = true
//
//        }else
            if (date < startDate! && date < endDate!) || (date > startDate! && date < endDate!) {
                print("class will start later")
                if personType == 1
                {
                    subscribeOrExpiredButton.alpha  = 1
                    reviewButton.alpha = 0
                    
                    if attendedOrDeliveredClassData.isSubcribed == false && attendedOrDeliveredClassData.isClassFull == false {
                        //                    subscribeOrExpiredButton.isHidden  = false
                        subscribeOrExpiredButton.isUserInteractionEnabled = true
                        subscribeOrExpiredButton.setTitle("Subscribe", for: .normal)
                        subscribeOrExpiredButton.backgroundColor = UIColor.init(hexString: "60A200")
                        subscribeOrExpiredButton.setTitleColor(.white, for: .normal)
                    }
                    else if attendedOrDeliveredClassData.isSubcribed == true {
                        //                    subscribeOrExpiredButton.isHidden = false
                        subscribeOrExpiredButton.isUserInteractionEnabled = true
                        subscribeOrExpiredButton.setTitle("Unsubscribe", for: .normal)
                        subscribeOrExpiredButton.backgroundColor = .clear
                        subscribeOrExpiredButton.layer.borderColor = UIColor.init(hex: "2DA9EC").cgColor
                        subscribeOrExpiredButton.setTitleColor(.init(hex: "2DA9EC"), for: .normal)
                    }
                    if attendedOrDeliveredClassData.isClassFull == true {
                        //                    subscribeOrExpiredButton.isHidden  = false
                        subscribeOrExpiredButton.isUserInteractionEnabled = false
                        subscribeOrExpiredButton.setTitle("Class is Full", for: .normal)
                        subscribeOrExpiredButton.setTitleColor(.white, for: .normal)
                        subscribeOrExpiredButton.backgroundColor = .red
                    }
                    
                    
                }
                else if personType == 3 {
                    subscribeOrExpiredButton.isHidden = true
                    reviewButton.isHidden = true
                }
            }
            else if date > startDate! && date > endDate! {
                subscribeOrExpiredButton.isHidden = false
                print("class is expired")
                subscribeOrExpiredButton.isUserInteractionEnabled = false
                subscribeOrExpiredButton.setTitle("Expired", for: .normal)
                subscribeOrExpiredButton.backgroundColor = .red
                subscribeOrExpiredButton.setTitleColor(.white, for: .normal)
                reviewButton.alpha = 1
                reviewButton.isHidden = false
                
        }
        gradesOffered.text = attendedOrDeliveredClassData.grades
        
    }
    @IBAction func subcribeOrExpiredButtonAction(_ sender: UIButton) {
        if sender.currentTitle == "Subscribe"{
                cellDelegate?.onAcceptButton(index: sender.tag)
        }
        else if sender.currentTitle == "Unsubscribe"{
                cellDelegate?.onUnsubscribeButton(index: sender.tag)
        }
         //using protocol so using same function, but changing method body here.
    }
    @IBAction func reviewButtonAction(_ sender: UIButton) {
        cellDelegate?.onDeclineButton(index: sender.tag)  //using protocol so using same function, but changing method body here.
    }
}

extension AttendedOrDeliveredClassCells {
    func getDate(date : String) -> String? {  //Function for getting date in desired Format.
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date1 = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMMM dd,yyyy"
        dateFormatter.locale = tempLocale // reset the locale
        return dateFormatter.string(from: date1!)
    }
    func serverToLocal(date:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let localDate = dateFormatter.date(from: date)
        
        return localDate
    }
}

