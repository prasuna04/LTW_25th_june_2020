//  ChatNewCell.swift
//  NOM
//  Created by Vaayoo on 12/08/19.
//  Copyright © 2019 Vaayoo. All rights reserved.

import UIKit
import NVActivityIndicatorView
import Alamofire
import MobileCoreServices
import AssetsLibrary
import Photos
import AVFoundation
import MediaPlayer
import AVKit
class ChatNewCell: UITableViewCell {

    // add by chandra for display name  chat 30 /mar/2020
       @IBOutlet weak var nameDisplay : UILabel!
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var view_mainBg: UIView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_answer: UILabel!
    @IBOutlet weak var view_images: UIView!
    @IBOutlet weak var view_imageHeight: NSLayoutConstraint!
    @IBOutlet weak var view_videos: UIView!
    @IBOutlet weak var view_videoHeight: NSLayoutConstraint!
    @IBOutlet weak var view_docs: UIView!
    @IBOutlet weak var view_docHeight: NSLayoutConstraint!
    @IBOutlet weak var lbl_timeStamp: UILabel!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var v_img1: UIImageView!
    @IBOutlet weak var v_img2: UIImageView!
    @IBOutlet weak var v_img3: UIImageView!
    @IBOutlet weak var v_img4: UIImageView!
    @IBOutlet weak var v_img5: UIImageView!
    @IBOutlet weak var d_img1: UIImageView!
    @IBOutlet weak var d_img2: UIImageView!
    @IBOutlet weak var d_img3: UIImageView!
    @IBOutlet weak var d_img4: UIImageView!
    @IBOutlet weak var d_img5: UIImageView!
   // @IBOutlet weak var lbl_answerHeight: NSLayoutConstraint!
    @IBOutlet weak var view_answerheight: NSLayoutConstraint!

