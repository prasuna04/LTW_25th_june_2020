//  AnswerCell.swift
//  LTW
//  Created by Ranjeet Raushan on 09/05/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import WebKit /* Added By Veeresh on 26th Dec 2019 */

class AnswerCell: UITableViewCell, UIWebViewDelegate, WKNavigationDelegate { /* Added UIWebViewDelegate, WKNavigationDelegate By Veeresh on 26th Dec 2019 */
    @IBOutlet weak var personImgVw: UIImageView!{
        didSet{
            personImgVw.setRounded()
            personImgVw.clipsToBounds = true
        }
    }
   @IBOutlet weak var  viewRelatedToImageInAnsrsScreen: UIView!
    @IBOutlet weak var datLbl: UILabel!
    @IBOutlet weak var personNameLbl: UILabel!
    @IBOutlet weak var scholLbl: UILabel!
    @IBOutlet weak var personTypLbl: UILabel!
  //  @IBOutlet weak var textAnswerLbl: UILabel! /* Outlet removed by Veeresh on 26th  Dec 2019 , Don't remove this line, future might reuse */
    @IBOutlet weak var upVoteBtn: UIButton!
    @IBOutlet weak var spamBtn: UIButton!
    @IBOutlet weak var webView: WKWebView! /* Added By Veeresh on 19th Dec 2019 */
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
