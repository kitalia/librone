#!/bin/bash
# Questo script si propone di automatizzare
# il download di e-books in italiano
export LANG=C # serve per non far fallire sed
export LC_CTYPE=C # serve per non far fallire sed
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD=$(tput bold)
NORM=$(tput sgr0)
GREEN='\033[30;92m'
GREENB='\033[30;42m' # Green background
ricomincia="si"
echo  
echo ================================================================================
echo
echo -e "${GREENB}                         __    _ __                                             ${NC}"
echo -e "${GREENB}                        / /   (_) /_  _________  ____  ___                      ${NC}"
echo -e "${GREENB}                       / /   / / __ \/ ___/ __ \/ __ \/ _ \                     ${NC}"
echo -e "${GREENB}                      / /___/ / /_/ / /  / /_/ / / / /  __/                     ${NC}"
echo -e "${GREENB}                     /_____/_/_____/_/   \____/_/ /_/\___/                      ${NC}"
echo
echo -e "------------------------------------------------------------${GREEN}versione 1.2 2022${NC}---"
echo
echo "Che libro cerchi oggi?"
while [ $ricomincia="si" ]; do
echo
echo "Inserisci il titolo o l'autore"
echo   
read -r ricerca
echo   
echo "Interessante ..."
echo   
echo -e "${GREENB}Dammi un attimo per cercarlo ...${NC}"
echo   
echo 
echo ----------------------------------------------------------------------------------
risultato=$(curl -v --silent https://libri.life/search/"$ricerca"/feed/rss2/ 2>&1 | grep 'Dati del libro' | sed -n -e 's/^.*libro //p' | sed 's/ Anno.*//' | awk '! /Titolo: /' | sed "s/-//g" | sed "s/&#8211;/-/g" | sed 's/Titolo:/ /g' | sed 's/ Autore: / - /g' | sed 's/\[\]<\/p>//g' | sort -u | awk '{print NR-0 "" $0}' | awk '{sub("$", "\033[1m\033[30;92m", $0)}; 1' | awk '{sub("$", "\033[0m)", $1)}; 1') # decisamente da migliorare, è lento
risultatone=$(curl -v --silent https://libri.life/search/"$ricerca"/feed/rss2/ 2>&1 | grep 'Dati del libro' | sed -n -e 's/^.*libro //p' | sed 's/ Anno.*//' | awk '! /Titolo: /' | sed "s/-//g" | sed "s/&#8211;/-/g" | sed 's/Titolo:/ /g' | sed 's/ Autore: / - /g' | sort -u | awk '{print NR-0 "" $0}') # decisamente da migliorare, è lento
while [ -z "$risultato" ]
do
echo   
echo 
echo -e "${RED}${BOLD}  OH NO!${NC}${NORM}"
echo -e "${RED}${BOLD}⚠️ ERRORE ⚠️${NC}${NORM}"
echo 
echo -e "${BOLD}Nessun risultato${NC}${NORM} corrispondente trovato... 🤔"
echo 
echo "Prova a cercare altro. Inserisci il titolo o l'autore"
echo   
read -r ricerca
echo   
echo -e "${GREENB}Dammi un attimo per cercarlo ...${NC}"
risultato=$(curl -v --silent https://libri.life/search/"$ricerca"/feed/rss2/ 2>&1 | grep 'Dati del libro' | sed -n -e 's/^.*libro //p' | sed 's/ Anno.*//' | awk '! /Titolo: /' | sed "s/-//g" | sed "s/&#8211;/-/g" | sed 's/Titolo:/ /g' | sed 's/ Autore: / - /g' | sed 's/\[\]<\/p>//g' | sort -u | awk '{print NR-0 "" $0}' | awk '{sub("$", "\033[1m\033[30;92m", $0)}; 1' | awk '{sub("$", "\033[0m)", $1)}; 1') # decisamente da migliorare, è lento
risultatone=$(curl -v --silent https://libri.life/search/"$ricerca"/feed/rss2/ 2>&1 | grep 'Dati del libro' | sed -n -e 's/^.*libro //p' | sed 's/ Anno.*//' | awk '! /Titolo: /' | sed "s/-//g" | sed "s/&#8211;/-/g" | sed 's/Titolo:/ /g' | sed 's/ Autore: / - /g' | sort -u | awk '{print NR-0 "" $0}') # decisamente da migliorare, è lento
echo   
echo ----------------------------------------------------------------------------------
done
echo   
echo -e "${BOLD}${GREEN}$risultato${NC}"
echo   
echo ----------------------------------------------------------------------------------
echo   
echo "Inserisci il numero corrispondente al libro che vuoi scaricare"
echo   
read -r numero
echo   
echo ----------------------------------------------------------------------------------
titolo=$(echo "$risultatone" | awk "FNR == $numero {print}" | sed "s/$numero //" | sed 's/ - .*//' )
autore=$(echo "$risultatone" | awk "FNR == $numero {print}" | sed "s/$numero $titolo - //")
while [ -z "$titolo" ]
do
echo ----------------------------------------------------------------------------------
echo   
echo -e "${BOLD}${GREEN}$risultato${NC}"
echo   
echo ----------------------------------------------------------------------------------
echo 
echo -e "${RED}${BOLD}  OH NO!${NC}${NORM}"
echo -e "${RED}${BOLD}⚠️ ERRORE ⚠️${NC}${NORM}"
echo 
echo -e "${BOLD}Nessun risultato${NC}${NORM} corrispondente trovato... 🤔"
echo 
echo "Credo tu abbia inserito il numero sbagliato o digitato caratteri non numerici"
echo  
echo "Inserisci il ${BOLD}numero${NORM} corrispondente al libro che vuoi scaricare (1 2 3 etc.)"
echo   
read -r numero
titolo=$(echo "$risultatone" | awk "FNR == $numero {print}" | sed "s/$numero //" | sed 's/ - .*//')
autore=$(echo "$risultatone" | awk "FNR == $numero {print}" | sed "s/$numero $titolo - //")
echo   
echo ----------------------------------------------------------------------------------
done
echo 
echo Titolo: "${BOLD}$titolo${NORM}"
echo Autore: "${BOLD}$autore${NORM}"
titolone=$(echo "$titolo" | sed "s/'//g" | sed "s/://g" | sed "s/(//g" | sed "s/)//g" | sed "s/,//g" | sed "s/;//g" | sed -e "s/ /-/g" | awk '{ print tolower($0) }' | sed "s/\./\-/g" | sed "s/\--/\-/g" | sed "s/\--/\-/g" | sed 's/à/a/g' | sed 's/è/e/g' | sed 's/ì/i/g' | sed 's/í/I/g' | sed 's/á/a/g' | sed 's/é/e/g' | sed 's/ë/e/g' | sed 's/ę/e/g' | sed 's/ó/o/g' | sed 's/ò/o/g' | sed 's/ù/u/g' | sed 's/ä/a/g' | sed 's/ö/o/g' | sed 's/ü/u/g') ### Tecnicamente funziona ma è da migliorare ed automatizzare, lento
autorone=$(echo "$autore" | sed "s/'//g" | sed "s/://g" | sed "s/(//g" | sed "s/)//g" | sed "s/,//g" | sed "s/;//g" | sed -e "s/ /-/g" | awk '{ print tolower($0) }' | sed "s/\./\-/g" | sed "s/\--/\-/g" | sed "s/\--/\-/g" | sed 's/à/a/g' | sed 's/è/e/g' | sed 's/ì/i/g' | sed 's/í/I/g' | sed 's/á/a/g' | sed 's/é/e/g' | sed 's/ë/e/g' | sed 's/ę/e/g' | sed 's/ó/o/g' | sed 's/ò/o/g' | sed 's/ù/u/g' | sed 's/ä/a/g' | sed 's/ö/o/g' | sed 's/ü/u/g') ### Tecnicamente funziona ma è da migliorare ed automatizzare, lento
echo
echo ----------------------------------------------------------------------------------
echo   
while [ -z "$formato" ]; do
  read -p "Seleziona il formato in cui scaricare il libro (Mobi, Epub, Pdf): " answer
  case "$answer" in
    [Mm]|[Mm]obi) formato="mobi" ;;
    [Ee]|[Ee]pub) formato="epub" ;;
    [Pp]|[Pp]df) formato="pdf" ;;
    *) echo 
    echo -e "${RED}${BOLD}  OH NO!${NC}${NORM}"
    echo -e "${RED}${BOLD}⚠️ ERRORE ⚠️${NC}${NORM}"
    echo 
    echo "Per selezionare il formato inserisci:" 
    echo
    echo -e "${RED}${BOLD}M${NC}${NORM} (oppure ${RED}${BOLD}m${NC}${NORM} oppure ${RED}${BOLD}mobi${NC}${NORM}) per il formato ${GREEN}${BOLD}mobi${NC}${NORM}"
    echo -e "${RED}${BOLD}E${NC}${NORM} (oppure ${RED}${BOLD}e${NC}${NORM} oppure ${RED}${BOLD}epub${NC}${NORM}) per il formato ${GREEN}${BOLD}epub${NC}${NORM}"
    echo -e "${RED}${BOLD}P${NC}${NORM} (oppure ${RED}${BOLD}p${NC}${NORM} oppure ${RED}${BOLD}pdf${NC}${NORM}) per il formato ${GREEN}${BOLD}pdf${NC}${NORM}" 
    echo ;;
  esac
