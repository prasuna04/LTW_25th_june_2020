//  AttendedOrDeliveredClassData.swift
//  LTW
//  Created by vaayoo on 02/04/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import Foundation

class AttendedOrDeliveredClassData {
    
    var _classTitle : String!
    var _classSubjectID : Int!
    var _classSubTopicID : Int!
    var _classCommencingDate :  String!
    //var _personType : String!
    var _classStartTime : String!
    var _classEndtime : String!
    var _pointsPerSubscriber : Int!
    var _numberOfSubscriber : Int!
    var _publicorPrivateID : Int!
    var _isClassFull : Bool!
    var _isSubcribed : Bool!
    var _userId : String!
    var _classId : Int!
    var _grades : String!
    
    var classTitle : String
    {
        if _classTitle == nil
        {
            _classTitle = ""
        }
        return _classTitle
    }
    var classSubjectID : Int
       {
           if _classSubjectID == nil
           {
               _classSubjectID = 1
           }
           return _classSubjectID
       }
    var classSubTopicID : Int
    {
        if _classSubTopicID == nil
        {
            _classSubTopicID = 1
        }
        return _classSubTopicID
    }
    var classCommencingDate : String
    {
        if _classCommencingDate == nil
        {
            _classCommencingDate = ""
        }
        return _classCommencingDate
    }
    var classStartTime : String
    {
        if _classStartTime == nil
        {
            _classStartTime = ""
        }
        return _classStartTime
    }
    var classEndtime : String
    {
        if _classEndtime == nil
        {
            _classEndtime = ""
        }
        return _classEndtime
    }
    var pointsPerSubscriber : Int
    {
        if _pointsPerSubscriber == nil
        {
            _pointsPerSubscriber = 0
        }
        return _pointsPerSubscriber
    }
    var numberOfSubscriber : Int
    {
        if _numberOfSubscriber == nil
        {
            _numberOfSubscriber = 0
        }
        return _numberOfSubscriber
    }
    var publicorPrivateID : Int
    {
        if _publicorPrivateID == nil
        {
            _publicorPrivateID = 1
        }
        return _publicorPrivateID
    }
    var isClassFull : Bool
    {
        if _isClassFull == nil
        {
            _isClassFull = false
        }
        return _isClassFull
    }
    var isSubcribed : Bool
    {
        if _isSubcribed == nil
        {
            _isSubcribed = false
        }
        return _isSubcribed
    }
    var userId : String
    {
        if _userId == nil
        {
            _userId = ""
        }
        return _userId
    }
    var classId : Int
    {
        if _classId == nil
        {
            _classId = 1
        }
        return _classId
    }
    var grades : String
    {
        if _grades == nil
        {
            _grades = ""
        }
        return _grades
    }
    
    
    init(attendedOrDeliveredClassDict: Dictionary<String, AnyObject>) {
        if let classTitle = attendedOrDeliveredClassDict["title"] as? String {
            _classTitle = classTitle
        }
        if let classSubjectID = attendedOrDeliveredClassDict["SubjectID"] as? Int {
            _classSubjectID = classSubjectID
        }
        if let classSubTopicID = attendedOrDeliveredClassDict["Sub_SubjectID"] as? Int {
            _classSubTopicID = classSubTopicID
        }
        if let classCommencingDate = attendedOrDeliveredClassDict["UTC_ClassDatetime"] as? String {
            _classCommencingDate = classCommencingDate
        }
        if let classEndtime = attendedOrDeliveredClassDict["UTC_ClassEndtime"] as? String {
            _classEndtime = classEndtime
        }
        if let pointsPerSubscriber = attendedOrDeliveredClassDict["Pay_points"] as? Int {
            _pointsPerSubscriber = pointsPerSubscriber
        }
        if let numberOfSubscriber = attendedOrDeliveredClassDict["num_Subscribed"] as? Int {
            _numberOfSubscriber = numberOfSubscriber
        }
        if let publicorPrivateID = attendedOrDeliveredClassDict["SharedType"] as? Int {
            _publicorPrivateID = publicorPrivateID
        }
        if let isClassFull = attendedOrDeliveredClassDict["isClassFull"] as? Bool {
            _isClassFull = isClassFull
        }
        if let isSubcribed = attendedOrDeliveredClassDict["isSubcribed"] as? Bool {
            _isSubcribed = isSubcribed
        }
        if let userId = attendedOrDeliveredClassDict["userid"] as? String {
            _userId = userId
        }
        if let classId = attendedOrDeliveredClassDict["Class_id"] as? Int {
            _classId = classId
        }
        if let grades = attendedOrDeliveredClassDict["Grades"] as? String {
            _grades = grades
        }
    }
 
}

