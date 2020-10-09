//
//  ItemsViewController.swift
//  NextToRead
//
//  Created by Ekaterina Khudzhamkulova on 5.10.2020.
//

import UIKit
import CoreData

class ItemsViewController: UITableViewController {
	var selectedCategory: Category? {
		didSet {
			loadBooks()
		}
	}
	var searchArgument: String? {
		didSet {
			loadBooks()
			navigationItem.rightBarButtonItem?.isEnabled = false
		}
	}

	var books = [Book]()
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return books.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: Constants.bookCell.rawValue, for: indexPath)
		let cellWithStyle = UITableViewCell(style: .subtitle, reuseIdentifier: Constants.bookCell.rawValue)
		cell = cellWithStyle
		cell.accessoryType = .checkmark
		let book = books[indexPath.row]
		cell.accessoryType = book.finished ? .checkmark : .none
		cell.textLabel?.text = book.title
		cell.detailTextLabel?.text = book.author


        return cell
    }

	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		let alert = UIAlertController(title: "Add New Book", message: "", preferredStyle: .alert)
		var titleField = UITextField()
		var authorField = UITextField()
		let action = UIAlertAction(title: "Add", style: .default) { [self] (action) in
			guard let title = titleField.text else {return}
			if title.count > 0 {
				let newBook = Book(context: self.context)
				newBook.title = title
				newBook.author = authorField.text
				newBook.parentCategory = selectedCategory


				books.append(newBook)
				saveBooks()
			}
		}
		alert.addTextField { (titleText) in
			titleText.placeholder = "Save a book name"
			titleField = titleText
		}
		alert.addTextField { (authorText) in
			authorText.placeholder = "Save a book author"
			authorField = authorText
		}

		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}

	//MARK: - Data manipulating methods

	func saveBooks() {
		do {
			try context.save()
		} catch {
			print("Error saving books, \(error)")
		}
		tableView.reloadData()
	}

	func loadBooks() {
		let request: NSFetchRequest<Book> = Book.fetchRequest()
		if let categoryArgument = selectedCategory?.name {

			let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", categoryArgument)
			request.predicate = predicate
		} else if let text = searchArgument {
			let predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
			request.predicate = predicate
		}
			do {
				books = try context.fetch(request)
			} catch {
				print("Error fetching books, \(error)")
			}
			tableView.reloadData()
	}

	//MARK: - Table view delegate methods

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		books[indexPath.row].finished = books[indexPath.row].finished ? false : true
		saveBooks()
	}
}
