from airflow import DAG
from datetime import datetime
# from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from airflow.utils.email import send_email


def send_failure_email(context):
    subject = "test email via sendgrid"
    body = """
    <h3>
    hello from airflow your dag is failed
    </h3>    
    <p> this  email was sent using sendgrid </P>
    """
    send_email('drmohamedahmedb@gmail.com', subject , body)
    
    
with DAG(
    dag_id = "airbnb", 
    start_date = datetime(2025 , 10 ,16 , 12 , 50),
    schedule = "0 0 * * *",
    catchup=False
) as dag:
    
    # send_mail = PythonOperator(
    #     task_id = "send_mail", 
    #     python_callable = send_failure_email
    # )
    
   
    run_macro_and_run = BashOperator(
        task_id="run_macro_and_run",
        bash_command=(
            "dbt run-operation handle_blank_auto "
            "--profiles-dir /usr/local/airflow/include "
            "--project-dir /usr/local/airflow/dbt_project_ && "
            "dbt run --profiles-dir /usr/local/airflow/include "
            "--project-dir /usr/local/airflow/dbt_project_"
        ),
        on_failure_callback=send_failure_email
    )
    
    run_snapshot = BashOperator(
        task_id="run_snapshot",
        bash_command=(
            "dbt snapshot --profiles-dir /usr/local/airflow/include "
            "--project-dir /usr/local/airflow/dbt_project_"
        ),
        on_failure_callback=send_failure_email
    )

    run_macro_and_run >> run_snapshot
    
