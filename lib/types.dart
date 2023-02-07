enum LocationType { city, village, capital, camp, local }

class Location {
  String name;
  double x;
  double y;
  LocationType type;

  Location(this.name, this.x, this.y, this.type);

  static Map<String, dynamic> toJson(Location value) => {'name': value.name, 'latitude': value.x, 'longitude': value.y, 'type': value.type.name};

  Location.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        x = json['latitude'],
        y = json['longitude'],
        type = LocationType.values.byName(json['type']);
}

class NormXY {
  double x;
  double y;

  NormXY(this.x, this.y);

  static Map<String, dynamic> toJson(NormXY value) => {
        'x': value.x,
        'y': value.y,
      };

  NormXY.fromJson(Map<String, dynamic> json)
      : x = json['x'],
        y = json['y'];
}

class WellPumpLocation {
  NormXY xy;

  WellPumpLocation(this.xy);
  WellPumpLocation.fromXY(double x, double y) : xy = NormXY(x, y);

  static Map<String, dynamic> toJson(WellPumpLocation value) => {
        'x': value.xy.x,
        'y': value.xy.y,
      };

  WellPumpLocation.fromJson(Map<String, dynamic> json) : xy = NormXY(json['x'], json['y']);
}

class BoatLocation {
  NormXY xy;

  BoatLocation(this.xy);
  BoatLocation.fromXY(double x, double y) : xy = NormXY(x, y);

  static Map<String, dynamic> toJson(BoatLocation value) => {
        'x': value.xy.x,
        'y': value.xy.y,
      };

  BoatLocation.fromJson(Map<String, dynamic> json) : xy = NormXY(json['x'], json['y']);
}

enum RedLocationType { military, firestation, policestation }

class RedLocation extends Comparable<RedLocation> {
  RedLocationType type;
  NormXY xy;

  RedLocation(this.type, this.xy);
  RedLocation.fromXY(this.type, double x, double y) : xy = NormXY(x, y);

  static Map<String, dynamic> toJson(RedLocation value) => {
        'type': value.type.name,
        'x': value.xy.x,
        'y': value.xy.y,
      };

  RedLocation.fromJson(Map<String, dynamic> json)
      : xy = NormXY(json['x'], json['y']),
        type = RedLocationType.values.byName(json['type']);

  @override
  int compareTo(RedLocation other) {
    switch (type) {
      case RedLocationType.firestation:
        switch (other.type) {
          case RedLocationType.firestation:
            return 0;
          case RedLocationType.policestation:
          case RedLocationType.military:
            return 1;
        }
      case RedLocationType.military:
        switch (other.type) {
          case RedLocationType.military:
            return 0;
          case RedLocationType.firestation:
          case RedLocationType.policestation:
            return -1;
        }
      case RedLocationType.policestation:
        switch (other.type) {
          case RedLocationType.military:
            return 1;
          case RedLocationType.firestation:
            return -1;
          case RedLocationType.policestation:
            return 0;
        }
    }
  }
}

enum PinkLocationType {
  medicalcenter,
  hospital,
}

class PinkLocation extends Comparable<PinkLocation> {
  PinkLocationType type;
  NormXY xy;

  PinkLocation(this.type, this.xy);
  PinkLocation.fromXY(this.type, double x, double y) : xy = NormXY(x, y);

  static Map<String, dynamic> toJson(PinkLocation value) => {
        'type': value.type.name,
        'x': value.xy.x,
        'y': value.xy.y,
      };

  PinkLocation.fromJson(Map<String, dynamic> json)
      : xy = NormXY(json['x'], json['y']),
        type = PinkLocationType.values.byName(json['type']);

  @override
  int compareTo(PinkLocation other) {
    switch (type) {
      case PinkLocationType.medicalcenter:
        switch (other.type) {
          case PinkLocationType.medicalcenter:
            return 0;
          case PinkLocationType.hospital:
            return 1;
        }
      case PinkLocationType.hospital:
        switch (other.type) {
          case PinkLocationType.hospital:
            return 0;
          case PinkLocationType.medicalcenter:
            return -1;
        }
    }
  }
}

class LightHouseLocation {
  NormXY xy;

  LightHouseLocation(this.xy);
  LightHouseLocation.fromXY(double x, double y) : xy = NormXY(x, y);

  static Map<String, dynamic> toJson(LightHouseLocation value) => {
        'x': value.xy.x,
        'y': value.xy.y,
      };

  LightHouseLocation.fromJson(Map<String, dynamic> json) : xy = NormXY(json['x'], json['y']);
}

class MilitaryTentLocation {
  NormXY xy;

  MilitaryTentLocation(this.xy);
  MilitaryTentLocation.fromXY(double x, double y) : xy = NormXY(x, y);

  static Map<String, dynamic> toJson(MilitaryTentLocation value) => {
        'x': value.xy.x,
        'y': value.xy.y,
      };

  MilitaryTentLocation.fromJson(Map<String, dynamic> json) : xy = NormXY(json['x'], json['y']);
}

class CaravanWreckLocation {
  NormXY xy;

  CaravanWreckLocation(this.xy);
  CaravanWreckLocation.fromXY(double x, double y) : xy = NormXY(x, y);

