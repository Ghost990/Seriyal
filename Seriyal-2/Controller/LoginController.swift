//
//  LoginController.swift
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

class LoginController: UIViewController {
    
    @IBOutlet weak var userEmailField: UITextField!
    @IBOutlet weak var userPasswordField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        SVProgressHUD.show()
        
        
        //TODO: Log in the user
        Auth.auth().signIn(withEmail: userEmailField.text!, password: userPasswordField.text!) { (user, error) in
            if error != nil {
                print("there was an error loggin in. Error: \(error)")
            } else {
                
                SVProgressHUD.dismiss()
                
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
