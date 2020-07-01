// HomeFilterListVC.swift
// LTW
// Created by Ranjeet Raushan on 27/09/19.
// Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView

@objc protocol FilterQuestion {
    @objc optional func filterQuestion(subjectIDs: String, subSubjectIDs:String, gradeNames: String)
    @objc optional func previousFilterData(scienceSubSubjecIDst: [String]?,technologySubSubjectIDs: [String]?,englishSubSubjectIDs: [String]?,mathsSubSubjectIDs: [String]?,gradeSubSubjectIDs: [String]?)
}
class HomeFilterListVC: UIViewController, NVActivityIndicatorViewable {
    @IBOutlet weak var filterTabelView: UITableView!
    @IBOutlet weak var resetBtn: UIButton! // this is select all BTN
    @IBOutlet weak var gradeBtn: UIButton!
    @IBOutlet weak var scienceBtn: UIButton!
    @IBOutlet weak var technologyBtn: UIButton!
    @IBOutlet weak var englishBtn: UIButton!
    @IBOutlet weak var mathsBtn: UIButton!
    
    //private var sujectID = Array(repeating: 0, count: 4)
    var scienceSubSubjecIDst: [String]?
    var technologySubSubjectIDs: [String]?
    var englishSubSubjectIDs: [String]?
    var mathsSubSubjectIDs: [String]?
    var gradeSubSubjectIDs: [String]?
    
    var scienceSubSubjectsList = [JSON]()
    var technologySubSubjectsList = [JSON]()
    var englishSubjectsList = [JSON]()
    var mathsSubSubjectsList = [JSON]()
    var gradesSubSubjectsList = [JSON]()
    
    //var isFilterApply: Bool = false
    
    var gradesArray = UserDefaults.standard.array(forKey: "grades") as! [String]
    unowned var abc:UIButton?
    
    var filterType: String!{
        didSet {
            if let filteType = filterType {
                print("filterType = \(filteType )")
                switch(filteType) {
                case FilterEnum.Science.rawValue:
                    if scienceSubSubjectsList.count > 0 {
                    }else {
                        scienceSubSubjectsList = getSubSubJectList(subjectID: 1)
                        if scienceSubSubjecIDst == nil {
                            self.scienceSubSubjecIDst = Array<String>(repeating: "",count: scienceSubSubjectsList.count)
                        }
                    }
                    
                    let scienceCount = (scienceSubSubjecIDst?.filter({!($0.isEmpty)}))?.count ?? 0
                    if scienceCount == scienceSubSubjectsList.count {
                        resetBtn.isSelected = true
                    }else {
                        resetBtn.isSelected = false
                    }
                    
                    filterTabelView.reloadData()
                    return
                case FilterEnum.Technology.rawValue:
                    if technologySubSubjectsList.count > 0 {
                    }else {
                        technologySubSubjectsList = getSubSubJectList(subjectID: 2)
                        if technologySubSubjectIDs == nil {
                            technologySubSubjectIDs = Array<String>(repeating: "",count: technologySubSubjectsList.count)
                        }
                    }
                    let techCount = (technologySubSubjectIDs?.filter({!($0.isEmpty)}))?.count ?? 0
                    if techCount == technologySubSubjectsList.count {
                        resetBtn.isSelected = true
                    }else {
                        resetBtn.isSelected = false
                    }
                    filterTabelView.reloadData()
                    return
                case FilterEnum.English.rawValue:
                    if englishSubjectsList.count > 0 {
                    }else {
                        englishSubjectsList = getSubSubJectList(subjectID: 3)
                        if englishSubSubjectIDs == nil {
                            englishSubSubjectIDs = Array<String>(repeating: "",count: englishSubjectsList.count)
                        }
                    }
                    
                    let englishCount = (englishSubSubjectIDs?.filter({!($0.isEmpty)}))?.count ?? 0
                    if englishCount == englishSubjectsList.count {
                        resetBtn.isSelected = true
                    }else {
                        resetBtn.isSelected = false
                    }
                    
                    
                    filterTabelView.reloadData()
                    return
                case FilterEnum.Maths.rawValue:
                    if mathsSubSubjectsList.count > 0 {
                    }else {
                        mathsSubSubjectsList = getSubSubJectList(subjectID: 4)
                        if mathsSubSubjectIDs == nil {
                            mathsSubSubjectIDs = Array<String>(repeating: "",count: mathsSubSubjectsList.count)
                        }
                    }
                    let mathCount = (mathsSubSubjectIDs?.filter({!($0.isEmpty)}))?.count ?? 0
                    if mathCount == mathsSubSubjectsList.count {
                        resetBtn.isSelected = true
                    }else {
                        resetBtn.isSelected = false
                    }
                    filterTabelView.reloadData()
                    return
                case FilterEnum.Grade.rawValue:
                    if gradesSubSubjectsList.count > 0 {
                        let gradeCount = (gradeSubSubjectIDs?.filter({!($0.isEmpty)}))?.count ?? 0
                        if gradeCount == gradesSubSubjectsList.count {
                            resetBtn.isSelected = true
                        }else {
                            resetBtn.isSelected = false
                        }
                    }else {
                    }
                    filterTabelView.reloadData()
                    return
                default :
                    return
                }
            }
        }
    }
    weak var delegate: FilterQuestion?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*  Added By Ranjeet on 31st March 2020 - starts here */
        /* remove unwanted cells - starts here */
        self.filterTabelView.tableFooterView = UIView()
        /* remove unwanted cells - ends here */
         /*  Added By Ranjeet on 31st March 2020 - starts here */
       
