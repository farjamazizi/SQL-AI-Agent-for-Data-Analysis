# Safe SQL AI Agent for Local Data Analysis

A local-first SQL AI agent that turns natural-language questions into safe SQL
queries for local data analysis. It can query a bundled DuckDB dataset or a
local PostgreSQL database, enrich prompts with table context, optionally review
generated SQL with a second LLM pass, validate SQL before execution, and show
results in Streamlit.

The current working demo uses OpenAI models. Other providers are kept as future
extension points in the configuration.

## Demo

Watch the project demo: [demo/demo-of-project.mp4](demo/demo-of-project.mp4)

## Local Setup

This project is configured for a local WSL/conda workflow. Install it in editable
mode from the repository root:

```bash
cd /home/farjam/sql-agent-ai
conda activate sql-agent-ai
pip install -e .
```

Create a local `.env` file with your credentials and database settings:

```bash
OPENAI_API_KEY="your-openai-key"
POSTGRES_USER="postgres"
POSTGRES_PASSWORD="password"
POSTGRES_HOST="localhost"
POSTGRES_PORT="5432"
POSTGRES_DATABASE="my_db"
```

Check PostgreSQL before running notebooks that use the Postgres backend:

```bash
pg_isready -h localhost -p 5432
```

Use `host="localhost"` in notebooks and scripts when connecting to PostgreSQL
from this local setup.

## Run The Apps

Run the main SQL agent Streamlit app:

```bash
streamlit run app/agent_app.py
```

Run the logs dashboard:

```bash
streamlit run app/logs_app.py
```

For the simplest local run, choose DuckDB in the app sidebar. PostgreSQL requires
the local `my_db` database to exist.

## Workflow

The main workflow starts in `app/agent_app.py` and runs through
`sql_ai_agent/SqlAgent.py`:

1. Choose a backend in Streamlit.
   - DuckDB loads the sample `data/air_traffic_gold.csv` file into an in-memory
     `air_traffic` table.
   - PostgreSQL connects with the credentials from `.env` and expects an
     `air_traffic` table in the configured database.

2. Configure the agent from the sidebar.
   - Select the LLM provider and model from `llm_config.yaml`.
   - Enable optional memory for follow-up questions.
   - Enable safety options such as read-only mode and maximum result limits.
   - Enable structured logging or database logging when you want to inspect
     prompts, generated SQL, validation results, and execution outcomes.
   - Enable the SQL Review Agent when you want a second LLM pass before
     execution.

3. Ask a natural-language question.
   - The agent inspects the selected table schema.
   - It can add distinct character values and table-specific context from the
     `skills/` directory.
   - It sends the question, schema, database type, table name, optional memory,
     and extra context to the LLM.

4. Generate and optionally review SQL.
   - The primary LLM returns SQL, including SQL inside markdown code blocks.
   - If SQL review is enabled, a second prompt checks whether the SQL answers the
     question and follows the available context. The reviewer either approves the
     query or returns a corrected query.

5. Validate before execution.
   - `SQLValidator` parses the query with `sqlglot`.
   - In read-only mode, it blocks unsafe statement types such as `UPDATE`,
     `DELETE`, `DROP`, and multi-statement SQL.
   - When result limits are enabled, it adds or tightens a `LIMIT` clause before
     the query reaches the database.

6. Execute and display results.
   - The validated query is executed through the Ibis/DuckDB or Ibis/PostgreSQL
     connection.
   - Results are returned as a pandas DataFrame and displayed in Streamlit along
     with the generated SQL and any errors.
   - If a validated query fails at execution time, the debug agent can retry with
     the error message. If fallback is enabled, the fallback model can make a
     final attempt.

## SQL Review Agent

The core `SqlAgent` supports an optional SQL Review Agent. When enabled, the
first LLM generates SQL, then a second LLM review pass checks whether the query
matches the user question and domain rules before validation and execution.

In Python:

```python
agent = SqlAgent(..., sql_review=True)
```

In Streamlit, enable **SQL Review Agent** in the sidebar. This improves semantic
quality but adds one extra LLM call per question.
