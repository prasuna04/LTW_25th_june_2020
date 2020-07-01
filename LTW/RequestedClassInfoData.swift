//  RequestedClassInfoData.swift
//  LTW
//  Created by vaayoo on 04/03/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import Foundation

class RequestedClassInfoData {
    
    var _studentName : String!
    var _grades : String!

    var grades : String
    {
    if _grades == nil {
    _grades = ""
    }
    return _grades
    }
    var _profileUrl :  String!
    //var _personType : String!
    var _school : String!
    var _state : String!
    var _country : String!
    var _board :String!
    var _subject : String!
    //var _grade : String!
    var _requestedOn : String!
    var _subTopic : String!
    var _classTitle : String!
    var _startDate : String!
    var _startTime: String!
    var _endTime : String!
    var _description : String!
    var _requestID : String!
    var _studentUserID : String!
    
    var studentName : String
    {
        if _studentName == nil
        {
            _studentName = ""
        }
        return _studentName
    }
    var profileUrl : String
    {
        if _profileUrl == nil
        {
            _profileUrl = ""
        }
        return _profileUrl
    }
    var studentUserID : String
    {
        if _studentUserID == nil
        {
            _studentUserID = ""
        }
        return _studentUserID
    }
    var school : String
    {
        if _school == nil
        {
            _school = ""
        }
        return _school
    }
    var state : String
    {
        if _state == nil
        {
            _state = ""
        }
        return _state
    }
    var country : String
    {
        if _country == nil
        {
            _country = ""
        }
        return _country
    }
    var board : String
    {
        if _board == nil
        {
            _board = ""
        }
        return _board
    }
    var subject : String
    {
        if _subject == nil
        {
            _subject = ""
        }
        return _subject
    }
    var requestedOn : String
    {
        if _requestedOn == nil
        {
            _requestedOn = ""
        }
        return _requestedOn
    }
    var subTopic : String
    {
        if _subTopic == nil
        {
            _subTopic = ""
        }
        return _subTopic
    }
    var classTitle : String
    {
        if _classTitle == nil
        {
            _classTitle = ""
        }
        return _classTitle
    }
    var startDate : String
    {
        if _startDate == nil
        {
            _startDate = ""
        }
        return _startDate
    }
//    var startTime : String
//    {
//        if _startTime == nil
//        {
//            _startTime = ""
//        }
//        return _startTime
//    }
    var endDate : String
    {
        if _endTime == nil
        {
            _endTime = ""
        }
        return _endTime
    }
    var description : String
    {
        if _description == nil
        {
            _description = ""
        }
        return _description
    }
    var requestID : String
    {
        if _requestID == nil
        {
            _requestID = ""
        }
        return _requestID
    }
    
    init(requestedClassDict: Dictionary<String, AnyObject>) {
        if let sName = requestedClassDict["StudentName"] as? String {
            _studentName = sName
        }
        if let imgUrl = requestedClassDict["ProfileUrl"] as? String {
            _profileUrl = imgUrl
        }
        if let scl = requestedClassDict["School"] as? String {
            _school = scl
        }
        if let st = requestedClassDict["State"] as? String {
            _state = st
        }
        if let cntry = requestedClassDict["Country"] as? String {
            _country = cntry
        }
        if let brd = requestedClassDict["Board"] as? String {
            _board = brd
        }
        if let sbjct = requestedClassDict["Subject"] as? String {
            _subject = sbjct
        }
        if let rqstdOn = requestedClassDict["RequestedOn"] as? String {
            _requestedOn = rqstdOn
        }
        if let sbtpc = requestedClassDict["SubTopic"] as? String {
            _subTopic = sbtpc
        }
        if let clsTitle = requestedClassDict["ClassTitle"] as? String {
            _classTitle = clsTitle
        }
        if let strtDt = requestedClassDict["StartDate"] as? String {
            _startDate = strtDt
        }
//        if let strttm = requestedClassDict["EndDate"] as? String {
//            _startTime = strttm
//        }
        if let endtm = requestedClassDict["EndDate"] as? String {
            _endTime = endtm
        }
        if let desc = requestedClassDict["Description"] as? String {
            _description = desc
        }
        if let rqstID = requestedClassDict["RequestID"] as? String {
            _requestID = rqstID
        }
        if let sId = requestedClassDict["StudentUserID"] as? String {
            _studentUserID = sId
        }
        if let grades = requestedClassDict["Grade"] as? String {
        _grades = grades
        }
    }
}
