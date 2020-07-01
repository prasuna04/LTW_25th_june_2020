//  Constants.swift
//  LTW
//  Created by Ranjeet Raushan on 09/04/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import Foundation

//Staging endpoints..
let productionBaseUrl = "http://ltwservice-staging.azurewebsites.net/" //(staging server)
let searchIndex  = "https://ltw-searchfree.search.windows.net/indexes/ltw-searchstaging/docs?api-version=2017-11-11&search="
let filterSearchIndex = "https://ltw-searchfree.search.windows.net/indexes/ltw-searchstaging/docs?api-version=2017-11-11&facet=Sub_SubjectName,count:50&$filter="
let publishableKey = "pk_test_51GsIcDFSQSe7eG0MlhgXW1VPImnIoSSjTOZn0rD6bkuRFJcuI9aV4Ed0K3JJA0ILAS1RdycyBxsvHWLDnCxglGQO00tqsrYeLu"
let publishableKeyForImg = "Bearer sk_test_51GsIcDFSQSe7eG0MkuYA1EN971ee68ou1FqpJiovfvQhFnv1ELz2QmvLl5KerHVoAbut1AYIxg18ci6A5iRrSFgW00pYFuLHXG"
let strBuildName = "Staging Server"
// End of staging endpoitns..

//Production endpoints..
//let productionBaseUrl = "http://ltwservice.azurewebsites.net/" //(production server) /* If need to change to production server just uncomment this line & comment staging server line , so please don't delete this */
//let searchIndex  = "https://ltw-searchfree.search.windows.net/indexes/ltw-searchindex/docs?api-version=2017-11-11&search="//(production server)
//let filterSearchIndex = "https://ltw-searchfree.search.windows.net/indexes/ltw-searchindex/docs?api-version=2017-11-11&facet=Sub_SubjectName,count:50&$filter="
//let publishableKey = "pk_live_23WGJNotUMyfKMBVZMDBtARS00rfavAr62"
//let publishableKeyForImg = "Bearer sk_live_uJl9d8y66xGzOgyomKxn8uIm00eqJbOcRm"
//let strBuildName = "Production Server"
//End of production endpoints..

enum Constants{
    static let HUBNAME = "LTWNotificationHub"
    static let HUBLISTENACCESS = "Endpoint=sb://ltwnotification.servicebus.windows.net/;SharedAccessKeyName=DefaultFullSharedAccessSignature;SharedAccessKey=09Ycfp6ID+BlYzij6dhvlzgUp4R6BEv1S6lnmMTp3u4="
}

enum Endpoints {
    static let buildName = strBuildName
    static let signIn = productionBaseUrl + "api/Users/UserSignin" /* Added By Ranjeet */
    static let signUp = productionBaseUrl + "api/Users/AddUser" // Add User or Sign Up /* Added By Ranjeet */
    static let tutorSignUp = productionBaseUrl +   "api/Users/AddTutorInfo" // Tutor Sign Up /* Added By Prasuna */
    static let updateTutorInfo = productionBaseUrl + "api/Users/updateTutorInfo/" /* Tutor Update Added By Chandra on 28th Feb 2020  */
    static let updateQuickID = productionBaseUrl + "api/Users/RegisterQuickbloxIDAtSignupOrSignin/" // Quick Blox /* Added By Prasuna */
    static let updateProfileUser =  productionBaseUrl + "api/Users/UpdateUser" // Update or Edit User /* Added By Ranjeet */
    static var forgotPwdEndPoint = productionBaseUrl + "api/Users/ForgotPassword?emailid=" /* Added By Ranjeet */
    static let changePwdEndPoint = productionBaseUrl + "api/Users/ChangePassword"  /* Added By Ranjeet */
    static let homeLandingEndPoint = productionBaseUrl + "api/v1/LTWLanding/" /* Added By Ranjeet */
    static let getSearchQstnEndPoint = productionBaseUrl + "api/v1/SearchQuestion/"
    static let askQstnEndPoint = productionBaseUrl + "api/Users/AskQuestions/" /* Added By Ranjeet */
    static let homeUpVoteEndPoint = productionBaseUrl + "api/Users/QuestionUpVote/" /* Added By Ranjeet */
    //  static let homeDownVoteEndPoint = productionBaseUrl + "api/Users/QuestionDownVote/" /* Don't delete downvote functionality , future might reuse somewhere else */ /* Added By Ranjeet */
    static let homeReportOffensiveEndPoint = productionBaseUrl + "api/Users/ReportOffensive/" // report offensive  /* Added By Ranjeet */
    static let answerReportOffensiveEndPoint = productionBaseUrl + "api/Users/ReportOffensiveAnswer/" // report offensive  /* Added By Ranjeet */
    
