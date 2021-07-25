//
//  Textfield.swift
//  Textfield
//
//  Created by Aybek Can Kaya on 25.07.2021.
//

import Foundation
import Debouncer
import UIKit

// MARK: - Textfield { Skeleton }
open class Textfield: UITextField {
//    private var textFieldDidBeginEditingDebouncer: ((Textfield) -> ())?
//    private var textFieldDidEndEditingDebouncer: ((Textfield) -> ())?
    private var textFieldEditingChangedDebouncer:  Debouncer?
//    private var textFieldShouldChangeCharactersDebouncer: ((Textfield, NSRange, String) -> (Bool))?
    
    private var textFieldDidBeginEditingCallback: ((Textfield) -> ())?
    private var textFieldDidEndEditingCallback: ((Textfield) -> ())?
    private var textFieldEditingChangedCallback:  ((Textfield, String) -> ())?
    private var textFieldShouldChangeCharactersCallback: ((Textfield, NSRange, String) -> (Bool))?
    
    private var dismissWithReturnKey: Bool = false
    private var textInset: CGPoint = .zero
    
    override public init(frame: CGRect) {
        super.init(frame: .zero)
        setUpUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Set Up
extension Textfield {
    private func setUpUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = self
        self.addTarget(self, action: #selector(textFieldEditingChangedFn), for: .editingChanged)
    }
}

// MARK: - Public
extension Textfield {
    @discardableResult
    public func textFieldDidBeginEditing(_ callback: @escaping ((Textfield) -> ()) ) -> Textfield {
        self.textFieldDidBeginEditingCallback = callback
        return self
    }
    
    @discardableResult
    public func textFieldDidEndEditing(_ callback: @escaping ((Textfield) -> ()) ) -> Textfield {
        self.textFieldDidEndEditingCallback = callback
        return self
    }
    
    @discardableResult
    public func textFieldEditingChanged(debounceTimeInterval: TimeInterval = 0, callback: @escaping ((Textfield, String) -> ()) ) -> Textfield {
        self.textFieldEditingChangedCallback = callback
        self.textFieldEditingChangedDebouncer = nil
        if debounceTimeInterval > 0 {
            self.textFieldEditingChangedDebouncer = Debouncer(timeInterval: debounceTimeInterval)
        }
        return self
    }
    
    @discardableResult
    public func textFieldShouldChangeCharacters(_ callback: @escaping ((Textfield, NSRange, String) -> (Bool)) ) -> Textfield {
        self.textFieldShouldChangeCharactersCallback = callback
        return self
    }
    
}

// MARK: - Textfield Delegate
extension Textfield: UITextFieldDelegate {
    @objc private func textFieldEditingChangedFn() {
        guard let closure = textFieldEditingChangedCallback else { return }
        guard let debouncer =  textFieldEditingChangedDebouncer else {
            closure(self, self.text ?? "")
            return
        }
        debouncer.ping()
        debouncer.tick {
            closure(self, self.text ?? "")
        }
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: textInset.x, dy: textInset.y)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: textInset.x, dy: textInset.y)
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let closure = textFieldDidBeginEditingCallback else { return }
        closure(self)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let closure = textFieldDidEndEditingCallback else { return }
        closure(self)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.dismissWithReturnKey { self.resignFirstResponder() }
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let closure = textFieldShouldChangeCharactersCallback else { return true }
        return closure(self, range, string)
    }
}

// MARK: - Declarative UI
extension Textfield {
    public static func textField() -> Textfield {
        let tf = Textfield(frame: .zero)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }
    
    @discardableResult
    public func dismissWhenReturnKeyPressed(_ isDismiss: Bool) -> Textfield {
        self.dismissWithReturnKey = isDismiss
        return self
    }
    
    @discardableResult
    public func textInsets(dx: CGFloat, dy: CGFloat) -> Textfield {
        self.textInset = CGPoint(x: dx, y: dy)
        return self
    }
}

extension UIView {
    public func asDeclarativeTextfield() -> Textfield {
        return self as! Textfield
    }
}

