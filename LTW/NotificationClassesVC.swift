//
//  NotificationClasses.swift
//  LTW
//
//  Created by vaayoo on 01/07/20.
//  Copyright © 2020 vaayoo. All rights reserved.
//

import UIKit

class NotificationClassesVC: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var classDict =  Dictionary<String,LTWEvents>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        classDict = CalenderEventStruct.classDict
    }
    @IBAction func joinButton(_ sender : UIButton){
        
    }
    @IBAction func whiteBoardButton(_ sender : UIButton){
        
    }
    @IBAction func unsubscribeButton(_ sender : UIButton) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationClassesCell", for: indexPath) as! NotificationClassesCell
        return cell

    }

    
   

}
