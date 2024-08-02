/*==================================================
 Bazaar
 
 © XScoder 2018
 All Rights reserved
 
 RE-SELLING THIS SOURCE CODE TO ANY ONLINE MARKETPLACE IS A SERIOUS COPYRIGHT INFRINGEMENT.
 YOU WILL BE LEGALLY PROSECUTED
 
====================================================*/

import UIKit
import Parse

class Settingss: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    /*--- VIEWS ---*/
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var pushNotificationsSWitch: UISwitch!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var ovContainerView: UIView!
    @IBOutlet weak var ovTitleLabel: UILabel!
    @IBOutlet weak var ovTextField: UITextField!
    @IBOutlet weak var ovSaveButton: UIButton!
    @IBOutlet weak var ovCancelButton: UIButton!
    
    

    /*--- VARIABLES --*/
    var optionIndex = 0
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Layouts
        avatarImg.layer.cornerRadius = avatarImg.bounds.size.width/2
        containerScrollView.contentSize = CGSize(width: containerScrollView.frame.size.width,
                                                 height: 750)
        logoutButton.layer.cornerRadius = 22
        
        optionsView.frame.origin.y = view.frame.size.height
        ovSaveButton.layer.cornerRadius = 22
        ovCancelButton.layer.cornerRadius = 22
        ovContainerView.layer.cornerRadius = 6

        
        // Call function
        showUserInfo()
    }

    
    
    
    // ------------------------------------------------
    // MARK: - SHOW USER INFO
    // ------------------------------------------------
    func showUserInfo() {
        let currentUser = PFUser.current()!
        let username = currentUser[USER_USERNAME] ?? ""
        let fullname = currentUser[USER_FULLNAME] ?? ""
        let email = currentUser[USER_EMAIL] ?? ""


        usernameLabel.text = "\(username)"
        fullnameLabel.text = "\(fullname) "
        emailLabel.text = "\(email)"
        getParseImage(object: currentUser, colName: USER_AVATAR, imageView: avatarImg)
        
        // Push Notifications Switch state
        allowPush = DEFAULTS.bool(forKey: "allowPush")
        if !allowPush {
            pushNotificationsSWitch.setOn(true, animated: true)
        } else {
            pushNotificationsSWitch.setOn(false, animated: true)
        }
    }
    
    
    
    // ------------------------------------------------
    // MARK: - CHANGE PROFILE PHOTO BUTTON
    // ------------------------------------------------
    @IBAction func changeProfilePhotoButt(_ sender: UIButton) {
        let alert = UIAlertController(title: APP_NAME,
            message: "Select source",
            preferredStyle: .actionSheet)
        
        // OPEN CAMERA
        let camera = UIAlertAction(title: "Take a picture", style: .default, handler: { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        alert.addAction(camera)

        // OPEN PHOTO LIBRARY
        let library = UIAlertAction(title: "Pick a photo from library", style: .default, handler: { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        alert.addAction(library)

        
        // CANCEL BUTTON
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
    // MARK: - GET THE IMAGE AND SAVE IT
    // ------------------------------------------------
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // Automatically save the avatar image
            let currentUser = PFUser.current()!
            avatarImg.image = scaleImageToMaxWidth(image: image, newWidth: 300)
            saveParseImage(object: currentUser, colName: USER_AVATAR, imageView: avatarImg)
            currentUser.saveInBackground { (succ, error) in
                if error == nil {
                    self.showToast("Porfile Photo saved!")
                // error
                } else {self.simpleAlert("\(error!.localizedDescription)")
            }}
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    // ------------------------------------------------
    // MARK: - USERNAME, NAME,EMAIL AND BIO BUTTONS
    // ------------------------------------------------
    @IBAction func usernameNameEmailBioButt(_ sender: UIButton) {
        let currentUser = PFUser.current()!
        optionsView.frame.origin.y = 0
        optionIndex = sender.tag
        
        switch sender.tag {
        case 0:
            ovTitleLabel.text = "Change Username"
            ovTextField.text = "\(currentUser[USER_USERNAME]!)"
            break
        case 1:
            ovTitleLabel.text = "Change Name"
            ovTextField.text = "\(currentUser[USER_FULLNAME]!)"
            break
        case 2:
            ovTitleLabel.text = "Change Email"
            ovTextField.text = "\(currentUser[USER_EMAIL]!)"
            break
        case 3:
            ovTitleLabel.text = "Change Bio / About you"
            if currentUser[USER_BIO] != nil {
                ovTextField.text = "\(currentUser[USER_BIO]!)"
            } else { ovTextField.text = "" }
            break
            
        default:break }
    }
    
    
    
    // ------------------------------------------------
    // MARK: - SAVE OPTION BUTTON
    // ------------------------------------------------
    @IBAction func saveOptionButt(_ sender: UIButton) {
        let currentUser = PFUser.current()!
        
        if ovTextField.text != "" {
            switch optionIndex {
                case 0:
                    usernameLabel.text = ovTextField.text!
                    currentUser[USER_USERNAME] = ovTextField.text!
                    currentUser.saveInBackground()
                    break
                case 1:
                    fullnameLabel.text = ovTextField.text!
                    currentUser[USER_FULLNAME] = ovTextField.text!
                    currentUser.saveInBackground()
                    break
                case 2:
                    emailLabel.text = ovTextField.text!
                    currentUser[USER_EMAIL] = ovTextField.text!
                    currentUser.saveInBackground()
                    break
                case 3:
                    currentUser[USER_BIO] = ovTextField.text!
                    currentUser.saveInBackground()
                    break
            default:break }
            
            optionsView.frame.origin.y = view.frame.size.height
            ovTextField.resignFirstResponder()
            
        } else { simpleAlert("You must type something!") }
    }
    
    
    // ------------------------------------------------
    // MARK: - CANCEL OPTION BUTTON
    // ------------------------------------------------
    @IBAction func cancelOptionButt(_ sender: Any) {
        optionsView.frame.origin.y = view.frame.size.height
        ovTextField.resignFirstResponder()
    }
    
    
    
    
    // ------------------------------------------------
    // MARK: - RESET PASSWORD BUTTON
    // ------------------------------------------------
    @IBAction func resetPasswordButt(_ sender: Any) {
        let alert = UIAlertController(title: APP_NAME,
            message: "Type the email address you've used to sign up.\n(Please note that if you've signed in with Facebook, you will not be able to reset your password)",
            preferredStyle: .alert)
        
        // RESET PASSWORD
        let reset = UIAlertAction(title: "Reset Password", style: .default, handler: { (action) -> Void in
            let textField = alert.textFields!.first!
            let txtStr = textField.text!
            
            PFUser.requestPasswordResetForEmail(inBackground: txtStr, block: { (succ, error) in
                if error == nil {
                    self.simpleAlert("Thanks, you are going to shortly get an email with a link to reset your password!")
                }})
        })
        alert.addAction(reset)
        
        
        // CANCEL BUTTON
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })
        alert.addAction(cancel)
        
        // TextField
        alert.addTextField { (textField: UITextField) in
            textField.keyboardType = .default
            textField.autocorrectionType = .no
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    // ------------------------------------------------
    // MARK: - CONTACT US BUTTON
    // ------------------------------------------------
    @IBAction func contactUsButt(_ sender: Any) {
        UIPasteboard.general.string = SUPPORT_EMAIL_ADDRESS
        simpleAlert("Our Support email address has been copied to your clipboard.\nOpen your favorite Mail client and drop us a message, we'll get back to you asap!")
    }
    
    
    // ------------------------------------------------
    // MARK: - PUSH NOTIFICATIONS SWITCH
    // ------------------------------------------------
    @IBAction func pushNotificationChanged(_ sender: UISwitch) {
        allowPush = !allowPush
        print("ALLOW PUSH: \(allowPush)")
        DEFAULTS.set(allowPush, forKey: "allowPush")
    }
    
    
    
    // ------------------------------------------------
    // MARK: - TERMS OF SERVICE & PRIVACY POLICY BUTTON
    // ------------------------------------------------
    @IBAction func termsOfUseButt(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TermsOfService") as! TermsOfService
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
    
    
    // ------------------------------------------------
    // MARK: - LOGOUT BUTTON
    // ------------------------------------------------
    @IBAction func logoutButt(_ sender: Any) {
        let alert = UIAlertController(title: APP_NAME,
        message: "Are you sure you want to logout?",
        preferredStyle: .alert)
        
        // LOGOUT
        let logout = UIAlertAction(title: "Logout", style: .destructive, handler: { (action) -> Void in
            self.showHUD()
            PFUser.logOutInBackground(block: { (error) in
                if error == nil {
                    self.hideHUD()
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Intro") as! Intro
                    self.navigationController?.pushViewController(vc, animated: true)
                // error
                } else { self.hideHUD(); self.simpleAlert("\(error!.localizedDescription)")
            }})
        })
        alert.addAction(logout)
        
        
        // CANCEL BUTTON
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    // ------------------------------------------------
    // MARK: - BACK BUTTON
    // ------------------------------------------------
    @IBAction func backButt(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
}// ./ end

