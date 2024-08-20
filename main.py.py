import csv
from datetime import datetime, date, timedelta
import os
import emailing
import psycopg2
import paramiko
import pandas as pd
from dotenv import load_dotenv

load_dotenv() # this loads all the environment variables


#Define path to local directory
WORK_SPACE = r"temp"

# Get your database credentials from environment variables
SERVER_NAME=os.getenv("SERVER")
DATABASE_NAME=os.getenv("DATABASE")
UID=os.getenv("UID_DB")
PWD=os.getenv("PWD_DB")
PORT="5432"


try:

    # Connect to the Postgresql database
    try:
        conn = psycopg2.connect(database=DATABASE_NAME, host=SERVER_NAME, user=UID, password=PWD, port=PORT)
        print("Database connected successfully")
    except:
        print("database not connected")

        # Create a cursor
    cur = conn.cursor()

    # Fetch the SQL queries from the sub-folder
    for filename in os.listdir("sql_queries"):
        sql_query_path = os.path.join("sql_queries", filename)
        # Read the SQL query from the file
        with open(sql_query_path, 'r') as file:
                sql_query = file.read()

        # Execute the SQL query
        cur.execute(sql_query)

        # Fetch all rows from the query result
        rows = cur.fetchall()
        
        # Specify the filename for the sales CSV file and dump the rows in it
        if "sales" in sql_query_path:
            csv_file_path = os.path.join(WORK_SPACE, ("WESA_SALE_NEW_" + str(((date.today())-timedelta(days = 1)).strftime("%Y%m%d")) + ".csv"))
            # Write the rows to a CSV file
            with open(csv_file_path, 'w', newline='') as f:
                # Create a CSV writer object
                writer = csv.writer(f)
                # Write the header (column names)
                writer.writerow([desc[0] for desc in cur.description])
                # Write the data rows
                writer.writerows(rows)
            
            # Clean the sales csv file: delete last 2 columns, add leading zeros to 'StoreNo' column and create the 'Credits' column
            data = pd.read_csv(csv_file_path)
            data = data.iloc[:, :-2]
            data['StoreNo'] = data['StoreNo'].astype(str).apply(lambda x: x.zfill(3))
            data['Credits'] = -(data['ShareTheGoodSales'] + data['TotalGiftCardsIssued'] + data['ChangeRoundup'] + data['TotalStoreCreditsRedeemed']).round(2)
            data.to_csv(csv_file_path, sep=',', encoding='utf-8', index=False)

        # Specify the filename for the store donations CSV file and dump the rows in it
        if "stores" in sql_query_path:
            csv_file_path2 = os.path.join(WORK_SPACE, ("WESA_DONR_NEW_" + str(((date.today())-timedelta(days = 1)).strftime("%Y%m%d")) + ".csv"))
            # Write the rows to a CSV file
            with open(csv_file_path2, 'w', newline='') as f:
                # Create a CSV writer object
                writer2 = csv.writer(f)
                # Write the header (column names)
                writer2.writerow([desc[0] for desc in cur.description])
                # Write the data rows
                writer2.writerows(rows)

            # Clean the store donations csv file: round the GGCDonors column
            data = pd.read_csv(csv_file_path2)
            data['GGCDonors'] = data['GGCDonors'].round(0).astype(int)
            data.to_csv(csv_file_path2, sep=',', encoding='utf-8', index=False)   

        # Specify the filename for the ADC donations CSV file and dump the rows in it
        if "donors_adc" in sql_query_path:
            csv_file_path3 = os.path.join(WORK_SPACE, ("WESA_ADC_" + str(((date.today())-timedelta(days = 1)).strftime("%Y%m%d")) + ".csv"))
            # Write the rows to a CSV file
            with open(csv_file_path3, 'w', newline='') as f:
                # Create a CSV writer object
                writer3 = csv.writer(f)
                # Write the header (column names)
                writer3.writerow([desc[0] for desc in cur.description])
                # Write the data rows
                writer3.writerows(rows)

            # Clean the ADC donations CSV file: round the No_of_ADC_Donors column
            data = pd.read_csv(csv_file_path3)
            data['No_of_ADC_Donors'] = data['No_of_ADC_Donors'].round(0).astype(int)
            data.to_csv(csv_file_path3, sep=',', encoding='utf-8', index=False)   

        # Specify the filename for the labor CSV file and dump the rows in it
        if "labor" in sql_query_path:
            csv_file_path4 = os.path.join(WORK_SPACE, ("Labor_Payroll." + str(((date.today())-timedelta(days = 1)).strftime("%Y%m%d%H%M%S")) + ".csv"))
            # Write the rows to a CSV file
            with open(csv_file_path4, 'w', newline='') as f:
                # Create a CSV writer object
                writer4 = csv.writer(f)
                # Write the header (column names)
                writer4.writerow([desc[0] for desc in cur.description])
                # Write the data rows
                writer4.writerows(rows)
        
            # Clean the labor CSV file: Rename some values in the Department Description column
            data = pd.read_csv(csv_file_path4)
            data['Department Description'] = data['Department Description'].replace({'Impact Centre Eic':'Edmonton Outlet Store', 'Impact Centre Cic':'Calgary Outlet Store'})
            data.to_csv(csv_file_path4, sep=',', encoding='utf-8', index=False)
        
    print("CSVs created")

    # Close the cursor and connection
    cur.close()
    conn.close()


    # Transferring ADC donors data from temp folder to WESA remote Server

    remote_directory = "/GWAlberta3.0-NEW"

    # create ssh client 
    SSH_Client= paramiko.SSHClient()

    # Get remote server credentials from environment variables
    HostName = os.getenv("HOST_FTP")
    UserName = os.getenv("USER_FTP")
    PassWord = os.getenv("PWD_FTP")
    Port = os.getenv("PORT_FTP")

    SSH_Client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    SSH_Client.connect( hostname=HostName, port=Port, username=UserName,
                    password= PassWord)

    # create an SFTP client object
    sftp_Client = SSH_Client.open_sftp()

    # transfer files to the remote server
    #loop through all files in the local directory and upload only files to the remote directory
    for file_name in os.listdir(WORK_SPACE):
        local_file_path = os.path.join(WORK_SPACE, file_name)
        if os.path.isfile(local_file_path):
            remote_file_path = os.path.join(remote_directory, file_name)
            sftp_Client.put(local_file_path, remote_file_path)

    print("All files transferred")

    # close the connection
    sftp_Client.close()
    SSH_Client.close()

except Exception as e:
    emailing.send_alert_email(str(e))  # Sending an email alert
    print("Upload failed:", str(e))

#Empty the temporary local folder
for file_name in os.listdir(WORK_SPACE):
    local_file_path = os.path.join(WORK_SPACE, file_name)
    if os.path.isfile(local_file_path):
        os.remove(local_file_path)


    