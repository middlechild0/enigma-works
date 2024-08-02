/*==================================================
 Bazaar
 
 © XScoder 2018
 All Rights reserved
 
 RE-SELLING THIS SOURCE CODE TO ANY ONLINE MARKETPLACE IS A SERIOUS COPYRIGHT INFRINGEMENT.
 YOU WILL BE LEGALLY PROSECUTED
 
 ===================================================*/

import UIKit

class NotificationCell: UITableViewCell {

    /*--- VIEWS ---*/
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var notifTextLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Layouts
        avatarImg.layer.cornerRadius = avatarImg.bounds.size.width/2
        
        fullnameLabel.autoresizingMask = .flexibleWidth
        dateLabel.autoresizingMask = .flexibleWidth
        notifTextLabel.autoresizingMask = .flexibleWidth
        
    }

}// ./ end
