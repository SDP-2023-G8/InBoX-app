class Delivery {
  String name;
  DateTime date;
  InBoXUnit unit;

  Delivery(this.name, this.date, this.unit);
}

class InBoXUnit {
  final int _numberOfCompartments;
  final List<CompartmentStatus> compartments = [];

  InBoXUnit(this._numberOfCompartments) {
    for (int i = 0; i < _numberOfCompartments; i++) {
      compartments.add(CompartmentStatus.empty);
    }
  }

  void reserveCompartment(int number) {
    compartments[number] = CompartmentStatus.reserved;
  }

  void recordDelivery(int number) {
    compartments[number] = CompartmentStatus.occupied;
  }

  void markEmpty(int number) {
    compartments[number] = CompartmentStatus.empty;
  }
}

enum CompartmentStatus {
  empty,
  reserved,
  occupied;
}
