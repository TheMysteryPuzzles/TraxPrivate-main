//
//  CheckoutViewController.swift
//  Trax
//
//  Created by mac on 27/08/2022.
//

import UIKit
import WebKit
import Alamofire
import ProgressHUD

struct PaymentUrl: Codable {
    let url: String
}

class CheckoutViewController: UIViewController, WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate {

    var userId = ""
    var vId = "0"
    
    lazy var topBar: UIView = {
       let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.7578694579, green: 0.7578694579, blue: 0.7578694579, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()
    
    lazy var backButton: UIButton = {
       let button = UIButton()
        //button.setImage(UIImage(named: "cancel"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    lazy var webView: WKWebView = {
        let preferences = WKPreferences()
        let contentController = WKUserContentController()
        
        preferences.javaScriptEnabled = true

        let source: String = """
                    window.onload = function() {
                    document.addEventListener("click", function(evt) {
                        var tagClicked = document.elementFromPoint(evt.clientX, evt.clientY);
                        window.webkit.messageHandlers.btnClicked.postMessage(tagClicked.outerHTML.toString());
                    });
                }
                """
        
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
           contentController.addUserScript(script)
           let configuration = WKWebViewConfiguration()
           configuration.preferences = preferences
           configuration.userContentController = contentController
           configuration.userContentController.add(self, name: "btnClicked")
        
        let view = WKWebView(frame: self.view.frame, configuration: configuration)
        view.translatesAutoresizingMaskIntoConstraints = false
        
       return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = UserDefaults().string(forKey: "user_id") {
            self.userId = id
            print(id)
        }
        self.view.addSubview(webView)
   
      
   
        ProgressHUD.show()
        let url = rootUrl + "checkout_api?user_id=\(userId)&v_id=\(self.vId)"
       
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        //self.webView.scrollView.delegate = self
        
        AF.request(url, method: .get).responseDecodable(of: PaymentUrl.self) { response in
            
            print(response)
            
            guard let url = response.value else {
                return
            }
            
            ProgressHUD.dismiss()
            
            let trimmed_url = url.url.filter {!$0.isWhitespace}
            
             let paymentUrl = URL (string: trimmed_url)
             let request = NSMutableURLRequest(url: paymentUrl!)
            
             request.httpMethod = "POST"
             request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
             self.webView.load(request as URLRequest)
           
        }
 
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        ProgressHUD.show()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ProgressHUD.dismiss()
    }
    
   
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
       // self.dismiss(animated: true)
        print(message.name)
        switch message.name {
        case "btnClicked":
             let sentData = message.body as! String
            if sentData.contains("ok"){
                goToHomeVc()
            }
                
        default:
            break
        }
    }
    
    func goToHomeVc(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarViewController") as! UITabBarController
        vc.selectedIndex = 2
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    

}
