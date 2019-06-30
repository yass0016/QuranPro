abstract class ListItem {}

class ChapterHeaderItem implements ListItem {
  final String name;
  final String number;

  ChapterHeaderItem(this.name, this.number);
}

class JuzHeaderItem implements ListItem {
  final String number;

  JuzHeaderItem(this.number);
}

class VerseItem implements ListItem {
  final String verse;
  final String verseNumber;
  final String verseTransliteration;
  final String verseTranslationEnglish;

  VerseItem(this.verse, this.verseNumber,
      {this.verseTransliteration, this.verseTranslationEnglish});
}
