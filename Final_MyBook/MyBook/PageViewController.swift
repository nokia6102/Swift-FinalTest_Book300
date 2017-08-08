import UIKit

class PageViewController: UIPageViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate
{
    //記錄內容頁面的類別實體
    var contentViewController:ContentViewController!
    //頁碼計數器（每換一頁就加1或減1）
    var pageCounter = 0
    //總頁數（總頁數不包含封面頁，因為封面頁為0）
    var totalPages = 5
    //宣告計時器（自動翻頁用）
    var timer:Timer!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        //指定頁面控制器的代理人
        self.delegate = self
        self.dataSource = self
        //初始化內容頁面
        contentViewController = self.storyboard!.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        //傳遞頁碼到內容頁面
        contentViewController.currentPage = pageCounter
        //讓頁面控制器目前管理的頁面
        self.setViewControllers([contentViewController], direction: .forward, animated: false, completion: nil)
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
            //不是最後一頁，才能往後翻頁
            if self.pageCounter < self.totalPages
            {
                self.pageCounter += 1
            }
            else    //如果是最後一頁，就回到封面頁
            {
                self.pageCounter = 0
            }
            //初始化內容頁面
            self.contentViewController = self.storyboard!.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
            //傳遞下一頁的頁碼
            self.contentViewController.currentPage = self.pageCounter
            //進行翻頁(動畫屬性為true，英文橫式為forward)
            self.setViewControllers([self.contentViewController], direction: .forward, animated: true, completion: nil)
        })

    }
    
    //MARK: UIPageViewControllerDataSource
    //（由使用者執行翻頁動作）往後翻頁
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        //不是最後一頁，才能往後翻頁
        if pageCounter < totalPages
        {
            pageCounter += 1
        }
        else    //如果是最後一頁，就回到封面頁
        {
            pageCounter = 0
        }
        //產生下一頁的頁面
        contentViewController = self.storyboard!.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        //傳遞下一頁的頁碼
        contentViewController.currentPage = pageCounter
        //回傳下一頁的頁面
        return contentViewController
    }
    //（由使用者執行翻頁動作）往前翻頁
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        //不是在封面頁時，才能往前翻頁
        if pageCounter > 0
        {
            pageCounter -= 1
        }
        else    //如果在封面頁，就翻到最後一頁
        {
            pageCounter = totalPages
        }
        //產生上一頁的頁面
        contentViewController = self.storyboard!.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        //傳遞上一頁的頁碼
        contentViewController.currentPage = pageCounter
        //回傳上一頁的頁面
        return contentViewController
    }
    
    //MARK: UIPageViewControllerDelegate
    //更改翻頁的旋轉軸心
    func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation
    {
        return .min //此為預設值，翻轉軸心在左側
    }
    
    
    
    

}
