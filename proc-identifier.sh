#!/bin/bash

PROCFILE=exe

function fatal_error() {
    echo "[-] Erro: $@" 1>&2;
    exit 1;
}

function proc_error() {
  echo -e "   [-] Erro: $@" 1>&2;
}

if [ $# -eq 0 ]
then
  fatal_error "Favor inserir um ou mais identificadores de processo."
fi  

for proc in "$@"
do
  echo "Processo $proc"
  
  pidno=$( ps ax | grep $proc | awk '{ print $1 }' | grep $proc )

  if [ -z "$pidno" ]  
  then                
    proc_error "Nao tem nenhum processo com o id $proc executando."
    continue;
  fi  

  if [ ! -r "/proc/$proc/$PROCFILE" ] 
  then
    proc_error "O processo $proc esta sendo executado, \n     contudo nao possuo permissao para ler o seu arquivo /proc/$proc/$PROCFILE."
    continue;
  fi  

  exe_file=$( ls -l /proc/$proc | grep "exe" | awk '{ print $11 }' )
  cwd_file=$( ls -l /proc/$proc | grep "cwd" | awk '{ print $11 }' )

  if [ -e "$exe_file" -a -e "$cwd_file"]  
  then                   
    echo "   Processo #$proc iniciado por $exe_file executado em $cwd_file."
  else
    proc_error "Nao consegui identificar o arquivo."
  fi 
done

exit 0