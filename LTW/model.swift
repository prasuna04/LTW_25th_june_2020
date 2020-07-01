//  model.swift
//  Task1
//  Created by vaayoo on 15/11/19.
//  Copyright © 2019 Vaayoo. All rights reserved.

import Foundation
import  UIKit

// the model is used to store the data of students who are attened the test

class model   {
    var testId : String          // for storing particular testId where students attended the exam
    var UserId : String
    var FirstName : String
    var LastName : String
    var ProfileURl : String
    var Score: Double /* Added  By Yashoda on 27th Jan 2020  */

    
    //creating the constructor to assign the value
    init(testId: String,UserId : String,FirstName : String,LastName : String,ProfileURl: String, Score: Double) { /* Added Score: Int  By Yashoda on 27th Jan 2020  */
        self.testId=testId
        self.UserId=UserId
        self.FirstName = FirstName.capitalized
        self.LastName=LastName.capitalized
        self.ProfileURl=ProfileURl
        self.Score = Score /* Added  By Yashoda on 27th Jan 2020  */
    }
    
}

//the class is used to store the information of particular student answer with the actuall answer

class AnswerModel{
    var questionId : String
    var questionTitle : String
    var yourAnswer : String
    var questionMarks : String//yasodha
    init(questionId: String,questionTitle: String,yourAnswer: String ,questionMarks : String) {
        self.questionId=questionId
        self.questionTitle=questionTitle
        self.yourAnswer=yourAnswer
        self.questionMarks = questionMarks//yasodha
    }
}
