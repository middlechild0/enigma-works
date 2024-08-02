/*==================================================
 Bazaar
 
 © XScoder 2018
 All Rights reserved
 
 RE-SELLING THIS SOURCE CODE TO ANY ONLINE MARKETPLACE IS A SERIOUS COPYRIGHT INFRINGEMENT.
 YOU WILL BE LEGALLY PROSECUTED
 
==================================================*/

import UIKit
import Parse
import MapKit

class AdInfo: UIViewController, MKMapViewDelegate {

    /*--- VIEWS ---*/
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var aMap: MKMapView!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var buttonsLeftView: UIView!
    @IBOutlet weak var soldLabel: UILabel!
    

    
    /*--- VARIABLES ---*/
    var adObj = PFObject(className: ADS_CLASS_NAME)
    
    
    
    // ------------------------------------------------
    // MARK: - VIEW DID APPEAR
    // ------------------------------------------------
    override func viewDidAppear(_ animated: Bool) {
        if mustDismiss {
            mustDismiss = false
            _ = navigationController?.popViewController(animated: true)
        }
    }

    // ------------------------------------------------
    // MARK: - VIEW DID LOAD
    // ------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        noReload = true
              
        // Layouts
        aMap.layer.cornerRadius = 6
        buttonsLeftView.layer.cornerRadius = 25
        avatarButton.layer.cornerRadius = avatarButton.bounds.size.width/2
        chatButton.layer.cornerRadius = 22
        if #available(iOS 11.0, *) { containerScrollView.contentInsetAdjustmentBehavior = .never }

        
        
