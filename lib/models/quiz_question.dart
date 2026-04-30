class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });
}

class PythonMaterial {
  final String id;
  final String name;
  final String description;
  final List<QuizQuestion> questions;
  final String icon;

  PythonMaterial({
    required this.id,
    required this.name,
    required this.description,
    required this.questions,
    required this.icon,
  });
}

// Quiz Data untuk 6 materi dasar Python
class QuizDataManager {
  static List<PythonMaterial> getAllMaterials() {
    return [
      _getIntegerMaterial(),
      _getBooleanMaterial(),
      _getStringMaterial(),
      _getFloatMaterial(),
      _getSetMaterial(),
      _getDictionaryMaterial(),
    ];
  }

  static PythonMaterial _getIntegerMaterial() {
    return PythonMaterial(
      id: 'integer',
      name: 'Integer',
      description: 'Pelajari tentang tipe data bilangan bulat dalam Python',
      icon: '🔢',
      questions: [
        QuizQuestion(
          question: 'Manakah yang merupakan tipe data Integer dalam Python?',
          options: ['15.5', '15', '"15"', '[15]'],
          correctAnswerIndex: 1,
          explanation:
              'Integer adalah tipe data untuk bilangan bulat tanpa desimal. "15" adalah nilai integer yang benar.',
        ),
        QuizQuestion(
          question: 'Apa hasil dari operasi 10 + 5 dalam Python?',
          options: ['15.0', '15', '"15"', 'Error'],
          correctAnswerIndex: 1,
          explanation:
              'Operasi penjumlahan dua integer menghasilkan integer. 10 + 5 = 15',
        ),
        QuizQuestion(
          question: 'Bagaimana cara mengecek tipe data sebuah variabel?',
          options: ['check(x)', 'type(x)', 'gettype(x)', 'typeof(x)'],
          correctAnswerIndex: 1,
          explanation:
              'Fungsi type() digunakan untuk mengecek tipe data dari sebuah variabel.',
        ),
        QuizQuestion(
          question: 'Berapa nilai maksimum integer dalam Python?',
          options: ['Tidak ada batasan', '2^31 - 1', '2^32 - 1', '2^64 - 1'],
          correctAnswerIndex: 0,
          explanation:
              'Python memungkinkan integer dengan nilai tak terbatas (arbitrary precision).',
        ),
        QuizQuestion(
          question: 'Apa output dari print(type(42))?',
          options: ['<class "int">', '<type "int">', '"int"', 'int'],
          correctAnswerIndex: 0,
          explanation:
              'Fungsi type() mengembalikan class type. Untuk integer, outputnya adalah <class "int">',
        ),
        QuizQuestion(
          question: 'Operasi mana yang menghasilkan integer?',
          options: ['10 / 3', '10 // 3', '10 % 3', 'Semua benar'],
          correctAnswerIndex: 3,
          explanation:
              '10 // 3 = 3 (floor division), 10 % 3 = 1 (modulo). Keduanya menghasilkan integer.',
        ),
      ],
    );
  }

  static PythonMaterial _getBooleanMaterial() {
    return PythonMaterial(
      id: 'boolean',
      name: 'Boolean',
      description: 'Memahami nilai True dan False dalam pemrograman',
      icon: '✔️',
      questions: [
        QuizQuestion(
          question: 'Manakah yang merupakan nilai Boolean dalam Python?',
          options: ['1 dan 0', 'True dan False', '"True" dan "False"', 'true dan false'],
          correctAnswerIndex: 1,
          explanation:
              'Boolean adalah tipe data dengan dua nilai: True dan False (dengan huruf capital).',
        ),
        QuizQuestion(
          question: 'Apa hasil dari operasi 5 > 3?',
          options: ['5 > 3', 'True', 'False', 'None'],
          correctAnswerIndex: 1,
          explanation:
              'Perbandingan 5 > 3 adalah benar, sehingga hasilnya adalah True.',
        ),
        QuizQuestion(
          question: 'Operator logika mana yang berarti "AND"?',
          options: ['&', '&&', 'and', 'AND'],
          correctAnswerIndex: 2,
          explanation:
              'Operator "and" digunakan untuk operasi logika AND dalam Python.',
        ),
        QuizQuestion(
          question: 'Apa hasil dari not True?',
          options: ['True', 'False', 'None', 'Error'],
          correctAnswerIndex: 1,
          explanation:
              'Operator not mengubah nilai boolean menjadi kebalikannya. not True = False',
        ),
        QuizQuestion(
          question: 'Manakah yang akan menghasilkan True?',
          options: ['True and False', 'False or False', 'True or False', 'not False and False'],
          correctAnswerIndex: 2,
          explanation:
              'True or False menghasilkan True karena operator or hanya membutuhkan satu nilai True.',
        ),
        QuizQuestion(
          question: 'Berapa jumlah nilai Boolean yang ada dalam Python?',
          options: ['1', '2', '3', 'Unlimited'],
          correctAnswerIndex: 1,
          explanation: 'Ada dua nilai Boolean: True dan False',
        ),
      ],
    );
  }

