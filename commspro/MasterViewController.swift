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
                     "Subscribed Channels" ]
    
    let management = [ "Manage Account", "Hidden Channels", "About Comms Pro" ]
    var subscribedChannels: [Channel]?
    var groups = [Group]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        
        //
        
        Group.get() { groups in
            self.groups = groups
            self.tableView.reloadData()
        }
        
        loadSubscribedChannels()

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            splashViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? SplashViewController
            splashViewController?.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            splashViewController?.navigationItem.leftItemsSupplementBackButton = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(accountDidChangeHandler), name: UserDidLogIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(accountDidChangeHandler), name: UserDidLogOut, object: nil)
    }
    
    func accountDidChangeHandler(notification: Notification) {
        loadSubscribedChannels()
        tableView.reloadData()
    }
    
    fileprivate func loadSubscribedChannels() {
        subscribedChannels = nil
        
        UserChannel.get { userChannels in
            self.subscribedChannels = userChannels.map { $0.channel }
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
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
                controller.channel = channel(for: indexPath)
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count + groups.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return management.count
        case 1:
            return subscribedChannels?.count ?? 0
        default:
            return groups[section - 2].channels.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = titleString(for: indexPath)
        cell.accessoryView = nil
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let currentUser: BackendlessUser? = Backendless.sharedInstance().userService.currentUser
            if let currentUser = currentUser {
                let accountlabel = UILabel()
                accountlabel.text = currentUser.name as String?
                accountlabel.sizeToFit()
                cell.accessoryView = accountlabel
            }
        }
        
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
        var title: String?
        
        switch section {
        case 0...1:
            title = sections[section]
        default:
            title = groups[section - 2].name
        }
        
        return title
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
        default:
            performSegue(withIdentifier: "showChannel", sender: self)
        }
    }
    
    private func titleString(for indexPath: IndexPath) -> String? {
        var item: String?
        
        switch indexPath.section {
        case 0:
            item = management[indexPath.row]
        case 1:
            item = subscribedChannels?[indexPath.row].name
        default:
            item = channel(for: indexPath)?.name
        }
        
        return item
    }
    
    private func channel(for indexPath: IndexPath) -> Channel? {
        var item: Channel?
        
        switch indexPath.section {
        case 0:
            break
        case 1:
            item = subscribedChannels?[indexPath.row]
        default:
            let group = groups[indexPath.section - 2]
            item = group.sortedChannels[indexPath.row]
        }
        
        return item
    }

}

