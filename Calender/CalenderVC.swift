//  ViewController.swift
//  task7
//  Created by vaayoo on 18/01/20.
//  Copyright © 2020 Vaayoo. All rights reserved.

import UIKit
import Alamofire
import EventKit



public enum MyError: Error {
    case Duplicate
    case Insufficient
}
//let subjects = UserDefaults.standard.array(forKey: "subjectArray") as! [String]

//@available(iOS 13.0, *) /*  Added By Ranjeet on 27th March 2020 */
class CalenderVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MonthViewDelegate , UITableViewDelegate ,UITableViewDataSource {
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cellDate = "\(calculatedDate)-\(currentMonthIndex)-\(currentYear)".split(separator: "-")
        for i in 0..<cellDate.count{
            if cellDate[i].count == 1 {
                cellDate[i].insert("0", at: cellDate[i].startIndex)
            }
        }
        let date = "\(cellDate[0])-\(cellDate[1])-\(cellDate[2])"
        if dict.keys.contains(date) {
            return dict[date]!.count
        }
        return 0
    }
    func buttonSlectedState(button : UIButton){
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor.init(hex: "2DA9EC")
    }
    func buttonIsNotSelected(button : UIButton){
        button.tintColor = UIColor.init(hex: "2DA9EC")
        button.backgroundColor = UIColor.white
    }
    @IBOutlet weak var subNotification: UIView!{
        didSet{
            subNotification.layer.shadowOffset = .zero
            subNotification.layer.shadowColor = UIColor.black.cgColor
            subNotification.layer.shadowOpacity = 1
            subNotification.layer.cornerRadius = subNotification.frame.height/2
        }
    }
    @IBOutlet weak var tasksView : UIView!{
        didSet{
            tasksView.isHidden = true
        }
    }
    @IBOutlet weak var classesView : UIView! {
        didSet{
            classesView.isHidden = true
        }
    }
    
    
    
   @IBAction func onClickOfJoin(_ sender: UIButton) {
          let p : Int = Int(personTypeForCalendar!)!
        if p == 1 {
                    let endPoint = Endpoints.classStartedEndpoint + userID + "/" + "\(dict[selectedKey]![sender.tag].classId)"
                   actionName = "StudentJoin"
                    hitServer(params: [:], endPoint: endPoint ,action: actionName, httpMethod: .get)
                    
                    let hostURL = dict[selectedKey]![sender.tag].hostUrl
                    if hostURL == ""{
                    // showMessage(bodyText: "Not part of zoom meeting.. call.",theme:.warning,presentationStyle:.center,duration:.seconds(seconds: 0.2) )
                    showMessage(bodyText: "Not part of zoom meeting.. call.",theme: .warning)
                    return

                    }else if let url = NSURL(string:dict[selectedKey]![sender.tag].hostUrl){
                    UIApplication.shared.openURL(url as URL)


                    }
        }
        else {
            let endPoint = Endpoints.classStartedEndpoint + userID + "/" + "\(dict[selectedKey]![sender.tag].classId)"
            actionName = "TeacherJoin"
            hitServer(params: [:], endPoint: endPoint ,action: actionName, httpMethod: .get)
            let hostURL = dict[selectedKey]![sender.tag].hostUrl
            if hostURL == ""{
            // showMessage(bodyText: "Not part of zoom meeting.. call.",theme:.warning,presentationStyle:.center,duration:.seconds(seconds: 0.2) )
            showMessage(bodyText: "Not part of zoom meeting.. call.",theme: .warning)
            return

            }else if let url = NSURL(string:dict[selectedKey]![sender.tag].hostUrl){
            UIApplication.shared.openURL(url as URL)

            }
            print("hostURL: \(dict[selectedKey]![sender.tag].hostUrl)")
        }
    }
    
    @IBAction func onClickOfUnsub(_ sender: UIButton) {
        if NetworkReachabilityManager()?.isReachable ?? false {
                    //Internet connected,Go ahead
            
            let endPoint = Endpoints.unsubscribeClassEndPoint + userID + "/"  + "\(dict[selectedKey]![sender.tag].classId)"
                    actionName = "Classunsubscribe"
                    hitServer(params: [:], endPoint: endPoint ,action: actionName, httpMethod: .get)
                }else {
                    //NO Internet connection, just return
                    showMessage(bodyText: "No internet connection",theme: .warning)
                }
    }
     @IBAction func onClickOfWhiteBoard(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
                              return
                          }
        
               self.title = "Call"
               self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Call", style: .plain, target: nil, action: nil)
              // self.navigationItem.rightBarButtonItem?.isEnabled = false
               
               
               viewController.viewFinalImageButton.title = ""
               self.navigationController?.pushViewController(viewController, animated: true)

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellDate = "\(calculatedDate)-\(currentMonthIndex)-\(currentYear)".split(separator: "-")
        
        for i in 0..<cellDate.count{
            if cellDate[i].count == 1 {
                cellDate[i].insert("0", at: cellDate[i].startIndex)
            }
        }
        let date = "\(cellDate[0])-\(cellDate[1])-\(cellDate[2])"
        let dictObj = dict[date]![indexPath.row] as calenderEvents//dict[date]! as! calenderEvents
        if dictObj is LTWEvents {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventCell
            let arr  = dictObj as! LTWEvents
            cell?.topicLbl.text = arr.topic
            cell?.tittleLbl.text = arr.tittle
            cell?.gradeLbl.text = arr.grade
            
            cell?.timeLbl.text = "\(arr.startDate) TO \(arr.endDate)" //convertHourFormate(for: arr.startDate) + " To " + convertHourFormate(for: arr.endDate)         // "\(arr[indexPath.row].startDate) TO \(arr[indexPath.row].endDate)"
             let p : Int = Int(personTypeForCalendar!)!
            if p == 1 {
                cell?.unsubscribeBtn.isHidden = false
            }
            else { cell?.unsubscribeBtn.isHidden = true }
            cell?.unsubscribeBtn.tag = indexPath.row
            cell?.joinBtn.tag = indexPath.row
            
         
             let datef = DateFormatter()
            datef.dateFormat = "dd-MM-YYYY"
            print( dict[date]![indexPath.row].key == datef.string(from: Date()))
            if dict[date]![indexPath.row].key == datef.string(from: Date()) {
                datef.dateFormat = "h:mm a"
                if minutes(from: datef.date(from:  dict[date]![indexPath.row].startDate)!) >= -30 && minutes(from: datef.date(from:  dict[date]![indexPath.row].startDate)!) <= 30 {
                    cell?.joinBtn.isUserInteractionEnabled = true
                    cell?.joinBtn.backgroundColor = UIColor.init(hex:"60A200")
                    
                }
                else {
                    cell?.joinBtn.isUserInteractionEnabled = false
                    cell?.joinBtn.backgroundColor = UIColor.lightGray
                }
            }else {
                 cell?.joinBtn.isUserInteractionEnabled = false
                 cell?.joinBtn.backgroundColor = UIColor.lightGray
            }
            
            
            return cell!
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocalCell", for: indexPath) as? LocalCell
            let arr  = dictObj as! LocalEvents
            cell?.dateLbl.text = arr.key
            cell?.titleLbl.text = arr.tittle
            cell?.timeLbl.text = "\(arr.startDate) TO \(arr.endDate)"
             return cell!
        }
        //  ? ( dic as! LTWEvents) :( dic as! LocalEvents )
        //return UITableViewCell()
    }
    func minutes(from date: Date) -> Int {
       let datef = DateFormatter()
        datef.dateFormat = "h:mm a"
        let str = datef.string(from: Date())
       // datef.date
        return Calendar.current.dateComponents([.minute], from: date, to: datef.date(from: str)!).minute ?? 0
    }
    func convertHourFormate(for str: String)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        let date12 = dateFormatter.date(from: str)!
        dateFormatter.dateFormat = "h:mm a"
        let date22 = dateFormatter.string(from: date12)
        return String(date22)
    }
    func extractLocalEvent(startDate: Date ,endDate : Date ){
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event , completion:{ (granted, error) in
            if granted == true && error == nil {
                let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
                print(predicate)
                let existingEvents = eventStore.events(matching: predicate)
                print(existingEvents)
                for i in existingEvents {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-yyyy"
                    let date = formatter.string(from: i.startDate!)
                    formatter.dateFormat = "HH:mm"
                    let LocalObj = LocalEvents(title: i.title, startTime: self.convertHourFormate(for: formatter.string(from: i.startDate)), endTime: self.convertHourFormate(for: formatter.string(from: i.endDate)), note: "", key: date)
                    taskDict[date] = LocalObj 
                    if self.dict.keys.contains(date){
                        if !self.isEventPresent(self.dict[date]!, localEvent: LocalObj){
                             self.dict[date]!.append(LocalObj)
                        }
                       
                    }
                    else {
                        var arr = [calenderEvents]()
                        arr.append(LocalObj)
                        self.dict[date] = arr
                    }
                    
                }
                DispatchQueue.main.async {
                self.calender.reloadData()
                }
            }
        })
    }
    func isEventPresent(_ obj : [calenderEvents], localEvent : LocalEvents)->Bool{
        for i in obj {
            if i.tittle == localEvent.tittle //&& i.startDate == localEvent.startDate
            {
                return true
            }
        }
      return false
    }
    func addEventToCalendar(title: String, description: String, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil)
    {
        if title.isEmpty || description.isEmpty  {
            completion?(false,MyError.Insufficient as NSError )
            return
        }
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event , completion:{ (granted, error) in
            if granted == true && error == nil {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.notes = description
                event.endDate=endDate
                let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
                print(predicate)
                let existingEvents = eventStore.events(matching: predicate)
                print(existingEvents)
                for singleEvent in existingEvents {
                    if singleEvent.title == title || singleEvent.startDate == startDate || singleEvent.endDate > startDate {
                        print("event already there")
                        //someError = .Duplicate
                        completion?(false , MyError.Duplicate as NSError )
                        return
                    }
                }
                let aInterval: TimeInterval = -1 * 60
                let alaram = EKAlarm(relativeOffset: aInterval)
                event.alarms = [alaram]
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                }catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
                return
            }
            else {
                completion?(false, error as NSError?)
            }
        })
    }
    
    var actionName = ""
    var userID : String = "e15823cd-b931-46d6-b9ea-539d87196f64"
    var dict = Dictionary<String,[calenderEvents]>()
    var classDict =  Dictionary<String,[LTWEvents]>()
    var taskDict = Dictionary<String,[LocalEvents]>()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = register(DateCCell.self , forCellWithReuseIdentifier: "DateCCell") as! DateCCell
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "DateCCell", for: indexPath) as? DateCCell
        cell!.contentView.backgroundColor=UIColor.init(named: "background_Color")
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            cell!.isHidden=true
        } else {
            let  calcDate = indexPath.row-firstWeekDayOfMonth+2
            cell!.isHidden=false
            cell!.datelbl.text="\(calcDate)"
            var cellDate = "\(calcDate)-\(currentMonthIndex)-\(currentYear)".split(separator: "-")
            // print(cellDate)
            for i in 0..<cellDate.count{
                if cellDate[i].count == 1 {
                    cellDate[i].insert("0", at: cellDate[i].startIndex)
                }
            }
            let date = "\(cellDate[0])-\(cellDate[1])-\(cellDate[2])"
            if dict.keys.contains(date) {
                cell?.countLbl.isHidden = false
                print(dict[date]?.count ?? 1)
                cell?.countLbl.text = "\(dict[date]!.count )"
            }
            else{
                cell?.countLbl.isHidden = true
            }
            //print("\(calcDate)-\(currentMonthIndex)-\(currentYear)")
            if calcDate < todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex {
                cell!.isUserInteractionEnabled=false
                cell!.datelbl.textColor = UIColor.init(named: "gray_Color")
                 cell?.countLbl.isHidden = true
            } else {
                cell!.isUserInteractionEnabled=true
                /*  Updated By Ranjeet on 27th March - starts here */
                cell!.datelbl.textColor = UIColor.init(named: "white_black_color")
                /*  Updated By Ranjeet on 27th March - ends here */
            }
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7 - 8
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath) as! DateCCell
        cell.contentView.backgroundColor = UIColor.init(named: "background_Color")
        cell.datelbl.textColor = UIColor.init(named: "white_black_color")
         //lbl.textColor = UIColor.init(named: "white_black_color")
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath) as! DateCCell
        cell.contentView.backgroundColor = UIColor.init(hex: "2DA9EC")
        cell.datelbl.textColor = .white
        calculatedDate = indexPath.row-firstWeekDayOfMonth+2
       // let butn = cell?.contentView.subviews[1] as! UIButton
        
        var cellDate = "\(calculatedDate)-\(currentMonthIndex)-\(currentYear)".split(separator: "-")
               for i in 0..<cellDate.count{
                   if cellDate[i].count == 1 {
                       cellDate[i].insert("0", at: cellDate[i].startIndex)
                   }
               }
               let date = "\(cellDate[0])-\(cellDate[1])-\(cellDate[2])"
        selectedKey = date
        
        if cell.countLbl.isHidden {
            tableView.isHidden = true
        }
        else {
            tableView.isHidden = false
            DispatchQueue.global().sync {
                tableView.reloadData()
            }
        }
        // let lbl = cell?.subviews[0] //as! UILabel
    }
    func didChangeMonth(monthIndex: Int, year: Int) {
        currentMonthIndex=monthIndex+1
        currentYear = year
        
        //for leap year, make february month of 29 days
        if monthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 29
            } else {
                numOfDaysInMonth[monthIndex] = 28
            }
        }
        //end
        tableView.isHidden = true
        firstWeekDayOfMonth=getFirstWeekDay()
        
        calender.reloadData()
        //Mark ************************
        monthView.btnLeft.isEnabled = !(currentMonthIndex == presentMonthIndex && currentYear == presentYear)
    }
    func initializeView() {
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth=getFirstWeekDay()
        
        //for leap years, make february month of 29 days
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex-1] = 29
        }
        //end
        
        presentMonthIndex=currentMonthIndex
        presentYear=currentYear
        
        // setupViews()
        
        self.calender.delegate=self
        self.calender.dataSource=self
        //   myCollectionView.register(dateCVCell.self, forCellWithReuseIdentifier: "Cell")
    }
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        //return day == 7 ? 1 : day
        
        return day
    }
    func createDate(index : Int ,month : String,year : String)-> Date{
      //  let mon = index == 0 ? month :
        let date = "01-\(month)-\(year) 00:00"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: date)!
    }
    
    var selectedKey = ""
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0
    var calculatedDate = Int()
    let personTypeForCalendar = UserDefaults.standard.string(forKey: "persontyp")
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func navigationRight(_ sender: UIBarButtonItem ) {
        var count = Int()
        for (key , value) in dict.keys.enumerated(){
            print ("key \(key)  value \(value)")
            for i in dict[value]!{
                if i is LTWEvents{
//                    let startDateStr = "\(i.key/*.replacingOccurrences(of: "-", with: "/")*/) \(i.startDate)"
//                    let endDateStr = "\(i.key/*.replacingOccurrences(of: "-", with: "/")*/) \(i.endDate)"
//                    let dateFormatter =  DateFormatter()
                    //                dateFormatter.dateFormat = dateFormatter.string(from: Date()).contains("am") ? "dd-MM-yyyy h:mm a" : "dd-MM-yyyy h:mm a"
//                    dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
//                    dateFormatter.locale = Locale.current
//                    dateFormatter.timeZone = TimeZone.current
//                    let finalstartDate = dateFormatter.date(from: startDateStr)
//                    let finalEndDate = DateHelper.getDateObj(from: endDateStr, fromFormat: "dd-MM-yyyy h:mm a")
//                    let finalstartDate = dateFormatter.date(from: DateHelper.localToUTC(date: (i as! LTWEvents).UTCStartTime, fromFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "dd-MM-yyyy h:mm a"))
                    
                    let finalstartDate = UTCToLocal(date: (i as! LTWEvents).UTCStartTime)
//                    let finalEndDate = dateFormatter.date(from: DateHelper.localToUTC(date: (i as! LTWEvents).UTCEndTime, fromFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "dd-MM-yyyy h:mm a"))
                    let finalEndDate = UTCToLocal(date: (i as! LTWEvents).UTCEndTime)
                    let description =  i is LTWEvents ? "class on topic \((i as! LTWEvents).topic)" : ""
                    addEventToCalendar(title: i.tittle , description: description , startDate: finalstartDate!, endDate: finalEndDate!, completion: {(success , error) in
                        if success && error == nil {
                            count += 1
                        }
                    })
                    print("start at \(String(describing: finalstartDate))   and end \(String(describing: finalEndDate))")
                }
            }
                
        }
        print(count)
        self.calender.reloadData()
    }
    @IBOutlet weak var calender: UICollectionView!
    @IBOutlet weak var weekView: WeekView!
    @IBOutlet weak var monthView: MonthViews!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("running")
        initializeView()
        calender.translatesAutoresizingMaskIntoConstraints = false
        monthView.translatesAutoresizingMaskIntoConstraints=false
        weekView.translatesAutoresizingMaskIntoConstraints=false
        monthView.delegate=self
        tableView.delegate = self
        tableView.dataSource = self
        /* remove unwanted cells - starts here */
        self.tableView.tableFooterView = UIView()
        /* remove unwanted cells - ends here */
    }
  
    override func viewWillAppear(_ animated: Bool) {
        checkCalendarAuthorizationStatus(enterhereWhichSettingControlYouWant: "Calender")
        dict.removeAll()
        var endPoint = String()
        let p : Int = Int(personTypeForCalendar!)!
        if p  == 1 {
            endPoint = "\(Endpoints.subcribedClassEndPoint)\(userID)?searchText="
        }
        else {
            endPoint = "\(Endpoints.myClassesEndPoint)\(userID)?searchText="
        }
        fetchAPI(with: endPoint)
    }
    func createNewEvent(){
        
    }
    func checkCalendarAuthorizationStatus(enterhereWhichSettingControlYouWant : String) {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
//            requestAccessToCalendar()
            moveToSettings(enterhereWhichSettingControlYouWant: enterhereWhichSettingControlYouWant)
            print("not determind")
        case EKAuthorizationStatus.authorized:
            // Things are in line with being able to show the calendars in the table view
//            loadCalendars()
//            refreshTableView()
            print("authorized")
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            // We need to help them give us permission
//            needPermissionView.fadeIn()
            moveToSettings(enterhereWhichSettingControlYouWant: enterhereWhichSettingControlYouWant)
//            checkCalendarAuthorizationStatus()
            print("restricted")
        }
    }
    func moveToSettings(enterhereWhichSettingControlYouWant : String ){
        let alertController = UIAlertController(title: "Need \(enterhereWhichSettingControlYouWant) Permission.", message: "Please go to Settings and turn on the \(enterhereWhichSettingControlYouWant) permissions", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
             }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func UTCToLocal(date:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"

        let s = dateFormatter.string(from: dt!)
        return dateFormatter.date(from: s)
    }
    func serverToLocal(date:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let localDate = dateFormatter.date(from: date)
        return localDate
    }
    func fetchAPI(with str : String){
        let url = URL(string:str)
        Alamofire.request(url!).responseJSON{response in
            let result = response.result.value as? Dictionary<String,Any>
            // print(result)
            if result!["message"] as! String == "Success" && result!["error"] as! Bool == false {
                let ControlsData = result!["ControlsData"] as! Dictionary<String,Any>
                let ClassList = ControlsData["ClassList"] as! [Dictionary<String,Any>]
                print(ClassList.count)
                for items in ClassList {
                    var fromTimingDate: Date?
                    var toTimingDate: Date?
                    
                    fromTimingDate = self.serverToLocal(date: items["UTC_ClassDatetime"] as! String)
                    toTimingDate = self.serverToLocal(date: items["UTC_ClassEndtime"] as! String)
                    
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-yyyy HH:mm"
                    let fromTimingDateString = formatter.string(from: fromTimingDate!)
                    
                    let formatter1 = DateFormatter()
                    formatter1.dateFormat = "dd-MM-yyyy HH:mm"
                    let toTimingDateString = formatter1.string(from: toTimingDate!)
                    
                    let startTimeParts = fromTimingDateString.split(separator: " ")
                    let endTimeParts = toTimingDateString.split(separator: " ")
                    let date = "\(startTimeParts[0])"
//                    (DateHelper.formattDate(date: startDate!, toFormatt: "h:mm a")
                    let startTime: String = self.amAppend(str: String(startTimeParts[1])) // String(startTimeParts[1]) //
                    let endTime:String = self.amAppend(str: String(endTimeParts[1])) // String(endTimeParts[1]) //
                    print("Deepak",startTime)
                    print("Deepak",endTime)
                   // let date = self.serverToLocal(date: items["UTC_ClassDatetime"] as! String)//DateHelper.localToUTC(date: items["date"] as! String, fromFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "dd-MM-yyyy")
                    let calederEventObj = LTWEvents(title: items["title"] as? String ?? "" , topic: subjects[(items["SubjectID"] as! Int)-1] , grade: items["Grades"] as? String ?? "", startDate:  startTime , endDate : endTime , key : date, classId: items["Class_id"] as! Int, hostUrl: items["hostURL"] as? String ?? "", UTCStartTime : items["UTC_ClassDatetime"] as! String , UTCEndTime : items["UTC_ClassEndtime"] as! String)
                    classDict[date] = calederEventObj
                    if self.dict.keys.contains(date){
                        //let count = self.dict["date"]?.count
                        self.dict[date]!.append(calederEventObj)
                    }
                    else {
                        var arr = [calenderEvents]()
                        arr.append(calederEventObj)
                        self.dict[date] = arr
                    }
                    // dict[date] =
                }
            }
            else
            {
                print("failure while featching data")
            }
            let monthsToAdd = 6
            let now = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM"
            let nameOfMonth = dateFormatter.string(from: now)
            self.extractLocalEvent(startDate: self.createDate(index: 0, month: nameOfMonth , year: "2020"), endDate: Calendar.current.date(byAdding: .month, value: monthsToAdd, to: Date())!)
            self.calender.reloadData()
            self.tableView.reloadData()
        }
    }
    
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
                    self!.actionName = action
                    //after coming from the Zoom
                    if self!.actionName == "startClass" || self!.actionName == "Joinclass"{
                    }
                    else if _self.actionName == "unsubscribe" {
                        // showMessage(bodyText: msg,theme: .success) /*  Commented By Ranjeet on 19th March 2020 */
                        showMessage(bodyText: "You have unsubscribed from this class",theme: .success)  /*  Updated By Ranjeet on 19th March 2020 */
                        
                    }
                    
                }
                _self.dict.removeAll()
                var endPoint = String()
                let p : Int = Int(_self.personTypeForCalendar!)!
                if p  == 1 {
                    endPoint = "\(Endpoints.subcribedClassEndPoint)\(_self.userID)?searchText="
                }
                else {
                    endPoint = "\(Endpoints.myClassesEndPoint)\(_self.userID)?searchText="
                }
                _self.fetchAPI(with: endPoint)
                _self.tableView.reloadData()
            default : break
            }
            
            
        }
    }
}

