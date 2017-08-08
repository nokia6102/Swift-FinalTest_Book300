import UIKit

class ContentViewController: UIViewController
{
    //MARK:- 呈現的封面內容
    @IBOutlet weak var imgCover: UIImageView!
  
    @IBOutlet weak var imgType: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblAuthor: UILabel!
    
    @IBOutlet weak var txtArtcle: UITextView!
    //MARK:-
    
    //顯示頁碼
    @IBOutlet weak var lblPage: UILabel!
    //記錄目前頁碼（供PageViewController傳遞頁碼使用）
    var currentPage = 0
    var stitle = ""
    var type = ""
    var author = ""
    var article = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //顯示目前頁碼
        lblPage.text = "\(currentPage)"
        lblTitle.text = stitle
        lblAuthor.text = author
//        txtArtcle.text = article
        //MARK:格式化文字
        let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 10
                paragraphStyle.alignment = .center
        let attributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 20),NSParagraphStyleAttributeName: paragraphStyle] //
        txtArtcle.attributedText = NSAttributedString(string: article , attributes: attributes)
 
        imgType.image = UIImage(named: "\(type).png")
        
        //MARK:檢查是否到封面
        imgCover.isHidden = !(currentPage == 0)

    }

    
}
