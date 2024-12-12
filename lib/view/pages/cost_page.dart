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
  bool isLoading = false; // Flag to manage loading state

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
            // Main UI content
            Container(
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Card(
                      color: Colors.white,
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Courier Dropdown
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
                                    items: ['jne', 'Lion', 'Tiki', 'SiCepat']
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
                                      labelText: 'Berat (kg)',
                                      border: OutlineInputBorder(),
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
                                Text(
                                  "Origin",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            // Origin Province and City Dropdowns
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
                                          return const Text(
                                              "Select a province first");
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
                                Text(
                                  "Destination",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            // Destination Province and City Dropdowns
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
                                          return const Text(
                                              "Select a province first");
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
                            ElevatedButton(
                              onPressed: () {
                                if (selectedCity != null &&
                                    selectedCity2 != null &&
                                    berat.text != "" &&
                                    selectedCourier != "") {
                                  setState(() {
                                    isLoading = true; // Show loading overlay
                                  });
                                  homeViewModel
                                      .getCostList(
                                          selectedCity.cityId.toString(),
                                          selectedCity2.cityId.toString(),
                                          int.parse(berat.text),
                                          selectedCourier.toString())
                                      .then((_) {
                                    setState(() {
                                      isLoading = false; // Hide loading overlay
                                    });
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
                              child: const Text('Calculate Cost'),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    flex: 1,
                    child: Visibility(
                      visible: !isLoading,
                      child: Consumer<HomeViewmodel>(
                        builder: (context, value, _) {
                          switch (value.CostList.status) {
                            case Status.loading:
                              return Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "There is no data",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ));
                            case Status.error:
                              return Align(
                                  alignment: Alignment.center,
                                  child:
                                      Text(value.CostList.message.toString()));
                            case Status.completed:
                              return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0),
                                  child: ListView.builder(
                                    itemCount: value.CostList.data?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      return CardCost(value.CostList.data!
                                          .elementAt(index));
                                    },
                                  ));
                            default:
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
