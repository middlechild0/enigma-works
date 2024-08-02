/*==================================================
 Bazaar
 
 © XScoder 2018
 All Rights reserved
 
 RE-SELLING THIS SOURCE CODE TO ANY ONLINE MARKETPLACE IS A SERIOUS COPYRIGHT INFRINGEMENT.
 YOU WILL BE LEGALLY PROSECUTED
 
===================================================*/

import Foundation
import UIKit
import AVFoundation
import CoreLocation
import GoogleMobileAds
import AudioToolbox
import Parse
import SystemConfiguration


// ------------------------------------------------
// MARK: - REPALCE THE STRING BELOW TO SET YOUR OWN APP NAME
// ------------------------------------------------
let APP_NAME = "Local: Buy & Sell"



// ------------------------------------------------
// MARK: - REPLACE THE STRINGS BELOW WITH YOUR OWN 'App ID' AND 'Client Key' FROM YOUR PARSE APP ON https://back4app.com
// ------------------------------------------------
let PARSE_APP_ID = "XTdyD5yrO5df5oRe7kjT7q9oYMZo9PwuoRkJipMm"
let PARSE_CLIENT_KEY = "02iaJBShPaVdlvTjJLMTtbmwZDZQZfGCU8FwQEIP"



// ------------------------------------------------
// MARK: - REPLACE THE RED STRING BELOW WITH YOUR OWN BANNER UNIT ID YOU'LL GET FROM  http://apps.admob.com
// ------------------------------------------------
let ADMOB_INTERSTITIAL_UNIT_ID = "ca-app-pub-3434790868889976/1759373883"



// ------------------------------------------------
// MARK: - EDIT THE CURRENCY CODE BELOW AS YOU WISH
// ------------------------------------------------
let CURRENCY_CODE = "USD"



// ------------------------------------------------
// MARK: - EDIT THE RGBA VALUES BELOW AS YOU WISH
// ------------------------------------------------
let MAIN_COLOR = UIColor(red: 83/255, green: 156/255, blue: 253/255, alpha: 1)
let LIGHT_GREY = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)



// ------------------------------------------------
// MARK: - EDIT THE GPS COORDINATES BELOW AS YOU WISH, IN ORDER TO SET THE DEFAULT LOCATION'S COORDINATES
// ------------------------------------------------
let DEFAULT_LOCATION = CLLocation(latitude: 40.7143528, longitude: -74.0059731)



// ------------------------------------------------
// MARK: - EDIT THE EMAIL ADDRESS BELOW AS YOU WISH, IN ORDER TO ALLOW CLIENTS TO CONTACT YOU IN CASE OF SUPPORT
// ------------------------------------------------
let SUPPORT_EMAIL_ADDRESS = "localbuyandsellapp@gmail.com"



// ------------------------------------------------
// MARK: - ARRAY OF STUFF CATEGORIES - YOU CAN EDIT IT AS YOU WISH
// ------------------------------------------------
var categoriesArray = [
    "Accessories",
    "Home",
    "Fashion",
    "Tech",
    "Pets",
    "Auto",
    "Artists",
    "Services",
    "Other",
]




// ------------------------------------------------
// MARK: - UTILITY EXTENSIONS
// ------------------------------------------------
var hud = UIView()
var loadingCircle = UIImageView()
var toast = UILabel()

