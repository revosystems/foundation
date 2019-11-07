import Foundation
import AVFoundation

@objc public class Sound : NSObject {

    static var player : AVAudioPlayer?

    @objc public class func play(_ filename: String) {
        guard let path = Bundle.main.path(forResource:filename, ofType:"mp3") else { return }
        let file = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: file)
            player?.prepareToPlay()
            player?.play()
        } catch {
            debugPrint("Can't play sound \(filename): \(error)")
        }
    }
}
