import threading
import subprocess
import sys


def run_script(script_name):
    subprocess.run([sys.executable, script_name])    #instead of simply "python" use sys.executable as python path to ease finding the path in your computer

if __name__ == "__main__":
    script1_thread = threading.Thread(target=run_script, args=("wesa_donors_adc.py",))
    script2_thread = threading.Thread(target=run_script, args=("wesa_donors_stores.py",))
    script3_thread = threading.Thread(target=run_script, args=("wesa_labour.py",))
    script4_thread = threading.Thread(target=run_script, args=("wesa_sales.py",))

    script1_thread.start()
    script2_thread.start()
    script3_thread.start()
    script4_thread.start()

    script1_thread.join()
    script2_thread.join()
    script3_thread.join()
    script4_thread.join()

    print("All 4 scripts have finished executing.")