//
//  BirthdayAddViewController.swift
//  BirthdayReminder
//
//  Created by Yazgülü Türker on 11.04.2022.
//
import UIKit
import CoreData

class BirthdayAddViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    //DatePicker properties
    let datePicker = UIDatePicker()
    //Date Format
    let formatter =  DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.textAlignment = .center
        dateTextField.textAlignment = .center
        //Gesture-->Hareket
        //Recognizer-->Tanıyıcı
        //Tap--> Dokunma
        //Touch gesture defined to variable
        let gestureRecognizer = UITapGestureRecognizer (target: self, action: #selector(hideKeyboard))
        //run when view is touched
        view.addGestureRecognizer(gestureRecognizer)
        
     
        //DatePicker set mode like date,oclock,stopwatch
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        
        //Appearance of "Datepicker"
          datePicker.frame.size = CGSize(width: 0, height: 300)
        //what the date picker  will look like examples wheels
        datePicker.preferredDatePickerStyle = .wheels
       // Maximum which date can be selected
        datePicker.maximumDate = Date()
        
        //Add DatePicker
        dateTextField.inputView = datePicker
        //We print today's date in "textfield"
        dateTextField.text = formatDate(date: Date())
        }
    
    @objc func hideKeyboard ()
    {
        //Finalizing changes in view
        view.endEditing(true)
    }
    @objc func dateChange (datePicker : UIDatePicker)
    {
        dateTextField.text = formatDate(date: datePicker.date)
        
    }
    func formatDate (date :Date) -> String
    {
       
        formatter.dateFormat = "MMMM dd yyyy"
        
        return formatter.string(from: date )
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        //"UIApplicaiton Delegate" reached
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //Add data Birthday in Core Data
        let newBirthday = NSEntityDescription.insertNewObject(forEntityName: "Birthdays", into:context)
        
        //Attributes
        if nameTextField.text != ""
        {
            newBirthday.setValue(nameTextField.text!, forKey: "name")
            newBirthday.setValue(datePicker.date, forKey: "date")
            newBirthday.setValue(UUID(), forKey: "id")
            
            do
            {
                try context.save()
                print("success")
            }
            catch
            {
                print("error")
            }
            
            // Diğer viewControllerlara mesaj  gönderme olanağı sağlar.
            NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
            //Bir önceki viewcontroller'a geri döner.
            self.navigationController?.popViewController(animated: true)
            
            
        }
        else
        {
            
            let alertMessage = UIAlertController.init(title: "Error", message: "Name can not be empty",preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            
            alertMessage.addAction(okButton)
            
            self.present(alertMessage, animated: true ,completion:nil )
        }
        
        
       
    
        
        
    }
}
