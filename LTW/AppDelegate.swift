//  AppDelegate.swift
//  LTW
//  Created by Ranjeet Raushan on 08/04/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import IQKeyboardManagerSwift  // Key Board Handling
import UserNotifications
import SwiftyJSON
import AVFoundation
//import Quickblox
//import QuickbloxWebRTC
//import PushKit
import SVProgressHUD
import Alamofire
//import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
//import AppsFlyerLib
import Stripe
//struct CredentialsConstant {
//        static let applicationID:UInt = 4
//        static let authKey = "RrMWjgnPMsAsmvU"
//        static let authSecret = "34tff7AXe9gJaea"
//        static let accountKey = "bcrP6x8fqwz2FPrDekJ8"
//        static let apiEndpoint = "https://apilearnteachworld.quickblox.com"
//        static let chatEndpoint = "chatlearnteachworld.quickblox.com"
//        static let chatEndpointPort = "oxgmJgU8EB_BTaEa3xB3"
//}

struct TimeIntervalConstant {
    static let answerTimeInterval: TimeInterval = 60.0
    static let dialingTimeInterval: TimeInterval = 5.0
}

struct AppDelegateConstant {
    static let enableStatsReports: UInt = 1
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    lazy private var backgroundTask: UIBackgroundTaskIdentifier = {
        let backgroundTask = UIBackgroundTaskIdentifier.invalid
        return backgroundTask
    }()
    
//    var isCalling = false {
//        didSet {
//            if UIApplication.shared.applicationState == .background,
//                isCalling == false {
//                disconnect()
//            }
//        }
//    }
//    lazy private var dataSource: UsersDataSource = {
//        let dataSource = UsersDataSource()
//        return dataSource
//    }()
//    weak var session: QBRTCSession?
//    var callUUID: UUID?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        if #available(iOS 13.0, *) {
            // In iOS 13 setup is done in SceneDelegate
//        } else {
            // quick block register
        Stripe.setDefaultPublishableKey(publishableKey)
//        FirebaseApp.configure()
//        AppsFlyerTracker.shared().appsFlyerDevKey = "mQ8HmxnfrEVAZC3Ekm5qRS"
//        AppsFlyerTracker.shared().appleAppID = "1477151992"
//        AppsFlyerTracker.shared().delegate = self
//        /* Set isDebug to true to see AppsFlyer debug logs */
//        AppsFlyerTracker.shared().isDebug = true
//
//        NotificationCenter.default.addObserver(self,selector: #selector(sendLaunch),
////         For Swift version < 4.2 replace name argument with the commented out code
//            name: UIApplication.didBecomeActiveNotification, //.UIApplicationDidBecomeActive for Swift < 4.2
//            object: nil)

                
//        FBSDKSettings.setAutoLogAppEventsEnabled(true)

//       QBSettings.applicationID = CredentialsConstant.applicationID;
//        QBSettings.authKey = CredentialsConstant.authKey
//        QBSettings.authSecret = CredentialsConstant.authSecret
//        QBSettings.accountKey = CredentialsConstant.accountKey
//        QBSettings.apiEndpoint = CredentialsConstant.apiEndpoint
//        QBSettings.chatEndpoint = CredentialsConstant.chatEndpoint
//        QBSettings.autoReconnectEnabled = true
//        QBSettings.logLevel = QBLogLevel.nothing
//        QBSettings.disableXMPPLogging()
//        QBRTCConfig.setAnswerTimeInterval(TimeIntervalConstant.answerTimeInterval)
//        QBRTCConfig.setDialingTimeInterval(TimeIntervalConstant.dialingTimeInterval)
//        QBRTCConfig.setLogLevel(QBRTCLogLevel.verbose)
//        QBRTCConfig.setConferenceEndpoint("wss://groupcallslearnteachworld.quickblox.com:8989")
//        if AppDelegateConstant.enableStatsReports == 1 {
//        QBRTCConfig.setStatsReportTimeInterval(1.0)
//        }

        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
//        QBRTCClient.initializeRTC()
//
//        let profile = Profile()
//        if profile.isFull == true {
//            self.setDelegatesForVideoCall()
//        }
        IQKeyboardManager.shared.enable = true // Key Board Handling
        
