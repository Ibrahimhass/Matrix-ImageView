//
//  ViewController.swift
//  MatrixFace
//
//  Created by Ibrahim Hassan on 07/08/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var matrixFaceImageView: MatrixFaceImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        matrixFaceImageView.startEffect()
    }
}

