//
//  OpenImageSelectionOption.swift
//  DriverApp
//
//  Created by ADMIN on 16/05/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Photos
import CropViewController


class OpenImageSelectionOption: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate, UIDocumentInteractionControllerDelegate, CropViewControllerDelegate, UIDocumentMenuDelegate, MyBtnClickDelegate, FileUploadingDelegate {
    
    
    
    typealias ImageUploadCompletionHandler = (_ isImageUpload:Bool) -> Void
    typealias ImageSelectedCompletionHandler = (_ isImageSelected:Bool) -> Void
    
    var uv:UIViewController!
    
    let generalFunc = GeneralFunctions()
    
    var overlayView:UIView!
    var selectionAreaView:UIView!
    
    var loadingDialog:NBMaterialLoadingDialog!
    let dialog = MTDialog()
    var exeWebServerUrl:ExeServerUrl!
    var imageUploadCompletionHandler:ImageUploadCompletionHandler!
    var imageSelectedCompletionHandler:ImageSelectedCompletionHandler!
    
    var isDocumentUpload = false
    var isUFXServicePhotoChoose = false
    var isUFXGalleryPhotoChoose = false
    var isChooseCategory = false
    var isPreferecneProofUpload = false
    
    var dict_data: [String: String]!
    var selectedFileData:Data!
    
    var fileData:String!
    var fileName = NSString()
    var fileExtension:String!
    
    var cameraTapGue = UITapGestureRecognizer()
    var gallaryTapGue = UITapGestureRecognizer()
    var docPickerTapGue = UITapGestureRecognizer()
    var closeTapGue = UITapGestureRecognizer()
    
    // FileUploading CircleProgressBarView
    var circlePrgressBar:CircleProgressView!
    var totalSizeUpladed:MyLabel!
    
    var isRestaurantPhotoChoose = false
    var cencelUploadation = false
    
    var isGenie = false
    
    init(uv: UIViewController) {
        self.uv = uv
        super.init()
    }
    
    init(uv: UIViewController, dict_data: [String: String]) {
        self.uv = uv
        self.dict_data = dict_data
        super.init()
    }
    
    func setDataParams(dict_data: [String: String]){
        self.dict_data = dict_data
    }
    
    func setImageSelectionHandler(imageSelectedCompletionHandler:@escaping ImageSelectedCompletionHandler){
        self.imageSelectedCompletionHandler = imageSelectedCompletionHandler
    }
    func setImageUploadHandler(imageUploadCompletionHandler:@escaping ImageUploadCompletionHandler){
        self.imageUploadCompletionHandler = imageUploadCompletionHandler
    }
    
