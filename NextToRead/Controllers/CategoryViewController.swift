//
//  CategoryViewController.swift
//  NextToRead
//
//  Created by Ekaterina Khudzhamkulova on 5.10.2020.
//

import UIKit
import CoreData

enum Constants: String {
	case categoryCell
}

class CategoryViewController: UITableViewController {
	let categoriesExmp = ["One", "Two", "Three"]
	var categories = [Category]()

	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

		loadCategories()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		saveCategories()
	}

	func loadCategories() {
		let request: NSFetchRequest<Category> = Category.fetchRequest()
		do {
			categories = try context.fetch(request)
		} catch {
			print("Error fetching categories, \(error)")
		}
		tableView.reloadData()
	}

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categoriesExmp.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.categoryCell.rawValue, for: indexPath)

		cell.textLabel?.text = categoriesExmp[indexPath.row]
        return cell
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
