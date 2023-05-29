import UIKit

@objc extension UICollectionView {

    public func enableOrDisableScrollDependingOnContentSize(scrollDirection:ScrollDirection) {
        self.layoutIfNeeded()
        if (scrollDirection == ScrollDirection.horizontal) {
            self.isScrollEnabled = self.contentSize.width > self.bounds.size.width
            return
        }
        self.isScrollEnabled = self.contentSize.height > self.bounds.size.height
    }
    
    public func reloadDataAndEnableOrDisableScrollDependingOnContentSize(scrollDirection:ScrollDirection) {
        self.reloadData()
        enableOrDisableScrollDependingOnContentSize(scrollDirection: scrollDirection)
    }
}
