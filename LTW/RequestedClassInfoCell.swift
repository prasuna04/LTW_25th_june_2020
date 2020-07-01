//  RequestedClassInfoCell.swift
//  LTW
//  Created by vaayoo on 04/03/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import UIKit

protocol GroupCell{
    func onAcceptButton(index : Int)
    func onDeclineButton(index :Int)
    func onUnsubscribeButton(index :Int)
}

class RequestedClassInfoCell: UITableViewCell {
    
    @IBOutlet weak var requesteeImg: UIImageView! {
        didSet {
            requesteeImg.setRounded()
            requesteeImg.layer.shadowColor = UIColor.gray.cgColor
            requesteeImg.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
            requesteeImg.layer.shadowRadius = 5.0
            requesteeImg.layer.shadowOpacity = 0.8
        }
    }
    @IBOutlet weak var grades: UILabel!
    @IBOutlet weak var dateConstantLbl: UILabel!
    @IBOutlet weak var timeConstantLbl: UILabel!
    
    @IBOutlet weak var requesteeNameLbl: UILabel!
    @IBOutlet weak var requesteeSchoolLbl: UILabel!
    @IBOutlet weak var requesteCreatedOnDateLbl: UILabel!
    
    @IBOutlet weak var classTitleLbl: UILabel!
    @IBOutlet weak var boardLbl: UILabel!
    @IBOutlet weak var subjectRequestedLbl: UILabel!
    @IBOutlet weak var topicRequestedLbl: UILabel!
    
    @IBOutlet weak var flexibleForAnyDateLbl: UILabel! {
        didSet {
            flexibleForAnyDateLbl.textColor = UIColor.init(hex: "60A200")
            flexibleForAnyDateLbl.isHidden = true
        }
    }
    
    @IBOutlet weak var classRequestedDateLbl: UILabel!
    @IBOutlet weak var requestedTimeDurationLbl: UILabel!
    @IBOutlet weak var requestedClassDescriptionLbl: UILabel!
    
    @IBOutlet weak var totalHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var flexibleLblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var acceptButton: UIButton! {
        didSet {
        acceptButton.backgroundColor = UIColor.init(hex: "60A200")
        acceptButton.layer.cornerRadius = acceptButton.frame.height / 2
        acceptButton.layer.borderWidth = 1
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.layer.borderColor = UIColor.init(hex: "60A200").cgColor
        }
    }
    
    @IBOutlet weak var declineButton: UIButton! {
        didSet {
            declineButton.backgroundColor = UIColor.init(hex: "DC200C")
            declineButton.layer.cornerRadius = acceptButton.frame.height / 2
            declineButton.layer.borderWidth = 1
            declineButton.setTitle("Decline", for: .normal)
            declineButton.layer.borderColor = UIColor.init(hex: "DC200C").cgColor
        }
    }
    
    var cellDelegate : GroupCell?
    var index : IndexPath?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: animated)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //populating cell.
    
    func updateCell(requestedClassInfoData : RequestedClassInfoData){
        
        if let url = URL(string : requestedClassInfoData.profileUrl){
            print("Deepak Kumar ",  url)
            let thumbnail = requestedClassInfoData.profileUrl.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
            requesteeImg.sd_setImage(with: URL.init(string:thumbnail ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
        }
        requesteeNameLbl.text = requestedClassInfoData.studentName.capitalizingFirstLetter()
        requesteeSchoolLbl.text = "\(requestedClassInfoData.school), \(requestedClassInfoData.state), \(requestedClassInfoData.country)"
        if let reqDate = getDate(date : requestedClassInfoData.requestedOn.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression) ) {
            requesteCreatedOnDateLbl.text = reqDate
        }
        
        classTitleLbl.text = requestedClassInfoData.classTitle.capitalizingFirstLetter()
        boardLbl.text = requestedClassInfoData.board
        subjectRequestedLbl.text = requestedClassInfoData.subject.capitalizingFirstLetter()
        topicRequestedLbl.text = requestedClassInfoData.subTopic.capitalizingFirstLetter()
        if requestedClassInfoData.startDate  == "" { // codes for "flexible for any date is true.
            flexibleForAnyDateLbl.isHidden = false
            classRequestedDateLbl.isHidden = true
            requestedTimeDurationLbl.isHidden = true
            dateConstantLbl.isHidden = true
            timeConstantLbl.isHidden = true
            totalHightConstraint.constant = 28 //dynamic resizing.
            
            
        }
        else {
            totalHightConstraint.constant = 112-23 // dynamic resizing.
            dateHeightConstraint.constant = 5 //
            flexibleForAnyDateLbl.isHidden = true
            classRequestedDateLbl.isHidden = false
            requestedTimeDurationLbl.isHidden = false
            
            dateConstantLbl.isHidden = false
            timeConstantLbl.isHidden = false
            
            classRequestedDateLbl.text = getDate(date : requestedClassInfoData.startDate.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression))
//            requestedTimeDurationLbl.text = "\(requestedClassInfoData.startTime) - \(requestedClassInfoData.endTime)"
            let fromTimingDate = self.serverToLocal(date: requestedClassInfoData.startDate)
            let toTimingDate = self.serverToLocal(date: requestedClassInfoData.endDate)
            
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
            
            //        dateLabel.text = "\(startTimeParts[0])"
            requestedTimeDurationLbl.text = "\(startTimeParts[1]) - \(endTimeParts[1])"
            let startTime: String = amAppend(str: String(startTimeParts[1]))
            let endTime:String = amAppend(str: String(endTimeParts[1]))
            
            requestedTimeDurationLbl.text = "\(startTime) - \(endTime)"
        }
        requestedClassDescriptionLbl.text = requestedClassInfoData.description
    }
    
    
    
    
    // functions for accept and decline buttons.
    @IBAction func acceptButtonClicked(_ sender: UIButton) {
        cellDelegate?.onAcceptButton(index: (index?.row)!)
    }
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        cellDelegate?.onDeclineButton(index: (index?.row)!)
    }
    
    
    
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
    func amAppend(str:String) -> String{
        var temp = str
        var strArr = str.characters.split{$0 == ":"}.map(String.init)
        var hour = Int(strArr[0])!
        let min = Int(strArr[1])!
        if(hour > 12 || hour == 12 ){
            
            if hour == 12 {}
            else{
                hour = hour - 12
            }
            
            // hour = hour - 12
            if hour == 0 {
                strArr[0] = "0\(hour)"
            }else{
                strArr[0] = "\(hour)"
                
            }
            if min < 10 {
                strArr[1] = "0\(min)"
            }else{
                strArr[1] = "\(min)"
                
            }
            
            temp = strArr[0] + ":" + strArr[1] + "PM"
            
            // temp = temp + "PM"
        }
        else{
            temp = temp + "AM"
        }
        return temp
    }
    func serverToLocal(date:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let localDate = dateFormatter.date(from: date)
        
        return localDate
    }
    
}


// extension for 1st letter capitalisation.
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

//extension for downloading Image.
extension UIImageView{
    func load(url: URL){
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf : url) {
                if let image = UIImage(data : data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
