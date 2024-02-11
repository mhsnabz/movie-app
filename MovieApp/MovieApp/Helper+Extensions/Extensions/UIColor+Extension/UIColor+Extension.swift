
import Foundation
import UIKit
extension UIColor {
    enum CustomColor: String {
        case dark_black
        case dark_red
        case main_black
        case main_blue
        case main_gray
        case red

        var color: UIColor {
            switch self {
            case .dark_black:
                return UIColor(named: CustomColor.dark_black.rawValue) ?? .white
            case .dark_red:
                return UIColor(named: CustomColor.dark_red.rawValue) ?? .white
            case .main_black:
                return UIColor(named: CustomColor.main_black.rawValue) ?? .white
            case .main_blue:
                return UIColor(named: CustomColor.main_blue.rawValue) ?? .white
            case .main_gray:
                return UIColor(named: CustomColor.main_gray.rawValue) ?? .white
            case .red:
                return UIColor(named: CustomColor.red.rawValue) ?? .white
            }
        }
    }

    static func customColor(_ color: CustomColor) -> UIColor {
        return color.color
    }
}