done
echo 
echo ----------------------------------------------------------------------------------
echo 
mkdir -p ~/Downloads/librone/
curl --silent https://dwnlg.link/book-n/"$autorone"/"$titolone"-"$autorone"/"$titolone"."$formato" -o ~/Downloads/librone/"$titolone"."$formato"
peso=$(wc -c ~/Downloads/librone/"$titolone"."$formato" | awk '{print $1}')
if [ $peso -ge 1 ]
then
echo -e "${BOLD}$titolo${NC}${NORM} di ${BOLD}$autore${NC}${NORM}"
echo -e "nel formato ${BOLD}$formato${NC}${NORM}" 
echo "è stato scaricato nella cartella ${BOLD}~/Downloads/librone"
echo -e "${GREEN}Buona lettura 👍${NC}${NORM}"
echo
else
rm ~/Downloads/librone/"$titolone"."$formato"
echo -e "${RED}${BOLD}OH NO!${NC}${NORM}"
echo -e "mi spiace c'è stato un ${RED}${BOLD}⚠️ ERRORE ⚠️${NC}${NORM} nel download di"
echo -e "${BOLD}$titolo${NC}${NORM} di ${BOLD}$autore${NC}${NORM}"
echo -e "nel formato ${BOLD}$formato${NC}${NORM}" 
echo "sembra che il file sia vuoto ed è stato eliminato"
echo  
fi
  echo -e "=====================================Vuoi scaricare un altro libro? (${GREEN}${BOLD}SÍ${NC}${NORM} o ${RED}${BOLD}NO${NC}${NORM})====="
  echo
  read -p "" answer
  case "$answer" in
    [Ss]|[Ss]i|[Ss]í|[Ss]ì|[Ss]Ì|[Ss]Í) ricomincia="si" echo
    echo -e "-----${GREEN}${BOLD}OK${NC}${NORM}---------------------------------------------------------------------------" ;;
    [Nn]|[Nn]o)  
    ricomincia="no"
    echo
    echo -e "=========================================================================${RED}${BOLD}CIAO${NC}${NORM}====="
    echo
    exit 0
    break ;;
    *) echo 
    echo ----------------------------------------------------------------------------------
    echo
    echo -e "${GREEN}${BOLD}Non ho capito la risposta:${NC}${NORM}"
    echo non credo che sia una risposta valida ma nel dubbio ricominciamo
    echo -e "per ${RED}${BOLD}chiudere forzatamente${NC}${NORM} il programma premi ${RED}${BOLD}CTRL+C${NC}${NORM}" 
    echo
    echo ----------------------------------------------------------------------------------
    echo ;;
  esac
done
echo ==================================================================================
exit 0
