from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import smtplib
import os
from dotenv import load_dotenv

load_dotenv() # this loads all the environment variables

def send_alert_email(error_message):
    # Email configuration
    sender_email = os.getenv("SENDER")
    receiver_email = os.getenv("RECEIVER")
    password = os.getenv("PWD_EMAIL")

    # Email content
    message = MIMEMultipart()
    message['From'] = sender_email
    message['To'] = receiver_email
    message['Subject'] = "SFTP Upload Failed"
    body = f"Error occurred during SFTP upload:\n{error_message}"
    message.attach(MIMEText(body, 'plain'))

    # Connect to SMTP server and send email
    with smtplib.SMTP('smtp.gmail.com', 587) as server:
        server.starttls()
        server.login(sender_email, password)
        server.sendmail(sender_email, receiver_email, message.as_string())
    print("Alert email sent")