import UIKit

extension UITableView {
    func public scrollToBottom(){
        let numberOfSections = numberOfSections
        if numberOfSections > 0{
            let numberOfRows = numberOfRows(inSection: numberOfSections - 1)
            if numberOfRows > 0 {
                scrollToRow(at: IndexPath(row:numberOfRows - 1, section:numberOfSections - 1), at:.bottom, animated:true)
            }
        }
    }
}
