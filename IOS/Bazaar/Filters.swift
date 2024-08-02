/*==================================================
 Bazaar
 
 © XScoder 2018
 All Rights reserved
 
 RE-SELLING THIS SOURCE CODE TO ANY ONLINE MARKETPLACE IS A SERIOUS COPYRIGHT INFRINGEMENT.
 YOU WILL BE LEGALLY PROSECUTED
 
===================================================*/

import UIKit
import Parse


class Filters: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate
{

    /*--- VIEWS ---*/
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var categoriesCollView: UICollectionView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var newestButton: UIButton!
    @IBOutlet weak var closestButon: UIButton!
    @IBOutlet weak var priceLowToHightButton: UIButton!
    @IBOutlet weak var priceHighToLowButton: UIButton!
    @IBOutlet weak var mostLikedButton: UIButton!
    @IBOutlet weak var priceFromTxt: UITextField!
    @IBOutlet weak var priceToTxt: UITextField!
    
    
    
    /*--- VARIABLES ---*/
    var sortByButtons = [UIButton]()
    
    
    
    
    
    // ------------------------------------------------
    // MARK: - VIEW DID LOAD
    // ------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        // Layouts
        containerScrollView.contentSize = CGSize(width: containerScrollView.frame.size.width,
                                                 height: 1100)
        
        
        
        // Array of sortBy Buttons
        sortByButtons = [
            newestButton,
            closestButon,
            priceHighToLowButton,
            priceLowToHightButton,
            mostLikedButton
        ]
        
        // Setup sortBy Buttons
        for i in 0..<sortByButtons.count {
            let butt = sortByButtons[i]
            butt.backgroundColor = UIColor.white
            butt.titleLabel!.textColor = UIColor.black
            
            let sortByStr = butt.titleLabel!.text!.replacingOccurrences(of: " ", with: "")
            if sortByStr == sortBy {
                butt.backgroundColor = LIGHT_GREY
                butt.setTitleColor(MAIN_COLOR, for: .normal)
            }
        }
        
        // Set Price From and To
        if priceFrom != 0 { priceFromTxt.text = "\(priceFrom)" }
        if priceTo != 0 { priceToTxt.text = "\(priceTo)" }

        
        // Load data
        categoriesArray.insert("All", at: 0)
        categoriesCollView.reloadData()
        
        // Move bottomView below the CollectionView
        let height = categoriesCollView.collectionViewLayout.collectionViewContentSize.height
        categoriesCollView.frame.size.height = height
        bottomView.frame.origin.y = height + categoriesCollView.frame.origin.y + 10
    }

    
    
    
    
    // ------------------------------------------------
    // MARK: - SHOW DATA IN COLLECTION VIEW
    // ------------------------------------------------
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        cell.catImage.image = UIImage(named: "\(categoriesArray[indexPath.row])")
        cell.catNameLabel.text = "\(categoriesArray[indexPath.row])"
        
    return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/2, height: 48)
    }
    
    
    // ------------------------------------------------
    // MARK: - SELECT A CATEGORY
    // ------------------------------------------------
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categoriesArray[indexPath.row]
        print("SELECTED CATEGORY: \(selectedCategory)")
    }
    

    
    
    // ------------------------------------------------
    // MARK: - SORT BY BUTTONS
    // ------------------------------------------------
    @IBAction func sortByButt(_ sender: UIButton) {
        let sortByStr = sender.titleLabel!.text!.replacingOccurrences(of: " ", with: "")
        print("SORT BY STRING: \(sortByStr)")
        
        // Set sortBy
        sortBy = sortByStr
        
        // Reset buttons
        for butt in sortByButtons {
            butt.backgroundColor = UIColor.white
            butt.setTitleColor(UIColor.black, for: .normal)
        }
        sender.backgroundColor = LIGHT_GREY
        sender.setTitleColor(MAIN_COLOR, for: .normal)
    }
    
    
    
    
    // ------------------------------------------------
    // MARK: - TEXT FIELD DELEGATES
    // ------------------------------------------------
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        priceFromTxt.resignFirstResponder()
        priceToTxt.resignFirstResponder()
    return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedChars = CharacterSet.decimalDigits
        let charSet = CharacterSet(charactersIn: string)
        return allowedChars.isSuperset(of: charSet)
    }
    
    
    // ------------------------------------------------
    // MARK: - DONE BUTTON
    // ------------------------------------------------
    @IBAction func applyButt(_ sender: Any) {
        if priceFromTxt.text != "" { priceFrom = Int(priceFromTxt.text!)!
        } else { priceFrom = 0 }
        if priceToTxt.text != "" { priceTo = Int(priceToTxt.text!)!
        } else { priceTo = 0 }
        dismiss(animated: true, completion: nil)
    }

    
    // ------------------------------------------------
    // MARK: - REMOVE FIRST ITEM OF THE CATEGORIES ARRAY ("All")
    // ------------------------------------------------
    override func viewDidDisappear(_ animated: Bool) {
        categoriesArray.remove(at: 0)
    }
    
    
    
    // ------------------------------------------------
    // MARK: - TAP TO DISMISS KEYBOARD
    // ------------------------------------------------
    @IBAction func tapToDismissKeyboard(_ sender: Any) {
        priceFromTxt.resignFirstResponder()
        priceToTxt.resignFirstResponder()
    }
    

    
}// ./ end
