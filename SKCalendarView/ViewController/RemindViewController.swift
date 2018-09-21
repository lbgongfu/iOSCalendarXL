//
//  RemindViewController.swift
//  SKCalendarView
//
//  Created by 李彪 on 2018/8/24.
//  Copyright © 2018年 武汉思古科技有限公司. All rights reserved.
//

import UIKit

class RemindViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RemindCellDelegate, MWPhotoBrowserDelegate {
    
    var photos: [MWPhoto] = []
    
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(photos.count)
    }
    
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        if (index < photos.count) {
            return photos[Int(index)]
        }
        return nil;
    }
    
    @IBOutlet weak var emptyDataView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnNew: UIButton!
    
    let mediaCellSize = 70
    
    var reminds = [Remind]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.sakura.titleTextAttributes()("navBarTitleColor")
        navigationController?.navigationBar.sakura.tintColor()("accentColor")
        automaticallyAdjustsScrollViewInsets = false
        
//        tableView.register(RemindCell.classForCoder(), forCellReuseIdentifier: "remindCell")
        
        let cellNib = UINib(nibName: "RemindCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "remindCell")

        btnNew.layer.cornerRadius = 8
        btnNew.sakura.backgroundColor()("accentColor")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reminds.removeAll()
        reminds.append(contentsOf: RemindViewController.getRemindList())
        
        if reminds.count == 0 {
            emptyDataView.isHidden = false
            tableView.isHidden = true
        } else {
            emptyDataView.isHidden = true
            tableView.isHidden = false
        }
        
        tableView.reloadData()
    }
    
    static func getRemindList() -> [Remind] {
        var reminds = [Remind]()
        var filePaths = [String]()
        let dir = RemindViewController.documentsDirectory()
        do {
            let array = try FileManager.default.contentsOfDirectory(atPath: dir)
            
            for fileName in array {
                var isDir: ObjCBool = true
                
                if !fileName.contains(".plist") {
                    continue
                }
                let fullPath = "\(dir)/\(fileName)"
                
                if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDir) {
                    if !isDir.boolValue {
                        filePaths.append(fullPath)
                    }
                }
            }
        } catch let error as NSError {
            print("get file path error: \(error)")
        }
        
        filePaths.forEach({(path) in
            //声明文件管理器
            let defaultManager = FileManager()
            //通过文件地址判断数据文件是否存在
            if defaultManager.fileExists(atPath: path) {
                //读取文件数据
                let url = URL(fileURLWithPath: path)
                let data = try! Data(contentsOf: url)
                //解码器
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                //通过归档时设置的关键字Checklist还原lists
                let remind = unarchiver.decodeObject(forKey: "remind") as! Remind
                reminds.append(remind)
                //结束解码
                unarchiver.finishDecoding()
            }
        })
        return reminds
    }
    
    //获取沙盒文件夹路径
    static func documentsDirectory()->String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                        .userDomainMask, true)
        let documentsDirectory = paths.first!
        return documentsDirectory
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reminds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "remindCell", for: indexPath) as! RemindCell
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        cell.addGestureRecognizer(longPress)
        cell.selectionStyle = .none
        
        cell.delegate = self
        
        let remind = reminds[indexPath.row]
        cell.medias = remind.medias
        cell.labelRemindContent.text = remind.content
        cell.labelLocation.text = remind.location
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale.current
        dateFormater.dateFormat = "yyyy-MM-dd EEEE"
        cell.labelDate.text = dateFormater.string(from: remind.date)
        dateFormater.dateFormat = "hh:mm"
        cell.labelTime.text = dateFormater.string(from: remind.date)
        
        let calendar = Calendar(identifier: .chinese)
        let day = calendar.component(.day, from: remind.date)
        let dayOfNow = calendar.component(.day, from: Date())
        if day == dayOfNow {
            cell.labelFriendlyTime.text = "今天"
        } else {
            let comp = calendar.dateComponents([.day, .second], from: remind.date, to: Date())
            var days = abs(comp.day!)
            let seconds = abs(comp.second!)
            if seconds > 0 {
                days += 1
            }
            cell.labelFriendlyTime.text = "距今\(days)天"
        }
        return cell
    }
    
    var indexToDelete = -1
    
    @objc func longPress(_ ges: UILongPressGestureRecognizer) {
        if ges.state == .began {
            let point = ges.location(in: tableView)
            indexToDelete = (tableView.indexPathForRow(at: point)?.row)!
            let controller = UIAlertController(title: "提示", message: "您确定删除提醒吗？", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "点错了", style: .cancel, handler: {(action) in
                
            })
            
            let positiveAction = UIAlertAction(title: "确定", style: .destructive, handler: {(action) in
                if self.indexToDelete < 0 || self.indexToDelete > self.reminds.count - 1 {
                    return
                }
                let remindToDelete = self.reminds[self.indexToDelete]
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
                self.reminds.remove(at: self.indexToDelete)
                self.tableView.reloadData()
            })
            controller.addAction(cancelAction)
            controller.addAction(positiveAction)
            present(controller, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        performSegue(withIdentifier: "editRemind", sender: reminds[indexPath.row])
        return indexPath
    }
    
    func imageClicked(index: Int, images: [Media]) {
        photos.removeAll()
        images.forEach({(media) in
            let photo = MWPhoto(url: URL(string: media.filePath))
            photos.append(photo!)
        })
        let browser = MWPhotoBrowser(delegate: self)
        browser?.displayNavArrows = true
        browser?.displayActionButton = false
        browser?.setCurrentPhotoIndex(UInt(index))
        self.navigationController?.pushViewController(browser!, animated: true)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editRemind" {
            let controller = (segue.destination as! UINavigationController).topViewController as! CreateRemindViewController
            controller.remind = sender as? Remind
        }
    }

}
