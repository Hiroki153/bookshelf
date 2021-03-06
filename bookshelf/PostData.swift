//
//  PostData.swift
//  bookshelf
//
//  Created by 仲井宏紀 on 2020/12/20.
//  Copyright © 2020 hiroki.nakai. All rights reserved.
//

import UIKit
import Firebase

class PostData: NSObject {
    var id: String
    var name: String?
    var booktitle: String?
    var author: String?
    var bookimage: UIImage!
    var caption: String?
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false

    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID

        let postDic = document.data()

        self.name = postDic["name"] as? String

        self.caption = postDic["caption"] as? String
        
        self.booktitle = postDic["booktitle"] as? String
        
        if let author = postDic["author"] as? String {
                self.author = author
        }
        
        if let urlString = postDic["bookimage"] as? String, let url = URL(string: urlString){
            self.bookimage = UIImage(url: url)
        }

        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()

        if let likes = postDic["likes"] as? [String] {
            self.likes = likes
        }
        if let myid = Auth.auth().currentUser?.uid {
            // likesの配列の中にmyidが含まれているかチェックすることで、自分がいいねを押しているかを判断
            if self.likes.firstIndex(of: myid) != nil {
                // myidがあれば、いいねを押していると認識する。
                self.isLiked = true
            }
        }
    }

}