        // Increment Ad Views
        adObj.incrementKey(ADS_VIEWS, byAmount: 1)
        adObj.saveInBackground()
        
        
        // Call function
        showAdInfo()
    }

    
    
    
    
    // ------------------------------------------------
    // MARK: - SHOW AD'S INFO
    // ------------------------------------------------
    func showAdInfo() {
            // Ad Liked/Not liked
            if PFUser.current() != nil {
                let currentUser = PFUser.current()!
                let likedBy = adObj[ADS_LIKED_BY] as! [String]
                if likedBy.contains(currentUser.objectId!) {
                    likeButton.setBackgroundImage(UIImage(named: "liked_butt"), for: .normal)
                }
            }
            
            // User Pointer
            let userPointer = adObj[ADS_SELLER_POINTER] as! PFUser
            userPointer.fetchIfNeededInBackground(block: { (user, error) in
                if error == nil {
                    // Avatar
                    self.getParseImage(object: userPointer, colName: USER_AVATAR, button: self.avatarButton)
                    
                // error
                } else { self.simpleAlert("\(error!.localizedDescription)")
            }})// ./ userPointer
            
            
            // isSold
            let isSold = adObj[ADS_IS_SOLD] as! Bool
            if isSold {
                soldLabel.isHidden = false
                chatButton.isHidden = true
            } else {
                soldLabel.isHidden = true
            }
            
            // Hide chatButton in case of currentUser
            if PFUser.current() != nil {
                let currentUser = PFUser.current()!
                if currentUser.objectId == userPointer.objectId {
                    chatButton.isHidden = true
                }
            }
            
            // First image
            getParseImage(object: adObj, colName: ADS_IMAGE1, imageView: firstImage)
            // Title
            titleLabel.text = "\(adObj[ADS_TITLE]!)"
            // Price
            let isNegotiable = adObj[ADS_IS_NEGOTIABLE] as! Bool
            if isNegotiable { priceLabel.text = "\(adObj[ADS_CURRENCY]!) \(adObj[ADS_PRICE]!) - Negotiable"
            } else { priceLabel.text = "\(adObj[ADS_CURRENCY]!) \(adObj[ADS_PRICE]!)" }
        
         print("AD OBJECT allkey: \(String(describing: adObj.allKeys))")
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
                              shippingLabel.attributedText = attributedString
                          }else{
                              
                              let attachment:NSTextAttachment = NSTextAttachment()
                              attachment.image = UIImage(named: "shipping")
                              let attachmentString:NSAttributedString = NSAttributedString(attachment: attachment)
                              let attributedString:NSMutableAttributedString = NSMutableAttributedString(string:"")
                              attributedString.append(attachmentString)
                              let label = " Ships for " + "\(adObj[ADS_CURRENCY]!) \(adObj[ADS_SHIPPING]!)"
                              attributedString.append(NSMutableAttributedString(string:label))
                              shippingLabel.attributedText = attributedString
                          }
                          
                      }else{
                          shippingLabel.text = ""
                      }
                  }else{
                      shippingLabel.text = ""
                  }
              }else{
                  shippingLabel.text = ""
              }
               
            // Date
            dateLabel.text = timeAgoSinceDate(adObj.createdAt!, currentDate: Date(), numericDates: true)
            // Views
            let views = adObj[ADS_VIEWS] as! Int
            viewsLabel.text = views.rounded
            // Likes
            let likes = adObj[ADS_LIKES] as! Int
            likesLabel.text = likes.rounded
            // Location
            setAdLocation()
            // Description
            descriptionTxt.text = "\(adObj[ADS_DESCRIPTION]!)"
            descriptionTxt.sizeToFit()
            
            // Layouts
            bottomView.frame.origin.y = descriptionTxt.frame.size.height + descriptionTxt.frame.origin.y + 20
            containerScrollView.contentSize = CGSize(width: containerScrollView.frame.size.width,
                                                     height: bottomView.frame.origin.y + bottomView.frame.size.height + 50)
        
    }
    
    
    
    
    
    // ------------------------------------------------
    // MARK: - SET AD LOCATION
    // ------------------------------------------------
    func setAdLocation() {
        let gp = adObj[ADS_LOCATION] as! PFGeoPoint
        let location = CLLocation(latitude: gp.latitude, longitude: gp.longitude)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            let placeArray:[CLPlacemark] = placemarks!
            var placemark: CLPlacemark!
            placemark = placeArray[0]
            let city = placemark.addressDictionary?["City"] as? String ?? ""
            let country = placemark.addressDictionary?["Country"] as? String ?? ""
            // Show Location
            self.locationLabel.text = "\(city), \(country)"
            
            // Show Map Area
            self.showMapArea()
        })
    }
    
    
    // ------------------------------------------------
    // MARK: - SHOW MAP PIN
    // ------------------------------------------------
    func showMapArea() {
        aMap.delegate = self
        
        // Ad's location
        let gp = adObj[ADS_LOCATION] as! PFGeoPoint
        let location = CLLocation(latitude: gp.latitude, longitude: gp.longitude)
        
        aMap.centerCoordinate = location.coordinate
        
        // Zoom the Map to the location
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000);
        aMap.setRegion(region, animated: true)
        aMap.regionThatFits(region)
        aMap.reloadInputViews()
    }
    
    
    // ------------------------------------------------
    // MARK: - OPEN THE NATIVE iOS MAPS APP
    // ------------------------------------------------
    @IBAction func openMapsButt(_ sender: Any) {
        // Ad's location
        let gp = adObj[ADS_LOCATION] as! PFGeoPoint
        let location = CLLocation(latitude: gp.latitude, longitude: gp.longitude)
        let coords = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let placemark = MKPlacemark(coordinate: coords, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(adObj[ADS_TITLE]!)"
        mapItem.openInMaps(launchOptions: nil)
    }


    
    // ------------------------------------------------
    // MARK: - SHOW PHOTOS
    // ------------------------------------------------
    @IBAction func showPhotosButt(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AdPhotos") as! AdPhotos
        vc.adObj = adObj
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)

    }
    
    
    
    // ------------------------------------------------
    // MARK: - LIKE BUTTON
    // ------------------------------------------------
    @IBAction func likeButt(_ sender: UIButton) {
        
        // currentUser is Logged IN
        if PFUser.current() != nil {
            let currentUser = PFUser.current()!
            var likedBy = adObj[ADS_LIKED_BY] as! [String]
        
            // MARK: - UNLIKE AD ----------------------
            if likedBy.contains(currentUser.objectId!) {
                likedBy = likedBy.filter{$0 != currentUser.objectId!}
                adObj[ADS_LIKED_BY] = likedBy
                adObj.incrementKey(ADS_LIKES, byAmount: -1)
                adObj.saveInBackground()
                sender.setBackgroundImage(UIImage(named: "like_butt"), for: .normal)
             
                
            // MARK: - LIKE AD ----------------------
            } else {
                likedBy.append(currentUser.objectId!)
                adObj[ADS_LIKED_BY] = likedBy
                adObj.incrementKey(ADS_LIKES, byAmount: 1)
                adObj.saveInBackground()
                sender.setBackgroundImage(UIImage(named: "liked_butt"), for: .normal)

                // User Pointer
                let userPointer = adObj[ADS_SELLER_POINTER] as! PFUser
                userPointer.fetchIfNeededInBackground(block: { (user, error) in
                    if error == nil {
                        
                        // Send Push Notification
                        let pushMessage = "\(currentUser[USER_FULLNAME]!) liked your Ad: '\(self.adObj[ADS_TITLE]!)'"
                        self.sendPushNotification(userPointer: userPointer, pushMessage: pushMessage)
                        
                    // error
                    } else { self.simpleAlert("\(error!.localizedDescription)")
                }})// ./ userPointer
            }
            
            
        // currentUser is logged OUT
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "Intro") as! Intro
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    
    
    // ------------------------------------------------
    // MARK: - AVATAR BUTTON
    // ------------------------------------------------
    @IBAction func avatarButt(_ sender: Any) {
        // User Pointer
        let userPointer = adObj[ADS_SELLER_POINTER] as! PFUser
        userPointer.fetchIfNeededInBackground(block: { (user, error) in
            if error == nil {
                
                // CURRENT USER IS LOGGED IN!
                if PFUser.current() != nil {
                    let currentUser = PFUser.current()!
                    if userPointer.objectId != currentUser.objectId {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserProfile") as! UserProfile
                        vc.userObj = userPointer
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Account") as! Account
                        vc.isCurrentUser = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                // CURRENT USER IS NOT LOGGED IN...
                } else {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserProfile") as! UserProfile
                    vc.userObj = userPointer
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            // error
            } else { self.simpleAlert("\(error!.localizedDescription)")
        }})// ./ userPointer
    }
    
    
    
    
    
    // ------------------------------------------------
    // MARK: - OPTIONS BUTTON
    // ------------------------------------------------
    @IBAction func optionsButt(_ sender: UIButton) {
        // currentUser is Logged IN
        if PFUser.current() != nil {
            let currentUser = PFUser.current()!
            
            // User Pointer
            let userPointer = adObj[ADS_SELLER_POINTER] as! PFUser
            userPointer.fetchIfNeededInBackground(block: { (user, error) in
                if error == nil {
                    
                    // Fire alert
                    let alert = UIAlertController(title: APP_NAME,
                        message: "Select option",
                        preferredStyle: .actionSheet)
                    
                    
                    // ------------------------------------------------
                    // MARK: - THIS AD IS NOT BY CURRENT USER
                    // ------------------------------------------------
                    if userPointer.objectId != currentUser.objectId {

                        // REPORT AD -------------------------------------------------------
                        let report = UIAlertAction(title: "Report Ad", style: .destructive, handler: { (action) -> Void in
                            let alert = UIAlertController(title: APP_NAME,
                                message: "Are you sure you want to report this Ad?",
                                preferredStyle: .alert)
                            
                            // Yes
                            let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
                                self.adObj[ADS_IS_REPORTED] = true
                                self.adObj.saveInBackground()
                                self.simpleAlert("The Ad has been reported. Thanks")
                            })
                            
                            // No
                            let no = UIAlertAction(title: "No", style: .cancel, handler: { (action) -> Void in })
                            
                            alert.addAction(yes)
                            alert.addAction(no)
                            self.present(alert, animated: true, completion: nil)
                        })
                        alert.addAction(report)
                    
                    
                        
                        // ------------------------------------------------
                        // MARK: - THIS AD IS BY CURRENT USER
                        // -------------------------------------------------
                        } else {
                        
                            // EDIT YOUR OWN AD -------------------------------------------------------
                            let editAd = UIAlertAction(title: "Edit Ad", style: .default, handler: { (action) -> Void in
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SellEditStuff") as! SellEditStuff
                                vc.adObj = self.adObj
                                vc.modalPresentationStyle = .fullScreen
                                self.present(vc, animated: true, completion: nil)
                            })
                            alert.addAction(editAd)
                        
                        
                            // DELETE YOUR OWN AD -------------------------------------------------------
                            let deleteAd = UIAlertAction(title: "Delete Ad", style: .destructive, handler: { (action) -> Void in
                                let alert = UIAlertController(title: APP_NAME,
                                    message: "Are you sure you want to delete this Ad?",
                                    preferredStyle: .alert)
                                
                                let delete = UIAlertAction(title: "Delete", style: .default, handler: { (action) -> Void in
                                    self.adObj.deleteInBackground(block: { (succ, error) in
                                        if error == nil {
                                            
                                            // Query and Delete Chats relative to this Ad (if any)
                                            let query = PFQuery(className: CHATS_CLASS_NAME)
                                            query.whereKey(CHATS_AD_POINTER, equalTo: self.adObj)
                                            query.findObjectsInBackground { (objects, error) in
                                                if error == nil {
                                                    if objects!.count != 0 {
                                                        for i in 0..<objects!.count {
                                                            var cObj = PFObject(className: CHATS_CLASS_NAME)
                                                            cObj = objects![i]
                                                            cObj.deleteInBackground();
                                                        }// ./ For
                                                    }// ./ If
                                                    
                                                // error
                                                } else { self.hideHUD(); self.simpleAlert("\(error!.localizedDescription)")
                                            }}
                                            
                                            // Fire alert2
                                            let alert2 = UIAlertController(title: APP_NAME,
                                                message: "Your Ad has been successfully deleted!",
                                                preferredStyle: .alert)
                                            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                                    noReload = false
                                                    _ = self.navigationController?.popViewController(animated: true)
                                            })
                                            alert2.addAction(ok)
                                            self.present(alert2, animated: true, completion: nil)
                                            
                                        // error
                                        } else { self.hideHUD(); self.simpleAlert("\(error!.localizedDescription)")
                                    }})
                                })
                                alert.addAction(delete)
                                
                                
                                // Cancel
                                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })
                                alert.addAction(cancel)
                                self.present(alert, animated: true, completion: nil)
                            })
                            alert.addAction(deleteAd)
                        
                        }// ./ If
                    
                    
                    
                    
                    // SHARE AD ------------------------------------------------
                    let share = UIAlertAction(title: "Share Ad", style: .default, handler: { (action) -> Void in
                        let message  = "Look what I've just found on \(APP_NAME)! - \(self.adObj[ADS_TITLE]!) - posted by \(userPointer[USER_FULLNAME]!)"
                        let img = self.firstImage.image!
                        
                        let shareItems = [message, img] as [Any]
                        let actVC = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
                        actVC.excludedActivityTypes = [.print, .postToWeibo, .copyToPasteboard, .addToReadingList, .postToVimeo]
                        
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            // iPad
                            actVC.modalPresentationStyle = .popover
                            actVC.popoverPresentationController?.sourceView = self.view
                            actVC.popoverPresentationController?.sourceRect = sender.frame
                            self.present(actVC, animated: true, completion: nil)
                        } else {
                            // iPhone
                            self.present(actVC, animated: true, completion: nil)
                        }
                    })
                    alert.addAction(share)
                    
                    
                    
                    // CANCEL BUTTON ---------------------------------------
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })
                    alert.addAction(cancel)
                    
                    
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        // iPad
                        alert.modalPresentationStyle = .popover
                        alert.popoverPresentationController?.sourceView = self.view
                        alert.popoverPresentationController?.sourceRect = sender.frame
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        // iPhone
                        self.present(alert, animated: true, completion: nil)
                    }
            
                // error
                } else { self.simpleAlert("\(error!.localizedDescription)")
            }})// ./ userPointer
            
            
            
        // currentUser is logged OUT
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "Intro") as! Intro
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    
    
    // ------------------------------------------------
    // MARK: - CHAT NOW BUTTON
    // ------------------------------------------------
    @IBAction func chatButt(_ sender: Any) {
        // currentUser IS LOGGED IN!
        if PFUser.current() != nil {
            let currentUser = PFUser.current()!
        
            // User Pointer
            let userPointer = adObj[ADS_SELLER_POINTER] as! PFUser
            userPointer.fetchIfNeededInBackground(block: { (user, error) in
                if error == nil {
                    
                    let hasBlocked = userPointer[USER_HAS_BLOCKED] as! [String]
                    if hasBlocked.contains(currentUser.objectId!) {
                        self.simpleAlert("\(userPointer[USER_FULLNAME]!) has blocked you, you can no longer chat with this User.")
                    } else {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Messages") as! Messages
                        vc.adObj = self.adObj
                        vc.userObj = userPointer
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                // error
                } else { self.simpleAlert("\(error!.localizedDescription)")
            }})// ./ userPointer
            
            
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
