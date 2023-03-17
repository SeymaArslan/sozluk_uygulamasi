import 'package:flutter/material.dart';
import 'package:sozluk_uygulamasi/DetaySayfa.dart';
import 'package:sozluk_uygulamasi/Kelimeler.dart';
import 'package:sozluk_uygulamasi/Kelimelerdao.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Anasayfa(),
    );
  }
}

class Anasayfa extends StatefulWidget {

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {

  bool aramaYapiliyorMu = false;
  String aramaKelimesi = "";

  /*Future<List<Kelimeler>> tumKelimeleriGoster() async{    // tasarımDeneme
    // List türünde içerisinde kelimeler olan bir list oluşturacağız ve arayüzde bunu kullanacağız
    var kelimelerListesi = <Kelimeler>[];

    var k1 = Kelimeler(1, "dog", "köpek");
    var k2 = Kelimeler(2, "flower", "çiçek");
    var k3 = Kelimeler(3, "stone", "taş");
    var k4 = Kelimeler(4, "baby", "bebek");

    kelimelerListesi.add(k1);
    kelimelerListesi.add(k2);
    kelimelerListesi.add(k3);
    kelimelerListesi.add(k4);

    return kelimelerListesi;
  }*/

  Future<List<Kelimeler>> tumKelimeleriGoster() async{
    var kelimelerListesi = await Kelimelerdao().tumKelimeler();
    return kelimelerListesi;
  }

  Future<List<Kelimeler>> aramaYap(String aramaKelimesi) async{
    var kelimelerListesi = await Kelimelerdao().kelimeAra(aramaKelimesi);
    return kelimelerListesi;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: aramaYapiliyorMu
            ? TextField(
                decoration: InputDecoration(
                    hintText: "Arama için bir şey yazın"),
                    onChanged: (aramaSonucu){
                      print("Arama sonucu : $aramaSonucu");
                      setState(() {
                        aramaKelimesi = aramaSonucu;
                      });
                    },
              )
            : Text("SÖZLÜK UYGULAMASI") ,
        actions:[
          aramaYapiliyorMu
              ? IconButton(
                onPressed: (){
                setState(() {
                  aramaYapiliyorMu = false;
                  aramaKelimesi = "";
                });
                },
                  icon: Icon(Icons.cancel),
                )
              : IconButton(
              onPressed: (){
                setState(() {
                  aramaYapiliyorMu = true;
                });
              },
              icon: Icon(Icons.search),
          ),
        ],
      ),
      body: FutureBuilder<List<Kelimeler>>(
        future: aramaYapiliyorMu ? aramaYap(aramaKelimesi) : tumKelimeleriGoster(), // aramaYapılıyorMu false ise normal arayüz görünecek, true ise girdiğimiz harfi içeren kelimeleri göstereecek
        builder: (context, snapshot){
          if(snapshot.hasData){
            var kelimelerListesi = snapshot.data;
            return ListView.builder(
                itemCount: kelimelerListesi!.length,
                itemBuilder: (context,indeks){
                  var kelime = kelimelerListesi[indeks];
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetaySayfa(kelime: kelime)));
                    },
                    child: SizedBox( height: 50,
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(kelime.ingilizce, style: TextStyle(fontWeight: FontWeight.bold),),
                            Text(kelime.turkce),
                          ],
                        ),
                      ),
                    ),
                  );
                },
            );
          } else  {
            return Center();
          }
        },
      ),
    );
  }
}
