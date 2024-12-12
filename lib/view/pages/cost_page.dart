part of 'pages.dart';

class CostPage extends StatefulWidget {
  const CostPage({super.key});

  @override
  State<CostPage> createState() => _CostPageState();
}

class _CostPageState extends State<CostPage> {
  HomeViewmodel homeViewModel = HomeViewmodel();

  @override
  void initState() {
    homeViewModel.getProvinceList();
    super.initState();
  }

  dynamic selectedProvince;
  dynamic selectedCourier;
  dynamic selectedCity;
  dynamic selectedProvince2;
  dynamic selectedCity2;
  final berat = TextEditingController();
  bool isLoading = false;

  String formatuang(int? value) {
    if (value == null) return "Rp0,00";
    final formatuanga = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 2,
    );
    return formatuanga.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Calculate Cost"),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider<HomeViewmodel>(
        create: (context) => homeViewModel,
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: [
                  Flexible(
                    flex: 3,
                    child: Card(
                      color: Colors.white,
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: selectedCourier,
                                    hint: const Text('Select Courier'),
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 30,
                                    elevation: 2,
                                    style: const TextStyle(color: Colors.black),
                                    items: ['jne', 'pos', 'tiki']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedCourier = newValue!;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 1,
                                  child: TextField(
                                    controller: berat,
                                    decoration: const InputDecoration(
                                      labelText: 'Berat (gr)',
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      setState(() {
                                        print("Berat: ${berat.text}");
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    "Origin",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Consumer<HomeViewmodel>(
                                    builder: (context, value, _) {
                                      switch (value.provincelist.status) {
                                        case Status.loading:
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        case Status.error:
                                          return Text(value.provincelist.message
                                              .toString());
                                        case Status.completed:
                                          return DropdownButton(
                                            isExpanded: true,
                                            value: selectedProvince,
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            iconSize: 30,
                                            elevation: 2,
                                            hint: const Text('Select Province'),
                                            style: const TextStyle(
                                                color: Colors.black),
                                            items: value.provincelist.data!.map<
                                                    DropdownMenuItem<Province>>(
                                                (Province value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                    value.province.toString()),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedProvince = newValue;
                                                selectedCity = null;
                                                homeViewModel.getCityListOrigin(
                                                    selectedProvince
                                                        .provinceId);
                                              });
                                            },
                                          );
                                        default:
                                          return Container();
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Consumer<HomeViewmodel>(
                                    builder: (context, value, _) {
                                      switch (value.CityListOrigin.status) {
                                        case Status.loading:
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        case Status.error:
                                          return Text(value
                                              .CityListOrigin.message
                                              .toString());
                                        case Status.completed:
                                          return DropdownButton(
                                            isExpanded: true,
                                            value: selectedCity,
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            iconSize: 30,
                                            elevation: 2,
                                            hint: const Text('Select City'),
                                            style: const TextStyle(
                                                color: Colors.black),
                                            items: value.CityListOrigin.data!
                                                .map<DropdownMenuItem<City>>(
                                                    (City value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                    value.cityName.toString()),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedCity = newValue;
                                              });
                                            },
                                          );
                                        default:
                                          return Container();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    "Destination",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Consumer<HomeViewmodel>(
                                    builder: (context, value, _) {
                                      switch (value.provincelist.status) {
                                        case Status.loading:
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        case Status.error:
                                          return Text(value.provincelist.message
                                              .toString());
                                        case Status.completed:
                                          return DropdownButton(
                                            isExpanded: true,
                                            value: selectedProvince2,
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            iconSize: 30,
                                            elevation: 2,
                                            hint: const Text(
                                                'Select Destination Province'),
                                            style: const TextStyle(
                                                color: Colors.black),
                                            items: value.provincelist.data!.map<
                                                    DropdownMenuItem<Province>>(
                                                (Province value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                    value.province.toString()),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedProvince2 = newValue;
                                                selectedCity2 = null;
                                                homeViewModel
                                                    .getCityListDestination(
                                                        selectedProvince2
                                                            .provinceId);
                                              });
                                            },
                                          );
                                        default:
                                          return Container();
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Consumer<HomeViewmodel>(
                                    builder: (context, value, _) {
                                      switch (
                                          value.CityListDestination.status) {
                                        case Status.loading:
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        case Status.error:
                                          return Text(value
                                              .CityListDestination.message
                                              .toString());
                                        case Status.completed:
                                          return DropdownButton(
                                            isExpanded: true,
                                            value: selectedCity2,
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            iconSize: 30,
                                            elevation: 2,
                                            hint: const Text('Select City'),
                                            style: const TextStyle(
                                                color: Colors.black),
                                            items: value
                                                .CityListDestination.data!
                                                .map<DropdownMenuItem<City>>(
                                                    (City value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                    value.cityName.toString()),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedCity2 = newValue;
                                              });
                                            },
                                          );
                                        default:
                                          return Container();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 9),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (selectedCity != null &&
                                      selectedCity2 != null &&
                                      berat.text != "" &&
                                      selectedCourier != "") {
                                    setState(() {});
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text(
                                            "checking all costs"),
                                        content: const Text(
                                            "checking all costs please wait"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                    
                                    homeViewModel
                                        .getCostList(
                                            selectedCity.cityId.toString(),
                                            selectedCity2.cityId.toString(),
                                            int.parse(berat.text),
                                            selectedCourier.toString())
                                        .then((_) {
                                      setState(() {});
                                    });
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text(
                                            "Please Complete All Fields"),
                                        content: const Text(
                                            "All fields are required to proceed."),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3.0),
                                  ),
                                ),
                                child: const Text('Calculate shipping cost'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Visibility(
                      visible: !isLoading,
                      child: Consumer<HomeViewmodel>(
                        builder: (context, value, _) {
                          if (value.CostList.status == Status.loading) {
                            return Align(
                              alignment: Alignment.center,
                              child: Text(
                                "There is no data",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            );
                          } else if (value.CostList.status == Status.error) {
                            return Align(
                              alignment: Alignment.center,
                              child: Text(value.CostList.message.toString()),
                            );
                          } else if (value.CostList.status ==
                              Status.completed) {
                            final costs = value.CostList.data;
                           

                            if (costs != null && costs.isNotEmpty) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: costs.map((a_costs) {
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      margin: EdgeInsetsDirectional.symmetric(
                                          vertical: 6, horizontal: 16),
                                      color: Colors.white,
                                      elevation: 4,
                                      shadowColor: Colors.black.withOpacity(1),
                                      child: ListTile(
                                          title: Text(
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                              "${a_costs.description} (${a_costs.service})"),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                  "Biaya: ${formatuang(a_costs.cost![0].value ?? 0)}"),
                                              SizedBox(height: 4),
                                              Text(
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                  "Estimasi sampai: ${a_costs.cost![0].etd ?? ''} hari"),
                                            ],
                                          ),
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.blue,
                                            child: Icon(Icons.local_shipping,
                                                color: Colors.white),
                                          )),
                                    );
                                  }).toList(),
                                ),
                              );

                            } else {
                              // Handle empty costs
                              return Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "No cost data available",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              );
                            }
                          } else {
                            return Container();
                          }
                          ;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
          ],
        ),
      ),
    );
  }
}
