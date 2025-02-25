import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

final _diabetesgController = TextEditingController();
final _glucisaController = TextEditingController();
final _presionController = TextEditingController();
final _insulinaController = TextEditingController();
final _imcController = TextEditingController();
final _pedigriController = TextEditingController();
final _edadController = TextEditingController();

final _edadMetController = TextEditingController();
final _generoMetController = TextEditingController();
final _pesoMetController = TextEditingController();
final _imcMetController = TextEditingController();
final _insulinaHistMetController = TextEditingController();
final _hbaMetController = TextEditingController();
final _glucemiMetController = TextEditingController();
final _gluce2hMetController = TextEditingController();
final _antecedentesMetController = TextEditingController();



class Formulario4 extends StatefulWidget {
  @override
  _Formulario4State createState() => _Formulario4State();
}

class _Formulario4State extends State<Formulario4> {
  List<ChartData> _chartData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChartData();
  }

  Future<void> _fetchChartData() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5000/get_reporte_metformina'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _chartData = data.map((item) => ChartData(
          fecha: item['fecha'],
          totalPrediccion: item['total_prediccion'],
        )).toList();
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reporte de Dosis de Metformina')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 400, // Ajusta la altura según sea necesario
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      title: AxisTitle(text: 'Fecha'),
                    ),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(text: 'Total Predicción'),
                    ),
                    title: ChartTitle(text: 'Reporte de Dosis de Metformina'),
                    legend: Legend(isVisible: true),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <ChartSeries>[
                      ColumnSeries<ChartData, String>(
                        dataSource: _chartData,
                        xValueMapper: (ChartData data, _) => data.fecha,
                        yValueMapper: (ChartData data, _) => data.totalPrediccion,
                        color: Colors.blue,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class ChartData {
  ChartData({required this.fecha, required this.totalPrediccion});
  final String fecha;
  final double totalPrediccion;
}


class MyHomePage extends StatefulWidget {


  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {

  void _showSnackbar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}


  String _resultado = '';
  
  void _showDialog(String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Resultado'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}




Future<void> _processValues() async {
  const String urlString = 'http://127.0.0.1:5000/process_values';
  final Uri url = Uri.parse(urlString);
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'cadena': '48,0,62,23.5,57.9,7.9,125,226,1'
    }),
  );

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    print('Respuesta de la API: $jsonData');

    String resultMessage = '${jsonData['message']}: ${jsonData['values_received'].join(', ')}. Resultado: ${jsonData['prediction']}';

    setState(() {
      _resultado = resultMessage;
    });

    _showSnackbar(resultMessage);
    _showDialog(resultMessage);
  } else {
    print('Error: ${response.statusCode}');
    setState(() {
      _resultado = 'Error al obtener resultado.';
    });
    _showSnackbar('Error al obtener resultado.');
    _showDialog('Error al obtener resultado.');
  }
}




Future<void> _procesotresobjetive() async {
  const String urlString = 'http://127.0.0.1:5000/objetive3';
  final Uri url = Uri.parse(urlString);
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'cadena': '1,11,26,1,0,0,1,0'
    }),
  );

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    print('Respuesta de la API: $jsonData');

    String resultMessage = '${jsonData['message']}: ${jsonData['values_received'].join(', ')}. Resultado: ${jsonData['prediction']}';

    setState(() {
      _resultado = resultMessage;
    });

    _showSnackbar(resultMessage);
    _showDialog(resultMessage);
  } else {
    print('Error: ${response.statusCode}');
    setState(() {
      _resultado = 'Error al obtener resultado.';
    });
    _showSnackbar('Error al obtener resultado.');
    _showDialog('Error al obtener resultado.');
  }
}



