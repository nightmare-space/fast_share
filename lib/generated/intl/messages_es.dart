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
        "allDevices":
            MessageLookupByLibrary.simpleMessage("Todos los dispositivos"),
        "androidSAFTips": MessageLookupByLibrary.simpleMessage(
            "La arquitectura SAF de Android hará que seleccionar archivos desde la carpeta del sistema siempre copie uno, si usa el administrador de archivos incorporado de Speed Share, no aumentará el tamaño de la caché"),
        "apk": MessageLookupByLibrary.simpleMessage("Apk"),
        "appName": MessageLookupByLibrary.simpleMessage("Speed Share"),
        "autoDownload":
            MessageLookupByLibrary.simpleMessage("Descarga automática"),
        "cacheSize": m0,
        "camera": MessageLookupByLibrary.simpleMessage("Cámara"),
        "changeLog":
            MessageLookupByLibrary.simpleMessage("Registro de cambios"),
        "chatWindow": MessageLookupByLibrary.simpleMessage("Ventana de chat"),
        "chatWindowNotice": MessageLookupByLibrary.simpleMessage(
            "Actualmente no hay mensajes, haga clic para ver la lista de mensajes"),
        "classifyTips": MessageLookupByLibrary.simpleMessage(
            "Nota, después de que se active la clasificación de archivos, todos los archivos en la ruta de descarga se organizarán automáticamente"),
        "clearCache": MessageLookupByLibrary.simpleMessage("Limpiar caché"),
        "clearSuccess":
            MessageLookupByLibrary.simpleMessage("Éxito al limpiar"),
        "clipboardshare":
            MessageLookupByLibrary.simpleMessage("Compartir portapapeles"),
        "close": MessageLookupByLibrary.simpleMessage("Cerrar"),
        "common": MessageLookupByLibrary.simpleMessage("Común"),
        "connected": MessageLookupByLibrary.simpleMessage("Conectado"),
        "currenVersion": MessageLookupByLibrary.simpleMessage("Versión actual"),
        "currentRoom": MessageLookupByLibrary.simpleMessage("Sala de chat"),
        "developer": MessageLookupByLibrary.simpleMessage("Desarrollador"),
        "device": MessageLookupByLibrary.simpleMessage("Dispositivos"),
        "directory": MessageLookupByLibrary.simpleMessage("Directorio"),
        "disconnected": MessageLookupByLibrary.simpleMessage("Desconectado"),
        "doc": MessageLookupByLibrary.simpleMessage("Documento"),
        "downlaodPath":
            MessageLookupByLibrary.simpleMessage("Ruta de descarga"),
        "downloadTip": MessageLookupByLibrary.simpleMessage(
            "SpeedShare también es compatible con Windows, macOS y Linux"),
        "empty": MessageLookupByLibrary.simpleMessage("Vacío"),
        "enableFileClassification": MessageLookupByLibrary.simpleMessage(
            "Habilitar clasificación de archivos"),
        "enableWebServer":
            MessageLookupByLibrary.simpleMessage("Habilitar servidor web"),
        "enableWebServerTips": MessageLookupByLibrary.simpleMessage(
            "Después de habilitar, puede acceder al archivo en la ruta de descarga a través del navegador"),
        "fileDownloadSuccess": MessageLookupByLibrary.simpleMessage(
            "La descarga del archivo se ha completado"),
        "fileIsDownloading": MessageLookupByLibrary.simpleMessage(
            "El archivo se está descargando"),
        "fileType":
            MessageLookupByLibrary.simpleMessage("Correlación de archivos"),
        "headerNotice": m1,
        "home": MessageLookupByLibrary.simpleMessage("Inicio"),
        "image": MessageLookupByLibrary.simpleMessage("Imagen"),
        "inlineManager": MessageLookupByLibrary.simpleMessage(
            "Desde el administrador de archivos de la aplicación"),
        "inlineManagerTips": MessageLookupByLibrary.simpleMessage(
            "Utiliza el administrador de archivos de la aplicación"),
        "inputAddressTip": MessageLookupByLibrary.simpleMessage(
            "Ingrese la dirección IP del dispositivo"),
        "inputConnect":
            MessageLookupByLibrary.simpleMessage("Ingresar conexión"),
        "join": MessageLookupByLibrary.simpleMessage("Unirse"),
        "joinQQGroup": MessageLookupByLibrary.simpleMessage(
            "Unirse al grupo de retroalimentación de comunicación"),
        "lang": MessageLookupByLibrary.simpleMessage("Idioma"),
        "log": MessageLookupByLibrary.simpleMessage("Registro"),
        "messageNote": MessageLookupByLibrary.simpleMessage(
            "Vibrar al recibir un mensaje"),
        "music": MessageLookupByLibrary.simpleMessage("Música"),
        "new_line": MessageLookupByLibrary.simpleMessage("Nueva línea"),
        "nightmare": MessageLookupByLibrary.simpleMessage("Pesadilla"),
        "open": MessageLookupByLibrary.simpleMessage("Abrir"),
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
        "select": MessageLookupByLibrary.simpleMessage("Seleccionar"),
        "sendFile": MessageLookupByLibrary.simpleMessage("Enviar archivo"),
        "setting": MessageLookupByLibrary.simpleMessage("Ajustes"),
        "systemManager":
            MessageLookupByLibrary.simpleMessage("Desde el sistema"),
        "systemManagerTips": MessageLookupByLibrary.simpleMessage(
            "Utiliza el administrador de archivos del sistema"),
        "theTermsOfService":
            MessageLookupByLibrary.simpleMessage("Términos de servicio"),
        "ui": MessageLookupByLibrary.simpleMessage("Diseñador de interfaz"),
        "unknownFile":
            MessageLookupByLibrary.simpleMessage("Archivo desconocido"),
        "uploadFile": MessageLookupByLibrary.simpleMessage("Subir archivo"),
        "video": MessageLookupByLibrary.simpleMessage("Vídeo"),
        "vipTips": MessageLookupByLibrary.simpleMessage(
            "Esta función requiere una membresía para usar"),
        "zip": MessageLookupByLibrary.simpleMessage("Zip")
      };
}
