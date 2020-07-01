//  ChatVC.swift
//  LTW
//  Created by Vaayoo on 24/09/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import SwiftyJSON
import NVActivityIndicatorView
import Alamofire
import MobileCoreServices
import AssetsLibrary
import Photos
import AVFoundation
import MediaPlayer
import AVKit
import IQKeyboardManagerSwift
import PDFReader

class ChatVC: UIViewController,UITableViewDataSource,UITableViewDelegate ,UIImagePickerControllerDelegate,UINavigationControllerDelegate,VideoServiceDelegate{
    
    
    func videoDidFinishSaving(obj: [String : Any]) {
        doneBtn.isEnabled = true
        var isReplace = false
        for i in 0..<videosArray.count{
            let str = videosArray[i]
            if str == "removed"{
                if let object = obj["filePath"] //fileName
                {
                    videosArray[i] = object as! String
                    videoThumbnailsArray[i] = (object as! String).replacingOccurrences(of: ".mp4", with: ".jpg")
                }
                isReplace = true
                break
            }
            
        }
        if !isReplace{
            if let object = obj["filePath"] as? String{
                videosArray.append(object)
                videoThumbnailsArray.append((object as String).replacingOccurrences(of: ".mp4", with: ".jpg"))
            }
        }
        let result = (obj["filePath"] as! NSString).lowercased.hasPrefix("https://")
        checkContraints()
        let videoFolderPath = AppConstants().getVideosFolder()
        
        
        if !result{
            let isPath = true
            if isPath {
                if (obj["filePath"] as! String).contains("var")
                {
                    let videoPath = (videoFolderPath as String) + "/".appending(obj["fileName"] as! String)
                    
                    let fileExists = FileManager.default.fileExists(atPath:videoPath )
                    
                    if fileExists
                    {
                        DispatchQueue.main.async {
                            let singleFrameImage = self.generateThumbnail(path: URL.init(fileURLWithPath: videoPath))
                            let anIndex = self.videosArray.firstIndex(of: obj["filePath"] as! String)
                            if anIndex == 0{
                                self.v_img_text1.image = singleFrameImage
                                let vidImage = UIImageView.init(frame: CGRect.init(x: self.v_img_text1.frame.size.width/2-10, y: self.v_img_text1.frame.size.height/2-10, width: 20, height: 20))
                                vidImage.image = UIImage.init(named: "playbutton")
                                self.v_img_text1.addSubview(vidImage)
                                
                                self.v_img_text1.setRounded()
                                self.btn_removev1.isHidden = false
                                self.v_img_text1.tag = 11
                                self.v_img_text1.isUserInteractionEnabled = true
                                let gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap1(gesture:)))
                                gesture1.numberOfTapsRequired = 1
                                self.v_img_text1.addGestureRecognizer(gesture1)
                            }
                            else if anIndex == 1{
                                self.v_img_text2.image = singleFrameImage
                                let vidImage = UIImageView.init(frame: CGRect.init(x: self.v_img_text2.frame.size.width/2-10, y: self.v_img_text2.frame.size.height/2-10, width: 20, height: 20))
                                vidImage.image = UIImage.init(named: "playbutton")
                                self.v_img_text2.addSubview(vidImage)
                                self.v_img_text2.isUserInteractionEnabled = true
                                self.v_img_text2.setRounded()
                                self.btn_removev2.isHidden = false
                                self.v_img_text2.tag = 12
                                
                                let gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap1(gesture:)))
                                gesture1.numberOfTapsRequired = 1
                                self.v_img_text2.addGestureRecognizer(gesture1)
                            }
                            else if anIndex == 2{
                                self.v_img_text3.image = singleFrameImage
                                let vidImage = UIImageView.init(frame: CGRect.init(x: self.v_img_text3.frame.size.width/2-10, y: self.v_img_text3.frame.size.height/2-10, width: 20, height: 20))
                                vidImage.image = UIImage.init(named: "playbutton")
                                self.v_img_text3.addSubview(vidImage)
                                self.v_img_text3.isUserInteractionEnabled = true
                                self.v_img_text3.setRounded()
                                self.btn_removev3.isHidden = false
                                self.v_img_text3.tag = 13
                                
                                let gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap1(gesture:)))
                                gesture1.numberOfTapsRequired = 1
                                self.v_img_text3.addGestureRecognizer(gesture1)
                            }
                            else if anIndex == 3{
                                self.v_img_text4.image = singleFrameImage
                                let vidImage = UIImageView.init(frame: CGRect.init(x: self.v_img_text4.frame.size.width/2-10, y: self.v_img_text4.frame.size.height/2-10, width: 20, height: 20))
                                vidImage.image = UIImage.init(named: "playbutton")
                                self.v_img_text4.addSubview(vidImage)
                                self.v_img_text4.isUserInteractionEnabled = true
                                self.v_img_text4.setRounded()
                                self.btn_removev4.isHidden = false
                                self.v_img_text4.tag = 14
                                
                                let gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap1(gesture:)))
                                gesture1.numberOfTapsRequired = 1
                                self.v_img_text4.addGestureRecognizer(gesture1)
                            }
                            else if anIndex == 4{
                                self.v_img_text5.image = singleFrameImage
                                let vidImage = UIImageView.init(frame: CGRect.init(x: self.v_img_text5.frame.size.width/2-10, y: self.v_img_text5.frame.size.height/2-10, width: 20, height: 20))
                                vidImage.image = UIImage.init(named: "playbutton")
                                self.v_img_text5.addSubview(vidImage)
                                self.v_img_text5.isUserInteractionEnabled = true
                                self.v_img_text5.setRounded()
                                self.btn_removev5.isHidden = false
                                self.v_img_text5.tag = 15
                                
                                let gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap1(gesture:)))
                                gesture1.numberOfTapsRequired = 1
                                self.v_img_text5.addGestureRecognizer(gesture1)
                            }
                        }
                    }
                }
            }
        }
    }
    func imagePickerdidfinishLoaded(withData mediaData: [String : Any], and imagestamp: String) {
        doneBtn.isEnabled = true
        if (mediaData["fileName"] as! String).contains(".jpg")
        {
            var isReplace = false
            for k in 0..<imagesArray.count {
                let str = imagesArray[k]
                if (str == "removed") {
                    if let object = mediaData["filePath"] {
                        imagesArray[k] = object as! String
                    }
                    isReplace = true
                    break
                }
            }
            if !isReplace {
                if let object:String = mediaData["filePath"] as? String {
                    
                    imagesArray.append(object)
                }
            }
            
            
            self.checkContraints()
            
            let result = (mediaData["filePath"] as! NSString).lowercased.hasPrefix("https://")
            
            let _imgfolderPath = AppConstants().getImagesFolder()
            if !(result) {
                
                let isPath = true
                if isPath {
                    
                    
                    if (mediaData["filePath"] as! String).contains("var")
                    {
                        let imagesPath = (_imgfolderPath as String) + "/".appending(mediaData["fileName"] as! String)
                        
                        let fileExists = FileManager.default.fileExists(atPath:imagesPath )
                        
                        if fileExists
                        {
                            DispatchQueue.main.async {
                                
                                
                                let anIndex = self.imagesArray.firstIndex(of: mediaData["filePath"] as! String)
                                if anIndex == 0{
                                    self.img_text1.image = UIImage(contentsOfFile: imagesPath)
                                    self.img_text1.setRounded()
                                    self.btn_remove1.isHidden = false
                                    let gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gesture:)))
                                    gesture1.numberOfTapsRequired = 1
                                    self.img_text1.isUserInteractionEnabled = true
                                    self.img_text1.addGestureRecognizer(gesture1)
                                }
                                else if anIndex == 1
                                {
                                    self.img_text2.image = UIImage(contentsOfFile: imagesPath)
                                    self.img_text2.setRounded()
                                    self.btn_remove2.isHidden = false
                                    let gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gesture:)))
                                    gesture1.numberOfTapsRequired = 1
                                    self.img_text2.isUserInteractionEnabled = true
                                    self.img_text2.addGestureRecognizer(gesture1)
                                    
                                }
                                else if anIndex == 2
                                {
                                    self.img_text3.image = UIImage(contentsOfFile: imagesPath)
                                    self.img_text3.setRounded()
                                    self.btn_remove3.isHidden = false
                                    let gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gesture:)))
                                    gesture1.numberOfTapsRequired = 1
                                    self.img_text3.isUserInteractionEnabled = true
                                    self.img_text3.addGestureRecognizer(gesture1)
                                    
                                    
                                }
                                else if anIndex == 3
                                {
                                    self.img_text4.image = UIImage(contentsOfFile: imagesPath)
                                    self.img_text4.setRounded()
                                    self.btn_remove4.isHidden = false
                                    let gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gesture:)))
                                    gesture1.numberOfTapsRequired = 1
                                    self.img_text4.isUserInteractionEnabled = true
                                    self.img_text4.addGestureRecognizer(gesture1)
                                    
                                    
                                }
                                else if anIndex == 4
                                {
                                    self.img_text5.image = UIImage(contentsOfFile: imagesPath)
                                    self.img_text5.setRounded()
                                    self.btn_remove5.isHidden = false
                                    let gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gesture:)))
                                    gesture1.numberOfTapsRequired = 1
                                    self.img_text5.isUserInteractionEnabled = true
                                    self.img_text5.addGestureRecognizer(gesture1)
                                }
                            }
                            
                            
                        }
                        
                        
                    }
                    
                }
            }
            
            
            
        }
        
    }
    @objc func handleTap(gesture: UITapGestureRecognizer){
        let view = gesture.view
        if imagesArray.count > 0 && imagesArray.count >= view!.tag //+ 1
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "imageSwipe") as! ImageSwipeVC
            vc.uploadView = false
            vc.imagesArray = imagesArray
            vc.indexPath = IndexPath.init(row: view!.tag-1, section: 0)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @objc func handleTap1(gesture: UITapGestureRecognizer){
        let view = gesture.view
        if videosArray.count > 0 && videosArray.count >= view!.tag - 10
        {
            playVideo(file: videosArray[view!.tag-11])
            
        }
    }
    func playVideo(file: String){
        let videoFolderPath = AppConstants().getVideosFolder()
        let videoPath = "\(videoFolderPath)/\((file as NSString).lastPathComponent)"
        let isExist = FileManager.default.fileExists(atPath: videoPath)
        if isExist
        {
            playMovie(url: URL.init(fileURLWithPath: videoPath))
        }
        else{
            playMovie(url: URL.init(string: file)!)
        }
    }
    private func playMovie(url: URL) {
        let player = AVPlayer.init(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        
        present(vc, animated: true) {
            vc.player?.play()
        }
    }
    @objc func handleDocTap(gesture: UITapGestureRecognizer){
        let view = gesture.view
        if docsArray.count > 0 && docsArray.count >= view!.tag - 10
        {
        }
    }
    func dismissMediaDeviceView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerdidCancelled() {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    @IBOutlet weak var tbl_chat: UITableView!
    
    //Chat text box items.
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var view_imageText: UIView!
    @IBOutlet weak var view_videoText: UIView!
    @IBOutlet weak var view_docText: UIView!
    @IBOutlet weak var view_imgheoght: NSLayoutConstraint!
    @IBOutlet weak var view_containerheight: NSLayoutConstraint!
    
    @IBOutlet weak var view_videoheoght: NSLayoutConstraint!
    @IBOutlet weak var view_docsheoght: NSLayoutConstraint!
    @IBOutlet weak var img_text1: UIImageView!
    @IBOutlet weak var img_text2: UIImageView!
    @IBOutlet weak var img_text3: UIImageView!
    @IBOutlet weak var img_text4: UIImageView!
    @IBOutlet weak var img_text5: UIImageView!
    @IBOutlet weak var v_img_text1: UIImageView!
    @IBOutlet weak var v_img_text2: UIImageView!
    @IBOutlet weak var v_img_text3: UIImageView!
    @IBOutlet weak var v_img_text4: UIImageView!
    @IBOutlet weak var v_img_text5: UIImageView!
    @IBOutlet weak var d_img_text1: UIImageView!
    @IBOutlet weak var d_img_text2: UIImageView!
    @IBOutlet weak var d_img_text3: UIImageView!
    @IBOutlet weak var d_img_text4: UIImageView!
    @IBOutlet weak var d_img_text5: UIImageView!
    @IBOutlet weak var btn_remove1: UIButton!
    @IBOutlet weak var btn_remove2: UIButton!
    @IBOutlet weak var btn_remove3: UIButton!
    @IBOutlet weak var btn_remove4: UIButton!
    @IBOutlet weak var btn_remove5: UIButton!
    @IBOutlet weak var btn_removev1: UIButton!
    @IBOutlet weak var btn_removev2: UIButton!
    @IBOutlet weak var btn_removev3: UIButton!
    @IBOutlet weak var btn_removev4: UIButton!
    @IBOutlet weak var btn_removev5: UIButton!
    @IBOutlet weak var btn_removed1: UIButton!
    @IBOutlet weak var btn_removed2: UIButton!
    @IBOutlet weak var btn_removed3: UIButton!
    @IBOutlet weak var btn_removed4: UIButton!
    @IBOutlet weak var btn_removed5: UIButton!
    
    var vSpinner : UIView?
    var data:Int!
    private var lastContentOffset: CGFloat = 0
    var addlbl = UILabel() // add by chandra on 4th jun
    //data storage
    
    
    var doneBtn:UIButton!
    var addButton:UIButton!
    var imagesArray = [String]()
    var videoThumbnailsArray = [String]()
    var videosArray = [String]()
    var docsArray = [String]()
    var newFrame:CGRect!
    
    
    var caseID:String!
    var textView = HPGrowingTextView()
    var formatter = DateFormatter()
    var serverMessages = [ChatMessage]()
    var chatMessages = [[ChatMessage]]()
    fileprivate let cellId = "chatCell"
    
    
    var isPost : Bool = false
    var text : String!
    var discussionId :String!
    //    var callservise =  BaseService()
    var cell: ChatNewCell!
    var refreshControl = UIRefreshControl()
    var index = 0
    var count = 300
    let dateFormatter = DateFormatter()
    var naviTitle: String?
   /* Added By Chandra on 28th Jan 2020 - starts here  */
    var timer = Timer()  // Auto Reload in Chat
    var localChat = false  // Auto Reload in Chat
    var hit5sec: Int! // Auto Reload in Chat
    var scroolCheck:Int!
    var countOne:Int!
    var countTwo:Int!
    var scroolUp:Int!
   /* Added By Chandra on 28th Jan 2020 - ends here  */

    override func viewDidLoad() {
        super.viewDidLoad()
        scroolCheck = 0
        // Do any additional setup after loading the view.
        self.title = naviTitle!
        IQKeyboardManager.shared.enable = false
        startAnimating(type:.ballSpinFadeLoader,color: UIColor.green)
        //viewModel.hitServer(caseId:"44")
        tbl_chat.allowsSelection = false
        tbl_chat.rowHeight = UITableView.automaticDimension
        tbl_chat.estimatedRowHeight = UITableView.automaticDimension
        dateFormatter.dateFormat = "MM/dd/yyyy"
        view_containerheight.constant = 60
        hideRemoveButtons(isHidden: true)
            setUpTextView()
        if currentReachabilityStatus != .notReachable {
            self.serverMessages.removeAll()
            let point = "\(Endpoints.getChatMessagebyIndex + discussionId)/\(index)/\(count)"
            scrollToLastIndex() // add by chandra on 2 june
            hitServer(params: [:], endPoint: point,  action: "MessagesTopList", httpMethod: .get)
            
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
            })
        }
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(loadTop),for: .valueChanged)
        tbl_chat.addSubview(refreshControl)
        
        addGalleryButton()
