//
//  DynamicLabelHeight.swift
//  LTW
//
//  Created by yashoda on 25/05/20.
//  Copyright © 2020 vaayoo. All rights reserved.
//

import Foundation

class DynamicLabelSize {
    
    static func height (text : NSAttributedString, font : UIFont, width: CGFloat) -> CGFloat {
        
        var currentHeight: CGFloat!
        let label = UILabel(frame: CGRect(x: 0,y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        
        label.attributedText =  text
        label.font =  font
        label.numberOfLines = 0
        label.sizeToFit()
        label.lineBreakMode = .byWordWrapping
        currentHeight = label.frame.height
        label.removeFromSuperview()
        return currentHeight
    }
    
//       static func attributedString (text : String) ->  NSAttributedString {
//        
//        var attributedStr : NSAttributedString!
//        
////       loadMenu(category: text,completion:{(recipe:NSAttributedString?) in
////                                        //   DispatchQueue.main.async {
////
////                                            attributedStr = recipe
////
////                                        //   }
////                                       })
//        
//         DispatchQueue.global(qos: .background).async {
//                       
//            
//            print("************** Inbagground thred **************")
//            attributedStr! = text.htmlToAttributedString!
//            
//            }
//       
//        
//        
//               
//       return  attributedStr!
//         
//    }
//    
   
    
    
}
func loadMenu(category: String, completion:@escaping(NSAttributedString?)->Swift.Void)
     {
         
         
         //        let recipe = category.html2Attributed
         //        completion(recipe)
         
         DispatchQueue.global(qos: .background).async {
             
             let recipe = category.html2Attributed
             DispatchQueue.main.async {
                 
                 completion(recipe)
                 
             }
             
         }
         
     }
