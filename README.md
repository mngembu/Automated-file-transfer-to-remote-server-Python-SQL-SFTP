# Automated File Transfer System

## Project Overview
This project is a Python backend application designed to automate the daily transfer of data between servers located in Canada and the United States. 
The system handles the extraction, transformation, and loading (ETL) of data related to sales, donations, and labor. The data is extracted from a PostgreSQL database, 
saved into `.csv` files, and securely transferred to a remote SFTP server in the US. The process is monitored using WinSCP to ensure the integrity and security of the data transfer.

## Objectives
- Automate the daily data transfer process between servers in different geographical locations.
- Ensure secure and reliable data transfer using the SFTP protocol.
- Minimize manual intervention and potential human errors in the data transfer process.
- Monitor and log the data transfer process for accountability and troubleshooting.

## Technologies Used
- **Python**: The core programming language used to develop the application.
- **PostgreSQL**: The database from which the data is extracted using SQL queries.
- **SFTP**: The protocol used for secure file transfer between servers.
- **WinSCP**: A file transfer client used to monitor the data transfer process.
- **CSV**: The format used to save the extracted data before transfer.

## Installation and Usage
1. **Clone the Repository**:
   ```bash
   git clone "https://github.com/mngembu/Automated-file-transfer-to-remote-server-Python-SQL-SFTP.git"
   cd automated-file-transfer-system

2. **Set Up the Virtual Environment** 
 ```bash
python -m venv venv
source venv/bin/activate  # On Windows, use `venv\Scripts\activate`

3. **Install Dependencies**:
```bash
python -m pip install -r requirements.txt

4. **Configure the Application**:
- Update the config.ini file with the necessary database credentials, SFTP server details, and other configuration settings.

5. **Run the Application**:
```bash
python run_scripts.py

6. **Monitor the Transfer Process**:
- Use WinSCP or another SFTP client to monitor the file transfer process and ensure successful completion.

## Dependencies
- Pamariko: To authenticate the server during SSH. Used to handle SFTP connections and file transfers.
- psycopg2: A PostgreSQL adapter for Python, used to connect to the PostgreSQL database and execute SQL queries.
- pandas: Used to manipulate and save the extracted data into .csv files.
- python-dotenv: For loading environment variables from a .env file (if used).
- WinSCP: External software used for monitoring the SFTP file transfer process.


Note:
Ensure that you have the necessary permissions and credentials to access the servers and databases involved in this project.


## Contact

If you have any questions, feel free to reach out to me at ara.ngembu@yahoo.com.

Author: Mary Ara Ngembu





   
