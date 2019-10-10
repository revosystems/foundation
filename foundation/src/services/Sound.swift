import Foundation
import AVFoundation

@objc public class Sound : NSObject {
    
    @objc public class func play(_ filename: String) {
        var player: AVAudioPlayer?
        
        let path = Bundle.main.path(forResource: filename, ofType: "mp3")
        let url = URL(fileURLWithPath: path ?? "")

        do {
           player = try AVAudioPlayer(contentsOf: url)
           player?.play()
        } catch let error {
           print(error.localizedDescription)
        }
    }
}
