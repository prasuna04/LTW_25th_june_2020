//  FollowScreenVC.swift
//  LTW
//  Created by Ranjeet Raushan on 17/11/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit

class FollowScreenVC: UIViewController {
      override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navigationController = navigationController else { return }
        navigationController.view.backgroundColor = UIColor.white
        if (self.navigationController?.navigationBar) != nil {
            navigationController.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        }
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Follow"
    }
    @IBAction func onFollowUserBtnClk(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "followUser") as! FollwUserVC2ViewController
        vc.title = "Follow Users"
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onMyFolowersBtnClk(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MyFollowUseer2ViewController") as! MyFollowUseer2ViewController
        vc.title = "My Followers"
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onFollowCatgryBtnClk(_ sender: UIButton) {
        let myFollow = storyboard?.instantiateViewController(withIdentifier: "myfolwd") as! MyFollowedVC
        navigationController?.pushViewController(myFollow, animated: true)
    }
    @IBAction func onQstnsFollowedBtnClk(_ sender: UIButton) {
        let followQstn = storyboard?.instantiateViewController(withIdentifier: "contntqstinsfollowed") as! ContentQuestionsFollowedVC
        navigationController?.pushViewController(followQstn, animated: true)
    }
    
}
