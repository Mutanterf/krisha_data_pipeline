import subprocess
from data_parse import main

if __name__ == "__main__":
    URL = "https://krisha.kz/prodazha/kvartiry/?page={}"
    main(URL, pages=5)
    print("3) Running dbt…")
    subprocess.run(["dbt","run"], check=True)
    print("Done.")
