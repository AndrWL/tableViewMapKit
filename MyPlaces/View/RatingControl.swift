

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    var rating = 0 {
        didSet {
            updateButtonSelectionState()
        }
    }
    
    var buttons: [UIButton] = []
   
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupBttn()
        }
    }
    
    @IBInspectable  var starCount: Int = 5 {
        didSet {
            setupBttn()
        }
    }
    
 
    
   

   
    
    //MARK: Initialization
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBttn()
    }
    
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupBttn()
    }
    //MARK: button Action
    

    @objc func ratingBtnPressed(button: UIButton) {
        
        guard let index = buttons.firstIndex(of: button) else { return  }
       
        // calculate the rating of selected button
        
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
            
        } else {
            rating = selectedRating
        }
        
    }
    //MARK: private methods
    
    private func setupBttn() {
        
        for btn in buttons {
            removeArrangedSubview(btn)
            btn.removeFromSuperview()
        }
        
        buttons.removeAll()
        
        
        let bundel = Bundle(for: type(of: self))
        let filedStar = UIImage(named: "filledStar", in: bundel, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundel, compatibleWith: self.traitCollection)
        let highlitedStar = UIImage(named: "highlightedStar", in: bundel, compatibleWith: self.traitCollection)
        
        
        
        
        
        
        for _ in 0..<starCount {
            
            let button  = UIButton()
          
          
            
            button.setImage(emptyStar, for: .normal)
            button.setImage(filedStar, for: .selected)
            button.setImage(highlitedStar, for: .highlighted)
            button.setImage(highlitedStar, for: [.highlighted, .selected])
           
            
            
            // add constraints
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            
            button.addTarget(self, action: #selector(ratingBtnPressed(button: )), for: .touchUpInside)
            
            
            addArrangedSubview(button)
            
            buttons.append(button)
            updateButtonSelectionState()
        }
        
    
    }
    private func updateButtonSelectionState() {
        
        for (index, button) in buttons.enumerated() {
            button.isSelected = index < rating
        }
    }
   
	
}
