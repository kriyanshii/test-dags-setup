# Test DAGs Setup

This project contains a collection of test DAGs (Directed Acyclic Graphs) and a script to automatically enqueue them via API calls. The `start.sh` script discovers all YAML DAG definition files in the `dags/` directory and enqueues each one to the workflow orchestration system running on `localhost:8080`. The script is configurable through environment variables for API host, UI origin, remote node, and payload parameters.

