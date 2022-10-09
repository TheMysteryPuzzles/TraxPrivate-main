//
//  CouponValidDaysModel.swift
//  Trax
//
//  Created by mac on 26/09/2022.
//


import Foundation

// MARK: - CouponValidDay

struct CouponValidDay: Codable {
    let daysID, couponID, monday, tuesday: String
    let wednesday, thursday, friday, saturday: String
    let sunday: String

    enum CodingKeys: String, CodingKey {
        case daysID = "days_id"
        case couponID = "coupon_id"
        case monday = "Monday"
        case tuesday = "Tuesday"
        case wednesday = "Wednesday"
        case thursday = "Thursday"
        case friday = "Friday"
        case saturday = "Saturday"
        case sunday = "Sunday"
    }
    
    
    func getDayValue(day: String) -> String {
        switch day {
            
        case "Monday": return self.monday
        case "Tuesday": return self.tuesday
        case "Wednesday": return self.wednesday
        case "Thursday": return self.thursday
        case "Friday": return self.friday
        case "Saturday": return self.saturday
        case "Sunday": return self.sunday
            
            
        default: break;
            
        }
        return "0"
    }
    
    
}

typealias CouponValidDays = [CouponValidDay]
