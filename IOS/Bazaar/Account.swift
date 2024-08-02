/*==================================================
 Bazaar
 
 © XScoder 2018
 All Rights reserved
 
 RE-SELLING THIS SOURCE CODE TO ANY ONLINE MARKETPLACE IS A SERIOUS COPYRIGHT INFRINGEMENT.
 YOU WILL BE LEGALLY PROSECUTED
 
===================================================*/

import UIKit
import Parse

class Account: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    /*--- VIEWS ---*/
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var sellingButton: UIButton!
    @IBOutlet weak var soldButton: UIButton!
    @IBOutlet weak var likedButton: UIButton!
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var adsCollView: UICollectionView!
    @IBOutlet weak var sellStuffView: UIView!
    @IBOutlet weak var verifiedLabel: UILabel!
    
    

    /*--- VARIABLES --*/
    var isCurrentUser = false
    var isSelling = true
    var isLiked = false
    var adsArray = [PFObject]()
    
    
    
    
    // ------------------------------------------------
    // MARK: - VIEW DID APPEAR
    // ------------------------------------------------
    override func viewDidAppear(_ animated: Bool) {
        // CURRENT USER IS NOT LOGGED IN...
        if PFUser.current() == nil {
            let vc = storyboard?.instantiateViewController(withIdentifier: "Intro") as! Intro
            navigationController?.pushViewController(vc, animated: true)
        
            
        // CURRENT USER IS LOGGED IN!
        } else {
            // Show/Hide Back button
            if isCurrentUser { backButton.isHidden = false
            } else { backButton.isHidden = true }
            
            // Call function
            showUserInfo()
            
            // Recall query
            if !noReload || mustReload {
                noReload = true
                mustReload = false
                
                queryAds()
            }
        }
    }
    
    
    
    // ------------------------------------------------
    // MARK: - VIEW DID LOAD
    // ------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        // Layouts
        avatarImg.layer.cornerRadius = avatarImg.bounds.size.width/2
        sellStuffView.layer.cornerRadius = 22
        
        // iPhone X/S, iPhone XS Max, XR
        if UIScreen.main.bounds.size.height == 812 || UIScreen.main.bounds.size.height == 896 {
            sellStuffView.frame.origin.y = view.frame.size.height - 90 - sellStuffView.frame.size.height
            adsCollView.frame.size.height = adsCollView.frame.size.height - sellStuffView.frame.size.height
        }
        
        // Call query
        if PFUser.current() != nil { queryAds() }
    }
    
    
    
    // ------------------------------------------------
    // MARK: - SHOW USER'S INFO
    // ------------------------------------------------
    func showUserInfo() {
        var currentUser = PFUser.current()!
        do { try currentUser = PFUser.current()!.fetch() } catch { print("\(error)") }
        
        // Verified
        if currentUser["emailVerified"] != nil {
            verifiedLabel.text = "Verified"
        } else {
            verifiedLabel.text = "Not Verified yet"
        }
        
        // Full name
        
        let fullname = currentUser[USER_FULLNAME] ?? ""
        fullnameLabel.text = "\(fullname)"
        
        // Avatar
        getParseImage(object: currentUser, colName: USER_AVATAR, imageView: avatarImg)
        
        // Bio
        if currentUser[USER_BIO] != nil { bioLabel.text = "\(currentUser[USER_BIO]!)"
        } else { bioLabel.text = "" }
    }
    
    
    
    
    
    // ------------------------------------------------
    // MARK: - QUERY ADS
    // ------------------------------------------------
    func queryAds() {
        let currentUser = PFUser.current()!
        
        // Reset data
        adsArray.removeAll()
        adsCollView.reloadData()
        
        showHUD()
        
        // Query
        let query = PFQuery(className: ADS_CLASS_NAME)
        
        if isSelling && !isLiked {
            query.whereKey(ADS_SELLER_POINTER, equalTo: currentUser)
            query.whereKey(ADS_IS_SOLD, equalTo: false)
        
        } else if !isSelling && !isLiked {
            query.whereKey(ADS_SELLER_POINTER, equalTo: currentUser)
            query.whereKey(ADS_IS_SOLD, equalTo: true)
        
        } else if isLiked && !isSelling {
            query.whereKey(ADS_LIKED_BY, containedIn: [currentUser.objectId!])
            query.whereKey(ADS_IS_REPORTED, equalTo: false)
        }
        query.order(byDescending: ADS_CREATED_AT)
        
        // Perform query
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
        
        // Sold badge
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
        isLiked = false
        sellingButton.setBackgroundImage(UIImage(named: "underline"), for: .normal)
        soldButton.setBackgroundImage(nil, for: .normal)
        likedButton.setBackgroundImage(nil, for: .normal)
        queryAds()
    }
    
    
    // ------------------------------------------------
    // MARK: - SOLD BUTTON
    // ------------------------------------------------
    @IBAction func soldButt(_ sender: UIButton) {
        isSelling = false
        isLiked = false
        soldButton.setBackgroundImage(UIImage(named: "underline"), for: .normal)
        sellingButton.setBackgroundImage(nil, for: .normal)
        likedButton.setBackgroundImage(nil, for: .normal)
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
    // MARK: - SELL STUFF BUTTON
    // ------------------------------------------------
    @IBAction func sellStuffButt(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SellEditStuff") as! SellEditStuff
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
    
    
    
    // ------------------------------------------------
    // MARK: - SETTINGS BUTTON
    // ------------------------------------------------
    @IBAction func settingsButt(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "Settings") as! Settingss
        navigationController?.pushViewController(vc, animated: true)
    }
    

    
    
    
    // ------------------------------------------------
    // MARK: - BACK BUTTON
    // ------------------------------------------------
    @IBAction func backButt(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    
    // ------------------------------------------------
    // MARK: - VIEW DI DISAPPEAR
    // ------------------------------------------------
    override func viewDidDisappear(_ animated: Bool) {
        isCurrentUser = false
        isLiked = false
        isSelling = true
    }
    
    
    
}// ./ end
