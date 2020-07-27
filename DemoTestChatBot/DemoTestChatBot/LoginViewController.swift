//
//  LoginViewController.swift
//  DemoTestChatBot
//
//  Created by Apple on 23/07/20.
//  Copyright © 2020 ixm. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    private let loginViewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var txtfld_userName: UITextField!
    @IBOutlet weak var txtfld_password: UITextField!
    @IBOutlet weak var btn_Login: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initalzeSignInWidgets()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLoginAction(_ sender: UIButton) {
       // performSegue(withIdentifier: "ViewController", sender: nil)
        UIView.animate(withDuration: 0.7,
        animations: {
            self.btn_Login.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        },
        completion: { _ in
            UIView.animate(withDuration: 0.6) {
                self.btn_Login.transform = CGAffineTransform.identity
                let OTPVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardViewController") as? DashboardViewController
                self.navigationController?.pushViewController(OTPVC!, animated: true)
            }
        })
    }
    
    func initalzeSignInWidgets() {
        txtfld_userName.rx.text.map { $0 ?? "" }.bind(to: loginViewModel.userNameInput_PublishSubject).disposed(by: disposeBag)
        txtfld_password.rx.text.map { $0 ?? "" }.bind(to: loginViewModel.passwordInput_PublishSubject).disposed(by: disposeBag)
        loginViewModel.isValidateSignIn().bind(to: btn_Login.rx.isEnabled).disposed(by: disposeBag)
        loginViewModel.isValidateSignIn().map { $0 ? 1 : 0.1}.bind(to: btn_Login.rx.alpha).disposed(by: disposeBag)
    }
    


}

class LoginViewModel {
    let userNameInput_PublishSubject = PublishSubject<String>()
    let passwordInput_PublishSubject = PublishSubject<String>()
    
    func isValidateSignIn() -> Observable<Bool> {
        Observable.combineLatest(userNameInput_PublishSubject.asObserver().startWith(), passwordInput_PublishSubject.asObserver().startWith()).map { username, password in
            return username.count > 3 && password.count > 3
        }.startWith(false)
    }
}
