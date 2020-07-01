//
//  PaymentVC.swift
//  BidToBring
//
//  Created by vaayoo on 04/10/18.
//  Copyright © 2018 vaayoo. All rights reserved.
//


import UIKit
import Stripe
import NVActivityIndicatorView
import Alamofire
import SwiftyJSON
let months = Calendar.current.shortMonthSymbols
let years = (Calendar.current.component(.year, from: Date())...2050).map { String($0) }
struct DateModel {
    var month = months[0]
    var year = years[0]
}
class PaymentVC: UIViewController, UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,NVActivityIndicatorViewable {
    
    var model = DateModel()
    
    @IBOutlet weak var scrollViewView: UIView!
    
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    
    @IBOutlet weak var cardTableView: UITableView!
    @IBOutlet weak var cardTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var creditCardRadioBtn: UIButton!
    
    @IBOutlet var cardNumberTF: UITextField!;
    @IBOutlet weak var cardNoUnderLineView: UIView!
    
    @IBOutlet weak var expiryLabel: UILabel!
    
    @IBOutlet weak var monthBtn: UIButton!
    @IBOutlet weak var mmArrowBtn: UIButton!
    @IBOutlet weak var mmUnderlineBtn: UIView!
    
    @IBOutlet weak var yearBtn: UIButton!
    @IBOutlet weak var yyArrowBtn: UIButton!
    @IBOutlet weak var yyUnderlineView: UIView!
    
    @IBOutlet weak var cvcTF: UITextField!
    @IBOutlet weak var cvvUnderlineView: UIView!
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var nameUnderlineView: UIView!
    
    @IBOutlet weak var saveCardLabel: UILabel!
    @IBOutlet weak var saveCardSwitchBtn: UISwitch!
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var continueBtnTopConst: NSLayoutConstraint!
    
    //prasuna added
    @IBOutlet weak var pointsBtn: UIButton!
    @IBOutlet weak var currencyBtn: UIButton!

    
    
    
    var monthNumber:UInt?
    var selectedElementIndex:Int = -1
    var isVeryFirstTime: Bool = true
    
