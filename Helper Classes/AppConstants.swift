import Foundation
import UIKit
import AVFoundation
class AppConstants: NSObject {
    
       
    func ShowAlert(vc: UIViewController, title: String, message: String)
    {
        DispatchQueue.main.async {
            let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction.init(title: "OK", style: .default) { (UIAlertAction) in}
            alertController.addAction(action)
            vc.present(alertController, animated: true, completion: nil)
        }
       
    }
    
    func isValidEmail(_ email: String) -> Bool {
        
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
        
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
    
    func getImagesFolder() -> NSString {
        let documentFolderPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let imagesFolderPath = documentFolderPath + "/Images"
        
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
    func getUniqueDocumentFileName() -> String{
        let time = Foundation.Date()
        let df = DateFormatter()
        df.dateFormat = "MMddyyyyhhmmssSSS"
        let timeString = df.string(from: time)
        let fileName = "\(timeString)"
        return fileName
    }
    func currentDateInUTC() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let result = dateFormatter.string(from: date)
        let finalDate =  self.localToUTC(date: result, formatter:dateFormatter )
        return finalDate
    }
    
    func localToUTC(date:String, formatter: DateFormatter) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: dt!)
    
    }
    
    
  func localToUTCForChat(date:String, formatter: DateFormatter) -> String  {
    
    
    let dateFormatter = DateFormatter()
    let dateFormat = DateFormatter()
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = returnDateFormatForSendingServer()
    var dt = dateFormatter.date(from: date)
    dateFormat.timeZone = TimeZone.current
    dateFormat.dateFormat = returnDateFormatForSendingServer()
    if dt == nil{
    dateFormat.dateFormat = returnDateFormatForSendingServer()//returnDateFormat()
    dt = dateFormat.date(from: date)
    }
    dateFormat.timeZone = TimeZone(abbreviation: "UTC")
    
    return dateFormat.string(from: dt ?? Date())
    
    
    }
    
    func getDateFromServerString(date:String) -> String {
        let dateFormat = DateFormatter()

        if date.contains(".") {
            
            let arr = date.split(separator: ".")//12/9/18
            let parser1 = DateFormatter()
            parser1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            parser1.timeZone = TimeZone(abbreviation: "UTC")
            let job = parser1.date(from: String(arr[0]))
            dateFormat.timeZone = TimeZone.current
            dateFormat.dateFormat = "MMMM dd,yyyy"
            return "\(dateFormat.string(from: job!))"
            
        }else{
            
            if(date != "" )
            {
                let parser1 = DateFormatter()
                parser1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                parser1.timeZone = TimeZone(abbreviation: "UTC")
                let job = parser1.date(from: date)
                dateFormat.timeZone = TimeZone.current
                dateFormat.dateFormat = "MMMM dd,yyyy"
                return "\(dateFormat.string(from: job!))"
            }
        }
        
        return ""
    }
    
    func getDateFromString(date:String) -> Date {
        
        if date.contains(".") {
            
            let arr = date.split(separator: ".")//12/9/18
            let parser1 = DateFormatter()
            parser1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            parser1.timeZone = TimeZone(abbreviation: "UTC")
            let job = parser1.date(from: String(arr[0]))
            return job ?? Date()
            
        }else{
            
            if(date != "" )
            {
                let parser1 = DateFormatter()
                parser1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                parser1.timeZone = TimeZone(abbreviation: "UTC")
                let job = parser1.date(from: date)
                return job ?? Date()
            }
        }
        
        return Date()
    }
    
    func remainingTime(startTime:Date , endTime:Date) -> String {
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([Calendar.Component.minute,Calendar.Component.hour,Calendar.Component.day], from: startTime, to: endTime)
        
        var dateStr = ""
        let days = dateComponents.day
        let hrs = dateComponents.hour
        let minutes = dateComponents.minute
        if let day = days , day != 0
        {
            if day > 1{
                
                dateStr =  "\(day) days ago"

            }else
            {
                dateStr = "\(day) day ago"

            }

            
            return dateStr
        }
        if let hr = hrs , hr != 0
        {
            if hr > 1
            {
                dateStr = "\(hr) hrs ago"

            }else
            {
                dateStr = "\(hr) hr ago"

            }
            
            
            return dateStr
        }
        
        if let minute = minutes
        {
            if minute > 1
            {
                dateStr = "\(minute) mins ago"

            }
            else
            {
                dateStr = "\(minute) min ago"

            }
            
            
            return dateStr
        }
        

        return dateStr
    }
    
    func getImageFrom(gradientLayer:CAGradientLayer) -> UIImage? {
        var gradientImage:UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
    func setGradient(view: UIView) {
        let gradient = CAGradientLayer()
        var bounds = view.bounds
        if view is UINavigationBar {
            bounds.size.height += UIApplication.shared.statusBarFrame.size.height
            //print("Navigation Bar Height  = \(bounds.size.height)")
        }
        gradient.frame = bounds
        gradient.colors = [UIColor.init(hex:ColorsList.gradientTopColor).cgColor, UIColor.init(hex: ColorsList.gradientBottomColor ).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        if let image = getImageFrom(gradientLayer: gradient) {
            if let navigationBar = view as? UINavigationBar {
                //navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
                navigationBar.barTintColor = UIColor(patternImage: image)
            } else if let button = view as? UIButton {
                button.setBackgroundImage(image, for: .normal)
            }
        }
    }
    func setGradient1(view: UIView) {
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.init(hex:ColorsList.gradientBottomColor ).cgColor, UIColor.init(hex: ColorsList.gradientTopColor ).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        view.layer.insertSublayer(gradient, at: 0)
        
    }
   
    func setBtnGradient(view: UIView) {
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.init(hex:ColorsList.gradientBtnBottomColor).cgColor, UIColor.init(hex: ColorsList.gradientBtnTopColor ).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        if let image = getImageFrom(gradientLayer: gradient) {
            if let button = view as? UIButton {
                button.setBackgroundImage(image, for: .normal)
            }
        }
//        view.layer.insertSublayer(gradient, at: 0)
    
        
    }

    func returnDateFormatForSendingServer() -> String{
        return "MM-dd-yy hh:mm a"
    }
    
    func getTime(str: String) -> String
    {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormat.timeZone = TimeZone(abbreviation: "UTC")
        var dat: Date!
        if str.contains(".") {
            let arr = str.split(separator: ".")//12/9/18
            dat = dateFormat.date(from: String(arr[0]))
        }
        else{
            dat = dateFormat.date(from:str)
            if dat == nil{
               
                    dateFormat.dateFormat = returnDateFormatForSendingServer()
                    dat = dateFormat.date(from:str)
            }
        }
       
        dateFormat.timeZone = TimeZone.current
        dateFormat.dateFormat = "HH:mm"
        return "\(dateFormat.string(from: dat!))"
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        
        do {

            let asset = AVURLAsset(url: url, options: nil)
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
    func azureUrls(collection: [String], containerType: containerUrls) -> [String]{
        var finalAzureUrls = [String]()
        var azurePath: String!
        switch containerType {
        case .image:
            azurePath = "https://ltwuploadcontent.blob.core.windows.net/actualimages/"
        case .thumbnails:
            azurePath = "https://ltwuploadcontent.blob.core.windows.net/thumbnails/"
        case .video:
            azurePath = "https://ltwuploadcontent.blob.core.windows.net/videos/"
        case .document:
            azurePath = "https://ltwuploadcontent.blob.core.windows.net/documents/"
        }
        for str in collection{
            if str.contains("var"){
                let urlPath = URL.init(string: str)
                let finalPath = urlPath?.lastPathComponent
                finalAzureUrls.append(azurePath + finalPath!)
            }
            else{
                finalAzureUrls.append(str)
            }
        }
        return finalAzureUrls
    }
}

enum ColorsList
{
   
    static let gradientBtnTopColor = "1ec942"
    static let gradientBtnBottomColor = "20b66d"
    static let gradientTopColor = "2af598"
    static let gradientBottomColor = "008aad"
    static let greenColor = "1ec942"
    static let grayColor = "909191"
    static let txtBoarderColor = "e0e0e0"
    static let redColor = "FA0707"
    static let white = "FFFFFF"
    static let black = "000000"
    static let lightGray = "9A9A9A"



}
enum containerUrls{
    case image, thumbnails, video, document
}

