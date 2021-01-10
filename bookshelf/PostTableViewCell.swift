//
//  PostTableViewCell.swift
//  bookshelf
//
//  Created by 仲井宏紀 on 2020/12/20.
//  Copyright © 2020 hiroki.nakai. All rights reserved.
//

import UIKit
import FirebaseUI

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
        // PostDataの内容をセルに表示
        func setPostData(_ postData: PostData) {
            // 画像の表示
            postImageView.image = postData.bookimage

            //本のタイトルの表示
            if postData.booktitle != nil {
                self.titleLabel.text = "\(postData.booktitle!)"
            } else {
                self.titleLabel.text = ""
            }
            // キャプションの表示
            self.captionLabel.text = "\(postData.name!)  \(postData.caption!)"
            //著者の表示
            if postData.author != nil {
                     self.authorLabel.text = "\(postData.author!)"
            } else {
                self.authorLabel.text = ""
            }

            // 日時の表示
            self.dateLabel.text = ""
            if let date = postData.date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                let dateString = formatter.string(from: date)
                self.dateLabel.text = dateString
            }

            // いいね数の表示
            let likeNumber = postData.likes.count
            likeLabel.text = "\(likeNumber)"

            // いいねボタンの表示
            if postData.isLiked {
                let buttonImage = UIImage(named: "like_exist")
                self.likeButton.setImage(buttonImage, for: .normal)
            } else {
                let buttonImage = UIImage(named: "like_none")
                self.likeButton.setImage(buttonImage, for: .normal)
            }
        }
}
    

