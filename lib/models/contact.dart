
class Contact {

	int _id;
	String _title;
	String _description;


	Contact(this._title,
   [this._description]);

	Contact.withId(this._id, this._title,
   [this._description]);

	int get id => _id;

	String get title => _title;

	String get description => _description;

	set title(String newTitle) {
		if (newTitle.length <= 255) {
			this._title = newTitle;
		}
	}

	set description(String newDescription) {
		if (newDescription.length <= 255) {
			this._description = newDescription;
		}
	}



	// Convert a Note object into a Map object
	Map<String, dynamic> toMap() {

		var map = Map<String, dynamic>();
		if (id != null) {
			map['id'] = _id;
		}
		map['title'] = _title;
		map['description'] = _description;

		return map;
	}

	// Extract a Note object from a Map object
	Contact.fromMapObject(Map<String, dynamic> map) {
		this._id = map['id'];
		this._title = map['title'];
		this._description = map['description'];
	}
}