    var savedCardList: Array<JSON> = []
    var amount = 0

    
    var params: [String: Any]?
        //= ["OrderID": 802,"Amount": 30000,"Description": Constants.defaultDescription,"TipAmount": 3000,"CurrencyCode": Constants.defaultCurrency ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
//        scrollViewView.isHidden = true
        self.title = "Payment"
        cardNumberTF.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
        continueBtn.layer.cornerRadius = 5
        cardTableView.dataSource = self
        cardTableView.delegate = self
        self.cardTableViewHeight.constant = 0
        seperatorView.backgroundColor = UITableView().separatorColor
        seperatorView.isHidden = true
        cardNumberTF.delegate = self
        cvcTF.delegate = self
        nameTF.delegate = self
        creditCardRadioBtn.isSelected = true
        cardNumberTF.addDoneButtonToKeyboard(myActionDone:  #selector(self.cardNumberTF.resignFirstResponder), myActionCancel: #selector(self.cardNumberTF.resignFirstResponder))
        cvcTF.addDoneButtonToKeyboard(myActionDone:  #selector(self.cvcTF.resignFirstResponder), myActionCancel: #selector(self.cvcTF.resignFirstResponder))
        
        //12/6/2020
                 if NSLocale.current.currencyCode == "INR"
                 {
                    currencyBtn.setTitle("INR", for: .normal)
        }else
                 {
                    currencyBtn.setTitle("USD", for: .normal)

        }
        
        
        //TODO - check Internet conectivity
        self.completeCharge(url: "\(self.savedCardUrl.appendingPathComponent("\(UserDefaults.standard.integer(forKey: "UserID"))"))",requestType: "savedCard", httpMethod: .get, params: [:] )
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedCardList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:SavedCardCell =
            tableView.dequeueReusableCell(withIdentifier: "savedcardcell") as! SavedCardCell
        cell.separatorInset = UIEdgeInsets.zero
        let dict = savedCardList[indexPath.row]
        
        cell.itemLabel.text = "\(dict["Brand"]) \(dict["funding"])"
        cell.cardNumber.text = "**** **** **** \(dict["last4"])"
        
        if dict["IsDefaultCard"].boolValue && isVeryFirstTime {
            isVeryFirstTime = false
            selectedElementIndex = indexPath.row
        }
        if indexPath.row == selectedElementIndex {
            cell.radioButton.isSelected = true
            cell.cvvTextField.isHidden = false
            cell.cvvUnderlineView.isHidden = false
            cell.QuesMarkBtn.isHidden = false
            cell.quesmarkBtnUnderlineView.isHidden = false
            cell.QuesMarkBtn.addTarget(self, action: #selector(onQuestionMarkBtnClick), for: .touchUpInside)
            cell.cvvTextField.delegate = self
            cell.cvvTextField.addDoneButtonToKeyboard(myActionDone:  #selector(cell.cvvTextField.resignFirstResponder), myActionCancel: #selector(cell.cvvTextField.resignFirstResponder))
            
        } else {
            cell.radioButton.isSelected = false
            cell.cvvTextField.isHidden = true
            cell.cvvUnderlineView.isHidden = true
            cell.QuesMarkBtn.isHidden = true
            cell.quesmarkBtnUnderlineView.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedElementIndex = indexPath.row
        creditCardRadioBtn.isSelected = false
        self.hideCardInputFields(value: true)
        self.continueBtnTopConst.constant = 30
        cardTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // let indexPath = tableView.indexPathForSelectedRow
        //let cell = tableView.cellForRow(at: indexPath)  as! CustomiseTableViewCell
        return 114
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
//    @objc private func onQuestionMarkBtnClick(){
//        print("#onQuestionMarkBtnClick#")
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let myAlert = storyboard.instantiateViewController(withIdentifier: "alert")
//        myAlert.modalPresentationStyle = UIModalPresentationStyle.popover
//        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//        self.present(myAlert, animated: true, completion: nil)
//
//        //self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//
//    }
    @objc private func onQuestionMarkBtnClick(){
        print("#onQuestionMarkBtnClick#")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "alert")
        myAlert.popoverPresentationController?.sourceView = self.view
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(myAlert, animated: true, completion: nil)
    }
    
    @IBAction func onCreditCardBtnClick(_ sender: UIButton) {
        creditCardRadioBtn.isSelected = true
        selectedElementIndex = -1
        cardTableView.reloadData()
        self.hideCardInputFields(value: false)
        continueBtnTopConst.constant = 350
        
        
    }
    @IBAction func onDateBtnClick(_ sender: UIButton) {
        let inputArr = sender.tag == 1 ? months : years
        let controller = ArrayChoiceTableViewController(inputArr){ (monthYear) in
            if sender.tag == 1 {
                self.model.month = monthYear
                self.monthBtn.setTitle(String(describing: self.model.month), for: .normal)
                
                print("Month index = \((months.index(of: monthYear)! + 1))")
                self.monthNumber = (UInt(months.index(of: monthYear)!) + 1)
                self.monthBtn.setTitleColor(UIColor.black, for: .normal)
            } else {
                self.model.year = monthYear
                self.yearBtn.setTitle(String(describing: self.model.year), for: .normal)
                self.yearBtn.setTitleColor(UIColor.black, for: .normal)
            }
        }
        controller.preferredContentSize = CGSize(width: 75, height: 200)
        showPopup(controller, sourceView: sender)
    }
    @IBAction func onPointsBtnClick(_ sender: UIButton) {
        
        /*
         $1 = 40 points
         $2- 100 points
         $5 - 400 points
         $10 - 1000 points
         $15- 2000 points
         $20 - 3000 points
         */
        
       let inputArr = ["100","200","300","400","500","600","700","800","900","1000"]
        let currencyArr = ["1","2","3","4","5","6","7","8","9","10"]
        let currencyArr1 = ["70","140","210","280","350","420","490","560","630","700"]
        let controller = ArrayChoiceTableViewController(inputArr){ (monthYear) in
            //12/6/2020
           if NSLocale.current.currencyCode == "INR"
           {
            let val = currencyArr1[inputArr.index(of: monthYear)!]
            self.amount = Int(val)!
            print("Month index \(val)")
            self.currencyBtn.setTitle(val + " INR", for: .normal)

            }else
           {
            let val = currencyArr[inputArr.index(of: monthYear)!]
            self.amount = Int(val)!
            print("Month index \(val)")
            self.currencyBtn.setTitle(val + " USD", for: .normal)

            }
            self.currencyBtn.setTitleColor(UIColor.black, for: .normal)
            self.pointsBtn.setTitle(monthYear + "  ", for: .normal)
            self.pointsBtn.setTitleColor(UIColor.black, for: .normal)
               }
               controller.preferredContentSize = CGSize(width: 75, height: 200)
               showPopup(controller, sourceView: sender)
    }
    
    @IBAction func onSaveCardToggled(_ sender: UISwitch) {
        //showAlert(msg: "Work in proress!")
    }
    
    @IBAction func onContinueBtnClick(_ sender: UIButton) {
            
            print("Pay Button Clicked!")
            continueBtn.isEnabled = false
            if selectedElementIndex != -1 {
                // saved card
                
                let indexPath  = IndexPath(row: selectedElementIndex, section: 0)
                let cell = cardTableView.cellForRow(at: indexPath)  as! SavedCardCell
                let cvv = cell.cvvTextField.text
                if (cvv?.isEmpty)! {
                    showAlert(msg: "Enter CVV number")
                    continueBtn.isEnabled = true
                    return
                }
                //"Token": token.tokenId,
                //,"ShouldCardBeSaved":  self.selectedElementIndex == -1 ? self.saveCardSwitchBtn.isOn : true
                
                
                let dict = savedCardList[selectedElementIndex]
                //            cardParams.number = dict["last4"].stringValue
                //            cardParams.expMonth = dict["exp_month"].uIntValue
                //            cardParams.expYear = dict["exp_year"].uIntValue
                //            cardParams.cvc = cvv
                
                //"Token": token.tokenId,
                //,"ShouldCardBeSaved":  self.selectedElementIndex == -1 ? self.saveCardSwitchBtn.isOn : true
    //            params!["Token"] = ""
    //            params!["ShouldCardBeSaved"] = self.selectedElementIndex == -1 ? self.saveCardSwitchBtn.isOn : true
    //            params!["StripeCardID"] = dict["StripeCardID"].stringValue
                //TODO - check Internet conectivity
                self.completeCharge(url: Endpoints.baseURLString,requestType: "charge", httpMethod: .post, params: self.params! )
                
            }else{
                // new card
                if pointsBtn.titleLabel!.text!.trimmingCharacters(in: CharacterSet.whitespaces) == "Points"
                {
                    showAlert(msg: "Please select points.")
                    continueBtn.isEnabled = true
                    return
                    
                }else if cardNumberTF.text?.isEmpty ?? false{
                    
                    showAlert(msg: "Enter card number")
                    continueBtn.isEnabled = true
                    return
                }else if monthBtn.title(for: .normal) == "MM" {
                    showAlert(msg: "Please select expiry month.")
                    continueBtn.isEnabled = true
                    return
                }else if yearBtn.title(for: .normal) == "YYYY" {
                    showAlert(msg: "Please select expiry year.")
                    continueBtn.isEnabled = true
                    return
                }else if cardNumberTF.text?.isEmpty ?? false {
                    showAlert(msg: "Please enter card number.")
                    continueBtn.isEnabled = true
                    return
                }else if cvcTF.text?.isEmpty ?? false {
                    showAlert(msg: "Please enter CVV number.")
                    continueBtn.isEnabled = true
                    return
                }
                else  if (Int(cvcTF.text!) ?? 0 <= 100 || Int(cvcTF.text!) ?? 0 >= 999) {
                    showAlert(msg: "CVV number should be 3 digits.")//17/6/2020
                    continueBtn.isEnabled = true
                    return
                }else if nameTF.text?.isEmpty ?? false
                {
                    showAlert(msg: "Please enter name.")
                    continueBtn.isEnabled = true
                    return

                }
                
                startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
                let cardParams = STPCardParams()
                cardParams.currency = NSLocale.current.currencyCode
    //            cardParams.currency = params!["CurrencyCode"] as? String
                cardParams.number = cardNumberTF.text
                cardParams.expMonth = monthNumber!
                cardParams.expYear = UInt(yearBtn.title(for: .normal)!)!
                cardParams.cvc = cvcTF.text
                
                print("Card Info = \(cardParams)")
                // paymentCardTextField.resignFirstResponder()
                if STPCardValidator.validationState(forCard: cardParams) == .valid {
                    print("Card id valid!")
                }else {
                    self.stopAnimating()
                    showAlert(msg: "Invalid card Info!")
                    print("Card is invalid!")
                    continueBtn.isEnabled = true
                    return
                }
                STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
                    guard let token = token, error == nil else {
                        // Present error to user...
                        self.stopAnimating()
                        self.showAlert(msg: "Error in generating token!")
                        self.continueBtn.isEnabled = true
                        return
                    }
                    print("Token = \(token.tokenId)")
                    // (self.currencyBtn.titleLabel?.text ?? "")
    //                "\(self.pointsBtn.titleLabel?.text ?? "")"
                    
//                    let amount = Int(self.currencyBtn.titleLabel!.text!) ?? 0
                    let points = Int(self.pointsBtn.titleLabel!.text!.trimmingCharacters(in: CharacterSet.whitespaces)) ?? 0
                    //12/6/2020
                    self.params = ["EmailID": "\(UserDefaults.standard.object(forKey: "emailId") as! String)","Amount": self.amount * 100 ,"Token": "\(token.tokenId)" ,"CurrencyCode": "\(NSLocale.current.currencyCode ?? "USD")","Points": points ,"UserID":"\(UserDefaults.standard.object(forKey: "userID") as! String)","Description":"","CustomerId":"\(UserDefaults.standard.object(forKey: "CustomerID") as? String ?? "")","ShouldCardBeSaved":self.selectedElementIndex == -1 ? self.saveCardSwitchBtn.isOn : true,"StripeCardID":""]
                    
    //                self.params!["Token"] = token.tokenId
    //                self.params!["ShouldCardBeSaved"] = self.selectedElementIndex == -1 ? self.saveCardSwitchBtn.isOn : true
    //                self.params!["StripeCardID"] = ""
                    
                    //TODO - check Internet conectivity
                    self.completeCharge(url: Endpoints.baseURLString,requestType: "charge", httpMethod: .post, params: self.params! )
                }
            }// end of else
        }
//    private lazy var baseURL: URL = {
//        guard let url = URL(string: Endpoints.baseURLString) else {
//            fatalError("Invalid URL")
//        }
//        return url
//    }()
    private lazy var savedCardUrl: URL = {
        guard let url = URL(string: Endpoints.savedCardUrl) else {
            fatalError("Invalid URL")
        }
        return url
    }()
    
    private func hideCardInputFields(value: Bool){
        
        cardNumberTF.isHidden = value
        cardNoUnderLineView.isHidden = value
        
        expiryLabel.isHidden = value
        
        monthBtn.isHidden = value
        mmArrowBtn.isHidden = value
        mmUnderlineBtn.isHidden = value
        
        yearBtn.isHidden = value
        yyArrowBtn.isHidden = value
        yyUnderlineView.isHidden = value
        
        cvcTF.isHidden = value
        cvvUnderlineView.isHidden = value
        
        nameTF.isHidden = value
        nameUnderlineView.isHidden = value
        
        saveCardLabel.isHidden = value
        saveCardSwitchBtn.isHidden = value
    }
    
    func completeCharge( url: String, requestType: String,httpMethod: HTTPMethod, params: [String:Any]) {
        // 1
        //let url = baseURL.appendingPathComponent("charge")
        // let url = baseURL
        print("Url = \(url)")
        
        print("Params = \(params)")
        
        print("method = \(httpMethod)")
        // 3
        
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        LTWClient.shared.hitService(withBodyData: params, toEndPoint: url, using: httpMethod, dueToAction: "Payment"){[unowned self] result in
            self.stopAnimating()
            self.continueBtn.isEnabled = true
            switch result {
            case let .success(json, _):
                let msg = json["Message"].stringValue
                if json["error"].intValue == 1 {
                    showMessage(bodyText: msg,theme: .error)
                }else {
//                    if  let value = response.result.value{
//                        print("Payment response : \(response.result.value!)")
//                        let json = JSON(value)
                        if requestType == "charge" {
                            var msg: String = ""
                            if json["message"].exists() {
                                msg = json["message"].stringValue
                            }else {
//                                msg = response.result.value! as! String
                            }
                            
                            let dict = json["ControlsData"].dictionaryValue
                            UserDefaults.standard.set(dict["CustomerID"]?.stringValue, forKey:"CustomerID")
                            // Present success to user...
                            let alertController = UIAlertController(title: "Message", message: msg , preferredStyle: .alert)
                            // let alertAction = UIAlertAction(title: "OK", style: .default)
                            let alertAction = UIAlertAction.init(title: "Ok", style: .default, handler: { (UIAlertAction) in
                               // self.navigationController?.popToRootViewController(animated: true) //commented by yasodha
                                self.navigationController?.popViewController(animated: true) //Added by yasodha
                            })
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true)
                        }else if requestType == "savedCard" {
                            self.savedCardList.removeAll()
//                            let json = JSON(value)
                            for object in json.arrayValue {
                                self.savedCardList.append(object)
                            }
                            
                            if self.savedCardList.count > 0 {
                                
                                if self.savedCardList.count == 1 {
                                    self.cardTableViewHeight.constant = (115 - 3) // 1 is for underline view height * 3
                                }else {
                                    self.cardTableViewHeight.constant = (230 - 3) //  1 is for underline view height * 3
                                }
                                self.cardTableView.reloadData()
                                self.seperatorView.isHidden = false
                                self.hideCardInputFields(value: true)
                                self.continueBtnTopConst.constant = 30
                            }else {
                                self.creditCardRadioBtn.isSelected  = true
                            }
                            
                            self.scrollViewView.isHidden = false
                            
                            
                        }
//                    }
                }
                break
            case .failure(let error):
                print("MyError = \(error)")
//                showMessage(bodyText: "\(error)",theme: .error)

                break
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
//        Alamofire.request(url,method: httpMethod, parameters: params.isEmpty ? nil: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
//            //            activityIndicator.stopAnimating() // On response stop animating
//            //            activityIndicator.removeFromSuperview() // remove the view
//            ProgressHUD.dismiss()
//            switch(response.result) {
//            case .success(_):
//                if response.result.value != nil{
//                    if  let value = response.result.value{
//                        print("Payment response : \(response.result.value!)")
//                        let json = JSON(value)
//                        if requestType == "charge" {
//                            var msg: String = ""
//                            if json["Message"].exists() {
//                                msg = json["Message"].stringValue
//                            }else {
//                                msg = response.result.value! as! String
//                            }
//                            // Present success to user...
//                            let alertController = UIAlertController(title: NSLocalizedString("ALERT_MESSAGE", comment: ""), message: msg , preferredStyle: .alert)
//                            // let alertAction = UIAlertAction(title: "OK", style: .default)
//                            let alertAction = UIAlertAction.init(title: "Ok", style: .default, handler: { (UIAlertAction) in
//                                self.navigationController?.popToRootViewController(animated: true)
//                            })
//                            alertController.addAction(alertAction)
//                            self.present(alertController, animated: true)
//                        }else if requestType == "savedCard" {
//                            self.savedCardList.removeAll()
//                            let json = JSON(value)
//                            for object in json.arrayValue {
//                                self.savedCardList.append(object)
//                            }
//
//                            if self.savedCardList.count > 0 {
//
//                                if self.savedCardList.count == 1 {
//                                    self.cardTableViewHeight.constant = (115 - 3) // 1 is for underline view height * 3
//                                }else {
//                                    self.cardTableViewHeight.constant = (230 - 3) //  1 is for underline view height * 3
//                                }
//                                self.cardTableView.reloadData()
//                                self.seperatorView.isHidden = false
//                                self.hideCardInputFields(value: true)
//                                self.continueBtnTopConst.constant = 30
//                            }else {
//                                self.creditCardRadioBtn.isSelected  = true
//                            }
//
//                            self.scrollViewView.isHidden = false
//
//
//                        }
//                    }
//                }
//                break
//
//            case .failure(_):
//
//                if let error = response.result.error {
//                    if error._code == NSURLErrorTimedOut { // 4/2/19
//                        VSCore().ShowAlert(vc: self, title: NSLocalizedString("ALERT_MESSAGE", comment: ""), message: NSLocalizedString("ALERT_LOW_CONNECTIVITY", comment: "") )
//                    }else if error._code == NSURLErrorNotConnectedToInternet
//                    {
//                        VSCore().ShowAlert(vc: self, title: NSLocalizedString("ALERT_MESSAGE", comment: ""), message: NSLocalizedString("ALERT_CONNECTION", comment: "") )
//                    }
//                }
//                break
//
//            }
//        }
    }
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        previousTextFieldContent = textField.text;
        previousSelection = textField.selectedTextRange;
        return true
    }
    
    @objc func reformatAsCardNumber(textField: UITextField) {
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
        }
        
        var cardNumberWithoutSpaces = ""
        if let text = textField.text {
            cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
        }
        
        if cardNumberWithoutSpaces.count > 19 {
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            return
        }
        
        let cardNumberWithSpaces = self.insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
        textField.text = cardNumberWithSpaces
        
        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
    }
    
    func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var digitsOnlyString = ""
        let originalCursorPosition = cursorPosition
        
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if characterToAdd >= "0" && characterToAdd <= "9" {
                digitsOnlyString.append(characterToAdd)
            }
            else if i < originalCursorPosition {
                cursorPosition -= 1
            }
        }
        
        return digitsOnlyString
    }
    
