//
//  DesignLabel.swift
//  FigmaConvertXib
//
//  Created by Рустам Мотыгуллин on 25.07.2020.
//  Copyright © 2020 mrusta. All rights reserved.
//

import UIKit

@IBDesignable
class DesignLabel: UILabel {
    
    //MARK: Gradient
    
    @IBInspectable var grColor1: UIColor?
    @IBInspectable var grColor2: UIColor?
    @IBInspectable var grColor3: UIColor?
    @IBInspectable var grColor4: UIColor?
    @IBInspectable var grColor5: UIColor?
    @IBInspectable var grColor6: UIColor?
    
    @IBInspectable var grStartPoint: CGPoint = CGPoint.zero
    @IBInspectable var grEndPoint:   CGPoint = CGPoint.zero
    
    @IBInspectable var grRadial:       Bool = false /// default: linear
    @IBInspectable var grDrawsOptions: Bool = true
    @IBInspectable var grDebug:        Bool = false
    @IBInspectable var grPointPercent: Bool = true
    @IBInspectable var grBlendMode:    Int  = 20    /// заполнители
    
    //MARK: - Shadow
    
    @IBInspectable var shColor:  UIColor = .clear
    @IBInspectable var shRadius: CGFloat = 0.0
    @IBInspectable var shOffset: CGSize  = CGSize.zero
    
    //MARK: Border
    
    @IBInspectable var brColor: UIColor = .clear
    @IBInspectable var brWidth: CGFloat = 0.0
    
     //MARK: - Draw
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        shadow()
        gradient()
        gradientDebug()
        border()
    }
    
    //MARK: - Add Shadow
    
    private func shadow() {
        layer.shadowOpacity    = 1.0
        layer.shadowOffset     = shOffset
        layer.shadowRadius     = shRadius
        layer.shadowColor      = shColor.cgColor
    }
    
    //MARK: - Add Border
    
    func border() {
        
        guard brColor != .clear, brWidth != 0.0 else { return }
        
        let borderLabel = UILabel(frame: bounds)
        borderLabel.text = text
        borderLabel.font = font
        borderLabel.textColor = .clear
        borderLabel.numberOfLines = numberOfLines
        borderLabel.backgroundColor = .clear
        
        
        let strokeTextAttributes: [NSAttributedString.Key : Any] = [
            .strokeColor :       brColor,
            .strokeWidth : -1 * (brWidth * 2),
        ]
        
        borderLabel.attributedText = NSAttributedString(string: text ?? "",
                                                        attributes: strokeTextAttributes)
        
        addSubview(borderLabel)
    }
    
    //MARK: - Add Gradient
    
    func gradient() {
        
        /// ------------------------------------------------------------------
        
        var colors: [CGColor] = []
        
        if grColor1 != nil || grColor2 != nil || grColor3 != nil || grColor4 != nil || grColor5 != nil {
            
            if let color1 = grColor1 { colors.append(color1.cgColor) }
            if let color2 = grColor2 { colors.append(color2.cgColor) }
            if let color3 = grColor3 { colors.append(color3.cgColor) }
            if let color4 = grColor4 { colors.append(color4.cgColor) }
            if let color5 = grColor5 { colors.append(color5.cgColor) }
            if let color6 = grColor6 { colors.append(color6.cgColor) }
            
        } else { return }
        
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: colors as CFArray,
                                        locations: nil) else { return }
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let bMode = CGBlendMode(rawValue: CGBlendMode.RawValue(grBlendMode)) ?? CGBlendMode.sourceAtop
        context.setBlendMode(bMode)

        let options: CGGradientDrawingOptions =
            grDrawsOptions ? [ .drawsBeforeStartLocation, .drawsAfterEndLocation ] : [ ]
        
        
        if grPointPercent {
              grEndPoint = CGPoint(x:   grEndPoint.x * frame.width, y:   grEndPoint.y * frame.height)
            grStartPoint = CGPoint(x: grStartPoint.x * frame.width, y: grStartPoint.y * frame.height)
        }
        
        //MARK: Gr. Radial / Linear
        
        if grRadial {
            
            let x: CGFloat = (grEndPoint.x - grStartPoint.x)
            let y: CGFloat = (grEndPoint.y - grStartPoint.y)
            let distance: CGFloat = sqrt((x * x) + (y * y))
            
            context.drawRadialGradient(gradient,
                                  startCenter: grStartPoint,
                                  startRadius: 0,
                                  endCenter: grStartPoint,
                                  endRadius: distance,
                                  options: options)
        } else {
            
            context.drawLinearGradient(gradient,
                                  start: grStartPoint,
                                  end:   grEndPoint,
                                  options: options)
        }

        context.saveGState()
        
    }

    //MARK: - Gr. Debug
    
    func gradientDebug() {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        guard grDebug else { return }
        
        /// ------------------------------
        let ellipseRadius: CGFloat = 5
        
        context.setBlendMode(CGBlendMode.normal)
        context.setLineWidth(3.0)
        
        
        context.setFillColor(UIColor.black.cgColor)
        
        
        
        /// ------------------------------------------------------------------
        context.setStrokeColor(UIColor.systemRed.cgColor)
        
        let circleRect = CGRect(x: grStartPoint.x - ellipseRadius,
                                y: grStartPoint.y - ellipseRadius,
                                width: ellipseRadius * 2,
                                height: ellipseRadius * 2)
        
        context.fillEllipse(in: circleRect)
        context.strokeEllipse(in: circleRect)
        
        
        /// ------------------------------------------------------------------
        
        context.setStrokeColor(UIColor.green.cgColor)
        
        let circleRect2 = CGRect(x: grEndPoint.x - ellipseRadius,
                                y: grEndPoint.y - ellipseRadius,
                                width: ellipseRadius * 2,
                                height: ellipseRadius * 2)
        
        context.fillEllipse(in: circleRect2)
        context.strokeEllipse(in: circleRect2)
    }
    
}

