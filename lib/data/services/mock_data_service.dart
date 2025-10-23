import 'dart:math';
import '../models/country_model.dart';
import 'database_service.dart';

class MockDataService {
  static final List<String> _firstNames = [
    'Ana',
    'Carlos',
    'María',
    'José',
    'Laura',
    'Diego',
    'Sofía',
    'Andrés',
    'Camila',
    'Miguel',
    'Valentina',
    'Sebastián',
    'Isabella',
    'Nicolás',
    'Gabriela',
    'Alejandro',
    'Daniela',
    'Fernando',
    'Natalia',
    'Ricardo',
    'Paola',
    'Roberto',
    'Andrea',
    'Luis',
    'Carolina',
    'Jorge',
    'Monica',
    'David',
    'Claudia',
    'Antonio',
    'Patricia',
    'Francisco',
    'Sandra',
    'Manuel',
    'Elena',
    'Rafael',
    'Carmen',
    'Javier',
    'Rosa',
    'Pedro',
    'Teresa',
    'Alberto',
    'Marta',
    'Eduardo',
    'Lucía',
    'Héctor',
    'Beatriz',
    'Raúl',
    'Adriana',
    'Víctor',
  ];

  static final List<String> _lastNames = [
    'García',
    'Rodríguez',
    'Martínez',
    'Hernández',
    'López',
    'González',
    'Pérez',
    'Sánchez',
    'Ramírez',
    'Cruz',
    'Flores',
    'Gómez',
    'Díaz',
    'Reyes',
    'Morales',
    'Jiménez',
    'Álvarez',
    'Ruiz',
    'Torres',
    'Domínguez',
    'Vásquez',
    'Ramos',
    'Gil',
    'Serrano',
    'Blanco',
    'Muñoz',
    'Romero',
    'Alonso',
    'Gutiérrez',
    'Navarro',
    'Torres',
    'Díaz',
    'Vargas',
    'Castro',
    'Ortega',
    'Delgado',
    'Peña',
    'Rojas',
    'Medina',
    'Guerrero',
    'Herrera',
    'Mendoza',
    'Aguilar',
    'Vega',
    'Silva',
    'Ramos',
    'Cortés',
    'Moreno',
    'Herrera',
    'Jiménez',
  ];

  static Future<void> generateMockUsers() async {
    final db = await DatabaseService.database;

    final existingUsers = await db.query('users');
    if (existingUsers.isNotEmpty) return;

    final countries = await _loadCountries();
    final random = Random();

    for (int i = 1; i <= 50; i++) {
      final firstName = _firstNames[random.nextInt(_firstNames.length)];
      final lastName = _lastNames[random.nextInt(_lastNames.length)];
      final birthDate = _generateRandomBirthDate();

      final userId = await db.insert('users', {
        'firstName': firstName,
        'lastName': lastName,
        'birthDate': birthDate.toIso8601String(),
      });

      final country = countries[random.nextInt(countries.length)];
      final department =
          country.departments[random.nextInt(country.departments.length)];
      final municipality =
          department.cities[random.nextInt(department.cities.length)];

      await db.insert('addresses', {
        'userId': userId,
        'country': country.name,
        'department': department.name,
        'municipality': municipality,
      });

      if (random.nextDouble() < 0.3) {
        final secondCountry = countries[random.nextInt(countries.length)];
        final secondDepartment = secondCountry
            .departments[random.nextInt(secondCountry.departments.length)];
        final secondMunicipality = secondDepartment
            .cities[random.nextInt(secondDepartment.cities.length)];

        await db.insert('addresses', {
          'userId': userId,
          'country': secondCountry.name,
          'department': secondDepartment.name,
          'municipality': secondMunicipality,
        });
      }
    }
  }

