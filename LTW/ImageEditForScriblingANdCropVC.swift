//  ImageEditForScriblingANdCropVC.swift
//  LTW
//  Created by Veeresh on 08/01/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import UIKit
import Mantis

protocol EditImgSender : class {
    func getImg(EditedImg : UIImage)
}




class ImageEditForScriblingANdCropVC: UIViewController ,  CropViewControllerDelegate {
    
    @IBOutlet weak var backgroundImg: UIImageView!
    weak var Delegate : EditImgSender?
    
    @IBOutlet weak var scribbleButton: UIButton! // added by dk on 21st may 2020.
    
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage) {
        backgroundImg.image = cropped
    }
    
    var backgroundImgPassed = UIImage()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImg.image = backgroundImgPassed
        /* Below lines added by dk to hide the scribble button when on crop profile page.*/
        switch self.navigationController?.viewControllers.previous {
        case is SignUpVC :
            scribbleButton.isHidden = true
        case is UserProfileUpdateVC :
            scribbleButton.isHidden = true
        case is CreateNewGrupDscsnVC :
            scribbleButton.isHidden = true
        default :
            scribbleButton.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       // self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.init(hex: "FFFFFF")]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        if (self.navigationController?.navigationBar) != nil {
            self.navigationController!.navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor.init(hex: "2DA9EC")
        }
      //  self.tabBarController?.tabBar.isHidden = false
    }
    @IBAction func done(_ sender: Any) {
        Delegate?.getImg(EditedImg: backgroundImg.image! )
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func scribble(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "InLineScribbleVC") as! InLineScribbleVC
        vc.backgroungImg.image = backgroundImg.image
               vc.Delegate = self
              // vc.modalPresentationStyle = .fullScreen
               self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func crop(_ sender: Any) {
        let config = Mantis.Config()
        let cropViewController = Mantis.cropViewController(image: backgroundImg.image! , config: config)
        cropViewController.modalPresentationStyle = .fullScreen
        cropViewController.delegate = self
        present(cropViewController, animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ImageEditForScriblingANdCropVC : ScribbleImgSender {
    func getImg(scribbleImg: UIImage){
        backgroundImg.image = scribbleImg
    }
}
