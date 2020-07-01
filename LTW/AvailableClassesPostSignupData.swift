//
//  AvailableClassesPostSignupData.swift
//  LTW
//
//  Created by vaayoo on 22/04/20.
//  Copyright © 2020 vaayoo. All rights reserved.
//

import Foundation

class AvailableClassesPostSignupData {
    var _profileUrl : String!
    var _teachersName : String!
    var _teacherUserID : String!
    var _classTitle : String!
    var _classStartDate :  String!
    var _classStartTime : String!
    var _classEndtime : String!
    var _pointsPerSubscriber : Int!
    var _numberOfSubscriber : Int!
    var _publicorPrivateID : Int!
    var _subjectId : Int!
    var _subSubjectID : Int!
    var _classID : Int!
    var _isClassFull : Bool!
    var _ratingsPoints : Double!
    var _grades : String!
    
    var profileUrl : String
    {
        if _profileUrl == nil
        {
            _profileUrl = ""
        }
        return _profileUrl
    }
    var teachersName : String
    {
        if _teachersName == nil
        {
            _teachersName = ""
        }
        return _teachersName
    }
    var teacherUserID : String
    {
        if _teacherUserID == nil
        {
            _teacherUserID = ""
        }
        return _teacherUserID
    }
    var classTitle : String
    {
        if _classTitle == nil
        {
            _classTitle = ""
        }
        return _classTitle
    }
    var classStartDate : String
    {
        if _classStartDate == nil
        {
            _classStartDate = ""
        }
        return _classStartDate
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
    var subjectId : Int
    {
        if _subjectId == nil
        {
            _subjectId = 0
        }
        return _subjectId
    }
    var subSubjectID : Int
    {
        if _subSubjectID == nil
        {
            _subSubjectID = 0
        }
        return _subSubjectID
    }
    
    var classID : Int
    {
        if _classID == nil
        {
            _classID = 0
        }
        return _classID
    }
    
    var ratingsPoints : Double
    {
        if _ratingsPoints == nil || _ratingsPoints == 0.0
        {
            _ratingsPoints = 2.5
        }
        return _ratingsPoints
    }
    var grades : String
    {
        if _grades == nil
        {
            _grades = ""
        }
        return _grades
    }
    
    init(availableClassesPostSignUpDict: Dictionary<String, AnyObject>) {
        if let profileURL = availableClassesPostSignUpDict["profileURL"] as? String {
            _profileUrl = profileURL
        }
        if let teachersName = availableClassesPostSignUpDict["fullname"] as? String {
            _teachersName = teachersName
        }
        if let teacherUserID = availableClassesPostSignUpDict["userid"] as? String {
            _teacherUserID = teacherUserID
        }
        if let classTitle = availableClassesPostSignUpDict["title"] as? String {
            _classTitle = classTitle
        }
        if let classStartDate = availableClassesPostSignUpDict["date"] as? String {
            _classStartDate = classStartDate
        }
        if let classStartDate = availableClassesPostSignUpDict["UTC_ClassDatetime"] as? String {
            _classStartDate = classStartDate
        }
//        if let classStartTime = availableClassesPostSignUpDict["start_time"] as? String {
//            _classStartTime = classStartTime
//        }
        if let classEndtime = availableClassesPostSignUpDict["UTC_ClassEndtime"] as? String {
            _classEndtime = classEndtime
        }
        if let pointsPerSubscriber = availableClassesPostSignUpDict["Pay_points"] as? Int {
            _pointsPerSubscriber = pointsPerSubscriber
        }
        if let numberOfSubscriber = availableClassesPostSignUpDict["num_Subscribed"] as? Int {
            _numberOfSubscriber = numberOfSubscriber
        }
        if let publicorPrivateID = availableClassesPostSignUpDict["SharedType"] as? Int {
            _publicorPrivateID = publicorPrivateID
        }
        if let subjectId = availableClassesPostSignUpDict["SubjectID"] as? Int {
            _subjectId = subjectId
        }
        if let subSubjectID = availableClassesPostSignUpDict["Sub_SubjectID"] as? Int {
            _subSubjectID = subSubjectID
        }
        if let classID = availableClassesPostSignUpDict["Class_id"] as? Int {
            _classID = classID
        }
        if let isClassFull = availableClassesPostSignUpDict["isClassFull"] as? Bool {
            _isClassFull = isClassFull
        }
        if let ratingsPoints = availableClassesPostSignUpDict["Rating"] as? Double {
            _ratingsPoints = ratingsPoints
        }
        if let grades = availableClassesPostSignUpDict["Grades"] as? String {
            _grades = grades
        }
        
    }

}

