//  GalleryVC.swift
//  LTW
//  Created by Vaayoo on 26/09/19.
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

class GalleryVC: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var galleryCollection: UICollectionView!
    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var btnVideos: UIButton!
    @IBOutlet weak var btnDocs: UIButton!
    var discussionId: String?
    var collection = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if currentReachabilityStatus != .notReachable {
            let point = "\(Endpoints.getGallery)\(discussionId!)/1"
            hitServer(params: [:], endPoint: point,  action: "Images", httpMethod: .get)
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
            })
        }
        
         lbl.text = "Photos"
        btnImage.isSelected = true
    }
    @IBAction func switchTabs(_ sender: UIButton) {
    
        var mediaType = 1
        var mediaAction = "Images"
        switch sender.tag {
        case 0:
            mediaType = 1
            mediaAction = "Images"
            btnImage.isSelected = true
            btnVideos.isSelected = false
            btnDocs.isSelected = false
            lbl.text = "Photos"
            
        case 1:
            mediaType = 2
            mediaAction = "Videos"
            btnImage.isSelected = false
            btnVideos.isSelected = true
            btnDocs.isSelected = false
            lbl.text = "Videos"
            
        case 2:
            mediaType = 3
            mediaAction = "Docs"
            btnImage.isSelected = false
            btnVideos.isSelected = false
            btnDocs.isSelected = true
            lbl.text = "Documents"
            
        default:
            break
        }
        if currentReachabilityStatus != .notReachable {
            let point = "\(Endpoints.getGallery)\(discussionId!)/\(mediaType)"
            hitServer(params: [:], endPoint: point,  action: mediaAction, httpMethod: .get)
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
            })
        }
    }
    
    private func hitServer(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){ [weak self] result in
            guard let _ = self else {
                return
            }
    
            self?.stopAnimating()
            switch result {
            case let .success(json,_):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }
                else {
                
                    self?.parseGallery(json: json)
                    
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
    func parseGallery(json: JSON){
        if let v = json["ControlsData"].dictionaryValue["Urls"]?.arrayObject{
            collection = v as! [String]
        }
        DispatchQueue.main.async {
            self.galleryCollection.reloadData()
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
        //guard let url = videoURL else { return }
        
        let player = AVPlayer.init(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        
        present(vc, animated: true) {
            vc.player?.play()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
           self.navigationController?.navigationBar.topItem?.title = " "
           navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
           navigationItem.title = "Gallery"
       }
}
extension GalleryVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = galleryCollection.dequeueReusableCell(withReuseIdentifier: "gallery", for: indexPath) as! GalleryCell
        let strUrl = collection[indexPath.row]
        cell.imgPlay.isHidden = true
        if strUrl.contains(".jpg"){
            let localPath = "\(AppConstants().getImagesFolder())/\(((strUrl as NSString).lastPathComponent))"
            let isFileExist = FileManager.default.fileExists(atPath: localPath)
            let thumb = strUrl.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
            if isFileExist{
            cell.img.image = UIImage.init(contentsOfFile: localPath)
            }
            else{
//            cell.img.sd_setImage(with: URL.init(string: thumb),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached]) /* Commented By Chandra on 6th Jan 2020 */
                
              cell.img.sd_setImage(with: URL.init(string: thumb),placeholderImage: UIImage(named: "gImage_unSelected"), options: [.continueInBackground, .progressiveDownload,.refreshCached]) /* Added By Chandra on 6th Jan 2020 */
            }
        }
        else if strUrl.contains(".mp4"){
            let localPath = "\(AppConstants().getVideosFolder())/\(((strUrl as NSString).lastPathComponent))"
            let isFileExist = FileManager.default.fileExists(atPath: localPath)
            let thumb = strUrl.replacingOccurrences(of: "videos", with: "thumbnails")
            let final = thumb.replacingOccurrences(of: ".mp4", with: ".jpg")
            if isFileExist{
                cell.img.image = UIImage().generateThumbnail(path: URL.init(fileURLWithPath: localPath))
            }
            else{
                 cell.img.sd_setImage(with: URL.init(string: final ),placeholderImage: UIImage(named: "gVideo_unSelected"), options: [.continueInBackground, .progressiveDownload,.refreshCached])  /* Added By Chandra on 6th Jan 2020 */
            }
            cell.imgPlay.isHidden = false
        }
        else{
            let fileName = self.getFileName(str: (strUrl as NSString).pathExtension)
            cell.img.image = UIImage.init(named: fileName)
        }
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collection[indexPath.row].contains(".jpg"){
            let vc = storyboard!.instantiateViewController(withIdentifier: "imageSwipe") as! ImageSwipeVC
            vc.uploadView = false
            vc.imagesArray = collection
            vc.indexPath = IndexPath.init(row: indexPath.row, section: 0)
            self.navigationController?.pushViewController(vc, animated: false)
        }
        else if collection[indexPath.row].contains(".mp4"){
            playVideo(file: collection[indexPath.row])
        }
        else{
            let webVc = storyboard?.instantiateViewController(withIdentifier: "WebVC") as! WebVC
            webVc.myTitle = "openDoc"
            webVc.documentUrl = collection[indexPath.row]
            self.startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
            self.navigationController?.pushViewController(webVc, animated: true)
        }
    }
}
