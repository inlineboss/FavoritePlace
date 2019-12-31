//
//  RatingControl.swift
//  FavoritePlace
//
//  Created by inlineboss on 25.12.2019.
//  Copyright © 2019 inlineboss. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {

    var buttons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtons()
        }
    }
    @IBInspectable var starSize : CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount : Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
//    MARK: Init
    override init (frame: CGRect) {
        
        super.init(frame: frame)
        setupController()
        
    }
    
    required init (coder: NSCoder) {
        
        super.init(coder: coder)
        setupController()
        
    }
    
    private func setupController() {
        setupButtons()
    }
    
    @objc func ratingButtonTaped(sender: UIButton) {
        
        guard let index = buttons.firstIndex(of: sender) else { return }
        
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
        
    }
    
    private func setupButtons() {
        
        for button in buttons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        buttons.removeAll()
        
        let bundle = Bundle(for: type(of: self))
        
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let highlighStart = UIImage(named: "highlighStart", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        
        
        
        for _ in 1 ... starCount {
                 
            let button = UIButton()
            
            button.setImage(filledStar, for: .selected)
            button.setImage(emptyStar, for: .normal)
            button.setImage(highlighStart, for: .highlighted)
            button.setImage(highlighStart, for: [.selected, .highlighted])
            
            button.translatesAutoresizingMaskIntoConstraints = false
             
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            
            button.addTarget(self, action: #selector(ratingButtonTaped(sender:)), for: .touchUpInside)
            
            addArrangedSubview(button)
                        
            buttons.append(button)
            
        }
        
        updateButtons()
    }
    
    
    private func updateButtons() {
        for (index, button) in buttons.enumerated() {
            button.isSelected = index < rating
        }
    }

}
