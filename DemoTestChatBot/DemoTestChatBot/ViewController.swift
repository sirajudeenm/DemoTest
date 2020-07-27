//
//  ViewController.swift
//  DemoTestChatBot
//
//  Created by Apple on 20/07/20.
//  Copyright © 2020 ixm. All rights reserved.
//

import UIKit
import AWSLex

class ViewController: UIViewController, UITextFieldDelegate, AWSLexInteractionDelegate {
   

    @IBOutlet weak var lbl_Answer: UILabel!
    @IBOutlet weak var txtfldChat: UITextField!
    @IBOutlet weak var scrollViewChat: UIScrollView!
    @IBOutlet weak var viewChat: UIView!
    @IBOutlet weak var bottomChatView: UIView!
    
    var interactionKit: AWSLexInteractionKit?
    var keyboardHeight: CGFloat = 0.0
    var viewMyChats = [UIView](repeating: UIView(), count: 1000000)
    var yCoord : CGFloat = 10
    private var padding: CGFloat = 20.0
    private var timePadding: CGFloat = 8.0
    var chatIndex = -1
    var yName : CGFloat = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         setUpTextField()
         setUpLex()
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(true)
          //appDelegate.uploadType = ""
          NotificationCenter.default.addObserver(
              self,
              selector: #selector(keyboardWillShow),
              name: UIResponder.keyboardWillShowNotification,
              object: nil
          )
         
      }
    
    //MARK: - Keyboard Delegate
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
    }
    
    @IBAction func btnSendAction(_ sender: UIButton) {
        txtfldChat.resignFirstResponder()
        if (txtfldChat.text?.count)! > 0 {
            chatIndex = chatIndex + 1
            showOUTGoingText(text: txtfldChat.text!, itemIndex: chatIndex, dTime: Common.currentDateAgg())
        
            sendToLex(text: txtfldChat.text!)
        }
    }
    func interactionKit(_ interactionKit: AWSLexInteractionKit, onError error: Error) {
        print("interactionKit error: \(error)")
    }
    
    func setUpLex() {
        self.interactionKit = AWSLexInteractionKit.init(forKey: "chatConfig")
        self.interactionKit?.interactionDelegate = self
    }
    
    func setUpTextField(){
        txtfldChat.delegate = self
        txtfldChat.underlinedRegStatic()
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        if (txtfldChat.text?.count)! > 0 {
//            sendToLex(text: txtfldChat.text!)
//        }
//        return true
//    }
    
    func sendToLex(text : String){
        self.interactionKit?.text(inTextOut: text, sessionAttributes: nil)
    }
    
    //handle response
    func interactionKit(_ interactionKit: AWSLexInteractionKit, switchModeInput: AWSLexSwitchModeInput, completionSource: AWSTaskCompletionSource<AWSLexSwitchModeResponse>?) {
        guard let response = switchModeInput.outputText else {
            let response = "No reply from bot"
            print("Response: \(response)")
            return
        }
    //show response on screen
        DispatchQueue.main.async{
            print("\(response)")
            self.chatIndex = self.chatIndex + 1
            self.showINComingText(text: response , itemIndex: self.chatIndex, dTime: Common.currentDateAgg())
        }
    }
    
    
    //MARK: - Textfield and View Delegates
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveEaseIn, animations: {() -> Void in
          //  //print("view animation")
            self.viewChat.frame = CGRect(x: self.viewChat.frame.origin.x,
                                         y: CGFloat(-150),
                                         width: CGFloat(self.viewChat.frame.size.width),
                                         height: CGFloat(self.viewChat.frame.size.height))
        }, completion: {(_ finished: Bool) -> Void in
           // //print("on completion")
            self.bottomChatView.frame = CGRect(x: self.bottomChatView.frame.origin.x,
                                               y: self.view.frame.size.height-self.keyboardHeight-self.bottomChatView.frame.size.height,
                                               width: self.bottomChatView.frame.size.width,
                                               height: self.bottomChatView.frame.size.height)
        })
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && string == " " || range.location == 0 && string == "'"
        {
            ////print("empty stirng not allowed")
            return false
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       self.viewChat.frame = CGRect(x: self.viewChat.frame.origin.x,
                                    y: CGFloat(0),
                                    width: CGFloat(self.viewChat.frame.size.width),
                                    height: CGFloat(self.viewChat.frame.size.height))
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {() -> Void in
            self.bottomChatView.frame = CGRect(x: self.bottomChatView.frame.origin.x, y: self.view.frame.size.height-self.bottomChatView.frame.size.height, width: self.bottomChatView.frame.size.width, height: self.bottomChatView.frame.size.height)
        }, completion: {(_ finished: Bool) -> Void in
        })
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {() -> Void in
            self.bottomChatView.frame = CGRect(x: self.bottomChatView.frame.origin.x, y: self.view.frame.size.height-self.bottomChatView.frame.size.height, width: self.bottomChatView.frame.size.width, height: self.bottomChatView.frame.size.height)
        }, completion: {(_ finished: Bool) -> Void in
        })
    }
    
    //MARK: 2 - Phase 2 Outgoing Text
        func showOUTGoingText(text: String, itemIndex: Int, dTime: String) {
            //Layout View
            viewMyChats[itemIndex] = UIView()
            viewMyChats[itemIndex].frame = CGRect(x: 0, y: yCoord, width: self.view.frame.size.width, height: 0)
            viewMyChats[itemIndex].autoresizingMask = [.flexibleWidth, .flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin]
            viewMyChats[itemIndex].tag = itemIndex
            viewMyChats[itemIndex].backgroundColor = UIColor .clear
            self.viewChat.addSubview(viewMyChats[itemIndex])
    //        let tapLongGuster = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPressChats(_:)))
    //        viewMyChats[itemIndex].addGestureRecognizer(tapLongGuster)
            
            //Bubble
            var bgImageView: UIImageView?
            bgImageView = UIImageView(frame: CGRect.zero)
            self.viewMyChats[itemIndex].addSubview(bgImageView!)
            
            
            //Outgoing Message Content
            let label =  UILabel()
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 13)//UIFont(name: "ProximaNova-Regular", size: 13) //UIFont.systemFont(ofSize: 14)
            label.textColor = UIColor(red: 107.0/255.0, green: 107.0/255.0, blue: 107.0/255.0, alpha: 1)//.black
            label.text = text
            
            let constraintRect = CGSize(width: 0.66 * view.frame.width,
                                        height: .greatestFiniteMagnitude)
            let boundingBox = text.boundingRect(with: constraintRect,
                                                options: .usesLineFragmentOrigin,
                                                attributes: [.font: label.font],
                                                context: nil)
            label.frame.size = CGSize(width: ceil(boundingBox.width),
                                      height: ceil(boundingBox.height))
            
            self.viewMyChats[itemIndex].addSubview(label)
            
            var xCord : CGFloat = 0
            xCord = self.view.frame.size.width + 7 - label.frame.size.width - padding * 4
            label.frame = CGRect(x: xCord, y: 10, width: label.frame.size.width, height: label.frame.size.height)
            
            // Time Label
            //old x = label.frame.size.width + label.frame.origin.x + 2 4 to 7
            let labelTime = UILabel(frame: CGRect(x: label.frame.size.width + label.frame.origin.x - 6, y: label.frame.origin.y + label.frame.size.height + 6 - timePadding , width: 60, height: 21))
            labelTime.text = dTime
            labelTime.font = UIFont.systemFont(ofSize: 11) //UIFont(name: "ROBOTO-REGULAR", size: 11)//UIFont.systemFont(ofSize: 12)
            labelTime.numberOfLines = 0
            labelTime.sizeToFit()
            labelTime.textColor = UIColor(red: 191.0/255.0, green: 142.0/255.0, blue: 133.0/255.0, alpha: 1)
            self.viewMyChats[itemIndex].addSubview(labelTime)
            
            // old width = + 45
            bgImageView?.image = UIImage(named: "aqua1")?.stretchableImage(withLeftCapWidth: 24, topCapHeight: 24)
            bgImageView?.frame = CGRect(x: label.frame.origin.x - padding / 2, y: label.frame.origin.y - padding / 2, width: label.frame.size.width + padding + 50, height: label.frame.size.height + padding + 6)
            
            self.viewMyChats[itemIndex].frame.size.height = (bgImageView?.frame.size.height)!
            
            yCoord = self.viewMyChats[itemIndex].frame.size.height + self.viewMyChats[itemIndex].frame.origin.y + 10
            
            var yyCord : CGFloat = 0
            
            yyCord = yCoord + 10
            
            self.viewChat.frame.size.height = yyCord
            self.scrollViewChat.contentSize = CGSize(width: self.scrollViewChat.contentSize.width, height: yyCord+50)
            
            let bottomOffset = CGPoint(x: CGFloat(0), y: CGFloat(self.scrollViewChat.contentSize.height - self.scrollViewChat.bounds.size.height))
            self.scrollViewChat.setContentOffset(bottomOffset, animated: false)
        }
    
    //MARK: - Phase 2 Incoming Text
        func showINComingText(text: String, itemIndex: Int, dTime: String) {
            //Layout View
            viewMyChats[itemIndex] = UIView()
            viewMyChats[itemIndex].frame = CGRect(x: 0, y: yCoord, width: self.view.frame.size.width, height: 0)
            viewMyChats[itemIndex].autoresizingMask = [.flexibleWidth, .flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin]
            viewMyChats[itemIndex].tag = itemIndex
            viewMyChats[itemIndex].backgroundColor = UIColor .clear
            self.viewChat.addSubview(viewMyChats[itemIndex])
           
            //Bubble
            var bgImageView: UIImageView?
            bgImageView = UIImageView(frame: CGRect.zero)
            self.viewMyChats[itemIndex].addSubview(bgImageView!)
            
             yName = 10
            
            
            //Outgoing Message Content
            let label =  UILabel()
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 13)//UIFont(name: "ProximaNova-Regular", size: 13)//UIFont.systemFont(ofSize: 14)
            label.textColor = UIColor(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1)//.black
            label.text = text
            
            let constraintRect = CGSize(width: 0.66 * view.frame.width,
                                        height: .greatestFiniteMagnitude)
            let boundingBox = text.boundingRect(with: constraintRect,
                                                options: .usesLineFragmentOrigin,
                                                attributes: [.font: label.font],
                                                context: nil)
            label.frame.size = CGSize(width: ceil(boundingBox.width),
                                      height: ceil(boundingBox.height))
            self.viewMyChats[itemIndex].addSubview(label)
            label.frame = CGRect(x: padding * 2 - 10, y: yName, width: label.frame.size.width, height: label.frame.size.height)
            
            
            // Time Label 4 to 7
            let labelTime = UILabel(frame: CGRect(x: label.frame.size.width + label.frame.origin.x - 7, y: label.frame.origin.y + label.frame.size.height + 6 - timePadding, width: 60, height: 21))
            labelTime.text = dTime
            labelTime.font = UIFont.systemFont(ofSize: 12) //UIFont(name: "ROBOTO-REGULAR", size: 11)//UIFont.systemFont(ofSize: 12)
            labelTime.numberOfLines = 0
            labelTime.sizeToFit()
            labelTime.textColor = UIColor(red: 175.0/255.0, green: 118.0/255.0, blue: 107.0/255.0, alpha: 1)
            //labelTime.textColor = UIColor.white
            self.viewMyChats[itemIndex].addSubview(labelTime)
            
            bgImageView?.image = UIImage(named: "aqua2")?.stretchableImage(withLeftCapWidth: 24, topCapHeight: 24)
            
            bgImageView?.frame = CGRect(x: padding - 10 , y: label.frame.origin.y - padding / 2, width: label.frame.size.width + padding + 45, height: label.frame.size.height + padding + 6)
            
            self.viewMyChats[itemIndex].frame.size.height = (bgImageView?.frame.size.height)!
            
            
            yCoord = self.viewMyChats[itemIndex].frame.size.height + self.viewMyChats[itemIndex].frame.origin.y + 10
            
            var yyCord : CGFloat = 0
            
            yyCord = yCoord + 10
            
            self.viewChat.frame.size.height = yyCord
            self.scrollViewChat.contentSize = CGSize(width: self.scrollViewChat.contentSize.width, height: yyCord+50)
            
            let bottomOffset = CGPoint(x: CGFloat(0), y: CGFloat(self.scrollViewChat.contentSize.height - self.scrollViewChat.bounds.size.height))
            self.scrollViewChat.setContentOffset(bottomOffset, animated: false)
            
        }

}