    func show(imageUploadCompletionHandler:@escaping ImageUploadCompletionHandler){
        
        
        self.imageUploadCompletionHandler = imageUploadCompletionHandler
        
        let chooseDocumentOptionView = self.generalFunc.loadView(nibName: "ChooseDocumentOptionView")
        chooseDocumentOptionView.frame = CGRect(x:0, y: Application.screenSize.height - 230, width: Application.screenSize.width, height: 240)

        let titleView:MyLabel  = chooseDocumentOptionView.viewWithTag(10) as! MyLabel
        
        chooseDocumentOptionView.frame = CGRect(x:0, y: Application.screenSize.height - 210, width: Application.screenSize.width, height: 220)
        titleView.isHidden = true
        
        
        chooseDocumentOptionView.cornerRadius = 10
        chooseDocumentOptionView.masksToBounds = true
        
        let overlayView = UIView()
        overlayView.frame = CGRect(x:0, y: 0, width: self.uv.view.frame.width, height: Application.screenSize.height)
        overlayView.backgroundColor = UIColor.black
        overlayView.alpha = 0.4
        self.overlayView = overlayView

        chooseDocumentOptionView.layer.shadowOpacity = 0.5
        chooseDocumentOptionView.layer.shadowOffset = CGSize(width: 0, height: 3)
        chooseDocumentOptionView.layer.shadowColor = UIColor.black.cgColor
        
        self.selectionAreaView = chooseDocumentOptionView
        let currentWindow = Application.window
        if(self.uv == nil){
            currentWindow?.addSubview(overlayView)
            currentWindow?.addSubview(chooseDocumentOptionView)
        }else if(self.uv.navigationController != nil){
            self.uv.navigationController?.view.addSubview(overlayView)
            self.uv.navigationController?.view.addSubview(chooseDocumentOptionView)
           // self.uv.navigationController?.navigationBar.layer.zPosition = -1
        }else{
            self.uv.view.addSubview(overlayView)
            self.uv.view.addSubview(chooseDocumentOptionView)
        }

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            overlayView.alpha = 0.4
            chooseDocumentOptionView.alpha = 1
        })
        let topView = chooseDocumentOptionView.viewWithTag(1000) as! UIView
        topView.isHidden = false
        let stackView = chooseDocumentOptionView.viewWithTag(16) as! UIStackView

        let lCamera = chooseDocumentOptionView.viewWithTag(111) as! MyLabel
        lCamera.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CAMERA")
        
        let lGallery = chooseDocumentOptionView.viewWithTag(222) as! MyLabel
        lGallery.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GALLERY")
        
        let lDocument = chooseDocumentOptionView.viewWithTag(333) as! MyLabel
        lDocument.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DOCUMET")
        
        cameraTapGue.addTarget(self, action: #selector(self.cameraTapped))
        let CameraView:UIView = chooseDocumentOptionView.viewWithTag(100) as! UIView
        CameraView.isUserInteractionEnabled = true
        CameraView.addGestureRecognizer(cameraTapGue)
        
        gallaryTapGue.addTarget(self, action: #selector(self.gallaryTapped))
        
        let galleryView:UIView = chooseDocumentOptionView.viewWithTag(200) as! UIView
        galleryView.isUserInteractionEnabled = true
        galleryView.addGestureRecognizer(gallaryTapGue)
        
        docPickerTapGue.addTarget(self, action: #selector(self.docPickerTapped))
        let docView:UIView = chooseDocumentOptionView.viewWithTag(300) as! UIView
        docView.isUserInteractionEnabled = true
        docView.addGestureRecognizer(docPickerTapGue)
        
        if self.uv.isKind(of: EditProfileUV.self){
            chooseDocumentOptionView.frame = CGRect(x:0, y: Application.screenSize.height - 210, width: Application.screenSize.width, height: 220)
            if let myConstraint = stackView.constraintWith(identifier: "StackHeight"){
                myConstraint.constant = 120
                chooseDocumentOptionView.setNeedsLayout()
                chooseDocumentOptionView.layoutSubviews()
            }
        }
        
        if  Application.screenSize.width <= 320 {
            chooseDocumentOptionView.frame = CGRect(x:0, y: Application.screenSize.height - 210, width: Application.screenSize.width, height: 220)
            if let myConstraint = stackView.constraintWith(identifier: "StackHeight"){
                myConstraint.constant = 80
                if self.uv.isKind(of: EditProfileUV.self){
                    chooseDocumentOptionView.frame = CGRect(x:0, y: Application.screenSize.height - 190, width: Application.screenSize.width, height: 200)
                    myConstraint.constant = 100
                }
                chooseDocumentOptionView.setNeedsLayout()
                chooseDocumentOptionView.layoutSubviews()
            }
        }
   
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            CameraView.addShadowWithCornerRadius(cornerRadius: 10, .lightGray, fillColor: .white)
            galleryView.addShadowWithCornerRadius(cornerRadius: 10, .lightGray, fillColor: .white)
            docView.addShadowWithCornerRadius(cornerRadius: 10, .lightGray, fillColor: .white)
        }
        let cancelBtn:MyButton = chooseDocumentOptionView.viewWithTag(400) as! MyButton
        cancelBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT").uppercased())
        cancelBtn.isUserInteractionEnabled = true
        cancelBtn.clickDelegate = self
        cancelBtn.setOnClickListener { (btn) in
            self.closeSlectionView()
        }
        
        if(isChooseCategory != true){
            docView.isHidden = true
        }
    }
    
    func myBtnTapped(sender: MyButton) {
        if sender.tag == 400 {
            self.closeSlectionView()
        }
    }
    
    @objc func closeSlectionView(){
        if(self.overlayView == nil || self.selectionAreaView == nil){
            return
        }
        self.overlayView!.removeFromSuperview()
        self.selectionAreaView!.removeFromSuperview()
    }
    
//    @objc func cameraTapped(){
//        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
//            let imagePickerController = UIImagePickerController()
//            imagePickerController.sourceType = .camera
//            imagePickerController.delegate = self
//            //            imagePickerController.allowsEditing = true
//            self.uv.present(imagePickerController, animated: true, completion: nil)
//        }else{
//            generalFunc.setError(uv: self.uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOT_SUPPORT_CAMERA_TXT"))
//        }
//
//    }

    @objc func cameraTapped(){
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized, .notDetermined: callCamera() // Do your stuff here i.e. callCameraMethod()
        case .denied: alertToEncourageCameraAccessInitially(message: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CAMERA_REQUIRE_TXT"))
        default: alertToEncourageCameraAccessInitially(message: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CAMERA_REQUIRE_TXT"))
        }
    }
    
    func alertToEncourageCameraAccessInitially(message:String) {
        let alert = UIAlertController(
            title: self.generalFunc.getLanguageLabel(origValue: "", key: "IMPORTANT"),
            message: message , //"Camera access required for capturing photos!",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ALLOW_CAMERA_TXT"), style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
            
        }))
        self.uv.present(alert, animated: true, completion: nil)
    }
    
    func callCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            //            imagePickerController.allowsEditing = true
            
            Configurations.setDefaultNavBar()
            self.uv.present(imagePickerController, animated: true, completion: nil)
        }else{
            generalFunc.setError(uv: self.uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOT_SUPPORT_CAMERA_TXT"))
        }
    }
    
    @objc func gallaryTapped(){
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            //            imagePickerController.allowsEditing = true
            Configurations.setDefaultNavBar()
            
//            if #available(iOS 11.0, *) {
//                UINavigationBar.appearance().backgroundColor = UIColor.UCAColor.documentPickerNavColor
//                UIBarButtonItem.appearance().tintColor = UIColor.UCAColor.documentPickerNavColor
//            }
            self.uv.present(imagePickerController, animated: true, completion: nil)
        }else{
            generalFunc.setError(uv: self.uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOT_SUPPORT_GALLARY_TXT"))
        }
    }
    
    @objc func docPickerTapped(){
        //        let types: [String] = [(kUTTypeCompositeContent as String), (kUTTypeImage as String), (kUTTypeJPEG as String), (kUTTypePNG as String), (kUTTypePDF as String)]
        //        let documentMenuVC = UIDocumentMenuViewController(documentTypes: types, in: .import)
        let documentMenuVC = UIDocumentPickerViewController(documentTypes: [(kUTTypeCompositeContent as String), (kUTTypeImage as String), (kUTTypeText as String), (kUTTypePlainText as String), (kUTTypeRTF as String)], in: .import)
        documentMenuVC.delegate = self
        documentMenuVC.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        documentMenuVC.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
        Configurations.setDefaultNavBar()
        
//        if #available(iOS 11.0, *) {
//            documentMenuVC.allowsMultipleSelection = false
//            UINavigationBar.appearance().backgroundColor = UIColor.UCAColor.documentPickerNavColor
//            UIBarButtonItem.appearance().tintColor = UIColor.UCAColor.documentPickerNavColor
//        }
        
        //        UINavigationBar.appearance().backgroundColor = UIColor.UCAColor.documentPickerNavColor
        //        UIBarButtonItem.appearance().tintColor = UIColor.UCAColor.documentPickerNavColor
        
        self.uv.present(documentMenuVC, animated: true, completion: nil)
    }
    
    //MARK - DocumentPickerView Delegate & Datasource Methods
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self.uv
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        Configurations.setAppThemeNavBar()
        if controller.documentPickerMode == UIDocumentPickerMode.import {
            DispatchQueue.main.async {
                
                self.fileName = ""
                self.fileName = (url.lastPathComponent as NSString)
                
                let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                
                let tsite_upload_docs_file_extensions = userProfileJson.get("tsite_upload_docs_file_extensions").trimAll().components(separatedBy: ",")
                
                let fileExtension = self.fileName.pathExtension
                
                if(!tsite_upload_docs_file_extensions.contains(fileExtension)){
                    self.closeSlectionView()
                    self.fileName = ""
                    self.generalFunc.setAlertMessage(uv: self.uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WRONG_FILE_SELECTED_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    })
                }else{
                    if(self.isDocumentUpload == true){
                        let dataTake = NSData(contentsOf: url) as Data?
                        
                        Utils.printLog(msgData: "DataTake::\(String(describing: dataTake))")
                        
                        if(self.imageSelectedCompletionHandler != nil){
                            self.imageSelectedCompletionHandler(true)
                        }
                        self.requestUploadDocument(data: dataTake!)
                    }
                }
            }
        }
    }
    
    func documentInteractionController(_ controller: UIDocumentInteractionController, willBeginSendingToApplication application: String?) {
        Utils.printLog(msgData: "WillBeginSendingToApplication")
    }
    
    func documentInteractionController(_ controller: UIDocumentInteractionController, didEndSendingToApplication application: String?) {
        Utils.printLog(msgData: "We're done sending the document.")
    }
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        self.uv.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        Configurations.setAppThemeNavBar()
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        Configurations.setAppThemeNavBar()
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        Configurations.setAppThemeNavBar()
        var selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        selectedImage = selectedImage.correctlyOrientedImage()
        
        var imgExtension : String!
        
        if picker.sourceType == UIImagePickerController.SourceType.camera {
            self.fileName = String(format:"doc_img.png") as NSString
        }else {
            let assetPath = info[UIImagePickerController.InfoKey.referenceURL] as! NSURL
            imgExtension = ((assetPath.absoluteString?.components(separatedBy: ("ext="))[1])?.lowercased())!
            self.fileName = String(format:"doc_img.%@", imgExtension) as NSString
        }
        
        picker.dismiss(animated: true, completion: {
            if(self.isDocumentUpload == true){
                if(self.imageSelectedCompletionHandler != nil){
                    self.imageSelectedCompletionHandler(true)
                }
                
                DispatchQueue.main.async() {
                    self.requestUploadDocument(data: selectedImage.jpegData(compressionQuality: 1.0)!)
                }
                
            }else if(self.isUFXServicePhotoChoose == true || self.isUFXGalleryPhotoChoose == true){
                self.selectedFileData = selectedImage.jpegData(compressionQuality: 1.0)!
                print(self.selectedFileData as! Data)
                if(self.imageSelectedCompletionHandler != nil){
                    self.imageSelectedCompletionHandler(true)
                }
                
                self.closeSlectionView()
                
            }else if(self.isRestaurantPhotoChoose == true){
                self.selectedFileData = selectedImage.jpegData(compressionQuality: 1.0)!
                
                if(self.imageSelectedCompletionHandler != nil){
                    self.imageSelectedCompletionHandler(true)
                }
                
                self.closeSlectionView()
            }
            else if(self.isPreferecneProofUpload == true){
                           self.selectedFileData = selectedImage.jpegData(compressionQuality: 1.0)!
                           
                           if(self.imageSelectedCompletionHandler != nil){
                               self.imageSelectedCompletionHandler(true)
                           }
                           
                           self.closeSlectionView()
                       }
            else{
                if(selectedImage.size.width < Utils.ImageUpload_MINIMUM_WIDTH || selectedImage.size.height < Utils.ImageUpload_MINIMUM_HEIGHT){
                    self.generalFunc.setError(uv: self.uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MIN_RES_IMAGE"))
                    return
                }
                
                if(self.imageSelectedCompletionHandler != nil){
                    self.imageSelectedCompletionHandler(true)
                }
                
                DispatchQueue.main.async() {
                    let cropViewController = CropViewController(image: selectedImage)
                    cropViewController.delegate = self
                    cropViewController.customAspectRatio = CGSize(width: 1024, height: 1024)
                    
                    cropViewController.aspectRatioLockEnabled = true
                    cropViewController.aspectRatioPickerButtonHidden = true
                    cropViewController.resetAspectRatioEnabled = false
                    cropViewController.showActivitySheetOnDone = false
                    
                    cropViewController.cancelButtonTitle = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT")
                    cropViewController.doneButtonTitle = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DONE")
                    self.uv.present(cropViewController, animated: true, completion: nil)
                }
                
                
                //                DispatchQueue.main.async() {
                //
                //                    let fileData = UIImageJPEGRepresentation(selectedImage.correctlyOrientedImage().cropTo(size: CGSize(width: Utils.ImageUpload_DESIREDWIDTH, height: Utils.ImageUpload_DESIREDHEIGHT)), 1.0)!
                //                    self.requestUploadImage(fileData: fileData, fileName: "UserImage.png")
                //                }
            }
            
        })
        
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        cropViewController.dismiss(animated: true, completion: {
            DispatchQueue.main.async() {
                if(image.size.width < Utils.ImageUpload_MINIMUM_WIDTH || image.size.height < Utils.ImageUpload_MINIMUM_HEIGHT){
                    self.generalFunc.setError(uv: self.uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MIN_RES_IMAGE"))
                    return
                }else{
                    let fileData = image.correctlyOrientedImage().cropTo(size: CGSize(width: Utils.ImageUpload_DESIREDWIDTH, height: Utils.ImageUpload_DESIREDHEIGHT)).jpegData(compressionQuality: 1.0)!
                    self.requestUploadImage(fileData: fileData, fileName: "UserImage.png")
                }
            }
        })
    }
    
    func requestUploadImage(fileData:Data, fileName:String){
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        let SITE_TYPE_DEMO_MSG = userProfileJson.get("SITE_TYPE_DEMO_MSG")
        
        //        if let SITE_TYPE = GeneralFunctions.getValue(key: Utils.SITE_TYPE_KEY) as? String{
        //            if(SITE_TYPE == "Demo"){
        //                self.generalFunc.setError(uv: self.uv, title: "", content: SITE_TYPE_DEMO_MSG)
        //                return
        //            }
        //        }
        
        if let SITE_TYPE = GeneralFunctions.getValue(key: Utils.SITE_TYPE_KEY) as? String{
            if(SITE_TYPE == "Demo" && userProfileJson.get("vEmail") == "driver@gmail.com"){
                self.generalFunc.setError(uv: self.uv, title: "", content: SITE_TYPE_DEMO_MSG)
                return
            }
        }
        
        myImageUploadRequest(image: fileData, fileName: fileName)
    }
    
    func myImageUploadRequest(image:Data, fileName:String){
        let parameters = [
            "type"  : "uploadImage",
            "MemberType"    : Utils.appUserType,
            "iMemberId"    : GeneralFunctions.getMemberd()
        ]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.uv.view, isOpenLoader: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        self.exeWebServerUrl = exeWebServerUrl
        exeWebServerUrl.uploadImage(fileData:image, fileName: fileName, completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                    
                    self.closeSlectionView()
                    
                    if(self.imageUploadCompletionHandler != nil){
                        self.imageUploadCompletionHandler(true)
                    }
                }else if dataDict.get("message") == "" {
                    self.closeSlectionView()
                    self.generalFunc.setError(uv: self.uv)
                }
                else{
                    self.generalFunc.setError(uv: self.uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.closeSlectionView()
                if(self.cencelUploadation != true){
                    self.generalFunc.setError(uv: self.uv)
                }else{
                    self.cencelUploadation = false
                }
            }
        })
    }
    
    func requestUploadDocument(data:Data){
        self.selectedFileData = data
        //        myDocUploadRequest(image: image)
        
        closeSlectionView()
    }
    
    func myDocUploadRequest(fileData:Data, fileName:String){
        let myUrl = URL(string: CommonUtils.webservice_path)
        
        let request = NSMutableURLRequest(url:myUrl!);
        request.httpMethod = "POST"
        
        Utils.printLog(msgData: "SelectedFileName::\(fileName)")
        
        let exeWebServerUrl = ExeServerUrl(dict_data: dict_data, currentView: self.uv.view, isOpenLoader: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.fileUploadingSize = self
        self.exeWebServerUrl = exeWebServerUrl
        showProgressView()
        exeWebServerUrl.uploadImage(fileData: fileData, fileName: fileName) { (response) -> Void in
            
            if(response != ""){
                Utils.printLog(msgData: "responseUploadDOc:\(response)")
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.closeSlectionView()
                    
                    if(self.imageUploadCompletionHandler != nil){
                        self.imageUploadCompletionHandler(true)
                    }
                }else if dataDict.get("message") == "" {
                    self.closeSlectionView()
                    self.generalFunc.setError(uv: self.uv)
                }
                else{
                    self.closeSlectionView()
                    self.generalFunc.setError(uv: self.uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.closeSlectionView()
                if(self.cencelUploadation != true){
                    self.generalFunc.setError(uv: self.uv)
                }else{
                    self.cencelUploadation = false
                }
                
            }
        }
    }
    
    func totalFileSize(Uploaded: Float) {
        if  circlePrgressBar != nil && totalSizeUpladed != nil {
            circlePrgressBar.progress = Double(Uploaded)
            totalSizeUpladed.text = "\(Int(Uploaded * 100))%"
        }
    }

    func showProgressView(){
       // if(isChooseCategory == true){
            let chooseDocumentOptionView = self.generalFunc.loadView(nibName: "ChooseDocumentOptionView")
            let titleView:MyLabel  = chooseDocumentOptionView.viewWithTag(10) as! MyLabel
            titleView.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHOOSE_CATEGORY")
            
            chooseDocumentOptionView.frame = CGRect(x:0, y: Application.screenSize.height - 170 - GeneralFunctions.getSafeAreaInsets().bottom, width: Application.screenSize.width, height: 200 + GeneralFunctions.getSafeAreaInsets().bottom)
            chooseDocumentOptionView.cornerRadius = 10
            chooseDocumentOptionView.masksToBounds = true
            
            let overlayView = UIView()
            overlayView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: Application.screenSize.height)
            
            overlayView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)
            overlayView.backgroundColor = UIColor.black
            overlayView.alpha = 0.4
            self.overlayView = overlayView
            self.selectionAreaView = chooseDocumentOptionView
            chooseDocumentOptionView.layer.shadowOpacity = 0.5
            chooseDocumentOptionView.layer.shadowOffset = CGSize(width: 0, height: 3)
            chooseDocumentOptionView.layer.shadowColor = UIColor.black.cgColor
            let currentWindow = Application.window
            if(self.uv == nil){
                
                UIView.transition(with: self.uv.view, duration: 0.25, options: .transitionCrossDissolve, animations: {
                    currentWindow?.addSubview(overlayView)
                    currentWindow?.addSubview(chooseDocumentOptionView)
                }, completion: nil)
                
            }else if(self.uv.navigationController != nil){
                UIView.transition(with: self.uv.navigationController?.view ?? self.uv.view, duration: 0.25, options: .transitionCrossDissolve, animations: {
                    self.uv.navigationController?.view.addSubview(overlayView)
                    self.uv.navigationController?.view.addSubview(chooseDocumentOptionView)
                    self.uv.navigationController?.navigationBar.layer.zPosition = -1
                }, completion: nil)
                
            }else{
                
                UIView.transition(with: self.uv.view, duration: 0.25, options: .transitionCrossDissolve, animations: {
                    self.uv.view.addSubview(overlayView)
                    self.uv.view.addSubview(chooseDocumentOptionView)
                }, completion: nil)
                
            }
            
            let topView:UIView = chooseDocumentOptionView.viewWithTag(500) as! UIView
            topView.isHidden = false
            circlePrgressBar = chooseDocumentOptionView.viewWithTag(501) as! CircleProgressView
            circlePrgressBar.trackFillColor = UIColor.UCAColor.AppThemeColor
            
            totalSizeUpladed = chooseDocumentOptionView.viewWithTag(502) as! MyLabel
            self.totalSizeUpladed.text = ""
            
            let titleLabel = chooseDocumentOptionView.viewWithTag(503) as! MyLabel
            titleLabel.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PLEASE_WAIT")
            let SubTitleLabel = chooseDocumentOptionView.viewWithTag(504) as! MyLabel
        
            if(self.isGenie) {
                SubTitleLabel.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GENIE_IMAGE_UPLOADING")
            }else{
                SubTitleLabel.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DOCUMET_UPLOADING")
            }
            
            let closeImg = chooseDocumentOptionView.viewWithTag(15) as! UIImageView
            
            closeImg.isHidden = true
            closeImg.setOnClickListener { (close) in
                
                if(self.circlePrgressBar.progress < 1){
                    self.generalFunc.setAlertMessage(uv: self.uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SURE_CANCEL_UPLOAD"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_OK"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                        
                        if btnClickedIndex == 0 {
                            
                            if (self.exeWebServerUrl != nil && self.circlePrgressBar.progress < 1) {
                                self.cencelUploadation = true
                                self.exeWebServerUrl.cancel()
                            }
                        }
                        
                    })
                }
                
            }
        //}
    }
}

extension Data {
    var format: String {
        let array = [UInt8](self)
        let ext: String
        switch (array[0]) {
        case 0xff:
            ext = ".jpeg"
            break
        case 0x25:
            ext = ".pdf"
            break
        case 0x46:
            ext = ".txt"
            break
        case 0x47:
            ext = ".gif"
            break
        case 0x89:
            ext = ".png"
            break
        case 0x49, 0x4d:
            ext = ".tiff"
            break
        default:
            ext = ".doc"
        }
        return ext
    }
}
