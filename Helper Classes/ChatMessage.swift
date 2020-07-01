//  ChatMessage.swift
//  LTW
//  Created by Vaayoo on 24/09/19.
//  Copyright © 2019 vaayoo. All rights reserved.

struct ChatMessage {
    var message: String?
    var isInComing: Bool?
    var date: Date?
    var dateString: String?
    var messageId: String?
    var profileURL: String?
    var imagesUrls: [String]!
    var videoUrls: [String]!
    var docsUrl: [String]!
    var name:String? // add by chandra on 30 /mar/2020
    var nameUserId:String?  // add by chandra on 30 /mar/2020
    
    init(withDictionary dict: [String: Any]) {
        let msg = dict["messageText"] as? String
        self.message = msg?.trim()
        if dict["UserID"] as! String != (UserDefaults.standard.object(forKey: "userID") as! String){
            
            self.isInComing = true
        }
        else{
            
            self.isInComing = false
        }
        self.date = Date.dateFromCustomString(customString: dict["messageDate"] as? String ?? "")
        self.dateString = AppConstants().getTime(str: dict["messageDate"] as? String ?? "")
        self.messageId = "\(dict["MessageID"] as? Int ?? 0)"
        self.profileURL = dict["profileURL"] as? String ?? ""
        self.imagesUrls = dict["images"] as? [String] ?? []
        self.videoUrls = dict["videos"] as? [String] ?? []
        self.docsUrl = dict["docs"] as? [String] ?? []
        self.name = dict["FullName"] as? String ?? "" // add by chandra on 30 /mar/2020
        self.nameUserId = dict["UserID"] as? String ?? "" // add by chandra on 30 /mar/2020
    }
}
