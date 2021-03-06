//
//  CardoViewController.swift
//  Cardo
//
//  Created by happts on 2019/2/28.
//  Copyright © 2019 happts. All rights reserved.
//

import UIKit

class CardoViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate {
    
    @IBOutlet weak var ResultTextView: UITextView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var BottomToolbar: UIToolbar!
    
    
    @IBOutlet weak var StackView: UIStackView!
    @IBOutlet weak var ShareButton: UIButton!
    @IBOutlet weak var CollectButton: UIButton!
    @IBOutlet weak var DeleteButton: UIButton!
    
    var SubmitBarButtonItem:UIBarButtonItem!
    
    @IBOutlet weak var ActivittyIndicator: UIActivityIndicatorView!
    
    var cardo:Cardo!
    var cardoItem:Int?
    var photoResult = false
    var fromMap = false
    // FIXME : 设计方式不好
    var photo_id:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if !photoResult {
            self.BottomToolbar.removeFromSuperview()
            ShareButton.setImage(UIImage(named: "分享样式"), for: .selected)
            ShareButton.setTitle("已分享", for: .selected)
            ShareButton.setImage(UIImage(named: "未分享样式"), for: .normal)
            ShareButton.setTitle("分享  ", for: .normal)
            
            CollectButton.setImage(UIImage(named: "收藏样式"), for: .selected)
            CollectButton.setTitle("已收藏", for: .selected)
            CollectButton.setImage(UIImage(named: "未收藏样式"), for: .normal)
            CollectButton.setTitle("收藏  ", for: .normal)
            
            
            SubmitBarButtonItem = UIBarButtonItem(title: "提交", style: UIBarButtonItem.Style.done, target: self, action: #selector(SubmitAction))
            self.navigationItem.rightBarButtonItem = SubmitBarButtonItem
            
            if cardo.isShared {
                ShareButton.isSelected = true
            }
            if cardo.isCollected {
                CollectButton.isSelected = true
            }
            
            //
            self.NameLabel.text = cardo.title
            self.ResultTextView.text = cardo.description
            self.ImageView.image = UIImage(data: cardo.imageData ?? Data())
            //
            
            if self.cardo.fileUserId != self.cardo.userId {
                self.ShareButton.isUserInteractionEnabled = false
                self.DeleteButton.isUserInteractionEnabled = false
                self.ResultTextView.isEditable = false
            }
        }else {
            StackView.removeFromSuperview()
        }
        
        if fromMap {
            DeleteButton.isEnabled = false
            self.ResultTextView.isEditable = false
        }
        
        self.ResultTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
    }

    //分享
    @IBAction func shareAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    //收藏
    @IBAction func ShareAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func DeleteAction(_ sender: UIButton) {
        UIAlertUtils.alertControllerDistructive(ViewController: self, message: "确认删除此 Cardo?", deleteHandler: { (_) in
            self.cardo.delete()
            if let item = self.cardoItem ,let secvm = self.cardo.cell?.sectionViewModel {
                secvm.data.removeCardo([item])
                secvm.collectionViewModel?.vc?.collectionView.reloadSections([secvm.sectionIndex])
            }
            self.navigationController?.dismiss(animated: true, completion: nil)
        }, cancelHandler: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.ResultTextView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("start edit")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("end edit")
    }
    
    @objc func keyboardFrameChanged(_ notification:Notification){
        let keyboardRect = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let offsetY = keyboardRect.origin.y - UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.3) {
            self.view.transform = CGAffineTransform(translationX: 0, y: offsetY)
        }
    }
    
    // MARK: photoresult
    @IBAction func CancelAction(_ sender: Any) {
        if photoResult {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func SaveAction(_ sender: Any) {
        if photoResult {
            self.ActivittyIndicator.startAnimating()
            if let id = self.photo_id {
                Request_modifyCardoDescription(photo_id: id, newdescription: self.ResultTextView.text).execute { (result) in
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
            }else {
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func SubmitAction(){
        print("you touched submit")
        UIAlertUtils.alertControllerWithMessageAndChoice(ViewController: self, message: "确认提交修改?") { (_) in
            self.cardo.isCollected = self.CollectButton.isSelected
            self.cardo.isShared = self.ShareButton.isSelected
            self.cardo.description = self.ResultTextView.text
            self.navigationController?.popViewController(animated: true)
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
