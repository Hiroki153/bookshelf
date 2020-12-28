//
//  BookshelfViewController.swift
//  bookshelf
//
//  Created by 仲井宏紀 on 2020/12/07.
//  Copyright © 2020 hiroki.nakai. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class BookshelfViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewCell: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //レイアウトを調整
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        collectionView.collectionViewLayout = layout
    }
    
    // PostDataの内容をセルに表示
    func setCollectioViewData(_ postData: PostData) {
        // 画像の表示
        collectionViewCell.image = postData.bookimage
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let myid = Auth.auth().currentUser?.uid {
                   //自分のidで投稿されている場合のでーたの数を引っ張ってくる
                   }
            
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) //表示するセルを登録
        collectionView.delegate = self
        collectionView.dataSource = self
        cell.backgroundColor = .brown  //セルの色
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) ->CGSize {
        let horizontalSpace : CGFloat = 20
        let cellSize : CGFloat = self.view.bounds.width / 3 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
