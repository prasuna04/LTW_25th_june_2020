//
//  AvailableClassesPostSignupVC.swift
//  LTW
//
//  Created by vaayoo on 22/04/20.
//  Copyright © 2020 vaayoo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class AvailableClassesPostSignupVC: UIViewController, UITableViewDelegate, UITableViewDataSource,NVActivityIndicatorViewable {
    
    var availableClassEndPoint : String!
    typealias DownloadComplete = () -> ()
    let loggedInUserID = UserDefaults.standard.string(forKey: "userID")
    var cellDatas = [AvailableClassesPostSignupData]()
//    var subscribedClassCount : Int! = 0
    //    var subscribedClassData = [JSON]()
    
    @IBOutlet weak var availableClassTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton! {
        didSet{
            nextButton.backgroundColor = .clear
            nextButton.setTitleColor(.init(hex: "FFAE00"), for: .normal)
            nextButton.layer.cornerRadius = (nextButton.bounds.height - 10) / 2
            nextButton.layer.borderWidth = 1
            nextButton.layer.borderColor = UIColor.init(hex: "FFAE00").cgColor
            nextButton.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let subcribedClassEndPoint = Endpoints.subcribedClassEndPoint + loggedInUserID! + "?searchText="
        //        downloadingSubscribedClassData(params: [:], endPoint: subcribedClassEndPoint, action: "subscribedData", httpMethod: .get)
        availableClassEndPoint = Endpoints.availableClassEndpoint + loggedInUserID!
        hitServer(globalListEndPoint: availableClassEndPoint)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    private func hitServer(globalListEndPoint : String) {
        var shim = UIImageView()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: shim = UIImageView(image: UIImage(named: "Asset 65")!) ; shim.contentMode = .topLeft
        case .pad: shim = UIImageView(image: UIImage(named: "Asset 65")!) ; shim.contentMode = .scaleToFill
        case .unspecified: shim = UIImageView(image: UIImage(named: "my-group-mobile")!)
        case .tv: shim = UIImageView(image: UIImage(named: "my-group-ipad")!) ; shim.contentMode = .topLeft
        case .carPlay: shim = UIImageView(image: UIImage(named: "my-group-mobile")!)
        }//scaleAspectFill
        availableClassTableView.backgroundView = shim  /* added by veeresh on 26/2/2020 */
        shim.startShimmering()
        downloadAvailableClassInformation(url: globalListEndPoint){
            self.availableClassTableView.backgroundView = UIView()
            shim.stopShimmering()
            shim.removeFromSuperview()
        }
    }
    
    //Downloading Data starts here
    func downloadAvailableClassInformation(url :  String, completed : @escaping DownloadComplete) {
        print("Deepak Kumar url ", url)
        //            print("Deepak Kumar searchURl " , searchUrl!)
        Alamofire.request(url).responseJSON {
            response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject>{
                if let controlsData = dict["ControlsData"] as? Dictionary<String, AnyObject> {
                    if let lsvGrp = controlsData["ClassList"] as? [Dictionary<String, Any>]{
                        print(lsvGrp)
                        if lsvGrp.count != 0 {
                            for obj in lsvGrp {
                                let cellData = AvailableClassesPostSignupData(availableClassesPostSignUpDict : obj as Dictionary<String, AnyObject>)
                                self.cellDatas.append(cellData)
                                print("appendData>>\(self.cellDatas)")
                            }
                        }
                        else {
                            self.callNextVC()
                        }
                        self.availableClassTableView.reloadData()
                    }
                }
            }
            completed()
        }
    } //downloading data from server ends here
    
    
    
    
    //Table related code starts here.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "availableClassesPostSignupCell", for: indexPath) as! AvailableClassesPostSignupCell
        let data = cellDatas[indexPath.row]
        cell.updateCell(availableClassesPostSignupData: data)
        cell.subscribeButton.tag = indexPath.row
        cell.subscribeButton.addTarget(self, action: #selector(onSubcriptionBtnClicked), for: .touchUpInside)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(uiViewWithImageTapped(_:)))
        cell.profileImage.tag = indexPath.row
        tap1.numberOfTapsRequired = 1
        cell.profileImage.isUserInteractionEnabled = true
        cell.profileImage.addGestureRecognizer(tap1)
        return cell
    }
    //table related code ends here.
    //code for image tapping starts here.
    @objc func uiViewWithImageTapped(_ sender: AnyObject) {
        let personalprofile = storyboard?.instantiateViewController(withIdentifier: "personalprofile") as! PersonalProfileVC
        personalprofile.userID = cellDatas[sender.view.tag].teacherUserID
        navigationController?.pushViewController(personalprofile, animated: false) // comment this line when animation not required /
    }
    //Code for Subscribing class starts here.!
    @objc func onSubcriptionBtnClicked(sender: UIButton) {
        print("onSubcriptionBtnClicked classID = \(sender.tag)")
        print("Subscribe ")
        let clsId = cellDatas[sender.tag].classID
        if NetworkReachabilityManager()?.isReachable ?? false {
            //Internet connected,Go ahead
           
//            guard let quickBloxID = UserDefaults.standard.string(forKey: "QuickBlockID")
//                else {
//                    return
//            }
//             let endPoint = Endpoints.quickBlockRegisterEndPoint + loggedInUserID! + "/\(clsId)/\(0)"
            let endPoint = Endpoints.subscribeClassEndPoint+loggedInUserID!+"/\(clsId)"
            startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
            Alamofire.request(endPoint).responseJSON { response in
                self.stopAnimating()
                print(response.request!)   // original url request
                print(response.response!) // http url response
                print(response.result)  // response serialization result
                let json = response.result.value as? [String: Any]
                if "\(response.result)" == "SUCCESS"{
                        if json!["message"] as? String  == "Success" {
                            showMessage(bodyText: "Subscribed Successfully!",theme: .success)
                            self.cellDatas.remove(at: sender.tag)
                            self.availableClassTableView.reloadData()
                        }else{
                            showMessage(bodyText: json!["message"] as! String,theme: .error)
                    }
                }
                else {
                    showMessage(bodyText: "Please Try Again!",theme: .warning)
                }
            }
        }else {
            //NO Internet connection, just return
            showMessage(bodyText: "No internet connection",theme: .warning)
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        callNextVC()
    }
    func callNextVC(){
        //        if subscribedClassCount != 0{
        // chandra write code to move to Follow category.
        //        }else {
        UserDefaults.standard.set(false, forKey: "PostSignUpClassPage")
        UserDefaults.standard.set(true, forKey: "PostSignupGroupPage")
        UserDefaults.standard.synchronize()
        
        let group = self.storyboard?.instantiateViewController(withIdentifier: "AvailableGroupSignUpViewController") as! AvailableGroupSignUpViewController
        group.modalPresentationStyle = .fullScreen
        self.present(group, animated: true, completion: nil)
        //        }
    }
}

