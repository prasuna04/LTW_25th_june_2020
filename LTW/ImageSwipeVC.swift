//  ImageSwipeVC.swift
//  LTW
//  Created by Vaayoo on 06/08/19.
//  Copyright © 2019 Vaayoo. All rights reserved.
//

import UIKit
import CoreServices
import CoreGraphics
import AVFoundation
import MediaPlayer
import AVKit
import SDWebImage
class ImageSwipeVC: UIViewController, CAAnimationDelegate {

    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var scrollV: UIScrollView!
    @IBOutlet weak var img: UIImageView!
    var indexPath: IndexPath!
    var imagesArray: [String]!
    var uploadView: Bool!
    //local
    var imgCount: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblCount.text = "\(indexPath.row+1)/\(imagesArray.count)"
        
        let file = imagesArray[indexPath.row]
        if uploadView{
            //file = imagesArray[indexPath.row]["filePath"] as? String
        }
        imgCount = indexPath.row
        let fileExtension = URL(fileURLWithPath: file).pathExtension as CFString
        //let fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, nil) as! CFString
        
        let unmanagedFileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, nil)
        let fileUTI = unmanagedFileUTI!.takeRetainedValue()
        if !UTTypeConformsTo(fileUTI, kUTTypeMovie) {
            let imageFolderPath = AppConstants().getImagesFolder()
            let imagePath = "\(imageFolderPath)/\((file as NSString).lastPathComponent)"
            let isExist = FileManager.default.fileExists(atPath: imagePath)
            if isExist
            {
                img.image = UIImage.init(contentsOfFile: imagePath)
            }
            else{
                img.sd_setImage(with: URL.init(string: file),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
            }
            img.isUserInteractionEnabled = true
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(swipe:)))
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(swipe:)))
            
            // Setting the swipe direction.
            swipeLeft.direction = .left
            swipeRight.direction = .right
            
            // Adding the swipe gesture on image view
            img.addGestureRecognizer(swipeRight)
            img.addGestureRecognizer(swipeLeft)
        }
        else{
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    @objc func handleSwipe(swipe: UISwipeGestureRecognizer){
        var indexes = imgCount
        let intg = imagesArray.count
        if swipe.direction == .left{
            indexes += 1
            if 0 <= indexes && indexes < intg {
                img.image = nil
                let transition = CATransition()
                transition.duration = 0.75
                transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                transition.type = .push
                transition.subtype = .fromRight
                transition.delegate = self
                img.layer.add(transition, forKey: nil)
            }
        }
        else if swipe.direction == .right
        {
            indexes -= 1
            if 0 <= indexes && indexes < intg {
                img.image = nil
                let transition = CATransition()
                transition.duration = 0.75
                transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                transition.type = .push
                transition.subtype = .fromLeft
                transition.delegate = self
                img.layer.add(transition, forKey: nil)
            }
        }
        if 0 <= indexes && indexes < intg
        {
            let i = indexes
            imgCount = i;
            lblCount.text = "\(indexes+1)/\(imagesArray.count)"
            let imageFolderPath = AppConstants().getImagesFolder()
            let imagePath = "\(imageFolderPath)/\((imagesArray[i] as NSString).lastPathComponent)"
            let isExist = FileManager.default.fileExists(atPath: imagePath)
            if isExist
            {
                img.image = UIImage.init(contentsOfFile: imagePath)
            }
            else{
                img.sd_setImage(with: URL.init(string: imagesArray[i]),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
            }
        }
    }
}
