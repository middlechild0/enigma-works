/*==================================================
 Bazaar
 
 © XScoder 2018
 All Rights reserved
 

 RE-SELLING THIS SOURCE CODE TO ANY ONLINE MARKETPLACE IS A SERIOUS COPYRIGHT INFRINGEMENT.
 YOU WILL BE LEGALLY PROSECUTED

=====================================================*/

import UIKit

class ChatCell: UITableViewCell {

    /*--- VIEWS ---*/
    @IBOutlet weak var adImage: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var adTitleLabel: UILabel!
    @IBOutlet weak var chatDateLabel: UILabel!
    @IBOutlet weak var avatarImg: UIImageView!
    
    
    /*--- VARIABLES ---*/
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Layouts
        adImage.layer.cornerRadius = 4
        avatarImg.layer.cornerRadius = avatarImg.bounds.size.width/2
        
        fullnameLabel.autoresizingMask = .flexibleWidth
        chatDateLabel.autoresizingMask = .flexibleWidth
        adTitleLabel.autoresizingMask = .flexibleWidth
        
    }

}// ./ end
