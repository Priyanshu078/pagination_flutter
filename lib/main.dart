import 'package:flutter/material.dart';
import 'package:pagination_example/pagination_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StateProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    final stateProvider = Provider.of<StateProvider>(context, listen: false);
    stateProvider.fetchData(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Consumer<StateProvider>(builder: (context, model, _) {
        return model.uiState == UiState.fetching
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : model.uiState == UiState.fetched
                ? ListView.builder(
                    itemCount: model.list.length + 1,
                    itemBuilder: (context, index) {
                      if (index == model.list.length) {
                        return model.paginationState == PaginationState.fetched
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: InkWell(
                                      onTap: () {
                                        Provider.of<StateProvider>(context,
                                                listen: false)
                                            .fetchData(false);
                                      },
                                      child: const Center(
                                          child: Text("Load More"))),
                                ))
                            : model.paginationState == PaginationState.fetching
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Container();
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(child: Text("Card no.${index + 1}")),
                          ),
                        );
                      }
                    },
                  )
                : model.uiState == UiState.error
                    ? const Center(
                        child: Text("Error"),
                      )
                    : Container();
      }),
    );
  }
}
