//
//  EventCell.swift
//  task7
//
//  Created by vaayoo on 20/01/20.
//  Copyright © 2020 Vaayoo. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
 @IBOutlet weak var unsubscribeBtn: UIButton!{
        didSet{
            unsubscribeBtn.layer.borderColor = UIColor.init(hex: "2DA9EC").cgColor
             unsubscribeBtn.layer.borderWidth = 2
            unsubscribeBtn.layer.cornerRadius = 14
        }
    }
    @IBOutlet weak var joinBtn: UIButton!
    {
        didSet{
            joinBtn.layer.borderColor = UIColor.init(hex: "7DC20B").cgColor
             joinBtn.layer.borderWidth = 2
            joinBtn.layer.cornerRadius = 14
        }
    }
    
    @IBOutlet weak var whiteBoardBtn: UIButton!
    {
           didSet{
               whiteBoardBtn.layer.borderColor = UIColor.init(hex: "7DC20B").cgColor //init(hex: "2DA9EC")
            whiteBoardBtn.layer.borderWidth = 2
               whiteBoardBtn.layer.cornerRadius = 14
           }
       }
    @IBOutlet weak var topicLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var gradeLbl: UILabel!
    @IBOutlet weak var tittleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.shadowRadius = 3
        self.layer.cornerRadius = 4
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
