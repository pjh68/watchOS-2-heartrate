//
//  ViewController.swift
//  VimoHeartRate
//
//  Created by Ethan Fan on 6/25/15.
//  Copyright © 2015 Vimo Lab. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {

    @IBOutlet var hblabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let session = WCSession.defaultSession()
        session.delegate = self
        session.activateSession()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        NSLog("WC Message recieved: \(message)")
        let hbMaybeValue = message["heartbeat"]
        if let hbValue = hbMaybeValue as? Double {
            dispatch_async(dispatch_get_main_queue()) {
                self.hblabel.text = String(format:"%.0f", hbValue)
            }
        }
    }
    
}

