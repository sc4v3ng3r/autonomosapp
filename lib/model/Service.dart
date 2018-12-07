
class Service implements Comparable<Service> {

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
  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    return ( (other is Service) && (( this.id.compareTo(other.id)) == 0) );
  }

  @override
  int compareTo(Service other) {
    return this.name.compareTo( other.name);
  }


}