const std = @import("std");
const stdout = std.io.getStdOut().writer();
const allocPrint = std.fmt.allocPrint;
const print = std.debug.print;
const exit = std.os.linux.exit;
const Child = std.process.Child;

// Pranešimų rinkinys kalbai
const LangMessages = struct {
  err: []const u8 = "",
  succ: []const u8 = ""
};

// Pranešimų medžio struktūra
const Messages = struct {
  en: LangMessages,
  lt_LT: LangMessages,

  // Motodas pranešimui iš masyvo paimti pagal raktą
  pub fn get(self:Messages, name: []const u8) LangMessages {
    if (std.mem.eql(u8, name, "en")) {
      return self.en;
    } else if (std.mem.eql(u8, name, "lt_LT")) {
      return self.lt_LT;
    } else {
      return LangMessages{.err = "!!!", .succ = "!!!"};
    }
  }
};

// Išorinių komandų iškvietimo funkcija
fn runCmd(cmdArg: []const u8, langMessages: LangMessages) !void {
  //Sukuriamas alocatorius
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit(); // alocatorius deinicializuojamas, išeinant iš funkcijos
  const allocator = arena.allocator();

  // Sukuria komandos tekstinę eilutę iš funkcijos argumento
  const command = try allocPrint(allocator, "{s} {s}", .{"sudo", cmdArg});
  defer allocator.free(command);

  // Generuoja skirtuką, visus komandos $command simbolius pakeisdamas "-" simboliu
  // allocator.alloc(u8, command.len) - sukuriama tuščia komandos ilgio eilutė
  // while (...)... - kiekvienas to eilutės ženklas pakeičiamas '-' simboliu
  var separator = try allocator.alloc(u8, command.len);
  defer allocator.free(separator);
  var i: usize = 0;
  while (i < separator.len) : (i += 1) {
    separator[i] = '-';
  }

  // Išveda komandos eilutę, apsuptą skirtuko eilučių
  print("{s}\n{s}\n{s}\n\n", .{separator, command, separator});

  // Sukuriamas argumentų masyvas
  var cmdArgsList = std.ArrayList([]const u8).init(allocator);
  var iterator = std.mem.splitScalar(u8, command, ' ');
    while (iterator.next()) |x| {
    try cmdArgsList.append(x);
  }

  // Ir argumentųsukuriamas ir įvykdomas procesas, išėjimo kodas išsaugomas kintamjame
  var child = Child.init(cmdArgsList.items, allocator);
  try child.spawn();
  const exitCode = try child.wait();

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if (exitCode.Exited > 0) {
    print("\n{s}\n\n", .{langMessages.err});
    exit(99);
  }

  // Kitu atveju išvedamas sėkmės pranešimas
  print("\n{s}\n\n", .{langMessages.succ});
}

// Pagrindinė funkcija - programos įeigos taškas
pub fn main() !void {
  // Sukuriamas alokatorius
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit();
  const allocator = arena.allocator();

  // Pranešimų medžio inicializacija
  const messages: Messages = .{
    .en = .{
      .err = "Error! Script execution was terminated!",
      .succ = "Successfully finished!"
    },
    .lt_LT = .{
      .err = "Klaida! Scenarijaus vykdymas sustabdytas!",
      .succ = "Komanda sėkmingai įvykdyta!"
    }
  };

  // Paimti aplinkos kintamuosius į struktūrą
  const env_map = try allocator.create(std.process.EnvMap);
  env_map.* = try std.process.getEnvMap(arena.allocator());
  defer env_map.deinit(); // technically unnecessary when using ArenaAllocator

  // Gauti aplinlos kalbos nustatymus
  const lang = env_map.get("LANG") orelse "";
  defer allocator.free(lang);

  // Paimti pranešimus, atitinkančius aplinkos kalbą
  const key: []const u8 = try std.mem.replaceOwned(u8, allocator, lang, ".UTF-8", "");
  defer allocator.free(key);
  const langMessages = messages.get(key);
  
  try stdout.print("{s}", .{"\n"});

  // Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
  try runCmd("apt-get update", langMessages);
  try runCmd("apt-get upgrade -y", langMessages);
  try runCmd("apt-get autoremove -y", langMessages);
  try runCmd("snap refresh", langMessages);

}

