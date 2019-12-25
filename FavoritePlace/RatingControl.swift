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
    var rating = 0
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
        
        print ("Button pressed 👏")
        
    }
    
    private func setupButtons() {
        
        for button in buttons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        buttons.removeAll()
                
        for _ in 1 ... starCount {
                 
            let button = UIButton()
            
            button.backgroundColor = .red
            
            button.translatesAutoresizingMaskIntoConstraints = false
             
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            
            button.addTarget(self, action: #selector(ratingButtonTaped(sender:)), for: .touchUpInside)
            
            addArrangedSubview(button)
                        
            buttons.append(button)
            
        }
    }

}
