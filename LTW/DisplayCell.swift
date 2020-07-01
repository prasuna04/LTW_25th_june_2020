//  DisplayCell.swift
//  Task1
//  Created by vaayoo on 15/11/19.
//  Copyright © 2019 Vaayoo. All rights reserved.

import UIKit

class DisplayCell: UITableViewCell {

    @IBOutlet weak var fullName : UILabel!
    @IBOutlet weak var Images : UIImageView!
    @IBOutlet weak var button : UIButton!
    @IBOutlet weak var score: UILabel!   /* Added By Yashoda on 27th Jan 2020  */

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateFrame(model : model,index: Int){
        Images.image=UIImage(named: "profile") // adding default image
        button.tag=index // adding the index number of the models are to the particular button tag
        fullName.text="\(model.FirstName) \(model.LastName)" //setting FullName as title
        button.setTitle("Review Test", for: .normal)
     
        let Score :Double = model.Score

               
               if Score.isInt == true {
                    score.text = String(format:"%.0f", Score)//It wont show decimal places
                   
               }else{
                    score.text = String(format:"%.2f", Score)//It will show two decimal places
                   
               }
        

        
        //------below for loading the image data by Async
        let url = URL(string: model.ProfileURl);
        if url != nil {
            DispatchQueue.global().async { [weak self] in
                do {
                    var data = Data()
                    data = try (Data(contentsOf: url!) )
                    let image=UIImage(data: data)
                    DispatchQueue.main.async {
                        self?.Images.image=image //assigning the downloaded data to the imageview
                    }
                }catch is Error {
                    print("noo url")
                }
                
            }
        }
        //---------------the below is to creating circle image --------------------
        self.Images.layer.cornerRadius = (self.Images.frame.size.width)/2
        self.Images.clipsToBounds = true
        self.Images.layer.borderWidth = 3.0
        self.Images.layer.borderColor = UIColor.white.cgColor
        
        //---------------------to make button curved------------------
        button.backgroundColor = .clear
        button.layer.cornerRadius = 14
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.orange.cgColor
        
    }
    
}

