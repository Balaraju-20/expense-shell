#!/bin/bash
 
 LOGS_FOLDER="/var/log/expense"
 SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
 TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
 LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
 mkdir -p $LOGS_FOLDER
 
 USERID=$(id -u)
 R="\e[31m"
 G="\e[32m"
 N="\e[0m"
 Y="\e[33m"
 
 CHECK_ROOT(){
     if [ $USERID -ne 0 ]
     then
         echo -e "$R Please run this script with root priveleges $N" | tee -a $LOG_FILE
         exit 1
     fi
 }
 
 VALIDATE(){
     if [ $1 -ne 0 ]
     then
         echo -e "$2 is...$R FAILED $N"  | tee -a $LOG_FILE
         exit 1
     else
         echo -e "$2 is... $G SUCCESS $N" | tee -a $LOG_FILE
     fi
 }
 
 echo "Script started executing at: $(date)" | tee -a $LOG_FILE
 
 CHECK_ROOT
 
 dnf module disable nodejs -y &>>$LOG_FILE
 VALIDATE $? "Disable default nodejs"

 dnf module enable nodejs:20 -y &>>$LOG_FILE
 VALIDATE $? "enable default nodejs:20"

 dnf install nodejs -y &>>$LOG_FILE
 VALIDATE $? "Install nodejs"

 id expense &>>$LOG_FILE
 if [ $? -ne 0 ]
 then
    echo -e "user expense does not exists...$G CREATING $N" 
    useradd expense &>>$LOG_FILE
    VALIDATE $? "creating expense user"
 else
    echo -e "expense user already exists .. $Y skipping $N" 
 fi