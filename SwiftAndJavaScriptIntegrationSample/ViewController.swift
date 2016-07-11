import Cocoa
import WebKit

class ViewController: NSViewController {
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var webView: WebView!
    @IBOutlet weak var textLabel: NSTextField!
    
    @IBAction func callJavaScript(sender: AnyObject) {
        webView.windowScriptObject.evaluateWebScript("log('" + textField.stringValue + "')")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var html: String = "<!DOCTYPE html>"
        html += "<html lang='en'>"
        html += "<head>"
        html += "  <meta charset='UTF-8'>"
        html += "</head>"
        html += "<body>"
        html += "<input id='ipt' type='text' value='Hello, Swift' />"
        html += "<button id='btn'>Call Swift</button>"
        html += "<br/>"
        html += "<p>From Swift:</p>"
        html += "<p id='msg'></p>"
        html += "<script>"
        html += "  var ipt = document.getElementById('ipt');"
        html += "  var btn = document.getElementById('btn');"
        html += "  var msgEl = document.getElementById('msg');"
        html += "  btn.addEventListener('click', function () {"
        html += "    Cocoa.log(ipt.value);"
        html += "  });"
        html += "  window.log = function (msg) {"
        html += "    msgEl.innerHTML += msg;"
        html += "  };"
        html += "</script>"
        html += "</body>"
        html += "</html>";
        webView.mainFrame.loadHTMLString(html, baseURL: nil)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

extension ViewController: WebFrameLoadDelegate {
    func webView(webView: WebView!, didClearWindowObject windowObject: WebScriptObject!, forFrame frame: WebFrame!) {
        webView.windowScriptObject.setValue(self, forKey: "Cocoa")
    }
    
    override class func webScriptNameForSelector(sel: Selector) -> String? {
        if sel == #selector(cocoaLog) {
            return "log";
        }
        return nil
    }
    
    override class func isSelectorExcludedFromWebScript(sel: Selector) -> Bool {
        switch (sel) {
        case #selector(cocoaLog):
            return false
        default:
            return true
        }
    }
    
    func cocoaLog(message: String) {
        textLabel.stringValue = message
    }
}
