import UIKit

extension UITableViewCell{
    public subscript(tag: Int) -> UILabel {
        viewWithTag(tag) as! UILabel
    }
    
    public func setText(_ text:String?, at tag:Int){
        if let label = viewWithTag(tag) as? UILabel {
            label.text = text
        } else if let textView = viewWithTag(tag) as? UITextView {
            textView.text = text
        }
    }
}