        navigationItem.title = "Filter"
        self.filterType = FilterEnum.Grade.rawValue
        gradesSubSubjectsList = getGradeList()
        if gradeSubSubjectIDs == nil {
            gradeSubSubjectIDs = Array<String>(repeating: "",count: gradesSubSubjectsList.count)
            for (index, grade) in gradesSubSubjectsList.enumerated() {
                if gradesArray.contains(grade["Grades"].stringValue.trim()) {
                    gradeSubSubjectIDs?[index] = grade["Grades"].stringValue
                }
            }
        }
        if gradesSubSubjectsList.count > 0 {
            let gradeCount = (gradeSubSubjectIDs?.filter({!($0.isEmpty)}))?.count ?? 0
            if gradeCount == gradesSubSubjectsList.count {
                resetBtn.isSelected = true
            }else {
                resetBtn.isSelected = false
            }
        }
        gradeBtn.isSelected = true // highlight grade button
        // Right Bar Button Code Starts Here
        let applyBarBtn = UIBarButtonItem(title: "Apply", style: .done, target: self, action: #selector(onFilterBtnClick))
        self.navigationItem.rightBarButtonItem = applyBarBtn
        
        let backBarBtn = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(onBackBtnClick))
        self.navigationItem.leftBarButtonItem = backBarBtn
        
