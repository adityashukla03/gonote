class Task {
  String _name;
  bool _completed = false;

  Task(this._name);

  // Getter and setter for name
  getName() => this._name;
  setName(name) => this._name = name;

  // Getter and setter for completed
  isCompleted() => this._completed;
  setCompleted(completed) => this._completed = completed;
}