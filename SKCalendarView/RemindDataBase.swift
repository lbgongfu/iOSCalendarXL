//
//  RemindDataBase.swift
//  SKCalendarView
//
//  Created by 李彪 on 2018/10/10.
//  Copyright © 2018年 shevchenko. All rights reserved.
//

import Foundation

class RemindDataBase: NSObject {
    static private var reminds = [Remind]()
    static var initialized = false
    
    static func initDataBase() {
        if initialized {
            return
        }
        reminds.append(contentsOf: RemindViewController.getRemindList())
        initialized = true
    }
    
    static func list() -> [Remind] {
        return reminds
    }
    
    static func add(remind: Remind) {
        reminds.append(remind)
    }
    
    static func remove(remind: Remind) {
        if let index = reminds.index(of: remind) {
            reminds.remove(at: index)
        }
    }
    
    static func hasRemind(year: Int, month: Int, day: Int) -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        for remind in reminds {
            let components2 = calendar.dateComponents([.year, .month, .day, .weekday], from: remind.date)
            let year1 = components2.year!
            let month1 = components2.month!
            let day1 = components2.day!
            let weekday1 = components2.weekday!
            switch (remind.repeatType) {
            case .Norepeat:
                if (year == year1 && month == month1 && day == day1) {
                    return true
                }
            case .RepeatPerDay:
                if (year > year1) {
                    return true
                }
                if (year == year1) {
                    if (month > month1) {
                        return true
                    }
                    if (month == month1 && day >= day1) {
                        return true
                    }
                }
                break
            case .RepeatPerWeek:
                var component = DateComponents()
                component.setValue(year, for: .year)
                component.setValue(month, for: .month)
                component.setValue(day, for: .day)
                let date = calendar.date(from: component)
                let weekday = calendar.component(.weekday, from: date!)
                if (weekday == weekday1) {
                    if (year > year1) {
                        return true
                    }
                    if (year == year1) {
                        if (month > month1) {
                            return true
                        }
                        if (month == month1 && day >= day1) {
                            return true
                        }
                    }
                }
                break
            case .RepeatPerMonth:
                if (day == day1) {
                    if (year > year1) {
                        return true
                    }
                    if (year == year1 && month >= month1) {
                        return true
                    }
                }
                break
            case .RepeatPerYear:
                if (month == month1 && day == day1) {
                    if (year >= year1) {
                        return true
                    }
                }
                break
            }
        }
        return false
    }
}
