//  AzureUploadUtil.swift
//  LTW
//  Created by Ranjeet Raushan on 14/05/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import AZSClient
import Alamofire
import SwiftyJSON
class AzureUploadUtil: NSObject {
    
    func uploadBlobToContainer(filePathArray: Array<Any>){
            for filePathName in filePathArray {
                do
                {
                   let account  = try AZSCloudStorageAccount.init(fromConnectionString: "DefaultEndpointsProtocol=https;AccountName=ltwuploadcontent;AccountKey=2Xow/VeJlNL75DVsiNorwP9B9CGWp0eDb7V4xBTcqy5VcWbDHsj29jtA/61j0m5l8Ns0cJZG1poi1WghhJB5kA==")
                    
                    let blobClient: AZSCloudBlobClient = account.getBlobClient()
                    let blobContainer: AZSCloudBlobContainer = blobClient.containerReference(fromName: "actualimages")
                    blobContainer.createContainerIfNotExists(with: AZSContainerPublicAccessType.container, requestOptions: nil, operationContext: nil) { (NSError, Bool) -> Void in
                        if ((NSError) != nil)
                        {
                            NSLog("Error in creating container.")
                        }
                        else
                        {
                            let urlFilePath = URL.init(string: filePathName as! String)
                            let fileName = urlFilePath?.lastPathComponent
                            let blob: AZSCloudBlockBlob = blobContainer.blockBlobReference(fromName: fileName!)
                            let mainPath = ImagePicker().getImagesFolder()
                            let appendImagePath = "\(mainPath)/\(fileName!)"
                            blob.uploadFromFile(withPath: appendImagePath , completionHandler: { (error1) in
                            print("Image file uploaded successfully...")
                            })
                        }
                    }
                }
                catch {
                    let fetchError = error as NSError
                     print("AZSCloudBlobClient----->%@",fetchError)
                    continue
                }
            }
    }
    
    func updateServer(url: String) {
    
    // intract with mobile service
    let headers: HTTPHeaders = [
         "Content-Type": "application/json"
    ]
        
        
        Alamofire.request(url,headers: headers).responseJSON { response in
            
            switch(response.result) {
                
            case .success(_):
                if response.result.value != nil{
                    
                }
                break
                
            case .failure(_):
                print("Failure : \(response.result.error!)")
                break
                
            }
        }
        
    }
    
}
