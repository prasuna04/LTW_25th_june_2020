//
//  NotificationClassesCell.swift
//  LTW
//
//  Created by vaayoo on 01/07/20.
//  Copyright © 2020 vaayoo. All rights reserved.
//

import UIKit

class NotificationClassesCell: UITableViewCell {
    
    @IBOutlet weak var classDate : UILabel!
    @IBOutlet weak var classTitle : UILabel!
    @IBOutlet weak var grades : UILabel!
    @IBOutlet weak var timings : UILabel!
    @IBOutlet weak var subject : UILabel!
    @IBOutlet weak var joinButton : UIButton!{
        didSet{
            joinButton.layer.cornerRadius = (joinButton.bounds.height - 10) / 2
            joinButton.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        }
    }
    @IBOutlet weak var whiteboardButton : UIButton!{
        didSet{
            whiteboardButton.backgroundColor = .clear
            whiteboardButton.layer.cornerRadius = (whiteboardButton.bounds.height - 10) / 2
            whiteboardButton.layer.borderWidth = 1
            whiteboardButton.layer.borderColor = UIColor.green.cgColor
            whiteboardButton.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        }
    }
    @IBOutlet weak var subscribeUnsubscribeButton : UIButton!{
        didSet{
            subscribeUnsubscribeButton.backgroundColor = .clear
            subscribeUnsubscribeButton.layer.cornerRadius = (subscribeUnsubscribeButton.bounds.height - 10) / 2
            subscribeUnsubscribeButton.layer.borderWidth = 1
            subscribeUnsubscribeButton.layer.borderColor = UIColor.init(hex: "2DA9EC").cgColor
            subscribeUnsubscribeButton.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        }
    }
    @IBOutlet weak var tutorNameLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