    static let followQstnInAnswrsScreen = productionBaseUrl + "api/Users/FollowQuestion/" //follow  /* Added By Ranjeet */
    static let unFollowQstnInAnswrsScreen = productionBaseUrl + "api/Users/UnFollowQuestion/"  //unfollow  /* Added By Ranjeet */
    static let ansUpVoteEndPoint = productionBaseUrl + "api/Users/AnswerUpVote/" /* Added By Ranjeet */
    //  static let ansDownVoteEndPoint = productionBaseUrl + "api/Users/AnswerDownVote/" /* Added By Ranjeet */ /* Don't delete downvote functionality , future might reuse somewhere else */ /* Added By Ranjeet */
    static let contentQstonAskdEndPoint = productionBaseUrl + "api/Users/UserAskedQuestions?UserID="  /* Added By Ranjeet */
    static let questionsThatCanYouAnsweredEndPoint = productionBaseUrl + "api/Users/YouCanAnswerQuestions?UserID="  /* Added By Ranjeet */
    static let  answrsThatuProvidedEndPoint = productionBaseUrl + "api/Users/YourAnsweredQuestions?UserID=" /* Added By Ranjeet */
    static let deleteanswerThatUProvdedEndPoint = productionBaseUrl + "api/Users/DeleteYourAnswers/"
    //    static let editAnswerThatUProvidedEndPoints = productionBaseUrl + "api/QuestionAnswer/EditYourAnswer/UserID"
    static let editAnswerThatUProvidedEndPoints = productionBaseUrl + "api/QuestionAnswer/EditYourAnswer/"
    static let contentQstonFolowEndPoint = productionBaseUrl + "api/Users/UserFollowedQuestions?UserID="  /* Added By Ranjeet */
    static let editUserAskedQuestionGetEndPoint = productionBaseUrl + "api/QuestionAnswer/QuestionDetails" // Get Edit  /* Added By Ranjeet */
    static let editUserAskedQuestionPostEndPoint = productionBaseUrl + "api/Users/EditUserAskedQuestion" // Post Edit /* Added By Ranjeet */
    static let deleteContntQstonAskdBtnEndPoint = productionBaseUrl + "api/Users/DeleteUserAskedQuestion/"  /* Added By Ranjeet */
    static let myFollowedEndPoint = productionBaseUrl + "api/Users/UserFollowCategory?UserID="  /* Added By Ranjeet */
    static let addToFolowCatgryEndPoint = productionBaseUrl + "api/Users/AddToFollowCategory"  /* Added By Ranjeet */
    static let unfollowCatgryEndPoint = productionBaseUrl + "api/Users/UnFollowCategory" /* Added By Ranjeet */
    static let userProfileEndPoint = productionBaseUrl + "api/Users/ProfileData/" /* Added By Ranjeet */
    static let personalProfileEndPoint = productionBaseUrl + "api/getUserInfo/"  /* Added By Ranjeet */
    static let transferPointsEndPoint = productionBaseUrl + "api/users/Profile/TransferPoints/"  /* Added By Ranjeet */
    static let userFollowEndPoint = productionBaseUrl + "api/Users/FollowUser/" /* Added By Ranjeet */
    static let searchTeacherEndPoint = productionBaseUrl +  "api/Profile/SearchTeachers" /* Added By Ranjeet on 18th Feb 2020 */
    static let requestAClassClassEndPoint = productionBaseUrl + "api/class/RequestClass" /* Added By Ranjeet on 20th Feb 2020 */
    static let tutorAvailableClassEndPoint = productionBaseUrl + "api/class/TutorAvailableClass/" /* Added By Ranjeet on 23rd Feb 2020 */
    static let getRequestClassInfo = productionBaseUrl + "api/class/GetRequestClassInfo/"
    static let createTest = productionBaseUrl + "api/CreateTest/" /* Added By Mukesh */
    static let addQuesEndPoint = productionBaseUrl + "api/CreateTest_Questions" /* Added By Mukesh */
    static let allTestListUrl = productionBaseUrl + "api/AllTestList/" /* Added By Mukesh */
    static let myGrupEndPointPoint = productionBaseUrl + "api/GroupList/" /* Added By Ranjeet */
    static let createGroup = productionBaseUrl + "api/CreateGroup/" /* Added By Ranjeet */
    static let deleteGrupBtnEndPoint = productionBaseUrl + "api/deleteGroup/" /* Added By Ranjeet */
    static let getAllTestQuesUrl = productionBaseUrl + "api/TestQuestionList/" /* Added By Mukesh */
    static let answerTestUrl = productionBaseUrl + "api/AnswerTest" /* Added By Mukesh */
    static let writeAnswerAnswrAndSubmitUrl = productionBaseUrl + "api/QuestionAnswer/AnswerForQuestion" /* Added By Ranjeet */
    static let reviewTestUrl = productionBaseUrl + "api/ReviewTest/" /* Added By Mukesh */
    
