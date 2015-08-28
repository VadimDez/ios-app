//
//  CompetenceViewController.swift
//  UnserAller
//
//  Created by Vadym on 28/07/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import Alamofire

class CompetenceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mainTable: UITableView!
    
    var entries: [UACompetence] = []
    var checkValidation: Bool = false
    var projectId: UInt!
    var projectStepId: UInt!
    var previousCompetenceFormat: CompetenceFormat!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mainTable.delegate = self
        self.mainTable.dataSource = self
    }
//    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        self.mainTable.reloadData()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerNibs()
        self.getEntries({ () -> Void in
            self.previousCompetenceFormat = nil
            self.mainTable.reloadData()
        }, error: { () -> Void in
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    Register nibs
    */
    func registerNibs() {
        // freetext
        var UAFreetextCellNib = UINib(nibName: "UAFreetextCell", bundle: nil)
        self.mainTable.registerNib(UAFreetextCellNib, forCellReuseIdentifier: "UAFreetextCell")
        // single line input
        var UASingleLineInputCellNib = UINib(nibName: "UASingleLineInputCell", bundle: nil)
        self.mainTable.registerNib(UASingleLineInputCellNib, forCellReuseIdentifier: "UASingleLineInputCell")
        // multiple line input
        var UAMultipleLineInputCellNib = UINib(nibName: "UAMultipleLineInputCell", bundle: nil)
        self.mainTable.registerNib(UAMultipleLineInputCellNib, forCellReuseIdentifier: "UAMultipleLineInputCell")
        // options
        var UAOptionsNib = UINib(nibName: "UAOptionsCell", bundle: nil)
        self.mainTable.registerNib(UAOptionsNib, forCellReuseIdentifier: "UAOptionsCell")
        // checkbox
        var UACheckboxCellNib = UINib(nibName: "UACheckboxCell", bundle: nil)
        self.mainTable.registerNib(UACheckboxCellNib, forCellReuseIdentifier: "UACheckboxCell")
        // likert
        var UALikertCellNib = UINib(nibName: "UALikertCell", bundle: nil)
        self.mainTable.registerNib(UALikertCellNib, forCellReuseIdentifier: "UALikertCell")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.getCell(indexPath)
    }
    
    func getCell(indexPath: NSIndexPath) -> UITableViewCell {
        
        switch self.entries[indexPath.row].format as CompetenceFormat {
        case CompetenceFormat.Placeholder:
            fallthrough
        case CompetenceFormat.SingleLineInput:
            fallthrough
        case CompetenceFormat.MultipleLineInput:
            fallthrough
        case CompetenceFormat.Options:
            fallthrough
        case CompetenceFormat.Checkbox:
            fallthrough
        case CompetenceFormat.Likert:
            var cell = self.mainTable.dequeueReusableCellWithIdentifier(self.entries[indexPath.row].cellType, forIndexPath: indexPath) as! UACompetenceCell
            
            
            if self.previousCompetenceFormat == CompetenceFormat.Likert && self.entries[indexPath.row].format == CompetenceFormat.Likert && self.entries[indexPath.row].content == self.entries[indexPath.row - 1].content {
                (cell as! UALikertCell).showContent = false
            }
            
            cell.setupCell(self.entries[indexPath.row])
            
            if self.checkValidation {
                cell.validate()
            }
            
            
            self.previousCompetenceFormat = self.entries[indexPath.row].format
            return cell

        default: return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let width = self.mainTable.frame.width
        let font = UIFont(name: "Helvetica Neue", size: 14)
        let competence: UACompetence = self.entries[indexPath.row]
        
        if competence.format == CompetenceFormat.Placeholder {
            return 15.0 + competence.content.getHeightForView(width - 16, font: font!)
        } else if competence.format == CompetenceFormat.SingleLineInput {
            return 25.0 + 25.0 + competence.content.getHeightForView(width - 16, font: font!)
        } else if competence.format == CompetenceFormat.MultipleLineInput {
            return 25.0 + 50.0 + competence.content.getHeightForView(width - 16, font: font!)
        } else if competence.format == CompetenceFormat.Options
            || competence.format == CompetenceFormat.Checkbox
            || competence.format == CompetenceFormat.Likert
        {
            
            var height: CGFloat = 15.0 // base
            
            if competence.format == CompetenceFormat.Likert {
                if competence.format == CompetenceFormat.Likert
                    && self.previousCompetenceFormat != CompetenceFormat.Likert
                    && competence.content != competence.content {
                    // content
                    height = height + 10.0 + competence.content.getHeightForView(width - 16, font: font!)
                } else {
                    height = height + 20.0
                }
                
                // count question height
                height = height + 10.0 + competence.content.getHeightForView(width - 16, font: font!)
            } else {
                height = height + competence.content.getHeightForView(width - 16, font: font!)
            }
            
            let count = (competence as! UACompetenceWithOptions).options.count
            
            for (var i = 0; i < count; i++) {
                let optionHeight = (competence as! UACompetenceWithOptions).options[i].name.getHeightForView(width - 59, font: font!)
                
                if optionHeight < 31 {
                    height = height + 31
                } else {
                    height = height + 10.0 + optionHeight
                }
            }
            
            return height
        }
        return 150.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entries.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "asd"
//    }
//    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIView()
//    }
//    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10.0
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.mainTable.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func getEntries(success: () -> Void, error: () -> Void) {
        var url = "\(APIURL)/api/mobile/competence/get"
        var params:[String: AnyObject] = [String: AnyObject]()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        if (self.projectId != nil) {
            params["project"] = self.projectId
        }
        if (self.projectStepId != nil) {
            params["step"] = self.projectStepId
        }
        
        Alamofire.request(.GET, url, parameters: params)
            .responseJSON { (_,_,JSON,errors) in
                
                if (errors != nil || JSON?.count == 0) {
                    // print error
                    println(errors)
                    
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    // error block
                    error()
                    
                } else {
                    let competenceService = CompetenceService()
                    
                    // get get objects from JSON
                    var array = competenceService.getCompetencesFromJSON(JSON?.objectForKey("competences") as! [Dictionary<String, AnyObject>])

                    // merge two arrays
//                    self.entries = self.entries + array
                    self.entries = array
                    
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    success()
                }
        }
    }
    
    @IBAction func send(sender: AnyObject) {
        let count = self.entries.count
        var isValid = true
        var results: [Dictionary<String, AnyObject>] = []
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        for (var i = 0; i < count; i++) {
            let competence = self.entries[i] as UACompetence
            if !competence.validate() {
                isValid = false
            } else {
                for result in competence.getAnswer() {
                    results.append(result)
                }
            }
        }
        
        if !isValid {
            self.checkValidation = true
            self.previousCompetenceFormat = nil
            self.mainTable.reloadData()
        }// else {
        //    self.checkValidation = false
        //}
        
        
        self.sendAnswers(results, success: { () -> Void in
            self.getEntries({ () -> Void in

                if (self.entries.count == 0) {

                    if self.projectId != nil {
                        
                        var navigation = self.navigationController
                        
                        if self.projectStepId == nil {
                            var projectVC: ProjectViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Project") as! ProjectViewController
                        
                            // set project id
                            projectVC.projectId = self.projectId
                            
//                            navigation?.popToRootViewControllerAnimated(false)
                            navigation?.popViewControllerAnimated(false)
                            navigation?.pushViewController(projectVC, animated: true)
                        } else {
                            navigation?.popViewControllerAnimated(true)
                        }
                    }
                } else {
                    self.previousCompetenceFormat = nil
                    self.mainTable.reloadData()
                }
            }, error: { () -> Void in
                
            })
        }) { () -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    func sendAnswers(answers: [Dictionary<String, AnyObject>], success: () -> Void, failure: () -> Void) {
        let url = "\(APIURL)/api/v1/user/competence"
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        request.HTTPBody = encodeParameters(["competences": answers]).dataUsingEncoding(NSUTF8StringEncoding)
        
//        Alamofire.request(.POST, url, parameters: ["competences": ["0": ["competence": 172, "value": "read"]]], encoding: ParameterEncoding.JSON)
        
        Alamofire.request(request)
            .responseJSON { (_,_,JSON,errors) in
                
                if (errors != nil) {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    // print error
                    println("send competences error")
                    println(errors)
                    // error block
                    failure()
                } else {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    println(errors)
                    success()
                }
        }
    }
    
    func encodeParameters(object: AnyObject, prefix: String! = nil) -> String {
        if let dictionary = object as? [String: AnyObject] {
            let results = map(dictionary) { (key, value) -> String in
                return self.encodeParameters(value, prefix: prefix != nil ? "\(prefix)[\(key)]" : key)
            }
            return "&".join(results)
        } else if let array = object as? [AnyObject] {
            let results = map(enumerate(array)) { (index, value) -> String in
                return self.encodeParameters(value, prefix: prefix != nil ? "\(prefix)[\(index)]" : "\(index)")
            }
            return "&".join(results)
        } else {
            let escapedValue = escape("\(object)")
            return prefix != nil ? "\(prefix)=\(escapedValue)" : "\(escapedValue)"
        }
    }
    
    // This is Alamofire's private `escape` function; IMHO, this should
    // be public method, so either make public, or just re-implement it.
    
    func escape(string: String) -> String {
        let legalURLCharactersToBeEscaped: CFStringRef = ":/?&=;+!@#$()',*"

        return CFURLCreateStringByAddingPercentEscapes(nil, string, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as NSString as String
    }
}
