//
//  CollectionViewCell.swift
//  bookshelf
//
//  Created by 仲井宏紀 on 2021/01/03.
//  Copyright © 2021 hiroki.nakai. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionImageView: UIImageView!
    
    var postArray: [PostData] = []
    var newArray: [PostData] = []
    var booktitle: String?
    var caption: String?
    var myImage: UIImage!
    let myid = Auth.auth().currentUser?.uid
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //PostDataのデータをフィルタリングする
    func filterPostData(_ postData: PostData) {
        self.newArray = postArray.filter{
            $0.id.contains("myid")
        }
        if case postData.id = myid {
            self.caption = postData.caption
            self.booktitle = postData.booktitle
            self.myImage = postData.bookimage
        }
        collectionImageView.image = self.myImage
    }
    
}

