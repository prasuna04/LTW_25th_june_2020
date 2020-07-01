//  GroupInfoTableViewCell.swift
//  Alamofire
//  Created by vaayoo on 15/10/19.

import UIKit

class GroupInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var profileimg:UIImageView!{didSet{
        profileimg.setRounded()
        }}
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var personType:UILabel!
    @IBOutlet weak var delete:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}
