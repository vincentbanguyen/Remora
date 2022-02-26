import SwiftUI
import UIKit

struct FishTankView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return GameViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //code
    }
}
