//
//  ViewController.swift
//  Instagrid
//
//  Created by fatih tokgoz on 25/10/2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    
    // MARK: - Button Declaration
    @IBOutlet weak var buttonImage1: UIButton!
    @IBOutlet weak var buttonImage2: UIButton!
    @IBOutlet weak var buttonImage3: UIButton!
    @IBOutlet weak var buttonImage4: UIButton!
    
    @IBOutlet weak var layoutButton1: UIButton!
    @IBOutlet weak var layoutButton2: UIButton!
    @IBOutlet weak var layoutButton3: UIButton!
    
    @IBOutlet weak var gridView: UIView!
    
    @IBOutlet var instagridView: UIView!
    var selectedButton : UIButton!
    var doSwipe = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.setDefaultView()
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(swipeGridView))
        instagridView.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    // MARK: - Swipe Management
    
    @objc func swipeGridView(_ sender : UIPanGestureRecognizer){
        switch sender.state{
        case .began, .changed :
            transformInstagridViewWith(gesture: sender)
        case .cancelled, .ended:
            instagridView.transform = CGAffineTransform(translationX: 0, y: 0)
            if doSwipe{
                if getIsLandscape() {
                    gridView.transform = CGAffineTransform(translationX: gridView.bounds.minX, y: (-UIScreen.main.bounds.height - gridView.bounds.height))
                    
                }else{
                    gridView.transform = CGAffineTransform(translationX: (-UIScreen.main.bounds.width - gridView.bounds.width), y: gridView.bounds.minY)
                }
                shareCollage()
            }
        default :
            break
        }
    }
    
    private func transformInstagridViewWith(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: instagridView)
        doSwipe = false
        
        if getIsLandscape() {
            
            if translation.x < 0{
                let translationTransform = CGAffineTransform(translationX: translation.x, y: 0)
                gridView.transform = translationTransform
                if(translation.x < -100){
                    doSwipe = true
                }
            }

        }else{
            if translation.y < 0{
                let translationTransform = CGAffineTransform(translationX: 0, y: translation.y)
                gridView.transform = translationTransform
                if(translation.y < -100){
                    doSwipe = true
                }
            }
        }
    }
    
    // MARK: - Button's Action
    
    @IBAction func didTouchButton1(_ sender: Any) {
        selectedButton = buttonImage1
        selectImageInGallery()
    }
    @IBAction func didTouchButton2(_ sender: Any) {
        selectedButton = buttonImage2
        selectImageInGallery()
    }
    @IBAction func didTouchButton3(_ sender: Any) {
        selectedButton = buttonImage3
        selectImageInGallery()
        
    }
    @IBAction func didTouchButton4(_ sender: Any) {
        selectedButton = buttonImage4
        selectImageInGallery()
    }
    
    @IBAction func didTouchLayoutButton1(_ sender: Any) {
        doLayoutSelection(for: 1)
    }
    @IBAction func didTouchLayoutButton2(_ sender: Any) {
        doLayoutSelection(for: 2)
        
    }
    @IBAction func didTouchLayoutButton3(_ sender: Any) {
        doLayoutSelection(for: 3)
    }
    
    // MARK: - Image Picker Management
    private func selectImageInGallery(){
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageForButton(chooseButton: selectedButton, newImage: pickedImage)
        }

        dismiss(animated: true, completion: nil)
    }
    
    func imageForButton(chooseButton: UIButton, newImage: UIImage) {
        chooseButton.setImage(nil, for: .normal)
        chooseButton.imageView?.contentMode  = .scaleAspectFill
        chooseButton.setImage(newImage, for: .normal)
    }
    
    // MARK: - Methods
    private func doLayoutSelection(for selectedButton : Int){
        
        buttonImage2.isHidden = false
        buttonImage4.isHidden = false
        layoutButton1.imageView?.isHidden = true
        layoutButton2.imageView?.isHidden = true
        layoutButton3.imageView?.isHidden = true
        
        switch selectedButton {
        case 1:
            buttonImage2.isHidden = true
            layoutButton1.imageView?.isHidden = false
        case 2:
            buttonImage4.isHidden = true
            layoutButton2.imageView?.isHidden = false
        case 3:
            layoutButton3.imageView?.isHidden = false
            
        default:
            break
        }
    }
    
    private func shareCollage(){
        UIGraphicsBeginImageContext(gridView.frame.size)
        gridView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        if let image = image {
            let imageToShare : [Any] = [image]
            
            let activityViewController = UIActivityViewController(activityItems: imageToShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion:nil)
            
            activityViewController.completionWithItemsHandler = { activity, success, items, error in
                self.setDefaultView()
            }
        }
    }
    
    private func setDefaultView(){
        gridView.transform = CGAffineTransform(translationX: 0, y: 0)
        doLayoutSelection(for: 2)
        buttonImage1.setImage(UIImage(named: "Plus.png"), for: .normal)
        buttonImage2.setImage(UIImage(named: "Plus.png"), for: .normal)
        buttonImage3.setImage(UIImage(named: "Plus.png"), for: .normal)
        buttonImage4.setImage(UIImage(named: "Plus.png"), for: .normal)
    }
    
    private func getIsLandscape() -> Bool{
        let height = UIScreen.main.bounds.height
        let width = UIScreen.main.bounds.width
        if height > width {
            return false
        }else{
            return true
        }
    }
}

