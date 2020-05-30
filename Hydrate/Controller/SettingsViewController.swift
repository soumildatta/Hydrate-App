//
//  ProfileViewController.swift
//  Hydrate
//
//  Created by Soumil Datta on 5/21/20.
//  Copyright © 2020 Soumil Datta. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    @IBOutlet weak var glassSizePicker: UIPickerView!
    @IBOutlet weak var setGoalLabel: UILabel!
    @IBOutlet weak var setGoalStepper: UIStepper!
        
    let glassManager = GlassManager()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        glassSizePicker.dataSource = self
        glassSizePicker.delegate = self

        // initialize stepper value
        setGoalStepper.value = Double(glassManager.currentGoal)
        
    }
    
    @IBAction func setGoal(_ sender: UIStepper) {
        setGoalLabel.text = "\(Int(sender.value)) glasses /day"
        GlassManager.sharedInstance.currentGoal = Float(sender.value)
    }
    
    @IBAction func applyChanges(_ sender: UIButton) {
        // TODO: firebase saving done here
        let dailyGoal = setGoalStepper.value
        // TODO: picker, and notification
        if let currentUser = Auth.auth().currentUser?.email {
            db.collection(K.firebase.settingsCollection).document(currentUser).setData([
                K.firebase.dailyGoalField: dailyGoal,
                K.firebase.currentUserField: currentUser
            ]) { (error) in
                if let e = error {
                    print("Error saving settings, \(e)")
                } else {
                    print("Settings saved successfully")
                }
            }
        }
    }
}


// MARK: - UIPickerView
extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // TODO
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // the number of columns
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return glassManager.glassSizes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return glassManager.glassSizes[row] + "oz"
    }
    
}
