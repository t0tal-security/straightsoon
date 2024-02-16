#!/usr/bin/bash


if (( $# == 1 ))
then
	if [[ $1 == "check" ]]
	then
		$(/usr/bin/which tail) -n 5 $(pwd)/words
		exit 0
	fi

	if grep -i $1 $(pwd)/words;
	then
		echo "[+] Exists"
		exit 0
	else
		echo "[-] Doesn't exist"
		exit 1
	fi
elif (( $# == 2  ))
then
	echo "$1 - $2" >> $(pwd)/words
	$(/usr/bin/which tail) -n 5 $(pwd)/words
	exit 0
elif (( $# == 3  ))
then
	echo "$1 - $2 - $3" >> $(pwd)/words
	$(/usr/bin/which tail) -n 5 $(pwd)/words
	exit 0
elif (( $# == 4 ))
then
	for arg in "$@"
	do
		if [[ $arg == "check" ]]
		then
			origin=$($(/usr/bin/which sha256sum) $(pwd)/words|$(/usr/bin/which cut) -d" " -f1)
			copy=$($(/usr/bin/which sha256sum) $(pwd)/words.bak|$(/usr/bin/which cut) -d" " -f1)

			if [[ $origin == $copy ]]
			then
				echo "[+] Match on wordlist:backup"
				exit 0
			else
				echo "[-] No match on wordlist:backup"
				exit -1
			fi
		fi
	done

	echo "[*] Backuping wordlist..."
	$(/usr/bin/which cp) $(pwd)/words $(pwd)/words.bak
	$(/usr/bin/which cp) $(pwd)/words.bak $(pwd)/words2.bak
	$(/usr/bin/which cp) $(pwd)/words2.bak $(pwd)/words3.bak
	echo " "
	$(/usr/bin/which sha256sum) $(pwd)/words*
else
	echo "[-] Too much or too few parameters ( min 1, max 4 needed )"
	echo -e "[*]\t'1': check if word exists in wordlist ( 'check' as the arg to display last 5 words from wordlist )"
	echo -e "[*]\t'2': add 'word - translation' to the wordlist"
	echo -e "[*]\t'3': add 'word - tanslation - description' to the wordlist"
	echo -e "[*]\t'4': backup wordlist ( 'check' among them args for wordlist:backup match )"
	echo -e "\n[*] You provided $# parameters"
	exit 1
fi
