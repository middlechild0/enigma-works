/*==================================================
 Bazaar
 
 © XScoder 2018
 All Rights reserved
 
 RE-SELLING THIS SOURCE CODE TO ANY ONLINE MARKETPLACE IS A SERIOUS COPYRIGHT INFRINGEMENT.
 YOU WILL BE LEGALLY PROSECUTED
 
 ==================================================*/

import UIKit
import ParseFacebookUtilsV4
import Parse
import AuthenticationServices

class AuthDelegate:NSObject, PFUserAuthenticationDelegate {
    func restoreAuthentication(withAuthData authData: [String : String]?) -> Bool {
        return true
    }
    
    func restoreAuthenticationWithAuthData(authData: [String : String]?) -> Bool {
        return true
    }
}


class Intro: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding,PFUserAuthenticationDelegate {

    /*--- VIEWS ---*/
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var appnameLabel: UILabel!
    

    
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
        
        appnameLabel.text = "\(APP_NAME)"
        
        // Layouts
        facebookButton.layer.cornerRadius = 22
        signUpButton.layer.cornerRadius = 22
        signUpButton.layer.borderColor = MAIN_COLOR.cgColor
        signUpButton.layer.borderWidth = 2
        loginButton.layer.cornerRadius = 22
        loginButton.layer.borderColor = MAIN_COLOR.cgColor
        loginButton.layer.borderWidth = 2

