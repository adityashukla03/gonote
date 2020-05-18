class Todo {
  String name;
  bool completed = false;

  Todo(this.name, this.completed);

  // Getter and setter for name
  getName() => this.name;
  setName(name) => this.name = name;

  isCompleted() => this.completed;
  setCompleted(completed) => this.completed = completed;
}
