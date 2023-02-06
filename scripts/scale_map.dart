import 'dart:io' as io;

void main() async {
  var x = List<Future>.empty(growable: true);
  for (var file in io.Directory("./offlineMap").listSync(recursive: true)) {
    if ((await file.stat()).type == io.FileSystemEntityType.directory) continue;

    x.add(io.Process.run(r"C:\userdata\binaries\realesrgan\realesrgan-ncnn-vulkan.exe", ["-i", file.path, "-o", file.path], stdoutEncoding: const io.SystemEncoding(), stderrEncoding: const io.SystemEncoding()));
  }

  Future.wait(x);
}
