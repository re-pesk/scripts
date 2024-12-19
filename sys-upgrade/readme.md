[Atgal](../readme.md)

# Ubuntu paketų atnaujinimo skriptas skirtingomis programavimo kalbomis

Naudota operacinė sistema – Ubuntu 24.04

|| Pavadinimas | Pagrindinė<br />funkcija<br>būtina? | Funkcijos deklaravimas | Kintamojo deklaravimas |
| --- | --- | --- | --- | --- |
|||| Apvalkalo scenarijų (Shell scripting) kalbos ||
| + | Bash | Ne | <pre><code>runCmd() { ...=$@ } ||
| + | Elvish | Ne | <pre><code>var runCmd = { \| param \| } ||
| + | Fish | Ne | <pre><code>function runCmd ()<br>   ... = $argv<br>end ||
| + | Nu | Ne | <pre><code>def runCmd [...args] {} ||
| + | Zsh | Ne | <pre><code>runCmd() { ...=$@ } ||
|||| Intepretuojamos kalbos ||
| + | Abs | Ne | <pre><code>runCmd = f(cmdArg) {} ||
| + | JS (Bun) | Ne | <pre><code>const runCmd = (cmdArg) => {} ||
| + | JS (Deno) | Ne | <pre><code>--""-- ||
| + | JS (Node) | Ne | <pre><code>--""-- ||
| + | Julia | Ne/Taip[^1] | <pre><code>function runCmd(cmdArg)<br>    ...<br>end</pre> ||
| + | PHP | Ne | <pre><code>function runCmd($cmdArg) {} ||
| + | Python | Ne | <pre><code>def runCmd(cmdArg): ||
|||| Kompiliuojamos kalbos||
| + | C3 | Taip | <pre><code>fn void main() {} ||
| -[^2] | Carbon | ? |||
| + | Crystal | Ne | <pre><code>def runCmd(cmdArg : String)<br>end</pre> ||
| + | D | Taip | <pre><code>void runCmd(string cmdArg){} ||
| + | Dart | Taip | <pre><code>runCmd(String cmdArg){} ||
| + | Go | Taip | <pre><code>func runCmd(cmdArgString string) void {} ||
| + | Odin | Taip | <pre><code>runCmd :: proc(cmdStr: string) {} ||
| + | Swift | Ne | <pre><code>func runCmd(_ cmdArgs: String) {} ||
| + | V | Ne | <pre><code>fn run_cmd(cmdArgs string) {} ||
| + | Zig | Taip | <pre><code>fn runCmd(command: []const u8) !void {} ||

[^1]: Reikalinga tik kompiliuojant.
[^2]: Neįmanoma sukompiliuoti pavyzdžio iš dokumentų
