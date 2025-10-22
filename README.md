#  Airflow–Snowflake–dbt Pipeline

##  Overview  
A data pipeline built with **Airflow**, **Snowflake**, and **dbt** running in **Docker**.  
The pipeline loads raw CSV data into Snowflake and transforms it using dbt models, macros, and snapshots.

---

## ⚙️ Workflow  
1. **Extract & Load:** Load data from CSV into **Snowflake** tables.  
2. **Transform:** Use **dbt models** and **macros** for data cleaning and transformation.  
3. **Snapshot:** Track historical data changes using **dbt snapshots**.  
4. **Orchestration:** All steps are managed through **Airflow DAGs** in Docker containers.

---

## 🧩 Tech Stack  
- **Airflow** – Workflow orchestration  
- **Snowflake** – Cloud data warehouse  
- **dbt** – Data transformation  
- **Docker** – Containerized environment  
- **CSV** – Data source  

---

## 📁 Project Structure  
```
dags/ # Airflow DAGs (airbnb_dag.py, exampledag.py)
dbt_env/ # Virtual environment/config
dbt_project/
├─ models/ # dbt models (example, staging)
├─ macros/ # Custom dbt macros (handle_blank.sql)
├─ snapshots/ # dbt snapshots
├─ seeds/ # Seed data if needed
├─ tests/ # dbt tests
└─ dbt_project.yml # Main dbt config
include/ # Connection profiles and configs
data/ # Raw CSV files
```

