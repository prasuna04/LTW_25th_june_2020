//  TutorRatingAndReviewViewController.swift
//  LTW
//  Created by Vaayoo on 21/02/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import NVActivityIndicatorView
class TutorRatingAndReviewViewController: UIViewController,NVActivityIndicatorViewable {
   var profilId:String!
    var didScrool:Int!
    var jsondict = [JSON]()
    // add by chandra for scrolling
    private var tablePageIndex = 1
    private var noOfItemsInaPage = 5
    var activityIndicator: LoadMoreControl?
    @IBOutlet weak var tableview:UITableView!
    @IBOutlet weak var tutorProfileImg: UIImageView!{
           didSet{
               tutorProfileImg.setRounded()
               tutorProfileImg.layer.shadowColor = UIColor.gray.cgColor
               tutorProfileImg.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
               tutorProfileImg.layer.shadowRadius = 5.0
               tutorProfileImg.layer.shadowOpacity = 0.8
           }
       }
       @IBOutlet weak var nameLbl: UILabel!
       @IBOutlet weak var ratingViewtutor:CosmosView!
      
    override func viewDidLoad() {
        super.viewDidLoad()
        self.jsondict.removeAll()
        activityIndicator = LoadMoreControl(scrollView: tableview, spacingFromLastCell: 20, indicatorHeight: 60)
        activityIndicator?.delegate = self
        self.tableview.rowHeight = UITableView.automaticDimension
        self.tableview.estimatedRowHeight = 108.0
        hitserver()
        
    }
    override func viewDidLayoutSubviews() {
        let screenSize = UIScreen.main.bounds.size
        self.view.bounds.size = screenSize
        self.view.frame.origin.x = 0
        self.view.frame.origin.y = 0
    }
    func hitserver(){
        // api/searchPublicGroup/{UserID}/{index}/{count}?searchText={searchText}
        //let url = "http://ltwservice.azurewebsites.net/api/searchPublicGroup/\(userId!)/\(tablePageIndex)/\(noOfItemsInaPage)?searchText=\(textfield.text!)"
//        let url = Endpoints.classReviewList + profilId! + "/\(tablePageIndex)" + "/\(noOfItemsInaPage)"
        let url = Endpoints.tutorReviewList + profilId! + "/\(tablePageIndex)" + "/\(noOfItemsInaPage)"



        print(url)
        if didScrool == 1{
            
        }else{
             startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        }
       
        Alamofire.request(url ).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                self.stopAnimating()
                self.activityIndicator?.stop()
                
                if let message = swiftyJsonVar["message"].string{
                    if message == "Success"{
                        let lsv_group = swiftyJsonVar["ControlsData"]["lsv_reviewlist"].arrayValue
                        self.jsondict.append(contentsOf: lsv_group)
                        let rating = swiftyJsonVar["ControlsData"]["Rating"].intValue
                        self.ratingViewtutor.rating = rating == 0 ? 2.5 : Double(rating) /* added by veeresh on 3rd april 2020 */
                        let TutorName = swiftyJsonVar["ControlsData"]["TutorName"].string
                        self.nameLbl.text = TutorName
                        let imgTutor = swiftyJsonVar["ControlsData"]["TutorProfile"].string
                        let thumbnail = imgTutor!.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
                        self.tutorProfileImg.sd_setImage(with: URL.init(string:thumbnail ),placeholderImage: UIImage(named: "small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
                        DispatchQueue.main.async {
                            self.tableview.reloadData()
                        }
                    }else{
                        
                    }
                }
                //self.tableview.reloadData()
                self.stopAnimating()
                
            }else{
                self.stopAnimating()
            }
        }
    }
    
   

    
}
extension TutorRatingAndReviewViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsondict.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TutorRatingAndReviewTableViewCell") as! TutorRatingAndReviewTableViewCell
        let dict = jsondict[indexPath.row]
        highlightBoldWordAtLabel(textViewTotransform: cell.subjects, completeText: "Subject: \(dict["Subject"].stringValue)", wordToBold: "Subject: ")
       // cell.subjects.text = dict["Subject"].stringValue
        highlightBoldWordAtLabel(textViewTotransform: cell.grades, completeText: "Grade: \(dict["Grades"].stringValue)", wordToBold: "Grade: ")
        //cell.grades.text = dict["Grades"].stringValue
        highlightBoldWordAtLabel(textViewTotransform: cell.className, completeText: "ClassName: \(dict["ClassTitle"].stringValue)", wordToBold: "ClassName: ")
      //  cell.className.text = dict["ClassTitle"].stringValue
        cell.name.text = dict["Name"].stringValue
      highlightBoldWordAtLabel(textViewTotransform: cell.descriptionLbl, completeText: "Description: \(dict["Review"].stringValue)", wordToBold: "Description: ")
//        cell.descriptionLbl.text = "Description: \(dict["Review"].stringValue)"
        let rating = dict["Rating"].intValue
        // 0 ? 2.5 : Double(rating)
        cell.ratingView.rating = Double(rating)
        let stringUrl = dict["ProfileUrl"].stringValue
        let thumbnail = stringUrl.replacingOccurrences(of: "actualimages/", with: "thumbnails/sm-")
        cell.profileImg.sd_setImage(with: URL.init(string:thumbnail ),placeholderImage: UIImage(named:"small"), options: [.continueInBackground, .progressiveDownload,.refreshCached])
       return cell
    }
    func highlightBoldWordAtLabel(textViewTotransform: UILabel, completeText: String, wordToBold: String){
        textViewTotransform.text = completeText
        let range = (completeText as NSString).range(of: wordToBold)
        let attribute = NSMutableAttributedString.init(string: completeText)
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 16), range: range)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range)
        textViewTotransform.attributedText = attribute
    }
    // add by chandra for scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        activityIndicator?.didScroll()
        print("activityIndicator")
        
    }
}
//add by chandra for scrolling the tableview
extension TutorRatingAndReviewViewController: LoadMoreControlDelegate {
    func loadMoreControl(didStartAnimating loadMoreControl: LoadMoreControl) {
        print("didStartAnimating")
        tablePageIndex = (tablePageIndex + noOfItemsInaPage)
        didScrool = 1
        self.hitserver()
    }
    
    func loadMoreControl(didStopAnimating loadMoreControl: LoadMoreControl) {
        print("didStopAnimating")
    }
}