//MARK: 💩 Gradient Old

extension UILabel {

    func applyGradientWith(startColor: UIColor, endColor: UIColor, startPoint: CGPoint, endPoint: CGPoint) {
        
        var startColorRed: CGFloat = 0
        var startColorGreen: CGFloat = 0
        var startColorBlue: CGFloat = 0
        var startAlpha: CGFloat = 0
        
        if !startColor.getRed(&startColorRed, green: &startColorGreen, blue: &startColorBlue, alpha: &startAlpha) {
            return
        }
        
        var endColorRed: CGFloat = 0
        var endColorGreen: CGFloat = 0
        var endColorBlue: CGFloat = 0
        var endAlpha: CGFloat = 0
        
        if !endColor.getRed(&endColorRed, green: &endColorGreen, blue: &endColorBlue, alpha: &endAlpha) {
            return
        }
        
        let gradientText = self.text ?? ""
        
        
        let attr = [ NSAttributedString.Key.font: self.font ]
        
        let textSize: CGSize = gradientText.size(withAttributes: attr as [NSAttributedString.Key : Any])
        let width: CGFloat = textSize.width
        let height: CGFloat = textSize.height
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return
        }
        
        UIGraphicsPushContext(context)
        
        let glossGradient: CGGradient?
        let rgbColorspace: CGColorSpace?
        let num_locations: size_t = 2
        let locations: [CGFloat] = [ 0.0, 1.0 ]
        let components: [CGFloat] = [startColorRed, startColorGreen, startColorBlue, startAlpha, endColorRed, endColorGreen, endColorBlue, endAlpha]
        rgbColorspace = CGColorSpaceCreateDeviceRGB()
        glossGradient = CGGradient(colorSpace: rgbColorspace!, colorComponents: components, locations: locations, count: num_locations)
        
        context.drawLinearGradient(glossGradient!,
                                   start: CGPoint.zero,
                                   end: CGPoint(x: 0, y: textSize.height),
                                   options: CGGradientDrawingOptions.drawsBeforeStartLocation)
        
        UIGraphicsPopContext()
        
        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return
        }
        
        UIGraphicsEndImageContext()
        self.textColor = UIColor(patternImage: gradientImage)
    }

}
