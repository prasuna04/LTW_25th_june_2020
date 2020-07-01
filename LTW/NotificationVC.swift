import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView
import SwiftyJSON

/* Added By Chandra on 3rd Jan 2020 - starts here */
protocol notification:class {
    func ststus(reviewans:Int)
}
/* Added By Chandra on 3rd Jan 2020 - ends here */

class NotificationVC: UIViewController, NVActivityIndicatorViewable,UIGestureRecognizerDelegate {
    var notificationclick : Bool! //Added By Chandra on 3rd Jan 2020
    var storedNotificationids = [Int]()
    var finalStoredNotificationids = [Int]()
    var indexPath2:Int!
    var deletecheck:Bool!
    var NotificationID:Int!
    var removeAllcheck:Int!
    var viewDisappear:Int!
    var isTaken:Int!
    
    @IBOutlet weak var hightConstraintForTableView: NSLayoutConstraint!
    @IBOutlet weak var removeAllOutlet: UIButton!
    @IBOutlet weak var notificationTabelView: UITableView!
    private let userID = UserDefaults.standard.string(forKey: "userID")
    let personType = UserDefaults.standard.string(forKey: "persontyp")!//Added by yasodha
    
    private var notificationList = [JSON]() {
        didSet {
            notificationTabelView.reloadData()
        }
    }
    weak var delegate: notification? //Added By Chandra on 3rd Jan 2020
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem?.title = "" // add by chandra
        super.viewDidLoad()
        hightConstraintForTableView.constant = 40
        removeAllOutlet.isHidden = true
        
        /* Added By Chandra on 3rd Jan 2020 - starts here */
        for viewContoller in self.navigationController!.viewControllers as Array {
            if  viewContoller.isKind(of: NotificationVC.self) {
                self.navigationController?.popToViewController(viewContoller, animated: true)
            }
        }
        
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        self.notificationTabelView.addGestureRecognizer(longPressGesture)
        
        /* Added By Chandra on 3rd Jan 2020 - ends here */
        
