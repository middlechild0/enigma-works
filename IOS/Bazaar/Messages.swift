/*==================================================
 Bazaar
 
 © XScoder 2018
 All Rights reserved
 
 RE-SELLING THIS SOURCE CODE TO ANY ONLINE MARKETPLACE IS A SERIOUS COPYRIGHT INFRINGEMENT.
 YOU WILL BE LEGALLY PROSECUTED
 
====================================================*/

import UIKit
import Parse
import MessageUI
import MobileCoreServices
import AssetsLibrary
import AVFoundation



// ------------------------------------------------
// MARK: - MESSAGE CELL 1
// ------------------------------------------------
class MessageCell: UITableViewCell {
    /*--- VIEWS ---*/
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageTxtView: UITextView!
    @IBOutlet weak var imageButton: UIButton!
}


// ------------------------------------------------
// MARK: - MESSAGE CELL 2
// ------------------------------------------------
class MessageCell2: UITableViewCell {
    /*--- VIEWS ---*/
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageTxtView: UITextView!
    @IBOutlet weak var imageButton: UIButton!
}





// ------------------------------------------------
// MARK: - MESSAGES
// ------------------------------------------------
class Messages: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    /*--- VIEWS ---*/
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var adButton: UIButton!
    @IBOutlet weak var adTitleLabel: UILabel!
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var writeMessageView: UIView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var messageTxt: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    

    
    
    /*--- VARIABLES ---*/
    var adObj = PFObject(className: ADS_CLASS_NAME)
    var userObj = PFUser()
    var messagesArray = [PFObject]()
    var chatsArray = [PFObject]()
    
    var cellHeight = CGFloat()
    var refreshTimer = Timer()
    var lastMessageStr = ""
    var imageToSend:UIImage?
    
    
    // ------------------------------------------------
    // MARK: - VIEW DID APPEAR
    // ------------------------------------------------
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    

    
    // ------------------------------------------------
    // MARK: - VIEW DID LOAD
    // ------------------------------------------------
    override func viewDidLoad() {
            super.viewDidLoad()
        
        // Layouts
        self.edgesForExtendedLayout = UIRectEdge()
        lastMessageStr = ""
        previewView.frame.origin.y = view.frame.size.height
        messagesTableView.backgroundColor = UIColor.clear
        
        
        // AD Info
        adTitleLabel.text = "\(adObj[ADS_TITLE]!)"
        getParseImage(object: adObj, colName: ADS_IMAGE1, button: adButton)
        adButton.layer.cornerRadius = 3
        
        // User Info
        fullnameLabel.text = "\(userObj[USER_FULLNAME]!)"
        getParseImage(object: userObj, colName: USER_AVATAR, button: avatarButton)
        avatarButton.layer.cornerRadius = avatarButton.bounds.size.width/2

        
        // Call Timer to refresh Messages
        startRefreshTimer()
        
        // Call query
        queryMessages()

    }

    
    // ------------------------------------------------
    // MARK: - START THE REFRESH MESSAGES TIMER
    // ------------------------------------------------
    func startRefreshTimer() {
        refreshTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(queryMessages), userInfo: nil, repeats: true)
    }
    
    
    
    
    // ------------------------------------------------
    // MARK: - KEYBOARD HIDE AND SHOW OBSERVERS
    // ------------------------------------------------
    @objc func keyboardWillShow(_ notification: Notification) {
        if let kFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let kRect = kFrame.cgRectValue
            let kHeight = kRect.height
            
            // Move writeMessageView on the top of the keyboard
            writeMessageView.frame.origin.y = view.frame.size.height - kHeight - writeMessageView.frame.size.height
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        // Move writeMessageView on the bottom of the screen
        writeMessageView.frame.origin.y = view.frame.size.height - writeMessageView.frame.size.height
    }
    
    
    
    // ------------------------------------------------
    // MARK: - DISMISS KEYBOARD ON SCROLL DOWN
    // ------------------------------------------------
    var lastContentOffset: CGFloat = 0
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            messageTxt.resignFirstResponder()
        }
    }
    
    
    
    
    // ------------------------------------------------
    // MARK: - TEXTFIELD DELEGATES
    // ------------------------------------------------
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let chars = newText.count
        print("CHARS: \(chars)")
        if chars != 0 { sendButton.isEnabled = true
        } else { sendButton.isEnabled = false }
        
    return true
    }
    
    
    
    
    
    // ------------------------------------------------
    // MARK: - QUERY MESSAGES
    // ------------------------------------------------
    @objc func queryMessages() {
        if PFUser.current() != nil {
            
            let currentUser = PFUser.current()!
            let messId1 = "\(currentUser.objectId!)\(userObj.objectId!)"
            let messId2 = "\(userObj.objectId!)\(currentUser.objectId!)"
            
            let predicate = NSPredicate(format:"messageID = '\(messId1)' OR messageID = '\(messId2)'")
            let query = PFQuery(className: MESSAGES_CLASS_NAME, predicate: predicate)
            query.whereKey(MESSAGES_AD_POINTER, equalTo: adObj)
            
            query.whereKey(MESSAGES_DELETED_BY, notContainedIn: [currentUser.objectId!])

            query.order(byAscending: "createdAt")
            query.findObjectsInBackground { (objects, error)-> Void in
                if error == nil {
                    self.messagesArray = objects!
                    self.messagesTableView.reloadData()
                    
                    // Scroll TableView down to the bottom
                    if objects!.count != 0 {
                        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.scrollTableViewToBottom), userInfo: nil, repeats: false)
                    }
                    
                // error
                } else { self.simpleAlert("\(error!.localizedDescription)")
            }}
            
        }//./ If
    }
    
    
    
    
    // ------------------------------------------------
    // MARK: - SHOW MESSAGES IN TABLE VIEW
    // ------------------------------------------------
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Parse Object
        var mObj = PFObject(className: MESSAGES_CLASS_NAME)
        mObj = messagesArray[indexPath.row]
        let currentuser = PFUser.current()!
        
        // User Pointer
        var userPointer = mObj[MESSAGES_SENDER] as! PFUser
        do { userPointer = try userPointer.fetchIfNeeded() } catch {}
     
                
                // ------------------------------------------------
                // MARK: - CELL WITH MESSAGE FROM CURRENT USER
                // ------------------------------------------------
                if userPointer.objectId == currentuser.objectId {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
                    
                    // Layouts
                    cell.backgroundColor = UIColor.clear
                    cell.contentView.backgroundColor = UIColor.clear
                    cell.imageButton.isHidden = true
                    
                    // Get Date
                    cell.dateLabel.text = self.timeAgoSinceDate(mObj.createdAt!, currentDate: Date(), numericDates: true)
                
                    // Message
                    cell.messageTxtView.text = "\(mObj[MESSAGES_MESSAGE]!)"
                    cell.messageTxtView.sizeToFit()
                    cell.messageTxtView.frame.origin.x = 77
                    cell.messageTxtView.frame.size.width = cell.frame.size.width - 87
                    cell.messageTxtView.layer.cornerRadius = 5
                    
                    // Reset cellHeight
                    self.cellHeight = cell.messageTxtView.frame.origin.y + cell.messageTxtView.frame.size.height + 15
                  
                    // Message Image
                    if mObj[MESSAGES_IMAGE] != nil {
                        cell.imageButton.imageView!.contentMode = .scaleAspectFill
                        cell.imageButton.tag = indexPath.row
                        cell.imageButton.frame.size.width = 180
                        cell.imageButton.frame.size.height = 180
                        cell.imageButton.layer.cornerRadius = 8
                        cell.imageButton.isHidden = false

                        cell.messageTxtView.frame.size.height = 0

                        self.getParseImage(object: mObj, colName: MESSAGES_IMAGE, button: cell.imageButton)
                        
                        // Reset cellHeight
                        self.cellHeight = cell.messageTxtView.frame.origin.y + cell.messageTxtView.frame.size.height + cell.imageButton.frame.size.height + 40
                    }

                    return cell
                    
            
                    
                // ------------------------------------------------
                // MARK: - CELL WITH MESSAGE FROM OTHER USER
                // ------------------------------------------------
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell2", for: indexPath) as! MessageCell2
                    
                    // Layouts
                    cell.backgroundColor = UIColor.clear
                    cell.contentView.backgroundColor = UIColor.clear
                    cell.imageButton.isHidden = true
                    
                    
                    // Message
                    cell.messageTxtView.text = "\(mObj[MESSAGES_MESSAGE]!)"
                    cell.messageTxtView.sizeToFit()
                    cell.messageTxtView.frame.origin.x = 8
                    cell.messageTxtView.frame.size.width = cell.frame.size.width - 87
                    cell.messageTxtView.layer.cornerRadius = 5

                    // Date
                    cell.dateLabel.text = self.timeAgoSinceDate(mObj.createdAt!, currentDate: Date(), numericDates: true)

                    // Reset cellheight
                    self.cellHeight = cell.messageTxtView.frame.origin.y + cell.messageTxtView.frame.size.height + 15
                    
                    
                    // Message Image
                    if mObj[MESSAGES_IMAGE] != nil {
                        cell.imageButton.imageView!.contentMode = .scaleAspectFill
                        cell.imageButton.tag = indexPath.row
                        cell.imageButton.frame.size.width = 180
                        cell.imageButton.frame.size.height = 180
                        cell.imageButton.layer.cornerRadius = 8
                        cell.imageButton.isHidden = false
                        
                        cell.messageTxtView.frame.size.height = 0
                        
                        self.getParseImage(object: mObj, colName: MESSAGES_IMAGE, button: cell.imageButton)
                        
                        // Reset cellHeight
                        self.cellHeight = cell.messageTxtView.frame.origin.y + cell.messageTxtView.frame.size.height + cell.imageButton.frame.size.height + 40
                    }
                    
                    return cell
        
                }// ./ If
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }


    
    


    // ------------------------------------------------
    // MARK: - SCROLL TABLEVIEW TO BOTTOM
    // ------------------------------------------------
    @objc func scrollTableViewToBottom() {
        messagesTableView.scrollToRow(at: IndexPath(row: self.messagesArray.count-1, section: 0), at: .bottom, animated: true)
    }
    
    


    

    
    // ------------------------------------------------
    // MARK: - CHAT IMAGE BUTTON ON MESSAGE CELL 1
    // ------------------------------------------------
    @IBAction func imageButt(_ sender: UIButton) {
        previewImage.image = sender.imageView!.image
        showImagePreview()
    }
    
    
    // ------------------------------------------------
    // MARK: - CHAT IMAGE BUTTON ON MESSAGE CELL 2
    // ------------------------------------------------
    @IBAction func imageButt2(_ sender: UIButton) {
        previewImage.image = sender.imageView!.image
        showImagePreview()
    }
    
    

    
    
    // ------------------------------------------------
    // MARK: - SHOW/HIDE IMAGE PREVIEW
    // ------------------------------------------------
    func showImagePreview() {
        messageTxt.resignFirstResponder()
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
            self.previewView.frame.origin.y = 0
        }, completion: { (finished: Bool) in })
    }
    func hideImagePreview() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
            self.previewView.frame.origin.y = self.view.frame.size.height
        }, completion: { (finished: Bool) in })
    }
    
    
    
    // ------------------------------------------------
    // MARK: - DISMISS IMAGE PREVIEW BUTTON
    // ------------------------------------------------
    @IBAction func dismissImgPreview(_ sender: Any) {
        hideImagePreview()
    }
    
    
    
    // ------------------------------------------------
    // MARK: - SWIPE DOWN TO DISMISS IMAGE PREVIEW
    // ------------------------------------------------
    @IBAction func swipeDownToDismissImgPreview(_ sender: Any) {
        hideImagePreview()
    }
    
    
    
    
    
    // ------------------------------------------------
    // MARK: - AVATAR BUTTON
    // ------------------------------------------------
    @IBAction func avatarButt(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserProfile") as! UserProfile
        vc.userObj = userObj
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    // ------------------------------------------------
    // MARK: - DISMISS KEYBOARD
    // ------------------------------------------------
    @objc func dismissKeyboard() {
        messageTxt.text = ""
        messageTxt.resignFirstResponder()
        sendButton.isEnabled = false
    }
    
    
    
    
    

    
    // ------------------------------------------------
    // MARK: - SEND IMAGE BUTTON
    // ------------------------------------------------
    @IBAction func sendImageButt(_ sender: AnyObject) {
        let alert = UIAlertController(title: APP_NAME,
            message: "Select source",
            preferredStyle: .alert)
        
        // OPEN CAMERA
        let camera = UIAlertAction(title: "Take a picture", style: .default, handler: { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        alert.addAction(camera)

        
        // OPEN PHOTO LIBRARY
        let library = UIAlertAction(title: "Choose an Image", style: .default, handler: { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        alert.addAction(library)
        
        // CANCEL BUTTON
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }
    
    
    // ------------------------------------------------
    // MARK: - GET IMAGE TO SEND
    // ------------------------------------------------
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageToSend = scaleImageToMaxWidth(image: image, newWidth: 400)
        }
        dismissKeyboard()
        dismiss(animated: true, completion: nil)
        sendMessageButt(self)
    }
    
    
    
    
    
    

    
    
    
    
    // MARK: - SEND MESSAGE BUTTON ------------------
    @IBAction func sendMessageButt(_ sender: Any) {
        // Stop the refresh timer
        refreshTimer.invalidate()
        
        let mObj = PFObject(className: MESSAGES_CLASS_NAME)
        let currentUser = PFUser.current()!
        
        // Prepare data
        mObj[MESSAGES_SENDER] = currentUser
        mObj[MESSAGES_RECEIVER] = userObj
        mObj[MESSAGES_AD_POINTER] = adObj
        mObj[MESSAGES_MESSAGE_ID] = "\(currentUser.objectId!)\(userObj.objectId!)"
        mObj[MESSAGES_MESSAGE] = messageTxt.text!
        lastMessageStr = messageTxt.text!
        mObj[MESSAGES_DELETED_BY] = [String]()
        

        // Attach an Image (if any)
        if imageToSend != nil {
            showHUD()
            let imageData = imageToSend!.jpegData(compressionQuality: 1)
            let imageFile = PFFileObject(name:"image.jpg", data:imageData!)
            mObj[MESSAGES_IMAGE] = imageFile
            
            mObj[MESSAGES_MESSAGE] = "[Photo]"
            lastMessageStr = "[Photo]"
        }


        // Saving block ------------------------------------------------------
        mObj.saveInBackground { (success, error) -> Void in
            if error == nil {
                self.hideHUD()
                let currentUser = PFUser.current()!
                
                self.dismissKeyboard()
                
                // Call save LastMessage
                self.saveLastMessageInChats()
                
                // Add message to the array (it's temporary, before a new query gets automatically called)
                self.messagesArray.append(mObj)
                self.messagesTableView.reloadData()
                self.scrollTableViewToBottom()
     
                
                // Reset variables
                self.imageToSend = nil
                self.startRefreshTimer()
                
                
                // Send Push notification
                let pushMessage = "\(currentUser[USER_FULLNAME]!) | '\(self.adObj[ADS_TITLE]!)':\n\(self.lastMessageStr)'"
                let data = [
                    "badge" : "Increment",
                    "alert" : pushMessage,
                    "sound" : "bingbong.aiff"
                ]
                let request = [
                    "userObjectID" : self.userObj.objectId!,
                    "data" : data
                    ] as [String : Any]
                
                allowPush = DEFAULTS.bool(forKey: "allowPush")
                if !allowPush {
                    PFCloud.callFunction(inBackground: "pushiOS", withParameters: request as [String : Any], block: { (results, error) in
                        if error == nil { print ("\nPUSH NOTIFICATION SENT TO: \(self.userObj[USER_FULLNAME]!)\nMESSAGE: \(pushMessage)")
                        // error
                        } else { self.simpleAlert("\(error!.localizedDescription)")
                    }})// ./ PFCloud
                }// ./ If
                
            // error
            } else { self.hideHUD(); self.simpleAlert("\(error!.localizedDescription)")
        }}

    }
    
    
    
    
    // ------------------------------------------------
    // MARK: - SAVE LAST MESSAGE IN THE CHATS CLASS
    // ------------------------------------------------
    func saveLastMessageInChats() {
        let currentUser = PFUser.current()!

        let messId1 = "\(currentUser.objectId!)\(userObj.objectId!)"
        let messId2 = "\(userObj.objectId!)\(currentUser.objectId!)"
        
        let predicate = NSPredicate(format:"\(CHATS_ID) = '\(messId1)'  OR  \(CHATS_ID) = '\(messId2)' ")
        let query = PFQuery(className: CHATS_CLASS_NAME, predicate: predicate)
        query.whereKey(CHATS_AD_POINTER, equalTo: adObj)
        
        query.findObjectsInBackground { (objects, error)-> Void in
            if error == nil {
                self.chatsArray = objects!

                var chatsObj = PFObject(className: CHATS_CLASS_NAME)

                if self.chatsArray.count != 0 {
                    chatsObj = self.chatsArray[0]
                }
                // print("CHATS ARRAY: \(self.chatsArray)\n")
                
                // Update Last message
                chatsObj[CHATS_LAST_MESSAGE] = self.lastMessageStr
                chatsObj[CHATS_SENDER] = currentUser
                chatsObj[CHATS_RECEIVER] = self.userObj
                chatsObj[CHATS_ID] = "\(currentUser.objectId!)\(self.userObj.objectId!)"
                chatsObj[CHATS_AD_POINTER] = self.adObj
                chatsObj[CHATS_DELETED_BY] = [String]()

                // Saving block
                chatsObj.saveInBackground { (success, error) -> Void in
                    if error == nil { print("LAST MESS SAVED: \(self.lastMessageStr)\n")
                    // error
                    } else { self.simpleAlert("\(error!.localizedDescription)")
                }}
             
                
            // error in query
            } else { self.simpleAlert("\(error!.localizedDescription)")
        }}
    }
    
    
    
    


    
    // ------------------------------------------------
    // MARK: - VIEW AD'S INFO BUTTON
    // ------------------------------------------------
    @IBAction func AdButt(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AdInfo") as! AdInfo
        vc.adObj = adObj
        navigationController?.pushViewController(vc, animated: true)
    }
    



    
    
    
    // ------------------------------------------------
    // MARK: - OPTIONS BUTTON
    // ------------------------------------------------
    @IBAction func optionsButt(_ sender: Any) {
        // Check blocked users array
        let currentUser = PFUser.current()!
        var hasBlocked = currentUser[USER_HAS_BLOCKED] as! [String]
        
        // Set blockUser  Action title
        var blockTitle = String()
        if hasBlocked.contains(userObj.objectId!) { blockTitle = "Unblock User"
        } else { blockTitle = "Block User" }
        
        
        let alert = UIAlertController(title: APP_NAME,
            message: "Select option",
            preferredStyle: .alert)
        

        // REPORT USER
        let reportUser = UIAlertAction(title: "Report User", style: .default, handler: { (action) -> Void in
            self.showHUD()
            
            let request = [
                "userId" : self.userObj.objectId!,
                "reportMessage" : "Inapprorpiate User"
            ] as [String : Any]
            
            PFCloud.callFunction(inBackground: "reportUser", withParameters: request as [String : Any], block: { (results, error) in
                if error == nil {
                    print ("\(self.userObj[USER_FULLNAME]!) has been reported!")
                    self.hideHUD()
                    self.simpleAlert("Thanks for reporting this User, we will take action for it within 24h.")
                    
                    // Report all the Ads form this user
                    let query = PFQuery(className: ADS_CLASS_NAME)
                    query.whereKey(ADS_SELLER_POINTER, equalTo: self.userObj)
                    query.findObjectsInBackground { (objects, error) in
                        if error == nil {
                            for i in 0..<objects!.count {
                                var adObj = PFObject(className: ADS_CLASS_NAME)
                                adObj = objects![i]
                                
                                adObj[ADS_IS_REPORTED] = true
                                adObj.saveInBackground()
                            
                            }// ./ For loop
                            
                        // error
                        } else { self.simpleAlert("\(error!.localizedDescription)")
                    }}// ./ query

                // error
                } else { self.hideHUD(); self.simpleAlert("\(error!.localizedDescription)")
            }})// ./ PFCloud
        })
        alert.addAction(reportUser)

        
    
        
        // BLOCK/UNBLOCK USER
        let blockUser = UIAlertAction(title: blockTitle, style: .default, handler: { (action) -> Void in
            // Block User
            if blockTitle == "Block User" {
                hasBlocked.append(self.userObj.objectId!)
                currentUser[USER_HAS_BLOCKED] = hasBlocked
                currentUser.saveInBackground(block: { (succ, error) in
                    if error == nil {
                       self.simpleAlert("You've blocked \(self.userObj[USER_FULLNAME]!).")
                        _ = self.navigationController?.popViewController(animated: true)
                }})
                
            // Unblock User
            } else {
                let hasBlocked2 = hasBlocked.filter{$0 != "\(self.userObj.objectId!)"}
                currentUser[USER_HAS_BLOCKED] = hasBlocked2
                currentUser.saveInBackground(block: { (succ, error) in
                    if error == nil {
                        self.simpleAlert("You've unblocked \(self.userObj[USER_FULLNAME]!).")
                }})
            }
        })
        alert.addAction(blockUser)
        
        
        
        
        // DELETE CHAT
        let deleteChat = UIAlertAction(title: "Delete Chat", style: .default, handler: { (action) -> Void in
           
            let alert = UIAlertController(title: APP_NAME,
                message: "Are you sure you want to delete this Chat?",
                preferredStyle: .alert)
            
            let delete = UIAlertAction(title: "Delete Chat", style: .default, handler: { (action) -> Void in
                
                // Add currentUser's objectId to all messages of this chat
                for i in 0..<self.messagesArray.count {
                    var mObj = PFObject(className: MESSAGES_CLASS_NAME)
                    mObj = self.messagesArray[i]
                    var deletedBy = mObj[MESSAGES_DELETED_BY] as! [String]
                    deletedBy.append(currentUser.objectId!)
                    mObj[MESSAGES_DELETED_BY] = deletedBy
                    mObj.saveInBackground()
                }
                
                // Query Chats and add currentUser's objectId to the deletedBy column
                let messId1 = "\(currentUser.objectId!)\(self.userObj.objectId!)"
                let messId2 = "\(self.userObj.objectId!)\(currentUser.objectId!)"
                let predicate = NSPredicate(format:"\(CHATS_ID) = '\(messId1)'  OR  \(CHATS_ID) = '\(messId2)' ")
                let query = PFQuery(className: CHATS_CLASS_NAME, predicate: predicate)
                query.whereKey(CHATS_AD_POINTER, equalTo: self.adObj)
                
                query.findObjectsInBackground { (objects, error)-> Void in
                    if error == nil {
                        self.chatsArray = objects!
                        var chatsObj = PFObject(className: CHATS_CLASS_NAME)
                        chatsObj = self.chatsArray[0]
                        
                        var deletedBy = chatsObj[CHATS_DELETED_BY] as! [String]
                        deletedBy.append(currentUser.objectId!)
                        chatsObj[CHATS_DELETED_BY] = deletedBy
                        chatsObj.saveInBackground(block: { (succ, error) in
                            if error == nil {
                                _ = self.navigationController?.popViewController(animated: true)
                            // error
                            } else { self.simpleAlert("\(error!.localizedDescription)")
                        }})
                        
                    // error
                    } else { self.simpleAlert("\(error!.localizedDescription)")
                }}// ./ Query
                
            })
            alert.addAction(delete)
            
            
            // Cancel 
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        })
        alert.addAction(deleteChat)

        
        
        // CANCEL
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    // ------------------------------------------------
    // MARK: - BACK BUTTON
    // ------------------------------------------------
    @IBAction func backButt(_ sender: Any) {
        // Remove Notification observer
        NotificationCenter.default.removeObserver(self)
       
        // Stop refreshTimer
        refreshTimer.invalidate()
        
        // Go back
        _ = navigationController?.popViewController(animated: true)
    }

    
    
    // ------------------------------------------------
    // MARK: - VIEW WILL DISAPPEAR
    // ------------------------------------------------
    override func viewWillDisappear(_ animated: Bool) {
        // Remove Notification observer
        NotificationCenter.default.removeObserver(self)
        
        // Stop refreshTimer
        refreshTimer.invalidate()
    }
    
    
}// ./ end
