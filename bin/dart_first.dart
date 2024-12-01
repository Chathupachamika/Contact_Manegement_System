import 'dart:io';

class ContactList {
  List<Contact> contacts = [];
  int nextIndex = 0;

  String generateId() {
    return "C00${contacts.length + 1}".padLeft(5, '');
  }

  int searchByNameOrPhoneNumber(String query) {
    for (int i = 0; i < contacts.length; i++) {
      if (contacts[i].name == query || contacts[i].phoneNumber == query) {
        return i;
      }
    }
    return -1;
  }

  void add(Contact contact) {
    contacts.add(contact);
    nextIndex++;
  }

  void updateName(int index, String newName) => contacts[index].name = newName;
  void updatePhoneNumber(int index, String newPhoneNumber) =>
      contacts[index].phoneNumber = newPhoneNumber;
  void updateCompanyName(int index, String newCompanyName) =>
      contacts[index].companyName = newCompanyName;
  void updateSalary(int index, double newSalary) =>
      contacts[index].salary = newSalary;
}

class Contact {
  String id, name, phoneNumber, companyName, birthday;
  double salary;

  Contact(this.id, this.name, this.phoneNumber, this.companyName, this.salary, this.birthday);
}

class Customer {
  static final ContactList globalContactList = ContactList();

  static void delete(int index) {
    if (index >= 0 && index < globalContactList.contacts.length) {
      globalContactList.contacts.removeAt(index);
      print("Contact deleted successfully!");
    } else {
      print("Invalid contact index.");
    }
  }
  static void clearConsole() {
    if (Platform.isWindows) {
      Process.runSync('cmd', ['/c', 'cls']);
    } else {
      stdout.write("\x1B[2J\x1B[H");
    }
  }

  static void homepage() {
    while (true) {
      print('''
===============================
[01] Add Contact
[02] Update Contact
[03] Search Contact
[04] Delete Contact
[05] List Contacts
[06] Exit
===============================
''');
      stdout.write("Enter an option: ");
      String? option = stdin.readLineSync();

      switch (option) {
        case '1':
          addContacts();
          break;
        case '2':
          updateContacts();
          break;
        case '3':
          searchContacts();
          break;
        case '4':
          deleteContacts();
          break;  
        case '5':
          listContacts();
          break;
        case '6':
          exit(0);
        default:
          print("Invalid option. Try again.");
      }
    }
  }

  static void addContacts() {
    print("\n+---------------------------------+");
    print("|           Add Contact           |");
    print("+---------------------------------+\n");
    String id = globalContactList.generateId();
    stdout.write("Name: ");
    String name = stdin.readLineSync()!;

    String phoneNumber;
    do {
      stdout.write("Phone Number (10 digits, starts with 0): ");
      phoneNumber = stdin.readLineSync()!;
    } while (!isValidPhoneNumber(phoneNumber));

    stdout.write("Company Name: ");
    String companyName = stdin.readLineSync()!;

    double salary;
    do {
      stdout.write("Salary (positive): ");
      salary = double.tryParse(stdin.readLineSync()!) ?? -1;
    } while (!isValidSalary(salary));

    String birthday;
    do {
      stdout.write("Birthday (YYYY-MM-DD): ");
      birthday = stdin.readLineSync()!;
    } while (!isValidBirthday(birthday));

    globalContactList.add(Contact(id, name, phoneNumber, companyName, salary, birthday));
    print("Contact added successfully!\n");
  }

