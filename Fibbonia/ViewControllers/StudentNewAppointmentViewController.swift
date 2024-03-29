//
//  StudentNewAppointmentViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 30/Apr/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class StudentNewAppointmentViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var output : [Constants.tutorField] = []
    
    @IBOutlet weak var subjectPicker: UIPickerView!
    @IBOutlet weak var classPicker: UIPickerView!
    
    @IBOutlet weak var findTutorbutton: UIButton!

    private var subjects: [String] = [String]()
    private var classes: [String] = [String]()
    
    var selectedSubject: String = ""
    var selectedClass: String = ""
    
    var data = [Constants.tutorField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.styleFilledButton(findTutorbutton)
        self.hideKeyboardWhenTappedAround() 

        // Do any additional setup after loading the view.
        subjects = Constants.pulledSubjects
        classes = Constants.emptyList
        self.classPicker.delegate = self
        self.classPicker.delegate = self
        self.subjectPicker.delegate = self
        self.subjectPicker.delegate = self
        
        if subjects.count == 0 {
            
            let alertController = UIAlertController(
                title: "Error",
                message: "There appears to be an issue with your internet connection. Please try again later",
                preferredStyle: .alert
            )
            let cancel = UIAlertAction(title: "Okay", style: .cancel, handler: { action in
                // Need to assign to _ because optional binding loses @discardableResult value
                // https://bugs.swift.org/browse/SR-1681
                _ = self.navigationController?.popViewController(animated: true)
            })
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            //print("ret 1")
            return subjects.count
        } else {
            //print("ret 3")
            return classes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            //print("ret 2")
            return subjects[row]
        } else {
            //print("ret 4")
            return classes[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            selectedSubject = subjects[row]
            classes = Constants.pulledClasses[selectedSubject]!
            classPicker.selectRow(0, inComponent: 0, animated: true)
            self.classPicker.reloadAllComponents()
        } else {
            selectedClass = selectedSubject + " " + classes[row]
            print("selected", selectedClass)
        }
        
    }
    
    @IBAction func findPressed(_ sender: Any) {
//        desperate = Constants.classTutors[selectedClass]!
        pickedClass = selectedClass
        
        if pickedClass == "" {
            print("no picked class")
            Utils.createAlert(title: "Class Not Selected", message: "Please select a class first", buttonMsg: "Okay", viewController: self)
            return
        }
        
        
        print("picked", pickedClass)
        var output: [Constants.tutorField] = []
        let db = Firestore.firestore()
                db.collection(pickedClass).getDocuments { (snapshot, error) in
        
                    if error == nil && snapshot != nil {
                        if snapshot!.documents.count > 0 {
    
                        for document in snapshot!.documents {
                            let documentData = document.data()
                            let verified = documentData["verified"] as! Bool
                            if verified == true {
                                let name = documentData["name"] as! String
                                let rating = documentData["rating"] as! Double
                                let price = documentData["price"] as! Int
                                let online = documentData["zoom"] as! String
                                let email = documentData["calEmail"] as! String
                                let time = documentData["prefTime"] as! [String: [Int]]
                                let appointments = documentData["appointments"] as! [[String: Any]]
                                let bio = documentData["bio"] as! String
                                let classes = documentData["classes"] as! [String]
                                let object = Constants.tutorField(name: name, rating: rating, price: price, zoom: online, calEmail: email, prefTime: time, appointments: appointments, bio: bio, classes: classes)
                                
                                print(name, rating, price)
                                output.append(object)
                                
                            } else {
                                continue
                            }
                            
                            
                        }
                            if output.count > 0 {
                                self.performSegue(withIdentifier: "showTutors", sender: output)
                            } else {
                                Utils.createAlert(title: "No Tutors Found", message: "Sorry, there are no available tutors for this class", buttonMsg: "Okay", viewController: self)
                            }
                            
                        } else {
                            //MARK: Need to add ability to alert user when tutor is available
                             Utils.createAlert(title: "No Tutors Found", message: "Sorry, there are no available tutors for this class", buttonMsg: "Okay", viewController: self)
                        }
                }
                
            }
            
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTutors"{
            let destination = segue.destination as! DesperationViewController
            destination.tutors = sender as! [Constants.tutorField]
            destination.subject = selectedSubject
        }
    }
    

}
