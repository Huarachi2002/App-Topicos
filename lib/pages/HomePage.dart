import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}



  class _HomePageState extends State<HomePage> {
    List<Map<String, dynamic>> languages = [];
    String source_language = 'es';
    String target_language = 'en';
    String text = '';
    late TextEditingController _controller;

    @override
    void initState() {
      super.initState();
      _controller = TextEditingController();
      getLenguajes();
    }

    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

    Future<void> postTraduccion() async {
      try {
        final response = await Dio().post(
          'https://text-translator2.p.rapidapi.com/translate',
          options: Options(
            headers: {
              'content-type': 'application/x-www-form-urlencoded',
              'X-RapidAPI-Key': '49d7f1a00fmsh516f08c8b29ebbdp1671abjsncbd09299705f',
              'X-RapidAPI-Host': 'text-translator2.p.rapidapi.com',
            },
          ),
          data: {
            'source_language': source_language,
            'target_language': target_language,
            'text': _controller.text
          }
        );
        setState(() {
          text = response.data['data']['translatedText'];
        });
        print(text);
      } catch (e) {
        print('Error fetching languages: $e');
      }
    }

    Future<void> getLenguajes() async {
      try {
      final response = await Dio().get(
        'https://text-translator2.p.rapidapi.com/getLanguages',
        options: Options(
          headers: {
            'X-RapidAPI-Key': '49d7f1a00fmsh516f08c8b29ebbdp1671abjsncbd09299705f',
            'X-RapidAPI-Host': 'text-translator2.p.rapidapi.com',
          },
        ),
      );

        // Process the response
        for (var i = 0; i < response.data['data']['languages'].length; i++) {
          // print(response.data['data']['languages'][i]);
          languages.add(response.data['data']['languages'][i]);
          // print(response.data['data']['languages'][i]['code']);
        }
      //  print(response.data['data']['languages'][0]);
      } catch (e) {
        print('Error fetching languages: $e');
      } finally {
        setState(() {}); // Update UI after processing
      }
    }

    @override
    Widget build(BuildContext context) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                width: 200,
                child: TextField(
                  controller: _controller,
                  onSubmitted: (value) {
                    setState(() {
                      _controller.text = value;
                      print(_controller.text);
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Texto',
                    ),
                  ),
                ),
                DropdownMenu<String>(
                  width: 110,
                  label: const Text('De'),
                  initialSelection: source_language,  
                  onSelected: (value) {
                    setState(() {
                      source_language = value!;
                      print(source_language);
                    });
                  },
                  dropdownMenuEntries: languages.map((value){
                    return DropdownMenuEntry<String>(value: value['code'], label: value['name']);
                  }).toList(),
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            DropdownMenu<String>(
              width: 250,
              label: const Text('A'),
              initialSelection: target_language,
              onSelected: (value) {
                setState(() {
                  target_language = value!;
                  print(target_language);
                });
              },
              dropdownMenuEntries: languages.map((value){
                return DropdownMenuEntry<String>(value: value['code'], label: value['name']);
              }).toList(),
            ),
            const SizedBox(
              height: 40,
            ),
            TextButton.icon(
              onPressed: () {
                postTraduccion();
              }, 
              icon: const Icon(Icons.translate), 
              label: const Text('Traducir')
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              (text.isEmpty)
              ? ''
              : 'Traduccion: $text',
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      );
    }
  }

  class Language {
      String code;
      String name;

      Language({
          required this.code,
          required this.name,
      });

  }