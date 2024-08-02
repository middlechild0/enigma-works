/*==================================================
 Bazaar
 
 © XScoder 2018
 All Rights reserved
 
 RE-SELLING THIS SOURCE CODE TO ANY ONLINE MARKETPLACE IS A SERIOUS COPYRIGHT INFRINGEMENT.
 YOU WILL BE LEGALLY PROSECUTED
 
 ==================================================*/

import UIKit
import Parse


class SignUp: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /*--- VIEWS ---*/
    @IBOutlet var containerScrollView: UIScrollView!
    @IBOutlet var usernameTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var tosButton: UIButton!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var checkboxButton: UIButton!
    

    
    /*--- VARIABLES ---*/
    var tosAccepted = false
    
    
    

    // ------------------------------------------------
    // MARK: - VIEW DID LOAD
    // ------------------------------------------------
    override func viewDidLoad() {
            super.viewDidLoad()
        
        // Layouts
        logoImg.layer.cornerRadius = logoImg.bounds.size.width/2
        signUpButton.layer.cornerRadius = 22
        containerScrollView.contentSize = CGSize(width: containerScrollView.frame.size.width, height: 750)
    }
    


    
    
    // ------------------------------------------------
    // MARK: - SIGNUP BUTTON
    // ------------------------------------------------
    @IBAction func signupButt(_ sender: AnyObject) {
        dismissKeyboard()
        
        // YOU ACCEPTED THE TERMS OF SERVICE
        if tosAccepted {
            if usernameTxt.text == "" || passwordTxt.text == "" || emailTxt.text == "" || fullnameTxt.text == "" {
                simpleAlert("You must fill all fields to sign up on \(APP_NAME)")
                self.hideHUD()
                
            } else {
                showHUD()

                let currentUser = PFUser()
                currentUser.username = usernameTxt.text!.lowercased()
                currentUser.password = passwordTxt.text
                currentUser.email = emailTxt.text
                currentUser[USER_FULLNAME] = fullnameTxt.text
                currentUser[USER_IS_REPORTED] = false
                let hasBlocked = [String]()
                currentUser[USER_HAS_BLOCKED] = hasBlocked
                
                // Save Avatar
                let imageData = UIImage(named: "default_avatar")!.jpegData(compressionQuality: 1.0)
                let imageFile = PFFileObject(name:"avatar.jpg", data:imageData!)
                currentUser[USER_AVATAR] = imageFile
            
                currentUser.signUpInBackground { (succeeded, error) -> Void in
                    if error == nil {
                        self.hideHUD()
                
                        let alert = UIAlertController(title: APP_NAME,
                            message: "We have sent you an email that contains a verification link.\nVerified users get more consideration from buyers and sellers!",
                            preferredStyle: .alert)
                        
                        // OK
                        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            mustReload = true
                            _ = self.navigationController?.popToRootViewController(animated: true)
                        })
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                        
                    // error
                    } else { self.hideHUD(); self.simpleAlert("\(error!.localizedDescription)")
                }}
            }
            
            
        // YOU HAVEN'T ACCEPTED THE TERMS OF SERVICE
        } else { simpleAlert("You must agree with Terms of Service in order to Sign Up.") }
    }
    
    
    
    
    
    // ------------------------------------------------
    // MARK: - CHECKBOX BUTTON
    // ------------------------------------------------
    @IBAction func checkboxButt(_ sender: UIButton) {
        tosAccepted = true
        sender.setBackgroundImage(UIImage(named: "checkbox_on"), for: .normal)
    }
    
    
    
    
    // ------------------------------------------------
    // MARK: - TEXTFIELD DELEGATE
    // ------------------------------------------------
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTxt {  passwordTxt.becomeFirstResponder()  }
        if textField == passwordTxt {  emailTxt.becomeFirstResponder()     }
        if textField == emailTxt {  fullnameTxt.becomeFirstResponder()     }
        if textField == fullnameTxt {  dismissKeyboard()  }
    return true
    }
    
    
    
    
    // ------------------------------------------------
    // MARK: - TAP TO DISMISS KEYBOARD
    // ------------------------------------------------
    @IBAction func tapToDismissKeyboard(_ sender: UITapGestureRecognizer) {
        dismissKeyboard()
    }
    func dismissKeyboard() {
        usernameTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        emailTxt.resignFirstResponder()
        fullnameTxt.resignFirstResponder()
    }
    
    
    

    // ------------------------------------------------
    // MARK: - DISMISS BUTTON
    // ------------------------------------------------
    @IBAction func dismissButt(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    

    // ------------------------------------------------
    // MARK: - TERMS OF SERVICE BUTTON
    // ------------------------------------------------
    @IBAction func tosButt(_ sender: AnyObject) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TermsOfService") as! TermsOfService
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
    
}// ./ end
