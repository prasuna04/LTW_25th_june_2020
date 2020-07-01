//  ViewController.swift
//  task8
//  Created by Vaayoo on 03/03/20.
//  Copyright © 2020 Vaayoo. All rights reserved.

import UIKit

class tourSlidesVC: UIViewController {
    
    @IBOutlet var skipBtn: UIButton!
    @IBOutlet var leftBtn: UIButton!
    @IBOutlet var rightBtn: UIButton!
    
    var imagesArray : [UIImage] = []
    var images : [UIImageView] = []
    var currentIndex = 0
    var views = UIView()
    var personType = Int( UserDefaults.standard.string(forKey: "persontyp") ?? "0" )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var prefixStr = String()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: prefixStr = "tutor"
        case .pad : prefixStr = "tutor-ipad"
        default:
            print("i know it won't come here")
        }
        imagesArray = createImageArray(withPersonType: personType!, withPrefix: prefixStr)
        for i in 0..<imagesArray.count {
            let img  = imagesArray[i]
            let a = UIImageView(image: img)
            a.isUserInteractionEnabled = true
            let swipeRight = UISwipeGestureRecognizer(target: self, action: Selector(("respondToSwipeGesture:")))
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            a.addGestureRecognizer(swipeRight)
            let swipeDown = UISwipeGestureRecognizer(target: self, action: Selector(("respondToSwipeGesture:")))
            swipeDown.direction = UISwipeGestureRecognizer.Direction.left
            a.addGestureRecognizer(swipeDown)
            for j in 0...2 {
                if i==0 && j == 0{
                    continue
                }
                if i==imagesArray.count-1 && j==1{
                    let btn  = giveButton(for: 1)
                    btn.tag = 3
                    btn.setTitle("Done", for: .normal) ;  btn.setTitleColor(UIColor.init(hex: "2DA9EC"), for: .normal)
                    btn.setImage(UIImage(), for: .normal)
                    a.addSubview(btn)
                    continue
                }
                if  i==imagesArray.count-1 && j==2{
                    continue
                }
                    a.addSubview(giveButton(for: j))
            }
            images.append(a)
        }
        for i in 0..<images.count {
            let temp = images[i]
            if i == 0 {
                images[0].frame = CGRect(x: 0, y: 0, width: view.frame.width  , height: view.frame.height  )
            }
            else {
                images[i].frame = CGRect(x: -view.frame.width , y: 0, width: view.frame.width  , height: view.frame.height  )
            }
            view.addSubview(temp)
        }
    }
    func giveButton(for no: Int)-> UIButton{
        let  btn = UIButton() ; btn.isUserInteractionEnabled = true
        btn.backgroundColor = UIColor.clear
        btn.frame = CGRect(x: (no == 1 ? view.frame.width - view.frame.width/5  : 0) , y: view.frame.height - view.frame.height/8 , width: view.frame.width/5, height: view.frame.height/8 )
         btn.setImage(UIImage(named: "arrow-\(no == 1 ? "right" : "left")"), for: .normal)
        if no == 2{
            btn.frame.origin.x =  view.frame.width - view.frame.width/5 ;  btn.frame.origin.y = 0
            btn.setTitle("Skip", for: .normal) ; btn.setImage(UIImage(), for: .normal)
            btn.setTitleColor(UIColor.init(hex: "2DA9EC"), for: .normal)
            btn.titleLabel?.frame = btn.frame
        }
        btn.imageView?.contentMode = .scaleToFill
        btn.addTarget(self, action: #selector(onBtnClick), for: .touchUpInside)
        btn.tag = no
        return btn
    }
    func skiped(){
        UIApplication.shared.keyWindow!.rootViewController!.dismiss(animated: true, completion: nil)
        UIApplication.shared.keyWindow?.rootViewController = VSCore().launchHomePage(index: 0)
    }
   @IBAction func onBtnClick(_ sender : UIButton){
        sender.tag == 1 ? moveForward() : sender.tag == 0 ? moveBackward() : skiped()
    }
    @objc func respondToSwipeGesture(_ gesture : UIGestureRecognizer ){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .left : moveForward()
            case .right :moveBackward()
            default:
                print("it won't come here i know")
            }
        }
    }
    func moveForward(){
        currentIndex += 1
        print(currentIndex)
        if currentIndex < 5 {
            self.images[self.currentIndex].frame = CGRect(x: view.frame.width  , y: 0 , width: view.frame.width  , height: view.frame.height  )
            UIView.animate(withDuration: 0.55, delay: 0.0, options: .curveEaseInOut , animations: {
                var nextImageFrame = self.images[self.currentIndex].frame
                nextImageFrame.origin.x -= nextImageFrame.size.width
                var backImageFrame = self.images[self.currentIndex-1].frame
                backImageFrame.origin.x -= backImageFrame.size.width
                self.images[self.currentIndex-1].frame = backImageFrame
                self.images[self.currentIndex].frame = nextImageFrame
            }, completion: { finished in
                print("moved forward")
            })
        }else { currentIndex -= 1}
    }
    func moveBackward(){
        currentIndex -= 1
        print(currentIndex)
        if currentIndex >= 0 {
            self.images[self.currentIndex].alpha = 1
            self.images[self.currentIndex].frame = CGRect(x: -view.frame.width  , y: 0 , width: view.frame.width  , height: view.frame.height/* - 160*/ )
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear , animations: {
                var nextImageFrame = self.images[self.currentIndex].frame
                nextImageFrame.origin.x += nextImageFrame.size.width
                var backImageFrame = self.images[self.currentIndex+1].frame
                backImageFrame.origin.x += backImageFrame.size.width
                self.images[self.currentIndex+1].frame = backImageFrame
                self.images[self.currentIndex].frame = nextImageFrame
            }, completion: { finished in
                print("moved backward")
            })
        }else { currentIndex += 1}
    }
    func createImageArray(withPersonType no : Int , withPrefix str : String )-> [UIImage]{
        var images = [UIImage]()
        for i in 1...5 {
            var name = String()
            if (i==3 || i==4) && no == 1 {
                let temp = str.replacingOccurrences(of: "tutor", with: "student")
                name = "\(temp)-\(i)"
            }
            else {
                name = "\(str)-\(i)"
            }
            images.append(UIImage(named: name)!)
        }
        return images
    }
}
