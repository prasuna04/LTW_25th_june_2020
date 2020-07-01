//  AzureUpload.swift
//  LTW
//  Created by vaayoo on 19/07/18.
//  Copyright © 2018 vaayoo. All rights reserved.


import UIKit
import AZSClient
import Alamofire
class AzureUpload: NSObject {
    func updateServer(url: String) {
        let header = ["Content-Type": "application/json"]
        Alamofire.request(url,headers: header).responseJSON { response in
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    if let value = response.result.value{
                        //let json = JSON(value)
                        //print("Updated azure file uploading to mobile service")
                    }
                }
                break
            case .failure(_):
                print("Failure : \(response.result.error!)")
                break
            }
        }
    }

    /*
    func uploadBlobToContainer(filePathArray: Array<Any>)
    {
        DispatchQueue.main.async {
            for filePathName in filePathArray {
                do
                {
                    let account  = try AZSCloudStorageAccount.init(fromConnectionString: "DefaultEndpointsProtocol=https;AccountName=nomuploadcontents;AccountKey=yfs6DFxmsPimdxrFLTRg9WzwZ8qx5QshcPxboT79t/Tfr+z9KiH1ftpVTDFkqjQqtN3ly2PU4vQz15DU6YGcqg==;EndpointSuffix=core.windows.net")
                    
                    let blobClient: AZSCloudBlobClient = account.getBlobClient()
                    let blobContainer: AZSCloudBlobContainer = blobClient.containerReference(fromName: "originalimages")
                    blobContainer.createContainerIfNotExists(with: AZSContainerPublicAccessType.container, requestOptions: nil, operationContext: nil) { (NSError, Bool) -> Void in
                        if ((NSError) != nil)
                        {
                            NSLog("Error in creating container.")
                        }
                        else
                        {
                            
                            //
//                            let urlFilePath = URL.init(string: filePathName as! String)
                            let fileName = (filePathName as! NSString).lastPathComponent
                            let blob: AZSCloudBlockBlob = blobContainer.blockBlobReference(fromName: fileName) //If you want a random name, I used let imageName = CFUUIDCreateString(nil, CFUUIDCreate(nil))
                            let mainPath = AppConstants().getImagesFolder()
                            let appendImagePath = "\(mainPath)/\(fileName)"
                            blob.uploadFromFile(withPath: appendImagePath , completionHandler: { (error1) in
//                                self.updateServer(url: "http://realtorservice.azurewebsites.net/api/v1/UpdateUrl?url=https://realtorstorage.blob.core.windows.net/actualimages/\(String(describing: fileName!))")
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
    }
    */
    func uploadBlobToContainer(filePathArray: [String], containerType: String) // Container for??
    {
//        DispatchQueue.main.async {
            for filePathName in filePathArray {
                do
                {
                    /*
                     credential = [AuthenticationCredential credentialWithAzureServiceAccount:@"nomuploadcontents" accessKey:@"yfs6DFxmsPimdxrFLTRg9WzwZ8qx5QshcPxboT79t/Tfr+z9KiH1ftpVTDFkqjQqtN3ly2PU4vQz15DU6YGcqg=="];
                     
                     ContainerForImages = [[BlobContainer alloc] initContainerWithName:@"originalimages" URL:@"https://nomuploadcontents.blob.core.windows.net/originalimages" metadata:NULL];
                     ContainerForVideos = [[BlobContainer alloc] initContainerWithName:@"videos" URL:@"https://nomuploadcontents.blob.core.windows.net/videos" metadata:NULL];
                     ContainerForThumbnails = [[BlobContainer alloc] initContainerWithName:@"thumbnails" URL:@"https://nomuploadcontents.blob.core.windows.net/thumbnails" metadata:NULL];
                     ContainerForDocuments = [[BlobContainer alloc] initContainerWithName:@"documents" URL:@"https://nomuploadcontents.blob.core.windows.net/documents" metadata:NULL];
                     
                    
                     
                     */
                    let account  = try AZSCloudStorageAccount.init(fromConnectionString: "DefaultEndpointsProtocol=https;AccountName=ltwuploadcontent;AccountKey=2Xow/VeJlNL75DVsiNorwP9B9CGWp0eDb7V4xBTcqy5VcWbDHsj29jtA/61j0m5l8Ns0cJZG1poi1WghhJB5kA==")
                    
                    let blobClient: AZSCloudBlobClient = account.getBlobClient()
                    var blobContainer: AZSCloudBlobContainer!
                    if containerType == "Images"{
                        blobContainer = blobClient.containerReference(fromName: "actualimages")
                    }
                    else if containerType == "Thumbnails"{
                        blobContainer = blobClient.containerReference(fromName: "thumbnails")
                    }
                    else if containerType == "Videos"{
                        blobContainer = blobClient.containerReference(fromName: "videos")
                    }
                        else if containerType == "tutorresume"{
                            blobContainer = blobClient.containerReference(fromName: "tutorresume")
                        }
                    else{
                        blobContainer = blobClient.containerReference(fromName: "documents")
                    }
                    blobContainer.createContainerIfNotExists(with: AZSContainerPublicAccessType.container, requestOptions: nil, operationContext: nil) { (NSError, Bool) -> Void in
                        if ((NSError) != nil)
                        {
                            NSLog("Error in creating container.")
                        }
                        else
                        {
                            
                            /*
                             From Now onwards.. upload images and videos different container..
                             
                             https://nom4storage.blob.core.windows.net/nom4actual
                             https://nom4storage.blob.core.windows.net/nom4thumb/
                             
                             */
                            //
                            //                            let urlFilePath = URL.init(string: filePathName as! String)
                            let fileName = (filePathName as NSString).lastPathComponent
                            let blob: AZSCloudBlockBlob = blobContainer.blockBlobReference(fromName: fileName) //If you want a random name, I used let imageName = CFUUIDCreateString(nil, CFUUIDCreate(nil))
//                            let mainPath = AppConstants().getImagesFolder()
//                            let appendImagePath = "\(mainPath)/\(fileName)"
                            
                            var mainPath: NSString!
                            if fileName.contains(".mp4"){
                                mainPath = AppConstants().getVideosFolder()
                            }
                            else if fileName.contains(".jpg"){
                                
                                mainPath = AppConstants().getImagesFolder()
                            }
                            else{
                                
                                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                                let documentsDirectory = paths[0]
                                mainPath = "\(documentsDirectory)/PDF_Documents" as NSString
                            }
                            
                            let appendImagePath = "\(mainPath ?? "")/\(fileName)"
                            blob.uploadFromFile(withPath: appendImagePath , completionHandler: { (error1) in
                                
                                if containerType == "Videos"{
                                    
                                    self.updateServer(url: "https://nom4storage.blob.core.windows.net/videos/\(fileName)")
                                    
                                }
                                else if containerType == "Document"{
                                    
                                    self.updateServer(url: "https://nomuploadcontents.blob.core.windows.net/documents/\(fileName)")
                                    
                                }
                                
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
            
//        }
    }
}
