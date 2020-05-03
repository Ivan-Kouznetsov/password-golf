import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

class PwnedPasswordsClient{
  String _url;
  PwnedPasswordsClient({url = 'https://api.pwnedpasswords.com/range/'}){
    _url = url;
  }

  String _stringSha1Hash(String s){
    var bytes = utf8.encode(s);
    var digest = sha1.convert(bytes);
    return digest.toString().toUpperCase();
  }

  Future<int> getCount(String password) async {
    const prefixLength = 5;
    final hash = _stringSha1Hash(password);
    var request = await HttpClient().getUrl(Uri.parse(_url + hash.substring(0,prefixLength)));
    var response = await request.close();
   
    await for (String line in response.transform(Utf8Decoder()).transform(LineSplitter())){       
        if(line.contains(':')){
          final lineParts = line.split(':');
          if (lineParts[0]==hash.substring(prefixLength)) return int.tryParse(lineParts[1])?? 0;
        }
    }

    return 0;
  }

}