//        scheduledTimerWithTimeInterval() // Auto Reload in Chat Screen /* Added By Chandra on 28th Jan 2020 */
    }
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        print("labelTapped")
        scroolCheck = 0
        scroolUp = 2
        addlbl.isHidden = true
        scrollToBottom()
        scrollToLastIndex()
    }
    
    func setupLabelTap() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        addlbl.isUserInteractionEnabled = true
        addlbl.addGestureRecognizer(labelTap)
        
    }
    /* Added By Chandra on 28th Jan 2020  - starts here */
    // Mark: Auto Reload in Chat Screen
    func scheduledTimerWithTimeInterval(){
        self.serverMessages.removeAll()
        hit5sec = 1
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(updateCounting), userInfo: nil, repeats: true)
    }
    
    private func newMsg(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) { LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){ [weak self] result in
           guard let _self = self else {
               return
           }
           
           _self.stopAnimating()
           switch result {
           case let .success(json,_):
               let msg = json["message"].stringValue
               if json["error"].intValue == 1 {
                   showMessage(bodyText: msg,theme: .error)
               }
               else {
                if let msgData = json["ControlsData"].dictionaryValue["messageList"]?.arrayObject as? Array<Dictionary<String, Any>> {
                              var dataarr1 = [String]()
                                for obj in msgData{
                                    let data = obj["UserID"] as! String
                                    if data == UserDefaults.standard.string(forKey: "userID") {

                                    }else{
                                       dataarr1.append(data)
                                    }
                                }
                               _self.countTwo = dataarr1.count
                                  var newmsgCount :Int!
                                  newmsgCount = _self.countTwo - _self.countOne
                    if newmsgCount == 0{
                        _self.addlbl.isHidden = true
                    }else{
                        _self.addlbl.isHidden = false
                        _self.addlbl.text = String(newmsgCount!)
                    }
//                    _self.addlbl.text = String(newmsgCount!)
                    print(newmsgCount)
                    
                            }// add by chandra for getting msg count
//                var dataarr1 = [String]()
//                for obj in msgData!{
//                            var data = obj["UserID"].str
//                               if data == UserDefaults.standard.string(forKey: "userID") {
//
//                               }else{
//                                  dataarr1.append(data)
//                               }
//                           }
//                _self.countTwo = dataarr1.count
//
//                var newmsgCount :Int!
//                newmsgCount = _self.countTwo - _self.countOne
               }
               break
           case .failure(let error):
               print("MyError = \(error)")
               break
           }
           }
       }
    @objc func updateCounting(){
        print("counting..")
        hit5sec = 1
        let point = "\(Endpoints.getChatMessagebyIndex + discussionId)/\(index)/\(count)"
        if scroolUp == 1{
            newMsg(params: [:], endPoint: point, action: "MessagesTopList", httpMethod: .get)
           // hitServer(params: [:], endPoint: point, action: "MessagesTopList", httpMethod: .get)
        }else{
            hitServer(params: [:], endPoint: point, action: "MessagesTopList", httpMethod: .get)
        }
//        hitServer(params: [:], endPoint: point, action: "MessagesTopList", httpMethod: .get)
    }
      /* Added By Chandra on 28th Jan 2020  - ends  here */
    
    
    func addGalleryButton(){
        let button = UIButton(type: .custom)
               /*Added By Chandrashekhar on 17th-Nov-2019 [From Here]*/
               button.setImage(UIImage.init(named: "galleryIcon"), for: .normal)
               button.setTitleColor(UIColor.white, for: .normal)
               /*Added By Chandrashekhar on 17th-Nov-2019 [Till Here]*/
               
               //button.imageView?.contentMode = .center
               button.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
               button.addTarget(self, action: #selector(openGalleryForm), for: .touchUpInside)
               let barButton = UIBarButtonItem(customView: button)
               
               self.navigationItem.rightBarButtonItems = [barButton]
    }
    
    
    @objc func refreshChat(){
         serverMessages.removeAll()
        let point = "\(Endpoints.getChatMessagebyIndex + discussionId)/\(index)/\(count)"
        hitServer(params: [:], endPoint: point, action: "MessagesList", httpMethod: .get)
    }
    @objc func openGalleryForm(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "galleryV") as! GalleryVC
        vc.discussionId = discussionId
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func loadTop()  {
        if currentReachabilityStatus != .notReachable {
            refreshControl.beginRefreshing()
            let point = "\(Endpoints.getChatMessagebyIndex + discussionId)/\(index)/\(count)"
            hitServer(params: [:], endPoint: point,  action: "MessagesTopList", httpMethod: .get)
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
            })
        }
    }
    
    
    @objc func reload()
    {
        self.serverMessages = []
        self.chatMessages = []
        self.tbl_chat.reloadData()
        //openEndPoint()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        containerView.setNeedsLayout()
        containerView.layoutIfNeeded()
        
    }
    
    
    
    // MARK: - Sending Message subview
    override func viewWillAppear(_ animated: Bool) {
        addlbl.font = UIFont.systemFont(ofSize: 15) // add by chandra on 4 th jun
        addlbl.layer.cornerRadius = 10 // add by chandra on 4 th jun
        addlbl.layer.masksToBounds = true // add by chandra on 4 th jun
        addlbl.isHidden = true
        setupLabelTap()
        scheduledTimerWithTimeInterval() // Auto Reload in Chat Screen /* Added By Chandra on 28th Jan 2020 */

        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = naviTitle!
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func toAdd()   {
        textView.resignFirstResponder()
        let alert = UIAlertController.init(title: "Top", message: "Message", preferredStyle: .actionSheet)
        let takePhoto = UIAlertAction.init(title: "Take Photo", style: .default) { (Action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let count = self.image()
                if count
                {
                    VideoService.instance.launchVideoRecorder(in: self, cameratype: "Photo", local: true, completion: {
                    })
                    VideoService.instance.delegate = self
                }
            }
            else{
                AppConstants().ShowAlert(vc: self, title:"No Camera", message:"")
            }
            
        }
        let choosePhoto = UIAlertAction.init(title: "Choose Photo", style: .default) { (Action) in
            let count = self.image()
            if count
            {
                VideoService.instance.launchVideoRecorder(in: self, cameratype: "Photo", local: false, completion: {
                })
                VideoService.instance.delegate = self
            }
        }
        let recordVideo = UIAlertAction.init(title: "Record Video", style: .default) { (Action) in
            let count = self.video()
            if count
            {
                VideoService.instance.launchVideoRecorder(in: self, cameratype: "Video", local: true, completion: {
                })
                VideoService.instance.delegate = self
                
            }
        }
        let chooseVideo = UIAlertAction.init(title: "Choose Video", style: .default) { (Action) in
            let count = self.video()
            if count
            {
                VideoService.instance.launchVideoRecorder(in: self, cameratype: "Video", local: false, completion: {
                })
                VideoService.instance.delegate = self
            }
        }
        
        
        let chooseWhiteBoard = UIAlertAction.init(title: "Use WhiteBoard ", style: .default) { (Action) in
            let count = self.image()
            if count
            {
                 guard let sharingVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
                               return
                           }
                sharingVC.delegate = self
                self.navigationController?.pushViewController(sharingVC, animated: true)
            }
        }
        
        let chooseDocument = UIAlertAction.init(title: "Choose Document", style: .default) { (Action) in
            let count = self.docs()
            if count
            {
                let documentProviderMenu = UIDocumentPickerViewController.init(documentTypes: ["public.text", "public.zip-archive", "com.pkware.zip-archive","public.composite-content"], in: .import)
                documentProviderMenu.delegate = self
                  /*  Added By Ranjeet on 31st March 2020 - starts here */
                if #available(iOS 13.0, *) {
                    UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.label], for: .normal)
                } else {
                    // Fallback on earlier versions
                }
                  /*  Added By Ranjeet on 31st March 2020 - ends here */
                
                self.present(documentProviderMenu, animated: true, completion: nil)
            }
        }
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(takePhoto)
        alert.addAction(choosePhoto)
        alert.addAction(chooseWhiteBoard)
        alert.addAction(recordVideo)
        alert.addAction(chooseVideo)
        alert.addAction(chooseDocument)
        alert.addAction(cancel)
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        self.present(alert, animated: true, completion: nil)
        
    }
    func setUpTextView(){

        view_containerheight.constant = 60
        view_imageText.isHidden = true
        view_videoText.isHidden = true
        view_docText.isHidden = true
        view_imgheoght.constant = 0
        view_videoheoght.constant = 0
        view_docsheoght.constant = 0
        
        let rect = UIScreen.main.bounds
        addButton = UIButton(type: .custom)
        addButton.frame = CGRect(x: 8, y: 13, width: 25, height: 27)
        
        addButton.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        
        addButton.isEnabled = true
        
        addButton.addTarget(self, action: #selector(toAdd), for: .touchUpInside)
        
       // textView = HPGrowingTextView(frame: CGRect(x: addButton.frame.size.width + 20, y: 10, width: rect.size.width - 90, height: 20))
         textView = HPGrowingTextView(frame: CGRect(x: addButton.frame.size.width + 20, y: 10, width: rect.size.width - 150, height: 20))
        textView.isScrollable = false
        
        textView.placeholder = "Type message..."
        textView.minNumberOfLines = 1
        textView.maxNumberOfLines = 2
        textView.returnKeyType = .default
        textView.delegate = self
        textView.backgroundColor = UIColor.white
        textView.layer.borderColor = UIColor(red: 0.82, green: 0.82, blue: 0.843, alpha: 1).cgColor
        textView.layer.cornerRadius = 10.0
        textView.layer.masksToBounds = true
        textView.layer.borderWidth = 1.0
        
        let rawBackground = UIImage(named: "white.png")
        let background = rawBackground?.stretchableImage(withLeftCapWidth: 13, topCapHeight: 22)
        let imageView = UIImageView(image: background)
        
        imageView.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height)
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            var frame = containerView.frame
            frame.size.width = view.bounds.size.width
            containerView.frame = frame
        }
        view.bringSubviewToFront(containerView)
        doneBtn = UIButton(type: .custom)
        doneBtn.frame = CGRect(x: addButton.frame.size.width + textView.frame.size.width + 25, y: 10, width: 34, height: 28)
        doneBtn.setImage(#imageLiteral(resourceName: "Asset 93"), for: .normal)
        doneBtn.isEnabled = false
        doneBtn.addTarget(self, action: #selector(post), for: .touchUpInside)
        containerView.addSubview(doneBtn)
       // add by chandra start hre on 4 th jun
        
        let doneBtn1 = UIButton(type: .custom)
        doneBtn1.frame = CGRect(x: addButton.frame.size.width + textView.frame.size.width + 25 + doneBtn.frame.size.width + 25, y: -5, width: 34, height: 40)
        doneBtn1.setImage(#imageLiteral(resourceName:"dropdown"), for: .normal)
//        doneBtn1.isEnabled = false
//        doneBtn1.addTarget(self, action: #selector(post), for: .touchUpInside)
         doneBtn1.addTarget(self, action: #selector(downArraw), for: .touchUpInside)
        containerView.addSubview(doneBtn1)
        
        
        addlbl.backgroundColor = .red
        addlbl.textAlignment = .center
        addlbl.textColor = .white
        addlbl.textColor = UIColor.init(hex: "2DA9EC") // add by chandra on 4th jun
        addlbl.frame = CGRect(x: addButton.frame.size.width + textView.frame.size.width + 25 + doneBtn.frame.size.width + 33, y: -5, width: 25, height: 25)
        containerView.addSubview(addlbl)
     // add by chandra ends hre on 4 th jun
        
        containerView.addSubview(addButton)
        containerView.addSubview(textView)
        
        
    }
    func scrollToBottom(){
        let point = CGPoint(x: 0, y: self.tbl_chat.contentSize.height + self.tbl_chat.contentInset.bottom - self.tbl_chat.frame.height)
        if point.y >= 0{
            self.tbl_chat.setContentOffset(point, animated: false)
        }
    }
    @objc func downArraw()
    {
        scroolCheck = 0
        scroolUp = 2
        addlbl.isHidden = true
        scrollToBottom()
        scrollToLastIndex()
    }
    // MARK: Container methods
    
    func hideRemoveButtons(isHidden: Bool){
        btn_remove1.isHidden = isHidden
        btn_remove2.isHidden = isHidden
        btn_remove3.isHidden = isHidden
        btn_remove4.isHidden = isHidden
        btn_remove5.isHidden = isHidden
        
        btn_removev1.isHidden = isHidden
        btn_removev2.isHidden = isHidden
        btn_removev3.isHidden = isHidden
        btn_removev4.isHidden = isHidden
        btn_removev5.isHidden = isHidden
        
        btn_removed1.isHidden = isHidden
        btn_removed2.isHidden = isHidden
        btn_removed3.isHidden = isHidden
        btn_removed4.isHidden = isHidden
        btn_removed5.isHidden = isHidden
    }
    func setSpaceForAnyTwo() {
        view_containerheight.constant = 180
        newFrame = containerView.frame
        newFrame.size.height = 195
        containerView.frame = newFrame
    }
    func setSpaceForOnlyImagesView() {
        view_containerheight.constant = 185 - 53
        view_imageText.isHidden = false
        view_videoText.isHidden = true
        view_docText.isHidden = true
        view_imgheoght.constant = 53
        view_videoheoght.constant = 0
        view_docsheoght.constant = 0
        newFrame = containerView.frame
        newFrame.size.height = 145
        containerView.frame = newFrame
    }
    
    func setSpaceForOnlyVideosView() {
        view_containerheight.constant = 185 - 53
        view_imageText.isHidden = true
        view_videoText.isHidden = false
        view_docText.isHidden = true
        //        tbl_height.constant = 140
        view_imgheoght.constant = 0
        view_videoheoght.constant = 53
        view_docsheoght.constant = 0
        newFrame = containerView.frame
        newFrame.size.height = 145
        containerView.frame = newFrame
    }
    
    func setSpaceForOnlyDocsView() {
        view_containerheight.constant = 185 - 53
        view_imageText.isHidden = true
        view_videoText.isHidden = true
        view_docText.isHidden = false
        
        view_imgheoght.constant = 0
        view_videoheoght.constant = 0
        view_docsheoght.constant = 53
        newFrame = containerView.frame
        newFrame.size.height = 145
        containerView.frame = newFrame
    }
    
    func defaultT() {
        
        view_containerheight.constant = 60
        //        tbl_height.constant = 80 //60
        view_imageText.isHidden = true
        view_videoText.isHidden = true
        view_docText.isHidden = true
        view_imgheoght.constant = 0
        view_videoheoght.constant = 0
        view_docsheoght.constant = 0
        newFrame = containerView.frame
        newFrame.size.height = 80 //60
        containerView.frame = newFrame
    }
    
    func checkContraints(){
        textView.resignFirstResponder()
        if imagesArray.count > 0 || videosArray.count > 0 || docsArray.count > 0{
            var isImgVarFound = false
            var isVidVarFound = false
            var isDocVarFound = false
            
            for str in imagesArray {
                if str.contains("var") {
                    isImgVarFound = true
                    break
                } else {
                    isImgVarFound = false
                }
            }
            for str in videosArray {
                if str.contains("var") {
                    isVidVarFound = true
                    break
                } else {
                    isVidVarFound = false
                }
            }
            for str in docsArray {
                if !str.contains("removed") {
                    isDocVarFound = true
                    break
                } else {
                    isDocVarFound = false
                }
            }
            
            if isImgVarFound && isVidVarFound && isDocVarFound {
                view_containerheight.constant = 238
                view_imageText.isHidden = false
                view_videoText.isHidden = false
                view_docText.isHidden = false
                view_imgheoght.constant = 53
                view_videoheoght.constant = 53
                view_docsheoght.constant = 53
                newFrame = containerView.frame
                newFrame.size.height = 195
                containerView.frame = newFrame
                
            }else if isImgVarFound && isVidVarFound {
                view_imageText.isHidden = false
                view_videoText.isHidden = false
                view_docText.isHidden = true
                view_imgheoght.constant = 53
                view_videoheoght.constant = 53
                view_docsheoght.constant = 0
                setSpaceForAnyTwo()
            } else if isVidVarFound && isDocVarFound {
                view_imageText.isHidden = true
                view_videoText.isHidden = false
                view_docText.isHidden = false
                view_imgheoght.constant = 0
                view_videoheoght.constant = 53
                view_docsheoght.constant = 53
                setSpaceForAnyTwo()
            } else if isDocVarFound && isImgVarFound {
                // add by chandra for image hiding in mulitiple selactionfo deffert in botton of the chat
                // view_imageText.isHidden = true // commented by chandra
                view_imageText.isHidden = false // added by chandra
                view_videoText.isHidden = false
                view_docText.isHidden = false
                view_imgheoght.constant = 53
                view_videoheoght.constant = 0
                view_docsheoght.constant = 53
                setSpaceForAnyTwo()
            } else if !isImgVarFound && isVidVarFound && !isDocVarFound {
                setSpaceForOnlyVideosView()
            } else if isImgVarFound && !isVidVarFound && !isDocVarFound {
                setSpaceForOnlyImagesView()
            } else if !isImgVarFound && !isVidVarFound && isDocVarFound {
                setSpaceForOnlyDocsView()
            } else {
                defaultT()
            }
        }
    }
    func image() -> Bool {
        var isFine = true
        if imagesArray.count == 5 {
            // Do not add anymore since the array reached Max count
            for str in imagesArray {
                if (str == "removed") {
                    isFine = true
                    break
                } else {
                    isFine = false
                }
            }
        } else {
            isFine = true
        }
        if isFine {
            return isFine
        } else {
            
            //Write an alert here to notify user has reached max count
            AppConstants().ShowAlert(vc: self, title: "Message", message: "You can not add more than 5 images")
            return isFine
        }
        
    }
    func video() -> Bool {
        var isFine = true
        if videosArray.count == 5 {
            // Do not add anymore since the array reached Max count
            for str in videosArray {
                if (str == "removed") {
                    isFine = true
                    break
                } else {
                    isFine = false
                }
            }
        } else {
            isFine = true
        }
        if isFine {
            return isFine
        } else {
            //here you go..
            AppConstants().ShowAlert(vc: self, title: "Message", message: "You can not add more than 5 videos")
            
            return isFine
        }
    }
    
    func docs() -> Bool {
        var isFine = true
        if docsArray.count == 5 {
            // Do not add anymore since the array reached Max count
            for str in docsArray {
                if (str == "removed") {
                    isFine = true
                    break
                } else {
                    isFine = false
                }
            }
        } else {
            isFine = true
        }
        if isFine {
            return isFine
        } else {
            //here you go..
            AppConstants().ShowAlert(vc: self, title: "Message", message: "You can not add more than 5 documents")
            
            return isFine
        }
    }
    
    // MARK: -
    
    
    @IBAction func btnRemove1(_ sender: Any) {
        btn_remove1.isHidden = true
        img_text1.image = nil;
        imagesArray[btn_remove1.tag] = "removed"
        checkContraints()
    }
    @IBAction func btnRemove2(_ sender: Any) {
        btn_remove2.isHidden = true
        img_text2.image = nil;
        imagesArray[btn_remove2.tag] = "removed"
        checkContraints()
    }
    @IBAction func btnRemove3(_ sender: Any) {
        btn_remove3.isHidden = true
        img_text3.image = nil;
        imagesArray[btn_remove3.tag] = "removed"
        checkContraints()
    }
    @IBAction func btnRemove4(_ sender: Any) {
        btn_remove4.isHidden = true
        img_text4.image = nil;
        imagesArray[btn_remove4.tag] = "removed"
        checkContraints()
    }
    @IBAction func btnRemove5(_ sender: Any) {
        btn_remove5.isHidden = true
        img_text5.image = nil;
        imagesArray[btn_remove5.tag] = "removed"
        checkContraints()
    }
    
    @IBAction func btnRemoveV1(_ sender: Any) {
        btn_removev1.isHidden = true
        v_img_text1.image = nil;
        videosArray[btn_removev1.tag-11] = "removed"
        videoThumbnailsArray[btn_removev1.tag-11] = "removed"
        checkContraints()
    }
    @IBAction func btnRemoveV2(_ sender: Any) {
        btn_removev2.isHidden = true
        v_img_text2.image = nil;
        videosArray[btn_removev2.tag-11] = "removed"
        videoThumbnailsArray[btn_removev2.tag-11] = "removed"
        checkContraints()
    }
    @IBAction func btnRemoveV3(_ sender: Any) {
        btn_removev3.isHidden = true
        v_img_text3.image = nil;
        videosArray[btn_removev3.tag-11] = "removed"
        videoThumbnailsArray[btn_removev3.tag-11] = "removed"
        checkContraints()
    }
    @IBAction func btnRemoveV4(_ sender: Any) {
        btn_removev4.isHidden = true
        v_img_text4.image = nil;
        videosArray[btn_removev4.tag-11] = "removed"
        videoThumbnailsArray[btn_removev4.tag-11] = "removed"
        checkContraints()
    }
    @IBAction func btnRemoveV5(_ sender: Any) {
        btn_removev5.isHidden = true
        v_img_text5.image = nil;
        videosArray[btn_removev5.tag-11] = "removed"
        videoThumbnailsArray[btn_removev5.tag-11] = "removed"
        checkContraints()
    }
    
    @IBAction func btnRemoveD1(_ sender: Any) {
        btn_removed1.isHidden = true
        d_img_text1.image = nil;
        docsArray[btn_removed1.tag-110] = "removed"
        checkContraints()
    }
    @IBAction func btnRemoveD2(_ sender: Any) {
        btn_removed2.isHidden = true
        d_img_text2.image = nil;
        docsArray[btn_removed2.tag-110] = "removed"
        checkContraints()
    }
    @IBAction func btnRemoveD3(_ sender: Any) {
        btn_removed3.isHidden = true
        d_img_text3.image = nil;
        docsArray[btn_removed3.tag-110] = "removed"
        checkContraints()
    }
    @IBAction func btnRemoveD4(_ sender: Any) {
        btn_removed4.isHidden = true
        d_img_text4.image = nil;
        docsArray[btn_removed4.tag-110] = "removed"
        checkContraints()
    }
    @IBAction func btnRemoveD5(_ sender: Any) {
        btn_removed5.isHidden = true
        d_img_text5.image = nil;
        docsArray[btn_removed5.tag-110] = "removed"
        checkContraints()
    }
    
    @objc func keyboardWillShow(_ note: Notification) {
        var keyboardBounds = CGRect.zero
        (note.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).getValue(&keyboardBounds)
        
        
        // Need to translate the bounds to account for rotation.
        keyboardBounds = view.convert(keyboardBounds, to: nil)
        
        // get a rect for the textView frame
        var containerFrame: CGRect = containerView.frame
        containerFrame.origin.y = view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height)
        // animations settings
        // set views with new info
        containerView.frame = containerFrame
        
        tbl_chat.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardBounds.size.height, right: 0)
        scrollToLastIndex()
        
    }
    func scrollToLastIndex(){
        DispatchQueue.main.async {
            if self.chatMessages.count > 0{
                let section = self.tbl_chat.numberOfSections - 1
                let row = self.tbl_chat.numberOfRows(inSection: section)
                let indexPath = IndexPath.init(row: row - 1, section: section)
                self.tbl_chat.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    @objc func keyboardWillHide(_ note: Notification?) {
        var containerFrame: CGRect = containerView.frame
        containerFrame.origin.y = view.bounds.size.height - containerFrame.size.height
        containerView.frame = containerFrame
        tbl_chat.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom:0, right: 0)
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        IQKeyboardManager.shared.enable = true
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        timer.invalidate()
    }
    func growingTextViewDidChangeSelection(_ growingTextView: HPGrowingTextView) {
        
        if growingTextView.text.count > 0{
            let trim = growingTextView.text.trim()
            if trim.count != 0{
                doneBtn.isEnabled = true
                /*  Added By Ranjeet on 31st March 2020 - starts here */
                if #available(iOS 13.0, *) {
                    doneBtn.setTitleColor(UIColor.label, for: .normal)
                } else {
                    // Fallback on earlier versions
                }
                  /*  Added By Ranjeet on 31st March 2020 - starts here */
            }
        }
        else{
            doneBtn.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    // Post message
    @objc func post()
    {
        doneBtn.isEnabled = false
        textView.resignFirstResponder()
        text = textView.text.trim()
        if text.count != 0 || imagesArray.count != 0 || videosArray.count != 0 || docsArray.count != 0{
            isPost = true
            imagesArray.removeAll {$0 == "removed"}
            videosArray.removeAll {$0 == "removed"}
            videoThumbnailsArray.removeAll {$0 == "removed"}
            docsArray.removeAll {$0 == "removed"}
            
            let param = ["TextMessage": text,"DiscussionID": discussionId,"Images": AppConstants().azureUrls(collection: imagesArray, containerType: .image),"Videos": AppConstants().azureUrls(collection: videosArray, containerType: .video),"Documents":AppConstants().azureUrls(collection: docsArray, containerType: .document)] as [String : Any]
           
             timer.invalidate() // add by chandra 0n june 3 rd
            hitServer(params: param, action: "postMessage")
            timer.invalidate() // add by chandra on new 8
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                // Put your code which should be executed with a delay here
                //self.startTimer()
                self.scheduledTimerWithTimeInterval()
            }
            // add by chandra 0n june 3 rd ends here
        }
        else{
            doneBtn.isEnabled = true
        }
        
    }
    // add by chandra jun 3 rd
   func startTimer(){
       hit5sec = 1
       // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
       timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(updateCounting), userInfo: nil, repeats: true)
   }
    private func hitServer(params: [String:Any],action: String) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        let userId = UserDefaults.standard.object(forKey: "userID") as! String
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: Endpoints.postMessage + userId, using: .post, dueToAction: action){ result in
            self.stopAnimating()
            switch result {
            case let .success(json,_):
                
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }else {
                    //self.clear()
                    self.localChat = true // Auto reload in Chat Screen
                    self.addNewMessage()
                    /* Below line commented by Ranjeet on 23rd Oct 2019 , please don't remove future might reuse */
                  //  showMessage(bodyText: msg ,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 0.01))
                }
                
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    func addNewMessage(){
        textView.resignFirstResponder()
        let v2 = AppConstants().localToUTCForChat(date: self.createdOn(), formatter: self.formatter)
        var section = self.tbl_chat.numberOfSections
        let obj = ["messageText": text!, "UserID": (UserDefaults.standard.object(forKey: "userID") as! String), "messageDate": v2 ,"MessageID": "" ,"profileURL": UserDefaults.standard.string(forKey: "profileURL") ?? "", "images": imagesArray, "videos": videosArray, "docs": docsArray] as [String: Any]
        
      
        let chat = ChatMessage.init(withDictionary: obj)
/*           After creating Discussion and then go to chat and text message , app was crashing , now it is working - starts here   */
         
         self.serverMessages.insert(chat, at: 0)
                var last  = [ChatMessage]()
                if chatMessages.count >= 1
                {
                    last = chatMessages.last ?? []
                    
                    last.append(chat)
                    chatMessages.removeLast()
                    chatMessages.append(last)
                    if section > 0{
                         
                         if self.chatMessages.count > section
                         {
                         }else{
                             
                             section -= 1
                         }
                     }
                     let row = self.tbl_chat.numberOfRows(inSection: section)
                     let indexPat = IndexPath.init(row: row, section: section)
                     self.tbl_chat.beginUpdates()
                     self.tbl_chat.insertRows(at: [indexPat], with: .fade)
                     self.tbl_chat.endUpdates()

                }else{
                    
                    last.append(chat)
                    chatMessages.append(last)
                    self.tbl_chat.reloadData()

                }
               
         /*  After creating Discussion and then go to chat and text message , app was crashing , now it is working  - ends here    */
    
        self.scrollToLastIndex() // commented by chandra
        AzureUpload().uploadBlobToContainer(filePathArray: imagesArray, containerType: "Images")
        AzureUpload().uploadBlobToContainer(filePathArray: generateThumbnailImageAndData(arr: videoThumbnailsArray), containerType: "Thumbnails")
        AzureUpload().uploadBlobToContainer(filePathArray: videosArray, containerType: "Videos")
        AzureUpload().uploadBlobToContainer(filePathArray: docsArray, containerType: "Documents")
        self.clear()
    }
    fileprivate func assembleGroupedMessages(messagesFromServer: [ChatMessage]){
                    chatMessages = []
        /* Added By Chandra on 28th Jan 2020 - ends here*/
        
        let groupedMessages = Dictionary(grouping: messagesFromServer.reversed()) { (element) -> Date in
            return element.date?.reduceToMonthDayYear() ?? Date()
        }
        // provide a sorting for your keys somehow
        //serverMessages.sort(by: { $0.date!.compare($1.date!) == .orderedDescending})
        let sortedKeys = groupedMessages.keys.sorted()
        sortedKeys.forEach { (key) in
            let values = groupedMessages[key]
            //Mark: Auto Reload Chat Screen
             /* Added  By Chandra on 28th Jan 2020 - starts here */
            serverMessages.removeAll()  /* Added  By Chandra on 28th Jan 2020 */
                chatMessages.append(values ?? [])
             /* Added  By Chandra on 28th Jan 2020 - ends here  */
           
           
        }
        
    }

    
    /*  dynamic page loading - starts here */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if (actualPosition.y > 0){
            // Dragging down
           self.view.layoutIfNeeded()
            print("**unhide")
            scroolCheck = 1
            scroolUp = 1
            //addlbl.isHidden = false
        }else{
            // Dragging up
            self.view.layoutIfNeeded() // force any pending operations to finish
            print("hide")
            scroolCheck = 0
            scroolUp = 2
            addlbl.isHidden = true
            scrollToLastIndex()
        }
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
         print(chatMessages.count)
        return chatMessages.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatMessages[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let chat = chatMessages[indexPath.section][indexPath.row]
        var reuseIdentifier = "discCellSent" //discCellSent discCellReceive
        if chat.isInComing!{
            reuseIdentifier = "discCellReceive"
           
        }
        cell = tbl_chat.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ChatNewCell
        // pass indexPath
        cell.indexPatH = indexPath
        cell.chatMessage = chat
        
        if chat.imagesUrls.count > 0{
            cell.view_images.isHidden = false
            cell.view_imageHeight.constant = 60;
        }
        else{
            cell.view_images.isHidden = true
            cell.view_imageHeight.constant = 0;
        }
        if chat.videoUrls.count > 0{
            cell.view_videoHeight.constant = 60;
            cell.view_videos.isHidden = false
        }
        else{
            cell.view_videoHeight.constant = 0;
            cell.view_videos.isHidden = true
        }
        if chat.docsUrl.count > 0{
            cell.view_docHeight.constant = 60;
            cell.view_docs.isHidden = false
        }
        else{
            cell.view_docHeight.constant = 0;
            cell.view_docs.isHidden = true
        }
        cell.imageTap = { [weak self] indexPatH, tag, type in
            self?.mediaDetail(indexPath: indexPatH, tag: tag, type: type)
        }
        return cell
    }
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
    
    
    
    func mediaDetail(indexPath: IndexPath, tag: Int, type: containerUrls){
        
        switch type{
        case .image:
            let vc = storyboard!.instantiateViewController(withIdentifier: "imageSwipe") as! ImageSwipeVC
            vc.uploadView = false
            vc.imagesArray = chatMessages[indexPath.section][indexPath.row].imagesUrls
            vc.indexPath = IndexPath.init(row: tag-1, section: 0)
            self.navigationController?.pushViewController(vc, animated: false)
        case .video:
            let chat = chatMessages[indexPath.section][indexPath.row].videoUrls
            playVideo(file: chat![tag-1])
        case .document:
            startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
            let docs = chatMessages[indexPath.section][indexPath.row].docsUrl
            let str:String = docs![tag-1]
//            if str.contains(".pdf"){
//                let remotePDFDocumentURL = URL(string: str)!
//                let document = PDFDocument(url: remotePDFDocumentURL)!
//                let readerController = PDFViewController.createNew(with: document)
//                navigationController?.pushViewController(readerController, animated: true)
//            }else{
                
                let webVc = storyboard?.instantiateViewController(withIdentifier: "WebVC") as! WebVC
                webVc.myTitle = "openDoc"
//                let docs = chatMessages[indexPath.section][indexPath.row].docsUrl
//                webVc.documentUrl = docs![tag-1]
                webVc.documentUrl = str
         
                //write your code here
                self.startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
                self.navigationController?.pushViewController(webVc, animated: true)
      
            
//            }
            
        case .thumbnails:
            print("Thumb")
        }
    }
    func cornerRadius(_ image: UIImageView?) {
        let imglayer = image?.layer
        imglayer?.cornerRadius = 10
        imglayer?.masksToBounds = true
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let firstMessageInSection = chatMessages[section].first{
            let today = Date()
            let todayDate = dateFormatter.string(from: today)
            let dateString = dateFormatter.string(from: firstMessageInSection.date ?? Date())
            
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            
            let label = UILabel()
            label.frame = CGRect.init(x: headerView.frame.size.width/2 - 60, y: 5, width: 120, height: headerView.frame.height-10)
            label.textAlignment = .center
            if todayDate == dateString
            {
                label.text = "Today"
            }
            else{
                label.text = dateString
            }
            
            label.textColor = .white
              /*  Added By Ranjeet on 31st March 2020 - starts here */
            if #available(iOS 13.0, *) {
                label.backgroundColor = .label
            } else {
                // Fallback on earlier versions
            }
              /*  Added By Ranjeet on 31st March 2020 - ends here */
            label.layer.cornerRadius = 20
            label.layer.masksToBounds = true
            headerView.addSubview(label)
            
            return headerView
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        let chat = chatMessages[indexPath.section]
        
        
        var reuseIdentifier = "discCellSent" //discCellReceive
        if chat[indexPath.row].isInComing!{
            reuseIdentifier = "discCellReceive"
        }
        if !(cell != nil) {
            cell = tbl_chat.dequeueReusableCell(withIdentifier: reuseIdentifier) as? ChatNewCell
        }
        
        let dict = chat[indexPath.row]
        
        if dict.imagesUrls.count > 0 && dict.videoUrls.count > 0 && dict.docsUrl.count > 0 {
            height = 240 + 60
        } else if dict.imagesUrls.count > 0 && dict.videoUrls.count > 0 {
            height = 240
        } else if dict.videoUrls.count > 0 && dict.docsUrl.count > 0 {
            height = 240
        } else if dict.imagesUrls.count > 0 && dict.docsUrl.count > 0 {
            height = 240
        } else if dict.imagesUrls.count > 0 || dict.videoUrls.count > 0 || dict.docsUrl.count > 0 {
            height = 180
        } else {
            height = 120
        }
        if let object = dict.message {
            let v = self.height(forComment: "\(object)")
            self.cell.view_answerheight.constant = v + 20
        }
            height = height + self.cell.view_answerheight.constant - 60
        
        
        return height
        
    }
    func height(forComment comment: String?) -> CGFloat {
        var commentlabelWidth: CGFloat
        if UI_USER_INTERFACE_IDIOM() == .phone {
            let result = UIScreen.main.bounds.size
            if result.height == 568 {
                commentlabelWidth = 320.0 - 78.0
            } else if result.height == 667 {
                commentlabelWidth = 375.0 - 78.0
            } else if result.height == 736 {
                commentlabelWidth = 414.0 - 78.0
            } else {
                commentlabelWidth = 375.0 - 78.0
            }
        } else {
            commentlabelWidth = 745.0 - 78.0
        }
        let textRect = (comment?.heightWithConstrainedWidth(width: commentlabelWidth, font: UIFont.systemFont(ofSize: 14)))!
        return textRect+20
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func createdOn() -> String
    {
        let date = Date()
        formatter.dateFormat = AppConstants().returnDateFormatForSendingServer()
        return formatter.string(from: date)
    }
    
    class DateHeaderLabel: UILabel{
        override init(frame: CGRect) {
            super.init(frame: frame)
              /*  Added By Ranjeet on 31st March 2020 - starts here */
            if #available(iOS 13.0, *) {
                backgroundColor = .label
            } else {
                // Fallback on earlier versions
            }
              /*  Added By Ranjeet on 31st March 2020 - ends here */
            textColor = .white
            textAlignment = .center
            translatesAutoresizingMaskIntoConstraints = false
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) hasn't been implemented.")
        }
        override var intrinsicContentSize: CGSize{
            let contentOrginalSize = super.intrinsicContentSize
            let height = contentOrginalSize.height + 12
            layer.cornerRadius = height/2
            layer.masksToBounds = true
            return CGSize.init(width: contentOrginalSize.width + 20, height: height)
        }
    }
    func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    func parseDiscussionList(json: JSON, requestType: String){
        if let v = json["ControlsData"].dictionaryValue["messageList"]?.arrayObject as? Array<Dictionary<String, Any>>{
          var dataarr = [String]()
            for obj in v{
                var data = obj["UserID"] as! String
                if data == UserDefaults.standard.string(forKey: "userID") {

                }else{
                   dataarr.append(data)
                }
//                countOne = dataarr.count
                let chat = ChatMessage.init(withDictionary: obj)
                self.serverMessages.append(chat)
            }
            countOne = dataarr.count

//            print(dataarr.count)
//            print(self.serverMessages.count)
//            addlbl.text = String(dataarr.count) // add by chandra on 4th jun
        }
        self.assembleGroupedMessages(messagesFromServer: self.serverMessages)
        DispatchQueue.main.async {
            self.tbl_chat.reloadData()
        }
        if requestType != "MessagesList"{
            if scroolCheck == 1{
               print("venna pusa chandra")
            }else{
                scrollToLastIndex() // add by chandra new 3 june
            }
        
        }
        
    }
    func getFileName(str: String) -> String{
        var fileName = ""
        if str == "pdf" {
            fileName = "ic_pdf"
        }
        else if str == "doc" {
            fileName = "ic_dox"
        }
        else if str == "docx" {
            fileName = "ic_dox";
        }
        else if str == "txt" {
            fileName = "ic_txt";
        }
        else if str == "ppt" {
            fileName = "ic_ppt";
        }
        else if str == "xlsx" {
            fileName = "ic_xl";
        }
        else if str == "xLs" {
            fileName = "ic_anonymous"
        }
        else{
            fileName = "ic_anonymous"
        }
        return fileName
    }
    func saveFile(url: URL, fileName: String) -> String {
        let datePdf = try? Data.init(contentsOf: url)
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        var documentsDirectory = paths[0]
        //Create PDF_Documents directory
        documentsDirectory = "\(documentsDirectory)/PDF_Documents"
        do
        {
            try FileManager.default.createDirectory(atPath: documentsDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
        let filePath = "\(documentsDirectory)/\(fileName)"
        do{
            try datePdf?.write(to: URL.init(fileURLWithPath: filePath), options: .atomic)
        }
        catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
        return filePath
    }
}
extension ChatVC: NVActivityIndicatorViewable,HPGrowingTextViewDelegate
{
    func generateThumbnailImageAndData(arr: [String]) -> [String]{
        var out = [String]()
        for i in 0..<arr.count{
            let thumbImage = UIImage().generateThumbnail(path: URL.init(fileURLWithPath: self.videosArray[i]))
            let imD = thumbImage?.jpeg(.low)
            let filePath = AppConstants().getImagesFolder()
            let fileName = (arr[i] as NSString)
            let fileUrl = URL.init(fileURLWithPath: "\(filePath)/\(fileName.lastPathComponent)")
            do{
                try imD?.write(to: fileUrl, options: .atomic)
            }
            catch
            {
                let fetchError = error as NSError
                print(fetchError)
            }
            out.append("\(filePath)/\(fileName.lastPathComponent)")
        }
        return out
    }
    func clear(){
        textView.text = ""
        imagesArray.removeAll()
        videoThumbnailsArray.removeAll()
        videosArray.removeAll()
        docsArray.removeAll()
        img_text1.image = nil
        img_text2.image = nil
        img_text3.image = nil
        img_text4.image = nil
        img_text5.image = nil
        
        v_img_text1.image = nil
        v_img_text2.image = nil
        v_img_text3.image = nil
        v_img_text4.image = nil
        v_img_text5.image = nil
        
        d_img_text1.image = nil
        d_img_text2.image = nil
        d_img_text3.image = nil
        d_img_text4.image = nil
        d_img_text5.image = nil
        
        hideRemoveButtons(isHidden: true)
        self.defaultT()
    }
    func displayAlter(message:String)
    {
        self.stopAnimating()
        AppConstants().ShowAlert(vc: self, title:"Message", message:message)
    }
    private func hitServer(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        // Mark: Auto Reload in Chat Screen
          /* Added By Chandra on 28th Jan 2020 - starts here  */
        if hit5sec == 1{
            
        }
        else{
             startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        }
          /* Added By Chandra on 28th Jan 2020 - ends here  */
        
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){ [weak self] result in
            guard let _ = self else {
                return
            }
            self!.stopAnimating()
            if action == "MessagesTopList"{
                self?.refreshControl.endRefreshing()
            }
            switch result {
            case let .success(json,requestType):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }
                else {
//                    if let v = json["ControlsData"].dictionaryValue["lsv_Questions"]?.arrayObject as? Array<Dictionary<String, Any>>
                    self!.parseDiscussionList(json: json, requestType: requestType)
                    
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    
}
extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
extension ChatVC: UIDocumentPickerDelegate{
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .normal)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        doneBtn.isEnabled = true;
       UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .normal)
        let fileName = "\(AppConstants().getUniqueDocumentFileName()).\(url.pathExtension)"
        let name = getFileName(str: url.pathExtension)
        let finalPath = saveFile(url: url, fileName: fileName)
        
        var isReplace = false
        for K in 0..<docsArray.count{
            let str = docsArray[K]
            if str == "removed"{
                docsArray[K] = finalPath
                isReplace = true
                break
            }
        }
        if !isReplace{
            docsArray.append(finalPath)
        }
        checkContraints()
        
        let anIndex = self.docsArray.firstIndex(of: finalPath)
        if anIndex == 0{
            d_img_text1.image = UIImage.init(named: name)
            d_img_text1.setRounded()
            btn_removed1.isHidden = false
            d_img_text1.tag = 110
            
            let gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.handleDocTap(gesture:)))
            gesture1.numberOfTapsRequired = 1
            self.d_img_text1.addGestureRecognizer(gesture1)
        }
        else if anIndex == 1{
            d_img_text2.image = UIImage.init(named: name)
            d_img_text2.setRounded()
            btn_removed2.isHidden = false
            d_img_text2.tag = 111
            
            let gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.handleDocTap(gesture:)))
            gesture1.numberOfTapsRequired = 1
            self.d_img_text2.addGestureRecognizer(gesture1)
        }
        else if anIndex == 2{
            d_img_text3.image = UIImage.init(named: name)
            d_img_text3.setRounded()
            btn_removed3.isHidden = false
            d_img_text3.tag = 112
            
            let gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.handleDocTap(gesture:)))
            gesture1.numberOfTapsRequired = 1
            self.d_img_text3.addGestureRecognizer(gesture1)
        }
        else if anIndex == 3{
            d_img_text4.image = UIImage.init(named: name)
            d_img_text4.setRounded()
            btn_removed4.isHidden = false
            d_img_text4.tag = 113
            
            let gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.handleDocTap(gesture:)))
            gesture1.numberOfTapsRequired = 1
            self.d_img_text4.addGestureRecognizer(gesture1)
        }
        else if anIndex == 4{
            d_img_text5.image = UIImage.init(named: name)
            d_img_text5.setRounded()
            btn_removed5.isHidden = false
            d_img_text5.tag = 114
            
            let gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.handleDocTap(gesture:)))
            gesture1.numberOfTapsRequired = 1
            self.d_img_text5.addGestureRecognizer(gesture1)
        }
    }
}
extension Date {
    func reduceToMonthDayYear() -> Date {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let year = calendar.component(.year, from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.date(from: "\(month)/\(day)/\(year)") ?? Date()
    }
    static func dateFromCustomString(customString: String) -> Date {
        let dateFo = DateFormatter()
        if customString.contains(".") {
            let arr = customString.split(separator: ".")
            let parser1 = DateFormatter()
            parser1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            parser1.timeZone = TimeZone(abbreviation: "UTC")
            let job = parser1.date(from: String(arr[0]))
            dateFo.timeZone = TimeZone.current
            dateFo.dateFormat = "MM/dd/yyyy"
            let str = dateFo.string(from: job ?? Date())
            return dateFo.date(from: str) ?? Date()
            
        }
        else
        {
            let parser1 = DateFormatter()
            parser1.dateFormat = AppConstants().returnDateFormatForSendingServer() //"yyyy-MM-dd HH:mm:ss"
            parser1.timeZone = TimeZone(abbreviation: "UTC")
            let job = parser1.date(from: customString)
            dateFo.timeZone = TimeZone.current
            dateFo.dateFormat = "MM/dd/yyyy"
            let str = dateFo.string(from: job ?? Date())
            return dateFo.date(from: str) ?? Date()
        }
    }
}

