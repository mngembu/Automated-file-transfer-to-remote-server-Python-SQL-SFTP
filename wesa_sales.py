import csv
from datetime import datetime, date, timedelta
import os
import emailing
import psycopg2
import paramiko
import pandas as pd

# Define the path to your SQL query file
sql_query_path = r"C:\Users\mngembu\pyproject\wesa\wesa_sales_postgres.sql"

#Define path to destination directory
WORK_SPACE = r"C:\Users\mngembu\OneDrive - Goodwill Industries of Alberta\WESA_data\data_dump\wesa\temp"

SERVER_NAME = "data.gdp.goodwill.ab.ca"
DATABASE_NAME = "gdp"
UID = "mngembu"
PWD = "aEXdEa6UvZgAmedn"
PORT = "5432"


try:
    try:
        conn = psycopg2.connect(database=DATABASE_NAME, host=SERVER_NAME, user=UID, password=PWD, port=PORT)
        print("Database connected successfully")
    except:
        print("database not connected")


        # Create a cursor
    cur = conn.cursor()


    # Read the SQL query from the file
    with open(sql_query_path, 'r') as file:
            sql_query = file.read()

    # Execute your PostgreSQL query
    cur.execute(sql_query)

    # Fetch all rows from the query result
    rows = cur.fetchall()

    # Specify the filename for the CSV file
    csv_file_path = os.path.join(WORK_SPACE, ("WESA_SALE_NEW_" + str(((date.today())-timedelta(days = 1)).strftime("%Y%m%d")) + ".csv"))

    # Write the rows to a CSV file
    with open(csv_file_path, 'w', newline='') as f:
        # Create a CSV writer object
        writer = csv.writer(f)
        # Write the header (column names)
        writer.writerow([desc[0] for desc in cur.description])
        # Write the data rows
        writer.writerows(rows)

    # Clean the csv file (delete last 2 columns), add leading zeros to 'StoreNo' column and create the 'Creadits' column
    data = pd.read_csv(csv_file_path)
    data = data.iloc[:, :-2]
    data['StoreNo'] = data['StoreNo'].astype(str).apply(lambda x: x.zfill(3))
    data['Credits'] = -(data['ShareTheGoodSales'] + data['TotalGiftCardsIssued'] + data['ChangeRoundup'] + data['TotalStoreCreditsRedeemed']).round(2)
    data.to_csv(csv_file_path, sep=',', encoding='utf-8', index=False)

    print("csv created")

    # Close the cursor and connection
    cur.close()
    conn.close()


    # Transferring ADC donors data from temp folder to WESA remote Server

    localFilePath  = csv_file_path
    remoteFilePath = os.path.join("/GWAlberta3.0-NEW", ("WESA_SALE_NEW_" + str(((date.today())-timedelta(days = 1)).strftime("%Y%m%d")) + ".csv"))

    # create ssh client 
    SSH_Client= paramiko.SSHClient()

    # remote server credentials
    #Protocol = [WinSCP.Protocol]::Sftp
    HostName = "ftp.wesa.app"
    UserName = "ftpalberta"
    PassWord = "s4#OyUa#D69P1a&7i"
    Port = 60022
    #SshHostKeyFingerprint = "ssh-rsa 3072 BwYT9J862vYEwkhtOnG3iEF3+bD8Dr79oEdcrNIAJmA"

    SSH_Client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    SSH_Client.connect( hostname=HostName, port=Port, username=UserName,
                    password= PassWord)


    # create an SFTP client object
    sftp_Client    = SSH_Client.open_sftp()

    # transfer file to the remote server
    files = sftp_Client.put(localFilePath,remoteFilePath)

    print("Sales file transferred")

    # close the connection
    sftp_Client.close()
    SSH_Client.close()

except Exception as e:
    emailing.send_alert_email(str(e))  # Sending an email alert
    print("Upload failed:", str(e))