        /* Navigation Bar and Item Related - Concepts Starts Here */
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.white
        UITextField.appearance().tintColor = UIColor.init(hex: "2DA9EC")
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21)]
         navigationBarAppearace.barTintColor = UIColor.init(hex: "2DA9EC")// Background color Added by yasodha
        /* Navigation Bar and Item Related - Concepts Ends  Here */
        
        // Resgister notification
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
            UNUserNotificationCenter.current().getNotificationSettings(){ (setttings) in
                
                switch setttings.soundSetting{
                case .enabled:
                    print("enabled sound setting")
                case .disabled:
                    print("setting has been disabled")
                case .notSupported:
                    print("something vital went wrong here")
                }
            }
        }
        application.registerForRemoteNotifications()
        
        /* restore the Home Page Directly after close the application - Concepts Starts Here */
        if (UserDefaults.standard.object(forKey: "userID") != nil) {
            
            if launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil {
                // Do your task here
            }
//            if let remoteNotification = launchOptions?[.remoteNotification] as? [AnyHashable : Any] {
////            self.window?.rootViewController = VSCore().launchHomePage(index: 0)
//            // Do what you want to happen when a remote notification is tapped.
//            let aps = remoteNotification["aps" as String] as? [String:Any]
//            let apsString = String(describing: aps)
//            debugPrint("\n last incoming aps: \(apsString)")
//            UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
//            DispatchQueue.main.sync {
//
//            let content = notifications.last?.request.content.userInfo
//            self.handleNotificationtap(userInfo: content ?? [:])
//
//            print(notifications)
//
//            }
//            }
//
//            }
            // Check if launched from the remote notification and application is close
             //commented by  prasuna  this on 30/4/2020
          /*  if let remoteNotification = launchOptions?[.remoteNotification] as? [AnyHashable : Any] {
                // Do what you want to happen when a remote notification is tapped.
                let aps = remoteNotification["aps" as String] as? [String:AnyObject]
                let apsString = String(describing: aps)
                debugPrint("\n last incoming aps: \(apsString)")
           //     handleNotificationtap(userInfo: remoteNotification) /* Commented By Prauna on 21st April 2020 */
                return true
            } */
            //commented by  prasuna  this on 30/4/2020
              if UserDefaults.standard.bool(forKey: "Tutor")
              {
                let navi = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TutorSignUpVC") as! TutorSignUpVC
                               let objNavi = UINavigationController(rootViewController: navi)
                /* Below 1 line code is for Tutor Edit */
                navi.isEdit = false /* Added  by chadra on 25th Feb 2020  */
                self.window?.rootViewController = objNavi
              }else if UserDefaults.standard.bool(forKey: "PostSignUpClassPage") {
                    let navi = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AvailableClassesPostSignupVC") as! AvailableClassesPostSignupVC
                    let objNavi = UINavigationController(rootViewController: navi)
                    self.window?.rootViewController = objNavi
                    
                }else if UserDefaults.standard.bool(forKey: "PostSignupGroupPage") {
                    let navi = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AvailableGroupSignUpViewController") as! AvailableGroupSignUpViewController
                    let objNavi = UINavigationController(rootViewController: navi)
                    self.window?.rootViewController = objNavi
                }else if UserDefaults.standard.bool(forKey: "PostSignUpFollowCategoryPage") {
                    let navi = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FollowCategoryPostSignVC") as! FollowCategoryPostSignVC
                    let objNavi = UINavigationController(rootViewController: navi)
                    self.window?.rootViewController = objNavi
                }else
              {
                self.window?.rootViewController = VSCore().launchHomePage(index: 0)

            }
            
