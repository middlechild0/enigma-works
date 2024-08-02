/*==================================================
 Bazaar
 
 © XScoder 2018
 All Rights reserved
 
 RE-SELLING THIS SOURCE CODE TO ANY ONLINE MARKETPLACE IS A SERIOUS COPYRIGHT INFRINGEMENT.
 YOU WILL BE LEGALLY PROSECUTED
 
====================================================*/

import UIKit
import Parse
import GoogleMobileAds

class Chats: UIViewController, UITableViewDataSource, UITableViewDelegate, GADInterstitialDelegate {

    /*--- VIEWS ---*/
    @IBOutlet weak var chatsTableView: UITableView!
    @IBOutlet weak var noChatsLabel: UILabel!
    
    
    
    
    /*--- VARIABLES ---*/
    var adObj = PFObject(className: ADS_CLASS_NAME)
    var chatsArray = [PFObject]()

    
    
    
    // ------------------------------------------------
    // MARK: - VIEW DID APPEAR
    // ------------------------------------------------
    override func viewDidAppear(_ animated: Bool) {
        // currentUser IS LOGGED IN!
        if PFUser.current() != nil {
            // Call query
            queryChats()
            
        // currentUser IS NOT LOGGED IN...
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "Intro") as! Intro
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    // ------------------------------------------------
    // MARK: - VIEW DID LOAD
    // ------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Call AdMob Interstitial
       // showInterstitial()
    }

    
    
    
    
  
    // ------------------------------------------------
    // MARK: - QUERY CHATS
    // ------------------------------------------------
    func queryChats() {
        chatsArray.removeAll()
        chatsTableView.reloadData()
        showHUD()
        let currentUser = PFUser.current()!
        
        // Make query
        let query = PFQuery(className: CHATS_CLASS_NAME)
        query.includeKey(USER_CLASS_NAME)
        query.whereKey(CHATS_ID, contains: "\(currentUser.objectId!)")
        query.whereKey(CHATS_DELETED_BY, notContainedIn: [currentUser.objectId!])
        query.order(byDescending: "createdAt")
        
        query.findObjectsInBackground { (objects, error)-> Void in
            if error == nil {
                self.chatsArray = objects!
                self.hideHUD()
                
                if self.chatsArray.count == 0 {
                    self.noChatsLabel.isHidden = false
                } else {
                    self.noChatsLabel.isHidden = true
                    self.chatsTableView.reloadData()
                }
                
            // error
            } else { self.hideHUD(); self.simpleAlert("\(error!.localizedDescription)")
        }}
    }
    
    
    
    
    
    // MARK: - TABLEVIEW DELEGATES
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        // Layouts
        cell.avatarImg.layer.cornerRadius = cell.avatarImg.bounds.size.width/2
        cell.adImage.layer.cornerRadius = 3

        // Parse Object
        var cObj = PFObject(className: CHATS_CLASS_NAME)
        cObj = chatsArray[indexPath.row]
     
        let currentUser = PFUser.current()!
        
        
        // adPointer
        let adPointer = cObj[CHATS_AD_POINTER] as! PFObject
        adPointer.fetchIfNeededInBackground(block: { (ap, error) in
                    
            // Ad Photo
            self.getParseImage(object: adPointer, colName: ADS_IMAGE1, imageView: cell.adImage)
                        
            // Ad Title
            cell.adTitleLabel.text = "\(adPointer[ADS_TITLE]!)"
            
            // Chat Date
            let cDate = cObj.createdAt!
            let date = Date()
            cell.chatDateLabel.text = self.timeAgoSinceDate(cDate, currentDate: date, numericDates: true)
            
            
            // adUserPointer
            let adUserPointer = adPointer[ADS_SELLER_POINTER] as! PFUser
            adUserPointer.fetchIfNeededInBackground(block: { (aup, error) in
                if error == nil {
                    
                    // Fullname
                    if adUserPointer.objectId == currentUser.objectId {
                        cell.fullnameLabel.text = "You"
                        cell.fullnameLabel.textColor = MAIN_COLOR
                    } else {
                        cell.fullnameLabel.text = "\(adUserPointer[USER_FULLNAME]!)"
                    }
                    
                    // senderUser
                    let senderUser = cObj[CHATS_SENDER] as! PFUser
                    senderUser.fetchIfNeededInBackground(block: { (up, error) in
                        
                        // receiverUser
                        let receiverUser = cObj[CHATS_RECEIVER] as! PFUser
                        receiverUser.fetchIfNeededInBackground(block: { (ou, error) in
                            
                            // Avatar Image of the User you're chatting with
                            if senderUser.objectId == currentUser.objectId {
                                self.getParseImage(object: receiverUser, colName: USER_AVATAR, imageView: cell.avatarImg)
                            } else {
                                self.getParseImage(object: senderUser, colName: USER_AVATAR, imageView: cell.avatarImg)
                            }
                            
                        })// ./ receiverUser

                    })// ./ senderUser
                    
                // error
                } else { self.simpleAlert("\(error!.localizedDescription)")
            }})// ./ adUserPointer
                        
        })// ./ adPointer
                    
      
    return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    
    // ------------------------------------------------
    // MARK: - START MESSAGING
    // ------------------------------------------------
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Parse Object
        var cObj = PFObject(className: CHATS_CLASS_NAME)
        cObj = chatsArray[indexPath.row]
        
        // currentUser
        let currentUser = PFUser.current()!
        
        // adPointer
        let adPointer = cObj[CHATS_AD_POINTER] as! PFObject
        adPointer.fetchIfNeededInBackground(block: { (adp, error) in
            
            // senderUser
            let senderUser = cObj[CHATS_SENDER] as! PFUser
                senderUser.fetchIfNeededInBackground(block: { (up, error) in
               
                // receiverUser
                let receiverUser = cObj[CHATS_RECEIVER] as! PFUser
                receiverUser.fetchIfNeededInBackground(block: { (ou, error) in
                    if error == nil {
                        
                        let blockedUsers = receiverUser[USER_HAS_BLOCKED] as! [String]
                        
                        // receiverUser user has blocked you
                        if blockedUsers.contains(currentUser.objectId!) {
                            self.simpleAlert("Ouch, \(receiverUser[USER_USERNAME]!) has blocked you!")
                            
                        // Chat with receiverUser
                        } else {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Messages") as! Messages
                            
                            if senderUser.objectId == currentUser.objectId { vc.userObj = receiverUser
                            } else { vc.userObj = senderUser }
                            
                            vc.adObj = adPointer
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                    // error
                    } else { self.simpleAlert("\(error!.localizedDescription)")
                }})// ./ receiverUser
                
            })// ./ senderUser
            
        })// ./ adPointer
    }
    
    
}// ./ end
