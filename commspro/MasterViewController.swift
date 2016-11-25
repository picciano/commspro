//
//  MasterViewController.swift
//  commspro
//
//  Created by Anthony Picciano on 11/25/16.
//  Copyright © 2016 Anthony Picciano. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var splashViewController: SplashViewController? = nil
    
    let sections = [ "Management",
                     "Subscribed Channels",
                     "Topical Channels",
                     "Geographic Channels" ]
    
    let management = [ "Account", "Hidden Channels", "About Comms Pro" ]
    var subscribedChannels = [ "Alpha", "Bravo", "Charlie" ]
    var topicalChannels = [ "Delta", "Echo", "Foxtrot" ]
    var geographicChannels = [ "Golf", "Hotel", "India" ]


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        //

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            splashViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? SplashViewController
            splashViewController?.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            splashViewController?.navigationItem.leftItemsSupplementBackButton = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: Any) {
        performSegue(withIdentifier: "showHidden", sender: self)
//        objects.insert(NSDate(), at: 0)
//        let indexPath = IndexPath(row: 0, section: 0)
//        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAccount" {
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                let object = objects[indexPath.row] as! NSDate
//                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
        }
        
        if segue.identifier == "showHidden" {
            
        }
        
        if segue.identifier == "showChannel" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! ChannelViewController
                controller.channel = item(for: indexPath)
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return management.count
        case 1:
            return subscribedChannels.count
        case 2:
            return topicalChannels.count
        case 3:
            return geographicChannels.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = item(for: indexPath)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return indexPath.section == 1
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            objects.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .white
            header.backgroundColor = CommsProStyleKit.commsDarkTan
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                performSegue(withIdentifier: "showAccount", sender: self)
            } else if indexPath.row == 1 {
                performSegue(withIdentifier: "showHidden", sender: self)
            } else {
                performSegue(withIdentifier: "showSplash", sender: self)
            }
        case 1...3:
            performSegue(withIdentifier: "showChannel", sender: self)
        default:
            break
        }
    }
    
    private func item(for indexPath: IndexPath) -> String? {
        var item: String?
        
        switch indexPath.section {
        case 0:
            item = management[indexPath.row]
        case 1:
            item = subscribedChannels[indexPath.row]
        case 2:
            item = topicalChannels[indexPath.row]
        case 3:
            item = geographicChannels[indexPath.row]
        default:
            break
        }
        
        return item
    }

}

