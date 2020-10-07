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
	var books = [Book]()
	let booksExmp = ["One", "Two", "Three"]
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		return books.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.bookCell.rawValue, for: indexPath)
		cell.textLabel?.text = books[indexPath.row].title

        return cell
    }

	func loadBooks() {
		let request: NSFetchRequest<Book> = Book.fetchRequest()
		guard let categoryArgument = selectedCategory?.name else {return}
		let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", categoryArgument)
		request.predicate = predicate
		do {
			books = try context.fetch(request)
		} catch {
			print("Error fetching books, \(error)")
		}
		tableView.reloadData()
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
