//  SearchTeacherVC.swift
//  LTW
//  Created by Ranjeet Raushan on 17/02/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import UIKit
import NVActivityIndicatorView
import SwiftyJSON
import Alamofire

/* Added By Deepak on 26th Feb 2020 - starts here */
struct PassableData {  /* Added by DK on 26th feb 2020 */
    static var gradsToNextVC : String!
    static var boardsTonextVC : String!
    static var subjectsToNextVC : String!
    
} //end.
  /* Added By Deepak on 26th Feb 2020 - ends here */

class SearchTeacherVC: UIViewController, NVActivityIndicatorViewable  {
    @IBOutlet weak var gradesBtn: UIButton!
    @IBOutlet weak var boardsBtn: UIButton!
    @IBOutlet weak var subjectBtn: UIButton!
    
    @IBOutlet weak var searchTeacherBtn: UIButton!
    {
        didSet{
            searchTeacherBtn.layer.cornerRadius = searchTeacherBtn.frame.height / 12
        }
    }
    
    var gradeV = Int()
    var boardV = Int()
    var subV = Int()
    var graDs = ["1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th","11th","12th","UnderGraduates","Graduates"]
    var boarDss = ["CBSE","ICSE","IGCSE","IB","Others","US Common Core"]
    var suBjecTs = ["Science", "Technology", "English", "Maths"]
    
    // Screen width.
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navigationController = navigationController else { return }
        navigationController.view.backgroundColor = UIColor.init(hex:"2DA9EC")
        if (self.navigationController?.navigationBar) != nil {
            navigationController.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        }
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Search Teacher"
    }
    
    @IBAction func onGradesBtnClk(_ sender: UIButton) {
        sender.tag = 1
        let controller = ArrayChoiceTableViewControllerForRequestClass(graDs){[unowned self ](selectedGrade) in
            self.gradesBtn.setTitle(String(describing: selectedGrade), for: .normal)
            self.gradesBtn.setTitleColor(.darkGray, for: .normal) /* Added By DK on 28th March, 2020 */
            /*  Updated By Ranjeet on 26th March 2020  - starts here  */
            if #available(iOS 13.0, *) {
                self.gradesBtn.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
            }
             /*  Updated By Ranjeet on 26th March 2020 - ends here   */
             PassableData.gradsToNextVC = selectedGrade  /* Added By Deepak on 26th Jan 2020 */
        }
        controller.preferredContentSize =  CGSize(width: self.screenWidth - 20, height: self.screenHeight / 3)
        showPopup(controller, sourceView: sender)
    }
    
    @IBAction func onBoardsBtnClk(_ sender: UIButton) {
        sender.tag = 2
        let controller = ArrayChoiceTableViewControllerForRequestClass(boarDss){[unowned self ](selectedBoard) in
            self.boardsBtn.setTitle(String(describing: selectedBoard), for: .normal)
             self.boardsBtn.setTitleColor(.darkGray, for: .normal) /* Added By DK on 28th March, 2020 */
              /*  Updated By Ranjeet on 26th March 2020  - starts here  */
            if #available(iOS 13.0, *) {
                 self.boardsBtn.setTitleColor(UIColor.label, for: .normal)
                      } else {
                          // Fallback on earlier versions
                      }
             /*  Updated By Ranjeet on 26th March 2020  - ends here  */
            PassableData.boardsTonextVC = selectedBoard  /* Added By Deepak on 26th Jan 2020 */
        }
        controller.preferredContentSize =  CGSize(width: self.screenWidth - 20,  height: 200)
        showPopup(controller, sourceView: sender)
    }
    
    @IBAction func onSubjectsBtnClick(_ sender: UIButton) {
        sender.tag = 3
        let controller = ArrayChoiceTableViewControllerForRequestClass(suBjecTs){[unowned self] (selectedSubject) in
            self.subjectBtn.setTitle(String(describing: selectedSubject ), for: .normal)
             self.subjectBtn.setTitleColor(.darkGray, for: .normal) /* Added By DK on 28th March, 2020 */
              /*  Updated By Ranjeet on 26th March 2020  - starts here  */
            if #available(iOS 13, *){
                self.subjectBtn.setTitleColor(UIColor.label, for: .normal)
            }
            else {
                // Fallback on earlier versions
            }
              /*  Updated By Ranjeet on 26th March 2020  - starts here  */
            
            PassableData.subjectsToNextVC = selectedSubject /* Added By Deepak on 26th Jan 2020 */
        }
        controller.preferredContentSize = CGSize(width: self.screenWidth - 20, height: 200)
        showPopup(controller, sourceView: sender)
        
    }
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    
    @IBAction func onSearchTeacherBtnClk(_ sender: UIButton) {
        validateData()
    }
    
   private func validateData()
    {
     
            guard let gradeSelection = gradesBtn.title(for: .normal), gradeSelection != "Offering for Grade" else{
                      showMessage(bodyText: "Please select Grades",theme: .warning)
                      return
                  }


        
       guard let boardSelection = boardsBtn.title(for: .normal), boardSelection != "Board" else{
         showMessage(bodyText: "Please select Board",theme: .warning)
         return
      }


        guard let subjectSelection = subjectBtn.title(for: .normal), subjectSelection != "Subjects" else{
                             showMessage(bodyText: "Please select Subjects",theme: .warning)
                             return
                         }
        



        if currentReachabilityStatus != .notReachable {
            let endPoint = "\(Endpoints.searchTeacherEndPoint)?board=\(boarDss.firstIndex(where: {$0 == boardsBtn.title(for: .normal)!})! + 1)&grade=\(graDs.firstIndex(where: {$0 == gradesBtn.title(for: .normal)!})! + 1)&subjects=\(suBjecTs.firstIndex(where: {$0 == subjectBtn.title(for: .normal)!})! + 1)&name="


            hitServerForSearchTutor(params: [:], endPoint: endPoint ,  action: "searchTeacher", httpMethod: .get)
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
            })
        }
    }
}

extension SearchTeacherVC {
    //Search Teacher Related
    private func hitServerForSearchTutor(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: endPoint, using: httpMethod, dueToAction: action){[weak self] result in
            guard let _self = self else {
                return
            }
            _self.stopAnimating()
            switch result {
            case let .success(json,_):
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }
                else {
                    
                    let teacherData = json["ControlsData"]["lsv_teachers"].arrayValue
                    print(teacherData)
                    let teachersList = _self.storyboard?.instantiateViewController(withIdentifier: "teacherslist") as! TeachersListVC
                    teachersList.teachersListArray  = teacherData
                    teachersList.boardV = _self.boarDss.firstIndex(where: {$0 == _self.boardsBtn.title(for: .normal)!})! + 1
                    teachersList.gradeV = _self.graDs.firstIndex(where: {$0 == _self.gradesBtn.title(for: .normal)!})! + 1
                    teachersList.subV = _self.suBjecTs.firstIndex(where: {$0 == _self.subjectBtn.title(for: .normal)!})! + 1
                    _self.navigationController?.pushViewController(teachersList, animated: true)
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
}

