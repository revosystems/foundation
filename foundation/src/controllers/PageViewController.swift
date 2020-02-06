import UIKit

protocol RevoPageViewControllerDelegate {
    func onPageChanged(_ index:Int)
}

class RevoPageViewController : UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var controllers:[UIViewController]! {
        didSet {
            self.dataSource = self
            show(index: 0)
        }
    }
    
    var currentController:UIViewController{
        controllers[currentIndex]
    }
    
    var pageChangedDelegate:RevoPageViewControllerDelegate?{
        didSet {
            self.delegate = self
        }
    }
    
    var currentIndex:Int = 0
    
    func show(index:Int){
        setViewControllers([controllers[index]], direction: index < currentIndex ? .reverse : .forward, animated: true, completion: nil)
        currentIndex = index
        pageChangedDelegate?.onPageChanged(index)
    }
        
    // ============================================
    // MARK: DataSource
    // ===========================================
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        guard let viewControllerIndex = controllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard controllers.count > previousIndex else {
            return nil
        }
        currentIndex = previousIndex
        return controllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        
        guard let viewControllerIndex = controllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let controllersCount = controllers.count

        guard controllersCount != nextIndex else {
            return nil
        }
        
        guard controllersCount > nextIndex else {
            return nil
        }
        
        currentIndex = nextIndex
        return controllers[nextIndex]
    }
    
    // ============================================
    // MARK: Delegate
    // ===========================================
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let controller = pageViewController.viewControllers?[0] else { return }
        guard let index      = controllers.firstIndex(of: controller) else { return }
        pageChangedDelegate?.onPageChanged(index)
    }
}
