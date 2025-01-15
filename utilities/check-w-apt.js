#! /usr/bin/env -S bun run

import { parseArgs } from "util";
import { basename } from "node:path";
import { inherits } from "node:util";

const { values, positionals } = parseArgs({
  args: Bun.argv,
  options: {
    i: {
      type: 'boolean',
    },
    n: {
      type: 'boolean',
    }
  },
  strict: true,
  allowPositionals: true,
})

const basenameStr = basename(Bun.argv[1])
const pkgNames = positionals.slice(2).sort();

// const pkgNames = "curl git unzip xz-utils zip libglu1-mesa".split(" ")

if (pkgNames.length === 0) {
  console.error(`!!!pkgNames.length === ${pkgNames.length}!!! ./${basename(Bun.argv[1])} pkg1 pkg2 ...`);
  process.exit(1);
} 

// console.log(pkgNames.join(' '));
const regstr = "^(" + pkgNames.join("|").replaceAll("+", "\\+") + ")\\/";
const regex = new RegExp(regstr, "gm");
// console.log(regex);

const proc = Bun.spawn(["apt", "list", "--installed"], {
  stdio: ['inherit', 'pipe', null]
});

const aptListOutput = await new Response(proc.stdout).text();
// console.log(aptListOutput)
const installedPkgs = [...aptListOutput.matchAll(regex)].map((row)=>row[1]);
const notInstalledPkgs = pkgNames.filter((pkgName) => !installedPkgs.includes(pkgName));

let installed = values["i"] ?? false;
let notInstalled = values["n"] ?? false;

if (!installed && !notInstalled) {
  installed = true;
  notInstalled = true;
} 

if(installed && notInstalled) {
  console.log(
    `i: ${installedPkgs.join(" ")}\nn: ${notInstalledPkgs.join(" ")}`
  );
  process.exit()
}

if (installed) {
  console.log(installedPkgs.join(" "));
}
if (notInstalled) {
  console.log(notInstalledPkgs.join(" "));
}