extension CalenderVC {
    func amAppend(str:String) -> String{
           var temp = str
           var strArr = str.characters.split{$0 == ":"}.map(String.init)
           var hour = Int(strArr[0])!
           var min = Int(strArr[1])!
           if(hour > 12 || hour == 12 ){
               
               if hour == 12 {}
               else{
                   hour = hour - 12
               }
               // hour = hour - 12
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
               
               temp = strArr[0] + ":" + strArr[1] + " pm"
               
               // temp = temp + "PM"
           }
           else{
               temp = temp + " am"
           }
           return temp
       }
}

extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

//get date from string
extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}

class calenderEvents {
    init(title : String ,startDate : String,endDate : String ,key : String,classId : Int, hostUrl : String) {
        self.tittle=title
        self.startDate=startDate
        self.endDate=endDate
        self.key = key
        self.classId = classId
        self.hostUrl = hostUrl
    }
    var key : String
    var tittle : String
    var startDate : String
    var endDate : String
    var classId : Int
    var hostUrl : String
    
}

class LTWEvents: calenderEvents {
    var topic : String
    var grade : String
    var UTCStartTime : String
    var UTCEndTime : String
    init(title : String , topic : String ,grade : String,startDate : String,endDate : String ,key : String, classId : Int , hostUrl : String, UTCStartTime : String, UTCEndTime : String) {
        self.topic = topic
        self.grade = grade
        self.UTCEndTime = UTCEndTime
        self.UTCStartTime = UTCStartTime
        super.init(title: title,startDate: startDate,endDate: endDate,key: key, classId: classId, hostUrl: hostUrl)
    }
}
class LocalEvents : calenderEvents{
    var note : String
    init(title : String,startTime : String, endTime : String , note : String , key : String) {
        self.note = note
        super.init(title: title, startDate: startTime, endDate: endTime, key: key, classId: 0, hostUrl: "")
    }
}
