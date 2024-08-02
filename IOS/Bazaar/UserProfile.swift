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

class UserProfile: UIViewController, GADInterstitialDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    /*--- VIEWS ---*/
    var adMobInterstitial:GADInterstitial!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var blockedUserView: UIView!
    @IBOutlet weak var sellingButton: UIButton!
    @IBOutlet weak var soldButton: UIButton!
    @IBOutlet weak var likedButton: UIButton!
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var adsCollView: UICollectionView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var verifiedLabel: UILabel!
    
    
    
    /*--- VARIABLES ---*/
    var userObj = PFUser()
    var isSelling = true
    var isLiked = false
    var adsArray = [PFObject]()
    
    
    
    
    // ------------------------------------------------
    // MARK: - VIEW DID LOAD
    // ------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        // Layouts
        avatarImg.layer.cornerRadius = avatarImg.bounds.size.width/2
        followButton.layer.cornerRadius = 4
        followButton.layer.borderColor = MAIN_COLOR.cgColor
        followButton.layer.borderWidth = 1
        
        // Call function
        showUserInfo()
        
        // Call query
        queryAds()
        
        // Call AdMob Interstitial
       // showInterstitial()
    }

    
    
    
    // ------------------------------------------------
    // MARK: - SHOW USER'S INFO
    // ------------------------------------------------
    func showUserInfo() {
        
        // Verified
        if userObj["emailVerified"] != nil {
            verifiedLabel.text = "Verified"
        } else {
            verifiedLabel.text = "Not Verified yet"
        }
        
        // Full name
        fullnameLabel.text = "\(userObj[USER_FULLNAME]!)"
        
        // Avatar
        getParseImage(object: userObj, colName: USER_AVATAR, imageView: avatarImg)
        
        // Bio
        if userObj[USER_BIO] != nil { bioLabel.text = "\(userObj[USER_BIO]!)"
        } else { bioLabel.text = "" }
        
        // Blocked user View
        if PFUser.current() != nil {
            let currentUser = PFUser.current()!
            let hasBlocked = currentUser[USER_HAS_BLOCKED] as! [String]
            if hasBlocked.contains(userObj.objectId!) {
                blockedUserView.isHidden = false
            } else { blockedUserView.isHidden = true }
        }
        
        // Follow Button
        if PFUser.current() != nil {
            let currentUser = PFUser.current()!
            
            // Perform query
            let query = PFQuery(className: FOLLOW_CLASS_NAME)
            query.whereKey(FOLLOW_IS_FOLLOWING, equalTo: userObj)
            query.whereKey(FOLLOW_CURRENT_USER, equalTo: currentUser)
            query.findObjectsInBackground { (objects, error) in
                if error == nil {
                    
                    // Following
                    if objects!.count != 0 {
                        self.followButton.backgroundColor = UIColor.white
                        self.followButton.setTitle("Following", for: .normal)
                        self.followButton.setTitleColor(MAIN_COLOR, for: .normal)
                    // Not following
                    } else {
                        self.followButton.backgroundColor = MAIN_COLOR
                        self.followButton.setTitle("Follow", for: .normal)
                        self.followButton.setTitleColor(UIColor.white, for: .normal)
                    }
                // error
                } else { self.simpleAlert("\(error!.localizedDescription)")
            }}
            
        // currentuser IS NOT LOGGED IN...
        } else { followButton.isHidden = true }

    }
    
    
    
    
    // ------------------------------------------------
    // MARK: - QUERY ADS
    // ------------------------------------------------
    func queryAds() {
        // Reset data
        adsArray = [PFObject]()
        adsCollView.reloadData()
        
        showHUD()
        
        // Query
        let query = PFQuery(className: ADS_CLASS_NAME)
        query.whereKey(ADS_SELLER_POINTER, equalTo: userObj)
        if isSelling && !isLiked { query.whereKey(ADS_IS_SOLD, equalTo: false)
        } else if !isSelling && !isLiked { query.whereKey(ADS_IS_SOLD, equalTo: true) }
        if isLiked && !isSelling { query.whereKey(ADS_LIKED_BY, containedIn: [userObj.objectId!]) }
        query.order(byDescending: ADS_CREATED_AT)
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                self.adsArray = objects!
                self.hideHUD()
                self.adsCollView.reloadData()
                
                // Show/hide noResult view
                if self.adsArray.count == 0 {
                    self.noResultsLabel.isHidden = false
                } else { self.noResultsLabel.isHidden = true }
            
            // error
            } else { self.hideHUD(); self.simpleAlert("\(error!.localizedDescription)")
        }}
    }
    
    
    
    // ------------------------------------------------
    // MARK: - SHOW DATA IN COLLECTION VIEW
    // ------------------------------------------------
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return adsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdCell", for: indexPath) as! AdCell
        
        // Parse Object
        var adObj = PFObject(className: ADS_CLASS_NAME)
        adObj = adsArray[indexPath.row]
        
        // First Image
        getParseImage(object: adObj, colName: ADS_IMAGE1, imageView: cell.adImage)
        // Title
        cell.adTitleLabel.text = "\(adObj[ADS_TITLE]!)"
        // Price
        cell.adPriceLabel.text = "\(adObj[ADS_CURRENCY]!) \(adObj[ADS_PRICE]!)"
        // Sold badge
        
         if (adObj[ADS_IS_SHIPPING] != nil){
                   let isShipping = adObj[ADS_IS_SHIPPING] as! Bool
                   if (isShipping == true){
                       if (adObj[ADS_IS_SHIPPING] != nil ){
                           let labelValue = "\(adObj[ADS_SHIPPING]!)"
                           if labelValue == "0"{
                               let attachment:NSTextAttachment = NSTextAttachment()
                               attachment.image = UIImage(named: "shipping")
                               let attachmentString:NSAttributedString = NSAttributedString(attachment: attachment)
                               let attributedString:NSMutableAttributedString = NSMutableAttributedString(string:"")
                               attributedString.append(attachmentString)
                                let label = " Ships for FREE"
                               attributedString.append(NSMutableAttributedString(string:label))
                               cell.freeShipping.attributedText = attributedString
                           }else{
                               
                               let attachment:NSTextAttachment = NSTextAttachment()
                               attachment.image = UIImage(named: "shipping")
                               let attachmentString:NSAttributedString = NSAttributedString(attachment: attachment)
                               let attributedString:NSMutableAttributedString = NSMutableAttributedString(string:"")
                               attributedString.append(attachmentString)
                               let label = " Ships for " + "\(adObj[ADS_CURRENCY]!) \(adObj[ADS_SHIPPING]!)"
                               attributedString.append(NSMutableAttributedString(string:label))
                               cell.freeShipping.attributedText = attributedString
                           }
                           
                       }else{
                           cell.freeShipping.text = ""
                       }
                   }else{
                       cell.freeShipping.text = ""
                   }
               }else{
                   cell.freeShipping.text = ""
               }
        
        let isSold = adObj[ADS_IS_SOLD] as! Bool
        if isSold { cell.soldBadge.isHidden = false
            cell.freeShipping.text = ""
        } else { cell.soldBadge.isHidden = true }
        
        
        // Cell layout
        cell.layer.cornerRadius = 6
        
    return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return setCellSize()
    }
    
    
    // ------------------------------------------------
    // MARK: - SHOW AD'S INFO
    // ------------------------------------------------
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Parse Object
        var adObj = PFObject(className: ADS_CLASS_NAME)
        adObj = adsArray[indexPath.row]
        
        // Enter AdInfo screen
        let vc = storyboard?.instantiateViewController(withIdentifier: "AdInfo") as! AdInfo
        vc.adObj = adObj
        navigationController?.pushViewController(vc, animated: true)
    }
    

    
    
    // ------------------------------------------------
    // MARK: - SELLING BUTTON
    // ------------------------------------------------
    @IBAction func sellingButt(_ sender: UIButton) {
        isSelling = true
        sellingButton.setBackgroundImage(UIImage(named: "underline"), for: .normal)
        soldButton.setBackgroundImage(nil, for: .normal)
        queryAds()
    }
    
    
    // ------------------------------------------------
    // MARK: - SOLD BUTTON
    // ------------------------------------------------
    @IBAction func soldButt(_ sender: UIButton) {
        isSelling = false
        soldButton.setBackgroundImage(UIImage(named: "underline"), for: .normal)
        sellingButton.setBackgroundImage(nil, for: .normal)
        queryAds()
    }
    
    
    // ------------------------------------------------
    // MARK: - LIKED BUTTON
    // ------------------------------------------------
    @IBAction func likedButt(_ sender: UIButton) {
        isSelling = false
        isLiked = true
        likedButton.setBackgroundImage(UIImage(named: "underline"), for: .normal)
        sellingButton.setBackgroundImage(nil, for: .normal)
        soldButton.setBackgroundImage(nil, for: .normal)
        queryAds()
    }
    
    
    
    
    
    // ------------------------------------------------
    // MARK: - FOLLOW BUTTON
    // ------------------------------------------------
    @IBAction func followButt(_ sender: UIButton) {
        let currentUser = PFUser.current()!
        
        // FOLLOW THIS USER
        if sender.titleLabel!.text == "Follow" {
            // Save Follow
            let fObj = PFObject(className: FOLLOW_CLASS_NAME)
            fObj[FOLLOW_CURRENT_USER] = currentUser
            fObj[FOLLOW_IS_FOLLOWING] = userObj
            fObj.saveInBackground { (succ, error) in
                if error == nil {
                    self.followButton.setTitle("Following", for: .normal)
                    self.followButton.backgroundColor = UIColor.white
                    self.followButton.setTitleColor(MAIN_COLOR, for: .normal)

                    // Send Push Notification
                    let pushMessage = "\(currentUser[USER_FULLNAME]!) started following you"
                    self.sendPushNotification(userPointer: self.userObj, pushMessage: pushMessage)
                    
                    // Query Ads and add currentUser as follower
                    let query = PFQuery(className: ADS_CLASS_NAME)
                    query.whereKey(ADS_SELLER_POINTER, equalTo: self.userObj)
                    query.findObjectsInBackground { (objects, error) in
                        if error == nil {
                            for i in 0..<objects!.count {
                                var adObj = PFObject(className: ADS_CLASS_NAME)
                                adObj = objects![i]
                                var followedBy = adObj[ADS_FOLLOWED_BY] as! [String]
                                followedBy.append(currentUser.objectId!)
                                adObj[ADS_FOLLOWED_BY] = followedBy
                                adObj.saveInBackground()
                            }
                        // error
                        } else { self.simpleAlert("\(error!.localizedDescription)")
                    }}// ./ query Ads

                // error
                } else { self.simpleAlert("\(error!.localizedDescription)")
            }}// ./ saveInBackground
            
            
        // UN-FOLLOW THIS USER
        } else {
            // Query Follow
            let query = PFQuery(className: FOLLOW_CLASS_NAME)
            query.whereKey(FOLLOW_IS_FOLLOWING, equalTo: userObj)
            query.whereKey(FOLLOW_CURRENT_USER, equalTo: currentUser)
            query.findObjectsInBackground { (objects, error) in
                if error == nil {
                    var fObj = PFObject(className: FOLLOW_CLASS_NAME)
                    fObj = objects![0]
                    fObj.deleteInBackground(block: { (succ, error) in
                        if error == nil {
                            self.followButton.setTitle("Follow", for: .normal)
                            self.followButton.backgroundColor = MAIN_COLOR
                            self.followButton.setTitleColor(UIColor.white, for: .normal)
                            
                            // Query Ads and remove currentUser as follower
                            let query = PFQuery(className: ADS_CLASS_NAME)
                            query.whereKey(ADS_SELLER_POINTER, equalTo: self.userObj)
                            query.findObjectsInBackground { (ads, error) in
                                if error == nil {
                                    for i in 0..<ads!.count {
                                        var adObj = PFObject(className: ADS_CLASS_NAME)
                                        adObj = ads![i]
                                        var followedBy = adObj[ADS_FOLLOWED_BY] as! [String]
                                        followedBy = followedBy.filter{ $0 != currentUser.objectId! }
                                        adObj[ADS_FOLLOWED_BY] = followedBy
                                        adObj.saveInBackground()
                                    }
                                // error
                                } else { self.simpleAlert("\(error!.localizedDescription)")
                            }}// ./ query Ads
                            
                        // error
                        } else { self.simpleAlert("\(error!.localizedDescription)")
                    }})// ./ deleteInBackground
                
                // error
                } else { self.simpleAlert("\(error!.localizedDescription)")
            }}// ./ query Follow
        }
    }
    
    
    
    
    
    
    // ------------------------------------------------
    // MARK: - OPTIONS BUTTON
    // ------------------------------------------------
    @IBAction func optionsButt(_ sender: UIButton) {
        
        // currentUser IS LOGGED IN!
        if PFUser.current() != nil {
            let alert = UIAlertController(title: APP_NAME,
                message: "Select option",
                preferredStyle: .actionSheet)
        
                // Check blocked users array
                let currentUser = PFUser.current()!
                var hasBlocked = currentUser[USER_HAS_BLOCKED] as! [String]
            
                // Set blockUser Action title
                var blockTitle = String()
                if hasBlocked.contains(userObj.objectId!) { blockTitle = "Unblock User"
                } else { blockTitle = "Block User" }
            
            
                // BLOCK USER ----------------------------------------
                let blockUser = UIAlertAction(title: blockTitle, style: .default, handler: { (action) -> Void in
                    // Block User
                    if blockTitle == "Block User" {
                        hasBlocked.append(self.userObj.objectId!)
                        currentUser[USER_HAS_BLOCKED] = hasBlocked
                        currentUser.saveInBackground(block: { (succ, error) in
                            if error == nil {
                                self.simpleAlert("You've blocked \(self.userObj[USER_FULLNAME]!).")
                                self.blockedUserView.isHidden = false
                            }})
                        
                    // UNBLOCK USER ----------------------------------------
                    } else {
                        let hasBlocked2 = hasBlocked.filter{$0 != "\(self.userObj.objectId!)"}
                        currentUser[USER_HAS_BLOCKED] = hasBlocked2
                        currentUser.saveInBackground(block: { (succ, error) in
                            if error == nil {
                                self.simpleAlert("You've unblocked \(self.userObj[USER_FULLNAME]!).")
                                self.blockedUserView.isHidden = true
                        }})
                    }
                })
                alert.addAction(blockUser)
            
        
        
        
                // REPORT USER ----------------------------------------
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
                                    }// ./ For
                                    
                                // error
                                } else { self.hideHUD(); self.simpleAlert("\(error!.localizedDescription)")
                            }}// ./ query
                            
                        // error
                        } else { self.hideHUD(); self.simpleAlert("\(error!.localizedDescription)")
                    }})// ./ PFCloud
                })
                alert.addAction(reportUser)
            
            
            
            
                // CANCEL BUTTON ----------------------------------------------------------
                let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
                alert.addAction(cancel)
            
            
                if UIDevice.current.userInterfaceIdiom == .pad {
                    // iPad
                    alert.modalPresentationStyle = .popover
                    alert.popoverPresentationController?.sourceView = view
                    alert.popoverPresentationController?.sourceRect = sender.frame
                    present(alert, animated: true, completion: nil)
                } else {
                    // iPhone
                    present(alert, animated: true, completion: nil)
                }
            
            
            
        // currentUser IS NOT LOGGED IN...
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "Intro") as! Intro
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    
    
    // ------------------------------------------------
    // MARK: - BACK BUTTON
    // ------------------------------------------------
    @IBAction func backButt(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
}// ./ end
