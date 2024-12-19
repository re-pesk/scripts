#!/usr/bin/env bash

rm -f juliac-buildscript.jl
rm -f juliac.jl
rm -f julia-config.jl

wget https://raw.githubusercontent.com/JuliaLang/julia/refs/heads/master/contrib/juliac-buildscript.jl
wget https://raw.githubusercontent.com/JuliaLang/julia/refs/heads/master/contrib/juliac.jl
wget https://raw.githubusercontent.com/JuliaLang/julia/refs/heads/master/contrib/julia-config.jl
