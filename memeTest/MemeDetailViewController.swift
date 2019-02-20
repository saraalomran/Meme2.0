
import UIKit
import Foundation
class MemeDetailViewController: UIViewController {
    
    
    var selectedMeme: Meme!
    

    @IBOutlet weak var imagePickerView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerView.image = selectedMeme.memedImage
    }
    
    
}