    static let searchQuestionUrl = searchIndex
    //"https://ltw-searchfree.search.windows.net/indexes/ltw-searchstaging/docs?api-version=2017-11-11&search=" //(staging server)
    // static let searchQuestionUrl = "https://ltw-searchfree.search.windows.net/indexes/ltw-searchindex/docs?api-version=2017-11-11&search=" //(production server)
    
    
    static let notificationListUrl = productionBaseUrl + "api/users/Notification/" /* Added By Mukesh */
    static let testListUrl = productionBaseUrl + "api/SearchPublicORPrivateTest/" /* Added By Mukesh */
    static let searchPublicORPrivateTestUrl = productionBaseUrl + "api/SearchPublicORPrivateTest/" /* Added By Mukesh */
    
    //"https://ltw-searchfree.search.windows.net/indexes/ltw-searchstaging/docs?api-version=2017-11-11&facet=Sub_SubjectName,count:50&$filter=" //(staging server)
    //static let filterQuestionUrl = "https://ltw-searchfree.search.windows.net/indexes/ltw-searchindex/docs?api-version=2017-11-11&facet=Sub_SubjectName,count:50&$filter=" //(production server)
    
    static let gradalistUrl = productionBaseUrl + "api/getGradesCount"
    static let filterEndpoint =  productionBaseUrl + "api/Users/FilterByCategory/" /* Added By Mukesh */
    //Added by Manoj as on 24 Sep 2019
    static let discussionList =  productionBaseUrl + "api/discussionList/" /* Added By Manoj */
    static let createDiscussion =  productionBaseUrl + "api/CreateDiscussion"  /* Added By Manoj */
    static let getChatMessagebyIndex =  productionBaseUrl + "api/LoadDiscussionMessage/"  /* Added By Manoj */
    static let getMessagesList =  productionBaseUrl + "api/getDiscussionInfo/"  /* Added By Manoj */
    static let postMessage =  productionBaseUrl + "api/SendMessageToDiscussion/"  /* Added By Manoj */
    static let getGallery =  productionBaseUrl + "api/LoadDiscussionMedia/"  /* Added By Manoj */
    static let createClass =  productionBaseUrl + "api/class/CreateClass"  /* Added By Mukesh */
    static let myClassesEndPoint = productionBaseUrl + "api/class/MyClasses/"   /* Added By Mukesh */
    static let subcribedClassEndPoint = productionBaseUrl + "api/class/SubcribedClass/" /* Added By Mukesh */
    static let availableClassesEndPoint = productionBaseUrl + "api/class/AvailableClassesNew/" /* Added By Mukesh */
    static let subscribeClassEndPoint = productionBaseUrl + "api/class/SubscribeForClass/" /* Added By Mukesh */
    static let unsubscribeClassEndPoint = productionBaseUrl + "api/class/UnSubscribeForClass/" /* Added By Mukesh */
    static let quickBlockRegisterEndPoint = productionBaseUrl + "api/Users/RegisterQuickbloxID/" /* Added By Prasuna */
    
