//
//  DetailViewController.swift
//  casumoTestTask
//
//  Created by Oleksii Pelekh on 26.10.2020.
//

import UIKit

class DetailViewController: UIViewController {
//  @IBOutlet weak var detailDescriptionLabel: UILabel!
//  @IBOutlet weak var candyImageView: UIImageView!

  var event: Event? {
    didSet {
      configureView()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    configureView()
  }

  func configureView() {
//    if let event = event,
//      let detailDescriptionLabel = detailDescriptionLabel,
//      let candyImageView = candyImageView {
//      detailDescriptionLabel.text = candy.name
//      candyImageView.image = UIImage(named: candy.name)
//      title = candy.category.rawValue
//    }
  }
}
