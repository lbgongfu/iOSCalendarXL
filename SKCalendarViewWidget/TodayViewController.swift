//
//  TodayViewController.swift
//  SKCalendarViewWidget
//
//  Created by 李彪 on 2018/9/21.
//  Copyright © 2018年 shevchenko. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    private static let Zodiacs: [String] = ["鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪"]
    private static let HeavenlyStems: [String] = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
    private static let EarthlyBranches: [String] = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
    private static let chineseMonths: [String] = ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "冬月", "腊月"]
    private static let chineseDays: [String] = ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十", "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "廿十", "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"]
    
    private static let jieqi: [String] = ["立春", "雨水", "惊蛰", "春分", "清明", "谷雨", "立夏", "小满", "芒种", "夏至", "小暑", "大暑", "立秋", "处暑", "白露", "秋分", "寒露", "霜降", "立冬", "小雪", "大雪", "冬至", "小寒", "大寒"]
    
    @IBOutlet weak var labelSolarDate: UILabel!
    @IBOutlet weak var labelLunarDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        self.view.addGestureRecognizer(tap)
        updateDate()
    }
    
    static func isJieQi(str: String) -> Bool {
        return jieqi.contains(str)
    }
    
    @objc func tapped(_ ges: UITapGestureRecognizer) {
        let url = URL(string: "SKCalendar://")
        extensionContext?.open(url!, completionHandler: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日 EEEE"
        labelSolarDate.text = formatter.string(from: Date())
        let calendar = Calendar(identifier: .chinese)
        let components = calendar.dateComponents([.month, .day], from: Date())
        let month = components.month!
        let day = components.day!
        labelLunarDate.text = "\(TodayViewController.era(withDate: Date()))年\(TodayViewController.chineseMonths[month - 1])\(TodayViewController.chineseDays[day - 1])"
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        updateDate()
        
        completionHandler(NCUpdateResult.newData)
    }
    
    static func zodiac(withYear year: Int) -> String {
        let zodiacIndex: Int = (year - 1) % Zodiacs.count
        return Zodiacs[zodiacIndex]
    }
    
    static func zodiac(withDate date: Date) -> String {
        let calendar: Calendar = Calendar(identifier: .chinese)
        return zodiac(withYear: calendar.component(.year, from: date))
    }
    
    static func era(withYear year: Int) -> String {
        let heavenlyStemIndex: Int = (year - 1) % HeavenlyStems.count
        let heavenlyStem: String = HeavenlyStems[heavenlyStemIndex]
        let earthlyBrancheIndex: Int = (year - 1) % EarthlyBranches.count
        let earthlyBranche: String = EarthlyBranches[earthlyBrancheIndex]
        return heavenlyStem + earthlyBranche
    }
    
    static func era(withDate date: Date) -> String {
        let calendar: Calendar = Calendar(identifier: .chinese)
        return era(withYear: calendar.component(.year, from: date))
    }
}