//            self.window?.rootViewController = VSCore().launchHomePage(index: 0)
            
            /* Version Check  Code By Prasuna on 9th April 2020  - starts here  */
            VersionCheck.shared.checkAppStore() { isNew, version in
                
                if isNew!
                {
                    
                    let topWindow = UIWindow(frame: UIScreen.main.bounds)
                    topWindow.rootViewController = UIViewController()
                    topWindow.windowLevel = UIWindow.Level.alert + 1

                    let alertController = UIAlertController.init(title:"New version available", message: "A new version of LearnTeachWorld  is available.Please update to version " + version! + " now", preferredStyle: .alert)
                    let action = UIAlertAction.init(title: "Update", style: .default) { (UIAlertAction) in
                        
                        let appID = "1477151992"
                        let urlStr = "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(appID)"
                        if let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                        
                        topWindow.isHidden = true
                    }
                    alertController.addAction(action)
//                    let action1 = UIAlertAction.init(title:"No Thanks", style: .default) { (UIAlertAction) in
                        
//                        topWindow.isHidden = true

//                    }
//                    alertController.addAction(action1)
                    topWindow.makeKeyAndVisible()
                    topWindow.rootViewController?.present(alertController, animated: true)
                    
                }
            
                
            }
            
             /* Version Check  Code By Prasuna on 9th April 2020 - ends here  */
            
            
        }
        else{
        }
        /* restore the Home Page Directly after close the application - Concepts Ends Here */
        /* added By Prasuna on 15th may 2020*/
           ApplicationDelegate.shared.application(
                  application,
                  didFinishLaunchingWithOptions: launchOptions
              )
        AppEvents.logEvent(.completedRegistration)
    
              
//    }
        return true
          }
            
    
    /* added by prasunna on 15th may */
    func logCompleteRegistrationEvent(registrationMethod : String) {
    
        AppEvents.logEvent(.completedRegistration, parameters: ["FBSDKAppEventParameterNameRegistrationMethod" : registrationMethod])
//        let params : AppEvent.ParametersDictionary = [.registrationMethod : registrationMethod]
//        let event = AppEvent(name: .completedRegistration, parameters: params)
//        AppEventsLogger.log(event)
        
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
//        AppsFlyerTracker.shared().handleOpen(url, options: options)
        return true
    }
    
    
    
//    /* Added By Prasuna on 25th April 2020 - starts here */
//    var myOrientation: UIInterfaceOrientationMask = .portrait
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        return myOrientation
//    }

    /* Added By Prasuna on 25th April 2020 - starts here */
//    func setDelegatesForVideoCall() {
//        QBRTCClient.instance().add(self)
//        //              voipRegistry.delegate = self
//        //              voipRegistry.desiredPushTypes = Set<PKPushType>([.voIP])
//
//    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        if isCalling == false {
//            disconnect()
//            ChatManager.instance.disconnect()
//        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//        if QBChat.instance.isConnected == true {
//            return
//        }else
//        {
//            self.connectToChat()
//
//        }
//        ChatManager.instance.connect { (error) in
//                   if let error = error {
//                       return
//                   }
//               }
        
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//        disconnect()
//        ChatManager.instance.disconnect()
  }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("Recieved notification")
        //        handleNotificationtap(userInfo: userInfo)
        
        switch UIApplication.shared.applicationState {
        case .active:
            //app is currently active, can update badges count here
            handleNotificationtap(userInfo: userInfo)
            
            break
        case .inactive:
            //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
             handleNotificationtap(userInfo: userInfo)
            break
        case .background:
            //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
            handleNotificationtap(userInfo: userInfo)
            
            break
        default:
            break
        }
        
        
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        //        UserDefaults.standard.set(deviceTokenString, forKey: "deviceToken")
               UserDefaults.standard.set(deviceToken, forKey: "deviceTokenSBN")
               UserDefaults.standard.synchronize()
        
        
                if (UserDefaults.standard.object(forKey: "userID") != nil)
                {
                    
                      let hub = SBNotificationHub(connectionString:Constants.HUBLISTENACCESS, notificationHubPath:Constants.HUBNAME)
                    let set: Set<String> = [UserDefaults.standard.string(forKey: "userID")!, (UserDefaults.standard.string(forKey: "emailId") ?? "")]
                    
                    
                      do {
                        
                    try hub?.registerNative(withDeviceToken:deviceToken, tags: set) /* Comment in case of Device */
                          
                          print("deviceTokenSBN registered")

                      }
                      catch {
                          let fetchError = error as Error
                          print(fetchError)
                      }
                    
        }
        
