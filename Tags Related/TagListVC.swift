//  TagListVC.swift
//  LTW
//  Created by Ranjeet Raushan on 14/04/19.
//  Copyright © 2019 Vaayoo . All rights reserved.

import UIKit

protocol TagListVCDelegate {
    func setTagItems(strName: String, index: Int ,Tag:Int)
}

class TagListVC: UIViewController {
    
    var arrTagList : [String] = []
    var arrTag : [Int] = []
     var arrTag1 : [Int] = []
    var delegate : TagListVCDelegate!
    var tag :Int?
    @IBOutlet weak var tblTagList : UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblTagList.dataSource = self
        tblTagList.delegate = self
    }
    
   //MARK:- UIButton Action
    
    @IBAction func btnClosePressed(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
    }
}

extension TagListVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTagList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tblTagList.dequeueReusableCell(withIdentifier: "tagCell") as! TagListCell
        if tag == 0
        {
            cell.setCellData(strTag: arrTagList[indexPath.row], index: arrTag[indexPath.row])

        }else{
            
            cell.setCellData(strTag: arrTagList[indexPath.row], index: arrTag1[indexPath.row])

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblTagList.deselectRow(at: indexPath, animated: true)
        
        if tag == 0
        {
        if arrTag[indexPath.row] == 0 {
            
            
            //For Multiple Selection
            
                arrTag[indexPath.row] = 1
            self.delegate.setTagItems(strName: arrTagList[indexPath.row], index: indexPath.row, Tag: tag ?? 0)
                tblTagList.reloadRows(at:[indexPath], with: .automatic)
            
            /*
             // Don't Delete , because  in future , it will be reusable
            //for Single Selection
            self.dismiss(animated: true) {
              self.delegate.setTagItems(strName: self.arrTagList[indexPath.row], index: indexPath.row)
            }
            */
        }
        }else{
        if arrTag1[indexPath.row] == 0 {
            
            
            //For Multiple Selection
            
                arrTag1[indexPath.row] = 1
            self.delegate.setTagItems(strName: arrTagList[indexPath.row], index: indexPath.row, Tag: tag ?? 0)
                tblTagList.reloadRows(at:[indexPath], with: .automatic)
            
            /*
             // Don't Delete , because  in future , it will be reusable
            //for Single Selection
            self.dismiss(animated: true) {
              self.delegate.setTagItems(strName: self.arrTagList[indexPath.row], index: indexPath.row)
            }
            */
        }
        }
    }
}

class  TagListCell: UITableViewCell {
    @IBOutlet weak var lblTag : UILabel!
    func  setCellData(strTag: String, index: Int) {
        lblTag.text = strTag
        if index == 1 {
            lblTag.textColor = UIColor.gray
        } else {
            /*  Updated By Ranjeet on 26th March 2020 - starts  here */
            lblTag.textColor = UIColor.black // changed by ranjeet on 5th may
            if #available(iOS 13.0, *) {
                lblTag.textColor = UIColor.label
            } else {
                
                // Fallback on earlier versions
            }
             /*  Updated By Ranjeet on 26th March 2020 - ends  here */
        }
    }
}