    func insertCreditCardSpaces(_ string: String, preserveCursorPosition cursorPosition: inout Int) -> String {
        // Mapping of card prefix to pattern is taken from
        // https://baymard.com/checkout-usability/credit-card-patterns
        
        // UATP cards have 4-5-6 (XXXX-XXXXX-XXXXXX) format
        let is456 = string.hasPrefix("1")
        
        // These prefixes reliably indicate either a 4-6-5 or 4-6-4 card. We treat all these
        // as 4-6-5-4 to err on the side of always letting the user type more digits.
        let is465 = [
            // Amex
            "34", "37",
            
            // Diners Club
            "300", "301", "302", "303", "304", "305", "309", "36", "38", "39"
            ].contains { string.hasPrefix($0) }
        
        // In all other cases, assume 4-4-4-4-3.
        // This won't always be correct; for instance, Maestro has 4-4-5 cards according
        // to https://baymard.com/checkout-usability/credit-card-patterns, but I don't
        // know what prefixes identify particular formats.
        let is4444 = !(is456 || is465)
        
        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition
        
        for i in 0..<string.count {
            let needs465Spacing = (is465 && (i == 4 || i == 10 || i == 15))
            let needs456Spacing = (is456 && (i == 4 || i == 9 || i == 15))
            let needs4444Spacing = (is4444 && i > 0 && (i % 4) == 0)
            
            if needs465Spacing || needs456Spacing || needs4444Spacing {
                stringWithAddedSpaces.append(" ")
                
                if i < cursorPositionInSpacelessString {
                    cursorPosition += 1
                }
            }
            
            let characterToAdd = string[string.index(string.startIndex, offsetBy:i)]
            stringWithAddedSpaces.append(characterToAdd)
        }
        
        return stringWithAddedSpaces
    }
    func showAlert(msg: String){
        
        // create the alert
        let alert = UIAlertController(title: "Message", message: msg, preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
}




