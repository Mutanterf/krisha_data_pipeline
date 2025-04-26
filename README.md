# krisha_data_pipeline

A simple end‑to‑end data pipeline that:

1. **Scrapes** apartment listings from [krisha.kz](https://krisha.kz)
2. **Loads** raw data into a PostgreSQL table
3. **Transforms** the data using dbt

---

## 🚀 Prerequisites

Before you begin, ensure you have the following installed:

- **Python 3.8+**
- **PostgreSQL** (create a database named `krisha_data` or set `PG_DB` accordingly)
- **Chromedriver** matching your Chrome version (placed in `chromedriver-win64/`)
- **dbt Core** (`pip install dbt-core dbt-postgres`)

---

## 🔧 Installation

1. Clone the repo:
   ```bash
   git clone https://github.com/Mutanterf/krisha_data_pipeline.git
   cd krisha_data_pipeline
   ```

2. Install Python dependencies:


3. Install dbt and the Postgres adapter:
   ```bash
   pip install dbt-core dbt-postgres
   ```

---

## ⚙️ Configuration

1. **PostgreSQL**
   - Create a database (default: `krisha_data`).
   - Ensure you have a user/password with privileges:
     ```sql
     CREATE DATABASE krisha_data;
     CREATE USER myuser WITH PASSWORD 'mypassword';
     GRANT ALL PRIVILEGES ON DATABASE krisha_data TO myuser;
     ```

2. **Environment Variables** (optional — defaults shown below)
   ```bash
   export PG_USER=postgres
   export PG_PASSWORD=Mika2u7w
   export PG_HOST=localhost
   export PG_PORT=5432
   export PG_DB=krisha_data
   ```

3. **Chromedriver**
   - Place the ChromeDriver binary at `chromedriver-win64/chromedriver.exe` (Windows) or adjust `data_parse.py` path.

---

## 🏃 Running the Pipeline

From the project root:

```bash
python run_pipeline.py
```

Steps performed:

1. **Scrapes** first 5 pages of listings from `https://krisha.kz/prodazha/kvартиры/?page={}`
2. **Loads** scraped records into `public.raw_flats` table in Postgres
3. **Executes** `dbt run` to materialize:
   - `raw_data` table (from `raw_flats`)
   - `transform_data` table (cleaned)
   - `final_model` table (aggregated)

---

## 🔍 Inspecting Results

Connect to your database and check the tables:

```sql
-- Connect to krisha_data;
SELECT * FROM public.raw_flats LIMIT 10;
SELECT * FROM public.raw_data LIMIT 10;
SELECT * FROM public.transform_data LIMIT 10;
SELECT * FROM public.final_model LIMIT 10;
```

---

## 📈 dbt Models

- **raw_data** (`models/raw_data.sql`):
  - Reads from Postgres table `raw_flats`
  - Filters out rows with null prices

- **transform_data** (`models/transform_data.sql`):
  - Additional business logic & filtering

- **final_model** (`models/marts/final_model.sql`):
  - Final result for reporting or downstream analytics

---



