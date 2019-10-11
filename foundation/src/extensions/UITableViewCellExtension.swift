import UIKit

extension UITableViewCell{
    subscript(tag: Int) -> UILabel {
        viewWithTag(tag) as! UILabel
    }
}
