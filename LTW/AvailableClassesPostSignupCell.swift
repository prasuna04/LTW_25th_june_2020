//
//  AvailableClassesPostSignupCell.swift
//  LTW
//
//  Created by vaayoo on 22/04/20.
//  Copyright © 2020 vaayoo. All rights reserved.
//

import Foundation

class AvailableClassesPostSignupCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            profileImage.setRounded()
            profileImage.layer.shadowColor = UIColor.gray.cgColor
            profileImage.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
            profileImage.layer.shadowRadius = 5.0
            profileImage.layer.shadowOpacity = 0.8
        }
    }
    
    @IBOutlet weak var classCreateByLabel: UILabel!
    
    @IBOutlet weak var ratingsView: CosmosView!
    @IBOutlet weak var classTitleLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var subTopicLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var pointsChargedLabel: UILabel!
    @IBOutlet weak var numberOfAttendeesLabel: UILabel!
    
    @IBOutlet weak var publicPrivateButton: UIButton!
    
    @IBOutlet weak var subscribeButton: UIButton! {
        didSet {
            subscribeButton.backgroundColor = .clear
            subscribeButton.setTitleColor(.init(hex: "2DA9EC"), for: .normal)
            subscribeButton.layer.cornerRadius = (subscribeButton.bounds.height - 10) / 2
            subscribeButton.layer.borderWidth = 1
            subscribeButton.layer.borderColor = UIColor.init(hex: "2DA9EC").cgColor
            subscribeButton.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        }
    }
    @IBOutlet weak var gradesOffered: UILabel!
    
    func updateCell(availableClassesPostSignupData : AvailableClassesPostSignupData){
        if availableClassesPostSignupData.isClassFull == false {
            gradesOffered.text = availableClassesPostSignupData.grades
            if let url = URL(string : availableClassesPostSignupData.profileUrl){
                print("Deepak Kumar ",  url)
                let thumbnail = availableClassesPostSignupData.profileUrl.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
                profileImage.sd_setImage(with: URL.init(string:thumbnail ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
            }
            classCreateByLabel.text = availableClassesPostSignupData.teachersName
            // cell.ratingView.rating = dict["Rating"].intValue == 0 ? 2.5 : Double(dict["Rating"].intValue)/*
            ratingsView.rating = availableClassesPostSignupData.ratingsPoints
            classTitleLabel.text = availableClassesPostSignupData.classTitle
            subjectLabel.text = subjects[availableClassesPostSignupData.subjectId - 1]
            subTopicLabel.text = getSubjectName(with: availableClassesPostSignupData.subSubjectID)
            
            
            let fromTimingDate = self.serverToLocal(date: availableClassesPostSignupData.classStartDate)
            let toTimingDate = self.serverToLocal(date: availableClassesPostSignupData.classEndtime)
            
            let formatter = DateFormatter()
            // formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.dateFormat = "dd-MMM-yyyy HH:mm"
            let fromTimingDateString = formatter.string(from: fromTimingDate!)
            let startTimeParts = fromTimingDateString.split(separator: " ")
            
            let formatter1 = DateFormatter()
            // formatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter1.dateFormat = "dd-MMM-yyyy HH:mm"
            let toTimingDateString = formatter1.string(from: toTimingDate!)
            let endTimeParts = toTimingDateString.split(separator: " ")
            
            let reqDate = getDate(date : availableClassesPostSignupData.classStartDate.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression) )
            
            dateLabel.text = reqDate
            //        dateLabel.text = "\(startTimeParts[0])"
            //timeLabel.text = "\(startTimeParts[1]) - \(endTimeParts[1])"//commented by yasodha
            
            /*Added by yasodha 29/4/2020 starts here */
            let startTime: String = amAppend(str: String(startTimeParts[1]))
            let endTime:String = amAppend(str: String(endTimeParts[1]))
            
            timeLabel.text = "\(startTime) - \(endTime)"
            /*Added by yasodha 29/4/2020 */
            
            pointsChargedLabel.text = "\(availableClassesPostSignupData.pointsPerSubscriber)"
          //  numberOfAttendeesLabel.text = "\(availableClassesPostSignupData.numberOfSubscriber)"
            if availableClassesPostSignupData.pointsPerSubscriber == 0 {
                     pointsChargedLabel.textColor = UIColor.init(hex: "7DC20B")
                     pointsChargedLabel.text = "Free"
                     }else {
                     pointsChargedLabel.textColor = UIColor.init(hex: "2DA9EC")
                     pointsChargedLabel.text = "\(availableClassesPostSignupData.pointsPerSubscriber)"
                     }
            if availableClassesPostSignupData.publicorPrivateID == 1{
                publicPrivateButton.isSelected = false
            }
            else if availableClassesPostSignupData.publicorPrivateID == 2 {
                publicPrivateButton.isSelected = true
            }
            if availableClassesPostSignupData.isClassFull == true {
                subscribeButton.isUserInteractionEnabled = false
                subscribeButton.setTitle("Class is Full", for: .normal)
                subscribeButton.setTitleColor(.white, for: .normal)
                subscribeButton.backgroundColor = .red
            }else if availableClassesPostSignupData.isClassFull == false{
                subscribeButton.isUserInteractionEnabled = true
                subscribeButton.backgroundColor = .clear
                subscribeButton.setTitle("Subscribe", for: .normal)
                subscribeButton.setTitleColor(.init(hex: "2DA9EC"), for: .normal)
                subscribeButton.layer.cornerRadius = (subscribeButton.bounds.height - 10) / 2
                subscribeButton.layer.borderWidth = 1
                subscribeButton.layer.borderColor = UIColor.init(hex: "2DA9EC").cgColor
                subscribeButton.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
            }
        }
    }
}

extension AvailableClassesPostSignupCell {
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
    /*Added by yasodha 29/4/2020 starts here */
    func amAppend(str:String) -> String{
        var temp = str
        var strArr = str.characters.split{$0 == ":"}.map(String.init)
        var hour = Int(strArr[0])!
        var min = Int(strArr[1])!
        if(hour > 12){
            
            hour = hour - 12
            if hour == 0 {
                strArr[0]  = "0\(hour)"
            }else{
                strArr[0]  = "\(hour)"
                
            }
            if min < 10 {
                strArr[1]  = "0\(min)"
            }else{
                strArr[1]  = "\(min)"
                
            }
            
            temp = strArr[0] + ":" + strArr[1] + "PM"
            
            // temp = temp + "PM"
        }
        else{
            temp = temp + "AM"
        }
        return temp
    }
    /*Added by yasodha 29/4/2020 ends here */
}
