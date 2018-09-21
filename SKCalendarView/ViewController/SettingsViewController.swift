//
//  SettingsViewController.swift
//  SKCalendarView
//
//  Created by 李彪 on 2018/9/13.
//  Copyright © 2018年 shevchenko. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
//    @IBOutlet weak var switchViewShark: UISwitch!
    @IBOutlet weak var switchViewPopup: UISwitch!
//    @IBOutlet weak var switchViewStatusBar: UISwitch!
    
    @IBAction func valueChanged(_ sender: Any) {
        if let switchView = sender as? UISwitch {
            UserDefaults.standard.set(switchView.isOn, forKey: "popup")
//            if switchView == switchViewShark {
//                UserDefaults.standard.set(switchView.isOn, forKey: "shark")
//            } else if switchView == switchViewPopup {
//                UserDefaults.standard.set(switchView.isOn, forKey: "popup")
//            } else if switchView == switchViewStatusBar {
//                UserDefaults.standard.set(switchView.isOn, forKey: "statusbar")
//            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 0.01))
        tableView.tableHeaderView = header
        
        navigationController?.navigationBar.sakura.titleTextAttributes()("navBarTitleColor")
        navigationController?.navigationBar.sakura.tintColor()("accentColor")
        
//        switchViewShark.sakura.onTintColor()("accentColor")
        switchViewPopup.sakura.onTintColor()("accentColor")
//        switchViewStatusBar.sakura.onTintColor()("accentColor")

//        switchViewStatusBar.isOn = UserDefaults.standard.bool(forKey: "statusbar")
        switchViewPopup.isOn = UserDefaults.standard.bool(forKey: "popup")
//        switchViewShark.isOn = UserDefaults.standard.bool(forKey: "shark")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
