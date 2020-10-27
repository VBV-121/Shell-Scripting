#!/bin/sh

#Input files cipher text file, plain text file and words list file accordingly provided during command input of the script
cipher_text_file=$1
plain_text_file=$2
words_file=$3

#Storing the content of the plain file and cipher file into plain text and cipher text variables
plain_text=`cat $plain_text_file`
cipher_text=`cat $cipher_text_file`

#Creating a loop till the end of the word list
while IFS= read -r line
do
    #Checking if word is less than 16 characters 
    if [ ${#line} -le 16 ]; 
    then 
        #Appending an incremental number to the word in each iteration of the for loop starting from 0 to 9
        for i in `seq 0 9`
        do
            #Stores the appended word with the number
            candidate_key="${line}${i}"
            #Command to decrypt the cipher text using the generated key
            decrypt_output=`openssl enc -aes-128-cbc -d -in $cipher_text_file -k $candidate_key -nosalt`
            #Checking if output is generated 
            if [ -n "$decrypt_output" ]; 
            then
                #Checking if decrypted text is equal to plain text
                if [ "$decrypt_output" = "$plain_text" ];
                then
                    #Seting the key in a variable
                    final_key=$candidate_key
                    break
                fi
            fi
        done 
    fi
done < "$words_file"

#Printing the key
echo "Correct key is $final_key"