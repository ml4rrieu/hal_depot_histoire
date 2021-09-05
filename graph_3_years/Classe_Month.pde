// a class for Month
class Month {
  String name ; 
  int monthnb; 
  // value for years are added into IntList (implicit index)
  IntList notice = new IntList();
  IntList file = new IntList();
  Month(int _monthnb, int _notice, int _file) {
    monthnb = _monthnb;
    notice.append(_notice);
    file.append(_file);
  }


  void update(int y, int _notice, int _file) {
    notice.append(_notice);
    file.append(_file);
  }
}
