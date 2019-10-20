//
//  DateUtils.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/20.
//  Copyright © 2019 NemesissLin. All rights reserved.
//
import UIKit

let DateStringDefaultFormat = "yyyy-M-d"

func Unix2Date(_ timeInteval : Int) -> Date {
    let nsTimeInterval = TimeInterval(timeInteval)
    let date = Date(timeIntervalSince1970: nsTimeInterval)
    return date
}


func Date2Unix(_ date: Date) -> Int {
    return Int(date.timeIntervalSince1970)
}


func Date2String(_ date : Date, _ format : String = DateStringDefaultFormat) -> String {
    
    let fmt = DateFormatter()
    fmt.dateFormat = format
    return fmt.string(from: date)
}

func String2Date(_ dateString : String,_ format : String = DateStringDefaultFormat) -> Date {
    let fmt = DateFormatter()
    fmt.dateFormat = format
    return fmt.date(from: dateString)!
}


public extension Date {
    public func ToString(_ format : String = "yyyy-M-d") -> String {
        return Date2String(self, format)
    }
    
    public func ToUnix() -> Int {
        return Date2Unix(self)
    }
}
