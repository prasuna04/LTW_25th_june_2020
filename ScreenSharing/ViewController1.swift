//  ViewController.swift
//  ScribblePOC
//  Created by Vaayoo USA on 14/10/19.
//  Copyright © 2019 Vaayoo USA. All rights reserved.

import UIKit
//import MaLiang
//import Quickblox
//import QuickbloxWebRTC
import SwiftyDraw

struct Chartlet {
    var texture_id: UUID
    var size: CGSize
}

class ViewController1: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
//    @IBOutlet weak var canvas: Canvas!
    @IBOutlet weak var canvas1: SwiftyDrawView!
    @IBOutlet weak var subView : UIView!
    @IBOutlet weak var backgroundView: UIImageView!

    let colorPickerView = ColorPickerView()
    var sliderVal = "5"
//    var imgText : MLTexture? = nil
    var myCustomView: PenSize!
    var drawView: SelectView!
//    var chartlets: [MLTexture] = []
    var  selectVal = 0
//    var session: QBRTCSession?
    private var images: [String] = []
//    private weak var capture: QBRTCVideoCapture?
    private var enabled = false
//    private var screenCapture: ScreenCapture?
    //prasuna added this for users list
    private var usersTableView: UITableView!


//    var users = [QBUUser]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /* Right Bar Button Code Starts Here */
        let userslistBtn = UIBarButtonItem(title: "UsersList", style: .done, target: self, action: #selector(usersListDisplay))
        self.navigationItem.rightBarButtonItem = userslistBtn
        
        // Do any additional setup after loading the view.
        canvas1.brush.width = 5
//        canvas.tapGesture?.isEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(tap)
        subView.layer.cornerRadius = subView.frame.height/2
        subView.layer.borderWidth = 1
        subView.layer.borderColor = UIColor.lightGray.cgColor
        colorPickerView.onColorDidChange = { [weak self] color in
            DispatchQueue.main.async {
                
                self!.canvas1.brush.color = color as! Color
                self!.colorPickerView.isHidden = true
            }
            
        }
//        DispatchQueue.global().async {
//
//        self.chartlets = ["circle","circle-1", "circle-2","square","square-1", "square-2","triangle","triangle-1", "triangle-2","pentagon","pentagon-1", "pentagon-2"].compactMap({ (name) -> MLTexture? in
//            return try? self.canvas.makeTexture(with: UIImage(named: name)!.pngData()!)
//        })
//
//        }
        
        
//        if let session = session {
//
////            enabled = session.localMediaStream.videoTrack.isEnabled
////            capture = session.localMediaStream.videoTrack.videoCapture
////            screenCapture = ScreenCapture(view: view)
////            //Switch to sharing
////            session.localMediaStream.videoTrack.videoCapture = screenCapture
////
////            let stringArrayOfNumbers = session.opponentsIDs.map { $0.stringValue }
////
////            QBRequest.users(withIDs: stringArrayOfNumbers, page: QBGeneralResponsePage.init(currentPage: 1, perPage: 10), successBlock: { (response, page, users) in
////
////                self.users = users
////                self.usersTableView.reloadData()
////
////            }) { (response) in
////
////            }
//
////            for userId in session.opponentsIDs
////            {
////
////            let opp = CallViewController().createConferenceUser(userID: userId.uintValue)
////            users.append(opp)
////
////                }
//            let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
//            let displayWidth: CGFloat = self.view.frame.width
//            usersTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: 100))
//            usersTableView.register(UINib.init(nibName: "UserListCell", bundle: nil), forCellReuseIdentifier: "cell")
//            usersTableView.dataSource = self
//            usersTableView.delegate = self
//
//            self.view.addSubview(usersTableView)
//            usersTableView.isHidden = true
//            self.view.sendSubviewToBack(usersTableView)
//        }
        
    }

    @objc func usersListDisplay()
    {
    usersTableView.isHidden = false
    usersTableView.reloadData()
    self.view.bringSubviewToFront(usersTableView)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//
//        if let session = session,
//            enabled == false {
//            session.localMediaStream.videoTrack.isEnabled = true
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        if isMovingFromParent == true,
//            enabled == false,
//            let session = session {
//            session.localMediaStream.videoTrack.isEnabled = false
//            session.localMediaStream.videoTrack.videoCapture = capture
//        }
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        
        usersTableView.isHidden = true
        self.view.sendSubviewToBack(usersTableView)

        guard gesture.state == .ended else {
            return
        }
//
//        let chartlet = chartlets[selectVal]
//
//        let location = gesture.location(in: canvas)
//        canvas.renderChartlet(at: location, size: chartlet.size, textureID: chartlet.id)

    }
     @IBAction func selectDrawTypeAction(_ sender: Any) {
        
        let btn = sender as! UIButton
        selectVal = btn.tag
        
    }
    
    
    @IBAction func undoAction(_ sender: Any) {
        canvas1.undo()
//        canvas.defaultBrush.use()
    }
    
    @IBAction func redoAction(_ sender: Any) {
        canvas1.redo()
//        canvas.defaultBrush.use()
    }
    
    @IBAction func clearAction(_ sender: Any) {
        
        backgroundView.image = nil
        canvas1.clear()
//        canvas.defaultBrush.use()
    }
    
  @IBAction func eraserAction(_ sender: Any)  {
//
//    let eraser = try! canvas.registerBrush(name: "Eraser") as Eraser
//    eraser.pointSize = 15
//    eraser.use()
    self.canvas1.brush.color = .init(white: 1, alpha: 1)
    
    }
    
    @IBAction func addPencilAction(_ sender: Any)  {
        
        let overlayer = UIView.init(frame: self.view.frame)
        overlayer.tag = 1
        overlayer.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        myCustomView  = UIView.fromNib()
        myCustomView.center = self.view.center
        myCustomView.sizeLbl.text = sliderVal
        myCustomView.slider.value =  Float(sliderVal) ?? 0.0
        overlayer.addSubview(myCustomView)
        self.view.addSubview(overlayer)
        
    }
    
    @IBAction func addDrawViewTypeAction(_ sender: Any)  {
        
//        let overlayer = UIView.init(frame: self.view.frame)
//        overlayer.tag = 2
//        overlayer.backgroundColor = UIColor.black.withAlphaComponent(0.3)
//        drawView  = UIView.fromNib()
////        drawView.frame.size = CGSize.init(width:self.view.frame.size.width , height: drawView.frame.size.height)
//        drawView.center = self.view.center
//        overlayer.addSubview(drawView)
//        self.view.addSubview(overlayer)
        
    }
    
    @IBAction func removePencilAction(_ sender: Any)  {
        
        for view in self.view.subviews
        {
            if view.tag == 1 || view.tag == 2
            {
                view.removeFromSuperview()
                
            }
        }
        
    }

    @IBAction func changeSizeAction(_ sender: UISlider) {
        
        let size = Int(sender.value)
         canvas1!.brush.width = CGFloat(size)
        myCustomView.sizeLbl.text = "\(size)"
        sliderVal = "\(size)"
        
    }
    
    @IBAction func takeImageFromGallery(_ sender : Any){
        
        let imagePickerController = UIImagePickerController()
        let alertController = UIAlertController.init(title: "", message: "", preferredStyle: .actionSheet)
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
       
        let alertCamera = UIAlertAction.init(title: "Camera", style: .default) { (UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }
        let alertPhotoLibrary = UIAlertAction.init(title:"Choose from Gallery", style: .default) { (UIAlertAction) in
            imagePickerController.sourceType = .savedPhotosAlbum
            self.present(imagePickerController, animated: true, completion: nil)
        }
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertCamera)
        alertController.addAction(alertPhotoLibrary)
        alertController.addAction(cancel)
        alertController.popoverPresentationController?.sourceView = self.view // works for both iPhone & iPad
        alertController.popoverPresentationController?.sourceRect = CGRect.init(x: self.view.center.x, y: self.view.frame.size.height, width: 1.0, height: 1.0);
        present(alertController, animated: true) {
            print("option menu presented")
        }
        
    }
    
    @IBAction func colorPencilAction(_ sender: Any)  {
        
        colorPickerView.isHidden = false
        colorPickerView.frame = canvas1.frame
        self.view.addSubview(colorPickerView)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
       
      
//        canvas.data.appendClearAction()

        let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        backgroundView.image = chosenImage
//        guard let data = chosenImage.jpegData(compressionQuality: 1) else { return }
//
//        var mediaurl : URL?
//
//        if #available(iOS 11.0, *) {
//            mediaurl = info[UIImagePickerController.InfoKey.imageURL] as? URL
//        }
//
//        do {
//        if mediaurl != nil{
//
//            let imag =  try canvas.makeTexture(with: data, id: mediaurl?.lastPathComponent)
//           canvas.renderChartlet(at: canvas.center, size: imag.size, textureID: imag.id)
//
//        }else{
//
//
//            let imageFolder = self.getImagesFolder()
//            let imageFileName = self.getUniqueFileName()
//            let finalPath = URL.init(fileURLWithPath: "\(String(describing: imageFolder))/\(String(describing: imageFileName))")
//            do
//            {
//                try data.write(to: finalPath, options: .atomic)
//                let imag =  try canvas.makeTexture(with: data, id: finalPath.lastPathComponent)
//                canvas.renderChartlet(at: canvas.center, size: imag.size, textureID: imag.id)
//            }
//            catch
//            {
//                let fetchError = error as NSError
//                print(fetchError)
//            }
//
//
//            }
//        }catch
//        {
//            let fetchError = error as NSError
//            print(fetchError)
//        }

        

//      canvas.redo()
      dismiss(animated: true, completion: nil)

        
    }
    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    func getImagesFolder() -> NSString
    {
        let documentFolderPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let imagesFolderPath = documentFolderPath + "/Images"
        var isDir: ObjCBool = true
        let isExist = FileManager.default.fileExists(atPath: imagesFolderPath, isDirectory:&isDir)
        if isExist == false
        {
            do
            {
                try FileManager.default.createDirectory(atPath: imagesFolderPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch
            {
                let fetchError = error as NSError
                print(fetchError)
            }
        }
        return imagesFolderPath as NSString
    }
    func getUniqueFileName() -> String
    {
        let time = Foundation.Date()
        let df = DateFormatter()
        df.dateFormat = "MMddyyyyhhmmssSSS"
        let timeString = df.string(from: time)
        let fileName = "\(timeString).jpg"
        return fileName
    }

}

//extension UIView {
//    class func fromNib<T: UIView>() -> T {
//        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
//    }
//}
extension ViewController1 : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
//        return users.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! UserListCell
        
        //let user = users[indexPath.row]
        
       // let userID = NSNumber(value: user.id)
        
//        if let audioTrack = session?.remoteAudioTrack(withUserID: userID) {
//            cell.muteButton.isSelected = !audioTrack.isEnabled
//        }
        
//        cell.didPressMuteButton = { [weak self] isMuted in
//            let audioTrack = self?.session?.remoteAudioTrack(withUserID: userID)
//            audioTrack?.isEnabled = !isMuted
//
//        }
        cell.name = ""
//        cell.connectionState = .unknown
//        guard let currentUser = QBSession.current.currentUser, user.id != currentUser.id else {
//            return cell
//        }
      //  cell.connectionState = .connected
//        let title = user.fullName
//        cell.name = title ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
