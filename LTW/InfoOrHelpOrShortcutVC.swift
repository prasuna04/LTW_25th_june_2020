//  InfoOrHelpOrShortcutVC.swift
//  LTW
//  Created by Ranjeet Raushan on 19/11/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit

class InfoOrHelpOrShortcutVC: UIViewController {
//    @IBOutlet weak var myWebView: UIWebView!
    @IBOutlet weak var askQstnsInfoVw: CardView!
    @IBOutlet weak var studyGrupInfoVw: CardView!
    @IBOutlet weak var subscrbeClsInfoVw: CardView!
    @IBOutlet weak var ansrQstnsInfoVw: CardView!
    @IBOutlet weak var teachClsInfoVw: CardView!
    @IBOutlet weak var createTestsInfoVw: CardView!
    @IBOutlet weak var followInfoVw: CardView!
    @IBOutlet weak var howDoesitWorkLbl: UILabel!{
        didSet{
            howDoesitWorkLbl.attributedText = howDoesitWorkLbl.text!.getUnderLineAttributedText()
        }
    }
    var tapGesture1 = UITapGestureRecognizer()
    var tapGesture2 = UITapGestureRecognizer()
    var tapGesture3 = UITapGestureRecognizer()
    var tapGesture4 = UITapGestureRecognizer()
    var tapGesture5 = UITapGestureRecognizer()
    var tapGesture6 = UITapGestureRecognizer()
    var tapGesture7 = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pageUrl = "https://www.youtube.com/embed/bH0E5VgAj0Y" // "https://www.youtube.com/watch?v=bH0E5VgAj0Y"
//        myWebView.delegate = self as? UIWebViewDelegate
        if let url = URL(string: pageUrl) {
            let request = URLRequest(url: url)
//            myWebView.loadRequest(request)
        }
        // on click of askQstnsInfoView
        tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(InfoOrHelpOrShortcutVC.askQstnsInfoVwTapped(_:)))
        tapGesture1.numberOfTapsRequired = 1
        tapGesture1.numberOfTouchesRequired = 1
        askQstnsInfoVw.addGestureRecognizer(tapGesture1)
        askQstnsInfoVw.isUserInteractionEnabled = true
        
        //on click of studyGrupInfoView
        
        tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(InfoOrHelpOrShortcutVC.studyGrupInfoVwTapped(_:)))
        tapGesture2.numberOfTapsRequired = 1
        tapGesture2.numberOfTouchesRequired = 1
        studyGrupInfoVw.addGestureRecognizer(tapGesture2)
        studyGrupInfoVw.isUserInteractionEnabled = true
        
        tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(InfoOrHelpOrShortcutVC.subscrbeClsInfoVwTapped(_:)))
        tapGesture3.numberOfTapsRequired = 1
        tapGesture3.numberOfTouchesRequired = 1
        subscrbeClsInfoVw.addGestureRecognizer(tapGesture3)
        subscrbeClsInfoVw.isUserInteractionEnabled = true
        
        tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(InfoOrHelpOrShortcutVC.ansrQstnsInfoVwTapped(_:)))
        tapGesture4.numberOfTapsRequired = 1
        tapGesture4.numberOfTouchesRequired = 1
        ansrQstnsInfoVw.addGestureRecognizer(tapGesture4)
        ansrQstnsInfoVw.isUserInteractionEnabled = true
        
        tapGesture5 = UITapGestureRecognizer(target: self, action: #selector(InfoOrHelpOrShortcutVC.teachClsInfoVwTapped(_:)))
        tapGesture3.numberOfTapsRequired = 1
        tapGesture3.numberOfTouchesRequired = 1
        teachClsInfoVw.addGestureRecognizer(tapGesture5)
        teachClsInfoVw.isUserInteractionEnabled = true
        
        tapGesture6 = UITapGestureRecognizer(target: self, action: #selector(InfoOrHelpOrShortcutVC.createTestsInfoVwTapped(_:)))
        tapGesture6.numberOfTapsRequired = 1
        tapGesture6.numberOfTouchesRequired = 1
        createTestsInfoVw.addGestureRecognizer(tapGesture6)
        createTestsInfoVw.isUserInteractionEnabled = true
        
        tapGesture7 = UITapGestureRecognizer(target: self, action: #selector(InfoOrHelpOrShortcutVC.followInfoVwTapped(_:)))
        tapGesture7.numberOfTapsRequired = 1
        tapGesture7.numberOfTouchesRequired = 1
        followInfoVw.addGestureRecognizer(tapGesture7)
        followInfoVw.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.navigationController?.navigationBar) != nil {
            navigationController?.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        }
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Info"
    }
    
    // on click of askQstnsInfoView
    @objc func askQstnsInfoVwTapped(_ sender: UITapGestureRecognizer) {
        let askquestion = storyboard?.instantiateViewController(withIdentifier: "askquestionwithtext") as! AskQuestionWithTextVC
        navigationController?.pushViewController(askquestion, animated: true)
    }
    @objc func studyGrupInfoVwTapped(_ sender: UITapGestureRecognizer) {
        let mygroup = storyboard?.instantiateViewController(withIdentifier: "mygroup") as! MyGroupsVC
        navigationController?.pushViewController(mygroup, animated: true)
    }
    @objc func subscrbeClsInfoVwTapped(_ sender: UITapGestureRecognizer) {
        showMessage(bodyText: "Work In Message",theme: .success, duration: .seconds(seconds: 0.5))
    }
    @objc func ansrQstnsInfoVwTapped(_ sender: UITapGestureRecognizer) {
        showMessage(bodyText: "Work In Message",theme: .success, duration: .seconds(seconds: 0.5))
    }
    @objc func teachClsInfoVwTapped(_ sender: UITapGestureRecognizer) {
        showMessage(bodyText: "Work In Message",theme: .success, duration: .seconds(seconds: 0.5))
    }
    @objc func createTestsInfoVwTapped(_ sender: UITapGestureRecognizer) {
        let createNewTestVC = storyboard?.instantiateViewController(withIdentifier: "createnewtest") as! CreateNewTestVC
        self.navigationController?.pushViewController(createNewTestVC, animated: true)
    }
    @objc func followInfoVwTapped(_ sender: UITapGestureRecognizer) {
        let followscreenvc = storyboard?.instantiateViewController(withIdentifier: "followscreen") as! FollowScreenVC
        self.navigationController?.pushViewController(followscreenvc, animated: true)
    }
}
