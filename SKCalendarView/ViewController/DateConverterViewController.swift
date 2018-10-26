//
//  DateConverterViewController.swift
//  SKCalendarView
//
//  Created by 李彪 on 2018/10/10.
//  Copyright © 2018年 shevchenko. All rights reserved.
//

import UIKit

class DateConverterViewController: UITableViewController {

    @IBOutlet weak var viewRQTS: UIView!
    @IBOutlet weak var viewRQJG: UIView!
    @IBOutlet weak var viewRQHZ: UIView!
    //日期互转变量
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var labelSolarDate: UIButton!
    @IBOutlet weak var labelLunarDate: UIButton!
    @IBOutlet weak var btnCalendarHZ1: UIButton!
    @IBOutlet weak var btnCalendarHZ2: UIButton!
    var dateForHZ = Date()
    var solarDate = Solar()
    var lunarDate = Lunar()
    
    //日期间隔变量
    @IBOutlet weak var labelFirstDate: UIButton!
    @IBOutlet weak var labelSecondDate: UIButton!
    @IBOutlet weak var labelFirstDateResult: UILabel!
    @IBOutlet weak var labelSecondDateResult: UILabel!
    @IBOutlet weak var labelJG: UILabel!
    @IBOutlet weak var viewResultJG: UIView!
    @IBOutlet weak var btnCalendar1: UIButton!
    @IBOutlet weak var btnCalendar2: UIButton!
    @IBOutlet weak var btnQueryJG: UIButton!
    var firstDate = Date()
    var secondDate = Date()
    
    //日期推算变量
    @IBOutlet weak var labelDateTS: UIButton!
    @IBOutlet weak var fieldDayInterval: UITextField!
    @IBOutlet weak var btnForward: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnDateTS: UIButton!
    @IBOutlet weak var btnQueryTS: UIButton!
    @IBOutlet weak var viewResultTS: UIView!
    @IBOutlet weak var labelDayInterval: UILabel!
    @IBOutlet weak var labelSolarDateTS: UILabel!
    @IBOutlet weak var labelLunarDateTS: UILabel!
    var dateForTS = Date()
    
    var datePicker: XXTimerPicker?
    let chineseCalendarConverter = IDJChineseCalendar(yearStart: 1970, end: 2049)
    let greCalendar = Calendar(identifier: .gregorian)
    let chineseCalendar = Calendar(identifier: .chinese)
    var dateComponents = DateComponents()
    var dateFormatter = DateFormatter()
    
    @objc func tableViewTapped(tapGes: UITapGestureRecognizer) {
        if (segControl.selectedSegmentIndex == 2) {
            fieldDayInterval.resignFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //主题
        navigationController?.navigationBar.sakura.titleTextAttributes()("navBarTitleColor")
        navigationController?.navigationBar.sakura.tintColor()("accentColor")
        segControl.sakura.tintColor()("accentColor")
        
        var image = UIImage(named: "calendar")
        image = image?.withRenderingMode(.alwaysTemplate)
        btnDateTS.setImage(image, for: .normal)
        btnDateTS.sakura.tintColor()("accentColor")
        
        btnCalendar1.setImage(image, for: .normal)
        btnCalendar1.sakura.tintColor()("accentColor")
        
        btnCalendar2.setImage(image, for: .normal)
        btnCalendar2.sakura.tintColor()("accentColor")
        
        btnCalendarHZ1.setImage(image, for: .normal)
        btnCalendarHZ1.sakura.tintColor()("accentColor")
        
        btnCalendarHZ2.setImage(image, for: .normal)
        btnCalendarHZ2.sakura.tintColor()("accentColor")
        
        btnForward.sakura.titleColor()("accentColor", .selected)
        btnBack.sakura.titleColor()("accentColor", .selected)
        
        labelDayInterval.sakura.textColor()("accentColor")
        labelSolarDateTS.sakura.textColor()("accentColor")
        labelLunarDateTS.sakura.textColor()("accentColor")
        
        btnQueryJG.sakura.backgroundColor()("accentColor")
        btnQueryTS.sakura.backgroundColor()("accentColor")
        
        labelFirstDateResult.sakura.textColor()("accentColor")
        labelSecondDateResult.sakura.textColor()("accentColor")
        labelJG.sakura.textColor()("accentColor")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped(tapGes:)))
        tableView.addGestureRecognizer(tap)
        
        segControl.selectedSegmentIndex = 0
        switchViews(segControl)
        
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        
        let now = Date()
        let comps = greCalendar.dateComponents([.year, .month, .day], from: now)
        
        labelSolarDate.setTitle(dateFormatter.string(from: now), for: .normal)
        let dateComponents = chineseCalendar.dateComponents([.year, .month, .day], from: now)
        
