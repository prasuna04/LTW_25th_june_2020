//
//  EncashDetailsVC.swift
//  LTW
//
//  Created by Vaayoo USA on 11/06/20.
//  Copyright © 2020 vaayoo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class EncashDetailsVC: UIViewController ,NVActivityIndicatorViewable{
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var OkBtn: UIButton!
    var points : String?
    var totalPoints : String?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Encash Amount"
        OkBtn.layer.cornerRadius = OkBtn.frame.size.height / 2
        pointsLabel.text = "Points you have" + " "+(points ?? "0")
//        let point = Double(points!)! * 0.8
//        var amount = point / 100
//
//        if NSLocale.current.currencyCode! == "INR"
//        {
//            amount = amount * 70
//        }else
//        {
//            amount = amount * 1
//        }
//        explainLabel.text = "20% of your points will go to LearnTeachWorld and you will get \(amount.rounded())\(NSLocale.current.currencySymbol!)"
        hitServer(url:Endpoints.ConvertPointsToCurrency + (points ?? "0") )


    }
     func hitServer(url :String){
        
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: [:], toEndPoint: url, using: .get, dueToAction: "Points"){ [weak self] result in
            guard let _self = self else {
                return
            }
            _self.stopAnimating()
            switch result {
            case let .success(json,requestType):
                
                let msg = json["message"].stringValue
                if json["error"].intValue == 1 {
                    
                    showMessage(bodyText: msg,theme: .error)
                    
                }else {
                    
                    /* "ControlsData": {
                       "TotalPoints": 1000,
                       "USD": 800,
                       "LTWPoints": 200,
                       "INR": 56000
                     }*/
                    
                    if NSLocale.current.currencySymbol == "INR"{
                        
                        let amount = json["ControlsData"]["INR"].intValue

                        self?.explainLabel.text = "20% of your points will go to LearnTeachWorld and you will get \(amount/100)\(NSLocale.current.currencySymbol!)"
                        
                    }else
                        {
                            let amount = json["ControlsData"]["USD"].intValue

                            self?.explainLabel.text = "20% of your points will go to LearnTeachWorld and you will get \(amount/100)\(NSLocale.current.currencySymbol!)"
                    }
                    
                    
                }
              
                break
            case .failure(let error):
                print("MyError = \(error)")
                
                break
            }
        }
    }
    
    @IBAction func onEditBtnClick(_ sender: UIButton)
    {
        //17/6/2020
        let story = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EncashPointsVC") as! EncashPointsVC
        story.totalPoints = points
        navigationController?.pushViewController(story, animated: true)
        
    }

    
@IBAction func onDateBtnClick(_ sender: UIButton)
{
    
    if Int(points!)! < 1000
    {
        showMessage(bodyText: "Points should more than 1000 to encash",theme: .error)

        
    }else{
   
        let params = ["UserID":"\(UserDefaults.standard.object(forKey: "userID") as! String)","TotalPoints": Int(points!)!,"tutorAcountID":"\(UserDefaults.standard.object(forKey: "AccountID") as! String)"] as [String : Any] //AccountID
    print(params)
    startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
    LTWClient.shared.hitService(withBodyData: params, toEndPoint: Endpoints.encashURLString, using: .post, dueToAction: "Payment"){[unowned self] result in
                self.stopAnimating()
                switch result {
                case let .success(json, _):
                    let msg = json["Message"].stringValue
                    if json["error"].intValue == 1 {
                        showMessage(bodyText: msg,theme: .error)
                    }else
                    {
                        if json["Message"].stringValue.count > 2
                        {
                            showMessage(bodyText: json["Message"].stringValue,theme: .error)

//                            showMessage(bodyText: json["Message"].stringValue,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 1))

                        }else
                        {
                            showMessage(bodyText: json["message"].stringValue,theme: .success,presentationStyle: .center, duration: .seconds(seconds: 1))

                        }

//                        showMessage(bodyText: msg,theme: .error)

                    }
                    break
                case .failure(let error):
                    print("MyError = \(error)")
                    showMessage(bodyText: "\(error)",theme: .error)

                    break
                }
            }
    
    }
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
