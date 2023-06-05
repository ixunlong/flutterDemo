import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/asymmetric/api.dart';

class RsaUtil {
  static late Encrypter _encrypter;

  static Encrypter get encrypter => _encrypter;

  static init() async {
    // final pvk = await parseKeyFromFile<RSAPrivateKey>("assets/files/rsa_private_key.pem");
    // final pubk = await parseKeyFromFile<RSAPublicKey>("assets/files/rsa_public_key.pem");
    // final pvkStr = await rootBundle.loadString("assets/files/rsa_private_key.pem");
    final pubkStr =
        await rootBundle.loadString("assets/files/rsa_public_key.pem");
    // final pvk = RSAKeyParser().parse(pvkStr) as RSAPrivateKey;
    final pubk = RSAKeyParser().parse(pubkStr) as RSAPublicKey;
    _encrypter = Encrypter(RSA(publicKey: pubk));
  }
}