extension UIViewController {
    // ------------------------------------------------
    // MARK: - SHOW TOAST MESSAGE
    // ------------------------------------------------
    func showToast(_ message:String) {
        toast = UILabel(frame: CGRect(x: view.frame.size.width/2 - 100,
                                      y: view.frame.size.height-140,
                                      width: 200,
                                      height: 32))
        toast.font = UIFont(name: "OpenSans-Bold", size: 14)
        toast.textColor = UIColor.white
        toast.textAlignment = .center
        toast.adjustsFontSizeToFitWidth = true
        toast.text = message
        toast.layer.cornerRadius = 14
        toast.clipsToBounds = true
        toast.backgroundColor = MAIN_COLOR
        view.addSubview(toast)
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(hideToast), userInfo: nil, repeats: false)
    }
    @objc func hideToast() {
        toast.removeFromSuperview()
    }
    
    // ------------------------------------------------
    // MARK: - SHOW/HIDE LOADING HUD
    // ------------------------------------------------
    func showHUD() {
        hud.frame = CGRect(x:0, y:0,
                           width:view.frame.size.width,
                           height: view.frame.size.height)
        hud.backgroundColor = UIColor.white
        hud.alpha = 0.7
        view.addSubview(hud)
        
        loadingCircle.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        loadingCircle.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
        loadingCircle.image = UIImage(named: "loading_circle")
        loadingCircle.contentMode = .scaleAspectFill
        loadingCircle.clipsToBounds = true
        animateLoadingCircle(imageView: loadingCircle, time: 0.8)
        view.addSubview(loadingCircle)
    }
    func animateLoadingCircle(imageView: UIImageView, time: Double) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = -Double.pi * 2
        rotationAnimation.duration = time
        rotationAnimation.repeatCount = .infinity
        imageView.layer.add(rotationAnimation, forKey: nil)
    }
    func hideHUD() {
        hud.removeFromSuperview()
        loadingCircle.removeFromSuperview()
    }
    
    // ------------------------------------------------
    // MARK: - FIRE A SIMPLE ALERT
    // ------------------------------------------------
    func simpleAlert(_ mess:String) {
        let alert = UIAlertController(title: APP_NAME,
            message: mess, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    // ------------------------------------------------
    // MARK: - SHOW ADMOB INTERSTITIAL ADS
    // ------------------------------------------------
    func showInterstitial() {
        let adMobInterstitial = GADInterstitial(adUnitID: ADMOB_INTERSTITIAL_UNIT_ID)
        adMobInterstitial.load(GADRequest())
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            if adMobInterstitial.isReady {
                adMobInterstitial.present(fromRootViewController: self)
                print("AdMob Interstitial!")
        }})
    }
    
    // ------------------------------------------------
    // MARK: - GET PARSE IMAGE - IMAGEVIEW
    // ------------------------------------------------
    func getParseImage(object:PFObject, colName:String, imageView:UIImageView) {
        let imageFile = object[colName] as? PFFileObject
        imageFile?.getDataInBackground(block: { (imageData, error) in
            if error == nil {
                if let imageData = imageData {
                    imageView.image = UIImage(data:imageData)
        }}})
    }
    
    
    // ------------------------------------------------
    // MARK: - GET PARSE IMAGE - BUTTON
    // ------------------------------------------------
    func getParseImage(object:PFObject, colName:String, button:UIButton) {
        let imageFile = object[colName] as? PFFileObject
        imageFile?.getDataInBackground(block: { (imageData, error) in
            if error == nil {
                if let imageData = imageData {
                    button.setImage(UIImage(data:imageData), for: .normal)
        }}})
    }
    
    
    // ------------------------------------------------
    // MARK: - SAVE PARSE IMAGE
    // ------------------------------------------------
    func saveParseImage(object:PFObject, colName:String, imageView:UIImageView) {
        let imageData = imageView.image!.jpegData(compressionQuality: 1.0)
        let imageFile = PFFileObject(name:"image.jpg", data:imageData!)
        object[colName] = imageFile
    }
    
    // ------------------------------------------------
    // MARK: - PROPORTIONALLY SCALE AN IMAGE TO MAX WIDTH
    // ------------------------------------------------
    func scaleImageToMaxWidth(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    // ------------------------------------------------
    // MARK: - CREATE A THUMBNAIL IMAGE OF A VIDEO
    // ------------------------------------------------
    func createVideoThumbnail(_ url:URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        var time = asset.duration
        time.value = min(time.value, 2)
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch let error as NSError {
            print("Image generation failed with error \(error)")
            return nil
        }
    }
    
    // ------------------------------------------------
    // MARK: - SEND A PUSH NOTIFICATION
    // ------------------------------------------------
    func sendPushNotification(userPointer:PFUser, pushMessage:String) {
        let currentUser = PFUser.current()!
        let data = [
            "badge" : "Increment",
            "alert" : pushMessage,
            "sound" : "bingbong.aiff"
        ]
        let request = [
            "userObjectID" : userPointer.objectId!,
            "data" : data
        ] as [String : Any]
                
        allowPush = DEFAULTS.bool(forKey: "allowPush")
        if !allowPush {
            PFCloud.callFunction(inBackground: "pushiOS", withParameters: request as [String : Any], block: { (results, error) in
                if error == nil { print ("\nPUSH NOTIFICATION SENT TO: \(userPointer[USER_USERNAME]!)\nMESSAGE: \(pushMessage)")
                // error
                } else { self.simpleAlert("\(error!.localizedDescription)")
            }})// ./ PFCloud
        }
                
                
        // ------------------------------------------------
        // MARK: - SAVE NOTIFICATION IN THE DATABASE
        // ------------------------------------------------
        let nObj = PFObject(className: NOTIFICATIONS_CLASS_NAME)
        nObj[NOTIFICATIONS_TEXT] = pushMessage
        nObj[NOTIFICATIONS_CURRENT_USER] = currentUser
        nObj[NOTIFICATIONS_OTHER_USER] = userPointer
        nObj.saveInBackground(block: { (succ, error) in
            if error == nil {
                print("NOTIFICATION SAVED IN THE DATABASE!\n")
            } else { self.simpleAlert("\(error!.localizedDescription)")
        }})
    }
    
    
    // ------------------------------------------------
    // MARK: - FORMAT DATE BY TIME AGO SINCE DATE
    // ------------------------------------------------
    func timeAgoSinceDate(_ date:Date, currentDate:Date, numericDates:Bool) -> String {
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){ return "1 year ago"
            } else { return "Last year" }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){ return "1 month ago"
            } else { return "Last month" }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){ return "1 week ago"
            } else { return "Last week" }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){ return "1 day ago"
            } else { return "Yesterday" }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){ return "1 hour ago"
            } else { return "An hour ago" }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){ return "1 minute ago"
            } else { return "A minute ago" }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else { return "Just now" }
    }
    
    
    // ------------------------------------------------
    // MARK: - SET CELL SIZE
    // ------------------------------------------------
    func setCellSize() -> CGSize {
        var cellSize = CGSize()
        if UIDevice.current.userInterfaceIdiom == .pad {
            cellSize = CGSize(width: view.frame.size.width/3 - 20, height: 250)
        } else {
            cellSize = CGSize(width: view.frame.size.width/2 - 20, height: 250)
        }
        return cellSize
    }
    
}

