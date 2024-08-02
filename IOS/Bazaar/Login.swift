/*==================================================
 Bazaar
 
 © XScoder 2018
 All Rights reserved
 
 RE-SELLING THIS SOURCE CODE TO ANY ONLINE MARKETPLACE IS A SERIOUS COPYRIGHT INFRINGEMENT.
 YOU WILL BE LEGALLY PROSECUTED
 
 ==================================================*/

import UIKit
import Parse
import ParseFacebookUtilsV4


class Login: UIViewController, UITextFieldDelegate {
    
    /*--- VIEWS ---*/
    @IBOutlet var containerScrollView: UIScrollView!
    @IBOutlet var usernameTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var loginButtons: [UIButton]!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    
    
    
    
    // ------------------------------------------------
    // MARK: - VIEW DID APPEAR
    // ------------------------------------------------
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            _ = navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    
    // ------------------------------------------------
    // MARK: - VIEW DID LOAD
    // ------------------------------------------------
    override func viewDidLoad() {
            super.viewDidLoad()
        
        loginLabel.text = "Log in to \(APP_NAME)"
        
        // Layouts
        loginButton.layer.cornerRadius = 22
        logoImg.layer.cornerRadius = logoImg.bounds.size.width/2
        containerScrollView.contentSize = CGSize(width: containerScrollView.frame.size.width, height: 600)
    }
    
    
    
    
    // ------------------------------------------------
    // MARK: - LOGIN BUTTON
    // ------------------------------------------------
    @IBAction func loginButt(_ sender: AnyObject) {
        dismissKeyboard()
        showHUD()
        
        PFUser.logInWithUsername(inBackground: usernameTxt.text!, password:passwordTxt.text!) { (user, error) -> Void in
            if error == nil {
                self.hideHUD()
                mustReload = true
                _ = self.navigationController?.popToRootViewController(animated: true)
                
                
            // error
            } else { self.hideHUD(); self.simpleAlert("\(error!.localizedDescription)")
        }}
    }
    
    
    
    

    
    
    // ------------------------------------------------
    // MARK: - SIGNUP BUTTON
    // ------------------------------------------------
    @IBAction func signupButt(_ sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUp") as! SignUp
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    // ------------------------------------------------
    // MARK: - TEXTFIELD DELEGATES
    // ------------------------------------------------
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTxt  {  passwordTxt.becomeFirstResponder() }
        if textField == passwordTxt  {
            passwordTxt.resignFirstResponder()
            loginButt(self)
        }
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
    }


    
    
    
    
    
    // ------------------------------------------------
    // MARK: - FORGOT PASSWORD BUTTON
    // ------------------------------------------------
    @IBAction func forgotPasswButt(_ sender: AnyObject) {
        let alert = UIAlertController(title: APP_NAME,
            message: "Type your email address you used to register.",
            preferredStyle: .alert)
        
        // RESET PASSWORD
        let reset = UIAlertAction(title: "Reset Password", style: .default, handler: { (action) -> Void in
            let textField = alert.textFields!.first!
            let txtStr = textField.text!
            PFUser.requestPasswordResetForEmail(inBackground: txtStr, block: { (succ, error) in
                if error == nil {
                    self.simpleAlert("You will receive an email shortly with a link to reset your password")
            }})
        })
        alert.addAction(reset)
        
        
        // CANCEL BUTTON
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(cancel)
        
        // TextField
        alert.addTextField { (textField: UITextField) in
            textField.keyboardType = .emailAddress
        }
        
        present(alert, animated: true, completion: nil)
    }


    
    // ------------------------------------------------
    // MARK: - DISMISS BUTTON
    // ------------------------------------------------
    @IBAction func dismissButt(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    

}// ./ end
