//
//  RegisterController.swift
//  Seriyal-2
//
//  Created by Zsolt Nagy on 2017. 11. 03..
//  Copyright © 2017. Zsolt Nagy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase
import SVProgressHUD

class RegisterController: UIViewController {
    
    @IBOutlet weak var userRegisterEmail: UITextField!
    @IBOutlet weak var userRegisterPassword: UITextField!
    
    var refUsers : DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        refUsers = Database.database().reference().child("users")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        
        SVProgressHUD.show()
        
        
        //TODO: Log in the user
        Auth.auth().createUser(withEmail: userRegisterEmail.text!, password: userRegisterPassword.text!) { (user, error) in
            if error != nil {
                print("there was an error registering. Error: \(error)")
            } else {
                
                let email = self.userRegisterEmail.text!
                let key = self.refUsers.childByAutoId().key
                
                SVProgressHUD.dismiss()
                
                //creating users with the given values
                let user = ["id": key,
                                "email": email
                ]
                
                self.refUsers.child(key).setValue(user)
                //ref.child("users").child(authData!.uid).setValue(userData)
                
                self.performSegue(withIdentifier: "goToDiscover", sender: self)
                
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
