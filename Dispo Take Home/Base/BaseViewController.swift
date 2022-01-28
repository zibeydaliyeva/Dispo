import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func errorHandler(_ error: Error) {
        self.trackError(with: error.localizedDescription)
        self.errorAlert(with: error.localizedDescription)
    }
    
}
