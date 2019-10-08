//
//  MVDCardViewController.swift
//  DockOfCardsOBJ-CwSwift
//
//  Created by Michael Di Cesare on 10/8/19.
//  Copyright © 2019 Michael Di Cesare. All rights reserved.
//

import UIKit

class MVDCardViewController: UIViewController {
    @IBOutlet weak var cardSuitLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var drawCardButton: UIButton!
   
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawCard()
        designDrawCardButton()
    }
    
    @IBAction func cardDrawButtonTapped(_ sender: Any) {
        drawCard()
    }
    

    
    func drawCard() {
        MVDCardController.shared()?.drawNewCard(1) { (cards) in
            if let card = cards?[0] {
                DispatchQueue.main.async {
                    self.cardSuitLabel.text = card.suit
                }
                
                MVDCardController.shared()?.fetchImage(from: card) { (image) in
                    guard let image = image else {return}
                    DispatchQueue.main.async {
                        self.cardImageView.image = image
                        
                        
                    }
                }
            }
        }
    }
    func designDrawCardButton() {
        drawCardButton.layer.borderWidth = 1
        drawCardButton.layer.borderColor = UIColor.black.cgColor
        drawCardButton.layer.cornerRadius = drawCardButton.frame.height / 2
        drawCardButton.setTitle("Draw Card", for: .normal)
        drawCardButton.backgroundColor = .white
        drawCardButton.setTitleColor(.black, for: .normal)
    }
}


    
    