Future<void> _predictScaled() async {
  const String urlString = 'http://127.0.0.1:5000/predict_scaled';
  final Uri url = Uri.parse(urlString);
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'values': [46, 0, 79, 25.2, 49.0, 6.6, 125, 191, 1]  // Asegúrate de enviar los valores en el orden correcto
    }),
  );

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    print('Respuesta de la API: $jsonData');

    String resultMessage;
    if (jsonData['prediction'] == 0) {
      resultMessage = 'No riesgo de diabetes';
    } else if (jsonData['prediction'] == 1) {
      resultMessage = 'Riesgo de diabetes';
    } else {
      resultMessage = 'Resultado no reconocido';
    }

    setState(() {
      _resultado = resultMessage;
    });

    _showSnackbar(resultMessage);
    _showDialog(resultMessage);
  } else {
    print('Error: ${response.statusCode}');
    setState(() {
      _resultado = 'Error al obtener resultado.';
    });
    _showSnackbar('Error al obtener resultado.');
    _showDialog('Error al obtener resultado.');
  }
}

Future<void> _makeHelloRequest() async {
  const String urlString = 'http://127.0.0.1:5000/hello';
  final Uri url = Uri.parse(urlString);
  
  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    print('Respuesta de la API: $jsonData');

    // Acceder al mensaje del JSON
    String resultMessage = jsonData['message'] ?? 'Mensaje no encontrado';

    setState(() {
      _resultado = resultMessage;
    });

    _showSnackbar(resultMessage);
    _showDialog(resultMessage);
  } else {
    print('Error: ${response.statusCode}');
    setState(() {
      _resultado = 'Error al obtener resultado.';
    });
    _showSnackbar('Error al obtener resultado.');
    _showDialog('Error al obtener resultado.');
  }
}

Future<void> _makeMultiplyRequest(int number) async {
  const String urlString = 'http://127.0.0.1:5000/multiply';
  final Uri url = Uri.parse(urlString);
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'number': 2,
    }),
  );

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    print('Respuesta de la API: $jsonData');

    // Acceder al resultado del JSON
    int result = jsonData['result'] ?? 0;

    String resultMessage = 'El doble del número es: $result';

    setState(() {
      _resultado = resultMessage;
    });

    _showSnackbar(resultMessage);
    _showDialog(resultMessage);
  } else {
    print('Error: ${response.statusCode}');
    setState(() {
      _resultado = 'Error al obtener resultado.';
    });
    _showSnackbar('Error al obtener resultado.');
    _showDialog('Error al obtener resultado.');
  }
}



  Future<void> _makePrediction() async {
  
  const String urlString = 'http://127.0.0.1:5000/predict';
  final Uri url = Uri.parse(urlString);
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({

      //'values': [ _diabetesgController.text, _glucisaController.text, _presionController.text, _insulinaController.text, _imcController.text, _pedigriController.text, _edadController.text],
       'values': [
          _diabetesgController.text,
          _glucisaController.text,
          _presionController.text,
          _insulinaController.text,
          _imcController.text,
          _pedigriController.text,
          _edadController.text
        ],
      
    }),
  ); if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    print('Respuesta de la API: $jsonData');
    
    // Acceder a la clave 'prediction' en lugar de 'resultado'
    String resultMessage;
    if (jsonData['prediction'] == 0) {
      resultMessage = 'No riesgo de diabetes';
    } else if (jsonData['prediction'] == 1) {
      resultMessage = 'Riesgo de diabetes';
    } else {
      resultMessage = 'Resultado no reconocido';
    }

    setState(() {
      _resultado = resultMessage;
    });

    _showSnackbar(resultMessage);
    _showDialog(resultMessage);
  } else {
    print('Error: ${response.statusCode}');
    setState(() {
      _resultado = 'Error al obtener resultado.';
    });
    _showSnackbar('Error al obtener resultado.');
    _showDialog('Error al obtener resultado.');
  }

}


  String _selectedOption = '¡Prevenir es mejor que curar! Nuestra app te ofrece una estimación de tu riesgo de diabetes tipo 2, basada en los últimos avances en inteligencia artificial. Con esta información, podrás adoptar hábitos de vida más saludables y trabajar junto a tu médico para prevenir esta enfermedad.';

  void _selectOption(String option) {
    setState(() {
      _selectedOption = option;
    });
  }

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();



