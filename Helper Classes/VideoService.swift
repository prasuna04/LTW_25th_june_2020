//  VideoService.swift
//  CoreMediaDemo
//  Created by Tim Beals on 2018-10-12.
//  Copyright © 2018 Roobi Creative. All rights reserved.

import UIKit
import MobileCoreServices
import AssetsLibrary
import Photos
@objc protocol VideoServiceDelegate {
    
    @objc optional func videoDidFinishSaving(obj: [String: Any])
    func imagePickerdidfinishLoaded(withData mediaData: [String: Any], and imagestamp: String)
    func dismissMediaDeviceView()
    func imagePickerdidCancelled()
    //func imagepickerloadedwithTrimmedVideo(_ videoData: [String: Any], and videofilename: String)
}

class VideoService: NSObject {
    
    var delegate: VideoServiceDelegate?
    
    static let instance = VideoService()
    var exporter: AVAssetExportSession? = nil
    var exportPath = ""
    var filename_video = ""
    private override init() {}
    
}

extension VideoService {
    
    private func isVideoRecordingAvailable() -> Bool {
        let front = UIImagePickerController.isCameraDeviceAvailable(.front)
        let rear = UIImagePickerController.isCameraDeviceAvailable(.rear)
        if !front || !rear {
            return false
        }
        guard let media = UIImagePickerController.availableMediaTypes(for: .camera) else {
            return false
        }
        return media.contains(kUTTypeMovie as String)
    }
    
    private func setupVideoRecordingPicker(local:Bool) -> UIImagePickerController {
        let picker = UIImagePickerController()
        if local
        {
            picker.sourceType = .camera

        }else{
            picker.sourceType = .photoLibrary

        }
        picker.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        picker.videoQuality = .typeMedium
        picker.videoMaximumDuration = 0.25 // 15 sec
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.delegate = self
        return picker
    }
    
