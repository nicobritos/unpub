import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:args/args.dart';
import 'package:unpub/unpub.dart';
import 'package:unpub/unpub_file.dart';
import 'package:unpub/unpub_mongo.dart';

main(List<String> args) async {
  var parser = ArgParser();
  parser.addOption('host', abbr: 'h', defaultsTo: '0.0.0.0');
  parser.addOption('port', abbr: 'p', defaultsTo: '3000');

  var results = parser.parse(args);

  var host = results['host'] as String;
  var port = int.parse(results['port'] as String);

  if (results.rest.isNotEmpty) {
    print('Got unexpected arguments: "${results.rest.join(' ')}".\n\nUsage:\n');
    print(parser.usage);
    exit(1);
  }

  var baseDir = path.absolute('unpub-data');

  var repository = UnpubRepository(
    metaStore:
        await UnpubMongo.connect('mongodb://localhost:27017/dart_pub_test'),
    packageStore: UnpubFileStore(baseDir),
    shouldCheckUploader: false,
  );
  var server = UnpubServer(repository);
  server.serve(host, port);
}
