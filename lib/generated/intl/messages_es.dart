// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'es';

  static String m0(number) =>
      "${Intl.plural(number, other: 'Tamaño de caché actual ${number}MB')}";

  static String m1(number) =>
      "${Intl.plural(number, zero: 'No devices connect', other: 'have ${number} connected')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("Acerca de Speed Share"),
        "aboutSpeedShare":
            MessageLookupByLibrary.simpleMessage("Acerca de Speed Share"),
        "apk": MessageLookupByLibrary.simpleMessage("Apk"),
        "appName": MessageLookupByLibrary.simpleMessage("Speed Share"),
        "autoDownload":
            MessageLookupByLibrary.simpleMessage("Descarga automática"),
        "cacheSize": m0,
        "changeLog":
            MessageLookupByLibrary.simpleMessage("Registro de cambios"),
        "chatWindow": MessageLookupByLibrary.simpleMessage("Ventana de chat"),
        "chatWindowNotice": MessageLookupByLibrary.simpleMessage(
            "Actualmente no hay mensajes, haga clic para ver la lista de mensajes"),
        "clearCache": MessageLookupByLibrary.simpleMessage("Limpiar caché"),
        "clearSuccess":
            MessageLookupByLibrary.simpleMessage("Éxito al limpiar"),
        "clipboardshare":
            MessageLookupByLibrary.simpleMessage("Compartir portapapeles"),
        "common": MessageLookupByLibrary.simpleMessage("Común"),
        "currenVersion": MessageLookupByLibrary.simpleMessage("Versión actual"),
        "currentRoom": MessageLookupByLibrary.simpleMessage("Sala de chat"),
        "developer": MessageLookupByLibrary.simpleMessage("Desarrollador"),
        "directory": MessageLookupByLibrary.simpleMessage("Directorio"),
        "doc": MessageLookupByLibrary.simpleMessage("Documento"),
        "downlaodPath":
            MessageLookupByLibrary.simpleMessage("Ruta de descarga"),
        "downloadTip": MessageLookupByLibrary.simpleMessage(
            "SpeedShare también es compatible con Windows, macOS y Linux"),
        "empty": MessageLookupByLibrary.simpleMessage("Vacío"),
        "enableFileClassification": MessageLookupByLibrary.simpleMessage(
            "Habilitar clasificación de archivos"),
        "enbaleWebServer":
            MessageLookupByLibrary.simpleMessage("Habilitar servidor web"),
        "headerNotice": m1,
        "image": MessageLookupByLibrary.simpleMessage("Imagen"),
        "inputConnect":
            MessageLookupByLibrary.simpleMessage("Ingresar conexión"),
        "joinQQGroup": MessageLookupByLibrary.simpleMessage(
            "Unirse al grupo de retroalimentación de comunicación"),
        "lang": MessageLookupByLibrary.simpleMessage("Idioma"),
        "log": MessageLookupByLibrary.simpleMessage("Registro"),
        "messageNote": MessageLookupByLibrary.simpleMessage(
            "Vibrar al recibir un mensaje"),
        "music": MessageLookupByLibrary.simpleMessage("Música"),
        "nightmare": MessageLookupByLibrary.simpleMessage("Pesadilla"),
        "openSource": MessageLookupByLibrary.simpleMessage("Código abierto"),
        "otherVersion":
            MessageLookupByLibrary.simpleMessage("Descargar otra versión"),
        "privacyAgreement":
            MessageLookupByLibrary.simpleMessage("Acuerdo de privacidad"),
        "projectBoard": MessageLookupByLibrary.simpleMessage(
            "Panel de proyecto de la serie Nightmare"),
        "qrTips": MessageLookupByLibrary.simpleMessage(
            "Deslice hacia un lado para cambiar de IP"),
        "recentConnect":
            MessageLookupByLibrary.simpleMessage("Conexión reciente"),
        "recentFile":
            MessageLookupByLibrary.simpleMessage("Archivos recientes"),
        "recentImg": MessageLookupByLibrary.simpleMessage("Imágenes recientes"),
        "remoteAccessDes": MessageLookupByLibrary.simpleMessage(
            "Puede administrar los archivos locales abriendo esta IP en el navegador."),
        "remoteAccessFile": MessageLookupByLibrary.simpleMessage(
            "Archivo local de acceso remoto"),
        "scan": MessageLookupByLibrary.simpleMessage("Escanear código QR"),
        "setting": MessageLookupByLibrary.simpleMessage("Ajustes"),
        "theTermsOfService":
            MessageLookupByLibrary.simpleMessage("Términos de servicio"),
        "ui": MessageLookupByLibrary.simpleMessage("Diseñador de interfaz"),
        "unknownFile":
            MessageLookupByLibrary.simpleMessage("Archivo desconocido"),
        "video": MessageLookupByLibrary.simpleMessage("Vídeo"),
        "zip": MessageLookupByLibrary.simpleMessage("Zip")
      };
}
