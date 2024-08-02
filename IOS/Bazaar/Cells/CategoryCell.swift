/*==================================================
 Bazaar
 
 © XScoder 2018
 All Rights reserved
 
 RE-SELLING THIS SOURCE CODE TO ANY ONLINE MARKETPLACE IS A SERIOUS COPYRIGHT INFRINGEMENT.
 YOU WILL BE LEGALLY PROSECUTED
 
 ==================================================*/

import UIKit

class CategoryCell: UICollectionViewCell {
    
    /*--- VIEWS ---*/
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var catNameLabel: UILabel!
    
    
    // Set Selected/Unselected cell
    override var isSelected: Bool{
        didSet{
            if isSelected {
                catNameLabel.textColor = MAIN_COLOR
                self.backgroundColor = LIGHT_GREY
            } else {
                catNameLabel.textColor = UIColor.black
                self.backgroundColor = UIColor.white
    }}}
}
