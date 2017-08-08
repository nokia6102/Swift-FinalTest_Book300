import UIKit

class ContentViewController: UIViewController
{
    //呈現的頁面內容
    @IBOutlet weak var imgContent: UIImageView!
    //顯示頁碼
    @IBOutlet weak var lblPage: UILabel!
    //記錄目前頁碼（供PageViewController傳遞頁碼使用）
    var currentPage = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //顯示目前頁碼
        lblPage.text = "\(currentPage)"
        
        //準備檔名
        let fileName = String(format: "page%i.jpg", currentPage)
        //顯示圖片
        imgContent.image = UIImage(named: fileName)
    }

    
}
