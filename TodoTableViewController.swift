import UIKit
import RealmSwift

class TodoTableViewController: UITableViewController {
    
    @IBAction func AddThingsButton(_ sender: UIBarButtonItem) {
        let alertController: UIAlertController = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        let alertAction: UIAlertAction = UIAlertAction(title: "Add", style: .default) { (text) in
            //alertにtextFieldを追加する。
            let textField = alertController.textFields![0] as UITextField
            
            //optionalの検査
            if let text = textField.text {
                //Todoインスタンスの作成
                let todo = Todo()
                todo.text = text
                
                // Get the default Realm
                let realm = try! Realm()
                
                //Databeseに書き込み
                try! realm.write {
                    realm.add(todo)
                }
                
                //tableViewをリロードする。
                self.tableView.reloadData()
            }
        }
            
        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter the new todos"
        }
        alertController.addAction(alertAction)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let realm = try! Realm()
        let todos = realm.objects(Todo.self)
        
        return todos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let realm = try! Realm()
        let todos = realm.objects(Todo.self)
        let todo = todos[indexPath.row]
        // Configure the cell...
        cell.textLabel!.text = todo.text
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let realm = try! Realm()
            let todos = realm.objects(Todo.self)
            let todo = todos[indexPath.row]
            
            try! realm.write {
                realm.delete(todo)
            }
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
