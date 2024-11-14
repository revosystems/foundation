import UIKit

public func SBController<T>(_ storyBoard:String, _ identifier:String) -> T{
    let sb = UIStoryboard(name: storyBoard, bundle: nil)
    return sb.instantiateViewController(withIdentifier: identifier) as! T
}

public func topVc() -> UIViewController?{
    guard var topVc = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController else { return nil }
    
    while (topVc.presentedViewController != nil) {
        topVc = topVc.presentedViewController!
    }
    
    return topVc
}

public func topVcAsync() async -> UIViewController?{
    await MainActor.run {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              var topVc = windowScene.windows.first?.rootViewController else {
            return nil
        }
        while (topVc.presentedViewController != nil) {
            topVc = topVc.presentedViewController!
        }
        return topVc
    }
}

public func isIpad() -> Bool{
    UIDevice().userInterfaceIdiom == .pad
}

public func runAfter(_ seconds:Double, block:@escaping() -> Void){
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
         block()
     }
}

@discardableResult
public func tap<T>(_ value:T, _ block:(_ value:T) -> Void) -> T{
    block(value)
    return value
}

func retry<T>(tries:Int = 1, delayMs:UInt32 = 0, block:() throws -> T) throws -> T {
    do {
        return try block()
    } catch {
        guard tries > 0 else {
            throw error
        }
        usleep(delayMs)
        return try retry(tries: tries - 1, delayMs:delayMs, block: block)
    }
}

func retry(tries:Int = 1, delayMs:UInt32 = 0, block:() -> Bool) {
    guard tries >= 0 else {
        return
    }
    guard block() else {
        usleep(delayMs)
        return retry(tries: tries - 1, delayMs: delayMs, block: block)
    }
}

// Retry with completion
func retry(tries:Int = 1, delayMs:UInt32 = 0, block:@escaping(_ succeeded:@escaping(_ succeeded:Bool)->Void) -> Void) {
    guard tries >= 0 else { return }
    
    block { succeeded in
        if succeeded { return }
        usleep(delayMs)
        return retry(tries: tries - 1, delayMs: delayMs, block: block)
    }
}

public enum RetryError: Error, CustomStringConvertible {
    case maximumRetriesReached(error:String?)

    public var description: String {
        switch self {
            case .maximumRetriesReached(let error): return error ?? "Max retries reached"
        }
    }
}

public func retry(tries:Int = 1, delayMs:UInt32 = 0, _ operation: @escaping () async throws -> Void,_ currentError : String? = nil) async throws {
    guard tries >= 0 else {
        throw RetryError.maximumRetriesReached(error: currentError)
    }
    do {
        try await operation()
    } catch {
        usleep(delayMs)
        try await retry(tries:tries - 1, delayMs: delayMs, operation, "\(error)")
    }
}