    static let getTestInfoEndPoint = productionBaseUrl + "api/TestInfo/" /* Added By Mukesh */
    static let editTestEndPoint = productionBaseUrl + "api/EditTest/" /* Added By Mukesh */
    static let getTestQuestionsEndPoint = productionBaseUrl + "api/EditTestQuestionList/" /* Added By Mukesh */
    static let editTestQuestionsEndPoint = productionBaseUrl + "api/EditTestQuestions" /* Added By Mukesh */
    static let deleteTestEndPoint = productionBaseUrl + "api/DeleteTest/" /* Added By Mukesh */
    static let editClassEndPoint = productionBaseUrl + "api/class/EditClass/" /* Added By Mukesh */
    static let getClassinfoEndPoint = productionBaseUrl + "api/class/GetClassinfo/" /* Added By Mukesh */
    static let deleteClassEndPoint = productionBaseUrl + "api/class/DeleteClass/" /* Added By Mukesh */
    
    
    /* Added  By Chandrashekhar - starts here */
    static let notificationUpdate = productionBaseUrl + "api/Profile/NotificationUpdate/"
    static let deleteGroupEndPoint = productionBaseUrl + "api/RemoveUserFromGroup/"
    static let groupInfo = productionBaseUrl + "api/GroupInfo/"
    static let myGroupsList = productionBaseUrl + "api/myGroupsList/"
    static let subscribedGroup = productionBaseUrl + "api/SubscribedGroup/"
    static let availableGroup = productionBaseUrl + "api/availableGroup/"
    static let exitPublicGroup =  productionBaseUrl + "api/ExitPublicGroup/"
    static let publicGroupJoin =  productionBaseUrl + "api//PublicGroupJoin/"
    static let fetchEmailID =  productionBaseUrl + "api/FetchEmailID/"
    static let editGroup =  productionBaseUrl + "api/EditGroup/"
    static let myTests = productionBaseUrl + "api/MyTests/"
    static let testTakenByYou = productionBaseUrl + "api/TestTakenByYou/"
    static let testAvailableForYou = productionBaseUrl + "api/TestAvailableForYou/"
    static let searchAndFollowUser = productionBaseUrl + "api/Users/searchAndFollowUser/"
    static let getLikedUserList = productionBaseUrl + "api/getLikedUserList/"
    static let followUserList = productionBaseUrl + "api/Users/FollowUserList/"
    static let followingUserList = productionBaseUrl + "api/Users/FollowingUserList/"
    static let unFollowFollowingUser = productionBaseUrl + "api/Users/UnFollowFollowingUser/"
    
    
    static let groupInfoWithListOfUser = productionBaseUrl + "api/GroupInfoWithListOfUser/"
    static let deleteNotification = productionBaseUrl + "api/users/DeleteNotification/"
    static let tutorReviewList = productionBaseUrl + "api/Profile/TutorReviewList/"
    static let classReviewList = productionBaseUrl + "api/Profile/ClassReviewList/"
    /* Added  By Chandrashekhar - ends here */
    