        // Add Apple Sign in Button
        if #available(iOS 13.0, *) {
            let asiButton = ASAuthorizationAppleIDButton()
            asiButton.frame = CGRect(x: 0, y: 250, width: 280, height: 44)
            asiButton.center.x = view.center.x
            asiButton.clipsToBounds = true
            asiButton.layer.cornerRadius = 22
            asiButton.addTarget(self, action: #selector(appleButt), for: .touchUpInside)
            view.addSubview(asiButton)
        }
    }

    
    
    
    
    // ------------------------------------------------
    // MARK: - FACEBOOK LOGIN BUTTON
    // ------------------------------------------------
    @IBAction func facebookButt(_ sender: Any) {
        let alert = UIAlertController(title: APP_NAME,
            message: "Do you agree with our Terms of Service?",
            preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            // Set permissions required from the facebook user account
            let permissions = ["public_profile", "email"];
            self.showHUD()
            
            // LOGIN WITH FACEBOOK
            PFFacebookUtils.logInInBackground(withReadPermissions: permissions) { (user, error) in
                if user == nil {
                    self.simpleAlert("Facebook login cancelled")
                    self.hideHUD()
                    
                } else if (user!.isNew) {
                    print("NEW USER signed up or logged in with Facebook");
                    self.getFacebookUserData()
                    
                } else {
                    self.hideHUD()
                    print("OLD USER logged in with Facebook!");
                    _ = self.navigationController?.popToRootViewController(animated: true)
                }}
        })
        alert.addAction(yes)

        
        // TERMS OF SERVICE
        let tos = UIAlertAction(title: "Read Terms of Service", style: .default, handler: { (action) -> Void in
            self.tosButt(self)
        })
        alert.addAction(tos)

        
        // CANCEL BUTTON
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func getFacebookUserData() {
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email, picture.type(large)"])
            let connection = FBSDKGraphRequestConnection()
            connection.add(graphRequest) { (connection, result, error) in
                if error == nil {
                    let userData:[String:AnyObject] = result as! [String : AnyObject]
     
                    let currentUser = PFUser.current()!
                    
                    // Get data
                    let facebookID = userData["id"] as! String
                    let name = userData["name"] as! String
                    var email = ""
                    if userData["email"] != nil { email = userData["email"] as! String
                    } else { email = "\(facebookID)@facebook.com" }
                    
                    // Get profile picture
                    let pictureURL = URL(string: "https://graph.facebook.com/\(facebookID)/picture?type=large")
                    let urlRequest = URLRequest(url: pictureURL!)
                    let session = URLSession.shared
                    let dataTask = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                        if error == nil && data != nil {
                            let image = UIImage(data: data!)
                            let imageData = image!.jpegData(compressionQuality: 1.0)
                            let imageFile = PFFileObject(name:"avatar.jpg", data:imageData!)
                            currentUser[USER_AVATAR] = imageFile
                            currentUser.saveInBackground(block: { (succ, error) in
                                print("...AVATAR SAVED!")
                                
                                self.hideHUD()
                                mustReload = true
                                _ = self.navigationController?.popToRootViewController(animated: true)
                                /*
                                // Go back to Home
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBar") as! UITabBarController
                                vc.selectedIndex = 0
                                vc.modalPresentationStyle = .fullScreen
                                self.present(vc, animated: false, completion: nil)
                                 */
                            })
                        // error
                        } else { self.hideHUD(); self.simpleAlert("\(error!.localizedDescription)")
                    }})
                    dataTask.resume()
                    
                    
                    // Update user data
                    let nameArr = name.components(separatedBy: " ")
                    var username = String()
                    for word in nameArr { username.append(word.lowercased()) }
                    currentUser.username = username
                    currentUser.email = email
                    // Additional data
                    currentUser[USER_FULLNAME] = name
                    currentUser[USER_IS_REPORTED] = false
                    currentUser[USER_HAS_BLOCKED] = [String]()
                    
                    currentUser.saveInBackground(block: { (succ, error) in
                        if error == nil {
                            print("USER'S DATA UPDATED...")
                    }})
                    
                // error
                } else { self.hideHUD(); self.simpleAlert("\(error!.localizedDescription))")
                    
            }}
            connection.start()
    }
    
    
    

    // ------------------------------------------------
    // MARK: - APPLE SIGN IN FUNCTIONS
    // ------------------------------------------------
    @objc func appleButt() {
        if #available(iOS 13.0, *) {
           
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
            
        }
    }

    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credentials = authorization.credential as? ASAuthorizationAppleIDCredential, let token = credentials.identityToken, let tokenString = String(data: token, encoding: .utf8) else {
                // handle this
                return
            }

        let authData = ["token": tokenString, "id": credentials.user]
        let allowApple = DEFAULTS.bool(forKey: "allowApple")
        
        if !allowApple {
            PFUser.register(AuthDelegate(), forAuthType: "apple")
            DEFAULTS.set(true, forKey: "allowApple")
        }
       
        
        PFUser.logInWithAuthType(inBackground: "apple", authData: authData).continue({ (task) -> Any? in
//            guard task.error == nil, let _ = task.result else {
//
//                DispatchQueue.main.async {
//                    self.simpleAlert("\(task.error!.localizedDescription)")
//                }
//
//                print("TASK: \(String(describing: task.result?.email!))")
//                return task
//            }
                
            if ((task.error) != nil){
                print("\(task.error!.localizedDescription)")
            }
            // Sign in with Apple and store currentUser's data

                if let currentUser = task.result {
                        
                    // User already signed in with Apple
                    if credentials.fullName?.givenName == nil {
                        print("OLD USER signed in with Apple!")
                        DispatchQueue.main.async {
                            mustReload = true
                            _ = self.navigationController?.popToRootViewController(animated: true)
                        }
                            
                    // First time sign in with Apple
                    } else {
                        print("NEW APPLE USER: \(credentials.fullName?.givenName ?? "")")
                        
                        // Username, email and password
                        if credentials.email != nil { currentUser.email = credentials.email }
                        currentUser.password = UUID().uuidString
                        let nameArr = [credentials.fullName!.givenName!, credentials.fullName!.familyName!]
                        var username = String()
                        for word in nameArr { username.append(word.lowercased()) }
                        currentUser.username = username
                            
                        // Additional data
                        currentUser[USER_FULLNAME] = credentials.fullName!.givenName! + " " + credentials.fullName!.familyName!
                        currentUser[USER_IS_REPORTED] = false
                        currentUser[USER_HAS_BLOCKED] = [String]()
                            
                        
                        // Save
                        currentUser.saveInBackground { (succ, error) in
                            if error == nil {
                                print("NEW APPLE USER SAVED!")

                                // Save default Avatar in background
                                let image = UIImage(named: "default_avatar")
                                let imageData = image!.jpegData(compressionQuality: 1.0)
                                let imageFile = PFFileObject(name:"avatar.jpg", data:imageData!)
                                currentUser[USER_AVATAR] = imageFile
                                currentUser.saveInBackground()
                                    
                                DispatchQueue.main.async {
                                    mustReload = true
                                    _ = self.navigationController?.popToRootViewController(animated: true)
                                }

                            // error
                            } else { self.hideHUD(); self.simpleAlert("\(error!.localizedDescription))")
                        }}
                    }
                        
                // error in task.result
                } else { self.simpleAlert("\(task.error!.localizedDescription)") }
            
            return task
        })
       
           
    }
        
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            print("ERROR: \(error)")
    }
        
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            return view.window!
    }

    
    
    
    // ------------------------------------------------
    // MARK: - SING UP BUTTON
    // ------------------------------------------------
    @IBAction func signUpButt(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUp") as! SignUp
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    // ------------------------------------------------
    // MARK: - LOGIN BUTTON
    // ------------------------------------------------
    @IBAction func loginButt(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // ------------------------------------------------
    // MARK: - TERMS OF SERVICE BUTTON
    // ------------------------------------------------
    @IBAction func tosButt(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TermsOfService") as! TermsOfService
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
    
    
    // ------------------------------------------------
    // MARK: - DISMISS BUTTON
    // ------------------------------------------------
    @IBAction func dismissButton(_ sender: Any) {
        // Go back to the Home screen
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBar") as! UITabBarController
        vc.selectedIndex = 0
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    
    func restoreAuthentication(withAuthData authData: [String : String]?) -> Bool {
        return true
    }
    
    func restoreAuthenticationWithAuthData(authData: [String : String]?) -> Bool {
        return true
    }
}