  static Map<String, dynamic> toJson(CaravanWreckLocation value) => {
        'x': value.xy.x,
        'y': value.xy.y,
      };

  CaravanWreckLocation.fromJson(Map<String, dynamic> json) : xy = NormXY(json['x'], json['y']);
}

class IkarusWreckLocation {
  NormXY xy;

  IkarusWreckLocation(this.xy);
  IkarusWreckLocation.fromXY(double x, double y) : xy = NormXY(x, y);

  static Map<String, dynamic> toJson(IkarusWreckLocation value) => {
        'x': value.xy.x,
        'y': value.xy.y,
      };

  IkarusWreckLocation.fromJson(Map<String, dynamic> json) : xy = NormXY(json['x'], json['y']);
}

class TruckWreckLocation {
  NormXY xy;

  TruckWreckLocation(this.xy);
  TruckWreckLocation.fromXY(double x, double y) : xy = NormXY(x, y);

  static Map<String, dynamic> toJson(TruckWreckLocation value) => {
        'x': value.xy.x,
        'y': value.xy.y,
      };

  TruckWreckLocation.fromJson(Map<String, dynamic> json) : xy = NormXY(json['x'], json['y']);
}

class SedanWreckLocation {
  NormXY xy;

  SedanWreckLocation(this.xy);
  SedanWreckLocation.fromXY(double x, double y) : xy = NormXY(x, y);

  static Map<String, dynamic> toJson(SedanWreckLocation value) => {
        'x': value.xy.x,
        'y': value.xy.y,
      };

  SedanWreckLocation.fromJson(Map<String, dynamic> json) : xy = NormXY(json['x'], json['y']);
}

class HbWreckLocation {
  NormXY xy;

  HbWreckLocation(this.xy);
  HbWreckLocation.fromXY(double x, double y) : xy = NormXY(x, y);

  static Map<String, dynamic> toJson(HbWreckLocation value) => {
        'x': value.xy.x,
        'y': value.xy.y,
      };

  HbWreckLocation.fromJson(Map<String, dynamic> json) : xy = NormXY(json['x'], json['y']);
}

class DeerStandLocation {
  NormXY xy;

  DeerStandLocation(this.xy);
  DeerStandLocation.fromXY(double x, double y) : xy = NormXY(x, y);

  static Map<String, dynamic> toJson(DeerStandLocation value) => {
        'x': value.xy.x,
        'y': value.xy.y,
      };

  DeerStandLocation.fromJson(Map<String, dynamic> json) : xy = NormXY(json['x'], json['y']);
}

class ChurchLocation {
  NormXY xy;

  ChurchLocation(this.xy);
  ChurchLocation.fromXY(double x, double y) : xy = NormXY(x, y);

  static Map<String, dynamic> toJson(ChurchLocation value) => {
        'x': value.xy.x,
        'y': value.xy.y,
      };

  ChurchLocation.fromJson(Map<String, dynamic> json) : xy = NormXY(json['x'], json['y']);
}

class MilitaryBarrackLocation {
  NormXY xy;

  MilitaryBarrackLocation(this.xy);
  MilitaryBarrackLocation.fromXY(double x, double y) : xy = NormXY(x, y);

  static Map<String, dynamic> toJson(MilitaryBarrackLocation value) => {
        'x': value.xy.x,
        'y': value.xy.y,
      };

  MilitaryBarrackLocation.fromJson(Map<String, dynamic> json) : xy = NormXY(json['x'], json['y']);
}

class GreenHouseLocation {
  NormXY xy;

  GreenHouseLocation(this.xy);
  GreenHouseLocation.fromXY(double x, double y) : xy = NormXY(x, y);

  static Map<String, dynamic> toJson(GreenHouseLocation value) => {
        'x': value.xy.x,
        'y': value.xy.y,
      };

  GreenHouseLocation.fromJson(Map<String, dynamic> json) : xy = NormXY(json['x'], json['y']);
}

class RadioTowerLocation {
  NormXY xy;

  RadioTowerLocation(this.xy);
  RadioTowerLocation.fromXY(double x, double y) : xy = NormXY(x, y);

  static Map<String, dynamic> toJson(RadioTowerLocation value) => {
        'x': value.xy.x,
        'y': value.xy.y,
      };

  RadioTowerLocation.fromJson(Map<String, dynamic> json) : xy = NormXY(json['x'], json['y']);
}

class BarnLocation {
  NormXY xy;

  BarnLocation(this.xy);
  BarnLocation.fromXY(double x, double y) : xy = NormXY(x, y);

  static Map<String, dynamic> toJson(BarnLocation value) => {
        'x': value.xy.x,
        'y': value.xy.y,
      };

  BarnLocation.fromJson(Map<String, dynamic> json) : xy = NormXY(json['x'], json['y']);
}

class GroceryKioskLocation {
  NormXY xy;

  GroceryKioskLocation(this.xy);
  GroceryKioskLocation.fromXY(double x, double y) : xy = NormXY(x, y);

  static Map<String, dynamic> toJson(GroceryKioskLocation value) => {
        'x': value.xy.x,
        'y': value.xy.y,
      };

  GroceryKioskLocation.fromJson(Map<String, dynamic> json) : xy = NormXY(json['x'], json['y']);
}