    static let ReviewTestScoreEndPoint = productionBaseUrl + "api/ReviewTestScore/" /* Added By Veeresh  on 26th Dec 2019 */
    static let TestAttendeesEndPoint = productionBaseUrl  + "api/TestAttendees/"   /* Added By Veeresh on 26th Dec 2019 */
    
    static let profileUserAskedQuestions = productionBaseUrl + "api/Profile/UserAskedQuestions/"  /* Added By Yasodha on 17th Dec 2020  */
    static let profileUserAnsweredQuestions = productionBaseUrl + "api/Profile/UserAnsweredQuestions/" /* Added By Yasodha on 17th Dec 2020 */
    
    
    static let TutorClassesEndPoint = productionBaseUrl + "api/Profile/TutorClasses/" /* Added By yasodha on 27th Jan 2020 */
    
    static let TutorTestsEndPoint = productionBaseUrl + "api/Profile/TutorTests/" /* Added By yasodha on 27th Jan 2020 */
    static let StudentClassesEndPoint = productionBaseUrl + "api/Profile/studentClasses/" /* Added By yasodha on 27th Jan 2020 */
    static let StudentTestTakenEndPoint = productionBaseUrl + "api/Profile/StudentTestTaken/" /* Added By yasodha on 27th Jan 2020 */
    
    static let studentJoinClassEndPoint = productionBaseUrl + "api/class/JoinClass/" /* Added by veeresh on 10/2/2020 */
    static let GetClassTutorInfoToRateEndPoint = productionBaseUrl + "api/class/GetClassTutorInfoToRate/" /* Added by veeresh on 12/2/2020 */
    static let RateTutorEndPoint = productionBaseUrl + "api/class/RateTutor"  /* added by veeresh on 12/2/2020*/
    static let classAttended = productionBaseUrl + "api/class/ClassAttended/" /* added by veeresh on 12/2/2020 */
    static let rateClass = productionBaseUrl + "api/class/RateClass"  /* added by veeresh on 14/2/2020 */
    static let requestedClassListEndPoint = productionBaseUrl + "api/class/RequestedClass/" /* added by dk on 4/3/2020*/
    static let declineRequestedClassEndpoint = productionBaseUrl + "api/class/DeclineRequestedClass" /* added by dk on 5/3/2020*/
    
    static let TutorExpiredClassesEndPoint = productionBaseUrl + "api/class/TutorExpiredClasses/" /* Added By yasodha on 14/4/2020 */
    static let classStartedEndpoint = productionBaseUrl + "api/class/StartClass/"  /* Added By Prasuna on 16th April 2020 */
    
    static let availableClassEndpoint = productionBaseUrl + "api/user/AvailableClasses/" /*Added By Dk on 22nd April 2020 */
    static let signupAvailableGroup = productionBaseUrl + "api/user/availableGroup/" /*Added By Chandra on 24th April 2020 */
    static let HasTakenTest = productionBaseUrl + "api/HasTakenTest/"
    static let classInfo = productionBaseUrl + "api/class/ClassSubsribersDetails/"
    
    static let baseURLString = productionBaseUrl + "api/Payment/AcceptPayment"
    static let encashURLString = productionBaseUrl + "api/Payment/encashPaymentToTutors"
    static let savedCardUrl = productionBaseUrl + "api/Payment/GetUserCards/"
    static let defaultCurrency = "usd"
    static let defaultDescription = "Purchase from Mukesh Pocs"
    static let CreateStripeConnectAccount = productionBaseUrl + "api/Payment/CreateStripeConnectAccount"
    static let ConvertPointsToCurrency = productionBaseUrl + "api/Payment/ConvertPointsToCurrency?Points="
}
