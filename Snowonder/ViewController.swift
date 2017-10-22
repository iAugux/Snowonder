//
//  ViewController.swift
//  Snowonder
//
//  Created by Aliaksei Karetski on 19.06.17.
//  Copyright © 2017 Karetski. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var sortTypeCheckBox: NSButton! {
        didSet {
            sortTypeCheckBox.state = Prefs.sortByStringSize ? .on : .off
        }
    }
    
    // MARK: - Constant values
    
    private struct Constant {
        
        struct ScriptInfo {
            
            static let openSystemPreferencesExtensions: Script.Info = (Bundle.main, "open_system_preferences_extensions", .scpt)
        }
        
        struct URL {
            
            static let gitHub = Foundation.URL(string: "https://github.com/Karetski/Snowonder")
        }
    }
    
    // MARK: - Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Action handlers

    @IBAction func sortTypeCheckBoxValueDidChange(_ sender: NSButton) {
        Prefs.sortByStringSize = sender.state == .on
    }

    @IBAction func enableExtensionButtonAction(_ sender: NSButton) {
        Script(info: Constant.ScriptInfo.openSystemPreferencesExtensions).execute()
    }
    
    @IBAction func setupKeybindingsButtonAction(_ sender: NSButton) {
        // TODO: Implement in future versions
    }
    
    @IBAction func gitHubButtonAction(_ sender: NSButton) {
        if let url = Constant.URL.gitHub {
            NSWorkspace.shared.open(url)
        }
    }
}
