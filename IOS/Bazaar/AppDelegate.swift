/*==================================================
 Bazaar
 
 © XScoder 2018
 All Rights reserved
 
 RE-SELLING THIS SOURCE CODE TO ANY ONLINE MARKETPLACE IS A SERIOUS COPYRIGHT INFRINGEMENT.
 YOU WILL BE LEGALLY PROSECUTED
 
===================================================*/

import UIKit
import Parse
import ParseFacebookUtilsV4
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            DEFAULTS.set(false, forKey: "allowApple")
            // INITIALIZE PARSE SERVER
            let configuration = ParseClientConfiguration {
                $0.applicationId = PARSE_APP_ID
                $0.clientKey = PARSE_CLIENT_KEY
                $0.server = "https://parseapi.back4app.com"
            }
            Parse.initialize(with: configuration)
        
        
            // INITIALIZE FACEBOOK UTILS
            PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)
        
        
            // REGISTER FOR PUSH NOTIFICATIONS
            let notifTypes:UIUserNotificationType  = [.alert, .badge, .sound]
            let settings = UIUserNotificationSettings(types: notifTypes, categories: nil)
            DispatchQueue.main.async(execute: {
                application.registerUserNotificationSettings(settings)
                application.registerForRemoteNotifications()
                application.applicationIconBadgeNumber = 0
            })
        
        
        // Initialize AdMob
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        return true
    }

    
    
    
    // ------------------------------------------------
    // MARK: - DELEGATES FOR PUSH NOTIFICATIONS
    // ------------------------------------------------
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let installation = PFInstallation.current()
        installation?.setDeviceTokenFrom(deviceToken)
        installation?.saveInBackground(block: { (succ, error) in
            if error == nil {
                print("DEVICE TOKEN REGISTERED!")
            // error
            } else { print("\(error!.localizedDescription)")
        }})
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        PFPush.handle(userInfo)
        if application.applicationState == .inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(inBackground: userInfo, block: nil)
        }
    }
    
    
    
    // ------------------------------------------------
    // MARK: - DELEGATES FOR FACEBOOK LOGIN
    // ------------------------------------------------
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
        
        // Reset icon's badge number to 0
        let installation = PFInstallation.current()
        print("BADGE: \(installation!.badge)")
        if installation?.badge != 0 {
            installation?.badge = 0
            installation?.saveInBackground(block: { (succ, error) in
                if error == nil {
                    print("Badge reset to 0")
                // error
                } else { print("\(error!.localizedDescription)")
            }})
        }
    }

    
    
 
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }


    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

