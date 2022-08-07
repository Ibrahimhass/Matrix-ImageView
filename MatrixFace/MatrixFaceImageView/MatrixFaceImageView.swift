//
//  MatrixFaceImageView.swift
//  MatrixFace
//
//  Created by Ibrahim Hassan on 07/08/22.
//

import UIKit

public enum RenderingMode {
    case fast
    case detailed
}

public class MatrixFaceImageView: UIImageView {
    public var fontSize: CGFloat = 12
    public var renderingMode = RenderingMode.detailed
    
    private lazy var blackOverlay: UIView = {
        let blackOverlay = UIView()
        blackOverlay.backgroundColor = .black
        blackOverlay.frame = self.frame
        return blackOverlay
    }()
    
    lazy private var displayLink : CADisplayLink = {
        CADisplayLink(target: self, selector: #selector(updateUI))
    }()
    
    private var fallingCharacters: [FallingCharacterView] = []
    private var isPaused = false
    private var luminescence: [[CGFloat]] = []
    private var speedRange = 5 ... 12
    
    public func startMatrixEffect() {
        guard luminescence.isEmpty else {
            return
        }
        
        processImage {
            self.addSubview(self.blackOverlay)
            self.blackOverlay.isHidden = false
            self.spawnFallingCharacter()
            self.setUpDisplayLink()
        }
    }
    
    public func pauseMatrixEffect() {
        isPaused = true
    }
    
    public func stopMatrixEffect() {
        displayLink.remove(from: .main, forMode: .default)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
            self.blackOverlay.isHidden = true
        })
    }
}

// MARK: - Process Image and get luminescence
extension MatrixFaceImageView {
    private func getLuminisenceAt(_ centerPoint: CGPoint) -> Float {
        guard let imageSize = image?.size else {
            return 0.0
        }
        
        let fractionalX = centerPoint.x / frame.size.width
        let fractionalY = centerPoint.y / frame.size.height
                
        let row = Int(imageSize.height * fractionalY)
        let column = Int(imageSize.width * fractionalX)
        
        if row < luminescence[0].count && column < luminescence.count {
            return Float(luminescence[row][column])
        } else {
            return 0.0
        }
    }
    
    // https://www.ralfebert.com/ios/examples/image-processing/uiimage-raw-pixels/
    private func processImage(_ completion: @escaping () -> ()) {
        guard let cgImage = image?.cgImage,
            let data = cgImage.dataProvider?.data,
            let bytes = CFDataGetBytePtr(data) else {
            fatalError("Couldn't access image data")
        }
        
        assert(cgImage.colorSpace?.model == .rgb)

        let bytesPerPixel = cgImage.bitsPerPixel / cgImage.bitsPerComponent
        
        for y in 0 ..< cgImage.height {
            var luminescence1D: [CGFloat] = []
            for x in 0 ..< cgImage.width {
                let offset = (y * cgImage.bytesPerRow) + (x * bytesPerPixel)
                let r = bytes[offset]
                let g = bytes[offset + 1]
                let b = bytes[offset + 2]
                
                // https://stackoverflow.com/a/596243/
                luminescence1D.append((0.2126 * CGFloat(r) + 0.7152 * CGFloat(g) + 0.0722 * CGFloat(b)) / CGFloat(255))
            }
            
            luminescence.append(luminescence1D)
        }

        completion()
    }
}

// MARK: - Display Link and frame updates
extension MatrixFaceImageView {
    private func setUpDisplayLink() {
        displayLink.preferredFrameRateRange = CAFrameRateRange(minimum: 20, maximum: 60)
        displayLink.add(to: .main, forMode: .default)
    }
    
    private func spawnFallingCharacter() {
        let characterRequired = renderingMode == .fast ? 750 : 1000
        
        for i in 0 ..< characterRequired {
            let fc = FallingCharacterView(size: fontSize, textColor: .green)
            self.addSubview(fc)
            
            fc.frame.origin.x = CGFloat((Int(fontSize) * (i)) % Int(frame.size.width))
            fc.frame.origin.y = CGFloat(Int.random(in: 0 ... Int(frame.size.height)))
            
            fc.layer.opacity = 0.0
            
            fallingCharacters.append(fc)
        }
    }
    
    @objc private func updateUI() {
        guard !isPaused else {
            return
        }
        
        for character in fallingCharacters {
            let centerPoint = character.centerPoint
            character.frame.origin.y += CGFloat(Int.random(in: speedRange))
            character.layer.opacity = getLuminisenceAt(centerPoint)
        }
        
        wrapOffScreenCharacter()
    }
    
    private func wrapOffScreenCharacter() {
        for character in fallingCharacters where character.centerPoint.y > frame.size.height {
            character.frame.origin.y = CGFloat(Int.random(in: 0 ... Int(frame.size.height) / 8))
            character.layer.opacity = 0.0
        }
    }
}
