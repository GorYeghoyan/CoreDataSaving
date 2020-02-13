//
//  ViewController.swift
//  CoreDataExample
//
//  Created by Gor Yeghoyan on 2/13/20.
//  Copyright © 2020 Gor Yeghoyan. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func removeLast(_ sender: UIButton) {
        if people.count != 0 {
            people.removeLast()
        } else {
            return
        }
        print(people)
        self.tableView.reloadData()
    }
    
    
    @IBAction func addName(_ sender: UIBarButtonItem) {
        
        
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
                
            
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        
        let cencelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cencelAction)
        
        present(alert, animated: true)
    }
    
    
    
    
    
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let manageContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: manageContext)!
        let person = NSManagedObject(entity: entity, insertInto: manageContext)
        person.setValue(name, forKey: "name")
        
        do {
            try manageContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    
    var people: [NSManagedObject] = []
    
    
    override func viewDidLoad() {
      super.viewDidLoad()
      
      title = "The List"
      tableView.register(UITableViewCell.self,
                         forCellReuseIdentifier: "Cell")
    }

   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegete = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let manageContext = appDelegete.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            people = try manageContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    

}


extension ViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return people.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath)
                 -> UITableViewCell {

    let person = people[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                    for: indexPath)
                    cell.textLabel?.text = person.value(forKeyPath: "name") as? String
    return cell
  }
}

