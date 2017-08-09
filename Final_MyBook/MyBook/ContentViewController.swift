import UIKit

class ContentViewController: UIViewController
{
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var imgType: UIImageView!
    @IBOutlet weak var txtArticle: UITextView!
    @IBOutlet weak var lblPage: UILabel!
    //記錄目前頁碼（供PageViewController傳遞頁碼使用）
    var currentPage = 0
    //記錄頁面控制器
    var pageViewController:PageViewController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //顯示目前頁碼
        lblPage.text = "\(currentPage)"
        
        if currentPage > 0  //不是封面頁
        {
            lblTitle.text = pageViewController.arrTable[currentPage-1]["title"]
            lblAuthor.text = pageViewController.arrTable[currentPage-1]["author"]
            //製作檔名
            let fileName = pageViewController.arrTable[currentPage-1]["type"]! + ".png"
            imgType.image = UIImage(named: fileName)
            
 
            
            lblPage.text = pageViewController.arrTable[currentPage-1]["page"]
            
            //初始化段落樣式
            let paragraphStyle = NSMutableParagraphStyle()
            //設定段落樣式的行距
            paragraphStyle.lineSpacing = 10
            //設定段落樣式的置中
            paragraphStyle.alignment = .center
            //建立樣式屬性的字典(字型大小、段落樣式)
            let attributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 20),NSParagraphStyleAttributeName: paragraphStyle] //將詩文內容以對應的樣式屬性顯示
            txtArticle.attributedText = NSAttributedString(string: pageViewController.arrTable[currentPage-1]["article"]! , attributes: attributes)
            
        }
        else    //封面頁
        {
            imgCover.image = UIImage(named: "cover.jpg")
            lblTitle.isHidden = true
            lblAuthor.isHidden = true
            txtArticle.isHidden = true
            lblPage.isHidden = true
        }
    }
    
}
