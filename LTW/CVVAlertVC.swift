//
//  CVVAlertVC.swift
//  StripePoc3
//
//  Created by manjunath Hindupur on 10/10/18.
//  Copyright © 2018 manjunath Hindupur. All rights reserved.
//

import UIKit

class CVVAlertVC: UIViewController {

    @IBOutlet weak var bgUIView: UIView!
    
    @IBOutlet weak var okBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       bgUIView.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onOKBtnClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
