//
//  CategoryViewController.swift
//  NextToRead
//
//  Created by Ekaterina Khudzhamkulova on 5.10.2020.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
	var categories = [Category]()
	var books = [Book]()
	var searchText: String?

	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

	let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
//		searchController.searchResultsUpdater = self
		searchController.searchBar.delegate = self
		navigationItem.searchController = searchController
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search Book"
		searchController.definesPresentationContext = true
		loadCategories()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
		var nameField = UITextField()

		let action = UIAlertAction(title: "Add", style: .default) { [self] (action) in
			let newCategory = Category(context: self.context)
			guard let message = nameField.text else {return}
			if message.count > 0 {
				newCategory.name = message
				self.categories.append(newCategory)

				saveCategories()
			}

		}
		alert.addTextField { (textField) in
			textField.placeholder = "Create New Category"
			nameField = textField
		}

		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}

	func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest(), predicate: NSPredicate? = nil) {
		if let predicate = predicate {
			request.predicate = predicate
		}
		do {
			categories = try context.fetch(request)
		} catch {
			print("Error fetching categories, \(error)")
		}
		tableView.reloadData()
	}

	func saveCategories() {
		do {
			try context.save()
		} catch {
			print("Error saving categories, \(error)")
		}
		tableView.reloadData()
	}

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categories.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.categoryCell.rawValue, for: indexPath)

		cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }

	// MARK: - Table view delegate methods

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: Constants.goToBooks.rawValue, sender: self)
	}


	// MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let destination = segue.destination as? ItemsViewController else {return}
		if let indexSelected = tableView.indexPathForSelectedRow?.row {
			destination.selectedCategory = categories[indexSelected]
		} else if let searchArgument = searchText {
			destination.searchArgument = searchArgument
			destination.selectedCategory = nil
		}
    }

}

extension CategoryViewController: UISearchBarDelegate {
	public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		if let text = searchBar.text {
			searchText = text
			performSegue(withIdentifier: Constants.goToBooks.rawValue, sender: self)
		}
	}

	public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text?.count == 0 {
			loadCategories()
			DispatchQueue.main.async {
				searchBar.resignFirstResponder()
			}
		}
		
	}
}
