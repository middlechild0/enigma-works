/*==================================================
 Bazaar
 
 © XScoder 2018
 All Rights reserved
 

 RE-SELLING THIS SOURCE CODE TO ANY ONLINE MARKETPLACE IS A SERIOUS COPYRIGHT INFRINGEMENT.
 YOU WILL BE LEGALLY PROSECUTED
 
 ==================================================*/

import UIKit
import Parse
import CoreLocation
import GoogleMobileAds
import AudioToolbox

class Home: UIViewController, UITextFieldDelegate, GADInterstitialDelegate, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    /*--- VIEWS ---*/
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var adsCollView: UICollectionView!
    @IBOutlet weak var noResultsView: UIView!
    @IBOutlet weak var cityStateButton: UIButton!
    @IBOutlet weak var sellStuffView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    let refreshControl = UIRefreshControl()
    
        
        
    /*--- VARIABLES ---*/
    var searchTxt = ""
    var adsArray = [PFObject]()
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
        
        
        
    
    // ------------------------------------------------
    // MARK: - VIEW DID APPEAR
    // ------------------------------------------------
    override func viewDidAppear(_ animated: Bool) {
        print("NO RELOAD: \(noReload)")
        
        // Add device token to Installation class - for Push Notifications
        if PFUser.current() != nil {
            let installation = PFInstallation.current()
            installation?["username"] = PFUser.current()!.username
            installation?["userID"] = PFUser.current()!.objectId!
            installation?.saveInBackground(block: { (succ, error) in
                if error == nil {
                    print("PUSH REGISTERED FOR: \(PFUser.current()!.username!)")
            }})
        }
        
        
        // Set Search text
        if searchTxt != "" { searchTextField.text = searchTxt }
        
        // Set Category
        if selectedCategory == "" { categoryLabel.text = "All" }
        if selectedCategory == "All" {
            selectedCategory = ""
            categoryLabel.text = "All"
        }
       if selectedCategory != "" { categoryLabel.text = selectedCategory }
        
            
        
        // Get ads from a chosen location
        if chosenLocation != nil {
            currentLocation = chosenLocation
                
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(currentLocation!, completionHandler: { (placemarks, error) in
                let placeArray:[CLPlacemark] = placemarks!
                var placemark: CLPlacemark!
                placemark = placeArray[0]
                    
                // City
                let city = placemark.addressDictionary?["City"] as? String ?? ""
                // Country
                let country = placemark.addressDictionary?["Country"] as? String ?? ""
                    
                // Set distance and city labels
                self.cityStateButton.setTitle("\(city), \(country)", for: .normal)
                    
                // Call query
                if !noReload { self.queryAds()
                } else { noReload = false }
            })
            
            
        // Get current location
        } else { getCurrentLocation() }
    }

        
        
    // ------------------------------------------------
    // MARK: - VIEW DID LOAD
    // ------------------------------------------------
    override func viewDidLoad() {
            super.viewDidLoad()

        // Layouts
        adsCollView.backgroundColor = UIColor.clear
        noResultsView.isHidden = true
        cityStateButton.layer.cornerRadius = 15
        sellStuffView.layer.cornerRadius = 22
        searchTextField.placeholder = "Search on \(APP_NAME)"

        // iPhone X/S, iPhone XS Max, XR
        if UIScreen.main.bounds.size.height == 812 || UIScreen.main.bounds.size.height == 896 {
            sellStuffView.frame.origin.y = view.frame.size.height - 90 - sellStuffView.frame.size.height
            adsCollView.frame.size.height = adsCollView.frame.size.height - sellStuffView.frame.size.height
        }
        
        
        
        // Refresh Control
        refreshControl.tintColor = UIColor.black
        adsCollView.alwaysBounceVertical = true
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        adsCollView.addSubview(refreshControl)

        
        // Call AdMob Interstitial
       // showInterstitial()
    }
    
    
    
    
    
        
    // ------------------------------------------------
    // MARK: - GET CURRENT LOCATION
    // ------------------------------------------------
    func getCurrentLocation() {
        if !Reachability.isInternetConnectionAvailable(){
            simpleAlert("Internet Connection is not available, please enable WiFi or Mobile data!")
        } else {
            
            // Init LocationManager
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
            if locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) {
                locationManager.requestAlwaysAuthorization()
            }
            locationManager.startUpdatingLocation()
            
        }// If Internet connection
    }
        
        
    // MARK: - CORE LOCATION DELEGATES
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        simpleAlert("Cannot get your Location. Please go into Settings, search this app and enable Location service, so you'll be able to see ads nearby you. Otherwise the app will display ads from New York, USA")

        // Set New York City as default currentLocation
        currentLocation = DEFAULT_LOCATION
        
        
        // Set distance and city labels
        self.cityStateButton.setTitle("New York, USA", for: .normal)
        
        // Call query
        if !noReload { queryAds()
        } else { noReload = false }
    }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locationManager != nil {
            locationManager.stopUpdatingLocation()
        }
        
        currentLocation = locations.last!
        locationManager = nil
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(currentLocation!, completionHandler: { (placemarks, error) -> Void in
            
            let placeArray:[CLPlacemark] = placemarks!
            var placemark: CLPlacemark!
            placemark = placeArray[0]
            
            let city = placemark.addressDictionary?["City"] as? String ?? ""
            let country = placemark.addressDictionary?["Country"] as? String ?? ""
            
            // Set city/state
            self.cityStateButton.setTitle("\(city), \(country)", for: .normal)
            
            // Call query
            if !noReload { self.queryAds()
            } else { noReload = false }
        })
    }

        
        
        
        
    // ------------------------------------------------
    // MARK: - QUERY ADS
    // ------------------------------------------------
    func queryAds() {
        if !Reachability.isInternetConnectionAvailable(){
            simpleAlert("Internet Connection is not available, please enable WiFi or Mobile data!")
        } else {
            
            // Reset data
            adsArray.removeAll()
            adsCollView.reloadData()
            
            noResultsView.isHidden = true
            showHUD()
            let keywords = searchTxt.lowercased().components(separatedBy: " ")

            print("KEYWORDS: \(keywords) -- SELECTED CATEGORY: \(selectedCategory)")
            print("PRICE FROM: \(priceFrom) -- PRICE TO: \(priceTo)")
            print("SORT BY: \(sortBy)")

            
            // Query
            let query = PFQuery(className: ADS_CLASS_NAME)
            
            // filter by NON-Reported items
            query.whereKey(ADS_IS_REPORTED, equalTo: false)

            // filter by keywords
            if searchTxt != "" { query.whereKey(ADS_KEYWORDS, containedIn: keywords) }
            
            // filter by category
            if selectedCategory != "" { query.whereKey(ADS_CATEGORY, equalTo: selectedCategory) }
            
            // filter price From/To
            if priceFrom != 0 { query.whereKey(ADS_PRICE, greaterThanOrEqualTo: priceFrom) }
            if priceTo != 0 { query.whereKey(ADS_PRICE, lessThanOrEqualTo: priceTo) }

            // filter by location
            let gp = PFGeoPoint(latitude: currentLocation!.coordinate.latitude, longitude: currentLocation!.coordinate.longitude)
            query.whereKey(ADS_LOCATION, nearGeoPoint: gp, withinKilometers: distanceInKm)
            
            
            // filter sortBy
            switch sortBy {
                case "Newest": query.order(byDescending: "createdAt")
                case "Closest": query.order(byDescending: ADS_LOCATION)
                case "Price:lowtohigh": query.order(byAscending: ADS_PRICE)
                case "Price:hightolow": query.order(byDescending: ADS_PRICE)
                case "MostLiked": query.order(byDescending: ADS_LIKES)
                
            default:break}
            
            // Perform query
            query.findObjectsInBackground { (objects, error) in
                if error == nil {
                    self.adsArray = objects!
                    self.hideHUD()
                    self.adsCollView.reloadData()
                    
                    // Show/hide noResult view
                    if self.adsArray.count == 0 { self.noResultsView.isHidden = false
                    } else { self.noResultsView.isHidden = true }
                
                // error
                } else { self.hideHUD(); self.simpleAlert("\(error!.localizedDescription)")
            }}
            
        }// ./ If Internet connection
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
    // MARK: - FILTERS BUTTON
    // ------------------------------------------------
    @IBAction func filtersButt(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "Filters") as! Filters
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
        

    
    // ------------------------------------------------
    // MARK: - OPEN MAP SCREEN BUTTON
    // ------------------------------------------------
    @IBAction func openMapScreenButt(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MapScreen") as! MapScreen
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
        
    // ------------------------------------------------
    // MARK: - SEARCH TEXT FIELD DELEGATES
    // ------------------------------------------------
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelButton.isHidden = false
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            searchTxt = textField.text!
                
            // Call query
            queryAds()
                
            textField.resignFirstResponder()
                
        // No text -> No search
        } else { simpleAlert("You must type something!") }
    return true
    }
        

    
    // ------------------------------------------------
    // MARK: - CANCEL BUTTON
    // ------------------------------------------------
    @IBAction func cancelButt(_ sender: Any) {
        cancelButton.isHidden = true
        searchTxt = ""
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        
        selectedCategory = ""
        priceFrom = 0
        priceTo = 0
        
        // Relaunch query
        queryAds()
    }
    
    
        
    
    // ------------------------------------------------
    // MARK: - SELL STUFF BUTTON
    // ------------------------------------------------
    @IBAction func sellStuffButt(_ sender: Any) {
        
        // currentUser IS LOGGED IN!
        if PFUser.current() != nil {
            let vc = storyboard?.instantiateViewController(withIdentifier: "SellEditStuff") as! SellEditStuff
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            
        // currentUser IS NOT LOGGED IN...
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "Intro") as! Intro
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    
    
    // ------------------------------------------------
    // MARK: - REFRESH DATA
    // ------------------------------------------------
    @objc func refreshData () {
        queryAds()
        
        // Stop Refresh Control
        if refreshControl.isRefreshing { refreshControl.endRefreshing() }
    }
    
    
}// ./ end
