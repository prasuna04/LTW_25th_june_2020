//  ImagePicker.swift
//  LTW
//  MultiimageSelectionGallery
//  Created by Ranjeet Raushan on 10/04/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import BSImagePicker
import BSGridCollectionViewLayout
import Photos

protocol imagePickerDelegate {
    func reloadTable()
}
class ImagePicker: NSObject {
    var SelectedAssets = [PHAsset]()
    var imagesArray = Array<String>()
    var delegate: imagePickerDelegate?
    var iCount: Int = 1
    var imageCount: Int?
    func images(viewController: UIViewController)
    {
        let vc = BSImagePickerViewController()
        vc.navigationBar.isTranslucent = false
        vc.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")// Background color
        vc.navigationBar.tintColor = .white // Cancel button ~ any UITabBarButton items
        vc.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        
        vc.maxNumberOfSelections = imageCount!
        viewController.bs_presentImagePickerController(vc, animated: true,
                                                       select: { (asset: PHAsset) -> Void in
        }, deselect: { (asset: PHAsset) -> Void in
        }, cancel: { (assets: [PHAsset]) -> Void in
        }, finish: { (assets: [PHAsset]) -> Void in
            for i in 0..<assets.count{
                let img: PHAsset = assets[i]
                img.getURL(completionHandler: { (img) in
                    let fileUrl = img!
                    let filePath = self.getImagesFolder()
                    do{
                        let dataa = try Data.init(contentsOf: fileUrl)
                        let uniqueFileName = self.getUniqueFileName()
                        let finalPath = URL.init(fileURLWithPath: "\(filePath)/\(uniqueFileName)")
                        do{
                            try (UIImage.init(data: dataa)!).jpegData(compressionQuality: 0.5)?.write(to: finalPath, options: .atomic)
                            self.imagesArray.append(String(describing: finalPath))
                            let imagesCount = assets.count
                            if self.iCount == imagesCount{
                                if let del = self.delegate {
                                    del.reloadTable()
                                }
                            }
                            self.iCount += 1
                        }
                        catch{
                            let fetchError = error as NSError
                            print(fetchError)
                        }
                    }
                    catch{
                        let fetchError = error as NSError
                        print(fetchError)
                    }
                })
            }
        }, completion: nil)
        
        
    }
    func getImagesFolder() -> NSString {
        let documentFolderPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] //NSHomeDirectory() + "/Documents" as NSString
        //let fileManager = FileManager.default
        let imagesFolderPath = documentFolderPath + "/Images" //documentFolderPath.appendingPathComponent("Images") as NSString
        
        //Check if the images folder is already exist?  if not create it!
        var isDir: ObjCBool = true
        let isExist = FileManager.default.fileExists(atPath: imagesFolderPath, isDirectory:&isDir)
        if isExist == false
        {
            do{
                try FileManager.default.createDirectory(atPath: imagesFolderPath, withIntermediateDirectories: true, attributes: nil)
                
            }
            catch {
                let fetchError = error as NSError
                print(fetchError)
            }
        }
        return imagesFolderPath as NSString
    }
    func getUniqueFileName() -> String{
        let time = Foundation.Date()
        let df = DateFormatter()
        df.dateFormat = "MMddyyyyhhmmssSSS"
        let timeString = df.string(from: time)
        let fileName = "\(timeString).jpg"
        return fileName
    }
}
