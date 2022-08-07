//
//  FallingCharacterView.swift
//  MatrixFace
//
//  Created by Ibrahim Hassan on 07/08/22.
//

import UIKit

class FallingCharacterView: UIView {
    
    var centerPoint: CGPoint {
        let x = frame.origin.x + frame.size.width / 2
        let y = frame.origin.y + frame.size.height / 2
        
        return CGPoint(x: x, y: y)
    }
    
    init(size: CGFloat, textColor: UIColor) {
        super.init(frame: .zero)
        
        self.frame.size = CGSize(width: size, height: size)
        
        let textLayer = CATextLayer()
        textLayer.bounds = self.bounds
        textLayer.string = String.getRandomCharacter()

        textLayer.font = CTFontCreateWithName("Helvetica-Bold" as CFString, size - 2, nil)
        textLayer.fontSize = size - 2

        textLayer.foregroundColor = textColor.cgColor
        textLayer.isWrapped = true

        textLayer.contentsScale = UIScreen.main.scale
        layer.insertSublayer(textLayer, at: 0)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
