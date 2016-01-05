import UIKit
import Artsy_UILabels
import Artsy_UIButtons

class YourBiddingDetailsViewController: UIViewController {

    var provider: Networking!
    @IBOutlet dynamic var bidderNumberLabel: UILabel!
    @IBOutlet dynamic var pinNumberLabel: UILabel!

    @IBOutlet weak var confirmationImageView: UIImageView!
    @IBOutlet weak var subtitleLabel: ARSerifLabel!
    @IBOutlet weak var bodyLabel: ARSerifLabel!
    @IBOutlet weak var notificationLabel: ARSerifLabel!

    var confirmationImage: UIImage?

    lazy var bidDetails: BidDetails! = { (self.navigationController as! FulfillmentNavigationController).bidDetails }()

    override func viewDidLoad() {
        super.viewDidLoad()

        [notificationLabel, bidderNumberLabel, pinNumberLabel].forEach { $0.makeTransparent() }
        notificationLabel.setLineHeight(5)
        bodyLabel.setLineHeight(10)

        if let image = confirmationImage {
            confirmationImageView.image = image
        }

        bodyLabel?.makeSubstringsBold(["Bidder Number", "PIN"])

        bidDetails
            .paddleNumber
            .asObservable()
            .filterNil()
            .bindTo(bidderNumberLabel.rx_text)
            .addDisposableTo(rx_disposeBag)

        bidDetails
            .bidderPIN
            .asObservable()
            .filterNil()
            .bindTo(pinNumberLabel.rx_text)
            .addDisposableTo(rx_disposeBag)
    }

    @IBAction func confirmButtonTapped(sender: AnyObject) {
        fulfillmentContainer()?.closeFulfillmentModal()
    }

    class func instantiateFromStoryboard(storyboard: UIStoryboard) -> YourBiddingDetailsViewController {
        return storyboard.viewControllerWithID(.YourBidderDetails) as! YourBiddingDetailsViewController
    }
}
