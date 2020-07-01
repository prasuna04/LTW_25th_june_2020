//  Utility.swift
//  LTW
//  Created by Ranjeet Raushan on 09/04/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import Foundation
import UIKit
import SwiftMessages
import SwiftyJSON

func applyFloatingRoundShadow(view: UIView) {
    view.layer.shadowColor = UIColor.darkGray.cgColor
    view.layer.masksToBounds = false
    view.layer.shadowRadius = 0.2
    view.layer.shadowOpacity = 0.2
    view.layer.cornerRadius = view.frame.height / 2
}
func showMessage(view: MessageView = try! SwiftMessages.viewFromNib(), isCardView: Bool = false ,titleText: String = "Message" ,bodyText: String,iconImage: UIImage? = nil ,iconText: String? = nil,
                 buttonImage: UIImage? = nil,buttonTitle: String? = "OK",theme: Theme = Theme.info, iconStyle: IconStyle = .default,
                 accessibilityPrefix: String = "info", dropShadow: Bool = true, showButton:Bool = true,showIcon: Bool = true ,showTitle: Bool = true ,showBody: Bool = true, presentationStyle: SwiftMessages.PresentationStyle = .top ,presentationContext: SwiftMessages.PresentationContext = .window(windowLevel: UIWindow.Level.normal),duration: SwiftMessages.Duration = .forever, dimMode: SwiftMessages.DimMode = .gray(interactive: true),shouldAutoRotate: Bool = true,interactiveHide: Bool = true, buttonTapHandler: ((UIButton)->())? = { _ in SwiftMessages.hide() } ) {
    view.configureContent(title: titleText, body: bodyText, iconImage: iconImage, iconText: iconText, buttonImage: buttonImage, buttonTitle:  buttonTitle, buttonTapHandler : buttonTapHandler)
    view.configureTheme(theme, iconStyle: iconStyle)
    view.accessibilityPrefix = accessibilityPrefix
    
    if dropShadow {
        view.configureDropShadow()
    }
    if !showButton{
        view.button?.isHidden = true
    }
    if !showIcon  {
        view.iconImageView?.isHidden = true
        view.iconLabel?.isHidden = true
    }
    if !showTitle {
        view.titleLabel?.isHidden = true
    }
    
    if !showBody{
        view.bodyLabel?.isHidden = true
    }
    if case Theme.warning = theme  {
    }
    // Config setup
    var config = SwiftMessages.defaultConfig
    config.presentationStyle = presentationStyle
    config.presentationContext = presentationContext
    config.duration = duration
    config.dimMode = dimMode
    config.shouldAutorotate = shouldAutoRotate
    config.interactiveHide = interactiveHide
    // Set status bar style unless using card view (since it doesn't
    // go behind the status bar).
    if case .top = config.presentationStyle, isCardView {
        config.preferredStatusBarStyle = .lightContent
    }
    //Show
    SwiftMessages.show(config: config, view: view)
}

func getDocumentDirectory() -> String {
    let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
    let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
    if let dirPath = paths.first
    {
        return dirPath
    }else {
        return ""
    }
  }
func getSubSubjectID(subSubjectName: String) -> Int? {
    let stringJSON  = UserDefaults.standard.string(forKey: "subSubjectList")!
    let json = JSON.init(parseJSON: stringJSON)
    let SubSubjectJSONArray = json.arrayValue
    let selectedSubSubjectJSON = SubSubjectJSONArray.filter { json -> Bool in
        return json["SubjectName"].stringValue == subSubjectName
    }
    if selectedSubSubjectJSON.count > 0 {
        return selectedSubSubjectJSON[0]["Sub_SubjectID"].intValue
    }
    return nil
}
func getSubjectName(with ID: Int) -> String? {
    let stringJSON  = UserDefaults.standard.string(forKey: "subSubjectList")!
    let json = JSON.init(parseJSON: stringJSON)
    let SubSubjectJSONArray = json.arrayValue
    let selectedSubSubjectJSON = SubSubjectJSONArray.filter { json -> Bool in
        return json["Sub_SubjectID"].intValue == ID
    }
    if selectedSubSubjectJSON.count > 0 {
        return selectedSubSubjectJSON[0]["SubjectName"].stringValue
    }
    return nil
}
func getAttributedString(htmlString: String) -> NSAttributedString {
    let htmlData = NSString(string: htmlString).data(using: String.Encoding.unicode.rawValue)
    //    let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 40.0)! ]
    
    let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
    let attributedString = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
    return attributedString
}

func getEncryptedString(planeString : String) -> String {
    let plainData = planeString.data(using: String.Encoding.utf8)
    let stringEncryption = StringEncryption.init()
    let key = stringEncryption.sha256("LTWVaayookey@~*", length: 16)
    let data = stringEncryption.encrypt(plainData, key: key, iv: "LTWVaayoo@1230~*")
    let encyptedPwd = NSString.base64String(from: data, length: UInt(data!.count))
    return NSString.init(string: encyptedPwd!) as String
}
