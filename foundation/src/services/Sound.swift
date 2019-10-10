import Foundation
import AVFoundation

@objc class Sound : NSObject {
    
    @objc func play(_ filename: String) {
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
