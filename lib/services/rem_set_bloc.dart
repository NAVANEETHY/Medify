import 'package:rxdart/rxdart.dart';
import 'package:Medify/utils/errors.dart';
import 'package:Medify/utils/medicine_type.dart';

class NewEntryBloc {
  BehaviorSubject<MedicineType>? _selectMedicineType$;
  ValueStream<MedicineType>? get selectedMedicineType =>
      _selectMedicineType$!.stream;

  BehaviorSubject<int>? _selectedInterval$;
  BehaviorSubject<int>? get selectIntervals => _selectedInterval$;

  BehaviorSubject<String>? _selectedTimeOfDay$;
  BehaviorSubject<String>? get selectedTimeOfDay => _selectedTimeOfDay$;

//error state
  BehaviorSubject<EntryError>? _errorState$;
  BehaviorSubject<EntryError>? get errorState$ => _errorState$;

  NewEntryBloc() {
    _selectMedicineType$ =
        BehaviorSubject<MedicineType>.seeded(MedicineType.None);

    _selectedTimeOfDay$ = BehaviorSubject<String>.seeded('none');
    _selectedInterval$ = BehaviorSubject<int>.seeded(0);
    _errorState$ = BehaviorSubject<EntryError>();
  }

  void dispose() {
    _selectMedicineType$!.close();
    _selectedTimeOfDay$!.close();
    _selectedInterval$!.close();
  }

  void submitError(EntryError error) {
    _errorState$!.add(error);
  }

  void updateInterval(int interval) {
    _selectedInterval$!.add(interval);
  }

  void updateTime(String time) {
    _selectedTimeOfDay$!.add(time);
  }

  void updateSelectedMedicine(MedicineType type) {
    // if (_selectMedicineType$ != null) {
    MedicineType tempType = _selectMedicineType$!.value;

    if (type == tempType) {
      _selectMedicineType$!.add(MedicineType.None);
    } else {
      _selectMedicineType$!.add(type);
    }
  }
}
//}
