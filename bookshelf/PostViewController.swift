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
    

    var item: ItemInfo?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var authorLabel: UILabel!
    
    //投稿ボタンをタップした時に呼ばれるメソッド
    @IBAction func handlePostButton(_ sender: Any) {
        
            // HUDで投稿処理中の表示を開始
            SVProgressHUD.show(withStatus:"投稿中")
            // 画像と投稿データの保存場所を定義する
            let postRef = Firestore.firestore().collection(Const.PostPath).document()
            
            // FireStoreに投稿データを保存する
            let name = Auth.auth().currentUser?.displayName
            let postDic = [
                "name": name!,
                "bookimage": item!.largeImageUrl!.absoluteString,
                "booktitle": item!.title!,
                "author": item!.author!,
                "caption": self.textView.text!,
                "userid": Auth.auth().currentUser!.uid,
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
        //先頭の画面に戻る
        UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SVProgressHUD.dismiss()
        //APIで取得した画像をImageViewに設定する if let でアンラップでも可
        imageView.image = UIImage(url: item!.largeImageUrl!)
        //本のタイトルをセットする
        textField.text = item!.title!
        textField.tintColor = UIColor.black
        //著者名をセットする
        authorLabel.text = item!.author!
        authorLabel.tintColor = UIColor.black
        //textViewの枠のカラー
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1.0
        textView.backgroundColor = UIColor.white
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }

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
