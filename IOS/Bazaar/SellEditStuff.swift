/*==================================================
 Bazaar
 
 © XScoder 2018
 All Rights reserved

 RE-SELLING THIS SOURCE CODE TO ANY ONLINE MARKETPLACE IS A SERIOUS COPYRIGHT INFRINGEMENT.
 YOU WILL BE LEGALLY PROSECUTED
 
===================================================*/

//ll ask import BSImagePicker
import UIKit
import Parse
import CoreLocation
import Photos

class SellEditStuff: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate {

    var arrayOfPHAsset = [PHAsset]()

    /*--- VIEWS ---*/
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var photoButtonsScrollView: UIScrollView!
    @IBOutlet weak var photo1Button: UIButton!
    @IBOutlet weak var photo2Button: UIButton!
    @IBOutlet weak var photo3Button: UIButton!
    @IBOutlet weak var photo4Button: UIButton!
    @IBOutlet weak var photo5Button: UIButton!
    @IBOutlet weak var adTitleTxt: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var adPriceTxt: UITextField!
    @IBOutlet weak var adCurrencyCodeTxt: UITextField!
    @IBOutlet weak var adShippingTxt: UITextField!
    @IBOutlet weak var negotiableSwitch: UISwitch!
    @IBOutlet weak var shippingSwitch: UISwitch!
    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var markAsSoldButton: UIButton!
    @IBOutlet weak var deleteItemButton: UIButton!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var viewShipping: UIView!
    
    
    
    
    /*--- VARIABLES ---*/
    var adObj = PFObject(className: ADS_CLASS_NAME)
    var photoButtons = [UIButton]()
    var photoID = 0
    var isNegotiable = true
    var isShipping = false
    var photoAttachedIDs = [Int]()
    var category = ""
    var isSold = false
    var locationManager: CLLocationManager!
    var removeImageButtons: [UIButton] = [] //g
    
    
    
    
    // ------------------------------------------------
    // MARK: - VIEW DID APPEAR
    // ------------------------------------------------
    override func viewDidAppear(_ animated: Bool) {
        print("AD OBJECT ID: \(String(describing: adObj.objectId))")
        print("AD OBJECT allkey: \(String(describing: adObj.allKeys))")
        print("CHOSEN LOCATION: \(String(describing: chosenLocation))")
        print("PHOTO ID: \(String(describing: photoID))")
        print("PHOTO ATTACHED ID's: \(String(describing: photoAttachedIDs))")

        
        // Automatically dismiss the controller
        if mustDismiss {
            mustDismiss = false
            dismiss(animated: false, completion: nil)
        }
        
        // Item's Location
        if chosenLocation == nil { getCurrentLocation()
        } else { setAdLocation() }
        
        
        // Sell a new Item
        if adObj.objectId == nil { titleLabel.text = "Sell stuff" }
        
        
       
        self.resetObj()
        
    }// ./ viewDidAppear
    
    
    func resetObj(){
        // Set photo Buttons after attaching an image
        switch photoID {
            case 0:
                if photoAttachedIDs.count == 0 {
                    photo1Button.setImage(UIImage(named: "add_photo_butt"), for: .normal)
                    photo1Button.backgroundColor = UIColor.white
                    photo2Button.isEnabled = false
                    addRemoveButton(to: photo1Button, atIndex: 1)//g
                }
            break
            case 1:
                if photoAttachedIDs.count == 1 {
                    if !photoAttachedIDs.contains(photoID+1) {
                        photo2Button.setImage(UIImage(named: "add_photo_butt"), for: .normal)
                        photo2Button.backgroundColor = UIColor.white
                        photo2Button.isEnabled = true
                        addRemoveButton(to: photo2Button, atIndex: 2)//g
                    }
                }
            break
            case 2:
                if !photoAttachedIDs.contains(photoID+1) {
                    photo3Button.setImage(UIImage(named: "add_photo_butt"), for: .normal)
                    photo3Button.backgroundColor = UIColor.white
                    photo3Button.isEnabled = true
                    addRemoveButton(to: photo3Button, atIndex: 3)//g
                }
            break
            case 3:
                if !photoAttachedIDs.contains(photoID+1) {
                    photo4Button.setImage(UIImage(named: "add_photo_butt"), for: .normal)
                    photo4Button.backgroundColor = UIColor.white
                    photo4Button.isEnabled = true
                    addRemoveButton(to: photo4Button, atIndex: 4)//g
                }
            break
            case 4:
                if !photoAttachedIDs.contains(photoID+1) {
                    photo5Button.setImage(UIImage(named: "add_photo_butt"), for: .normal)
                    photo5Button.backgroundColor = UIColor.white
                    photo5Button.isEnabled = true
                    addRemoveButton(to: photo5Button, atIndex: 5)//g
                }
            break
            
        default:break }
    }
    
    
    // ---------
    // DELETE IMAGE BUTTON : g
    // ------------
    func addRemoveButton(to button: UIButton, atIndex index: Int) {
        
            
        
            if removeImageButtons.count > index {
                removeImageButtons[index].removeFromSuperview()
            }

            let removeImageButton = UIButton(type: .system)
            removeImageButton.setTitle("X", for: .normal)
            removeImageButton.setTitleColor(.red, for: .normal)
            removeImageButton.backgroundColor = .white
            removeImageButton.layer.cornerRadius = 10
            removeImageButton.layer.masksToBounds = true
            removeImageButton.tag = index
            removeImageButton.addTarget(self, action: #selector(removeImage(_:)), for: .touchUpInside)

            button.addSubview(removeImageButton)
            removeImageButtons.append(removeImageButton)
        
            //button.tag = 100 + index

            removeImageButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                removeImageButton.topAnchor.constraint(equalTo: button.topAnchor, constant: 5),
                removeImageButton.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -5),
                removeImageButton.widthAnchor.constraint(equalToConstant: 20),
                removeImageButton.heightAnchor.constraint(equalToConstant: 20)
            ])
        }

    @objc func removeImage(_ sender: UIButton) {
            let index = sender.tag
            guard let button = self.view.viewWithTag(100 + index) as? UIButton else {
                return
            }
        
            adObj["ADS_IMAGE\(index + 1)"] = nil
        
            if let photoIndex = photoAttachedIDs.firstIndex(of: index) {
                photoAttachedIDs.remove(at: photoIndex)
              }
        
            button.setImage(UIImage(named: "add_photo_butt"), for: .normal)
            button.backgroundColor = .white
            button.isEnabled = true
            
           if let deleteButton = button.subviews.first(where: { $0.tag == sender.tag + 100 }) as? UIButton {
              deleteButton.removeFromSuperview()
           }
        
            self.resetObj()
        }
    
    
    
    // ------------------------------------------------
    // MARK: - VIEW DID LOAD
    // ------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        shippingSwitch.setOn(false, animated: false)
        viewShipping.isUserInteractionEnabled = false
        viewShipping.alpha = 0.6
        
        // Layouts
        containerScrollView.contentSize = CGSize(width: containerScrollView.frame.size.width,
                                                 height: 1200)
        markAsSoldButton.layer.cornerRadius = 22
        deleteItemButton.layer.cornerRadius = 22

        
        // Show Currency code
        priceLabel.text = "PRICE"  //- \(CURRENCY_CODE)
        adCurrencyCodeTxt.text = CURRENCY_CODE
    
        // Array of photo Buttons
        photoButtons = [
            photo1Button,
            photo2Button,
            photo3Button,
            photo4Button,
            photo5Button
        ]
        
        // Setup photo Buttons
        for i in 0..<photoButtons.count {
            let butt = photoButtons[i]
            butt.layer.cornerRadius = 6
            butt.tag = i
            butt.clipsToBounds = true
            butt.imageView?.contentMode = .scaleAspectFill
            if i > 1 { butt.isEnabled = false }
        }
        photoButtonsScrollView.contentSize = CGSize(width: (photo1Button.frame.size.width+20) * 5, height: photoButtonsScrollView.frame.size.height)

        // ------------------------------------------------
        // MARK: - EDIT ITEM
        // ------------------------------------------------
        if adObj.objectId != nil {
            titleLabel.text = "Edit item"
            sellButton.setTitle("Update", for: .normal)
            markAsSoldButton.isHidden = false
            deleteItemButton.isHidden = false
            // Call function
            showItemDetails()
        }
        
        
    }// ./ viewDidLoad
    
    
    
    
    
    
    
    // ------------------------------------------------
    // MARK: - GET CURRENT LOCATION
    // ------------------------------------------------
    func getCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        if locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - CORE LOCATION DELEGATES
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        simpleAlert("Cannot get your Location. Please go into Settings, search this app and enable Location service, so you'll be able to see ads nearby you. Otherwise the app will display ads from New York, USA")
        
        // Set New York City as default currentLocation
        chosenLocation = DEFAULT_LOCATION
        
        // Set distance and city labels
        self.locationButton.setTitle("New York, USA", for: .normal)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        chosenLocation = locations.last!
        locationManager = nil
        
        // Call function
        setAdLocation()
    }
    
    

    
    // ------------------------------------------------
    // MARK: - SET AD LOCATION
    // ------------------------------------------------
    func setAdLocation() {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(chosenLocation!, completionHandler: { (placemarks, error) -> Void in
            let placeArray:[CLPlacemark] = placemarks!
            var placemark: CLPlacemark!
            placemark = placeArray[0]
            let city = placemark.addressDictionary?["City"] as? String ?? ""
            let country = placemark.addressDictionary?["Country"] as? String ?? ""
            // Set Location Button
            self.locationButton.setTitle("   \(city), \(country)", for: .normal)
        })
    }
    
    
    
    
    
    
    
    // ------------------------------------------------
    // MARK: - SHOW ITEM'S DETAILS
    // ------------------------------------------------
    func showItemDetails() {
        // Photo 1
        getParseImage(object: adObj, colName: ADS_IMAGE1, button: photo1Button)
        photoAttachedIDs.append(0)
        
        // Photo 2
        if adObj[ADS_IMAGE2] != nil {
            getParseImage(object: adObj, colName: ADS_IMAGE2, button: photo2Button)
            photoAttachedIDs.append(1)
            photo2Button.isEnabled = true
        }
        // Photo 3
        if adObj[ADS_IMAGE3] != nil {
            getParseImage(object: adObj, colName: ADS_IMAGE3, button: photo3Button)
            photoAttachedIDs.append(2)
            photo3Button.isEnabled = true
        }
        // Photo 4
        if adObj[ADS_IMAGE4] != nil {
            getParseImage(object: adObj, colName: ADS_IMAGE4, button: photo4Button)
            photoAttachedIDs.append(3)
            photo4Button.isEnabled = true
        }
        // Photo 5
        if adObj[ADS_IMAGE5] != nil {
            getParseImage(object: adObj, colName: ADS_IMAGE5, button: photo5Button)
            photoAttachedIDs.append(4)
            photo5Button.isEnabled = true
        }
        print("PHOTO ATTACHED IDs - ON SHOW ITEM'S DETAILS: \(photoAttachedIDs)")

        // Title
        adTitleTxt.text = "\(adObj[ADS_TITLE]!)"
        // Price
        adPriceTxt.text = "\(adObj[ADS_PRICE]!)"
        
        adCurrencyCodeTxt.text = "\(adObj[ADS_CURRENCY]!)"

        // Negotiable
        isNegotiable = adObj[ADS_IS_NEGOTIABLE] as! Bool
        if isNegotiable { negotiableSwitch.setOn(true, animated: true)
        } else { negotiableSwitch.setOn(false, animated: true) }
        
        if(adObj[ADS_IS_SHIPPING] != nil){
            isShipping = adObj[ADS_IS_SHIPPING] as! Bool
            if isShipping {
                shippingSwitch.setOn(true, animated: true)
                let labelValue = "\(adObj[ADS_SHIPPING]!)"
                if labelValue == "0"{
                    adShippingTxt.text = ""
                }else{
                    adShippingTxt.text = "\(adObj[ADS_SHIPPING]!)"
                }
                viewShipping.isUserInteractionEnabled = true
                viewShipping.alpha = 1
            } else { shippingSwitch.setOn(false, animated: true) }
        }else{
            shippingSwitch.setOn(false, animated: true)
        }
        
        
        // Description
        descriptionTxt.text = "\(adObj[ADS_DESCRIPTION]!)"
        // Location
        let adLocation = adObj[ADS_LOCATION] as! PFGeoPoint
        chosenLocation = CLLocation(latitude: adLocation.latitude, longitude: adLocation.longitude)
        setAdLocation()
        // Category
        category = "\(adObj[ADS_CATEGORY]!)"
        categoryButton.setTitle("   " + category, for: .normal)
        // Mark as Sold Button
        let isSold = adObj[ADS_IS_SOLD] as! Bool
        if isSold { markAsSoldButton.isHidden = true
        } else { markAsSoldButton.isHidden = false }
        // Delete Button
        deleteItemButton.isHidden = false
    }
    
    
    
    // ------------------------------------------------
    // MARK: - PHOTO BUTTONS
    // ------------------------------------------------
    @IBAction func photoButt(_ sender: UIButton) {
        // Set photoID
        photoID = sender.tag
        
        // Fire alert
        let alert = UIAlertController(title: APP_NAME,
            message: "Select source",
            preferredStyle: .actionSheet)
        
        // Open Camera
        let camera = UIAlertAction(title: "Take a Photo", style: .default, handler: { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                imagePicker.modalPresentationStyle = .fullScreen
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        alert.addAction(camera)

        
        // Open Photo Library
        let library = UIAlertAction(title: "Choose Image from Library", style: .default, handler: { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = ImagePickerController()
                imagePicker.settings.selection.max = 5 
                imagePicker.settings.theme.selectionStyle = .numbered
                imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
                imagePicker.settings.selection.unselectOnReachingMax = false

                let start = Date()
                self.presentImagePicker(imagePicker, select: { (asset) in
                    print("Selected: \(asset)")
                }, deselect: { (asset) in
                    print("Deselected: \(asset)")
                   
                }, cancel: { (assets) in
                    print("Canceled with selections: \(assets)")
                }, finish: { (assets) in
                    print("Finished with selections: \(assets)")
                    self.arrayOfPHAsset.removeAll()
                            for asset in assets  {
                                if self.photoID < 5 {
                                    self.arrayOfPHAsset.append(asset)
                                    let imageV = self.convertImageFromAsset(asset: asset)
                                    let scaledImg = self.scaleImageToMaxWidth(image: imageV, newWidth: 640)
                                    self.photoButtons[self.photoID].setImage(scaledImg, for: .normal)
                                    self.photoButtons[self.photoID].isEnabled = true
                                    
                                    if self.photoAttachedIDs.contains(self.photoID) {
                                        self.photoAttachedIDs.remove(at: self.photoID)
                                        self.photoAttachedIDs.insert(self.photoID, at: self.photoID)
                                    } else { self.photoAttachedIDs.append(self.photoID) }
                                    print("PHOTO ATTACHED ID's: \(self.photoAttachedIDs)")
                                    
                                    self.photoID = self.photoID + 1
                                }
                                self.resetObj()
                            }
                }, completion: {
                    let finish = Date()
                    print(finish.timeIntervalSince(start))
                })
                
//                let imagePicker = UIImagePickerController()
//                imagePicker.delegate = self
//                imagePicker.sourceType = .photoLibrary
//                imagePicker.allowsEditing = false
//                imagePicker.modalPresentationStyle = .fullScreen
//                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        alert.addAction(library)

        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })
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
    }
    func convertImageFromAsset(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            image = result!
        })
        return image
    }
    func getAssetThumbnail(asset: PHAsset, size: CGFloat) -> UIImage {
            let retinaScale = UIScreen.main.scale
            let retinaSquare = CGSize(width: size * retinaScale, height: size * retinaScale)
            let cropSizeLength = min(asset.pixelWidth, asset.pixelHeight)
            let square = CGRect(x: 0, y: 0, width: CGFloat(cropSizeLength), height: CGFloat(cropSizeLength))
            let cropRect = square.applying(CGAffineTransform(scaleX: 1.0/CGFloat(asset.pixelWidth), y: 1.0/CGFloat(asset.pixelHeight)))
            
            let manager = PHImageManager.default()
            let options = PHImageRequestOptions()
            var thumbnail = UIImage()
            
            options.isSynchronous = true
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .exact
            
            options.normalizedCropRect = cropRect
            
            manager.requestImage(for: asset, targetSize: retinaSquare, contentMode: .aspectFit, options: options, resultHandler: {(result, info)->Void in
                thumbnail = result!
            })
            return thumbnail
        }

    func getAssetThumbnail(assets: [PHAsset]) -> [UIImage] {
            var arrayOfImages = [UIImage]()
            for asset in assets {
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var image = UIImage()
                option.isSynchronous = true
                manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                    image = result!
                    arrayOfImages.append(image)
                })
            }

            return arrayOfImages
        }
    
    
    // ------------------------------------------------
    // MARK: - IMAGE PICKER DELEGATE
    // ------------------------------------------------
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // Scale image
            let scaledImg = scaleImageToMaxWidth(image: image, newWidth: 640)
            
            photoButtons[photoID].setImage(scaledImg, for: .normal)
            
            if photoAttachedIDs.contains(photoID) {
                photoAttachedIDs.remove(at: photoID)
                photoAttachedIDs.insert(photoID, at: photoID)
            } else { photoAttachedIDs.append(photoID) }
            print("PHOTO ATTACHED ID's: \(photoAttachedIDs)")
        }
        dismiss(animated: true, completion: nil)
    }
    
    // Dismiss imagePicker on Cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       photoID -= 1
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    // ------------------------------------------------
    // MARK: - SET NEGOTIABLE PRICE
    // ------------------------------------------------
    @IBAction func negotiableSwitchChanged(_ sender: UISwitch) {
        isNegotiable = !isNegotiable
        print("IS NEGOTIABLE: \(isNegotiable)")
    }
    
    @IBAction func shippingSwitchChanged(_ sender: UISwitch) {
        isShipping = !isShipping
        print("IS SHIPPING: \(isShipping)")
        if isShipping == true {
            viewShipping.isUserInteractionEnabled = true
            viewShipping.alpha = 1
        }else{
            viewShipping.isUserInteractionEnabled = false
            viewShipping.alpha = 0.6
        }
    }
    
    // ------------------------------------------------
    // MARK: - LOCATION BUTTON
    // ------------------------------------------------
    @IBAction func locationButt(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MapScreen") as! MapScreen
        vc.isSelling = true
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
    
    
    // ------------------------------------------------
    // MARK: - CATEGORY BUTTON
    // ------------------------------------------------
    @IBAction func categoryButt(_ sender: UIButton) {
        let alert = UIAlertController(title: APP_NAME,
            message: "Select a Category",
            preferredStyle: .actionSheet)
        
        var action = UIAlertAction()
        for i in 0..<categoriesArray.count {
            action = UIAlertAction(title: "\(categoriesArray[i])", style: .default, handler: { (action) -> Void in
                self.category = categoriesArray[i]
                self.categoryButton.setTitle("   " + self.category, for: .normal)
            })
            alert.addAction(action)
        }
        
        // Cancel button
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
    }
    
    
    
    
    
    // ------------------------------------------------
    // MARK: - SELL BUTTON
    // ------------------------------------------------
    @IBAction func sellButt(_ sender: Any) {
        let currentUser = PFUser.current()!
        
        // Missing info
        if adTitleTxt.text == "" ||
            adPriceTxt.text == "" ||
            adCurrencyCodeTxt.text == "" ||
            descriptionTxt.text == "" ||
            category == "" ||
            photoAttachedIDs.count == 0
        {
            simpleAlert("Please make sure you have inserted the following info:\n• Title\n• Price\n• Description\n• Category\n• A first photo")
            
            
        // All info have been set -> save data
        } else {
            showHUD()
            dismisskeyboard()
            var sellOrUpdateStr = ""
            
            // Prepare data for a New Item
            if adObj.objectId == nil {
                adObj[ADS_LIKED_BY] = [String]()
                adObj[ADS_FOLLOWED_BY] = [String]()
                adObj[ADS_LIKES] = 0
                adObj[ADS_VIEWS] = 0
                adObj[ADS_IS_REPORTED] = false
                
                sellOrUpdateStr = " posted a new Item: "
            } else {
                sellOrUpdateStr = " updated an Item: "
            }
            
            // Prepare general data
            adObj[ADS_SELLER_POINTER] = currentUser
            adObj[ADS_TITLE] = adTitleTxt.text!
            adObj[ADS_CATEGORY] = category
            adObj[ADS_PRICE] = Int(adPriceTxt.text!)
            if adCurrencyCodeTxt.text == "" {
                adObj[ADS_CURRENCY] = CURRENCY_CODE
              
            }else{
                adObj[ADS_CURRENCY] = adCurrencyCodeTxt.text!
              
            }
            adObj[ADS_LOCATION] = PFGeoPoint(latitude: chosenLocation!.coordinate.latitude, longitude: chosenLocation!.coordinate.longitude)
            adObj[ADS_DESCRIPTION] = descriptionTxt.text!
            adObj[ADS_IS_NEGOTIABLE] = isNegotiable
            adObj[ADS_IS_SHIPPING] = isShipping
            if isShipping {
                if  adShippingTxt.text == ""{
                    adObj[ADS_SHIPPING] = Int("0")
                }else{
                    adObj[ADS_SHIPPING] = Int(adShippingTxt.text!)
                }
            }
            
            adObj[ADS_IS_SOLD] = isSold
            
            // Prepare keywords
            let k1NoCommas = adTitleTxt.text!.lowercased().replacingOccurrences(of: ",", with: " ")
            let k2NoCommas = descriptionTxt.text!.lowercased().replacingOccurrences(of: ",", with: " ")
            let k1 = k1NoCommas.components(separatedBy: " ")
            let k2 = k2NoCommas.components(separatedBy: " ")
            let k3 = "\(currentUser[USER_USERNAME]!)".lowercased().components(separatedBy: " ")
            let keywords = k1 + k2 + k3
            adObj[ADS_KEYWORDS] = keywords
            
            // Prepare image(s)
            for i in 0..<photoAttachedIDs.count {
                let adImage = photoButtons[i].imageView!.image
                let imageData = adImage!.jpegData(compressionQuality: 1.0)
                let imageFile = PFFileObject(name:"image.jpg", data:imageData!)
                adObj["image\(i+1)"] = imageFile
            }
            
            
            // Saving...
            adObj.saveInBackground { (succ, error) in
                if error == nil {
                    self.hideHUD()
                    
                    // Store followedBy IDs for this Ad
                    let query = PFQuery(className: FOLLOW_CLASS_NAME)
                    query.whereKey(FOLLOW_IS_FOLLOWING, equalTo: currentUser)
                    query.findObjectsInBackground { (objects, error) in
                        if error == nil {
                            if objects!.count != 0 {
                                var followedBy = self.adObj[ADS_FOLLOWED_BY] as! [String]
                                
                                for i in 0..<objects!.count {
                                    // Parse Object
                                    var fObj = PFObject(className: FOLLOW_CLASS_NAME)
                                    fObj = objects![i]
                                    // User Pointer
                                    let userPointer = fObj[FOLLOW_CURRENT_USER] as! PFUser
                                    userPointer.fetchIfNeededInBackground(block: { (user, error) in
                                        if error == nil {
                                            followedBy.append(userPointer.objectId!)
                                            if i == objects!.count-1 { 
                                                self.adObj[ADS_FOLLOWED_BY] = followedBy
                                                self.adObj.saveInBackground()
                                              
                                                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "NotificationIdentifier"),object: self.adObj))

                                                // Send push notification
                                                let pushMessage = "\(currentUser[USER_FULLNAME]!)" + sellOrUpdateStr + " '\(self.adObj[ADS_TITLE]!)'"
                                                self.sendPushNotification(userPointer: userPointer, pushMessage: pushMessage)
                                            }
                                        // error
                                        } else { self.simpleAlert("\(error!.localizedDescription)")
                                    }})// ./ userPointer
                                    
                                }// ./ For loop
                                
                            }// ./ If
                            
                        // error
                        } else { self.simpleAlert("\(error!.localizedDescription)")
                    }}

                    
                    // Fire alert
                    let alert = UIAlertController(title: APP_NAME,
                        message: "Congratulations, your stuff has been successfully posted!",
                        preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        noReload = false
                        mustReload = true
                        self.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    
                // error
                } else { self.hideHUD(); self.simpleAlert("\(error!.localizedDescription)")
            }}
            
        }// ./ If
    }
    
    
    
    
    
    // ------------------------------------------------
    // MARK: - MARK AS SOLD BUTTON
    // ------------------------------------------------
    @IBAction func markAsSoldButt(_ sender: Any) {
        let alert = UIAlertController(title: APP_NAME,
            message: "Are you sure you want to mark this Item as Sold? You will not be able to change it later.",
            preferredStyle: .alert)
        
        // MARK AS SOLD
        let markSold = UIAlertAction(title: "Mark as Sold", style: .default, handler: { (action) -> Void in
            self.adObj[ADS_IS_SOLD] = true
            self.adObj.saveInBackground(block: { (succ, error) in
                if error == nil {
                    
                    // Fire alert
                    let alert2 = UIAlertController(title: APP_NAME,
                        message: "Your item has been marked as Sold! People will still be able to find this item in the app until you will delete it.",
                        preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        self.markAsSoldButton.isHidden = true
                        mustDismiss = true
                        noReload = false
                        self.dismiss(animated: true, completion: nil)
                    })
                    alert2.addAction(ok)
                    self.present(alert2, animated: true, completion: nil)
                    
                // error
                } else { self.simpleAlert("\(error!.localizedDescription)")
            }})
        })
        alert.addAction(markSold)
        
        // CANCEL BUTTON
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    
   
    
    
    // ------------------------------------------------
    // MARK: - DELETE AD BUTTON
    // ------------------------------------------------
    @IBAction func deleteButt(_ sender: Any) {
        let alert = UIAlertController(title: APP_NAME,
            message: "Are you sure you want to delete this Item?",
            preferredStyle: .alert)
        
        // Delete Ad
        let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
            self.showHUD()
            
            self.adObj.deleteInBackground(block: { (succ, error) in
                if error == nil {
                    self.hideHUD()
                    
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
                    
                    // Fire alert
                    let alert = UIAlertController(title: APP_NAME,
                        message: "Your Item has been successfully deleted!",
                        preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        self.dismiss(animated: true, completion: nil)
                        mustDismiss = true
                        noReload = false
                        
                    })
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    
                // error
                } else { self.hideHUD(); self.simpleAlert("\(error!.localizedDescription)")
            }})
        })
        alert.addAction(delete)
        
        
        // Cancel
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    // ------------------------------------------------
    // MARK: - TEXT FIELD DELEGATES
    // ------------------------------------------------
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == adTitleTxt { adPriceTxt.becomeFirstResponder() }
        if textField == adPriceTxt { adCurrencyCodeTxt.becomeFirstResponder() }

        return true
    }
    
    
    
    // ------------------------------------------------
    // MARK: - DISMISS KEYBOARD
    // ------------------------------------------------
    func dismisskeyboard() {
        adTitleTxt.resignFirstResponder()
        adPriceTxt.resignFirstResponder()
        adCurrencyCodeTxt.resignFirstResponder()
        descriptionTxt.resignFirstResponder()
    }
    
    
    // ------------------------------------------------
    // MARK: - DISMISS BUTTON
    // ------------------------------------------------
    @IBAction func dismissButt(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

    // ------------------------------------------------
    // MARK: - RESET VARIABLES ON VIEW DID DISAPPEAR
    // ------------------------------------------------
    override func viewDidDisappear(_ animated: Bool) {
        // chosenLocation = nil
    }
    
    

}// ./ end
