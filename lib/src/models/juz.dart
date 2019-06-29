class Juz {
  String _id;
  String _sura;
  String _startingAya;
  String _aya;
  String _name;
  String _tname;

  Juz(this._id, this._sura, this._startingAya, this._aya, this._name,
      this._tname);

  String get tname => _tname;

  set tname(String value) {
    _tname = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get aya => _aya;

  set aya(String value) {
    _aya = value;
  }

  String get startingAya => _startingAya;

  set startingAya(String value) {
    _startingAya = value;
  }

  String get sura => _sura;

  set sura(String value) {
    _sura = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }


}