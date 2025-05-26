#!/usr/bin/env php-script-loader.sh
//<?php # - This tag is here only for syntax highlighting, this script can be run without it

echo "\nTest of 4 different ways to call external programs!\n\n";

$command = "sudo apt-get update";
$output = null;
$result_code = null;

echo "(1 step on line ", __LINE__, ")\n";
$result = shell_exec($command);
echo "(2 step on line ", __LINE__, ")\n";
echo 'shell_exec: $result: ', "\n", $result;
echo "(3 step on line ", __LINE__, ")\n";
$result = exec($command, $output, $result_code);
echo "(4 step on line ", __LINE__, ")\n";
echo 'exec: $result: ', "\n", $result, '$output: ', "\n", join("\n", $output ?? []), "\n", '$result_code:', $result_code, "\n";
echo "(5 step on line ", __LINE__, ")\n";
$result = passthru($command, $result_code);
echo "(6 step on line ", __LINE__, ")\n";
echo 'passthru: $result: ', "\n", $result, "\n", '$result_code: ', $result_code, "\n";
echo "(7 step on line ", __LINE__, ")\n";
$result = system($command, $result_code);
echo "(8 step on line ", __LINE__, ")\n";
echo 'system: $result: ', "\n", $result, "\n", '$result_code: ', $result_code, "\n";
echo "(9 step on line ", __LINE__, ")\n";
