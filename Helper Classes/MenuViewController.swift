// MenuViewController.swift
// SlideInTransition
// Created by Ranjeet Raushan on 1/12/19.
// Copyright © 2019 Ranjeet Raushan. All rights reserved.

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage
import SwiftMessages
import NVActivityIndicatorView
import MessageUI
//import Quickblox
//import QuickbloxWebRTC
import StoreKit

struct celldata{
  var title: String!
  var sectionData:[String]!
  var opened: Bool!
  var img:UIImage?
  var sectionData1:[UIImage]?
}
class MenuViewController: UIViewController,NVActivityIndicatorViewable,MFMailComposeViewControllerDelegate {
    var userID = UserDefaults.standard.string(forKey: "userID")
    var tableViewData = [celldata]()
    @IBOutlet weak var swipeBtn:UIButton!
    @IBOutlet weak var tableview:UITableView!{
        didSet {
            tableview.tableFooterView = UIView(frame: .zero)
        }
    }
    /* Added By Ranjeet on 17th Jan 2020 to show version and build number dynamically - starts here */
    func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "Version: \(version)" // .\(build)    changed by veeresh on 16th may
    }
    /* Added By Ranjeet on 17th Jan 2020 to show version and build number dynamically - ends here */
    
    override func viewDidLoad() {
        super.viewDidLoad()
// Aniimation for the side Menu
        let transition = CATransition()
        let withDuration = 0.3
        transition.duration = withDuration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.layer.add(transition, forKey: kCATransition)
        
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        
        /* Below line i have taken two same images one for heder image and another one  for section image */
    tableViewData = [celldata(title: "Follow", sectionData: ["Follow User","Follow User","My Followers" ,"Follow Category", "Questions Followed"], img:UIImage(named: "followuser"),sectionData1: [UIImage(named: "followuser")!,UIImage(named: "followuser")!,UIImage(named: "Asset 150")!,UIImage(named: "followcategory")!,UIImage(named: "followquestion")!]),
        celldata(title: "Feedback", sectionData: [""],  img: UIImage(named: "feedback")),
        celldata(title: "Rate & Review", sectionData: [""],  img:  UIImage(named: "rateandreivew")),
        celldata(title: "How does it work", sectionData: [""],  img: UIImage(named: "howdoesitwork")),
        celldata(title: "Change Password", sectionData: [""], img:  UIImage(named: "changepassword")),
        celldata(title: "Logout", sectionData: [""],  img: UIImage(named: "logout-1")),
        //commented by veeresh on 15th may
       // celldata(title: "Tour Demo", sectionData: [""], img: UIImage(named: "app-tour")), //added by veeresh on 5th march 2020
        celldata(title: version() , sectionData: [""],  img: UIImage(named: "")), /* Added By Ranjeet on 17th Jan 2020 to show version and build number dynamically */
        celldata(title: Endpoints.buildName , sectionData: [""],  img: UIImage(named: "")) // changed by veeresh on 16th may
        ] /* Added By Ranjeet on 17th Jan 2020 to show staging and production server dynamically */
     //   for left Swiping
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft(swipe:)))
        swipeLeft.direction = .left
        swipeBtn.addGestureRecognizer(swipeLeft)

    }
   
    /* Don't delete this , future might requirement comes to implement this functionality - starts here
     /* hide side menu functionality - starts here */
    func hideTheSideMenu(){
        self.view.removeFromSuperview()
               for view in self.view.subviews{
                   view.removeFromSuperview()
        }
    }
    /* hide side menu functionality - ends  here  */
     Don't delete this , future might requirement comes to implement this functionality - ends  here */
    
    @objc func handleSwipeLeft(swipe:UISwipeGestureRecognizer){
        self.view.removeFromSuperview()
        for view in self.view.subviews{
            view.removeFromSuperview()
        }
    }
    @IBAction func HideBtn(_ sender: UIButton) {
        self.view.removeFromSuperview()
               for view in self.view.subviews{
                   view.removeFromSuperview()
        }
    }
    func configureMailComposer() -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.navigationItem.rightBarButtonItem?.tintColor = UIColor.blue
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["support@learnteachworld.com"])
        let firstName = UserDefaults.standard.object(forKey: "fname") as! String
        let lastName = UserDefaults.standard.object(forKey: "lname") as! String
        mailComposeVC.setSubject(NSLocalizedString("Feedback version 1.2 - from \(firstName) \(lastName)", comment: ""))
        //19/12/18
        let body = "\n\n\n\n\n \(NSLocalizedString("Regards", comment: ""))" + "\n\(firstName)" + " \(lastName)" + "\n" + "\(UserDefaults.standard.object(forKey: "emailId") as! String)"
        mailComposeVC.setMessageBody(body, isHTML: false)
        return mailComposeVC

    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