        let count = self.navigationController?.viewControllers.count
        print(" viewControllers count in notification form = \(count!)")
        if count == 1 {// Add explicit back button
            let backBtn = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(onBackClick(sender:)))
            navigationItem.leftBarButtonItem = backBtn
        }
        let deleteBarButton = UIBarButtonItem(title: "", style: .plain, target:self, action: #selector(DeleteSelectedNotification))
        self.navigationItem.rightBarButtonItem = deleteBarButton
        
        if NetworkReachabilityManager()?.isReachable ?? false {
            //Internet connected,Go ahead
            let endPoint: String = "\(Endpoints.notificationListUrl)\(userID!)"
            hitServer(params: [:], endPoint: endPoint ,action: "getAllTestList", httpMethod: .get)
            
        }else {
            //NO Internet connection, just return
            showMessage(bodyText: "No internet connection",theme: .warning)
        }
    }
    
    
    @IBAction func removeAllBtn(_ sender: Any) {
        
        if removeAllOutlet.isSelected == false{
            for i in notificationList{
                removeAllOutlet.isSelected = true
                let notificationID = i["NotificationID"].intValue
                finalStoredNotificationids.append(notificationID)
                storedNotificationids.append(notificationID)
                
                removeAllcheck = 3
                self.navigationItem.rightBarButtonItem?.title = "Remove All"
            }
        }else{
            finalStoredNotificationids.removeAll()
            storedNotificationids.removeAll()
            removeAllOutlet.isSelected = false
            removeAllcheck = 2
            self.navigationItem.rightBarButtonItem?.title = "Delete"
            
        }
        notificationTabelView.reloadData()
    }
    @objc func DeleteSelectedNotification(){
        if finalStoredNotificationids.count  == 0{
            showMessage(bodyText: "Ateleast select one",theme:.warning,presentationStyle:.top,duration:.seconds(seconds: 0.2) )
        }else{
            let finalStoredNotificationidsRemoveDuplicates = Array(Set(finalStoredNotificationids))
            let array = finalStoredNotificationidsRemoveDuplicates
            let seperatorint = array.map(String.init).joined(separator:",")
            let deleteEndpont = Endpoints.deleteNotification + (userID ?? "") + "?ListOfIDs=" + seperatorint
            hitServer(params: [:], endPoint: deleteEndpont, action: "deleteNotifacition", httpMethod: .get)
        }
        deletecheck = true
        removeAllOutlet.isSelected = false
        
    }
    
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        self.navigationItem.rightBarButtonItem?.title = "Delete"// add by chandra
        hightConstraintForTableView.constant = 25
        removeAllOutlet.isHidden = false
        notificationTabelView.allowsSelection = false
        let p = longPressGesture.location(in: self.notificationTabelView)
        let indexPath = self.notificationTabelView.indexPathForRow(at: p)
        if indexPath == nil {
            print("Long press on table view, not row.")
        } else if longPressGesture.state == UIGestureRecognizer.State.began {
            print("Long press on row, at \(indexPath!.row)")
            indexPath2 = indexPath!.row
            let cell = notificationTabelView.cellForRow(at: indexPath!) as! NotificationCell
            cell.checkBox.isSelected = true
            let dict = notificationList[indexPath!.row]
            let NotificationID = dict["NotificationID"].intValue
            storedNotificationids.append(NotificationID)
            finalStoredNotificationids = Array(Set(storedNotificationids))
            notificationTabelView.reloadData()
            
        }
    }
    @objc func onBackClick(sender: UIBarButtonItem) {
        UIApplication.shared.keyWindow?.rootViewController = nil
        UIApplication.shared.keyWindow?.rootViewController = VSCore().launchHomePage(index: 0)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.navigationController?.navigationBar) != nil {
            navigationController?.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
            navigationController?.view.backgroundColor = UIColor.init(hex: "2DA9EC") // to resolve black bar problem appears on navigation bar when pushing view controller
        }
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Notification"
        notificationTabelView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        let endPoint: String = "\(Endpoints.notificationListUrl)\(userID!)"
        hitServer(params: [:], endPoint: endPoint ,action: "getAllTestList", httpMethod: .get)
    }
    override func viewDidDisappear(_ animated: Bool) {
        viewDisappear = 1
        
        
    }
    @objc func chechBoxSelectAndDelect(sender: UIButton){
        let dict1 = notificationList[sender.tag]
        let NotificationID = dict1["NotificationID"].intValue
        if sender.isSelected{
            if finalStoredNotificationids.contains(NotificationID){
                finalStoredNotificationids.remove(at:finalStoredNotificationids.index(of: NotificationID)! )
                storedNotificationids.remove(at:storedNotificationids.index(of: NotificationID)! )
            }
            
        }else{
            storedNotificationids.append(NotificationID)
            finalStoredNotificationids = Array(Set(storedNotificationids))
            print(storedNotificationids.count)
            print(finalStoredNotificationids.count)
        }
        
        notificationTabelView.reloadData()
    }
    func updateNotification(NotificationID:Int){
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            let exiturl = Endpoints.notificationUpdate + "\(NotificationID)"
            Alamofire.request(exiturl , method: .get, parameters: nil , encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response)
                    DispatchQueue.main.async{

                    }
            }
        }
        
    }
    @objc func ImgTapped(sender:AnyObject){
        let index = notificationList[sender.view.tag]
        let userId = index["SentBy"].stringValue
        let vc = storyboard?.instantiateViewController(withIdentifier: "personalprofile") as! PersonalProfileVC
        vc.userID = userId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension NotificationVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationcell") as! NotificationCell
        let indexChuck = indexPath.row
        //        add by chandra for remove all
        if removeAllcheck == 3{
            cell.checkBox.isSelected = true
        }else{
            
        }
        
        let dict = notificationList[indexPath.row]
        if finalStoredNotificationids.count > 0{
            cell.checkBox.isHidden = false
            
        }else{
            navigationItem.rightBarButtonItem?.title = "" // add by chandra
            notificationTabelView.allowsSelection = true // add by chandra
            cell.checkBox.isHidden = true
            UIView.animate(withDuration: 0.12) {[unowned self] in
                self.hightConstraintForTableView.constant = -15
            }
            removeAllOutlet.isHidden = true
        }
        if indexChuck == indexPath2{
            cell.checkBox.isSelected = true
        }else{
            cell.checkBox.isSelected = false
        }
        let NotificationID = dict["NotificationID"].intValue
        if finalStoredNotificationids.contains(NotificationID){
            cell.checkBox.isSelected = true
            
        }else{
            cell.checkBox.isSelected = false
        }
        cell.checkBox.tag = indexPath.row
        cell.checkBox.addTarget(self, action: #selector(chechBoxSelectAndDelect), for: .touchUpInside)
        // add by chandra on 30 apr 2020 start here to
        var isreadcheco = dict["isRead"].boolValue
        if isreadcheco == false{
            cell.activeLbl.backgroundColor = .red
            
        print("call end point")
        }else{
            cell.activeLbl.backgroundColor = .green
            
        print("dont call end point")
        }
       // add by chandra on 30 apr 2020 ends here to
        /* Thumbnail related image Added By Ranjeet - From Here */
        
        let stringUrl = dict["ProfileURL"].stringValue
        let thumbnail = stringUrl.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
        cell.profileImageView?.sd_setImage(with: URL.init(string:thumbnail ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
        
        /* Thumbnail related image Added By Ranjeet - Till Here */
        
        /* Mukesh Code - From Here(Don't delete, cause  future might reuse)
         cell.profileImageView.sd_setImage(with: URL.init(string: dict["ProfileURL"].stringValue),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
         Mukesh Code - Till Here(Don't delete, cause  future might reuse) */
        
        /* Don't delete below note , it's a very strict warning to follow without commit this mistake once again in future.
         note: Don't load the image in DispatchQueue.main.async(){} cause it's freezing the UI most of the times and one more thing SDWebImage only handling all the threading related functionality in their own way. */
        
        cell.messageLabel.attributedText = getAttributedString(htmlString: dict["NotificationMessage"].stringValue)
        cell.messageLabel.font = UIFont(name:"Roboto-Medium", size: 14.0)
        
        /* Added By Ranjeet on 16th April 2020 - starts here */
        if #available(iOS 13.0, *) {
            cell.messageLabel.textColor = .label
        } else {
            // Fallback on earlier versions
        }
        /* Added By Ranjeet on 16th April 2020 - ends here */
        
        if let date = UTCToLocal(str: dict["SentDate"].stringValue){
            cell.messageTimeLabler.text = Date.getElapsedInterval(date)()
        }else {
            cell.messageTimeLabler.text = ""
        }
        let gasture = UITapGestureRecognizer(target: self, action: #selector(ImgTapped))
        cell.profileImageView.isUserInteractionEnabled = true
        cell.profileImageView.tag = indexPath.row
        cell.profileImageView.addGestureRecognizer(gasture)
        return cell
    }
    /* Added By ChandraShekhar on 31st Jan 2020 - stars here */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let dict = notificationList[indexPath.row]
        let NotificationID = dict["NotificationID"].intValue
        let deleteEndpont = Endpoints.deleteNotification + (userID ?? "") + "?ListOfIDs=" + "\(NotificationID)"
        hitServer(params: [:], endPoint: deleteEndpont, action: "deleteNotifacition", httpMethod: .get)
    }
    /* Added By ChandraShekhar on 31st Jan 2020 - ends here */
}
extension NotificationVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = notificationList[indexPath.row]
        let type = dict["Type"].intValue
        let uniqueID = dict["UniqueID"].stringValue
        switch type {
        case 1:
            var isreadcheco = dict["isRead"].boolValue
            if isreadcheco == false{
                let notificationID = dict["NotificationID"].intValue
                 updateNotification(NotificationID: notificationID)
             print("call end point")
            }else{
                print("dont call end point")
            }
            // add by chandra for infogroup on 17 mar 2020
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "GroupInfoViewController") as! GroupInfoViewController
            vc.discussionid = dict["UniqueID"].stringValue
            vc.userid = dict["SentBy"].stringValue
            vc.imgeurl = dict["ProfileURL"].stringValue
            vc.prasentIndex = 2
            navigationController?.pushViewController(vc, animated: true)
            
            
            
            
            break
        case 2:
            /*Added by yasodha 8/4/20202 starts here */
            if personType == "1"{
                
               let url = URL(string: Endpoints.HasTakenTest + dict["UniqueID"].stringValue + "/" + self.userID!)

                Alamofire.request(url!).responseJSON{ response in
                let isTakenDict = response.result.value as! Dictionary<String,Any>
                let controlsData = isTakenDict["ControlsData"] as? [String:Any]
                self.isTaken = controlsData!["IsTaken"] as! Int
                self.DetailsFunction(dict: dict)

                }



                // if notificationclick == true || self.isTaken == 1 {//

                // if self.isTaken == 1 {
                // var isreadcheco = dict["isRead"].boolValue
                // if isreadcheco == false{
                // let notificationID = dict["NotificationID"].intValue
                // updateNotification(NotificationID: notificationID)
                // print("call end point")
                // }else{
                // print("dont call end point")
                // }
                //
                // let attandTestVC1 = storyboard?.instantiateViewController(withIdentifier: "reviewtestvc") as! ReviewTestVC
                // attandTestVC1.testID = uniqueID
                // delegate?.ststus(reviewans: 1)
                // //attandTestVC.testDuration = self.tableViewDataSource[sender.tag]["Duration"].stringValue
                //
                // // attandTestVC.testDuration = "1:0"
                // navigationController?.pushViewController(attandTestVC1, animated: true)
                // }else if self.isTaken == 0 {
                //
                // var isreadcheco = dict["isRead"].boolValue
                // if isreadcheco == false{
                // let notificationID = dict["NotificationID"].intValue
                // updateNotification(NotificationID: notificationID)
                // print("call end point")
                // }else{
                // print("dont call end point")
                // }
                // let attandTestVC = storyboard?.instantiateViewController(withIdentifier: "answertestvc") as! AttandTestVC
                // attandTestVC.testID = uniqueID
                // //attandTestVC.testDuration = self.tableViewDataSource[sender.tag]["Duration"].stringValue
                // notificationclick = true
                // attandTestVC.testDuration = "1:0"
                // navigationController?.pushViewController(attandTestVC, animated: true)
                // }
            }else{
                var isreadcheco = dict["isRead"].boolValue
                if isreadcheco == false{
                    let notificationID = dict["NotificationID"].intValue
                     updateNotification(NotificationID: notificationID)
                 print("call end point")
                }else{
                    print("dont call end point")
                }
                /*Added by yasodha 7/3/2020 starts here */
                let soryboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard?.instantiateViewController(withIdentifier: "ReviewAnswerVC") as! ReviewAnswerVC
                vc.isNotificationOn = true
                vc.testIdFrmNotification = uniqueID
                vc.userIDFrmNotification = dict["SentBy"].stringValue
                self.navigationController?.pushViewController(vc, animated: true)
                
                /*Added by yasodha 7/3/2020 ends here */
            }
            
            /*Added by yasodha 8/4/20202 ends here */
            
            
            
            break
        case 3:
            var isreadcheco = dict["isRead"].boolValue
            if isreadcheco == false{
                let notificationID = dict["NotificationID"].intValue
                 updateNotification(NotificationID: notificationID)
             print("call end point")
            }else{
                print("dont call end point")
            }
            let myclass = storyboard?.instantiateViewController(withIdentifier: "myclassvc") as! MyClassVC
            myclass.notificationInt = 2
            navigationController?.pushViewController(myclass, animated: true)
            break
        case 4:
            var isreadcheco = dict["isRead"].boolValue
            if isreadcheco == false{
                let notificationID = dict["NotificationID"].intValue
                 updateNotification(NotificationID: notificationID)
             print("call end point")
            }else{
                print("dont call end point")
            }
            let ansWersVC = storyboard?.instantiateViewController(withIdentifier: "answer") as! AnswersVC
            ansWersVC.questionID = uniqueID
            navigationController?.pushViewController(ansWersVC, animated: true)
            break
            /* Added By Ranjeet on 23rd Feb 2020 - starts here */
        case 5:
            break
        case 6:
            var isreadcheco = dict["isRead"].boolValue
            if isreadcheco == false{
                let notificationID = dict["NotificationID"].intValue
                 updateNotification(NotificationID: notificationID)
             print("call end point")
            }else{
                print("dont call end point")
            }
            /*Added by yasodha 7/4/2020 starts here */
            let vc = storyboard?.instantiateViewController(withIdentifier: "MyFollowUseer2ViewController") as! MyFollowUseer2ViewController
            navigationController?.pushViewController(vc, animated: false)
            /*Added by yasodha 7/4/2020 ends here */
            break
        case 7:
            break
        case 8:
            var isreadcheco = dict["isRead"].boolValue
            if isreadcheco == false{
                let notificationID = dict["NotificationID"].intValue
                 updateNotification(NotificationID: notificationID)
             print("call end point")
            }else{
                print("dont call end point")
            }
            let CreateNewClassForTeacherNotificationVC = storyboard?.instantiateViewController(withIdentifier: "CreateNewClassForTeacherNotificationVC") as! CreateNewClassForTeacherNotificationVC
            CreateNewClassForTeacherNotificationVC.uniqueID = uniqueID
            navigationController?.pushViewController(CreateNewClassForTeacherNotificationVC, animated: true)
            break
        case 9:// can you copy and send in skype
            var isreadcheco = dict["isRead"].boolValue
            if isreadcheco == false{
                let notificationID = dict["NotificationID"].intValue
                updateNotification(NotificationID: notificationID)
                print("call end point")
            }else{
                print("dont call end point")
            }
            let myclass = storyboard?.instantiateViewController(withIdentifier: "myclassvc") as! MyClassVC
            myclass.notificationInt = 2
            navigationController?.pushViewController(myclass, animated: true)
            break
            /* Added By Ranjeet on 23rd Feb 2020 - ends here */
        default:
            print("Default")
        }
        
        /*
         TypeID    NotificationType
         1        Group Invitation
         2        Test Invitation
         3        Class Invitation
         4        Question Follow
         5        Reminder For class
         8        Request to class /* Added By Ranjeet on 21st Feb 2020 */
         */
    }
    
}
extension NotificationVC {
    
