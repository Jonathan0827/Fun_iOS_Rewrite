//
//  CoreFunctions.swift
//  Fun
//
//  Created by 임준협 on 1/24/24.
//

import Foundation
import SwiftUI
import UIKit


func currentBuildNumber() -> String {
    if let info: [String: Any] = Bundle.main.infoDictionary,
       let buildNumber: String
        = info["CFBundleVersion"] as? String {
        return buildNumber
    }
    return "nil"
}
func currentVersion() -> String {
    if let info: [String: Any] = Bundle.main.infoDictionary,
       let version: String
        = info["CFBundleShortVersionString"] as? String {
        return version
    }
    return "nil"
}
extension View {
    func saveSize(in size: Binding<[CGSize]>) -> some View {
        modifier(SCalc(size: size))
    }
}
extension UIImage {
    func averageColor(_ vtc: inout Array<UInt8>) -> UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        vtc = [bitmap[0], bitmap[1], bitmap[2], bitmap[3]]
        cprint("Got average color, returning...", "averageColor", false)
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
    func averageColorWOVtc() -> UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        
        cprint("Got average color, returning...", "averageColor", false)
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}
extension View {
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        controller.view.backgroundColor = .clear
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        cprint("Converted to UIImage, returning...", "ImageConverter", false)
        return image
    }
}

extension UIView {
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
extension Dictionary {
    func depart() -> [Any] {
        var v = [Any]()
        for (a, b) in self {
            v = [a, b]
        }
        return v
    }
}
extension UIColor {
    public func uc() -> Color {
        return Color(uiColor: self)
    }
}
