//
//  ViewController.swift
//  BirthdayReminder
//
//  Created by Yazgülü Türker on 11.04.2022.
//

import UIKit
import CoreData

class ViewController:UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var nameArray = [String]()
    var idArray   = [UUID]()
    var birthdayArray = [Date]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem (barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        getData()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue:"newData"), object: nil)
    }
    
  @objc func  getData()
    {
        
        //Aynı veriyi geitrmez aynı veriden tek getirir.
        nameArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        birthdayArray.removeAll(keepingCapacity: false)
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Birthdays")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(fetchRequest)
            
            for result in results as! [NSManagedObject] {
                if let name = result.value(forKey: "name") as? String
                {
                    self.nameArray.append(name)
                }
                if let id  = result.value(forKey: "id") as? UUID
                {
                    self.idArray.append(id)
                }
                if let birthday = result.value(forKey: "date") as? Date
                {
                    self.birthdayArray.append(birthday)
                }
                //Yeni data geldiğinde reload eder.
                self.tableView.reloadData()
            }
        }
        catch
        {
            print ("error")
        }
        
    }
    
    @objc func addButtonClicked ()
    {
        performSegue(withIdentifier: "birthdayAddVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return idArray.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = nameArray[indexPath.row]
        cell.detailTextLabel?.text = "Worked"
        return cell
        
    }
    
    
    //Seçili kişiyi sildik.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("Deleted")
        if editingStyle == .delete
        {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Birthdays")
            
            let idString = idArray[indexPath.row].uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@",idString)
            
            fetchRequest.returnsObjectsAsFaults = false
            
            do
            {
                let results = try context.fetch(fetchRequest)
                
                if results.count>0
                {
                    for result in results as! [NSManagedObject]
                    {
                        if let id = result.value(forKey: "id") as? UUID
                        {
                            if id == idArray[indexPath.row]
                            {
                                context.delete(result)
                                self.nameArray.remove(at: indexPath.row)
                                self.idArray.remove(at: indexPath.row)
                                self.birthdayArray.remove(at: indexPath.row)
                                self.tableView.reloadData()
                                
                                do{
                                      try context.save()
                                }
                                
                                catch
                                {
                                    print("error")
                                }
                            }
                        }
                    }
                }
            }
            catch
            {
                print("Error")
            }
        }
        
    }
    
   
  

}

