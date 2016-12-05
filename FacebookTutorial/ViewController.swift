//
//  ViewController.swift
//  FacebookTutorial
//
//  Created by Brian Coleman on 2015-03-27.
//  Copyright (c) 2015 Brian Coleman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        // Do any additional setup after loading the view, typically from a nib.
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            print("AccessToken distinto de nil")
            // User is already logged in, do work such as go to next view controller.
            
            // Or Show Logout Button
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
            self.returnUserData()
        }
        else
        {
            print("AccessToken igual a nil")
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
        
    }

    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
            print("Error")
        }
        else if result.isCancelled {
            // Handle cancellations
            print("Cancelado")
        }
        else {
            print("Entramos por el succed")
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
                print("Veamos del result del succeed")
                print("granted \(result.grantedPermissions)")
                print("declained \(result.declinedPermissions)")
                //print(result.dictionaryWithValuesForKeys(["email"]))
            }
            print("Vamos a ver el user data")
            self.returnUserData()
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData()
    {
        print("estamos en return User Data")
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture, verified"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
           print("dentro de la funcion")
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print(result)
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                let picture : NSString = result.valueForKey("picture")?.valueForKey("data")?.valueForKey("url") as! NSString
                print("User Picture URL is: \(picture)")
                let email : NSString = result.valueForKey("email") as! NSString
                print("User Email: \(email)")
                let verified : CFBoolean = result.valueForKey("verified") as! CFBoolean
                print("Verified: \(verified)")
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