//        if UserDefaults.standard.object(forKey: "userID") != nil && UserDefaults.standard.object(forKey: "QuickBlockID") != nil
//        {
////            guard let deviceIdentifier = UIDevice.current.identifierForVendor?.uuidString else {
////                return
////            }
////            let subscription = QBMSubscription()
////            subscription.notificationChannel = .APNS
////            subscription.deviceUDID = deviceIdentifier
////            subscription.deviceToken = deviceToken
////            QBRequest.createSubscription(subscription, successBlock: { response, objects in
////                debugPrint("[UsersViewController] Create Subscription request - Success")
////            }, errorBlock: { response in
////                debugPrint("[UsersViewController] Create Subscription request - Error")
////            })
//            if QBChat.instance.isConnected == false {
//                QBRTCClient.instance().add(self)
//                self.connectToChat()
//            }
//        }
        
       
    }
    
    private func handleNotificationtap(userInfo: [AnyHashable : Any]) {
        
        let notifInfo = (userInfo as? [String : Any])!
        let infoDict = notifInfo["aps"]
        let json = JSON(infoDict!)
        let dictVal = json.dictionaryValue
        let alert = dictVal["alert"]?.stringValue
        let sound = dictVal["sound"]?.stringValue
        print("infoDict = \(infoDict!)")
        // print("sound = \(sound!)")
        print("alert = \(alert!)")
        if let index = sound!.range(of: ".")?.lowerBound {
            let substring = sound![..<index]
            let string = String(substring)
            print("string = \(string)")
            let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: string, ofType: ".mp3")!)
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print(error)
            }
            var audioPlayer: AVAudioPlayer?
            try! audioPlayer = AVAudioPlayer(contentsOf: alertSound)
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        }
        
        let notificationType = dictVal["NotificationType"]?.intValue
        let state = UIApplication.shared.applicationState
        if state == .background || state == .inactive{
            self.onNotificationTap(notificationType: notificationType!, dictVal: dictVal)
        }else if state == .active {
        }
    }
    func onNotificationTap (notificationType: Int,dictVal: [String: JSON]){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        self.window?.rootViewController = nil
        func launchNotificationListForm() {
            let notificationVC = storyboard.instantiateViewController(withIdentifier: "notification") as! NotificationVC
            let navController = UINavigationController.init(rootViewController: notificationVC)
            
            self.window?.rootViewController = navController
        }
    }
    
    //MARK: - Connect/Disconnect
//    func connect(completion: QBChatCompletionBlock? = nil) {
//        let currentUser = Profile()
//
//        guard currentUser.isFull == true else {
//            completion?(NSError(domain: LoginConstant.chatServiceDomain,
//                                code: LoginConstant.errorDomaimCode,
//                                userInfo: [
//                                    NSLocalizedDescriptionKey: "Please enter your login and username."
//            ]))
//            return
//        }
//        if QBChat.instance.isConnected == true {
//            completion?(nil)
//        } else {
//            QBSettings.autoReconnectEnabled = true
//            QBChat.instance.connect(withUserID: currentUser.ID, password: currentUser.password, completion: completion)
//        }
//    }
//
//    func disconnect(completion: QBChatCompletionBlock? = nil) {
//        QBChat.instance.disconnect(completionBlock: completion)
//    }
    
}

