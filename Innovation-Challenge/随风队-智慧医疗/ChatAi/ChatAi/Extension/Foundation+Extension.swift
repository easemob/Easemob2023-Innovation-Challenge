//
//  Foundation+Extension.swift
//  News
//
//  Created by 杨蒙 on 2017/12/12.
//  Copyright © 2017年 hrscy. All rights reserved.
//

import UIKit

extension String {
    /// 计算文本的高度
    func textHeight(fontSize: CGFloat, width: CGFloat) -> CGFloat {
        let size = self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [.font: UIFont.systemFont(ofSize: fontSize)], context: nil)
        return ceil(size.height)
    }
    /// 计算文本宽度
    func textWidth(fontSize:CGFloat,height:CGFloat) ->CGFloat{
        let size = self.boundingRect(with:CGSize(width:CGFloat(MAXFLOAT), height:height), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [.font:UIFont.systemFont(ofSize: fontSize)], context:nil)
        return ceil(size.width)
    }
}
extension String {
  public subscript(bounds: CountableRange<Int>) -> String {

    let string = self[index(startIndex, offsetBy: bounds.lowerBound) ..< index(startIndex, offsetBy: bounds.upperBound)]
    return String(string)
  }
  
  public subscript(bounds: CountableClosedRange<Int>) -> String {
    let string = self[index(startIndex, offsetBy: bounds.lowerBound) ... index(startIndex, offsetBy: bounds.upperBound)]
    return String(string)
  }
  
  public subscript(index: Int) -> String {
    let character = self[self.index(startIndex, offsetBy: index)]
    return String(character)
  }
}

extension TimeInterval {
    // 把秒数转换成时间的字符串
    func convertString() -> String {
        // 把获取到的秒数转换成具体的时间
        let createDate = Date(timeIntervalSince1970: self)
        // 获取当前日历
        //        let calender = Calendar.current
        // 获取日期的年份
        //        let comps = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: createDate, to: Date())
        // 日期格式
        let formatter = DateFormatter()
        let weekday = Calendar.current.component(.weekday, from: createDate)
        // 判断当前日期是否为今年
        guard createDate.isThisYear() else {
            //            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.dateFormat = "yyyy-MM-dd"
            return "\(formatter.string(from: createDate)) \(weekday)"
        }
        if createDate.isBeforeYesterday() {
            return "前天 \(weekday)"
        }else if createDate.isYesterday(){
            return "昨天 \(weekday)"
        }  else if createDate.isToday(){
            return "今天 \(weekday)"
        } else {
            formatter.dateFormat = "MM-dd"
            return "\(formatter.string(from: createDate)) \(weekday)"
        }
    }
    func formatTimestamp() -> String {
        let checkDate = Date(timeIntervalSince1970: self)
        let currentDate = Date()
        
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
    
        let weekdayString = getWeekDayByDate(date: checkDate)
        
        if calendar.isDateInToday(checkDate) {
            return "今天" + weekdayString
        } else if calendar.isDateInYesterday(checkDate) {
            return "昨天" + weekdayString
        } else if calendar.isDate(checkDate, equalTo: currentDate, toGranularity: .day) {
            dateFormatter.dateFormat = "MM月dd日"
            return "前天" + weekdayString
        } else {
            dateFormatter.dateFormat = "MM月dd日"
            let shortDateString = dateFormatter.string(from: checkDate)
            
            dateFormatter.dateFormat = "yyyy年MM月dd日"
            let longDateString = dateFormatter.string(from: checkDate)
          
            guard checkDate.isThisYear() else {
                return longDateString + weekdayString
            }
            return shortDateString + weekdayString
        }
    }
    ///  - 返回对应日期是周几
    func getWeekDayByDate(date:Date) -> String{
        guard let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian) else {
            return "星期一"
        }
        let components = calendar.components([.weekOfYear,.weekOfMonth,.weekday,.weekdayOrdinal], from: date)
        let weekday = components.weekday!
        let cnWeekday = [" 星期日", " 星期一", " 星期二", " 星期三", " 星期四", " 星期五", " 星期六"]
        return cnWeekday[weekday-1]
    }
        
}

extension Int {
    
    func convertString() -> String {
        guard self >= 10000 else {
            return String(describing: self)
        }
        return String(format: "%.1f万", Float(self) / 10000.0)
    }
    
    /// 将秒数转成字符串
    func convertVideoDuration() -> String {
        // 格式化时间
        if self == 0 { return "00:00" }
        let hour = self / 3600
        let minute = (self / 60) % 60
        let second = self % 60
        if hour > 0 { return String(format: "%02d:%02d:%02d", hour, minute, second) }
        return String(format: "%02d:%02d", minute, second)
    }
    
}

extension Date {
    
    /// 判断当前日期是否为今年
    func isThisYear() -> Bool {
        // 获取当前日历
        let calender = Calendar.current
        // 获取日期的年份
        let yearComps = calender.component(.year, from: self)
        // 获取现在的年份
        let nowComps = calender.component(.year, from: Date())
        
        return yearComps == nowComps
    }
    
    /// 是否是昨天
    func isYesterday() -> Bool {
        // 获取当前日历
        let calender = Calendar.current
        // 获取日期的年份
        let comps = calender.dateComponents([.year, .month, .day], from: self, to: Date())
        // 根据头条显示时间 ，我觉得可能有问题 如果comps.day == 0 显示相同，如果是 comps.day == 1 显示时间不同
        // 但是 comps.day == 1 才是昨天 comps.day == 2 是前天
//        return comps.year == 0 && comps.month == 0 && comps.day == 1
        return comps.year == 0 && comps.month == 0 && comps.day == 0
    }
    
    /// 是否是前天
    func isBeforeYesterday() -> Bool {
        // 获取当前日历
        let calender = Calendar.current
        // 获取日期的年份
        let comps = calender.dateComponents([.year, .month, .day], from: self, to: Date())
        //
//        return comps.year == 0 && comps.month == 0 && comps.day == 2
        return comps.year == 0 && comps.month == 0 && comps.day == 1
    }
    
    /// 判断是否是今天
    func isToday() -> Bool {
        // 日期格式化
        let formatter = DateFormatter()
        // 设置日期格式
        formatter.dateFormat = "yyyy-MM-dd"
        
        let dateStr = formatter.string(from: self)
        let nowStr = formatter.string(from: Date())
        return dateStr == nowStr
    }
    
}
// MARK:- 一、数组 的基本扩展
extension Array {
    
    // MARK: 1.3、数组 -> JSON字符串
    /// 字典转换为JSONString
    func toJSON() -> String? {
        let array = self
        guard JSONSerialization.isValidJSONObject(array) else {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData = try! JSONSerialization.data(withJSONObject: array, options: []) as NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
    
}

