/*==================================================
 Bazaar
 
 © XScoder 2018
 All Rights reserved
 
 RE-SELLING THIS SOURCE CODE TO ANY ONLINE MARKETPLACE IS A SERIOUS COPYRIGHT INFRINGEMENT.
 YOU WILL BE LEGALLY PROSECUTED
 
===================================================*/

import UIKit
import Parse


class FollowingAds: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    /*--- VIEWS ---*/
    @IBOutlet weak var followingCollView: UICollectionView!
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var noResultslabel: UILabel!
    
    
    
    /*--- VARIABLES ---*/
    var adsArray = [PFObject]()
    
    
    
    
    // ------------------------------------------------
    // MARK: - VIEW DID APPEAR
    // ------------------------------------------------
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() == nil {
            let vc = storyboard?.instantiateViewController(withIdentifier: "Intro") as! Intro
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    
    // ------------------------------------------------
    // MARK: - VIEW DID LOAD
    // ------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Layouts
        followingCollView.backgroundColor = UIColor.clear
        
        
        // Refresh Control
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        followingCollView.alwaysBounceVertical = true
        followingCollView.addSubview(refreshControl)
        
        
        // Call query
        if PFUser.current() != nil { queryFollwingAds() }
    }

    
    
    
    // ------------------------------------------------
    // MARK: - QUERY FOLLOWING ADS
    // ------------------------------------------------
    func queryFollwingAds() {
        adsArray.removeAll()
        followingCollView.reloadData()
        noResultslabel.isHidden = true
        let currentuser = PFUser.current()!
        showHUD()
        
        // Query
        let query = PFQuery(className: ADS_CLASS_NAME)
        query.whereKey(ADS_FOLLOWED_BY, containedIn: [currentuser.objectId!])
        
        // Perform query
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                self.adsArray = objects!
                self.hideHUD()
                self.followingCollView.reloadData()
                
                // Show/hide noResult view
                if self.adsArray.count == 0 { self.noResultslabel.isHidden = false
                } else { self.noResultslabel.isHidden = true }
            
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
    // MARK: - SHOW AD's INFO
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
    // MARK: - REFRESH DATA
    // ------------------------------------------------
    @objc func refreshData () {
        // Recall query
        queryFollwingAds()
        
        if refreshControl.isRefreshing { refreshControl.endRefreshing() }
    }

    
}// ./ end
