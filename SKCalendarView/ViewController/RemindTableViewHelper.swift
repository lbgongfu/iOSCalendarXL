//
//  RemindTableViewHelper.swift
//  SKCalendarView
//
//  Created by 李彪 on 2018/9/20.
//  Copyright © 2018年 shevchenko. All rights reserved.
//

import Foundation
import UIKit

class RemindTableViewHelper: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var reminds: [Remind]?
    var controller: UIViewController?
    var indexToDelete = -1
    private var tableView: UITableView?
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView = tableView
        return reminds == nil ? 0 : reminds!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "remindCell") as! RemindCell2;
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        cell.addGestureRecognizer(longPress)
        let remind = reminds![indexPath.row];
        let formater = DateFormatter()
        formater.dateFormat = "HH:mm";
        cell.labelTime.text = formater.string(from: remind.date)
        cell.labelContent.text = remind.content;
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let remind = reminds![indexPath.row]
        controller?.performSegue(withIdentifier: "editRemind", sender: remind)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @objc func longPress(_ ges: UILongPressGestureRecognizer) {
        if ges.state == .began {
            let point = ges.location(in: tableView)
            indexToDelete = (tableView?.indexPathForRow(at: point)?.row)!
            let alertController = UIAlertController(title: "提示", message: "您确定删除提醒吗？", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "点错了", style: .cancel, handler: {(action) in
                
            })
            
            let positiveAction = UIAlertAction(title: "确定", style: .destructive, handler: {(action) in
                if self.indexToDelete < 0 || self.indexToDelete > (self.reminds?.count)! - 1 {
                    return
                }
                let remindToDelete = self.reminds![self.indexToDelete]
                if let notifications = UIApplication.shared.scheduledLocalNotifications {
                    notifications.forEach({(notification) in
                        if let userInfo = notification.userInfo {
                            if let remindFilePath = userInfo["remindFilePath"] as? String {
                                if remindFilePath == remindToDelete.filePath {
                                    UIApplication.shared.cancelLocalNotification(notification)
                                }
                            }
                        }
                    })
                }
                do {
                    try FileManager.default.removeItem(atPath: (remindToDelete.filePath)!)
                } catch let error as NSError {
                    print("delete remind occurred error: \(error)")
                }
                self.reminds?.remove(at: self.indexToDelete)
                RemindDataBase.remove(remind: remindToDelete)
                self.tableView?.reloadData()
            })
            alertController.addAction(cancelAction)
            alertController.addAction(positiveAction)
            self.controller?.present(alertController, animated: true, completion: nil)
        }
    }
}