        // navigationController?.view.backgroundColor = UIColor.init(hex:"2DA9EC")
        navigationController?.view.backgroundColor = UIColor.white
        
    }
    @objc func onBackBtnClick(){
        print("onBackBtnClick")
        navigationController?.popViewController(animated: false)
    }
    /// Right Bar Button Function Code Starts Here / this is select all or deselect all check box click
    @objc func onFilterBtnClick(){
        print("Sign In Right Bar Button Clicked")
       // isFilterApply = true
        var subjectID = "",subSubJectIDs = "", grades = ""
        let scienceCount = (scienceSubSubjecIDst?.filter({!($0.isEmpty)}))?.count ?? 0
        if scienceCount > 0 {
            subjectID = subjectID + "1,"
        }
        let technologyCount = (technologySubSubjectIDs?.filter({!($0.isEmpty)}))?.count ?? 0
        if technologyCount > 0 {
            subjectID = subjectID + "2,"
        }
        let EnglishCount = (englishSubSubjectIDs?.filter({!($0.isEmpty)}))?.count ?? 0
        if EnglishCount > 0 {
            subjectID = subjectID + "3,"
        }
        let mathsCount = (mathsSubSubjectIDs?.filter({!($0.isEmpty)}))?.count ?? 0
        if mathsCount > 0 {
            subjectID = subjectID + "4,"
        }
        
        let gradeCount = (gradeSubSubjectIDs?.filter({!($0.isEmpty)}))?.count ?? 0
        // if gradeCount > 0 {
        // subjectID = subjectID + "5"
        // }
        //print("subjectID = \(subjectID)")
        if scienceSubSubjecIDst != nil {
            for (index,element) in (scienceSubSubjecIDst?.enumerated())! where element != "" {
                if let id = scienceSubSubjecIDst?[index] {
                    subSubJectIDs = subSubJectIDs + "\(id),"
                }
            }
        }
        if technologySubSubjectIDs != nil {
            for (index,element) in (technologySubSubjectIDs?.enumerated())! where element != "" {
                if let id = technologySubSubjectIDs?[index] {
                    subSubJectIDs = subSubJectIDs + "\(id),"
                }
            }
        }
        if englishSubSubjectIDs != nil {
            for (index,element) in (englishSubSubjectIDs?.enumerated())! where element != "" {
                if let id = englishSubSubjectIDs?[index] {
                    subSubJectIDs = subSubJectIDs + "\(id),"
                }
                
            }
        }
        if mathsSubSubjectIDs != nil {
            for (index,element) in (mathsSubSubjectIDs?.enumerated())! where element != "" {
                if let id = mathsSubSubjectIDs?[index] {
                    subSubJectIDs = subSubJectIDs + "\(id),"
                }
            }
        }
        if gradeSubSubjectIDs != nil {
            for (index,element) in (gradeSubSubjectIDs?.enumerated())! where element != "" {
                let grade = gradeSubSubjectIDs?[index]
                grades = grades + "\(grade!),"
            }
        }
        if subjectID.count > 0 {
            subjectID.removeLast()
        }
        if subSubJectIDs.count > 0 {
            subSubJectIDs.removeLast()
        }
        if grades.count > 0 {
            grades.removeLast()
        }
        print("subjectID = \(subjectID)")
        print("subSubJectIDs = \(subSubJectIDs)")
        print("grades = \(grades)")
        // let queryString = "&SubjectID=\(subjectID)&SubSubjectID=\(subSubJectIDs)&Grade=\(grades)"
        //let filterEndPoint = "\(Endpoints.filterEndpoint)\(UserDefaults.standard.string(forKey: "userID")!)\(queryString)"
        delegate?.filterQuestion?(subjectIDs: subjectID, subSubjectIDs: subSubJectIDs, gradeNames: grades)
        delegate?.previousFilterData?(scienceSubSubjecIDst: scienceSubSubjecIDst, technologySubSubjectIDs: technologySubSubjectIDs, englishSubSubjectIDs: englishSubSubjectIDs, mathsSubSubjectIDs: mathsSubSubjectIDs, gradeSubSubjectIDs: gradeSubSubjectIDs)
        // delegate?.setFilterUI?(scienceCount: scienceCount, technologyCount: technologyCount, EnglishCount: EnglishCount, mathsCount: mathsCount, gradeCount: gradeCount)
        
        navigationController?.popViewController(animated: false)
    }
    
    private func getSubSubJectList(subjectID: Int) -> [JSON] {
        let stringJSON = UserDefaults.standard.string(forKey: "subSubjectList")!
        let json = JSON.init(parseJSON: stringJSON)
        let SubSubjectJSONArray = json.arrayValue
        let selectedSubSubjectJSON = SubSubjectJSONArray.filter { json -> Bool in
            return json["SubjectID"].intValue == subjectID
        }
        return selectedSubSubjectJSON
    }
    private func getGradeList() -> [JSON] {
        let stringJSON = UserDefaults.standard.string(forKey: "gradeList")!
        let json = JSON.init(parseJSON: stringJSON)
        // let SubSubjectJSONArray = json.arrayValue
        // let selectedSubSubjectJSON = SubSubjectJSONArray.filter { json -> Bool in
        // return json["SubjectID"].intValue == subjectID
        // }
        return json.arrayValue
    }
    
    
    
    @IBAction func onScienceBtnClick(_ sender: UIButton) {
        self.filterType = FilterEnum.Science.rawValue
        gradeBtn.isSelected = false
        scienceBtn.isSelected = false
        technologyBtn.isSelected = false
        englishBtn.isSelected = false
        mathsBtn.isSelected = false
        sender.isSelected = true
        
    }
    
    @IBAction func onTechnologyBtnClick(_ sender: UIButton) {
        self.filterType = FilterEnum.Technology.rawValue
        gradeBtn.isSelected = false
        scienceBtn.isSelected = false
        technologyBtn.isSelected = false
        englishBtn.isSelected = false
        mathsBtn.isSelected = false
        sender.isSelected = true
    }
    @IBAction func onEnglishBtnClick(_ sender: UIButton) {
        self.filterType = FilterEnum.English.rawValue
        gradeBtn.isSelected = false
        scienceBtn.isSelected = false
        technologyBtn.isSelected = false
        englishBtn.isSelected = false
        mathsBtn.isSelected = false
        sender.isSelected = true
    }
    
    @IBAction func onMathsBtnClick(_ sender: UIButton) {
        self.filterType = FilterEnum.Maths.rawValue
        gradeBtn.isSelected = false
        scienceBtn.isSelected = false
        technologyBtn.isSelected = false
        englishBtn.isSelected = false
        mathsBtn.isSelected = false
        sender.isSelected = true
    }
    
    @IBAction func onGradesBtnClick(_ sender: UIButton) {
        self.filterType = FilterEnum.Grade.rawValue
        gradeBtn.isSelected = false
        scienceBtn.isSelected = false
        technologyBtn.isSelected = false
        englishBtn.isSelected = false
        mathsBtn.isSelected = false
        sender.isSelected = true
    }
    @IBAction func onClick(_ sender: UIButton) {
        print("New MK Button Clicked")
        
    }
    
    @IBAction func onResetBtnClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        switch(filterType!) {
        case FilterEnum.Science.rawValue:
            if sender.isSelected {
                for (index,_) in scienceSubSubjectsList.enumerated() {
                    scienceSubSubjecIDst?[index] = scienceSubSubjectsList[index]["Sub_SubjectID"].stringValue
                }
            } else {
                scienceSubSubjecIDst = Array<String>(repeating: "",count: scienceSubSubjectsList.count)
            }
            
        case FilterEnum.Technology.rawValue:
            if sender.isSelected {
                for (index,_) in technologySubSubjectsList.enumerated() {
                    technologySubSubjectIDs?[index] = technologySubSubjectsList[index]["Sub_SubjectID"].stringValue
                }
                
            }else {
                technologySubSubjectIDs = Array<String>(repeating: "",count: technologySubSubjectsList.count)
            }
            
        case FilterEnum.English.rawValue:
            if sender.isSelected {
                for (index,_) in englishSubjectsList.enumerated() {
                    englishSubSubjectIDs?[index] = englishSubjectsList[index]["Sub_SubjectID"].stringValue
                }
            }else {
                englishSubSubjectIDs = Array<String>(repeating: "",count: englishSubjectsList.count)
            }
        case FilterEnum.Maths.rawValue:
            if sender.isSelected {
                for (index,_) in mathsSubSubjectsList.enumerated() {
                    mathsSubSubjectIDs?[index] = mathsSubSubjectsList[index]["Sub_SubjectID"].stringValue
                }
            }else {
                mathsSubSubjectIDs = Array<String>(repeating: "",count: mathsSubSubjectsList.count)
            }
        case FilterEnum.Grade.rawValue:
            if sender.isSelected {
                for (index,_) in gradesSubSubjectsList.enumerated() {
                    gradeSubSubjectIDs?[index] = gradesSubSubjectsList[index]["Grades"].stringValue
                }
                
            }else {
                gradeSubSubjectIDs = Array<String>(repeating: "",count: gradesSubSubjectsList.count)
            }
            
        default : break
        }
        filterTabelView.reloadData()
    }
    
}
extension HomeFilterListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _filterType = filterType {
            switch(_filterType) {
            case FilterEnum.Science.rawValue:
                return scienceSubSubjectsList.count
            case FilterEnum.Technology.rawValue:
                return technologySubSubjectsList.count
            case FilterEnum.English.rawValue:
                return englishSubjectsList.count
            case FilterEnum.Maths.rawValue:
                return mathsSubSubjectsList.count
            case FilterEnum.Grade.rawValue:
                return gradesSubSubjectsList.count
            default :
                return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as! homeFilterCell
        let index = indexPath.row
        switch(filterType!) {
        case FilterEnum.Science.rawValue:
            let dict = scienceSubSubjectsList[indexPath.row]
            cell.filterLabel.text = dict["SubjectName"].stringValue
            // cell.countLbl.text = "(\(dict["count"].stringValue))"
            
            
            if !(scienceSubSubjecIDst?[index].isEmpty)! {
                cell.chkBoxBtn.isSelected = true
            }else {
                cell.chkBoxBtn.isSelected = false
            }
            
            
        case FilterEnum.Technology.rawValue:
            let dict = technologySubSubjectsList[indexPath.row]
            cell.filterLabel.text = dict["SubjectName"].stringValue
            // cell.countLbl.text = "(\(dict["count"].stringValue))"
            if !(technologySubSubjectIDs?[index].isEmpty)!{
                cell.chkBoxBtn.isSelected = true
            }else {
                cell.chkBoxBtn.isSelected = false
            }
        case FilterEnum.English.rawValue:
            let dict = englishSubjectsList[indexPath.row]
            // cell.chkBoxBtn.tag = indexPath.row
            // cell.chkBoxBtn.addTarget(self, action: #selector(onCheckBoxBtnClick(sender:)), for: .touchUpInside)
            cell.filterLabel.text = dict["SubjectName"].stringValue
            // cell.countLbl.text = "(\(dict["count"].stringValue))"
            if !(englishSubSubjectIDs?[index].isEmpty)! {
                cell.chkBoxBtn.isSelected = true
            }else {
                cell.chkBoxBtn.isSelected = false
            }
            
        case FilterEnum.Maths.rawValue:
            let dict = mathsSubSubjectsList[indexPath.row]
            // cell.chkBoxBtn.tag = indexPath.row
            // cell.chkBoxBtn.addTarget(self, action: #selector(onCheckBoxBtnClick(sender:)), for: .touchUpInside)
            cell.filterLabel.text = dict["SubjectName"].stringValue
            //cell.countLbl.text = "(\(dict["count"].stringValue))"
            if !(mathsSubSubjectIDs?[index].isEmpty)! {
                cell.chkBoxBtn.isSelected = true
            }else {
                cell.chkBoxBtn.isSelected = false
            }
        case FilterEnum.Grade.rawValue:
            let dict = gradesSubSubjectsList[indexPath.row]
            // cell.chkBoxBtn.tag = indexPath.row
            // cell.chkBoxBtn.addTarget(self, action: #selector(onCheckBoxBtnClick(sender:)), for: .touchUpInside)
            cell.filterLabel.text = dict["Grades"].stringValue//counts//ids
            // cell.countLbl.text = "(\(dict["counts"].stringValue))"
            if !(gradeSubSubjectIDs?[index].isEmpty)! {
                cell.chkBoxBtn.isSelected = true
            }else {
                cell.chkBoxBtn.isSelected = false
            }
        default : break
        }
        return cell
    }
}

