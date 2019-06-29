class Chapter {
  String _id;
  String _ayas;
  String _start;
  String _name;
  String _tname;
  String _ename;
  String _type;
  String _order;
  String _rukus;

  Chapter(this._id, this._ayas, this._start, this._name, this._tname,
      this._ename, this._type, this._order, this._rukus);

  String get rukus => _rukus;

  set rukus(String value) {
    _rukus = value;
  }

  String get order => _order;

  set order(String value) {
    _order = value;
  }

  String get type => _type;

  set type(String value) {
    _type = value;
  }

  String get ename => _ename;

  set ename(String value) {
    _ename = value;
  }

  String get tname => _tname;

  set tname(String value) {
    _tname = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get start => _start;

  set start(String value) {
    _start = value;
  }

  String get ayas => _ayas;

  set ayas(String value) {
    _ayas = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }


}