// ------------------------------------------------
// MARK: - EXTENSION TO FORMAT LARGE NUMBERS
// ------------------------------------------------
extension Int {
    var rounded:String {
        let abbrev = "KMBTPE"
        return abbrev.enumerated().reversed().reduce(nil as String?) { accum, tuple in
            let factor = Double(self) / pow(10, Double(tuple.0 + 1) * 3)
            let format = (factor.truncatingRemainder(dividingBy: 1)  == 0 ? "%.0f%@" : "%.1f%@")
            return accum ?? (factor > 1 ? String(format: format, factor, String(tuple.1)) : nil)
            } ?? String(self)
    }
}


// ------------------------------------------------
// MARK: - CHECK INTERNET CONNECTION
// ------------------------------------------------
public class Reachability {
    class func isInternetConnectionAvailable() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
    }
}



// -------------------------------------------------------
// MARK: - PARSE DASHBOARD CLASSES AND COLUMNS NAMES
// -------------------------------------------------------
let USER_CLASS_NAME = "_User"
let USER_USERNAME = "username"
let USER_EMAIL = "email"
let USER_EMAIL_VERIFIED = "emailVerified"
let USER_FULLNAME = "fullName"
let USER_AVATAR = "avatar"
let USER_LOCATION = "location"
let USER_BIO = "bio"
let USER_IS_REPORTED = "isReported"
let USER_REPORT_MESSAGE = "reportMessage"
let USER_HAS_BLOCKED = "hasBlocked"

let ADS_CLASS_NAME = "Ads"
let ADS_SELLER_POINTER = "sellerPointer"
let ADS_LIKED_BY = "likedBy" // Array
let ADS_KEYWORDS = "keywords" // Array
let ADS_TITLE = "title"
let ADS_PRICE = "price"
let ADS_CURRENCY = "currency"
let ADS_CATEGORY = "category"
let ADS_LOCATION = "location"
let ADS_IMAGE1 = "image1"
let ADS_IMAGE2 = "image2"
let ADS_IMAGE3 = "image3"
let ADS_IMAGE4 = "image4"
let ADS_IMAGE5 = "image5"
let ADS_DESCRIPTION = "description"
let ADS_LIKES = "likes"
let ADS_VIEWS = "views"
let ADS_FOLLOWED_BY = "followedBy"
let ADS_IS_REPORTED = "isReported"
let ADS_REPORT_MESSAGE = "reportMessage"
let ADS_IS_SOLD = "isSold"
let ADS_IS_NEGOTIABLE = "isNegotiable"
let ADS_IS_SHIPPING = "IsShipping";
let ADS_SHIPPING = "Shipping"
let ADS_CREATED_AT = "createdAt"

let NOTIFICATIONS_CLASS_NAME = "Notifications"
let NOTIFICATIONS_CURRENT_USER = "currUser"
let NOTIFICATIONS_OTHER_USER = "otherUser"
let NOTIFICATIONS_TEXT = "text"
let NOTIFICATIONS_CREATED_AT = "createdAt"

let FOLLOW_CLASS_NAME = "Follow"
let FOLLOW_CURRENT_USER = "currentUser"
let FOLLOW_IS_FOLLOWING = "isFollowing"

let MESSAGES_CLASS_NAME = "Messages"
let MESSAGES_AD_POINTER = "adPointer"
let MESSAGES_SENDER = "sender"
let MESSAGES_RECEIVER = "receiver"
let MESSAGES_MESSAGE_ID = "messageID"
let MESSAGES_MESSAGE = "message"
let MESSAGES_IMAGE = "image"
let MESSAGES_DELETED_BY = "deletedBy"

let CHATS_CLASS_NAME = "Chats"
let CHATS_LAST_MESSAGE = "lastMessage"
let CHATS_SENDER = "sender"
let CHATS_RECEIVER = "receiver"
let CHATS_ID = "chatID"
let CHATS_AD_POINTER = "adPointer"
let CHATS_DELETED_BY = "deletedBy"


// ------------------------------------------------
// MARK: - GLOBAL VARIABLES
// ------------------------------------------------
var distanceInKm:Double = 50
var sortBy = "Newest"
var selectedCategory = ""
var priceFrom = 0
var priceTo = 0
var chosenLocation:CLLocation?
var mustDismiss = false
var DEFAULTS = UserDefaults.standard
var allowPush = Bool()
var noReload = false
var mustReload = false