  static PythonMaterial _getStringMaterial() {
    return PythonMaterial(
      id: 'string',
      name: 'String',
      description: 'Bekerja dengan teks dan karakter dalam Python',
      icon: '📝',
      questions: [
        QuizQuestion(
          question: 'Manakah yang merupakan String dalam Python?',
          options: ['123', '"hello"', '[1,2,3]', '12.5'],
          correctAnswerIndex: 1,
          explanation:
              'String adalah teks yang diapit oleh tanda kutip (single atau double quotes).',
        ),
        QuizQuestion(
          question: 'Bagaimana cara menggabungkan dua string?',
          options: ['Menggunakan +', 'Menggunakan &', 'Menggunakan +=', 'Keduanya benar'],
          correctAnswerIndex: 3,
          explanation:
              'String dapat digabungkan dengan operator + atau += dalam Python.',
        ),
        QuizQuestion(
          question: 'Apa hasil dari "Hello".upper()?',
          options: ['"HELLO"', '"Hello"', 'HELLO', 'None'],
          correctAnswerIndex: 0,
          explanation:
              'Method upper() mengubah semua huruf string menjadi huruf besar (capital).',
        ),
        QuizQuestion(
          question: 'Bagaimana cara mendapatkan karakter pertama dari string?',
          options: ['s[0]', 's[1]', 's[-1]', 's.first()'],
          correctAnswerIndex: 0,
          explanation:
              'Indeks dalam Python dimulai dari 0, jadi karakter pertama adalah s[0].',
        ),
        QuizQuestion(
          question: 'Apa yang dilakukan method len() pada string?',
          options: ['Menghapus string', 'Menghitung panjang string', 'Mengubah ke huruf kecil', 'Membagi string'],
          correctAnswerIndex: 1,
          explanation:
              'Fungsi len() digunakan untuk menghitung jumlah karakter dalam string.',
        ),
        QuizQuestion(
          question: 'Bagaimana cara mengganti karakter dalam string?',
          options: ['string.change()', 'string.replace()', 'string.substitute()', 'string.swap()'],
          correctAnswerIndex: 1,
          explanation:
              'Method replace() digunakan untuk mengganti karakter atau substring dalam string.',
        ),
      ],
    );
  }

  static PythonMaterial _getFloatMaterial() {
    return PythonMaterial(
      id: 'float',
      name: 'Float',
      description: 'Memahami bilangan desimal dalam Python',
      icon: '🔹',
      questions: [
        QuizQuestion(
          question: 'Manakah yang merupakan tipe data Float?',
          options: ['5', '5.5', '"5.5"', '[5.5]'],
          correctAnswerIndex: 1,
          explanation:
              'Float adalah tipe data untuk bilangan dengan desimal. 5.5 adalah nilai float.',
        ),
        QuizQuestion(
          question: 'Apa hasil dari 10 / 3 dalam Python 3?',
          options: ['3', '3.0', '3.333...', 'Error'],
          correctAnswerIndex: 2,
          explanation:
              'Operator / selalu menghasilkan float dalam Python 3. 10 / 3 = 3.333...',
        ),
        QuizQuestion(
          question: 'Bagaimana cara mengkonversi string ke float?',
          options: ['float()', 'tofloat()', 'int()', 'str()'],
          correctAnswerIndex: 0,
          explanation:
              'Fungsi float() digunakan untuk mengkonversi nilai ke tipe data float.',
        ),
        QuizQuestion(
          question: 'Berapa jumlah desimal yang dapat dimiliki float?',
          options: ['Maksimal 2', 'Maksimal 6', 'Tidak terbatas tetapi memiliki presisi', 'Maksimal 10'],
          correctAnswerIndex: 2,
          explanation:
              'Float dapat memiliki banyak desimal tetapi terbatas oleh presisi floating-point.',
        ),
        QuizQuestion(
          question: 'Apa hasil dari 1.5 * 2?',
          options: ['3', '3.0', '1.52', 'Error'],
          correctAnswerIndex: 1,
          explanation:
              'Operasi antara float dan integer menghasilkan float. 1.5 * 2 = 3.0',
        ),
        QuizQuestion(
          question: 'Fungsi mana untuk membulatkan float?',
          options: ['floor()', 'ceil()', 'round()', 'semua benar'],
          correctAnswerIndex: 3,
          explanation:
              'Python menyediakan berbagai fungsi pembulatan: round() untuk pembulatan normal, floor() untuk pembulatan ke bawah, ceil() untuk pembulatan ke atas.',
        ),
      ],
    );
  }

