import 'package:client/src/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnginePage extends ConsumerWidget {
  const EnginePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engineData = ref.watch(engineViewModelProvider);
    final parameters = ref.watch(engineParametersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ship Engine Monitor'),
        backgroundColor: const Color(0xFF444444),
      ),
      body: engineData == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: const Color(0xFF333333),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Connected - Last update: ${engineData.timestamp.toLocal().toString().substring(0, 19)}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              dataTableTheme: DataTableThemeData(
                                headingTextStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                dataTextStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                dividerThickness: 0.5,
                              ),
                            ),
                            child: DataTable(
                              headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => const Color(0xFF444444)),
                              dataRowColor: MaterialStateColor.resolveWith(
                                  (states) => const Color(0xFF555555)),
                              columnSpacing: 16,
                              horizontalMargin: 8,
                              headingRowHeight: 40,
                              dataRowMinHeight: 36,
                              dataRowMaxHeight: 36,
                              border: TableBorder(
                                horizontalInside: BorderSide(
                                  width: 1,
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                              ),
                              columns: const [
                                DataColumn(
                                  label: SizedBox(
                                    width: 60,
                                    child: Text('Tag'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 200,
                                    child: Text('Description'),
                                  ),
                                ),
                                DataColumn(
                                  numeric: true,
                                  label: SizedBox(
                                    width: 60,
                                    child: Text('Value'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 60,
                                    child: Text('Units'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 80,
                                    child: Text('Limits'),
                                  ),
                                ),
                                DataColumn(
                                  numeric: true,
                                  label: SizedBox(
                                    width: 40,
                                    child: Text('DT'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 70,
                                    child: Text('Status'),
                                  ),
                                ),
                              ],
                              rows: parameters.map<DataRow>((param) {
                                Color rowColor = const Color(0xFF555555);
                                bool isEven =
                                    parameters.indexOf(param) % 2 == 0;
                                if (isEven) {
                                  rowColor = const Color(0xFF505050);
                                }

                                return DataRow(
                                  color: MaterialStateColor.resolveWith(
                                      (states) => rowColor),
                                  cells: [
                                    DataCell(Text(param.tag)),
                                    DataCell(Text(param.description)),
                                    DataCell(
                                      Container(
                                        alignment: Alignment.centerRight,
                                        width: 60,
                                        child: Text(
                                          param.value.toStringAsFixed(1),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 60,
                                        child: Text(
                                          param.units,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 80,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              param.limitType,
                                              style: TextStyle(
                                                color: param.limitType == 'H'
                                                    ? Colors.red.shade200
                                                    : param.limitType == 'L'
                                                        ? Colors.blue.shade200
                                                        : Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(param.limit.toString()),
                                          ],
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 40,
                                        child: Center(
                                          child: Text(param.dt.toString()),
                                        ),
                                      ),
                                    ),
                                    DataCell(_buildStatusCell(param.status)),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatusCell(String status) {
    Color backgroundColor;
    Color textColor = Colors.white;

    switch (status.toLowerCase()) {
      case 'normal':
        backgroundColor = Colors.green;
        break;
      case 'alarm':
        backgroundColor = Colors.red;
        break;
      case 'off':
        backgroundColor = Colors.amber;
        textColor = Colors.black;
        break;
      default:
        backgroundColor = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