  static Future<List<CountryModel>> _loadCountries() async {
    return [
      CountryModel(
        name: 'Colombia',
        departments: [
          DepartmentModel(
            name: 'Bogotá D.C.',
            cities: ['Bogotá', 'Soacha', 'Chía', 'Zipaquirá', 'Cajicá'],
          ),
          DepartmentModel(
            name: 'Antioquia',
            cities: ['Medellín', 'Bello', 'Itagüí', 'Envigado', 'Apartadó'],
          ),
          DepartmentModel(
            name: 'Valle del Cauca',
            cities: ['Cali', 'Palmira', 'Buenaventura', 'Tuluá', 'Cartago'],
          ),
          DepartmentModel(
            name: 'Santander',
            cities: [
              'Bucaramanga',
              'Floridablanca',
              'Girón',
              'Piedecuesta',
              'Barrancabermeja',
            ],
          ),
          DepartmentModel(
            name: 'Atlántico',
            cities: [
              'Barranquilla',
              'Soledad',
              'Malambo',
              'Puerto Colombia',
              'Galapa',
            ],
          ),
        ],
      ),
      CountryModel(
        name: 'México',
        departments: [
          DepartmentModel(
            name: 'Ciudad de México',
            cities: [
              'Álvaro Obregón',
              'Coyoacán',
              'Iztapalapa',
              'Benito Juárez',
              'Miguel Hidalgo',
            ],
          ),
          DepartmentModel(
            name: 'Jalisco',
            cities: [
              'Guadalajara',
              'Zapopan',
              'Tlaquepaque',
              'Tonalá',
              'San Pedro Tlaquepaque',
            ],
          ),
          DepartmentModel(
            name: 'Nuevo León',
            cities: [
              'Monterrey',
              'Guadalupe',
              'San Nicolás de los Garza',
              'Apodaca',
              'Escobedo',
            ],
          ),
          DepartmentModel(
            name: 'Puebla',
            cities: [
              'Puebla',
              'San Pedro Cholula',
              'San Andrés Cholula',
              'Tehuacán',
              'Atlixco',
            ],
          ),
          DepartmentModel(
            name: 'Veracruz',
            cities: [
              'Veracruz',
              'Xalapa',
              'Coatzacoalcos',
              'Córdoba',
              'Poza Rica',
            ],
          ),
        ],
      ),
      CountryModel(
        name: 'Argentina',
        departments: [
          DepartmentModel(
            name: 'Buenos Aires',
            cities: [
              'La Plata',
              'Mar del Plata',
              'Quilmes',
              'Lomas de Zamora',
              'Lanús',
            ],
          ),
          DepartmentModel(
            name: 'Córdoba',
            cities: [
              'Córdoba',
              'Villa María',
              'Río Cuarto',
              'San Francisco',
              'Villa Carlos Paz',
            ],
          ),
          DepartmentModel(
            name: 'Santa Fe',
            cities: [
              'Santa Fe',
              'Rosario',
              'Venado Tuerto',
              'Rafaela',
              'Reconquista',
            ],
          ),
          DepartmentModel(
            name: 'Mendoza',
            cities: [
              'Mendoza',
              'San Rafael',
              'Godoy Cruz',
              'Las Heras',
              'Maipú',
            ],
          ),
          DepartmentModel(
            name: 'Tucumán',
            cities: [
              'San Miguel de Tucumán',
              'Yerba Buena',
              'Tafí Viejo',
              'Concepción',
              'Banda del Río Salí',
            ],
          ),
        ],
      ),
      CountryModel(
        name: 'Estados Unidos',
        departments: [
          DepartmentModel(
            name: 'California',
            cities: [
              'Los Angeles',
              'San Francisco',
              'San Diego',
              'Sacramento',
              'San José',
            ],
          ),
          DepartmentModel(
            name: 'Texas',
            cities: [
              'Houston',
              'Dallas',
              'Austin',
              'San Antonio',
              'Fort Worth',
            ],
          ),
          DepartmentModel(
            name: 'Florida',
            cities: [
              'Miami',
              'Tampa',
              'Orlando',
              'Jacksonville',
              'Tallahassee',
            ],
          ),
          DepartmentModel(
            name: 'Nueva York',
            cities: [
              'Nueva York',
              'Buffalo',
              'Rochester',
              'Syracuse',
              'Albany',
            ],
          ),
          DepartmentModel(
            name: 'Illinois',
            cities: ['Chicago', 'Aurora', 'Rockford', 'Joliet', 'Naperville'],
          ),
        ],
      ),
    ];
  }

  static DateTime _generateRandomBirthDate() {
    final random = Random();
    final now = DateTime.now();
    final minAge = 18;
    final maxAge = 80;

    final age = minAge + random.nextInt(maxAge - minAge + 1);
    final birthYear = now.year - age;
    final birthMonth = 1 + random.nextInt(12);
    final birthDay =
        1 + random.nextInt(28); // usar 28 para evitar problemas con febrero

    return DateTime(birthYear, birthMonth, birthDay);
  }
}