// MARK: - QBRTCClientDelegate
//extension AppDelegate: QBRTCClientDelegate {
//    func session(_ session: QBRTCSession, hungUpByUser userID: NSNumber, userInfo: [String : String]? = nil) {
//        if CallKitManager.instance.isCallStarted() == false && self.session?.id == session.id && self.session?.initiatorID == userID {
//            CallKitManager.instance.endCall(with: callUUID) {
//                debugPrint("[UsersViewController] endCall")
//            }
//            prepareCloseCall()
//        }
//    }
//
//    func didReceiveNewSession(_ session: QBRTCSession, userInfo: [String : String]? = nil) {
//        if self.session != nil {
//            session.rejectCall(["reject": "busy"])
//            return
//        }
//
//        self.session = session
//        let uuid = UUID()
//        callUUID = uuid
//        var opponentIDs = [session.initiatorID]
//        let profile = Profile()
//        guard profile.isFull == true else {
//            return
//        }
//        for userID in session.opponentsIDs {
//            if userID.uintValue != profile.ID {
//                opponentIDs.append(userID)
//            }
//        }
//
//        var callerName = ""
//        var opponentNames = [String]()
//        var newUsers = [NSNumber]()
//        for userID in opponentIDs {
//
//            // Getting recipient from users.
//            if let user = dataSource.user(withID: userID.uintValue),
//                let fullName = user.fullName {
//                opponentNames.append(fullName)
//            } else {
//                newUsers.append(userID)
//            }
//        }
//
//        if newUsers.isEmpty == false {
//            let loadGroup = DispatchGroup()
//            for userID in newUsers {
//                loadGroup.enter()
//                dataSource.loadUser(userID.uintValue) { (user) in
//                    if let user = user {
//                        opponentNames.append(user.fullName ?? user.login ?? "")
//                    } else {
//                        opponentNames.append("\(userID)")
//                    }
//                    loadGroup.leave()
//                }
//            }
//            loadGroup.notify(queue: DispatchQueue.main) {
//                callerName = opponentNames.joined(separator: ", ")
//                self.reportIncomingCall(withUserIDs: opponentIDs, outCallerName: callerName, session: session, uuid: uuid)
//            }
//        } else {
//            callerName = opponentNames.joined(separator: ", ")
//            self.reportIncomingCall(withUserIDs: opponentIDs, outCallerName: callerName, session: session, uuid: uuid)
//        }
//    }
//
//    private func reportIncomingCall(withUserIDs userIDs: [NSNumber], outCallerName: String, session: QBRTCSession, uuid: UUID) {
//        if hasConnectivity() {
//            CallKitManager.instance.reportIncomingCall(withUserIDs: userIDs,
//                                                       outCallerName: outCallerName,
//                                                       session: session,
//                                                       uuid: uuid,
//                                                       onAcceptAction: { [weak self] in
//                                                        guard let self = self else {
//                                                            return
//                                                        }
//                                                        if let controller = UIStoryboard(name: "Call", bundle: nil).instantiateViewController(withIdentifier: "CallViewController") as? CallViewController {
//                                                            let ass = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
//                                                            let nav = ass.viewControllers![0] as! UINavigationController
//
//                                                            for currentController in nav.viewControllers as Array {
//                                                                if currentController.isKind(of: HomeVC.self) {
////                                                                    controller.session = self.session
////                                                                    controller.usersDataSource = self.dataSource
////                                                                    controller.callUUID = uuid
//                                                                    nav.pushViewController(controller, animated: true)
//                                                                }
//                                                            }
//                                                        }
//                }, completion: { (end) in
//                    debugPrint("[UsersViewController] endCall")
//            })
//        } else {
//
//        }
//    }
//
//    func sessionDidClose(_ session: QBRTCSession) {
//        if let sessionID = self.session?.id,
//            sessionID == session.id {
//            //prasuna added this
//            let ass = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
//            let nav = ass.viewControllers![0] as! UINavigationController
//
//            if nav.viewControllers.contains(where: {
//                return $0 is MyClassVC
//            })
//            {
//                for controller in nav.viewControllers as Array {
//                    if controller.isKind(of: MyClassVC.self) {
//
//                        _ = nav.popToViewController(controller, animated: true)
//                        break
//                    }
//                }
//            }else
//            {
//                _ = nav.popToViewController(nav.viewControllers[0], animated: true)
//
//            }
//            CallKitManager.instance.endCall(with: self.callUUID) {
//                debugPrint("[UsersViewController] endCall")
//
//            }
//            prepareCloseCall()
//        }
//    }
//
//    private func hasConnectivity() -> Bool {
//
//        let status = Reachability.instance.networkConnectionStatus()
//        guard status != NetworkConnectionStatus.notConnection else {
//            // showAlertView(message: UsersAlertConstant.checkInternet)
//            SVProgressHUD.show(withStatus: UsersAlertConstant.checkInternet)
//
//            if CallKitManager.instance.isCallStarted() == false {
//                CallKitManager.instance.endCall(with: callUUID) {
//                    debugPrint("[UsersViewController] endCall")
//                }
//            }
//            return false
//        }
//        return true
//    }
//    private func prepareCloseCall() {
//        self.callUUID = nil
//        self.session = nil
//        if QBChat.instance.isConnected == false {
//            self.connectToChat()
//        }
//        //        self.setupToolbarButtons()
//    }
//
//    func connectToChat() {
//        let profile = Profile()
//        guard profile.isFull == true else {
//            return
//        }
//
//        QBChat.instance.connect(withUserID: profile.ID,
//                                password: LoginConstant.defaultPassword,
//                                completion: { [weak self] error in
//                                    guard let self = self else { return }
//                                    if let error = error {
//                                        if error._code == QBResponseStatusCode.unAuthorized.rawValue {
//                                            self.logoutAction()
//                                        } else {
//                                            debugPrint("[UsersViewController] login error response:\n \(error.localizedDescription)")
//                                        }
//                                    } else {
//                                        //did Login action
//                                        //                                        SVProgressHUD.dismiss()
//                                    }
//        })
//    }
//}

