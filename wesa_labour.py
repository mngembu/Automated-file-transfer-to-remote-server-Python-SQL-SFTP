import csv
from datetime import datetime, date, timedelta
import os
import emailing
import psycopg2
import paramiko
import pandas as pd

# Define the path to your SQL query file
sql_query_path = r"C:\Users\mngembu\pyproject\wesa\wesa_labour.sql"

#Define path to destination directory
WORK_SPACE = r"C:\Users\mngembu\OneDrive - Goodwill Industries of Alberta\WESA_data\data_dump\wesa\temp"

SERVER_NAME = os.environ.get("SERVER")
DATABASE_NAME = os.environ.get("DATABASE")
UID = os.environ.get("UID_DB")
PWD = os.environ.get("PWD_DB")
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
    csv_file_path = os.path.join(WORK_SPACE, ("Labor_Payroll." + str(((date.today())-timedelta(days = 1)).strftime("%Y%m%d%H%M%S")) + ".csv"))

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
    data['Department Description'] = data['Department Description'].replace({'Impact Centre Eic':'Edmonton Outlet Store', 'Impact Centre Cic':'Calgary Outlet Store'})
    data.to_csv(csv_file_path, sep=',', encoding='utf-8', index=False)

    print("csv created")

    # Close the cursor and connection
    cur.close()
    conn.close()



    # Transferring ADC donors data from temp folder to WESA remote Server

    localFilePath  = csv_file_path
    remoteFilePath = os.path.join("/GWAlberta3.0-NEW", ("Labor_Payroll." + str(((date.today())-timedelta(days = 1)).strftime("%Y%m%d%H%M%S")) + ".csv"))

    # create ssh client 
    SSH_Client= paramiko.SSHClient()

    # remote server credentials
    #Protocol = [WinSCP.Protocol]::Sftp
    HostName = os.environ.get("HOST_FTP")
    UserName = os.environ.get("USER_FTP")
    PassWord = os.environ.get("PWD_FTP")
    Port = os.environ.get("PORT_FTP")
    
    
    SSH_Client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    SSH_Client.connect( hostname=HostName, port=Port, username=UserName,
                    password= PassWord)

    # create an SFTP client object
    sftp_Client = SSH_Client.open_sftp()

    # transfer the file to the remote server
    files = sftp_Client.put(localFilePath,remoteFilePath)

    print("Labour file transferred")

    # close the connection
    sftp_Client.close()
    SSH_Client.close()

except Exception as e:
    emailing.send_alert_email(str(e))  # Sending an email alert
    print("Upload failed:", str(e)) 