    private func hitServer(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        // startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        // added by veeresh on 21/2/2020
        var shim = UIImageView()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: shim = UIImageView(image: UIImage(named: "notification-mobile")!)
        case .pad: shim = UIImageView(image: UIImage(named: "notification_1")!)// ; shim.contentMode = .topLeft
        case .unspecified: shim = UIImageView(image: UIImage(named: "notification-mobile")!)
        case .tv: shim = UIImageView(image: UIImage(named: "notification_1")!) ; shim.contentMode = .topLeft
        case .carPlay: shim = UIImageView(image: UIImage(named: "notification-mobile")!)
        }//scaleAspectFill
        if notificationList.count < 1 {
            notificationTabelView.backgroundView = shim
//            notificationTabelView.pinAllEdges(ofSubview: shim)
        }
        shim.startShimmering()
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){[weak self] result in
            guard let _self = self else {
                return
            }

                _self.notificationTabelView.backgroundView = UIView()

                
            
           
            shim.stopShimmering()
            shim.removeFromSuperview()
            // self.stopAnimating()
            _self.notificationList.removeAll()
            switch result {
            case let .success(json,_):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                    
                }else{
                    if action == "deleteNotifacition"{
                        _self.notificationTabelView.allowsSelection = true
                        _self.finalStoredNotificationids.removeAll()
                        _self.storedNotificationids.removeAll() //add by chandra
                        let endPoint: String = "\(Endpoints.notificationListUrl)\(_self.userID!)"
                        _self.hitServer(params: [:], endPoint: endPoint ,action: "getAllTestList", httpMethod: .get)
                    }else{
                        _self.notificationList = json["ControlsData"]["NotificationList"].arrayValue
                    }
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    
}

extension NotificationVC {
func DetailsFunction(dict: JSON){
// if notificationclick == true || self.isTaken == 1 {//

let uniqueID = dict["UniqueID"].stringValue

if self.isTaken == 1 {
var isreadcheco = dict["isRead"].boolValue
if isreadcheco == false{
let notificationID = dict["NotificationID"].intValue
updateNotification(NotificationID: notificationID)
print("call end point")
}else{
print("dont call end point")
}

let attandTestVC1 = storyboard?.instantiateViewController(withIdentifier: "reviewtestvc") as! ReviewTestVC
attandTestVC1.testID = uniqueID
delegate?.ststus(reviewans: 1)
//attandTestVC.testDuration = self.tableViewDataSource[sender.tag]["Duration"].stringValue

// attandTestVC.testDuration = "1:0"
navigationController?.pushViewController(attandTestVC1, animated: true)
}else if self.isTaken == 0 {

var isreadcheco = dict["isRead"].boolValue
if isreadcheco == false{
let notificationID = dict["NotificationID"].intValue
updateNotification(NotificationID: notificationID)
print("call end point")
}else{
print("dont call end point")
}
let attandTestVC = storyboard?.instantiateViewController(withIdentifier: "answertestvc") as! AttandTestVC
attandTestVC.testID = uniqueID
//attandTestVC.testDuration = self.tableViewDataSource[sender.tag]["Duration"].stringValue
notificationclick = true
attandTestVC.testDuration = "1:0"
navigationController?.pushViewController(attandTestVC, animated: true)
}


}
}
