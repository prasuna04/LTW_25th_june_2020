//  TeachersListVC.swift
//  LTW
//  Created by Ranjeet Raushan on 17/02/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView

enum PersonTypeForTeachersListVC : Int {
    case Student = 1 // why i am using 1 here because another two person type will automatically take 2 & 3 and if i  will not put 1 here  it will consider 0 automatically and another two person type will become 1 and 2 and we will get wrong information.
    case Parent
    case Teacher
}

class TeachersListVC: UIViewController,UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    var teachersListArray:[JSON]!
    var teacherListUserID: String!
    
    var gradeV = Int()
    var boardV = Int()
    var subV = Int()
    
    @IBOutlet weak var teachersListTblVw: UITableView!
    @IBOutlet weak var navigationSearchBar: UIView!
    @IBOutlet weak var textFieldSearch: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(teachersListArray)
        textFieldSearch.layer.cornerRadius = 20
        textFieldSearch.layer.borderWidth = 1.5
        textFieldSearch.layer.borderColor = UIColor.white.cgColor
        textFieldSearch.leftViewMode = UITextField.ViewMode.always
        let views = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        views.backgroundColor = UIColor.clear
        let imageView1 = UIImageView(frame: CGRect(x: 10, y:10, width: 20, height: 20))
        let image = UIImage(named: "topsearch")
        imageView1.image = image
        views.addSubview(imageView1)
        textFieldSearch.leftView = views
        textFieldSearch.tintColor = .white
        textFieldSearch.attributedPlaceholder =
            NSAttributedString(string: " Search By Teacher Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]) /* Added By Ranjeet on 11th March 2020 */
        self.teachersListTblVw.separatorStyle = .none
        teachersListTblVw.delegate = self
        teachersListTblVw.dataSource = self
        self.teachersListTblVw.reloadData()
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
        navigationItem.title = "Teachers List"
    }
    @IBAction func OnSearchClickBtn(sender:UIButton) {
        hitServerForSearchTeacher()
    }
    
    // Request btn
    @objc func requestBtnSelected(sender: UIButton){
        let dict = teachersListArray[sender.tag]
        let fname = dict["FirstName"].stringValue
        let lname = dict["LastName"].stringValue
        let schol = dict["School"].stringValue
        let personType = dict["PersonType"].stringValue
        
        let requestforclassforsegment = storyboard?.instantiateViewController(withIdentifier: "requestclasssegmenthandler") as! RequestClassSegmentHandlerVC
        teacherListUserID = dict["UserID"].stringValue
        requestforclassforsegment.teacherListUserID = self.teacherListUserID
        requestforclassforsegment.fname = fname
        requestforclassforsegment.lname = lname
        requestforclassforsegment.schol = schol
        requestforclassforsegment.personType = personType
        navigationController?.pushViewController(requestforclassforsegment, animated: true)
    }
    
    @objc func cellTappedMethod(_ sender:AnyObject){
        let index = teachersListArray[sender.view.tag]
        let UserID = index["UserID"].stringValue
        let vc = storyboard?.instantiateViewController(withIdentifier: "personalprofile") as! PersonalProfileVC
        vc.userID = UserID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func ratingTapped(_ sender:AnyObject){
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
             let containerView = storyBoard.instantiateViewController(withIdentifier: "RatingAndReviewContainerViewController") as! RatingAndReviewContainerViewController
             let index = teachersListArray[sender.view.tag]
             let UserID = index["UserID"].stringValue
             containerView.profileUserId = UserID
            self.navigationController?.pushViewController(containerView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int {
        return teachersListArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TeachersListCell
        var teacherList: JSON
         cell.hightConstraintetFortheBadges.constant = 0 // add by chandra for hide the badges
        if teachersListArray.count > 0{
            teacherList = teachersListArray[indexPath.row]
            cell.tchrFrstNm.text = teacherList["FirstName"].stringValue
            cell.tchrLastNm.text = teacherList["LastName"].stringValue
            cell.schoolLbl.text = teacherList["School"].stringValue
           // cell.rating.rating = Double(teacherList["Rating"].intValue)/* Commented By Veeresh on 27th March 2020 */
            cell.rating.rating = teacherList["Rating"].intValue == 0 ? 2.5 :  Double(teacherList["Rating"].intValue ) /* Added By Veeresh on 27th March 2020 */
            cell.rating.isUserInteractionEnabled = false
            let typeOfPersonForTeachersListVC = PersonTypeForTeachersListVC.init(rawValue: teacherList["PersonType"].intValue)
            if typeOfPersonForTeachersListVC != nil{
                cell.prsnTypLabel.text = "\(String(describing: typeOfPersonForTeachersListVC!))"
            }
            let stringUrlForTeachersList = teacherList["ProfileURL"].stringValue
            let thumbnailForTeachersList = stringUrlForTeachersList.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
            cell.tchrImg?.sd_setImage(with: URL.init(string:thumbnailForTeachersList),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
            // request Btn
            cell.requestBtn.tag = indexPath.row
            cell.requestBtn.addTarget(self, action: #selector(requestBtnSelected(sender:)), for: .touchUpInside)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTappedMethod(_:)))
            cell.tchrImg.isUserInteractionEnabled = true
            cell.tchrImg.tag = indexPath.row
            cell.tchrImg.addGestureRecognizer(tapGestureRecognizer)
            let tapRatigGasture = UITapGestureRecognizer(target: self, action: #selector(ratingTapped))
            cell.rating.isUserInteractionEnabled = true
            cell.rating.tag = indexPath.row
            cell.rating.addGestureRecognizer(tapRatigGasture)
        }
        return cell
    }
    private func hitServerForSearchTeacher() {
        textFieldSearch.resignFirstResponder()
        textFieldSearch.attributedPlaceholder =
            NSAttributedString(string: " Search By Teacher Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        if currentReachabilityStatus != .notReachable {
            let endPoint = "\(Endpoints.searchTeacherEndPoint)?board=\(boardV)&grade=\(gradeV)&subjects=\(subV)&name=\(textFieldSearch.text!.trim())" /* Added  By Ranjeet on 11th March 2020 */
            teachersListArray.removeAll()
            teachersListTblVw.reloadData()
            hitServerForSearchTeacher(params: [:], endPoint: endPoint ,  action: "searchTeacher", httpMethod: .get)
        } else {
            showMessage(bodyText: "No internet",buttonTitle: "Retry",theme: .error,buttonTapHandler: {(done) in
            })
        }
        
    }
}

extension TeachersListVC {
    //Search Teacher Related
    private func hitServerForSearchTeacher(params: [String:Any],endPoint: String, action: String,httpMethod: HTTPMethod) {
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
                    let data  = json["ControlsData"]["lsv_teachers"].arrayValue
                    _self.teachersListArray = data
                    _self.teachersListTblVw.reloadData()
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
                break
            }
        }
    }
}

