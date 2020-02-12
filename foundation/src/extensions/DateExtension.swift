import UIKit

extension Date {
    
    public enum Style : String {
        case datetime               = "yyyy-MM-dd HH:mm:ss" //2019-08-12 15:24:15
        case date                   = "yyyy-MM-dd"          //2019-15-25
        case time                   = "HH:mm:ss"            //15:24:40
        case timeWithoutSeconds     = "HH:mm"               //15:24
        case datetimeWithoutSeconds = "yyyy-MM-dd HH:mm"    //2019-08-12 15:24
        case niceDate               = "E, MMM d"            //"Wed, Nov 20
    }
    
    static var cachedFormatters: [String: DateFormatter] = [:]
    
    public init?(string:String, timeZone:TimeZone = TimeZone(identifier:"UTC")!){
        guard let date = Date.formatter(string.count == 10 ? Style.date : Style.datetime, timeZone: timeZone)
            .date(from: string) else { return nil }
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
    
    public var minute:Int{
        return Calendar.current.component(.minute, from: self)
    }
    
    public var hour:Int{
        return Calendar.current.component(.hour, from: self)
    }
    
    public var second:Int{
        return Calendar.current.component(.second, from: self)
    }
        
    public var month:Int{
        return Calendar.current.component(.month, from: self)
    }
    
    public var year:Int{
        return Calendar.current.component(.year, from: self)
    }
    
    //MARK: Formatting
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
    
    //MARK: Manipulating
    /**
    Returns a Date with the specified amount of components added to the one it is called with
    */
    public func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        let components = DateComponents(year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds)
        return Calendar.current.date(byAdding: components, to: self)
    }

    /**
    Returns a Date with the specified amount of components subtracted from the one it is called with
    */
    public func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        return add(years: -years, months: -months, days: -days, hours: -hours, minutes: -minutes, seconds: -seconds)
    }
    
    /**
     Returns the Date rounded to the next half, so 9:32 becomes 10:00, 9:15 => 9:30
     */
    public func roundToHalf() -> Date {
        let minute = self.minute
        if self.minute == 0 || minute == 30 {
            return self.floorSeconds()
        }
        if self.minute < 30 {
            return self.add(minutes:30 - minute, seconds:-second)!.floorSeconds()
        }
        return self.add(minutes:60 - minute)!.floorSeconds()
    }
    
    /**
     Returns the date rounded to the floor second, so 12:35:34 => 12:35:00
     */
    public func floorSeconds() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        return calendar.date(from: components)!
    }
    
    //MARK:Comparision (Using device timezone)
    public func sameDayAs(_ other:Date) -> Bool{
        return self.toDeviceTimezone(.date) == other.toDeviceTimezone(.date)
    }
    
    public func isToday() -> Bool {
        return self.toDeviceTimezone(.date) == Date().toDeviceTimezone(.date)
    }
    
    public func isTomorrow() -> Bool {
        return self.toDeviceTimezone(.date) == Date().add(days: 1)?.toDeviceTimezone(.date)
    }
    
    public func isYesterday() -> Bool {
        return self.toDeviceTimezone(.date) == Date().subtract(days: -1)?.toDeviceTimezone(.date)
    }
    
}
