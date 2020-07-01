//  FollowUserModel.swift
//  LTW
//  Created by Vaayoo on 04/10/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import Foundation
struct Welcome: Codable {
    let message: String
    let error: Bool
    let controlsData: ControlsData
    
    enum CodingKeys: String, CodingKey {
        case message, error
        case controlsData = "ControlsData"
    }
}

// MARK: - ControlsData
struct ControlsData: Codable {
    let userFollow: [UserFollow]
}

// MARK: - UserFollow
struct UserFollow: Codable {
    let userID, firstName, lastName, emailID: String
    let profileURL: String
    let myPoints, personType: Int
    let schools: String
    var isFollowing: Bool
    
    enum CodingKeys: String, CodingKey {
        case userID = "UserID"
        case firstName = "FirstName"
        case lastName = "LastName"
        case emailID = "EmailID"
        case profileURL = "ProfileUrl"
        case myPoints = "MyPoints"
        case personType = "PersonType"
        case schools = "Schools"
        case isFollowing
    }
}