    private func setupImagePicker(local:Bool) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        if local
        {
            picker.sourceType = .camera
            
        }else{
            picker.sourceType = .savedPhotosAlbum
            
        }
        picker.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        picker.delegate = self
        return picker
    }
    
    func launchVideoRecorder(in vc: UIViewController, cameratype:String, local:Bool ,completion: (() -> ())?) {
        
        guard isVideoRecordingAvailable() else {
            return }
        if cameratype == "Photo"
        {
            let picker = setupImagePicker(local: local)
            vc.present(picker, animated: true) {
                completion?()
            }
            
        }else{
            let picker = setupVideoRecordingPicker(local: local)
            vc.present(picker, animated: true) {
                completion?()
            }
        }
        
    }
    
    private func saveVideo(at mediaUrl: URL) {
        
        let data = try? Data.init(contentsOf: mediaUrl)
        let folder = self.getVideosFolder()
        let fileName = self.getUniqueFileName()

        let fileUrl = URL.init(fileURLWithPath: "\(folder)/\(fileName)")
        do{
            try data?.write(to: fileUrl, options: .atomic)
        }
        catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        cropVideoSquare(videourl: fileUrl) { (object) in
            self.video(videoPath: object)
        }


    }
    func cropVideoSquare(videourl: URL, completionHandler: @escaping ([String: Any]) -> Void){
        let asset = AVAsset(url: videourl)
        //create an avassetrack with our asset
        let clipVideoTrack = asset.tracks(withMediaType: .video)[0]
        //create a video composition and preset some settings
        let videoComposition = AVMutableVideoComposition.init()//AVMutableVideoComposition.init as? AVMutableVideoComposition
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        //here we are setting its render size to its height x height (Square)
        videoComposition.renderSize = CGSize(width: clipVideoTrack.naturalSize.height, height: clipVideoTrack.naturalSize.height)
        
        //create a video instruction
        let instruction = AVMutableVideoCompositionInstruction.init()
        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: CMTimeMakeWithSeconds(60, preferredTimescale: 30))
        
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: clipVideoTrack)

        var t1 = CGAffineTransform(translationX: clipVideoTrack.naturalSize.height, y: -(clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) / 2)
        
        //Make sure the square is portrait
        var t2 = t1.rotated(by: .pi / 2)
        let videoOrientation = getVideoOrientation(from: asset)

        switch videoOrientation {
        case UIImage.Orientation.up:
            t1 = CGAffineTransform(translationX: clipVideoTrack.naturalSize.height, y: -(clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) / 2)
            t2 = t1.rotated(by: .pi / 2)
        case UIImage.Orientation.down:
            t1 = CGAffineTransform(translationX: clipVideoTrack.naturalSize.height, y: -(clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) / 2)
            t2 = t1.rotated(by: -.pi/2)
        case UIImage.Orientation.right:
            t1 = CGAffineTransform(translationX: 0, y: 0)
            t2 = t1.rotated(by: 0)
        case UIImage.Orientation.left:
            t1 = CGAffineTransform(translationX: clipVideoTrack.naturalSize.height, y: -(clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) / 2)
            t2 = t1.rotated(by: .pi)
        default:
            break
        }

        let finalTransform = t2
        transformer.setTransform(finalTransform, at: .zero)
        
        //add the transformer layer instructions, then add to video composition
        if let array = [transformer] as? [AVVideoCompositionLayerInstruction] {
            instruction.layerInstructions = array
        }
        videoComposition.instructions = [instruction]
        
        //Create an Export Path to store the cropped video
        let filePath = "\(self.getVideosFolder())"
        filename_video = "\(self.getUniqueFileName())"
        exportPath = "\(filePath)/\(filename_video)"  //URL(fileURLWithPath: filePath).appendingPathComponent(filename_video).absoluteString
        let exportUrl = URL(fileURLWithPath: exportPath)
        
        
        //Remove any prevouis videos at that path
        do {
            try FileManager.default.removeItem(at: exportUrl)
        } catch {
        }
        
        //Export
        exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality)
        exporter!.videoComposition = videoComposition
        exporter!.outputURL = exportUrl
        exporter!.outputFileType = .mp4
        exporter!.exportAsynchronously(completionHandler: {
            DispatchQueue.main.async(execute: {
                //Call when finished
                let mediaObj = self.exportDidFinish(self.exporter)
                completionHandler(mediaObj)
                let Test = FileManager.default
                if Test.fileExists(atPath: self.exportPath) {
                }
                
            })
        })

    }
    func exportDidFinish(_ session: AVAssetExportSession?) -> [String: Any] {
       
        var mediaObject = [String: Any]()
        let outputURL = session?.outputURL
        
        let data = try? Data.init(contentsOf: outputURL!)
        
        let fileUrl = URL.init(fileURLWithPath: "\(exportPath)")
        do{
            try data?.write(to: fileUrl, options: .atomic)
            mediaObject = ["fileName": (exportPath as NSString).lastPathComponent, "filePath": exportPath]
            
            
        }
        catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
        return mediaObject
    }

    func getVideoOrientation(from asset: AVAsset?) -> UIImage.Orientation {
        let videoTrack = asset?.tracks(withMediaType: .video)[0]
        let size = videoTrack?.naturalSize
        let txf = videoTrack?.preferredTransform
        
        if size?.width == txf?.tx && size?.height == txf?.ty {
            return .left //return UIInterfaceOrientationLandscapeLeft;
        } else if txf?.tx == 0 && txf?.ty == 0 {
            return .right //return UIInterfaceOrientationLandscapeRight;
        } else if txf?.tx == 0 && txf?.ty == size?.width {
            return .down //return UIInterfaceOrientationPortraitUpsideDown;
        } else {
            return .up //return UIInterfaceOrientationPortrait;
        }
    }
    public func getVideosFolder() -> NSString
    {
        let documentFolderPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let videosFolderPath = documentFolderPath + "/Videos"
        
        //Check if the videos folder is already exist?  if not create it!
        var isDir: ObjCBool = true
        
        //if (fileManager.fileExists(atPath: imagesFolderPath as String, isDirectory: &isDir) && isDir) == false
        let isExist = FileManager.default.fileExists(atPath: videosFolderPath, isDirectory:&isDir)
        if isExist == false
        {
            do
            {
                try FileManager.default.createDirectory(atPath: videosFolderPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch
            {
                let fetchError = error as NSError
                print(fetchError)
            }
        }
        return videosFolderPath as NSString
    }
    public func getUniqueFileName() -> String
    {
        let time = Foundation.Date()
        let df = DateFormatter()
        df.dateFormat = "MMddyyyyhhmmssSSS"
        let timeString = df.string(from: time)
        let fileName = "\(timeString).mp4"
        return fileName
    }
    
    @objc func video(videoPath: [String: Any]) {
        //let videoURL = URL(fileURLWithPath: videoPath as String)
        self.delegate?.videoDidFinishSaving!(obj: videoPath)
    }
}

extension VideoService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        picker.dismiss(animated: true) {

            var mediaObjDict: [String : Any] = [:]
            
            
//            if (info.values(forKey: "UIImagePickerControllerMediaType") == "public.image") {

            if (info[UIImagePickerController.InfoKey.mediaType] as! String == "public.image") {
                
                //        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
                
                var chosenImage: UIImage?
                if (info[UIImagePickerController.InfoKey.editedImage] != nil) {
                    
                    chosenImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
                } else {
                    chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                }
                
                
//                let imD = chosenImage?.pngData()
//                let filePath = "\(AppConstants().getImagesFolder())"
//                let filename = "\(AppConstants().getUniqueFileName())"
                
                let imD = chosenImage?.jpeg(.low)//pngData()
                let filePath = "\(AppConstants().getImagesFolder())"
                let filename = "\(AppConstants().getUniqueFileName())"
                let Imagetimestamp = "IMG\(AppConstants().getUniqueFileName())"
                
                let fileUrl = URL.init(fileURLWithPath: "\(filePath)/\(filename)")
                do{
                    
                    try imD?.write(to: fileUrl, options: .atomic)
                    
                    mediaObjDict["fileName"] = fileUrl.lastPathComponent
                    mediaObjDict["filePath"] = "\(fileUrl)"
                }
                catch
                {
                    let fetchError = error as NSError
                    print(fetchError)
                }
            
                
                self.delegate?.imagePickerdidfinishLoaded(withData: mediaObjDict, and: Imagetimestamp)
                self.delegate?.dismissMediaDeviceView()

            }else{
                
        
            guard let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL else { return }
            
//            self.saveVideo(at: mediaURL)
                
                self.cropVideoSquare(videourl: mediaURL) { (object) in
                    self.video(videoPath: object)
                }
                
            }
            

        }
    }
}
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
