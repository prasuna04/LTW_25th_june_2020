//  modelAttendTV.swift
//  LTW
//  Created by yashoda on 24/03/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import Foundation
import  UIKit
class ModelData: NSObject {
  static let shared: ModelData = ModelData()
  var isAttandTV = false
  var answerSubmitted : String = ""//added by yasodha

  //Myclasses
  var isCreatingClassFromExpired = false
  var previousViewController = ""//added by yasodha
  var activeTabIndex = 0

    //Mytest - > ReviewAnswer buttonclick
    var isClickReviewAnswer = false


  //ReviewTestSubmit
  var isFromReviewTestSubmit = false

    //Added by dk
    var isComingBackFromRequestedClassPage = false
}

