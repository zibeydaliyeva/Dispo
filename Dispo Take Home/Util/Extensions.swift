import UIKit

extension UILabel {
    
    convenience init(fontWeight: UIFont.Weight = .regular,
                     fontSize: CGFloat,
                     numLines: Int = 1,
                     alignment: NSTextAlignment = .left) {
        self.init()
        self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        self.numberOfLines = numLines
        self.textAlignment = alignment
    }
    
}


extension String {
    
    func trim() -> String {
       return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
}

extension UIViewController {

    func errorAlert(with errorMessage: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: "Error!",
                                                message: errorMessage,
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Close", style: .cancel) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }

    func trackError(with message: String) {
        // we can print or save to file all logs
        print(message)
    }
    

}
