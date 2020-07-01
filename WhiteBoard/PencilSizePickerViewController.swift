//
//  PencilSizePickerViewController.swift
//  LTW
//
//  Created by Vaayoo USA on 27/11/19.
//  Copyright © 2019 vaayoo. All rights reserved.
//

import UIKit

protocol PenSizePickerViewControllerDelegate: AnyObject {
    
    func toolPickerViewControllerDidPickTheWidthOfLine(width:CGFloat)
    
}
class PencilSizePickerViewController: UIViewController {
    
  let tools: [CGFloat]
  weak var delegate: PenSizePickerViewControllerDelegate?

  init(tools: [CGFloat], delegate: PenSizePickerViewControllerDelegate) {
    self.tools = tools
    self.delegate = delegate
    super.init(nibName: nil, bundle: nil)
    preferredContentSize = CGSize(width: 90, height: tools.count * 50 )
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    let stackView = UIStackView(arrangedSubviews: tools.enumerated().map({ (i, tool) in
      let button = UIButton()
      button.tag = i
      button.translatesAutoresizingMaskIntoConstraints = false
      button.addTarget(self, action: #selector(PencilSizePickerViewController.setWidth(button:)), for: .touchUpInside)
    button.setTitle("\(tool)", for: .normal)
    button.setTitleColor(.blue, for: .normal)

      NSLayoutConstraint.activate([
        button.widthAnchor.constraint(equalToConstant: 90),
        button.heightAnchor.constraint(equalToConstant: 44),
        ])
      return button
    }))

    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.alignment = .fill
    self.view = stackView
  }

  @objc private func setWidth(button: UIButton) {
    delegate?.toolPickerViewControllerDidPickTheWidthOfLine(width: tools[button.tag])
  }
}
