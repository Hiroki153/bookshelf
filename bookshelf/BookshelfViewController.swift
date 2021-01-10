//
//  BookshelfViewController.swift
//  bookshelf
//
//  Created by 仲井宏紀 on 2020/12/07.
//  Copyright © 2020 hiroki.nakai. All rights reserved.
//

import UIKit
import Firebase

class BookshelfViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var postArray: [PostData] = []
    var selectedImage : UIImage?
    var booktitle: String?
    var caption: String?
    let myid = Auth.auth().currentUser?.uid

    
    //Firestoreのリスナー
    var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //レイアウトを調整
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        collectionView.collectionViewLayout = layout
        
        //カスタムセルを登録する
       let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
       collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")

        if Auth.auth().currentUser != nil {
            // ログイン済み
            if listener == nil {
                // listener未登録なら、登録してスナップショットを受信する
                let postsRef = Firestore.firestore().collection(Const.PostPath).whereField("id", isEqualTo:"myid").order(by: "date", descending: true).limit(to: 30)
                listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                    if let error = error {
                        print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                        return
                    }
                    // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                    self.postArray = querySnapshot!.documents.map { document in
                        print("DEBUG_PRINT: document取得 \(document.documentID)")
                        let postData = PostData(document: document)
                        return postData
                    }
                    // TableViewの表示を更新する
                    self.collectionView.reloadData()
                }
            }
        } else {
            // ログイン未(またはログアウト済み)
            if listener != nil {
                // listener登録済みなら削除してpostArrayをクリアする
                listener.remove()
                listener = nil
                postArray = []
                collectionView.reloadData()
            }
        }
    }
    

    


    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // セルを取得してデータを設定する
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.setPostData(postArray[indexPath.row])
        cell.backgroundColor = .white  //セルの色
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) ->CGSize {
        let horizontalSpace : CGFloat = 20
        let cellSize : CGFloat = self.view.bounds.width / 3 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // 配列からタップされたインデックスのデータを取り出す
        let selectedPostData = postArray[indexPath.row]
        selectedImage = selectedPostData.bookimage
        booktitle = selectedPostData.booktitle
        caption = selectedPostData.caption

        if selectedImage != nil {
            performSegue(withIdentifier: "itemSegue", sender: collectionView.cellForItem(at: indexPath))
        }
    }
    
    //Segue準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "itemSegue") {
            let myPostDetailViewController: MyPostDetailViewController = segue.destination as! MyPostDetailViewController
            myPostDetailViewController.selectedImage = selectedImage
            myPostDetailViewController.selectedTitle = booktitle
            myPostDetailViewController.selectedCaption = caption
        }
    }
    
    @IBAction func myUnwindAction(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController){
    }
    //
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