//extension AppDelegate: SettingsViewControllerDelegate {
//    func settingsViewController(_ vc: SessionSettingsViewController, didPressLogout sender: Any) {
//        logoutAction()
//    }
//
//     func logoutAction() {
//        if QBChat.instance.isConnected == false {
//            //            SVProgressHUD.showError(withStatus: "Error")
//            return
//        }
//        guard let identifierForVendor = UIDevice.current.identifierForVendor else {
//            return
//        }
//        let uuidString = identifierForVendor.uuidString
//        #if targetEnvironment(simulator)
//        disconnectUser()
//        #else
//        QBRequest.subscriptions(successBlock: { (response, subscriptions) in
//
////            if let subscriptions = subscriptions {
////                for subscription in subscriptions {
////                    if let subscriptionsUIUD = subscriptions.first?.deviceUDID,
////                        subscriptionsUIUD == uuidString,
////                        subscription.notificationChannel == .APNS {
////                        self.unregisterSubscription(forUniqueDeviceIdentifier: uuidString)
////                        return
////                    }
////                }
////            }
//            self.disconnectUser()
//
//        }) { response in
//            if response.status.rawValue == 404 {
//                self.disconnectUser()
//            }
//        }
//        #endif
//    }
//
//    private func disconnectUser() {
//        QBChat.instance.disconnect(completionBlock: { error in
//            if error != nil {
//             return
//            }
//            self.logOut()
//        })
//    }
//
//    private func unregisterSubscription(forUniqueDeviceIdentifier uuidString: String) {
//        QBRequest.unregisterSubscription(forUniqueDeviceIdentifier: uuidString, successBlock: { response in
//            self.disconnectUser()
//        }, errorBlock: { error in
//            if error.error != nil {
//                return
//            }
//         })
//    }
//
//    private func logOut() {
//    }
//}

extension AppDelegate: UNUserNotificationCenterDelegate{

    // This function will be called when the app receive notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // show the notification alert (banner), and with sound
        completionHandler([.alert, .sound])
    }
    // This function will be called right after user tap on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        let userInfo = response.notification.request.content.userInfo

        let application = UIApplication.shared

        if(application.applicationState == .active){
            print("user tapped the notification bar when the app is in foreground")

        }

        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        //dialog_id
        guard let dialogID = userInfo["dialog_id"] as? String,
            dialogID.isEmpty == false else {
                return
        }
        // calling dispatch async for push notification handling to have priority in main queue
