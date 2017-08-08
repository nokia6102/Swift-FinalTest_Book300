import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //MARK:- SQLite AppDelegate中全區宣告
    //宣告資料庫連線變數
    private var db:OpaquePointer? = nil
    //回傳資料庫連線給其他類別
    func getDB() -> OpaquePointer?
    {
        return db
    }
    //MARK:-
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    //MARK:- SQLite didFinishLaunchingWithOptions段宣告
        //取得檔案管理員
        let fileManager = FileManager.default
        //取得資料庫來源路徑
        let sourceDB = Bundle.main.path(forResource: "literature", ofType: "db")
        //取得資料庫的目的地路徑
        let destinationDB = NSHomeDirectory() + "/Documents/MyDB.db"
        print("目的地路徑：\(destinationDB)")
        //檢查目的地的資料庫是否已經存在
        if !fileManager.fileExists(atPath: destinationDB)   //如果不存在
        {
            if let _ = try? fileManager.copyItem(atPath: sourceDB!, toPath: destinationDB)
            {
                print("資料庫檔案已成功複製！")
            }
        }
        //呼叫Sqlite函式庫，開啟目的地資料庫
        if sqlite3_open(destinationDB, &db) == SQLITE_OK
        {
            print("資料庫開啟成功！")
        }
        else
        {
            print("資料庫開啟失敗！")
            db = nil
        }
    //MARK:-
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

