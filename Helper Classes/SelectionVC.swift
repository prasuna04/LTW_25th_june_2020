//  SelectionVC.swift
//  LTW
//  Created by Vaayoo USA on 29/01/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import UIKit

protocol SelectionDelegate:class {
    
    func doneBtnClicked(str: [String:String])
    func calcelBtnClinked()
    
}

class SelectionVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableVW :UITableView!
    @IBOutlet weak var okBtn:UIButton!
    @IBOutlet weak var cancelBtn:UIButton!
    var list:[String]?
    var dictList:[String:String]?
//    var selectstr :[String:String]!
//    var selectids : [String]!
    var selectDict :[String:String]?
    var strType = true
    weak var delegate: SelectionDelegate?
//    typealias doneComplition  = (String ,[[String:String]] ,Bool) -> Void
//    typealias cancelComplition = (String) -> Void
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.layer.cornerRadius = 5
        tableVW.delegate = self
        tableVW.dataSource = self
        tableVW.reloadData()
    
        okBtn.addTarget(self, action:#selector(doneBtnClicked), for: .touchUpInside)
        cancelBtn.addTarget(self, action:#selector(cancelBtnClicked), for: .touchUpInside)

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dictList?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.textColor = UIColor.init(hex: "2DA9EC")
        let str = dictList?["\(indexPath.row + 1)"]
        cell.textLabel?.text = str
        
        if selectDict?.keys.contains("\(indexPath.row + 1)") ?? false
        {
            if strType //For single selection
            {
                cell.imageView?.image = UIImage.init(named: "radio_selected")
            }else
            {
                cell.imageView?.image = UIImage.init(named: "checked")
                
            }
        }else
        {
            if strType //For single selection
            {
                cell.imageView?.image = UIImage.init(named: "radio")
            }else
            {
                cell.imageView?.image = UIImage.init(named: "check")
                
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let cell = tableView.cellForRow(at: indexPath)
        let str = dictList?["\(indexPath.row + 1)"]
        if selectDict?.keys.contains("\(indexPath.row + 1)") ?? false
        {
            if strType //For single selection
            {
                cell?.imageView?.image = UIImage.init(named: "radio")
                selectDict?.removeAll()
                tableView.reloadData()
                
            }else
            {
                cell?.imageView?.image = UIImage.init(named: "check")
                selectDict?.removeValue(forKey:"\(indexPath.row + 1)" )
                
            }
            
            
        }else
        {
            
            if strType //For single selection
            {
                selectDict = [:]
                selectDict?["\(indexPath.row + 1)"] = str!
                cell?.imageView?.image = UIImage.init(named: "radio_selected")
                tableView.reloadData()
                
            }else
            {
                selectDict?["\(indexPath.row + 1)"] = str!
                cell?.imageView?.image = UIImage.init(named: "checked")
                
            }
        }
    }
    
    
    @objc func doneBtnClicked(){
        
        if selectDict?.count ?? 0 < 1
        {
            showMessage(bodyText: "Please select",theme: .warning)
            
        }else
        {
            
            self.delegate?.doneBtnClicked(str:selectDict ?? [:])
            print(selectDict)
            
        }
    }
    
    @objc func cancelBtnClicked(){
        self.delegate?.calcelBtnClinked()
    }
}
