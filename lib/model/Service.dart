
class Service {

  String id;
  String name;

  static final String ID = "id";
  static final String NAME = "name";

  Service(this.id, this.name);

  Service.fromJson(Map<String, dynamic> json) :
      id = json[ID],
      name = json[NAME];


  Map<String, dynamic> toJson () => {
    ID : id,
    NAME : name,
  };

  @override
  String toString() {
    return "ID: $id\nNAME: $name";
  }
}