  static PythonMaterial _getSetMaterial() {
    return PythonMaterial(
      id: 'set',
      name: 'Set',
      description: 'Kumpulan elemen unik tanpa urutan',
      icon: '◎',
      questions: [
        QuizQuestion(
          question: 'Bagaimana cara membuat Set dalam Python?',
          options: ['[1,2,3]', '{1,2,3}', '(1,2,3)', 'set(1,2,3)'],
          correctAnswerIndex: 1,
          explanation:
              'Set dibuat menggunakan kurung kurawal {}. Set tidak dapat memiliki duplikat.',
        ),
        QuizQuestion(
          question: 'Apa karakteristik utama dari Set?',
          options: ['Urut dan bisa duplikat', 'Tidak urut dan tidak bisa duplikat', 'Urut dan tidak bisa duplikat', 'Tidak urut dan bisa duplikat'],
          correctAnswerIndex: 1,
          explanation:
              'Set tidak memiliki urutan tertentu dan secara otomatis menghapus duplikat.',
        ),
        QuizQuestion(
          question: 'Apa hasil dari {1,2,2,3}?',
          options: ['{1,2,2,3}', '{1,2,3}', 'Error', '{3,2,1}'],
          correctAnswerIndex: 1,
          explanation:
              'Set secara otomatis menghapus duplikat. Hasil dari {1,2,2,3} adalah {1,2,3}.',
        ),
        QuizQuestion(
          question: 'Metode mana untuk menambah elemen ke Set?',
          options: ['add()', 'append()', 'insert()', 'push()'],
          correctAnswerIndex: 0,
          explanation:
              'Method add() digunakan untuk menambah satu elemen ke Set.',
        ),
        QuizQuestion(
          question: 'Bagaimana cara menghapus semua elemen Set?',
          options: ['del()', 'remove()', 'clear()', 'pop()'],
          correctAnswerIndex: 2,
          explanation:
              'Method clear() digunakan untuk menghapus semua elemen dalam Set.',
        ),
        QuizQuestion(
          question: 'Operasi mana yang merupakan gabungan dua Set?',
          options: ['Set1 & Set2', 'Set1 | Set2', 'Set1 + Set2', 'Set1 - Set2'],
          correctAnswerIndex: 1,
          explanation:
              'Operator | (pipe) digunakan untuk menggabungkan dua Set. Set1 | Set2',
        ),
      ],
    );
  }

  static PythonMaterial _getDictionaryMaterial() {
    return PythonMaterial(
      id: 'dictionary',
      name: 'Dictionary',
      description: 'Data dengan pasangan kunci-nilai',
      icon: '📖',
      questions: [
        QuizQuestion(
          question: 'Bagaimana cara membuat Dictionary dalam Python?',
          options: ['{1,2,3}', '{"key": "value"}', '[{"key": "value"}]', '("key", "value")'],
          correctAnswerIndex: 1,
          explanation:
              'Dictionary dibuat dengan kurung kurawal dan pasangan key:value. Contoh: {"nama": "Budi"}',
        ),
        QuizQuestion(
          question: 'Bagaimana cara mengakses nilai dalam Dictionary?',
          options: ['dict[value]', 'dict[key]', 'dict.get(value)', 'dict.value(key)'],
          correctAnswerIndex: 1,
          explanation:
              'Mengakses Dictionary menggunakan key. Contoh: person["nama"] untuk mendapatkan nilai.',
        ),
        QuizQuestion(
          question: 'Apa hasil dari {"a": 1, "b": 2}["a"]?',
          options: ['"a"', '1', '"a": 1', 'Error'],
          correctAnswerIndex: 1,
          explanation:
              'Mengakses key "a" dari dictionary mengembalikan nilai yang terkait, yaitu 1.',
        ),
        QuizQuestion(
          question: 'Metode mana untuk mendapatkan semua key dalam Dictionary?',
          options: ['values()', 'items()', 'keys()', 'get()'],
          correctAnswerIndex: 2,
          explanation:
              'Method keys() mengembalikan semua kunci dalam dictionary.',
        ),
        QuizQuestion(
          question: 'Bagaimana cara menambah pasangan key-value baru?',
          options: ['dict.add(key, value)', 'dict[key] = value', 'dict.set(key, value)', 'dict.insert(key, value)'],
          correctAnswerIndex: 1,
          explanation:
              'Menambah key-value baru dengan syntax: dict[key] = value',
        ),
        QuizQuestion(
          question: 'Bagaimana cara menghapus key dari Dictionary?',
          options: ['dict.remove(key)', 'del dict[key]', 'dict.delete(key)', 'Keduanya benar'],
          correctAnswerIndex: 3,
          explanation:
              'Bisa menggunakan del dict[key] atau dict.pop(key) untuk menghapus key dari dictionary.',
        ),
      ],
    );
  }
}

