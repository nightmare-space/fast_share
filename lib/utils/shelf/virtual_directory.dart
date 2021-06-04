library shelf_virtual_directory;

import 'dart:io';

import 'package:global_repository/global_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mime/mime.dart' as mime;

class ShelfVirtualDirectory {
  final String folderPath;
  final String defaultFile;
  final String default404File;
  final bool showLogs;

  Router _router;
  Directory _rootDir;
  Cascade _cascade;

  /// Creates a instance of [Handler]
  Handler get handler => _cascade.handler;

  /// Returns a instance of [Router]
  ///
  /// Can be used to mount as a subroute
  ///
  /// ```
  /// final router = Router('/',ShelfVirtualDirectory('web').router);// localhost:8080/
  /// //or
  /// final router = Router('/home/',ShelfVirtualDirectory('web').router);//localhost:8080/home/
  /// ```
  Router get router => _router;

  /// Returns a instance of [Cascade]
  ///
  /// Can be used to directly serve from server
  /// ```
  /// import 'package:shelf/shelf_io.dart' as io show serve;
  ///
  /// final cascade = ShelfVirtualDirectory('web').cascade;
  /// io.serve(cascade,'localhost',8080).then((server){
  ///   print('Server is sunning at ${server.address}:${server.port}'),
  /// })
  ///
  /// ```
  Cascade get cascade => _cascade;

  /// Creates a instance of [ShelfVirtualDirectory]
  ///
  /// ## Parameters
  /// - `folderPath`: Name of the directory you want to serve from the *current folder*
  ///
  /// - `defaultFile`: File name that will be served. *Default: index.html*
  ///
  /// - `default404File`: File name that will be served for 404. *Default: 404.html*
  ///
  /// - `showLogs`: Shows logs from the ShelfVirtualDirectory. *Default: true*
  ///
  /// ## Examples
  ///
  /// You can get router or handler or cascade from [ShelfVirtualDirectory]
  /// instance
  /// ```dart
  ///
  /// final virDirRouter = ShelfVirtualDirectory(folderToServe);
  ///
  /// final staticFileHandler = const Pipeline()
  ///     .addMiddleware(logRequests())
  ///     .addHandler(virDirRouter.handler);
  ///
  /// io.serve(Cascade().add(staticFileHandler).handler,address,port).then((server){
  ///     print('Server is sunning at ${server.address}:${server.port}'),
  /// });
  ///```
  ShelfVirtualDirectory(
    this.folderPath, {
    this.defaultFile = 'index.html',
    this.default404File = '404.html',
    this.showLogs = true,
  }) {
    _rootDir = Directory(Platform.script.resolve(folderPath).toFilePath());
    _router = Router();
    _cascade = Cascade().add((req) => _router.call(req));
    _initilizeRoutes();
  }

  // initilize route
  Future<void> _initilizeRoutes() async {
    if (!await _rootDir.exists()) {
      throw ArgumentError(
        'A directory corresponding to folderPath '
        '"$folderPath" could not be found',
      );
    }
    // collects all the files from the
    final rootDirSubFolders = await _rootDir.list(recursive: false).toList();
    Log.d(rootDirSubFolders);
    Log.w(_rootDir.uri.pathSegments);
    var rootFolderName;
    if (folderPath == '/') {
      rootFolderName = '/';
    } else {
      rootFolderName = ([..._rootDir.uri.pathSegments]..removeLast()).last;
    }

    for (var entity in rootDirSubFolders) {
      final fileName = entity.uri.pathSegments.last;
      // filters out files from the folders
      if (fileName.isNotEmpty) {
        // trims path before [folderPath]
        final filePath = entity.uri;
        final fileRoute = entity.uri.pathSegments
            .sublist(entity.uri.pathSegments.indexOf(rootFolderName) + 1)
            .join('/');
        _logToConsole(
            '✅ Found FilePath: /$rootFolderName/$fileRoute | FileName: $fileName | Content-Type: ${mime.lookupMimeType(filePath.path)}');
        // adds file to all the routes
        _router.get('/$fileRoute', (_) => _serveFile(filePath));
      }
    }

    // serves index.html as default file
    await _setUpIndexPage();
    // serves 404.html as default file
    await _setUp404Page();
  }

  Future<void> _setUpIndexPage() async {
    final filePath = '${_rootDir.path}/$defaultFile';
    final headers = await _getFileHeaders(File(filePath));
    if (headers.isEmpty) {
      // if "index.html" does not exist
      _router.all(
          '/',
          (_) => Response.notFound(
              '"$defaultFile" file does not exist in root directory'));
    }
    _router.all('/', (_) => _serveFile(Uri.file(filePath)));
  }

  Future<void> _setUp404Page() async {
    final filePath = '${_rootDir.path}/$default404File';
    final headers = await _getFileHeaders(File(filePath));
    if (headers.isEmpty) {
      // if "404.html" does not exist
      _router.all('/<.*>', (_) => Response.notFound(':/ No default 404 page'));
    }
    _router.all(
        '/<.*>', (_) => _serveFile(Uri.file(filePath), statusCode: 400));
  }

  // serves 404 page to static handlers
  // Future<Response> _serve404Page() async {
  //   final filePath = '${_rootDir.path}/$default404File';
  //   final headers = await _getFileHeaders(File(filePath));
  //   if (headers.isEmpty) {
  //     // if "404.html" does not exist
  //     return Response.notFound(':/ No default 404 page');
  //   }
  //   return _serveFile(Uri.file(filePath), statusCode: 400);
  // }

  // serves file
  Future<Response> _serveFile(Uri fileUri, {int statusCode = 200}) async {
    final file = File.fromUri(fileUri);
    try {
      if (!await file.exists()) {
        // or default 404 page
        return Response.notFound('NotFound');
      }
      return Response(
        statusCode,
        body: file.openRead(),
        headers: await _getFileHeaders(file),
      );
    } catch (e) {
      print(e);
      return Response.internalServerError();
    }
  }

  // returns fileheaders
  Future<Map<String, Object>> _getFileHeaders(File file) async {
    if (!await file.exists()) {
      return {};
    }
    return {
      HttpHeaders.contentTypeHeader: mime.lookupMimeType(file.path) ?? '',
      HttpHeaders.contentLengthHeader: (await file.length()).toString(),
    };
  }

  // prints logs
  void _logToConsole(String message) {
    if (showLogs) print('[ShelfVirtualDirectory] $message');
  }
}
