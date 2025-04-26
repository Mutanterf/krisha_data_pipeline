
import os, time
import psycopg2
from psycopg2.extras import execute_values
import pandas as pd
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
import re

PG = {
    "user": os.getenv("PG_USER","postgres"),
    "pw":   os.getenv("PG_PASSWORD","Mika2u7w"),
    "host": os.getenv("PG_HOST","localhost"),
    "port": os.getenv("PG_PORT","5432"),
    "db":   os.getenv("PG_DB","krisha_data"),
}

CONN_INFO = (
    f"dbname={PG['db']} user={PG['user']} password={PG['pw']}"
    f" host={PG['host']} port={PG['port']}"
)

def info(x):
    name = x[0].strip()
    sqm  = float(x[1].rstrip(" м²"))
    rooms= int(name.split("-")[0])
    return name, rooms, sqm

def get_price(txt):
    digits_only = re.sub(r"\D+", "", txt)
    return int(digits_only) if digits_only else 0

def stats(txt):
    i = next((i for i,ch in enumerate(txt) if ch.isdigit()), len(txt))
    return txt[:i].strip(), txt[i:i+10].strip()

def get_YE(txt):
    return int(txt.split("г.п")[0].split()[-1]) if "г.п" in txt else None


def parse_data(page_url, num_pages=5):
    opts = Options()
    opts.add_argument("--headless")
    service = Service(os.path.join(os.path.dirname(__file__),
                                   "chromedriver-win64","chromedriver.exe"))
    driver = webdriver.Chrome(service=service, options=opts)

    records = []
    for p in range(1, num_pages+1):
        driver.get(page_url.format(p))
        time.sleep(0.3)
        for card in driver.find_elements(By.CLASS_NAME,"a-card__descr"):
            title = card.find_element(By.CLASS_NAME,"a-card__title").text.split("·")
            name, rooms, sqm = info(title)
            price           = get_price(card.find_element(By.CLASS_NAME,"a-card__price").text)
            city, date      = stats(card.find_element(By.CLASS_NAME,"a-card__stats").text)
            ye              = get_YE(card.find_element(By.CLASS_NAME,"a-card__text-preview").text)

            records.append((name, rooms, sqm, price, city, date, ye))
    driver.quit()
    return pd.DataFrame(records,
        columns=["name","rooms","sqm","price","city","date","year_of_est"]
    )

def load_to_postgres(df, table="raw_flats"):
    if df.empty:
        print("⚠️  No rows to load.")
        return

    cols = df.columns.tolist()
    vals = [tuple(x) for x in df.to_numpy()]

    with psycopg2.connect(CONN_INFO) as conn:
        with conn.cursor() as cur:
            cur.execute(f"DROP TABLE IF EXISTS public.{table}")
            cur.execute(f"""
            CREATE TABLE public.{table} (
              name          text,
              rooms         int,
              sqm           float,
              price         int,
              city          text,
              date          text,
              year_of_est   int
            )
            """)
            sql = f"INSERT INTO public.{table} ({','.join(cols)}) VALUES %s"
            execute_values(cur, sql, vals, page_size=500)
        conn.commit()
    print(f"✔ Loaded {len(df)} rows into public.{table}")

def main(page_url, pages=5):
    print("1) Scraping…", end=" ")
    df = parse_data(page_url, pages)
    print(f"→ Scraped {len(df)} rows")
    print("2) Loading to Postgres…", end=" ")
    load_to_postgres(df)
    return df
