//
//  ViewController.swift
//  FacebookTutorial
//
//  Created by Brian Coleman on 2015-03-27.
//  Copyright (c) 2015 Brian Coleman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var botonLogin: FBSDKLoginButton!
    
    let contentURL = "http://avaluos.peta.mx"
    let contentURLImage = "http://peta.mx/images/favicon/apple-icon-180x180.png"
    let contentTitle = "Está usando InmobiliaApp para lograr un buen trato para su nueva casa"
    let contentDescription = "esta localización le gusta y está a buen precio "
    var imagePicker = UIImagePickerController()
    var mediaSelected = ""
    
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
            self.showShareButtons()
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
        print("We are in loginButton <----------------")
        
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
            print("We are logged in")
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work with the email
                print("Veamos del result del succeed")
                print("granted \(result.grantedPermissions)")
                print("declained \(result.declinedPermissions)")
            }
            print("Vamos a ver el user data")
            self.returnUserData()
            self.showShareButtons()
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
                // picture contiene realmente el URL de donde hay que descargar la imagen
                if let url = NSURL(string: picture as String) {
                    if let data = NSData(contentsOfURL: url) {
                        self.ImageView.contentMode = UIViewContentMode.ScaleAspectFit
                        self.ImageView.image = UIImage(data: data)
                    }        
                }

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
    
    func showShareButtons()
    {
        self.showLinkButton()
        self.showPhotoButton()
        self.showVideoButton()
    }
    
    // Link Methods
    
    func showLinkButton()
    {
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: self.contentURL)
        content.contentTitle = self.contentTitle
        content.contentDescription = self.contentDescription
        content.imageURL = NSURL(string: self.contentURLImage)
        
        let button : FBSDKShareButton = FBSDKShareButton()
        button.shareContent = content
        button.frame = CGRectMake((UIScreen.mainScreen().bounds.width - 100) * 0.5, 50, 100, 25)
        self.view.addSubview(button)
        
        let label : UILabel = UILabel()
        label.frame = CGRectMake((UIScreen.mainScreen().bounds.width - 200) * 0.5, 25, 200, 25)
        label.text = "Link Example"
        label.textAlignment = .Center
        self.view.addSubview(label)
    }
    
    // Photo Methods
    
    func showPhotoButton()
    {
        let button : UIButton = UIButton()
        button.backgroundColor = UIColor.blueColor()
        button.setTitle("Choose Photo", forState: .Normal)
        button.frame = CGRectMake((UIScreen.mainScreen().bounds.width - 150) * 0.5, 125, 150, 25)
        button.addTarget(self, action: #selector(ViewController.photoBtnClicked), forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
        
        let label : UILabel = UILabel()
        label.frame = CGRectMake((UIScreen.mainScreen().bounds.width - 200) * 0.5, 100, 200, 25)
        label.text = "Photos Example"
        label.textAlignment = .Center
        self.view.addSubview(label)
    }
    
    func photoBtnClicked(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            print("Photo capture")
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
            self.mediaSelected = "Photo"
        }
        
    }
    
    // Video Methods
    
    func showVideoButton()
    {
        let button : UIButton = UIButton()
        button.backgroundColor = UIColor.blueColor()
        button.setTitle("Choose Video", forState: .Normal)
        button.frame = CGRectMake((UIScreen.mainScreen().bounds.width - 150) * 0.5, 200, 150, 25)
        button.addTarget(self, action: #selector(ViewController.videoBtnClicked), forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
        
        let label : UILabel = UILabel()
        label.frame = CGRectMake((UIScreen.mainScreen().bounds.width - 200) * 0.5, 175, 200, 25)
        label.text = "Video Example"
        label.textAlignment = .Center
        self.view.addSubview(label)
    }
    
    func videoBtnClicked(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            print("Video capture")
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
            self.mediaSelected = "Video"
        }
        
    }
    
    // Used for Both Photo & Video Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if self.mediaSelected == "Photo"
        {
            let photo : FBSDKSharePhoto = FBSDKSharePhoto()
            photo.image = info[UIImagePickerControllerOriginalImage] as! UIImage
            photo.userGenerated = true
            let content : FBSDKSharePhotoContent = FBSDKSharePhotoContent()
            content.photos = [photo]
        }
        
        if self.mediaSelected == "Video"
        {
            let video : FBSDKShareVideo = FBSDKShareVideo()
            video.videoURL = info[UIImagePickerControllerMediaURL] as! NSURL
            let content : FBSDKShareVideoContent = FBSDKShareVideoContent()
            content.video = video
        }
        
        self.mediaSelected = ""
    }
    
}

