 //
//  UploadDocUV.swift
//  DriverApp
//
//  Created by ADMIN on 03/06/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit
import SafariServices

protocol FileUploadingDelegate {
    func totalFileSize(Uploaded:Float)
}

class UploadDocUV: UIViewController, MyBtnClickDelegate, MyLabelClickDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var docHLbl: MyLabel!
    @IBOutlet weak var lblExpTitle: MyLabel!
    @IBOutlet weak var lblExpDate: MyLabel!
    
    @IBOutlet weak var txtViewdisableUpdateDoc: UITextView!
    @IBOutlet weak var CalenderImgView: UIImageView!
    @IBOutlet weak var downImgView: UIImageView!
    @IBOutlet weak var expDateTxtField: MyLabel!
    @IBOutlet weak var takePhotoImgView: UIImageView!
    @IBOutlet weak var continueBtn: MyButton!
    @IBOutlet weak var docSelectedImgBgView: UIView!
    @IBOutlet weak var docSelectedCheckImgView: UIImageView!
    @IBOutlet weak var ExpiryView: UIView!
    @IBOutlet weak var ExpiryViewHeight: NSLayoutConstraint!  // Default 85  when Hide ExpiryDate = 00
    @IBOutlet weak var EditViewImage: UIView!
    @IBOutlet weak var editLbl: MyLabel!
    @IBOutlet weak var viewLbl: MyLabel!
    @IBOutlet weak var seprator: UIView!
    var docUrl = ""
    let generalFunc = GeneralFunctions()
    
    let photoImgTapGue = UITapGestureRecognizer()
    
    var dataDict:NSDictionary!
    
    var openImgSelection:OpenImageSelectionOption!
    
    var listOfDocumentUv:ListOfDocumentUV!
    
    var DOC_TYPE = "driver"
    var iDriverVehicleId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.addSubview(self.generalFunc.loadView(nibName: "UploadDocScreenDesign", uv: self, contentView: contentView))
        
        self.addBackBarBtn()
        setData()
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        Configurations.setAppThemeNavBar()
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        headView.addShadowWithCornerRadius(cornerRadius: 5, .lightGray, 0.3, fillColor: .white)
    }
    
    func setData(){
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "Upload Document", key: "LBL_UPLOAD_DOC")
        self.title = self.generalFunc.getLanguageLabel(origValue: "Upload Document", key: "LBL_UPLOAD_DOC")
        
        self.docHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Select Document", key: "LBL_SELECT_DOC")
        
        //        photoImgTapGue.addTarget(self, action: #selector(self.photoImgTapped))
        //        takePhotoImgView.isUserInteractionEnabled = true
        //        takePhotoImgView.addGestureRecognizer(photoImgTapGue)
        self.lblExpTitle.text = self.generalFunc.getLanguageLabel(origValue: "Expiry Date", key: "LBL_EXPIRY_DATE")
        GeneralFunctions.setImgTintColor(imgView: CalenderImgView, color: UIColor.UCAColor.AppThemeColor)
        GeneralFunctions.setImgTintColor(imgView: downImgView, color: UIColor.UCAColor.grey_image_tint_color)
        if Configurations.isRTLMode() {
            self.txtViewdisableUpdateDoc.textAlignment = .right
        }else{
            self.txtViewdisableUpdateDoc.textAlignment = .left
        }
        if(self.dataDict.get("ex_status") == "yes"){
            if(self.dataDict.get("allow_date_change").uppercased() == "NO") {
                self.continueBtn.isBtnEnabled = false
                self.continueBtn.alpha = 0.5
                self.txtViewdisableUpdateDoc.isHidden = false
                self.txtViewdisableUpdateDoc.text = self.dataDict.get("doc_update_disable")
            }
            expDateTxtField.isHidden = false
            self.expDateTxtField.text = self.generalFunc.getLanguageLabel(origValue: "Select", key: "LBL_SELECT_TXT")
            if(self.dataDict.get("ex_date") != ""){
                self.lblExpDate.text = self.dataDict.get("ex_date")
            }else {
                self.lblExpDate.text  = ""
            }
        }else{
            
            self.txtViewdisableUpdateDoc.isHidden = true
            ExpiryView.isHidden = true
            ExpiryViewHeight.constant = 0
        }
        
        self.continueBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SUBMIT_TXT"))
        self.continueBtn.clickDelegate = self
        
        self.docHLbl.setClickDelegate(clickDelegate: self)
        docSelectedImgBgView.backgroundColor = UIColor.UCAColor.AppThemeTxtColor
        GeneralFunctions.setImgTintColor(imgView: docSelectedCheckImgView, color: UIColor.UCAColor.AppThemeColor)
        
        docSelectedImgBgView.isHidden = true
        docSelectedCheckImgView.isHidden = true
         self.EditViewImage.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        viewLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VIEW")
        editLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EDIT")
        takePhotoImgView.setOnClickListener { (Lbl) in
            self.photoImgTapped()
        }
        
        editLbl.setOnClickListener { (Lbl) in
            self.photoImgTapped()
        }
        
        viewLbl.setOnClickListener { (viewImg) in
            if let url = URL(string: self.dataDict.get("vimage")) {
                    let svc = SFSafariViewController(url: url)
                    self.present(svc, animated: true, completion: nil)
            }
        }
        
        if(self.dataDict.get("doc_file") != ""){
            EditViewImage.isHidden = false
            viewLbl.isHidden = false
            editLbl.isHidden = false
            seprator.isHidden = false
            self.docSelectedImgBgView.isHidden = false
            self.docSelectedCheckImgView.isHidden = false
            self.takePhotoImgView.image = UIImage(named: "ic_card")
            self.takePhotoImgView.alpha = 0.5
        }
        
        ExpiryView.setOnClickListener { (view) in
            let minDate = Calendar(identifier: Configurations.getCalendarIdentifire()).date(byAdding: .hour, value: 1, to: Date())
                DatePickerDialog().show(self.generalFunc.getLanguageLabel(origValue: "Expiry Date", key: "LBL_EXPIRY_DATE"), doneButtonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_TXT"), cancelButtonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), minimumDate: minDate, datePickerMode: .date) {
                    (date) -> Void in
                    if(date != nil){
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "en_GB")
                        dateFormatter.dateFormat = "YYYY-MM-dd"
                        let dateString = dateFormatter.string(from: date!)
                        
                        self.lblExpDate.text = dateString
                    }
            }
        }
    }
    
    func myLableTapped(sender: MyLabel) {
        if(sender == self.docHLbl){
            photoImgTapped()
        }
    }
    
    @objc func photoImgTapped(){
        
        self.openImgSelection = OpenImageSelectionOption(uv: self)
        self.openImgSelection.isDocumentUpload = true
        self.openImgSelection.isChooseCategory = true
        self.openImgSelection.setImageSelectionHandler { (isImageSelected) in
            if(isImageSelected){
                self.docSelectedImgBgView.isHidden = false
                self.docSelectedCheckImgView.isHidden = false
                self.takePhotoImgView.alpha = 0.5
                self.EditViewImage.isHidden = false
                self.editLbl.isHidden = false
            }
        }
        self.openImgSelection.show { (isImageUpload) in
            if(isImageUpload == true){
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Your document is uploaded successfully", key: "LBL_UPLOAD_DOC_SUCCESS"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    self.performSegue(withIdentifier: "unwindToDocumentList", sender: self)
                    
                })
            }
        }
    }
    
    func myBtnTapped(sender: MyButton) {
        if(sender == self.continueBtn){
            
            if(self.dataDict.get("ex_status") == "yes"){
                
                if(lblExpDate.text?.trimmingCharacters(in: .whitespaces) == ""){
                    Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "Expiry date is required.", key: "LBL_EXP_DATE_REQUIRED"), uv: self)
                    return
                }
            }
            
            if(self.dataDict.get("doc_file") == "" && (self.openImgSelection == nil || self.openImgSelection.selectedFileData == nil)){
                Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "Please attach your document.", key: "LBL_SELECT_DOC_ERROR"), uv: self)
                return
            }

            let parameters = [
                "type"  : "uploaddrivedocument",
                "MemberType"    : Utils.appUserType,
                "iMemberId"    : GeneralFunctions.getMemberd(),
                "doc_usertype": self.DOC_TYPE,
                "doc_masterid": "\(self.dataDict.get("masterid"))",
                "doc_name": "\(self.dataDict.get("doc_name"))",
                "doc_id": "\(self.dataDict.get("doc_id"))",
                "iDriverVehicleId": "\(self.iDriverVehicleId)",
                "doc_file":"\(self.openImgSelection == nil ? self.dataDict.get("doc_file") : (self.openImgSelection.selectedFileData == nil ? self.dataDict.get("doc_file") : ""))",
                "ex_date": self.dataDict.get("ex_status") == "yes" ? lblExpDate.text! : ""
                
            ]
            if(self.openImgSelection == nil){
                self.openImgSelection = OpenImageSelectionOption(uv: self)
                self.openImgSelection.isDocumentUpload = true
                self.openImgSelection.isChooseCategory = true
                //                UIImagePNGRepresentation
                //                self.openImgSelection.selectedFileData = UIImagePNGRepresentation(UIImage(named: "ic_trans")!)!
                
                //                  UIImageJPEGRepresentation
                self.openImgSelection.selectedFileData = (UIImage(named: "ic_trans")!).jpegData(compressionQuality: 1.0)
                self.openImgSelection.setImageUploadHandler(imageUploadCompletionHandler: { (isImageUpload) in
                    if(isImageUpload == true){
                        
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Your document is uploaded successfully", key: "LBL_UPLOAD_DOC_SUCCESS"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            self.performSegue(withIdentifier: "unwindToDocumentList", sender: self)
                            
                        })
                    }
                })
            }
            self.openImgSelection.setDataParams(dict_data: parameters)
            //            self.openImgSelection.myDocUploadRequest(fileData: self.openImgSelection.selectedFileData, fileName: "UserDoc.png")
            
            print("Images = ", self.openImgSelection.selectedFileData)
            print("Doc = ", self.dataDict.get("doc_file").data(using: .utf8))
            
            self.openImgSelection.myDocUploadRequest(fileData: (self.openImgSelection.selectedFileData == nil ? self.dataDict.get("doc_file").data(using: .utf8) : self.openImgSelection.selectedFileData)!, fileName: self.openImgSelection.fileName as String == "" ? self.dataDict.get("doc_file") as String : self.openImgSelection.fileName as String)
            
        }
    }

    
}
