import UIKit

@objc extension UICollectionView {
    public func enableOrDisableVerticalScrollDependingOnContentSize() {
        self.layoutIfNeeded()
        self.isScrollEnabled = self.contentSize.height > self.bounds.size.height
    }
    
    public func enableOrDisableHorizontalScrollDependingOnContentSize() {
        self.layoutIfNeeded()
        self.isScrollEnabled = self.contentSize.width > self.bounds.size.width
    }
    
    public func reloadDataAndEnableOrDisableVerticalScrollDependingOnContentSize() {
        self.reloadData()
        enableOrDisableVerticalScrollDependingOnContentSize()
    }
    
    public func reloadDataAndEnableOrDisableHorizontalScrollDependingOnContentSize() {
        self.reloadData()
        enableOrDisableHorizontalScrollDependingOnContentSize()
    }
}
