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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminds == nil ? 0 : reminds!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "remindCell") as! RemindCell2;
        let remind = reminds![indexPath.row];
        let formater = DateFormatter()
        formater.dateFormat = "hh:mm";
        cell.labelTime.text = formater.string(from: remind.date)
        cell.labelContent.text = remind.content;
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let remind = reminds![indexPath.row]
        controller?.performSegue(withIdentifier: "showRemindDetail", sender: remind)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
