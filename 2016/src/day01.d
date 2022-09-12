import std.file;

int main() {
    auto fh = File("input.txt", "r");
    auto buf = fh.rawRead(new char[]);
    fh.close();
    writeln(buf);
}