   // @IBOutlet weak var imgSourceHeight: NSLayoutConstraint!
    @IBOutlet weak var imgSource: UIImageView!
    var indexPatH: IndexPath?
    var imageTap: ((_ indexPath: IndexPath, _ imageTag: Int, _ type: containerUrls) -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var chatMessage: ChatMessage!{
        didSet{
            //lbl_name.text = [dict objectForKey:@"Name"];
            lbl_timeStamp.text = chatMessage.dateString
            imgSource.image = chatMessage.isInComing! ? #imageLiteral(resourceName: "chatBubbleReceiver") .stretchableImage(withLeftCapWidth: 15, topCapHeight: 14) : #imageLiteral(resourceName: "chatBubbleSender") .stretchableImage(withLeftCapWidth: 21, topCapHeight: 14)
            
//            img_profile.sd_setImage(with: URL.init(string: chatMessage.profileURL ?? ""), placeholderImage:#imageLiteral(resourceName: "male-filled"), options: [.continueInBackground,.progressiveLoad ])
            
            img_profile.sd_setImage(with: URL.init(string: chatMessage.profileURL ?? ""),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
            
            img_profile.setRounded()
            // add by chandra for display name  chat 30 /mar/2020 start here to
                      if  chatMessage.nameUserId  == UserDefaults.standard.object(forKey: "userID") as! String{
                         print("You are the logIn user")
                      }else{
                          nameDisplay.text = chatMessage.name
                      }
            // add by chandra for display name  chat 30 /mar/2020 end here
            
            img1.isHidden = true
            img2.isHidden = true
            img3.isHidden = true
            img4.isHidden = true
            img5.isHidden = true
            
            v_img1.isHidden = true
            v_img2.isHidden = true
            v_img3.isHidden = true
            v_img4.isHidden = true
            v_img5.isHidden = true
            
            d_img1.isHidden = true
            d_img2.isHidden = true
            d_img3.isHidden = true
            d_img4.isHidden = true
            d_img5.isHidden = true
            
            lbl_answer.text = chatMessage.message
            for i in 0..<chatMessage.imagesUrls.count {
                let str = chatMessage.imagesUrls[i]
                let localPath = "\(AppConstants().getImagesFolder())/\(((str as NSString).lastPathComponent))"
                let isFileExist = FileManager.default.fileExists(atPath: localPath)
                let gesture1 = MyGestureIndex(target: self, action: #selector(handleCellTap(_:)))
                gesture1.numberOfTapsRequired = 1
                gesture1.indexPath = indexPatH ?? IndexPath.init(row: 0, section: 0) // Check section value then row
                gesture1.type = .image
                let thumb = str.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
                if i == 0{
                    if isFileExist{
                        img1.image = UIImage.init(contentsOfFile: localPath)
                    }
                    else{
                        img1.sd_setImage(with: URL.init(string: thumb ),placeholderImage: UIImage(named: "gImage_unSelected"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
                    }
                    img1.isHidden = false
                    cornerRadius(img1)
                    img1.tag = 1
                    img1.isUserInteractionEnabled = true
                    img1.addGestureRecognizer(gesture1)
                }
                else if i == 1{
                    if isFileExist{
                        img2.image = UIImage.init(contentsOfFile: localPath)
                    }
                    else{
                        img2.sd_setImage(with: URL.init(string: thumb ),placeholderImage: UIImage(named: "gImage_unSelected"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
                    }
                    img2.isHidden = false
                    cornerRadius(img2)
                    img2.tag = 2
                    img2.isUserInteractionEnabled = true
                    
                    img2.addGestureRecognizer(gesture1)
                }
                else if i == 2{
                    if isFileExist{
                        img3.image = UIImage.init(contentsOfFile: localPath)
                    }
                    else{
                        img3.sd_setImage(with: URL.init(string: thumb ),placeholderImage: UIImage(named: "gImage_unSelected"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
                    }
                    img3.isHidden = false
                    cornerRadius(img3)
                    img3.tag = 3
                    img3.isUserInteractionEnabled = true
                    
                    img3.addGestureRecognizer(gesture1)
                }
                else if i == 3{
                    if isFileExist{
                        img4.image = UIImage.init(contentsOfFile: localPath)
                    }
                    else{
                        img4.sd_setImage(with: URL.init(string: thumb ),placeholderImage: UIImage(named: "gImage_unSelected"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
                    }
                    img4.isHidden = false
                    cornerRadius(img4)
                    img4.tag = 4
                    img4.isUserInteractionEnabled = true
                    
                    img4.addGestureRecognizer(gesture1)
                }
                else{
                    if isFileExist{
                        img5.image = UIImage.init(contentsOfFile: localPath)
                    }
                    else{
                        img5.sd_setImage(with: URL.init(string: thumb ),placeholderImage: UIImage(named: "gImage_unSelected"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
                    }
                    img5.isHidden = false
                    cornerRadius(img5)
                    img5.tag = 5
                    img5.isUserInteractionEnabled = true
                    
                    img5.addGestureRecognizer(gesture1)
                }
            }
            for i in 0..<chatMessage.videoUrls.count {
                let str = chatMessage.videoUrls[i]
                let localPath = "\(AppConstants().getVideosFolder())/\(((str as NSString).lastPathComponent))"
                let isFileExist = FileManager.default.fileExists(atPath: localPath)
                let gesture1 = MyGestureIndex(target: self, action: #selector(handleCellTap(_:)))
                gesture1.numberOfTapsRequired = 1
                gesture1.indexPath = indexPatH ?? IndexPath.init(row: 0, section: 0)
                gesture1.type = .video
                let thumb = str.replacingOccurrences(of: "videos", with: "thumbnails") //nom4thum
                let final = thumb.replacingOccurrences(of: ".mp4", with: ".jpg")
                if i == 0{
                    if isFileExist{
                        v_img1.image = UIImage().generateThumbnail(path: URL.init(fileURLWithPath: localPath))//UIImage.init(contentsOfFile: localPath)
                    }
                    else{
                        //v_img1.sd_setImage(with: URL.init(string: chatMessage.thumbnailImageOfVideo ?? ""), placeholderImage:#imageLiteral(resourceName: "male-filled"), options: [.continueInBackground,.progressiveLoad ])
                        v_img1.sd_setImage(with: URL.init(string: final ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
                    }
                    v_img1.isHidden = false
                    v_img1.tag = 1
                    cornerRadius(v_img1)
                    let vidImage = UIImageView(frame: CGRect(x: v_img1.frame.size.width / 2 - 10, y: v_img1.frame.size.height / 2 - 10, width: 20, height: 20))
                    vidImage.image = UIImage(named: "playbutton")
                    v_img1.addSubview(vidImage)
                    v_img1.isUserInteractionEnabled = true
                    v_img1.addGestureRecognizer(gesture1)
                }
                else if i == 1{
                    if isFileExist{
                        v_img2.image = UIImage().generateThumbnail(path: URL.init(fileURLWithPath: localPath))//UIImage.init(contentsOfFile: localPath)
                    }
                    else{
                        v_img2.sd_setImage(with: URL.init(string: final ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
                    }
                    v_img2.isHidden = false
                    v_img2.tag = 2
                    cornerRadius(v_img2)
                    let vidImage = UIImageView(frame: CGRect(x: v_img2.frame.size.width / 2 - 10, y: v_img2.frame.size.height / 2 - 10, width: 20, height: 20))
                    vidImage.image = UIImage(named: "playbutton")
                    v_img2.addSubview(vidImage)
                    v_img2.isUserInteractionEnabled = true
                    v_img2.addGestureRecognizer(gesture1)
                }
                else if i == 2{
                    if isFileExist{
                        v_img3.image = UIImage().generateThumbnail(path: URL.init(fileURLWithPath: localPath))//UIImage.init(contentsOfFile: localPath)
                    }
                    else{
                        v_img3.sd_setImage(with: URL.init(string: final),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
                    }
                    v_img3.isHidden = false
                    v_img3.tag = 3
                    cornerRadius(v_img3)
                    let vidImage = UIImageView(frame: CGRect(x: v_img3.frame.size.width / 2 - 10, y: v_img3.frame.size.height / 2 - 10, width: 20, height: 20))
                    vidImage.image = UIImage(named: "playbutton")
                    v_img3.addSubview(vidImage)
                    v_img3.isUserInteractionEnabled = true
                    v_img3.addGestureRecognizer(gesture1)
                }
                else if i == 3{
                    if isFileExist{
                        v_img4.image = UIImage().generateThumbnail(path: URL.init(fileURLWithPath: localPath))//UIImage.init(contentsOfFile: localPath)
                    }
                    else{
                        v_img4.sd_setImage(with: URL.init(string: final ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
                    }
                    v_img4.isHidden = false
                    v_img4.tag = 4
                    cornerRadius(v_img4)
                    let vidImage = UIImageView(frame: CGRect(x: v_img4.frame.size.width / 2 - 10, y: v_img4.frame.size.height / 2 - 10, width: 20, height: 20))
                    vidImage.image = UIImage(named: "playbutton")
                    v_img4.addSubview(vidImage)
                    v_img4.isUserInteractionEnabled = true
                    v_img4.addGestureRecognizer(gesture1)
                }
                else{
                    if isFileExist{
                        v_img5.image = UIImage().generateThumbnail(path: URL.init(fileURLWithPath: localPath))//UIImage.init(contentsOfFile: localPath)
                    }
                    else{
                        v_img5.sd_setImage(with: URL.init(string: final ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
                    }
                    v_img5.isHidden = false
                    v_img5.tag = 5
                    cornerRadius(v_img5)
                    let vidImage = UIImageView(frame: CGRect(x: v_img5.frame.size.width / 2 - 10, y: v_img5.frame.size.height / 2 - 10, width: 20, height: 20))
                    vidImage.image = UIImage(named: "playbutton")
                    v_img5.addSubview(vidImage)
                    v_img5.isUserInteractionEnabled = true
                    v_img5.addGestureRecognizer(gesture1)
                }
                
            }
            for i in 0..<chatMessage.docsUrl.count {
                let str = chatMessage.docsUrl[i]
                let fileName = self.getFileName(str: (str as NSString).pathExtension)
                let gesture1 = MyGestureIndex(target: self, action: #selector(handleCellTap(_:)))
                gesture1.numberOfTapsRequired = 1
                gesture1.indexPath = indexPatH ?? IndexPath.init(row: 0, section: 0)
                gesture1.type = .document
                if i == 0{
                    d_img1.image = UIImage.init(named: fileName)
                    d_img1.isHidden = false
                    d_img1.tag = 1
                    cornerRadius(d_img1)
                    d_img1.isUserInteractionEnabled = true
                    d_img1.addGestureRecognizer(gesture1)
                }
                else if i == 1{
                    d_img2.image = UIImage.init(named: fileName)
                    d_img2.isHidden = false
                    d_img2.tag = 2
                    cornerRadius(d_img2)
                    d_img2.isUserInteractionEnabled = true
                    d_img2.addGestureRecognizer(gesture1)
                }
                else if i == 2{
                    d_img3.image = UIImage.init(named: fileName)
                    d_img3.isHidden = false
                    d_img3.tag = 3
                    cornerRadius(d_img3)
                    d_img3.isUserInteractionEnabled = true
                    d_img3.addGestureRecognizer(gesture1)
                }
                else if i == 3{
                    d_img4.image = UIImage.init(named: fileName)
                    d_img4.isHidden = false
                    d_img4.tag = 4
                    cornerRadius(d_img4)
                    d_img4.isUserInteractionEnabled = true
                    d_img4.addGestureRecognizer(gesture1)
                }
                else{
                    d_img5.image = UIImage.init(named: fileName)
                    d_img5.isHidden = false
                    d_img5.tag = 5
                    cornerRadius(d_img5)
                    d_img5.isUserInteractionEnabled = true
                    d_img5.addGestureRecognizer(gesture1)
                }
            }
            
        }
    }
    func cornerRadius(_ image: UIImageView?) {
        let imglayer = image?.layer
        imglayer?.cornerRadius = 10
        imglayer?.masksToBounds = true
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
//    func generateThumbnail(path: URL) -> UIImage? {
//        do {
//            let asset = AVURLAsset(url: path, options: nil)
//            let imgGenerator = AVAssetImageGenerator(asset: asset)
//            imgGenerator.appliesPreferredTrackTransform = true
//            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
//            let thumbnail = UIImage(cgImage: cgImage)
//            return thumbnail
//        } catch let error {
//            print("*** Error generating thumbnail: \(error.localizedDescription)")
//            return nil
//        }
//    }
    @objc func handleCellTap(_ gesture: MyGestureIndex) {
        let view = gesture.view
        imageTap?(gesture.indexPath, view!.tag, gesture.type)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class MyGestureIndex: UITapGestureRecognizer{
    var indexPath = IndexPath()
    var type: containerUrls!
}
extension UIImage{
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
}
