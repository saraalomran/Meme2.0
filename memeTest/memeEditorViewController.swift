//
//  ViewController.swift
//  memeTest
//
//  Created by Sara Alomran on 06/12/2018.
//  Copyright © 2018 Sara Alomran. All rights reserved.
//

import UIKit

class memeEditorViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate{

// --------------------------------------------------------
    //texts
   
    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var imagePickerView: UIImageView!
//top bar buttons
   
    @IBOutlet weak var sharePickerView: UIBarButtonItem!
    @IBOutlet weak var cancel: UIBarButtonItem!
    
//bottom bar buttons

    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var library: UIBarButtonItem!
    
//top toolbar
    @IBOutlet weak var topToolBar: UIToolbar!
    //bottom toolbar
    @IBOutlet weak var bottomToolBar: UIToolbar!
// --------------------------------------------------------
    var bottomTextEdited = false
    var topTextEdited = false
    
  
// --------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //disable camera button if the device doesnt have camera
    camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        // Disable share button until an meme is created
        subscribeToKeyboardNotifications()

        sharePickerView.isEnabled = imagePickerView.image != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topText.delegate = self
        self.bottomText.delegate = self
        configTextFormat(topText, with: "TOP")
        configTextFormat(bottomText, with: "BOTTOM")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
//textfield attributes
// --------------------------------------------------------
    let textAttributes:[NSAttributedString.Key :Any] = [
        NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeColor.rawValue) : UIColor.black,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue) : UIColor.white,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue) : UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.backgroundColor.rawValue) : UIColor.clear,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeWidth.rawValue) : -5.0
    ]
//configure the attributes
    func configTextFormat(_ textField: UITextField, with defaultText: String) {
        textField.defaultTextAttributes = textAttributes
        textField.textAlignment = NSTextAlignment.center
        textField.text = defaultText
        textField.isHidden = false
    }
    
 // --------------------------------------------------------
    //cancel button action
  
    @IBAction func cancelApp(sender: AnyObject) {
        imagePickerView.image = nil
        topText.text = "TOP"
        topTextEdited = false
        bottomText.text = "BOTTOM"
        bottomTextEdited = false
        sharePickerView.isEnabled = false //disable share button since there will be no picture
        dismiss(animated: false, completion: nil)
    }
    

 // -------------------------------------------------------
    //taking a picture or picking an image:
    
    func pickAnImageFrom(from source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImageFrom(from: .camera)
    }
    
    // Get an album image when the album button is clicked
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImageFrom(from: .photoLibrary)
    }
    
    
    // -------------------------------------------------------
    //share a meme:
   
    @IBAction func shareMeme(_ sender: AnyObject){
        
        
        let generatedImage = generateMemedImage() //a meme with image and text generation
        let activityController = UIActivityViewController(activityItems: [generatedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = {
            (activity, completed, items, error) in if (completed) {
                self.save(memedImage: generatedImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.present(activityController, animated: true, completion: nil)   //display Activity View Controller
    }
    // --------------------------------------------------------
    //remove keybord from screen when returned is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
    }
 // --------------------------------------------------------
    // remove the keyboard when screen is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
  // --------------------------------------------------------
    //get the data of the image that the user picked:
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
        imagePickerView.contentMode = UIView.ContentMode.scaleAspectFit
        imagePickerView.layer.masksToBounds = true
        imagePickerView.image = image
    }
   picker.dismiss(animated: true, completion: nil )
    }
// --------------------------------------------------------
  
    
    func save(memedImage: UIImage?) {
    guard let memedImage = memedImage, let _ = imagePickerView.image else {
    print("image couldnt be saved / No image selected ")
     imageNotSaved()
    return
        }
     let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, image: imagePickerView.image!, memedImage: memedImage)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
// --------------------------------------------------------
    
    func imageNotSaved() {
        let alert = UIAlertController(title: "Select an Image", message: "Meme could not be saved because you did not select an image.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
// --------------------------------------------------------
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomText.isFirstResponder && view.frame.origin.y == 0 {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if bottomText.isFirstResponder && view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue //
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

// --------------------------------------------------------
  
    
// --------------------------------------------------------
  
    func generateMemedImage() -> UIImage {
        
      toolbarsControl(toptoolbar: true, bottomtoolbar: true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    
        toolbarsControl(toptoolbar: false, bottomtoolbar: false)
        
        return memedImage
    }
// --------------------------------------------------------

    func toolbarsControl(toptoolbar: Bool, bottomtoolbar: Bool){
        topToolBar.isHidden = toptoolbar
        bottomToolBar.isHidden = bottomtoolbar
    }
    // --------------------------------------------------------

    
    ///any recreation disposing
   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

