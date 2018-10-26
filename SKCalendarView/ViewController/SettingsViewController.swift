//
//  SettingsViewController.swift
//  SKCalendarView
//
//  Created by 李彪 on 2018/9/13.
//  Copyright © 2018年 shevchenko. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let userDefaults = UserDefaults.standard
private let themes : [ThemeObject] = [
    ThemeObject(name: "果橙", themeFileName: "default", color: UIColor(red: 1, green: 0.47, blue: 0, alpha: 1)),
    ThemeObject(name: "胭脂", themeFileName: "yanzhi", color: UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1)),
    ThemeObject(name: "朱砂", themeFileName: "zhusha", color: UIColor(red: 0.9, green: 0.3, blue: 0.2, alpha: 1)),
    ThemeObject(name: "茜红", themeFileName: "xihong", color: UIColor(red: 1, green: 0.4, blue: 0.5, alpha: 1)),
    ThemeObject(name: "酡粉", themeFileName: "tuofen", color: UIColor(red: 1, green: 0.6, blue: 0.8, alpha: 1)),
    ThemeObject(name: "天蓝", themeFileName: "tianlan", color: UIColor(red: 0.4, green: 0.7, blue: 1, alpha: 1)),
    ThemeObject(name: "碧蓝", themeFileName: "bilan", color: UIColor(red: 0.3, green: 0.8, blue: 0.8, alpha: 1)),
    ThemeObject(name: "酞蓝", themeFileName: "tailan", color: UIColor(red: 0.3, green: 0.4, blue: 0.8, alpha: 1)),
    ThemeObject(name: "莓紫", themeFileName: "meizi", color: UIColor(red: 0.5, green: 0.4, blue: 0.8, alpha: 1)),
    ThemeObject(name: "竹青", themeFileName: "zhuqin", color: UIColor(red: 0.1, green: 0.7, blue: 0.4, alpha: 1)),
    ThemeObject(name: "柳青", themeFileName: "liuqin", color: UIColor(red: 0.5, green: 0.8, blue: 0.1, alpha: 1)),
    ThemeObject(name: "墨青", themeFileName: "moqin", color: UIColor(red: 0.3, green: 0.3, blue: 0.4, alpha: 1))
]

class SettingsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
//    @IBOutlet weak var switchViewShark: UISwitch!
    @IBOutlet weak var switchViewPopup: UISwitch!
//    @IBOutlet weak var switchViewStatusBar: UISwitch!
    @IBOutlet weak var collectionViewTheme: UICollectionView!
//    @IBOutlet weak var themeCell: UITableViewCell!
    
    var currentTheme = themes[0]
    var themeCollectionViewHeightConstraint : NSLayoutConstraint?
    var themeCellHeight:CGFloat = 44
    var needUpdateHeight = true
    
    @IBAction func valueChanged(_ sender: Any) {
        if let switchView = sender as? UISwitch {
            if (switchView == switchViewPopup) {
                UserDefaults.standard.set(switchView.isOn, forKey: "popup")
            }
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
        
//        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
//        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        
        let nib = UINib(nibName: "ThemeCollectionViewCell", bundle: nil)
        collectionViewTheme.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        let themeName = userDefaults.string(forKey: "theme") ?? "果橙"
        themes.forEach({(theme) in
            if themeName == theme.name {
                currentTheme = theme
                return
            }
        })
        
        navigationController?.navigationBar.sakura.titleTextAttributes()("navBarTitleColor")
        navigationController?.navigationBar.sakura.tintColor()("accentColor")
        
//        switchViewShark.sakura.onTintColor()("accentColor")
        switchViewPopup.sakura.onTintColor()("accentColor")
//        switchViewStatusBar.sakura.onTintColor()("accentColor")

//        switchViewStatusBar.isOn = UserDefaults.standard.bool(forKey: "statusbar")
        if UserDefaults.standard.object(forKey: "popup") != nil {
            switchViewPopup.isOn = UserDefaults.standard.bool(forKey: "popup")
        } else {
            switchViewPopup.isOn = true
        }
//        switchViewShark.isOn = UserDefaults.standard.bool(forKey: "shark")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        updateThemeCollectionViewHeight()
    }
    
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return CGFloat.leastNormalMagnitude
//    }
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return 44
//        } else {
//            return themeCellHeight
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentTheme = themes[indexPath.row]
        //change theme
        userDefaults.set(currentTheme.name, forKey: "theme")
        collectionView.reloadData()
        TXSakuraManager.shiftSakura(withName: currentTheme.themeFileName, type: .mainBundle)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return themes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let theme = themes[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ThemeCollectionViewCell
        
        cell.backgroundColor = theme.color
        cell.labelThemeName.text = theme.name
        
        if (currentTheme == theme) {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateThemeCollectionViewHeight() {
        if !needUpdateHeight {
            return
        }
        needUpdateHeight = false
        var hCount = 0
        var w = collectionViewTheme.frame.width
        while true {
            if w > 70 {
                hCount += 1
                w = w - 70 - 10
            } else {
                break
            }
        }
        
//        let hCount = Int(collectionViewTheme.frame.width) / 70
        var row = themes.count / hCount
        row = themes.count % hCount == 0 ? row : row + 1
        let height = row == 0 ? 0 : row * 100 + (row - 1) * 10
        if themeCollectionViewHeightConstraint == nil {
            themeCollectionViewHeightConstraint = NSLayoutConstraint(item: collectionViewTheme, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(height))
            
            collectionViewTheme.addConstraint(themeCollectionViewHeightConstraint!)
        } else {
            themeCollectionViewHeightConstraint?.constant = CGFloat(height)
        }
        
        themeCellHeight = CGFloat(height)
//        tableView.reloadData()
    }

}