extension HomeFilterListVC:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let currentCell = tableView.cellForRow(at: indexPath) as! homeFilterCell
        currentCell.chkBoxBtn.isSelected = !currentCell.chkBoxBtn.isSelected
        switch(filterType!) {
        case FilterEnum.Science.rawValue:
            if currentCell.chkBoxBtn.isSelected {
                // add 1
                scienceSubSubjecIDst?[index] = scienceSubSubjectsList[indexPath.row]["Sub_SubjectID"].stringValue
            }else {
                // add 0
                scienceSubSubjecIDst?[index] = ""
            }
            let scienceCount = (scienceSubSubjecIDst?.filter({!($0.isEmpty)}))?.count ?? 0
            if scienceCount == scienceSubSubjectsList.count {
                resetBtn.isSelected = true
            }else {
                resetBtn.isSelected = false
            }
            
            
        case FilterEnum.Technology.rawValue:
            if currentCell.chkBoxBtn.isSelected {
                // add 1
                technologySubSubjectIDs?[index] = technologySubSubjectsList[indexPath.row]["Sub_SubjectID"].stringValue
            }else {
                // add 0
                technologySubSubjectIDs?[index] = ""
            }
            let techCount = (technologySubSubjectIDs?.filter({!($0.isEmpty)}))?.count ?? 0
            if techCount == technologySubSubjectsList.count {
                resetBtn.isSelected = true
            }else {
                resetBtn.isSelected = false
            }
        case FilterEnum.English.rawValue:
            if currentCell.chkBoxBtn.isSelected {
                // add 1
                
                englishSubSubjectIDs?[index] = englishSubjectsList[indexPath.row]["Sub_SubjectID"].stringValue
            }else {
                // add 0
                englishSubSubjectIDs?[index] = ""
            }
            let englishCount = (englishSubSubjectIDs?.filter({!($0.isEmpty)}))?.count ?? 0
            if englishCount == englishSubjectsList.count {
                resetBtn.isSelected = true
            }else {
                resetBtn.isSelected = false
            }
            
        case FilterEnum.Maths.rawValue:
            if currentCell.chkBoxBtn.isSelected {
                // add 1
                mathsSubSubjectIDs?[index] = mathsSubSubjectsList[indexPath.row]["Sub_SubjectID"].stringValue
            }else {
                // add 0
                mathsSubSubjectIDs?[index] = ""
            }
            let mathCount = (mathsSubSubjectIDs?.filter({!($0.isEmpty)}))?.count ?? 0
            if mathCount == mathsSubSubjectsList.count {
                resetBtn.isSelected = true
            }else {
                resetBtn.isSelected = false
            }
        case FilterEnum.Grade.rawValue:
            if currentCell.chkBoxBtn.isSelected {
                // add 1
                gradeSubSubjectIDs?[index] = gradesSubSubjectsList[indexPath.row]["Grades"].stringValue
            }else {
                // add 0
                gradeSubSubjectIDs?[index] = ""
            }
            let gradeCount = (gradeSubSubjectIDs?.filter({!($0.isEmpty)}))?.count ?? 0
            if gradeCount == gradesSubSubjectsList.count {
                resetBtn.isSelected = true
            }else {
                resetBtn.isSelected = false
            }
        default : break
        }
    }
}
