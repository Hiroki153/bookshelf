//
//  PostViewController.swift
//  bookshelf
//
//  Created by 仲井宏紀 on 2020/12/07.
//  Copyright © 2020 hiroki.nakai. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {
    

    var item: ItemJson?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    //投稿ボタンをタップした時に呼ばれるメソッド
    @IBAction func handlePostButton(_ sender: Any) {
            // 画像と投稿データの保存場所を定義する
            let postRef = Firestore.firestore().collection(Const.PostPath).document()
            // HUDで投稿処理中の表示を開始
            SVProgressHUD.show()
            // FireStoreに投稿データを保存する
            let name = Auth.auth().currentUser?.displayName
            let postDic = [
                "name": name!,
                "bookimage": item!.mediumImageUrl!.absoluteString,
                "booktitle": self.item!.title!,
                "caption": self.textField.text!,
                "date": FieldValue.serverTimestamp(),
                ] as [String : Any]
            postRef.setData(postDic)
            // HUDで投稿完了を表示する
            SVProgressHUD.showSuccess(withStatus: "投稿しました")
            // 投稿処理が完了したので先頭画面に戻る
           UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    //キャンセルボタンをタップした時に呼ばれるメソッド
    @IBAction func handleCancelButton(_ sender: Any) {
        //バーコード読み込み画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //APIで取得した画像をImageViewに設定する if let で餡ラップでも可
        imageView.image = UIImage(url: item!.mediumImageUrl!)
        //本のタイトルをセットする
        textField.text = item!.title
        
        // Do any additional setup after loading the view.
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

extension UIImage {
    public convenience init(url: URL) {
        do{
            let data = try Data(contentsOf: url)
            self.init(data: data)!
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}
