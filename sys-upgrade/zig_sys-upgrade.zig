const std = @import("std");
const stdout = std.io.getStdOut().writer();
const print = std.debug.print;
const exit = std.os.linux.exit;
const Child = std.process.Child;

// Pranešimų rinkinys kalbai
const LangMessages = struct {
  err: []const u8 = "",
  succ: []const u8 = ""
};

// Visų pranešimų struktūra
const Messages = struct {
  en: LangMessages,
  lt_LT: LangMessages,

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

// Įvykdo išorinę programą, terminale atspausdindama komandą su argumentais, jos pranešimus ir vykdymo rezultatus
fn runCmd(command: []const u8, langMessages: LangMessages) !void {
  
  //sukuriamas alocatorius
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit(); // alocatorius deinicializuojamas, išeinant iš funkcijos

  const allocator = arena.allocator();

  var separator = try allocator.alloc(u8, command.len);
  defer allocator.free(separator);
  
  var i: usize = 0;

  while (i < separator.len) : (i += 1) {
    separator[i] = '-';
  }

  var iterator = std.mem.splitScalar(u8, command, ' ');

  var cmdArgsList = std.ArrayList([]const u8).init(allocator);

  while (iterator.next()) |x| {
    try cmdArgsList.append(x);
  }

  print("\n{s}\n{s}\n{s}\n\n", .{separator, command, separator});

  var child = Child.init(cmdArgsList.items, allocator);
  try child.spawn();
  const exitCode = try child.wait();

  if (exitCode.Exited > 0) {
    print("\n{s}\n", .{langMessages.err});
    exit(99);
  }

  print("\n{s}\n", .{langMessages.succ});
}

pub fn main() !void {
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit();
  
  const allocator = arena.allocator();

  // Pranešimų struktūros inicializacija
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

  const env_map = try allocator.create(std.process.EnvMap);
  env_map.* = try std.process.getEnvMap(arena.allocator());
  defer env_map.deinit(); // technically unnecessary when using ArenaAllocator

  const lang = env_map.get("LANG") orelse "";
  defer allocator.free(lang);

  const key: []const u8 = try std.mem.replaceOwned(u8, allocator, lang, ".UTF-8", "");
  defer allocator.free(key);
  const langMessages = messages.get(key);
  
  try runCmd("sudo apt-get update", langMessages);
  try runCmd("sudo apt-get upgrade -y", langMessages);
  try runCmd("sudo apt-get autoremove -y", langMessages);
  try runCmd("sudo snap refresh", langMessages);

  try stdout.print("{s}", .{"\n"});
}

