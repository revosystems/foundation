import UIKit

extension UITableViewCell{
    public subscript(tag: Int) -> UILabel {
        viewWithTag(tag) as! UILabel
    }
}
