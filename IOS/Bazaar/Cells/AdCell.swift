/*==================================================
 Bazaar
 
 © XScoder 2018
 All Rights reserved
 
 RE-SELLING THIS SOURCE CODE TO ANY ONLINE MARKETPLACE IS A SERIOUS COPYRIGHT INFRINGEMENT.
 YOU WILL BE LEGALLY PROSECUTED
 
 ==================================================*/

import UIKit

class AdCell: UICollectionViewCell {
    
    /*--- VIEWS ---*/
    @IBOutlet weak var adImage: UIImageView!
    @IBOutlet weak var adTitleLabel: UILabel!
    @IBOutlet weak var adPriceLabel: UILabel!
    @IBOutlet weak var soldBadge: UIImageView!
    @IBOutlet weak var freeShipping: UILabel!
}
