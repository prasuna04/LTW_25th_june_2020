//  ViewController.swift
//  Task1
//  Created by vaayoo on 15/11/19.
//  Copyright © 2019 Vaayoo. All rights reserved.


import UIKit
import  Alamofire
import NVActivityIndicatorView


class AttendeesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,NVActivityIndicatorViewable{
    @IBOutlet weak var tableView : UITableView!
    var json=Dictionary<String,Any>()     // to store retrived Alamofire response
    var models=[model]()                  // to store the objects of model
    //testID goes here
    var testId = String()
    
    //Table view number of row is equal to number of model object created which is pressent in models.count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayCell", for: indexPath) as? DisplayCell
        {
            
            //calling a update function present in the DisplayCell with the parameters of index.row mosel present in array of model and passing a index value of model array for adding it into button tag
            let temp = models[indexPath.row]                     //taking a particular row model and storing it
            cell.updateFrame(model: temp,index: indexPath.row)
            return cell
        }
        return UITableViewCell()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //for making a navigationBar title color as white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        fetchUrl()                                 // this function is used to fetch the data from a url and stores in a models array
        tableView.delegate=self
        tableView.dataSource=self
        // to make backbutton title as empty so it only shows the back symbol
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

         if (self.navigationController?.navigationBar) != nil {
         navigationController?.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC") // making navigation bar color as blue
         navigationController?.view.backgroundColor = UIColor.init(hex:"2DA9EC")
        // to resolve black bar problem appears on navigation bar when pushing view controller
         }
         //self.navigationController?.navigationBar.topItem?.title = " "
         navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
         navigationController?.navigationBar.tintColor = UIColor.white

        self.navigationItem.title = "Attendees".uppercased()
    }
    
    @IBAction func onButtonPressed(_ sender: UIButton) {
//        performing a segues when the button is tapped
        let soryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard?.instantiateViewController(withIdentifier: "ReviewAnswerVC") as! ReviewAnswerVC
        vc.models=models[sender.tag]                //passing a cell associated model object
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // for fetching the dat from API and store in a model class
    func fetchUrl(){
               startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        self.models=[model]()
        let   url=URL(string: Endpoints.TestAttendeesEndPoint+"\(testId)")  /* Added By Veeresh on 26th Dec 2019 */
        Alamofire.request(url!).responseJSON { response in
            self.stopAnimating()
            let result=response.result
            print(result.value!)                               //uncomment to check response data
                self.json=result.value as! Dictionary<String,Any>
           //  print(self.json["message"])                       //uncomment to see message value
            let message=self.json["message"] as? String
            let error=self.json["error"] as? Bool
            if message=="Success" && error! == false{
                let ControlsData = self.json["ControlsData"] as? Dictionary<String,Any>
                let attendeesList = ControlsData!["attendeesList"] as? [Dictionary<String,Any>]
                for i in attendeesList!{
                    //for number of data present in the response creating a new object and storing it inside the models array
                    //instantiate the object with the testId userId FirstName LastName and Profile URL
                    self.models.append( model(testId: self.testId,UserId: i["UserID"]! as? String ?? "", FirstName: i["Firstname"]! as? String ?? "", LastName: i["LastName"]! as? String ?? "", ProfileURl: i["ProfileURl"]! as? String ?? "",  Score : i["Score"] as? Double ?? 0.0 )) /* Added Score By Yashoda on 27th Jan 2020  */
                }
            }
            self.tableView.reloadData()
            
           
        }
    }
}