extension MenuViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tableViewData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableViewData[section].opened == true{
            return tableViewData[section].sectionData.count
        }else{
            return 1
        }
    }
    
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell") as! SideMenuTableViewCell
            cell.textLabel?.text = tableViewData[indexPath.section].title
            cell.imageView?.image = tableViewData[indexPath.section].img
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .none /* Added By Ranjeet on 26th November 2019 */
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell") as! SideMenuTableViewCell
    //            custom cell outlets for the section data
            cell.titleLbl.text = tableViewData[indexPath.section].sectionData?[indexPath.row]
            cell.imag.image = tableViewData[indexPath.section].sectionData1?[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none /* Added By Ranjeet on 26th November 2019 */
               return cell
            }
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            if tableViewData[indexPath.section].opened == true{
                switch indexPath.row {
                case 0:
//                     if tapped on the section closing the cells
                    print("tapped On Follow close")
                    
                    tableViewData[indexPath.section].opened = false
                    tableView.reloadSections([indexPath.section], with: .none)
                case 1:
//                    hideTheSideMenu() /* Don't delete this , future might requirement comes to implement this functionality */
                    print("Follow User")
                    let vc = storyboard?.instantiateViewController(withIdentifier: "followUser") as! FollwUserVC2ViewController
                    // vc.title = "Follow Users"  /* Commented By Ranjeet , cause i implemented the code in main class file and this line most of the time not showing  navigation bar title */
                    // navigationController?.pushViewController(vc, animated: true) /* uncomment this line when animation required */
                    navigationController?.pushViewController(vc, animated: false) /* comment this line when animation not required */
                    break
                case 2:
//                    hideTheSideMenu() /* Don't delete this , future might requirement comes to implement this functionality */
                    print("My Followers")
                    let vc = storyboard?.instantiateViewController(withIdentifier: "MyFollowUseer2ViewController") as! MyFollowUseer2ViewController
                     //   vc.title = "My Followers" /* Commented By Ranjeet , cause i implemented the code in main class file and this line most of the time not showing  navigation bar title */
                    // navigationController?.pushViewController(vc, animated: true) /* uncomment this line when animation required */
                    navigationController?.pushViewController(vc, animated: false) /* comment this line when animation not required */
                    break
                case 3:
//                    hideTheSideMenu() /* Don't delete this , future might requirement comes to implement this functionality */
                    print("Follow Category")
                    let myFollow = storyboard?.instantiateViewController(withIdentifier: "myfolwd") as! MyFollowedVC
                   // myFollow.userID = self.userID /* Commented By Ranjeet , cause i implemented the code in main class file and this line most of the time not showing  navigation bar title */
                    // navigationController?.pushViewController(myFollow, animated: true) /* uncomment this line when animation required */
                    navigationController?.pushViewController(myFollow, animated: false) /* comment this line when animation not required */
                    break
                case 4:
//                    hideTheSideMenu() /* Don't delete this , future might requirement comes to implement this functionality */
                    print("Questions Followed")
                    let followQstn = storyboard?.instantiateViewController(withIdentifier: "contntqstinsfollowed") as! ContentQuestionsFollowedVC
                    // navigationController?.pushViewController(followQstn, animated: true) /* uncomment this line when animation required */
                    navigationController?.pushViewController(followQstn, animated: false) /* comment this line when animation not required */
                    break
                default:
                    print("default")
                    break
                }
            }else{
                 print("tapped On Follow open")
//             if tapped on the section expanding the cells
                
                 tableViewData[indexPath.section].opened = true
                 tableView.reloadSections([indexPath.section], with: .none)
            }
            
            break
        case 1:
