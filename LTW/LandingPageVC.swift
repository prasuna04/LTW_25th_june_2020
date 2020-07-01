//
//  LandingPageVC.swift
//  LTW
//
//  Created by Vaayoo on 20/05/20.
//  Copyright © 2020 vaayoo. All rights reserved.
//

import UIKit

class LandingPageVC: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!{
        didSet{
            loginBtn.layer.borderColor = UIColor.init(hex: "2DA9EC").cgColor
            loginBtn.layer.borderWidth = 2
            loginBtn.layer.cornerRadius = 19
        }
    }
    @IBOutlet weak var signupBtn: UIButton!{
        didSet{
            //  signupBtn.layer.borderColor = UIColor.green.cgColor
            //  signupBtn.layer.borderWidth = 2
            signupBtn.layer.cornerRadius = 19
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    @IBAction func onSignupBtnClick(_ sender: UIButton) {
        let sIgnUp = storyboard?.instantiateViewController(withIdentifier: "signup") as! SignUpVC
        navigationController?.pushViewController(sIgnUp, animated: false)
     //   self.present(sIgnUp, animated: <#Bool#>tr)
    }
    
    
    
    @IBAction func onLoginBtnClick(_ sender: UIButton) {
        
        let signIn = storyboard?.instantiateViewController(withIdentifier: "signinvc") as! SignInVC
        navigationController?.pushViewController(signIn, animated: false)
        
        
    }
    
    
    
}