  static void deleteContacts() {
    while (true) {
      print("\n+---------------------------------+");
      print("|          Delete Contact         |");
      print("+---------------------------------+\n");
      stdout.write("Search contact by name or phone number: ");
      String query = stdin.readLineSync()!;
      int index = globalContactList.searchByNameOrPhoneNumber(query);

      if (index == -1) {
        print("\nNo contact found for '$query'.");
        stdout.write("\nDo you want to try a new search? (Y/N): ");
        String? ch = stdin.readLineSync();
        if (ch == 'Y' || ch == 'y') {
          clearConsole();
          continue;
        } else if (ch == 'N' || ch == 'n') {
          clearConsole();
          homepage();
          break;
        }
      } else {
        printDetails(index);
        stdout.write("\nDo you want to delete this contact? (Y/N): ");
        String? ch = stdin.readLineSync();
        if (ch == 'Y' || ch == 'y') {
          delete(index);
        }

        stdout.write("\nDo you want to delete another contact? (Y/N): ");
        ch = stdin.readLineSync();
        if (ch == 'Y' || ch == 'y') {
          clearConsole();
          continue;
        } else if (ch == 'N' || ch == 'n') {
          clearConsole();
          homepage();
          break;
        }
      }
    }
  }
  static void updateContacts() {
    print("\n+---------------------------------+");
    print("|          Update Contact         |");
    print("+---------------------------------+\n");
    stdout.write("Search by name or phone number: ");
    String query = stdin.readLineSync()!;
    int index = globalContactList.searchByNameOrPhoneNumber(query);

    if (index == -1) {
      print("Contact not found.");
      return;
    }

    printDetails(index);

    print("What do you want to update?");
    print("[1] Name");
    print("[2] Phone Number");
    print("[3] Company Name");
    print("[4] Salary");
    stdout.write("Choose an option: ");
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        stdout.write("New Name: ");
        globalContactList.updateName(index, stdin.readLineSync()!);
        break;
      case '2':
        stdout.write("New Phone Number: ");
        globalContactList.updatePhoneNumber(index, stdin.readLineSync()!);
        break;
      case '3':
        stdout.write("New Company Name: ");
        globalContactList.updateCompanyName(index, stdin.readLineSync()!);
        break;
      case '4':
        stdout.write("New Salary: ");
        globalContactList.updateSalary(index, double.parse(stdin.readLineSync()!));
        break;
      default:
        print("Invalid option.");
    }
    print("Contact updated successfully!");
  }

  static void searchContacts() {
    print("\n+---------------------------------+");
    print("|          Search Contact         |");
    print("+---------------------------------+\n");
    stdout.write("Search by name or phone number: ");
    String query = stdin.readLineSync()!;
    int index = globalContactList.searchByNameOrPhoneNumber(query);

    if (index == -1) {
      print("Contact not found.");
    } else {
      printDetails(index);
    }
  }

  static void printDetails(int index) {
    var contact = globalContactList.contacts[index];
    print('''
Contact Details:
ID: ${contact.id}
Name: ${contact.name}
Phone Number: ${contact.phoneNumber}
Company Name: ${contact.companyName}
Salary: ${contact.salary}
Birthday: ${contact.birthday}
''');
  }

  static void listContacts() {
    while (true) {
      print('''
+---------------------------------+
|           View Contact          |
+---------------------------------+
[01] Sorting by Name
[02] Sorting by Salary
[03] Sorting by Birthday
[04] Go Back
''');
      stdout.write("Enter option to continue: ");
      String? option = stdin.readLineSync();

      switch (option) {
        case '1':
          sortByName();
          break;
        case '2':
          sortBySalary();
          break;
        case '3':
          sortByBirthday();
          break;
        case '4':
          return;
        default:
          print("Invalid option.");
      }
    }
  }

  static void sortByName() {
    print("\n--- Listing Contacts by Name ---");
    globalContactList.contacts.sort((a, b) => a.name.compareTo(b.name));
    printContactList();
  }

  static void sortBySalary() {
    print("\n--- Listing Contacts by Salary ---");
    globalContactList.contacts.sort((a, b) => a.salary.compareTo(b.salary));
    printContactList();
  }

  static void sortByBirthday() {
    print("\n--- Listing Contacts by Birthday ---");
    globalContactList.contacts.sort((a, b) => a.birthday.compareTo(b.birthday));
    printContactList();
  }

  static void printContactList() {
    print('''
+-----------------------------------------------------------------------------------------------------------+
|   Contact Id    |    Name         |  Phone Number   |   Company       |    Salary       |   Birthday      |
+-----------------------------------------------------------------------------------------------------------+''');
    for (var contact in globalContactList.contacts) {
      print('| ${contact.id.padRight(15)} | ${contact.name.padRight(15)} | ${contact.phoneNumber.padRight(15)} | '
          '${contact.companyName.padRight(15)} | ${contact.salary.toStringAsFixed(2).padRight(15)} | ${contact.birthday.padRight(15)} |');
    }
    print("+-----------------------------------------------------------------------------------------------------------+");
  }

  static bool isValidPhoneNumber(String phoneNumber) {
    return RegExp(r'^0\d{9}$').hasMatch(phoneNumber);
  }

  static bool isValidSalary(double salary) => salary > 0;

  static bool isValidBirthday(String birthday) {
    try {
      DateTime.parse(birthday);
      return true;
    } catch (e) {
      return false;
    }
  }
  
}

void main() {
  Customer.homepage();
}
