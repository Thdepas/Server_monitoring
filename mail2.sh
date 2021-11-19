#!/bin/bash

    file="report.txt" 
 
    MIMEType=`file --mime-type "$file" | sed 's/.*: //'`
    curl -s --url 'smtps://smtp.gmail.com:465' --ssl-reqd \
    --mail-from 'yourmail@gmail.com' \
    --mail-rcpt 'toreporting@gmail.com'\
    --user 'thdepas@gmail.com':'PASSWORD' \
     -H "Subject: 'Warning'" -H "From: 'yourmail@gmail.com'" -H "To:'toreporting@gmail.com'" -F \
    "=(;type=multipart/mixed" -F "='Disck capacity under 10%';type=text/plain" -F \
      "file=@$file;type=$MIMEType;encoder=base64" -F '=)'
     


 