//            hideTheSideMenu() /* Don't delete this , future might requirement comes to implement this functionality */
            print("Feedback")
            if MFMailComposeViewController.canSendMail(){
                let mailComposeViewController = configureMailComposer()
                self.present(mailComposeViewController, animated: true, completion: nil)
            }else{
                print("Can't send email")
                AppConstants().ShowAlert(vc: self, title:"Message", message:"Please set up mail account in order to give feedback")
            }
            break
        case 2:
//            hideTheSideMenu() /* Don't delete this , future might requirement comes to implement this functionality */
            print("Rate & Review")
            self.rateApp() //prasuna added this on 18/5/2020
            break
        case 3:
//            hideTheSideMenu() /* Don't delete this , future might requirement comes to implement this functionality */
            print("How does it work")
            let vc = storyboard?.instantiateViewController(withIdentifier: "HowDoesItWorksViewController") as! HowDoesItWorksViewController
            // navigationController?.pushViewController(vc, animated: true) /* uncomment this line when animation required */
            navigationController?.pushViewController(vc, animated: false) /* comment this line when animation not required */
            
            break
        case 4:
//            hideTheSideMenu() /* Don't delete this , future might requirement comes to implement this functionality */
            print("Change Password")
            let changePswrdVC = storyboard?.instantiateViewController(withIdentifier: "changepswrd") as! ChangePswrdVC
            // navigationController?.pushViewController(changePswrdVC, animated: true) /* uncomment this line when animation required */
            navigationController?.pushViewController(changePswrdVC, animated: false) /* comment this line when animation not required */
            break
        case 5:
//            hideTheSideMenu() /* Don't delete this , future might requirement comes to implement this functionality */
            print("LogOut")
            let alert = UIAlertController(title: "Are you sure, You want to logout?", message: "", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                
            // After logout the app and remove from background , app was not asking for Sign In , it was directly redirected to Home Screen, to resolve that issue below three lines code is there :
                 let deviceToken =  UserDefaults.standard.object(forKey: "deviceTokenSBN") as! Data /* comment this line while load in simulator but for device uncomment it */
//                  let deviceToken =  UserDefaults.standard.object(forKey: "deviceTokenSBN") as? Data  /* comment this line while load in device but for simulator uncomment it */
                let appDomain = Bundle.main.bundleIdentifier
                UserDefaults.standard.removePersistentDomain(forName: appDomain!)
                UserDefaults.standard.synchronize()
                
                UserDefaults.standard.set(deviceToken, forKey: "deviceTokenSBN") /* comment this line while load in simulator but for device uncomment it */
                UserDefaults.standard.synchronize()
                
                //prasuna comment this code on 7th may 2020
//                QBRequest.logOut(successBlock: { response in
//                //ClearProfile
//                Profile.clearProfile()
//
//                }) { response in
//
////                showMessage(bodyText: "\(response)" ,theme: .error) /* Commented By Prasuna on 19th Dec 2019 */
//
//                debugPrint("QBRequest.logOut error\(response)")
//                }
                
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                appDelegate.logoutAction()
                //end here
                
                
                
                SDWebImageManager.shared().imageCache!.clearDisk()
                SDWebImageManager.shared().imageCache!.clearMemory()
                UIApplication.shared.keyWindow?.rootViewController = nil
                // Load Login view controller
                let navi = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "landingPageNavBar") as! UINavigationController
                UIApplication.shared.keyWindow?.rootViewController = navi
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            
            // below 3 lines are for iPAD
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
            alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            self.present(alert, animated: true, completion: nil)
            break
            //commented by veeresh on 15th may
//            case 6 : print("tour demo") // tourSlidesVC      /* this case is added by veeresh on 5th march 2020
//            let tourDemo = storyboard?.instantiateViewController(withIdentifier: "tourSlidesVC") as! tourSlidesVC
//            tourDemo.modalPresentationStyle = .fullScreen
//            self.present(tourDemo, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func rateApp() {

//        if #available(iOS 13.0, *) {
//            SKStoreReviewController.requestReview()
//        } else {

                    let appID = "1477151992"
        //            let urlStr = "https://itunes.apple.com/app/id\(appID)" // (Option 1) Open App Page
                    let urlStr = "https://itunes.apple.com/app/id\(appID)?action=write-review" // (Option 2) Open App Review Page

                    guard let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) else { return }

                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url) // openURL(_:) is deprecated from iOS 10.
                    }
               // }
        
        
    }
    
}
