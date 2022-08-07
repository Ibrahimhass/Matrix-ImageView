//
//  String+RandomElement.swift
//  MatrixFace
//
//  Created by Ibrahim Hassan on 07/08/22.
//

extension String {
    // https://stackoverflow.com/a/71204016/
    static func getRandomCharacter() -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789乙 〇丁七九了二人入八刀力十又乃万丈三上下丸久亡凡刃千口土士夕大女子寸小山川 工己干弓才之巾乞于也々勺"
        
        return "\(base.randomElement() ?? Character(""))"
    }
}
