import 'package:bored_g/locations/types.dart';
import 'gamexy_conv.dart';

class Entry<T> {
  final RegExp regex;
  final String listName;
  final T Function(double x, double y) fromXY;
  final Map<String, dynamic> Function(Object?) toJson;

  Entry(
      {required this.regex,
      required this.listName,
      required this.fromXY,
      required this.toJson});
}

var entries = <Entry>[
  Entry<BoatLocation>(
    regex: RegExp(r'Land_Boat[^]*?pos="(.*?) (.*?) (.*?)"'),
    listName: "boats",
    fromXY: (x, y) =>
        BoatLocation.fromXY(convertGameXToNormX(x), convertGameYToNormY(y)),
    toJson: (val) => BoatLocation.toJson(val as BoatLocation),
  ),
  Entry<WellPumpLocation>(
    regex: RegExp(r'Land_.*_Well_Pump[^]*?pos="(.*?) (.*?) (.*?)"'),
    listName: "well_pumps",
    fromXY: (x, y) =>
        WellPumpLocation.fromXY(convertGameXToNormX(x), convertGameYToNormY(y)),
    toJson: (val) => WellPumpLocation.toJson(val as WellPumpLocation),
  ),
  Entry<LightHouseLocation>(
    regex: RegExp(r'Land_Lighthouse[^]*?pos="(.*?) (.*?) (.*?)"'),
    listName: "lighthouses",
    fromXY: (x, y) => LightHouseLocation.fromXY(
        convertGameXToNormX(x), convertGameYToNormY(y)),
    toJson: (val) => LightHouseLocation.toJson(val as LightHouseLocation),
  ),
  Entry<ChurchLocation>(
    regex: RegExp(r'Land_Church[^]*?pos="(.*?) (.*?) (.*?)"'),
    listName: "churchs",
    fromXY: (x, y) =>
        ChurchLocation.fromXY(convertGameXToNormX(x), convertGameYToNormY(y)),
    toJson: (val) => ChurchLocation.toJson(val as ChurchLocation),
  ),
  Entry<MilitaryTentLocation>(
    regex: RegExp(r'Land_Mil_Tent[^]*?pos="(.*?) (.*?) (.*?)"'),
    listName: "military_tents",
    fromXY: (x, y) => MilitaryTentLocation.fromXY(
        convertGameXToNormX(x), convertGameYToNormY(y)),
    toJson: (val) => MilitaryTentLocation.toJson(val as MilitaryTentLocation),
  ),
  Entry<MilitaryBarrackLocation>(
    regex: RegExp(r'Land_Mil_Barracks[^]*?pos="(.*?) (.*?) (.*?)"'),
    listName: "military_barracks",
    fromXY: (x, y) => MilitaryBarrackLocation.fromXY(
        convertGameXToNormX(x), convertGameYToNormY(y)),
    toJson: (val) =>
        MilitaryBarrackLocation.toJson(val as MilitaryBarrackLocation),
  ),
  Entry<CaravanWreckLocation>(
    regex: RegExp(r'Land_Wreck_Caravan[^]*?pos="(.*?) (.*?) (.*?)"'),
    listName: "caravan_wrecks",
    fromXY: (x, y) => CaravanWreckLocation.fromXY(
        convertGameXToNormX(x), convertGameYToNormY(y)),
    toJson: (val) => CaravanWreckLocation.toJson(val as CaravanWreckLocation),
  ),
  Entry<IkarusWreckLocation>(
    regex: RegExp(r'Land_Wreck_Ikarus[^]*?pos="(.*?) (.*?) (.*?)"'),
    listName: "ikarus_wrecks",
    fromXY: (x, y) => IkarusWreckLocation.fromXY(
        convertGameXToNormX(x), convertGameYToNormY(y)),
    toJson: (val) => IkarusWreckLocation.toJson(val as IkarusWreckLocation),
  ),
  Entry<TruckWreckLocation>(
    regex: RegExp(r'Land_wreck_truck[^]*?pos="(.*?) (.*?) (.*?)"'),
    listName: "truck_wrecks",
    fromXY: (x, y) => TruckWreckLocation.fromXY(
        convertGameXToNormX(x), convertGameYToNormY(y)),
    toJson: (val) => TruckWreckLocation.toJson(val as TruckWreckLocation),
  ),
  Entry<SedanWreckLocation>(
    regex: RegExp(r'Land_Wreck_sed[^]*?pos="(.*?) (.*?) (.*?)"'),
    listName: "sedan_wrecks",
    fromXY: (x, y) => SedanWreckLocation.fromXY(
        convertGameXToNormX(x), convertGameYToNormY(y)),
    toJson: (val) => SedanWreckLocation.toJson(val as SedanWreckLocation),
  ),
  Entry<HbWreckLocation>(
    regex: RegExp(r'Land_Wreck_hb[^]*?pos="(.*?) (.*?) (.*?)"'),
    listName: "hb_wrecks",
    fromXY: (x, y) =>
        HbWreckLocation.fromXY(convertGameXToNormX(x), convertGameYToNormY(y)),
    toJson: (val) => HbWreckLocation.toJson(val as HbWreckLocation),
  ),
  Entry<DeerStandLocation>(
    regex: RegExp(r'Land_Misc_DeerStand[^]*?pos="(.*?) (.*?) (.*?)"'),
    listName: "deerstands",
    fromXY: (x, y) => DeerStandLocation.fromXY(
        convertGameXToNormX(x), convertGameYToNormY(y)),
    toJson: (val) => DeerStandLocation.toJson(val as DeerStandLocation),
  ),
  Entry<GreenHouseLocation>(
    regex: RegExp(r'Land_Misc_Greenhouse[^]*?pos="(.*?) (.*?) (.*?)"'),
    listName: "greenhouses",
    fromXY: (x, y) => GreenHouseLocation.fromXY(
        convertGameXToNormX(x), convertGameYToNormY(y)),
    toJson: (val) => GreenHouseLocation.toJson(val as GreenHouseLocation),
  ),
  Entry<RadioTowerLocation>(
    regex: RegExp(r'Land_Tower_TC[^]*?pos="(.*?) (.*?) (.*?)"'),
    listName: "radio_towers",
    fromXY: (x, y) => RadioTowerLocation.fromXY(
        convertGameXToNormX(x), convertGameYToNormY(y)),
    toJson: (val) => RadioTowerLocation.toJson(val as RadioTowerLocation),
  ),
  Entry<BarnLocation>(
    regex: RegExp(r'Land_Barn[^]*?pos="(.*?) (.*?) (.*?)"'),
    listName: "barns",
    fromXY: (x, y) =>
        BarnLocation.fromXY(convertGameXToNormX(x), convertGameYToNormY(y)),
    toJson: (val) => BarnLocation.toJson(val as BarnLocation),
  ),
  Entry<GroceryKioskLocation>(
    regex: RegExp(r'Land_.*_Grocery[^]*?pos="(.*?) (.*?) (.*?)"'),
    listName: "grocery_kiosks",
    fromXY: (x, y) => GroceryKioskLocation.fromXY(
        convertGameXToNormX(x), convertGameYToNormY(y)),
    toJson: (val) => GroceryKioskLocation.toJson(val as GroceryKioskLocation),
  ),
];
