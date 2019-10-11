import UIKit

extension Date {
    
    public enum Style : String {
        case datetime       = "yyyy-MM-dd HH:mm:ss"
        case date           = "yyyy-MM-dd"
        case time           = "HH:mm:ss"
        case simpleDatetime = "yyyy-MM-dd HH:mm"
    }
    
    static var cachedFormatters: [Style: DateFormatter] = [:]
    
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

    public func toString(_ style:Style) -> String {
        return Date.formatter(style).string(from: self)
    }
    
    public var toSimpleDatetimeString: String {
        return toString(Style.simpleDatetime)
    }
    
    public var toDatetimeString : String {
        return toString(Style.datetime)
    }
    
    public var toDateString : String {
        return toString(Style.date)
    }
    
    public var toTimeString : String {
        return toString(Style.time)
    }
    
    public var toDateTimeLocalized : String {
        return DateFormatter.localizedString(from: self, dateStyle: .short, timeStyle: .none)
    }
    
    static public func formatter(_ style:Style) -> DateFormatter {
        guard let cached = Date.cachedFormatters[style] else {
            let formatter                = DateFormatter()
            formatter.dateFormat         = style.rawValue
            Date.cachedFormatters[style] = formatter
            return formatter
        }
        return cached
    }
}
