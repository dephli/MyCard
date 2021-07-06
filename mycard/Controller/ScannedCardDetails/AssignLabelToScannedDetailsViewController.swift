//
//  AssignLabelToScannedDetailsViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 5/5/21.
//

import UIKit

class AssignLabelToScannedDetailsViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!

    // MARK: - properties
    var viewModel: ReviewScannedCardDetailsViewModel!
    var detailToChange: (name: String, index: Int)?

    // MARK: - viewcontroller methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        if let detailToChange = detailToChange {
            self.detailTitleLabel.text = detailToChange.0
            self.detailLabel.text = viewModel.findDetail(
                name: detailToChange.0, index: detailToChange.1
            )
        } else {
            self.detailTitleLabel.text = "unlabelled"
            self.detailLabel.text = viewModel.findDetail(index: viewModel.currentUnlabelledDetailIndex ?? 0)
        }
    }

    // MARK: - actions
    @IBAction func fullNamePressed(_ sender: UIButton) {
        if let detail = detailToChange {
            viewModel.changeToFullName(name: detail.name, index: detail.index)
        } else {
            viewModel.untagLabelledDetail(name: "full name", index: 0)
            viewModel.setFullName()
        }
        detailToChange = nil
        dismiss(animated: true)

    }

    @IBAction func phoneNumberPressed(_ sender: UIButton) {
        if let detail = detailToChange {
            viewModel.changeToPhoneNumber(name: detail.name, index: detail.index, type: sender.currentTitle!)
        } else {
            viewModel.setPhoneNumber(type: sender.currentTitle!)
        }
        detailToChange = nil
        dismiss(animated: true)
    }

    @IBAction func emailPressed(_ sender: UIButton) {
        if let detail = detailToChange {
            viewModel.changeToEmail(name: detail.name, index: detail.index, type: sender.currentTitle!)
        } else {
            viewModel.setEmail(type: sender.currentTitle!)
        }
        detailToChange = nil
        dismiss(animated: true)
    }

    @IBAction func businessInfoPressed(_ sender: UIButton) {
        if let detail = detailToChange {
            viewModel.changeToBusinessInfo(name: detail.name, index: detail.index, type: sender.currentTitle!)
        } else {
            viewModel.untagLabelledDetail(name: sender.currentTitle!, index: 0)
            viewModel.setBusinessInfo(type: sender.currentTitle!)
        }
        detailToChange = nil
        dismiss(animated: true)
    }

    @IBAction func socialMediaPressed(_ sender: UIButton) {
        if let detail = detailToChange {
            viewModel.changeToSocialMedia(name: detail.name, index: detail.index, type: sender.currentTitle!)
        } else {
            viewModel.untagLabelledDetail(name: sender.currentTitle!, index: 0)
            viewModel.setSocialMedia(type: SocialMediaType.init(rawValue: sender.currentTitle!)!)
        }
        detailToChange = nil
        dismiss(animated: true)
    }

}
