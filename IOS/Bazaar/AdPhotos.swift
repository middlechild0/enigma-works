/*==================================================
 Bazaar
 
 © XScoder 2018
 All Rights reserved
 
 RE-SELLING THIS SOURCE CODE TO ANY ONLINE MARKETPLACE IS A SERIOUS COPYRIGHT INFRINGEMENT.
 YOU WILL BE LEGALLY PROSECUTED
 
===================================================*/

import UIKit
import Parse

class AdPhotos: UIViewController, UIScrollViewDelegate {

    /*--- VIEWS ---*/
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var adTitleLabel: UILabel!
    
    
    
    /*--- VARIABLES ---*/
    var adObj = PFObject(className: ADS_CLASS_NAME)
    var photosArray = [UIImage]()
    
    
    
    // ------------------------------------------------
    // MARK: - VIEW DID LOAD
    // ------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        // Ad Title
        adTitleLabel.text = "\(adObj[ADS_TITLE]!)"
        
        // Get photos
        let imageFile = adObj[ADS_IMAGE1] as? PFFileObject
        imageFile?.getDataInBackground(block: { (data, error) in
            if error == nil { if let imageData = data {
                self.photosArray.append(UIImage(data: imageData)!)
                self.setupPhotosInScrollView()
                print("PHOTO 1")
        }}})

        DispatchQueue.main.async {

            if self.adObj[ADS_IMAGE2] != nil {
                self.pageControl.numberOfPages = 2
                let imageFile = self.adObj[ADS_IMAGE2] as? PFFileObject
                imageFile?.getDataInBackground(block: { (data, error) in
                    if error == nil { if let imageData = data {
                        self.photosArray.append(UIImage(data: imageData)!)
                        self.setupPhotosInScrollView()
                        print("PHOTO 2")
                }}})
            }
            if self.adObj[ADS_IMAGE3] != nil {
                self.pageControl.numberOfPages = 3
                let imageFile = self.adObj[ADS_IMAGE3] as? PFFileObject
                imageFile?.getDataInBackground(block: { (data, error) in
                    if error == nil { if let imageData = data {
                        self.photosArray.append(UIImage(data: imageData)!)
                        self.setupPhotosInScrollView()
                        print("PHOTO 3")
                }}})
            }
            if self.adObj[ADS_IMAGE4] != nil {
                self.pageControl.numberOfPages = 4
                let imageFile = self.adObj[ADS_IMAGE4] as? PFFileObject
                imageFile?.getDataInBackground(block: { (data, error) in
                    if error == nil { if let imageData = data {
                        self.photosArray.append(UIImage(data: imageData)!)
                        self.setupPhotosInScrollView()
                        print("PHOTO 4")
                }}})
            }
            if self.adObj[ADS_IMAGE5] != nil {
                self.pageControl.numberOfPages = 5
                let imageFile = self.adObj[ADS_IMAGE5] as? PFFileObject
                imageFile?.getDataInBackground(block: { (data, error) in
                    if error == nil { if let imageData = data {
                        self.photosArray.append(UIImage(data: imageData)!)
                        self.setupPhotosInScrollView()
                        print("PHOTO 5")
                }}})
            }
        
        }
    }

    
    
    
    // ------------------------------------------------
    // MARK: - SETUP PHOTOS IN SCROLLVIEW
    // ------------------------------------------------
    @objc func setupPhotosInScrollView() {
        var X:CGFloat = 0
        let Y:CGFloat = 0
        let W:CGFloat = view.frame.size.width
        let H:CGFloat = view.frame.size.height
        let G:CGFloat = 0
        var counter = 0
        
        // Loop to create ImageViews
        for i in 0..<photosArray.count {
            counter = i
            
            // Create a ImageView
            let aImg = UIImageView(frame: CGRect(x: X, y: Y, width: W, height: H))
            aImg.tag = i
            aImg.contentMode = .scaleAspectFit
            aImg.image = photosArray[i]
            
            // Add ImageViews based on X
            X += W + G
            containerScrollView.addSubview(aImg)
 
        } // ./ FOR loop
        
        // Place Buttons into a ScrollView
        containerScrollView.contentSize = CGSize(width: W * CGFloat(counter+2), height: H)
    }
    
    
    // ------------------------------------------------
    // MARK: - CHANGE PAGE CONTROL PAGES ON SCROLL
    // ------------------------------------------------
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = containerScrollView.frame.size.width
        let page = Int(floor((containerScrollView.contentOffset.x * 2 + pageWidth) / (pageWidth * 2)))
        pageControl.currentPage = page
    }

    
    
    
    
    // ------------------------------------------------
    // MARK: - DISMISS BUTTON
    // ------------------------------------------------
    @IBAction func dismissButt(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}// ./ end