@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Predicción de Diabetes Mellitus Tipo II'),
    ),
    body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () => _selectOption('formulario1'),
            child: const Text('Predecir riesgo de Diabetes Mellitus Tipo II'),
          ),
          ElevatedButton(
            onPressed: () => _selectOption('formulario2'),
            child: const Text('Predecir dosis de Metformina'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _selectOption('formulario3'),
            child: const Text('Predecir enfermedad al corazón'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _selectOption('formulario4'),
            child: const Text('REPORTE dosis de Metformina'),
          ),
          // Contenido basado en la opción seleccionada
          _selectedOption == 'formulario1'
                  ? Form(
                      key: _formKey1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _diabetesgController,
                                      decoration: const InputDecoration(
                                        labelText: 'Diabetes_Gestacional',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor ingrese su Diabetes Gestacional';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _glucisaController,
                                      decoration: const InputDecoration(
                                        labelText: 'Glucosa',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor ingrese su Glucosa';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: TextFormField(
                                        controller: _presionController,
                                        decoration: const InputDecoration(
                                          labelText: 'Presion_Arterial',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor ingrese su Presion Arterial';
                                          }
                                          return null;
                                        },
                                      ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 16),
                            Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                        controller: _insulinaController,
                                        decoration: const InputDecoration(
                                          labelText: 'Insulina',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor ingrese su Insulina';
                                          }
                                          return null;
                                        },
                                      ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: TextFormField(
                                        controller: _imcController,
                                        decoration: const InputDecoration(
                                          labelText: 'IMC',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor ingrese su IMC';
                                          }
                                          return null;
                                        },
                                      ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: TextFormField(
                                        controller: _pedigriController,
                                        decoration: const InputDecoration(
                                          labelText: 'Función Pedrigrí Diabetes',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor ingrese su Función Pedrigrí Diabetes';
                                          }
                                          return null;
                                        },
                                      ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                          controller: _edadController,
                                          decoration: const InputDecoration(
                                            labelText: 'Edad',
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Por favor ingrese su Edad';
                                            }
                                            return null;
                                          },
                                        ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      flex: 2,
                                      child: Container(), // Espacio vacío
                                    ),
                                  ],
                                ),

                            ElevatedButton(
                              onPressed: () {
                                if (_formKey1.currentState!.validate()) {
                                _makePrediction();
                                }
                              },
                              child: const Text('Predecir riesgo de diabetes'),
                            ),
                            const SizedBox(height: 20),
                              Text(
                                _resultado,
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                          ],
                        ),
                      ),
                      
                    )
                : _selectedOption == 'formulario2'
                      ? Form(
                          key: _formKey2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                          controller: _edadMetController,
                                          decoration: const InputDecoration(
                                            labelText: 'EdadMetformina',
                                          ),
                                          
                                        ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _generoMetController,
                                        decoration: const InputDecoration(
                                          labelText: 'Genero',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _pesoMetController,
                                        decoration: const InputDecoration(
                                          labelText: 'Peso',
                                        ),
                                      
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _imcMetController,
                                        decoration: const InputDecoration(
                                          labelText: 'IMCmetformina',
                                        ),
                                      
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _insulinaHistMetController,
                                        decoration: const InputDecoration(
                                          labelText: 'insulinahistorica',
                                        ),
                                        
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _hbaMetController,
                                        decoration: const InputDecoration(
                                          labelText: 'hba',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _glucemiMetController,
                                        decoration: const InputDecoration(
                                          labelText: 'glucemiabasal',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _gluce2hMetController,
                                        decoration: const InputDecoration(
                                          labelText: 'glucemia2h',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _antecedentesMetController,
                                        decoration: const InputDecoration(
                                          labelText: 'antecedentes',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey2.currentState!.validate()) {
                                      _processValues();
                                        }
                                      },
                                      child: const Text('P'),
                                    ),const SizedBox(height: 20),
                                  Text(
                                    _resultado,
                                    style: Theme.of(context).textTheme.headlineMedium,
                                  ),
                              ],
                          ),
                          ),
                        )
                      : _selectedOption == 'formulario4'
                          ? SizedBox(
                        height: 500, // Tamaño fijo para evitar restricciones infinitas
                        child: Formulario4(),
                      )
                    : Container(),
        ],
      ),
    ),
  );
}


}
