/*==================================================
 Bazaar
 
 © XScoder 2018
 All Rights reserved
 
 RE-SELLING THIS SOURCE CODE TO ANY ONLINE MARKETPLACE IS A SERIOUS COPYRIGHT INFRINGEMENT.
 YOU WILL BE LEGALLY PROSECUTED
 
===================================================*/

import UIKit
import WebKit

class TermsOfService: UIViewController {

    /*--- VIEWS ---*/
    @IBOutlet weak var webView: WKWebView!
    

    
    
    // ------------------------------------------------
    // MARK: - HIDE STATUS BAR
    // ------------------------------------------------
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    // ------------------------------------------------
    // MARK: - VIEW DID LOAD
    // ------------------------------------------------
    override func viewDidLoad() {
            super.viewDidLoad()
        
        // Show tou.html
        let url = Bundle.main.url(forResource: "tou", withExtension: "html")
        webView.load(URLRequest(url: url!))
    }


    
    
    // ------------------------------------------------
    // MARK: - DISMISS BUTTON
    // ------------------------------------------------
    @IBAction func dismissButt(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
}//./ end