//        DispatchQueue.main.async {
//
//            if let chatDialog = ChatManager.instance.storage.dialog(withID: dialogID) {
//                self.openChat(chatDialog)
//            } else {
//                ChatManager.instance.loadDialog(withID: dialogID, completion: { (loadedDialog: QBChatDialog?) -> Void in
//                    guard let dialog = loadedDialog else {
//                        return
//                    }
//                    self.openChat(dialog)
//                })
//            }
//        }

        if(application.applicationState == .inactive)
        {
            print("user tapped the notification bar when the app is in background")
        }
        completionHandler()
    }

    //MARK: Help
//    func openChat(_ chatDialog: QBChatDialog) {
//
//        if let controller = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController {
//            let ass = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
//            let nav = ass.viewControllers![0] as! UINavigationController
//
//            for currentController in nav.viewControllers as Array {
//                if currentController.isKind(of: CallViewController.self) {
//                    controller.dialogID = chatDialog.id
//                    nav.pushViewController(controller, animated: true)
//                }
//            }
//        }
//}
}
 /* Version Check  Code By Prasuna on 9th April 2020  - starts here  */

class VersionCheck {
    
    public static let shared = VersionCheck()
    
    var newVersionAvailable: Bool?
    var appStoreVersion: String?
    
    func checkAppStore(callback: ((_ versionAvailable: Bool?, _ version: String?)->Void)? = nil) {
        let ourBundleId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
        Alamofire.request("https://itunes.apple.com/lookup?bundleId=\(ourBundleId)").responseJSON { response in
            var isNew: Bool?
            var versionStr: String?
            
            if let json = response.result.value as? NSDictionary,
                let results = json["results"] as? NSArray,
                let entry = results.firstObject as? NSDictionary,
                let appVersion = entry["version"] as? String,
                let ourVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            {
                isNew = ourVersion != appVersion
                versionStr = appVersion
            }else
            {
                isNew = false
            }
            
            self.appStoreVersion = versionStr
            self.newVersionAvailable = isNew
            callback?(isNew, versionStr)
        }
    }
}
 /* Version Check  Code By Prasuna on 9th April 2020  - ends here  */

//extension AppDelegate : AppsFlyerTrackerDelegate {
//    @objc func sendLaunch(app:Any) {
//        AppsFlyerTracker.shared().trackAppLaunch()
//    }
//    // Deeplinking
//
//    // Open URI-scheme for iOS 8 and below
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        AppsFlyerTracker.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
//        return true
//    }
//
//    // Open Univerasal Links
//    // For Swift version < 4.2 replace function signature with the commented out code
//    // func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool { // this line for Swift < 4.2
//    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//        AppsFlyerTracker.shared().continue(userActivity, restorationHandler: nil)
//        return true
//    }
//
//    // Report Push Notification attribution data for re-engagements
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        AppsFlyerTracker.shared().handlePushNotification(userInfo)
//    }
//
//    // AppsFlyerTrackerDelegate implementation
//
//    //Handle Conversion Data (Deferred Deep Link)
//    func onConversionDataSuccess(_ data: [AnyHashable: Any]) {
//        print("\(data)")
//        if let status = data["af_status"] as? String{
//            if(status == "Non-organic"){
//                if let sourceID = data["media_source"] , let campaign = data["campaign"]{
//                    print("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
//                }
//            } else {
//                print("This is an organic install.")
//            }
//            if let is_first_launch = data["is_first_launch"] , let launch_code = is_first_launch as? Int {
//                if(launch_code == 1){
//                    print("First Launch")
//                } else {
//                    print("Not First Launch")
//                }
//            }
//        }
//    }
//    func onConversionDataFail(_ error: Error) {
//        print("\(error)")
//    }
//
//    //Handle Direct Deep Link
//    func onAppOpenAttribution(_ attributionData: [AnyHashable: Any]) {
//        //Handle Deep Link Data
//        print("onAppOpenAttribution data:")
//        for (key, value) in attributionData {
//            print(key, ":",value)
//        }
//    }
//    func onAppOpenAttributionFailure(_ error: Error) {
//        print("\(error)")
//    }
//
//    // support for scene delegate
//    // MARK: UISceneSession Lifecycle
//    @available(iOS 13.0, *)
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//    @available(iOS 13.0, *)
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
//}

     
