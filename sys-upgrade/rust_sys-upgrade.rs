///usr/bin/env -S cargo script "$0" "$@"; exit $?

use std::env;
use std::process::{Command, exit};

// Pranešimų struktūra
struct Messages {
    err: &'static str,
    succ: &'static str,
}

// Pranešimų medis
const MESSAGES: &[(&str, Messages)] = &[
    (
        "en.UTF-8",
        Messages {
            err: "Error! Script execution was terminated!",
            succ: "Successfully finished!",
        },
    ),
    (
        "lt_LT.UTF-8",
        Messages {
            err: "Klaida! Scenarijaus vykdymas sustabdytas!",
            succ: "Komanda sėkmingai įvykdyta!",
        },
    ),
];

// Numatyti pranešimai (jei kalba nerasta)
const DEFAULT_MESSAGES: Messages = Messages {
    err: "Error! Unknown language!",
    succ: "Success!",
};


// Funkcija, kuri pagal kalbą parenka tinkamus pranešimus
fn get_messages(lang: &str) -> &'static Messages {
    MESSAGES
        .iter()
        .find(|(key, _)| *key == lang)
        .map(|(_, messages)| messages)
        .unwrap_or(&DEFAULT_MESSAGES)
}

fn run_cmd(cmd_arg: &str, messages: &Messages) {
    // Sukuriama komandos tekstinė eilutė
    let command = format!("sudo {}", cmd_arg);

    // Sukuriamas skirtukas iš "-" simbolių
    let separator = "-".repeat(command.len());

    // Išvedama komanda ir skirtukas
    println!("{}\n{}\n{}\n", separator, command, separator);

    // Paleidžiama komanda
    let status = Command::new("sudo")
        .args(cmd_arg.split(' '))
        .status()
        .expect("Failed to execute command");

    // Tikrinamas komandos vykdymo statusas
    if !status.success() {
        eprintln!("\n{}\n", messages.err);
        exit(99);
    }

    println!("\n{}\n", messages.succ);
}

fn main() {
    // Gauti aplinkos kalbos nuostatą
    let lang = env::var("LANG").unwrap_or_else(|_| "en.UTF-8".to_string());
    let messages = get_messages(&lang);

    println!("");

    // Komandų vykdymo funkcijos iškvietimai
    run_cmd("apt-get update", messages);
    run_cmd("apt-get upgrade -y", messages);
    run_cmd("apt-get autoremove -y", messages);
    run_cmd("snap refresh", messages);
}

