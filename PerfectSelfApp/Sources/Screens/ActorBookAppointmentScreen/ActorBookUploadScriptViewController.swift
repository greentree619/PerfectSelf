//
//  ActorBookAppointmentViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActorBookUploadScriptViewController: UIViewController, UIDocumentPickerDelegate {

    var readerUid: String = ""
    var readerName: String = ""
    var bookingStartTime: String = ""
    var bookingEndTime: String = ""
    var bookingDate: String = ""
    var scriptBucket = ""
    var scriptKey = ""
    let txtScriptPlaceHolder = "Paste Text Script Here"
    
    @IBOutlet weak var lbl_readerName: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var text_script: UITextView!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var policyText: UITextView!
    @IBOutlet weak var agreePolicyCheckBox: CheckBox!
    @IBOutlet weak var projectNameText: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lbl_readerName.text = "Reading with \(readerName)"
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        df.timeZone = TimeZone(abbreviation: "EST")
        let estDate = df.date(from: bookingDate + bookingStartTime) ?? Date()
        df.dateFormat = "hh:mm a"
        let t = df.string(from: estDate)
        df.dateFormat = "MMMM dd, yyyy"
        let d = df.string(from: estDate)
        lbl_time.text = "Time: \(t) EST"
        lbl_date.text = "Date: \(d)"
        
        text_script.delegate = self
        text_script.text = txtScriptPlaceHolder
        text_script.textColor = UIColor.lightGray
        
        projectNameText.text = ""
        
        //{{Script sharing policy
        self.policyText.textContainer.maximumNumberOfLines = 1
        //self.policyText.textContainer.lineBreakMode = .byTruncatingTail
        let attributedString = NSMutableAttributedString(string: "I acknowledge the script sharing policy.")
        let url = URL(string: sharingPolicyLink)!//"https://www.apple.com"

        // Set the 'click here' substring to be the link
        attributedString.setAttributes([.link: url], range: NSMakeRange(19, 21))

        self.policyText.attributedText = attributedString
        self.policyText.isUserInteractionEnabled = true
        self.policyText.isEditable = false

        // Set how links should appear: blue and underlined
        self.policyText.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        //}}Script sharing policy
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        self.policyText.centerVertically()
    }

    @IBAction func UploadScriptFile(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        documentPicker.delegate = self
        self.present(documentPicker, animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        let uuid = UUID().uuidString
        showIndicator(sender: nil, viewController: self, color: UIColor.white)
        awsUpload.uploadScript(filePath: urls[0], bucketName: SCRIPT_BUCKET, prefix: "\(uuid)") { (error: Error?) -> Void in
            DispatchQueue.main.async {
                hideIndicator(sender: nil)
            }
            if error == nil {
                // do something with url
                //Omitted let url = "https://perfect-reader-video-bucket.s3.us-east-2.amazonaws.com/actor-script/\(uuid)/\(String(urls[0].lastPathComponent))"
                
                self.scriptBucket = SCRIPT_BUCKET
                self.scriptKey = "\(uuid)/\(String(urls[0].lastPathComponent))"
            }
        }
    }
    
    @IBAction func GotoCheckout(_ sender: UIButton) {
        var inputCheck: String = ""
        var focusTextField: UITextField? = nil
        
        if(projectNameText.text!.isEmpty){
            inputCheck += "- Please input project name.\n"
            if(focusTextField == nil){
                focusTextField = projectNameText
            }
        }
        
        if(!inputCheck.isEmpty){
            showAlert(viewController: self, title: "Confirm", message: inputCheck) { UIAlertAction in
                focusTextField!.becomeFirstResponder()
            }
            return
        }
        
        guard agreePolicyCheckBox.isChecked else{
            showAlert(viewController: self, title: "Confirm", message: "Please review and check the script sharing policy.") { UIAlertAction in
                return
            }
            return
        }
        
        let controller = ActorSetPaymentViewController();

        controller.readerUid = readerUid
        controller.readerName = readerName
        controller.bookingStartTime = bookingStartTime
        controller.bookingEndTime = bookingEndTime
        controller.bookingDate = bookingDate
        if text_script.textColor == UIColor.lightGray {
            controller.script = ""
        }
        else{
            controller.script = text_script.text
        }
        
        controller.scriptBucket = self.scriptBucket
        controller.scriptKey = self.scriptKey
        controller.modalPresentationStyle = .fullScreen
//        self.navigationController?.pushViewController(controller, animated: true)
//        let transition = CATransition()
//        transition.duration = 0.5 // Set animation duration
//        transition.type = CATransitionType.push // Set transition type to push
//        transition.subtype = CATransitionSubtype.fromRight // Set transition subtype to from right
//        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        self.present(controller, animated: false)
    }
    @IBAction func GoBack(_ sender: UIButton) {
//        _ = navigationController?.popViewController(animated: true)
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromLeft // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
  
        self.dismiss(animated: false)
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

extension ActorBookUploadScriptViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {

        if text_script.textColor == UIColor.lightGray {
            text_script.text = ""
            text_script.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if text_script.text == "" {
            text_script.text = txtScriptPlaceHolder
            text_script.textColor = UIColor.lightGray
        }
    }
}
