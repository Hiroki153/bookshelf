//
//  CodeReaderViewController.swift
//  bookshelf
//
//  Created by 仲井宏紀 on 2020/12/07.
//  Copyright © 2020 hiroki.nakai. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class CodeReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureDevice:AVCaptureDevice?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var captureSession:AVCaptureSession?
    var isbn:[Int] = []
    //本の情報一式を「タプル」としてまとめ、「配列」に格納
    var bookList : [(title:String?, image:URL)] = []
    
    //JSONのitem内のデータ構造
    struct ItemJson: Codable {
        //本のタイトル
        let title: String?
        //画像URL
        let image: URL?
    }
    
    //JSONのデータ構造
    struct ResultJson: Codable {
        //複数要素
        let item:[ItemJson]?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cameraButtonAction(_ sender: Any) {
        navigationItem.title = "Scanner"
        view.backgroundColor = .white

        captureDevice = AVCaptureDevice.default(for: .video)
        // Check if captureDevice returns a value and unwrap it
        if let captureDevice = captureDevice {

            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)

                captureSession = AVCaptureSession()
                guard let captureSession = captureSession else { return }
                captureSession.addInput(input)

                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession.addOutput(captureMetadataOutput)

                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: .main)
                captureMetadataOutput.metadataObjectTypes = [.code128, .qr, .ean13,  .ean8, .code39] //AVMetadataObject.ObjectType

                captureSession.startRunning()

                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer?.videoGravity = .resizeAspectFill
                videoPreviewLayer?.frame = view.layer.bounds
                view.layer.addSublayer(videoPreviewLayer!)

            } catch {
                print("Error Device Input")
            }

        }
        
        
        view.addSubview(codeLabel)
        codeLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        codeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        codeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        codeLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

    }
    
    //キャンセルボタンをタップした時に呼ばれるメソッド
    @IBAction func cancelButtonAction(_ sender: Any) {
    //先頭画面に戻る
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
       }
    
    let codeLabel:UILabel = {
        let codeLabel = UILabel()
        codeLabel.backgroundColor = .white
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        return codeLabel
    }()

    let codeFrame:UIView = {
        let codeFrame = UIView()
        codeFrame.layer.borderColor = UIColor.green.cgColor
        codeFrame.layer.borderWidth = 2
        codeFrame.frame = CGRect.zero
        codeFrame.translatesAutoresizingMaskIntoConstraints = false
        return codeFrame
    }()

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        captureSession?.stopRunning()
        guard let objects = metadataObjects as? [AVMetadataObject] else { return }
        var detectionString: String? = nil
        let barcodeTypes = [AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.ean13]
        for metadataObject in objects {
            loop: for type in barcodeTypes {
                guard metadataObject.type == type else { continue }
                guard self.videoPreviewLayer?.transformedMetadataObject(for: metadataObject) is AVMetadataMachineReadableCodeObject else { continue }
                if let object = metadataObject as? AVMetadataMachineReadableCodeObject {
                    detectionString = object.stringValue
                    break loop
                }
            }
            var text = ""
            guard let value = detectionString else { continue }
            text += "読み込んだ値:\t\(value)"
            text += "\n"
            guard let isbn = convartISBN(value: value) else { continue }
            text += "ISBN:\t\(isbn)"
            print("text \(text)")

        }



    }
    
        private func convartISBN(value: String) -> String? {
            let v = NSString(string: value).longLongValue
            let prefix: Int64 = Int64(v / 10000000000)
            guard prefix == 978 || prefix == 979 else { return nil }
            let isbn9: Int64 = (v % 10000000000) / 10
            var sum: Int64 = 0
            var tmpISBN = isbn9
            /*
             for var i = 10; i > 0 && tmpISBN > 0; i -= 1 {
             let divisor: Int64 = Int64(pow(10, Double(i - 2)))
             sum += (tmpISBN / divisor) * Int64(i)
             tmpISBN %= divisor
             }
             */

            var i = 10
            while i > 0 && tmpISBN > 0 {
                let divisor: Int64 = Int64(pow(10, Double(i - 2)))
                sum += (tmpISBN / divisor) * Int64(i)
                tmpISBN %= divisor
                i -= 1
            }

            let checkdigit = 11 - (sum % 11)
            return String(format: "%lld%@", isbn9, (checkdigit == 10) ? "X" : String(format: "%lld", checkdigit % 11))
        }

    
    
    //第一引数　isbnコード
    func searchBookTitle(){
        
        var isbn = self.isbn
         //本のisbnコードをURLエンコードする
        guard let isbn_encode = isbn.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else{
            return
        }
        
        //リクエストURLの組み立て
        guard let req_url = URL(string:
            "https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?isbn=\(isbn_encode)&sort=+releaseDate") else {
                return
        }
        
    print(req_url)
        
    //リクエストに必要な情報を生成
    let req = URLRequest(url: req_url)
    //データ転送を管理するためのセッションを生成
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    //リクエストをタスクとして登録
        let task = session.dataTask(with: req, completionHandler: {
            (data, response, error) in
            //セッションを終了
            session.finishTasksAndInvalidate()
            // do try catch エラーハンドリング
            do {
                //JSONDecoderのインスタンス取得
                let decoder = JSONDecoder()
                //受け取ったJSONデータをパース（解析）して格納
                let json = try decoder.decode(ResultJson.self, from: data!)
                
                //本の情報が取得できているか確認
                if let items = json.item {
                    //取得している本の数だけ処理
                    for item in items {
                        //本のタイトル、画像URLをアンラップ
                        if let name = item.title, let image = item.image {
                            //1つの本をタプルでまとめて管理
                            let book = (self.title,image)
                            //本の配列へ追加
                            self.bookList.append(book)
                        }
                    }
                    if let bookdbg = self.bookList.first {
                        print ("-----------------")
                        print ("bookList[0 = \(bookdbg)]")
                    }
                }
            } catch {
                //エラー処理
                print("エラーが出ました")
            }
        })
        //ダウンロード開始
        task.resume()
    }
    
    //JSONのデータを使えるデータに変換
    
    
    //APIからデータを取ってきた後にpostViewControllerにモーダル遷移し、データの受け渡しをするメソッドが必要
    //その際にデータを変換するメソッドが必要
        
    func imageSettingController(_picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.originalImage] != nil {
            //JSONで取得された画像・本のタイトルを代入する
            let image = info[.originalImage] as! UIImage
            let title = self.title!
            
            //投稿画面を開く
            let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
            postViewController.image = image
            postViewController.booktitle = title
            present(postViewController, animated: true, completion: nil)
        }
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
