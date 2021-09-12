#!/bin/bash

E_WRONGARGS=65
E_BADPID=66
E_NOSUCHPROCESS=67
E_NOPERMISSION=68
PROCFILE=exe

#func
#atr var
#par posicionais
#expansao de cmd
#fluxo cond inteiros
#fluxo cond arq
#filtrando saida
#permissao de leitura
#awk
#for

function fatal_error() {
    echo "[-] Erro: $@" 1>&2;
    exit 1;
}

function proc_error() {
  echo -e "   [-] Erro: $@" 1>&2;
  continue;
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
  fi  

  if [ ! -r "/proc/$1/$PROCFILE" ] 
  then
    proc_error "O processo $proc esta sendo executado, \n     contudo nao possuo permissao para ler o seu arquivo /proc/$1/$PROCFILE."
  fi  

  exe_file=$( ls -l /proc/$1 | grep "exe" | awk '{ print $11 }' )

  if [ -e "$exe_file" ]  
  then                   
    echo "Processo #$1 executado por $exe_file."
  else
    proc_error "Nao consegui identificar o arquivo."
  fi 
done

exit 0