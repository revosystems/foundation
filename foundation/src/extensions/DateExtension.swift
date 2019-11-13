import UIKit

extension Date {
    
    public enum Style : String {
        case datetime               = "yyyy-MM-dd HH:mm:ss"
        case date                   = "yyyy-MM-dd"
        case time                   = "HH:mm:ss"
        case timeWithoutSeconds     = "HH:mm"
        case datetimeWithoutSeconds = "yyyy-MM-dd HH:mm"
    }
    
    static var cachedFormatters: [String: DateFormatter] = [:]
    
    public init?(string:String){
        guard let date = Date.formatter(string.count == 10 ? Style.date : Style.datetime)
            .date(from: string) else { return nil}
        self.init(timeInterval:0, since:date)
    }
    
    public var weekDay: Int {
        let calendar =  Calendar.current;
        var dayOfWeek = calendar.component(.weekday, from: self)
        /*if (calendar.firstWeekday == 1) {
         dayOfWeek -= 1;
         }*/
        if dayOfWeek <= 0 {
            dayOfWeek += 7
        }
        return dayOfWeek;
    }
    
    public func toDeviceTimezone(_ style:Style) -> String {
        return Date.formatter(style, timeZone:NSTimeZone.local).string(from: self)
    }

    public func toString(_ style:Style, timeZone:TimeZone = TimeZone(identifier:"UTC")!) -> String {
        return Date.formatter(style, timeZone:timeZone).string(from: self)
    }
    
    public var toDatetimeWithoutSeconds: String {
        return toString(.datetimeWithoutSeconds)
    }
    
    public var toDatetime: String {
        return toString(.datetime)
    }
    
    public var toDate : String {
        return toString(.date)
    }
    
    public var toTime : String {
        return toString(.time)
    }
    
    public var toTimeWithoutSeconds : String {
        return toString(.timeWithoutSeconds)
    }
    
    public var toDateTimeLocalized : String {
        return DateFormatter.localizedString(from: self, dateStyle: .short, timeStyle: .none)
    }
    
    public var toDeviceTimezone : String {
        return Date.formatter(.datetime, timeZone:NSTimeZone.local).string(from: self)
    }
    
    static public func formatter(_ style:Style, timeZone:TimeZone = TimeZone(identifier:"UTC")!) -> DateFormatter {
        guard let cached = Date.cachedFormatters["\(style)" + timeZone.identifier] else {
            let formatter                = DateFormatter()
            formatter.dateFormat         = style.rawValue
            formatter.timeZone           = timeZone
            Date.cachedFormatters["\(style)" + timeZone.identifier] = formatter
            return formatter
        }
        return cached
    }
    
}
