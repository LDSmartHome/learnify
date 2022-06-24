import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learnify/util/dataset.dart';
import 'package:learnify/widget/menu.dart';

class ViewDataset extends StatefulWidget {
  const ViewDataset({Key? key}) : super(key: key);

  @override
  State<ViewDataset> createState() => _ViewDatasetState();
}

class _ViewDatasetState extends State<ViewDataset> {
  @override
  Widget build(BuildContext context) {
    final datasetDoc = ModalRoute.of(context)!.settings.arguments as String;

    return MenuWidget(
      title: "View",
      body: Center(
        child: FutureBuilder<List<dynamic>>(
            future: Future.wait([
              DataSet.getDataByID(datasetDoc),
              DataSet.getInfoByID(datasetDoc),
            ]),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  padding: const EdgeInsets.all(10),
                  children: [
                    Card(
                      child: ListTile(
                        title: const Text("Name"),
                        subtitle: Text(snapshot.data![1].data()["name"]),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text("Description"),
                        subtitle: Text(snapshot.data![1].data()["description"]),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text("Type"),
                        subtitle: Text(snapshot.data![1].data()["type"]),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text("Private"),
                        subtitle: Text(snapshot.data![1].data()["private"].toString()),
                      ),
                    ),
                    const Divider(),
                    ...snapshot.data![0].docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.list),
                          trailing: Text(
                            document.id,
                            style: const TextStyle(
                                color: Colors.green, fontSize: 15),
                          ),
                          title: Text(data['key']),
                          subtitle: Text(data['value']),
                        ),
                      );
                    }).toList(),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
