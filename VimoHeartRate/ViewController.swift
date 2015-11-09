//
//  ViewController.swift
//  VimoHeartRate
//
//  Created by Ethan Fan on 6/25/15.
//  Copyright © 2015 Vimo Lab. All rights reserved.
//


/* TODO: 
    1. Show status of connection to Apple TV.
    2. Automatic retry connetion (may or may not already be happening)
    3. Visual indicator when message recieved from watch

*/



import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {

    @IBOutlet var hblabel: UILabel!
    
    @IBOutlet var tvConnectionLabel: UILabel!
    
    var remoteSender : RemoteSender?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let session = WCSession.defaultSession()
        session.delegate = self
        session.activateSession()
        
        //TV Comms
        self.remoteSender = RemoteSender()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTVConnectionStatus", name:"UpdateTVConnectionStatus", object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func reconnectTapped(sender: AnyObject) {
        self.remoteSender = RemoteSender()
        self.tvConnectionLabel.text = "---"
    
    }
    
    func updateTVConnectionStatus() {
        dispatch_async(dispatch_get_main_queue()){
            if let isConnected = self.remoteSender?.isConnected {
                self.tvConnectionLabel.text = String(isConnected)
            } else {
                self.tvConnectionLabel.text = "---"
            }
            
            
        }
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
 
    @IBAction func sendTestHB(sender: AnyObject) {
        let message = ["heartbeat" : 100.0]
        self.remoteSender?.sendInfo(message)
    }

    
}

