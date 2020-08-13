//
//  ColorSelectorView.swift
//  CombineTest
//
//  Created by Zakaria Bounouar on 2020-08-12.
//  Copyright © 2020 Zakaria Bounouar. All rights reserved.
//

import UIKit

protocol ColorSelectorViewDelegate: class {
    func colorSelectorView(_ colorSelectorView: ColorSelectorView, didSelectColor color: UIColor)
}

class ColorSelectorView: UIView {
    
    weak var delegate: ColorSelectorViewDelegate?

    private var color: UIColor = .white {
        didSet {
            self.backgroundColor = color
        }
    }
    
    func configure(withColor color: UIColor, delegate: ColorSelectorViewDelegate?) {
        setColor(to: color)
        setupGestureRecognizer()
        self.delegate = delegate
    }
    
    func setColor(to color: UIColor) {
        self.color = color
    }
    
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        delegate?.colorSelectorView(self, didSelectColor: self.color)
    }

}
