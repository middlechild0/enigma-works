/*==================================================
 Bazaar
 
 © XScoder 2018
 All Rights reserved
 
 RE-SELLING THIS SOURCE CODE TO ANY ONLINE MARKETPLACE IS A SERIOUS COPYRIGHT INFRINGEMENT.
 YOU WILL BE LEGALLY PROSECUTED
 
===================================================*/

import UIKit
import Parse

class Notifications: UIViewController, UITableViewDelegate, UITableViewDataSource {

    /*--- VIEWS ---*/
    @IBOutlet weak var notificationsTableView: UITableView!
    let refreshControl = UIRefreshControl()

    
    
    /*--- VARIABLES ---*/
    var notificationsArray = [PFObject]()
    
    
    
    
    // ------------------------------------------------
    // MARK: - VIEW DID APPEAR
    // ------------------------------------------------
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() == nil {
            let vc = storyboard?.instantiateViewController(withIdentifier: "Intro") as! Intro
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    // ------------------------------------------------
    // MARK: - VIEW DID LOAD
    // ------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Refresh Control
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        notificationsTableView.addSubview(refreshControl)
        
        // Call query
        if PFUser.current() != nil { queryNotifications() }
    }
    
    
    
    // ------------------------------------------------
    // MARK: - QUERY NOTIFICATIONS
    // ------------------------------------------------
    func queryNotifications() {
        let currentUser = PFUser.current()!
        
        let query = PFQuery(className: NOTIFICATIONS_CLASS_NAME)
        query.whereKey(NOTIFICATIONS_OTHER_USER, equalTo: currentUser)
        query.order(byDescending: NOTIFICATIONS_CREATED_AT)
        // Perform query
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                self.hideHUD()
                self.notificationsArray = objects!
                self.notificationsTableView.reloadData()
            // error
            } else { self.hideHUD(); self.simpleAlert("\(error!.localizedDescription)")
        }}
    }
    
    
    
    // ------------------------------------------------
    // MARK: - SHOW DATA IN TABLEVIEW
    // ------------------------------------------------
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        
        // Parse Object
        var nObj = PFObject(className: NOTIFICATIONS_CLASS_NAME)
        nObj = notificationsArray[indexPath.row]
        
        // User Pointer
        let userPointer = nObj[NOTIFICATIONS_CURRENT_USER] as! PFUser
        userPointer.fetchIfNeededInBackground(block: { (user, error) in
            if error == nil {
                
                // Avatar
                self.getParseImage(object: userPointer, colName: USER_AVATAR, imageView: cell.avatarImg)
                // Full name
                cell.fullnameLabel.text = "\(userPointer[USER_FULLNAME]!)"
                // Date
                cell.dateLabel.text = self.timeAgoSinceDate(nObj.createdAt!, currentDate: Date(), numericDates: true)
                // Notification's Text
                cell.notifTextLabel.text = "\(nObj[NOTIFICATIONS_TEXT]!)"
            
            // error
            } else { self.simpleAlert("\(error!.localizedDescription)")
        }})// ./ userPointer
        
    return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    // ------------------------------------------------
    // MARK: - SHOW USER PROFILE
    // ------------------------------------------------
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentUser = PFUser.current()!
        
        // Parse Object
        var nObj = PFObject(className: NOTIFICATIONS_CLASS_NAME)
        nObj = notificationsArray[indexPath.row]
        
        // User Pointer
        let userPointer = nObj[NOTIFICATIONS_CURRENT_USER] as! PFUser
        userPointer.fetchIfNeededInBackground(block: { (user, error) in
            if error == nil {
                if userPointer.objectId! == currentUser.objectId! {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Account") as! Account
                    vc.isCurrentUser = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserProfile") as! UserProfile
                    vc.userObj = userPointer
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            // error
            } else { self.simpleAlert("\(error!.localizedDescription)") }
        })// ./ userPointer
    }
    
    
    
    // ------------------------------------------------
    // MARK: - DELETE NOTIFICATION
    // ------------------------------------------------
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var nObj = PFObject(className: NOTIFICATIONS_CLASS_NAME)
            nObj = notificationsArray[indexPath.row]
            nObj.deleteInBackground { (succ, error) in
                if error == nil {
                    self.notificationsArray.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                // error
                } else { self.simpleAlert("\(error!.localizedDescription)")
            }}
        }
    }
    
    
    
    
    // ------------------------------------------------
    // MARK: - REFRESH DATA
    // ------------------------------------------------
    @objc func refreshData () {
        // Recall query
        queryNotifications()
        
        if refreshControl.isRefreshing { refreshControl.endRefreshing() }
    }
    

}// ./ end
