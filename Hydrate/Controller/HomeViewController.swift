//
//  HomeViewController.swift
//  Hydrate
//
//  Created by Soumil Datta on 5/21/20.
//  Copyright © 2020 Soumil Datta. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var waterBar: UIProgressView!
    @IBOutlet weak var glassStepper: UIStepper!
    
    let glassManager = GlassManager()
    let db = Firestore.firestore()
    
    var current: Float = 0.0
    var percent: Float = 0.0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        // reload view every time it is clicked on
        // iniatialize progressbar and stepper values with new (possibly changed) currentGoal value
        percent = current / GlassManager.sharedInstance.currentGoal
        waterBar.setProgress(percent, animated: false)
        glassStepper.value = Double(current)
        
        if percent * 100 < 1000 {
            percentLabel.text = String(format: "%.0f", percent * 100) + "%"
        } else {
            percentLabel.text = "999%"
        }
        
        // set goal and number of glasses consumed today here
        goalLabel.text = String(format: "Current Daily Goal: %.0f glasses", GlassManager.sharedInstance.currentGoal)
        currentLabel.text = String(format: "%.0f/%.0f", current, GlassManager.sharedInstance.currentGoal)

        loadData()

    }
    
    func loadData() {
        if let currentUser = Auth.auth().currentUser?.email {
            db.collection(K.firebase.settingsCollection).document(currentUser).getDocument { (documentSnapshot, error) in
                if let e = error {
                    print("\(e)")
                } else {
                    if let document = documentSnapshot {
                        
                        let data = document.data()
                        
                        if let currentGoal = data?["goal"] as! Float?{
                            print(currentGoal)
                            
                            self.percent = self.current / currentGoal
                            self.waterBar.setProgress(self.percent, animated: false)
                            self.glassStepper.value = Double(self.current)
                            
                            if self.percent * 100 < 1000 {
                                self.percentLabel.text = String(format: "%.0f", self.percent * 100) + "%"
                            } else {
                                self.percentLabel.text = "999%"
                            }
                            
                            // set goal and number of glasses consumed today here
                            self.goalLabel.text = String(format: "Current Daily Goal: %.0f glasses", currentGoal)
                            self.currentLabel.text = String(format: "%.0f/%.0f", self.current, currentGoal)
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // making progress bar vertical and increasing width
        waterBar.transform = waterBar.transform.rotated(by: 270 * .pi / 180)
        waterBar.transform = waterBar.transform.scaledBy(x: 1.8, y: 100)

    }
    
    @IBAction func glassesStepper(_ sender: UIStepper) {
        // change current value based on stepper
        current = Float(sender.value)
        sendCurrentValue(current)
        
        currentLabel.text = String(format: "%.0f/%.0f", current, GlassManager.sharedInstance.currentGoal)
            
        // progress bar and percent progression
        percent = current / GlassManager.sharedInstance.currentGoal
        waterBar.setProgress(percent, animated: true)
        
        // limit percent to 999%
        if percent * 100 < 1000 {
            percentLabel.text = String(format: "%.0f", percent * 100) + "%"
        } else {
            percentLabel.text = "999%"
        }
        
    }
    
}


// MARK: - Firestore
extension HomeViewController {
    func sendCurrentValue(_ current: Float) {
        if let currentUser = Auth.auth().currentUser?.email {
            db.collection(K.firebase.mainDataCollection).document(currentUser).setData([
                K.firebase.currentCountField: current
            ]) { (error) in
                if let e = error {
                    print("Error \(e)")
                } else {
                    print("Goal saved")
                }
            }
        }
    }
    
    
}