        let chineseYear = "\(chineseCalendarConverter!.chineseYears[dateComponents.year! - 1])/\(comps.year!)"
        let chineseMonth = "\(chineseCalendarConverter!.chineseMonths[dateComponents.month! - 1])"
        let chineseDay = "\(chineseCalendarConverter!.chineseDays[dateComponents.day! - 1])"
        
        labelLunarDate.setTitle("\(chineseYear) \(chineseMonth) \(chineseDay)", for: .normal)
        
        //日期间隔视图初始化
        firstDate = greCalendar.date(from: comps)!
        secondDate = greCalendar.date(from: comps)!
        labelFirstDate.setTitle(dateFormatter.string(from: firstDate), for: .normal)
        labelSecondDate.setTitle(dateFormatter.string(from: secondDate), for: .normal)
        viewResultJG.isHidden = true
        
        //日期推算视图初始化
        dateForTS = greCalendar.date(from: comps)!
        labelDateTS.setTitle(dateFormatter.string(from: dateForTS), for: .normal)
        btnForward.isSelected = true
        fieldDayInterval.text = "1"
        viewResultTS.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func getDatePicker() -> XXTimerPicker {
        if (datePicker == nil) {
            datePicker = XXTimerPicker.getChooseTimerView()
            datePicker!.main()
            view.window?.addSubview(datePicker!)
        }
        return datePicker!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func solarBtnClicked(_ sender: Any) {
        getDatePicker().isLunar = false
        getDatePicker().isLunarSwitchHidden = true
        getDatePicker().selectedDate = dateForHZ
        getDatePicker().saveBlock = {(year, month, day, yearInt, monthInt, dayInt) in
            print("strings: \(year ?? "-1")-\(month ?? "-1")-\(day ?? "-1")")
            print("numbers: \(yearInt)-\(monthInt)-\(dayInt)")
            self.getDatePicker().isHidden = true
            
            if (self.getDatePicker().isLunar) {
                let lunarDate = Lunar(year: Int32(yearInt), andMonth: Int32(monthInt), andDay: Int32(dayInt))
                let solarDate = CalendarDisplyManager.obtainSolar(from: lunarDate)
                self.dateComponents.setValue(Int(solarDate!.solarYear), for: .year)
                self.dateComponents.setValue(Int(solarDate!.solarMonth), for: .month)
                self.dateComponents.setValue(Int(solarDate!.solarDay), for: .day)
                
                self.lunarDate = Lunar(year: Int32(yearInt), andMonth: Int32(monthInt), andDay: Int32(dayInt))
                self.solarDate = CalendarDisplyManager.obtainSolar(from: self.lunarDate)
            } else {
                self.dateComponents.setValue(yearInt, for: .year)
                self.dateComponents.setValue(monthInt, for: .month)
                self.dateComponents.setValue(dayInt, for: .day)
                
                self.solarDate = Solar(year: Int32(yearInt), andMonth: Int32(monthInt), andDay: Int32(dayInt))
                self.lunarDate = CalendarDisplyManager.obtainLunar(from: self.solarDate)
            }
            
            self.dateForHZ = self.greCalendar.date(from: self.dateComponents)!
            
            self.labelSolarDate.setTitle("\(self.solarDate.solarYear)年\(self.solarDate.solarMonth)月\(self.solarDate.solarDay)日", for: .normal)
            
//            let year = self.chineseCalendar.component(.year, from: self.dateForHZ)
//            let chineseYear = "\(self.chineseCalendarConverter!.chineseYears[year - 1])/\(self.lunarDate.lunarYear)"
//            let chineseMonth = "\(self.chineseCalendarConverter!.chineseMonths[Int(self.lunarDate.lunarMonth) - 1])"
//            let chineseDay = "\(self.chineseCalendarConverter!.chineseDays[Int(self.lunarDate.lunarDay) - 1])"
            
            self.labelLunarDate.setTitle(LunarSolarTransform.format(with: self.lunarDate), for: .normal)
        }
        getDatePicker().isHidden = false
    }
    
    @IBAction func lunarBtnClicked(_ sender: Any) {
        getDatePicker().isLunar = true
        getDatePicker().isLunarSwitchHidden = true
        getDatePicker().selectedDate = dateForHZ
        getDatePicker().saveBlock = {(year, month, day, yearInt, monthInt, dayInt) in
            print("strings: \(year ?? "-1")-\(month ?? "-1")-\(day ?? "-1")")
            print("numbers: \(yearInt)-\(monthInt)-\(dayInt)")
            self.getDatePicker().isHidden = true
            
            if (self.getDatePicker().isLunar) {
                self.lunarDate = Lunar(year: Int32(yearInt), andMonth: Int32(monthInt), andDay: Int32(dayInt))
                self.solarDate = CalendarDisplyManager.obtainSolar(from: self.lunarDate)
            } else {
                self.solarDate = Solar(year: Int32(yearInt), andMonth: Int32(monthInt), andDay: Int32(dayInt))
                self.lunarDate = CalendarDisplyManager.obtainLunar(from: self.solarDate)
            }
            
            var comps = DateComponents()
            comps.setValue(Int(self.solarDate.solarYear), for: .year)
            comps.setValue(Int(self.solarDate.solarMonth), for: .month)
            comps.setValue(Int(self.solarDate.solarDay), for: .day)
            print("lunar to solar: \(comps)")
            
            self.dateForHZ = self.greCalendar.date(from: comps)!
            
            self.labelLunarDate.setTitle(LunarSolarTransform.format(with: self.lunarDate), for: .normal)
            self.labelSolarDate.setTitle("\(self.solarDate.solarYear)年\(self.solarDate.solarMonth)月\(self.solarDate.solarDay)日", for: .normal)
        }
        getDatePicker().isHidden = false
    }
    
    @IBAction func switchViews(_ sender: Any) {
        fieldDayInterval.resignFirstResponder()
        viewRQHZ.isHidden = segControl.selectedSegmentIndex != 0
        viewRQJG.isHidden = segControl.selectedSegmentIndex != 1
        viewRQTS.isHidden = segControl.selectedSegmentIndex != 2
    }
    
    @IBAction func firstDateBtnClicked(_ sender: Any) {
        getDatePicker().isLunar = false
        getDatePicker().isLunarSwitchHidden = false
        getDatePicker().selectedDate = firstDate
        getDatePicker().saveBlock = {(year, month, day, yearInt, monthInt, dayInt) in
            print("strings: \(year ?? "-1")-\(month ?? "-1")-\(day ?? "-1")")
            print("numbers: \(yearInt)-\(monthInt)-\(dayInt)")
            self.getDatePicker().isHidden = true
            
            if (self.getDatePicker().isLunar) {
                let lunarDate = Lunar(year: Int32(yearInt), andMonth: Int32(monthInt), andDay: Int32(dayInt))
                let solarDate = CalendarDisplyManager.obtainSolar(from: lunarDate)
                self.dateComponents.setValue(Int(solarDate!.solarYear), for: .year)
                self.dateComponents.setValue(Int(solarDate!.solarMonth), for: .month)
                self.dateComponents.setValue(Int(solarDate!.solarDay), for: .day)
            } else {
                self.dateComponents.setValue(yearInt, for: .year)
                self.dateComponents.setValue(monthInt, for: .month)
                self.dateComponents.setValue(dayInt, for: .day)
            }
            
            self.firstDate = self.greCalendar.date(from: self.dateComponents)!
            
            self.labelFirstDate.setTitle(self.dateFormatter.string(from: self.firstDate), for: .normal)
        }
        getDatePicker().isHidden = false
    }
    
    @IBAction func secondDateBtnClicked(_ sender: Any) {
        getDatePicker().isLunar = false
        getDatePicker().isLunarSwitchHidden = false
        getDatePicker().selectedDate = secondDate
        getDatePicker().saveBlock = {(year, month, day, yearInt, monthInt, dayInt) in
            print("strings: \(year ?? "-1")-\(month ?? "-1")-\(day ?? "-1")")
            print("numbers: \(yearInt)-\(monthInt)-\(dayInt)")
            self.getDatePicker().isHidden = true
            
            if (self.getDatePicker().isLunar) {
                let lunarDate = Lunar(year: Int32(yearInt), andMonth: Int32(monthInt), andDay: Int32(dayInt))
                let solarDate = CalendarDisplyManager.obtainSolar(from: lunarDate)
                self.dateComponents.setValue(Int(solarDate!.solarYear), for: .year)
                self.dateComponents.setValue(Int(solarDate!.solarMonth), for: .month)
                self.dateComponents.setValue(Int(solarDate!.solarDay), for: .day)
            } else {
                self.dateComponents.setValue(yearInt, for: .year)
                self.dateComponents.setValue(monthInt, for: .month)
                self.dateComponents.setValue(dayInt, for: .day)
            }
            
            self.secondDate = self.greCalendar.date(from: self.dateComponents)!
            
            self.labelSecondDate.setTitle(self.dateFormatter.string(from: self.secondDate), for: .normal)
        }
        getDatePicker().isHidden = false
    }
    
    @IBAction func queryBtnClicked(_ sender: Any) {
        fieldDayInterval.resignFirstResponder()
        if (segControl.selectedSegmentIndex == 1) {
            calcDateSpan()
        } else if (segControl.selectedSegmentIndex == 2) {
            calcFutureDate()
        }
    }
    
    @IBAction func dateBtnClicked(_ sender: Any) {
        fieldDayInterval.resignFirstResponder()
        
        getDatePicker().isLunar = false
        getDatePicker().isLunarSwitchHidden = false
        getDatePicker().selectedDate = dateForTS
        getDatePicker().saveBlock = {(year, month, day, yearInt, monthInt, dayInt) in
            print("strings: \(year ?? "-1")-\(month ?? "-1")-\(day ?? "-1")")
            print("numbers: \(yearInt)-\(monthInt)-\(dayInt)")
            self.getDatePicker().isHidden = true
            
            if (self.getDatePicker().isLunar) {
                let lunarDate = Lunar(year: Int32(yearInt), andMonth: Int32(monthInt), andDay: Int32(dayInt))
                let solarDate = CalendarDisplyManager.obtainSolar(from: lunarDate)
                self.dateComponents.setValue(Int(solarDate!.solarYear), for: .year)
                self.dateComponents.setValue(Int(solarDate!.solarMonth), for: .month)
                self.dateComponents.setValue(Int(solarDate!.solarDay), for: .day)
            } else {
                self.dateComponents.setValue(yearInt, for: .year)
                self.dateComponents.setValue(monthInt, for: .month)
                self.dateComponents.setValue(dayInt, for: .day)
            }
            
            self.dateForTS = self.greCalendar.date(from: self.dateComponents)!
            
            self.labelDateTS.setTitle(self.dateFormatter.string(from: self.dateForTS), for: .normal)
        }
        getDatePicker().isHidden = false
    }
    
    @IBAction func forwardBtnClicked(_ sender: Any) {
        fieldDayInterval.resignFirstResponder()
        btnForward.isSelected = true
        btnBack.isSelected = false
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        fieldDayInterval.resignFirstResponder()
        btnForward.isSelected = false
        btnBack.isSelected = true
    }
    
    @IBAction func fieldValueChanged(_ sender: Any) {
//        if let text = fieldDayInterval.text {
//            if text.isEmpty {
//                fieldDayInterval.text = "1"
//            } else {
//                let i = Int(text)
//                if (i == nil) {
//                    fieldDayInterval.text = "1"
//                }
//            }
//        } else {
//            fieldDayInterval.text = "1"
//        }
    }
    
    func calcDateSpan() {
        viewResultJG.isHidden = false
        
        labelFirstDateResult.text = dateFormatter.string(from: firstDate)
        labelSecondDateResult.text = dateFormatter.string(from: secondDate)
        
        let components = greCalendar.dateComponents([.year, .month, .day], from: firstDate, to: secondDate)
        NSLog("\(components)")
        if (components.year! == 0 && components.month! == 0 && components.day! == 0) {
            labelJG.text = "是同一天"
        } else {
            labelJG.text = "相差\(components.year! == 0 ? "" : "\(components.year!)年")\(components.month! == 0 ? "" : "\(components.month!)月")\(components.day! == 0 ? "" : "\(components.day!)天")"
        }
    }
    
    func calcFutureDate() {
        var valid = true
        if let text = fieldDayInterval.text {
            if text.isEmpty {
                valid = false
            } else {
                let i = Int(text)
                if (i == nil) {
                    valid = false
                }
            }
        } else {
            valid = false
        }

        if !valid {
            let alert = UIAlertController(title: "错误", message: "请输入天数", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "我知道了", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        viewResultTS.isHidden = false
        
        let dayInterval = Int(fieldDayInterval.text!)!
        var comps = DateComponents()
        comps.day = btnForward.isSelected ? -dayInterval : dayInterval
        
        let newDate = greCalendar.date(byAdding: comps, to: dateForTS)
        print("new date: \(newDate!)")
        labelDayInterval.text = btnForward.isSelected ? "\(dayInterval)天前是" : "\(dayInterval)天后是"
        comps = greCalendar.dateComponents([.year, .month, .day], from: newDate!)
        
        let solarDate = Solar(year: Int32(comps.year!), andMonth: Int32(comps.month!), andDay: Int32(comps.day!))
        let lunarDate = CalendarDisplyManager.obtainLunar(from: solarDate)
        
        let chineseYear = chineseCalendar.component(.year, from: newDate!)
        
        labelSolarDateTS.text = dateFormatter.string(from: newDate!)
        labelLunarDateTS.text = "\(chineseCalendarConverter!.chineseYears[chineseYear - 1])/\(lunarDate!.lunarYear) \(chineseCalendarConverter!.chineseMonths[Int(lunarDate!.lunarMonth) - 1]) \(chineseCalendarConverter!.chineseDays[Int(lunarDate!.lunarDay) - 1])"
    }
}
