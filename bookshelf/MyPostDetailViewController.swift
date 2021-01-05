//
//  MyPostDetailViewController.swift
//  bookshelf
//
//  Created by 仲井宏紀 on 2021/01/03.
//  Copyright © 2021 hiroki.nakai. All rights reserved.
//

import UIKit

class MyPostDetailViewController: UIViewController {
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var selectedBookTitle: UILabel!
    @IBOutlet weak var selectedBookCaption: UILabel!
    
    var selectedImage: UIImage!
    var selectedTitle: String?
    var selectedCaption: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        selectedImageView.image = selectedImage
        selectedBookTitle.text = selectedTitle
        selectedBookCaption.text = selectedCaption
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "myRewindSegue") {
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
