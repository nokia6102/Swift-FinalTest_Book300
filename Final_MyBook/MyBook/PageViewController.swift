import UIKit

class PageViewController: UIPageViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate
{
    //MARK:- SQLite3 : 準備資料庫連線
    //資料庫連線（從AppDelegate取得）
    var db:OpaquePointer? = nil
    //記錄單一資料行
//    var dicRow = [String:Any?]()
    var dicRow = [String:String]()
    //記錄查詢到的資料表（離線資料集）
//    var arrTable = [[String:Any?]]()
    var arrTable = [[String:String]]()
    //目前資料行的索引值
    var currentRow = 0
    
    
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
        
        //MARK:- SQLite3 : 取得資料庫連線
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate
        {
            db = appDelegate.getDB()
        }
   
        //MARK:  SQLite3 : 準備離線資料集(呼叫讀取資料庫資料的函式)
        getDataFromDB()
        totalPages = arrTable.count
        //MARK:-
        
        //指定頁面控制器的代理人
        self.delegate = self
        self.dataSource = self
        //初始化內容頁面
        contentViewController = self.storyboard!.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        //傳遞頁碼到內容頁面
        contentViewController.currentPage = pageCounter
        //讓頁面控制器目前管理的頁面
        self.setViewControllers([contentViewController], direction: .forward, animated: false, completion: nil)
       
//        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
//            //不是最後一頁，才能往後翻頁
//            if self.pageCounter < self.totalPages
//            {
//                self.pageCounter += 1
//            }
//            else    //如果是最後一頁，就回到封面頁
//            {
//                self.pageCounter = 0
//            }
//            //初始化內容頁面
//            self.contentViewController = self.storyboard!.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
//            //傳遞下一頁的頁碼
//            self.contentViewController.currentPage = self.pageCounter
//            //進行翻頁(動畫屬性為true，英文橫式為forward)
//            self.setViewControllers([self.contentViewController], direction: .forward, animated: true, completion: nil)
//        })

    }
    
    // MARK: SQLite3 : 自定函式
    //讀取資料庫資料
    func getDataFromDB()
    {
        //清除所有的陣列元素
        arrTable.removeAll()        //arrTable = [[String:String]]()
        
        
        //MARK- 加入第一筆是封面資料集
        dicRow = ["page":"0","type":"七言古詩","title":"封面","author":"封面","article":"封面"]
        //將字典加入陣列（離線資料集）
        arrTable.append(dicRow)
        //MARK-
        
        //準備查詢指令
        let sql = "select page,type,title,author,article from poem order by page "
        //將查詢指令轉成c語言的字串
        let cSql = sql.cString(using: .utf8)
        //宣告查詢結果的變數（連線資料集）
        var statement:OpaquePointer? = nil
        //執行查詢指令（-1代表不限定sql指令的長度，最後一個參數為預留參數，目前沒有作用）
        sqlite3_prepare(db, cSql!, -1, &statement, nil)
        //往下讀一筆，如果讀到資料時
        while sqlite3_step(statement) == SQLITE_ROW
        {
            //取得第一個欄位（C語言字串）
            let poem_page = sqlite3_column_text(statement, 0)
            //轉換第一個欄位（swift字串）
            let page = String(cString: poem_page!)
            print("\(page)")
            
            //取得第二個欄位（C語言字串）
            let poem_type = sqlite3_column_text(statement, 1)
            //轉換第二個欄位（swift字串）
            let type = String(cString: poem_type!)
            print("\(type)")
            
            //取得第三個欄位（C語言字串）
            let poem_title = sqlite3_column_text(statement, 2)
            //轉換第三個欄位（swift字串）
            let title = String(cString: poem_title!)
            print("\(title)")
            
            //取得第四個欄位（C語言字串）
            let poem_author = sqlite3_column_text(statement, 3)
            //轉換第四個欄位（swift字串）
            let author = String(cString: poem_author!)
            print("\(author)")
            
            //取得第五個欄位（C語言字串）
            let poem_article = sqlite3_column_text(statement, 4)
            //轉換第五個欄位（swift字串）
            let article = String(cString: poem_article!)
            print("\(article)")
            
            
            //根據查詢到的每一個欄位來準備字典
            dicRow = ["page":page,"type":type,"title":title,"author":author,"article":article]
            //將字典加入陣列（離線資料集）
            arrTable.append(dicRow)
        }
        //關閉連線資料集
        sqlite3_finalize(statement)
        
        print("> 離線資料集陣列：\(arrTable)")
    }
    //MARK:-
    
    
    
    
    //MARK:UIPageViewControllerDataSource
    //（由使用者執行翻頁動作）往後翻頁
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        //不是最後一頁，才能往後翻頁
 
        if pageCounter < totalPages - 1         //一開始的的封面多一張total要減回來
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
        //MARK- 傳唐詩資料
        let dicPage:[String:String] = arrTable[pageCounter]
      
        contentViewController.stitle = dicPage["title"]!
        contentViewController.author = dicPage["author"]!
        contentViewController.article  = dicPage["article"]!
        contentViewController.type = dicPage["type"]!

        //MARK-
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
