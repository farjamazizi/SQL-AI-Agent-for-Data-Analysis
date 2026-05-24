# Build with AI: Safe and Scalable SQL AI Agents
This is the repository for the LinkedIn Learning course `Build with AI: Safe and Scalable SQL AI Agents`. The full course is available from [LinkedIn Learning][lil-course-url].

![lil-thumbnail-url]

## Course Description

<p>Make SQL agents product-ready by learning how to leverage Python, LangChain, and LLM frameworks. First, learn about the overall architecture of SQL AI agents by focusing on building a robust framework that uses deterministic information. Find out how to create effective prompt templates, add context, and inject memory into agents to handle complex and dynamic queries with ease. Dive into safety assurance, query validations, and safety constraints. Review monitoring systems and error-handling process. Then, set up logs to track the agent performance with MLflow. Last but not least, see how to implement multiple AI agents to process the data. </p><p>This course is designed for data scientists and engineers but is also beneficial to data analysts seeking to increase knowledge and build operational skills in AI systems. By the end of the course, you will have learned how to prototype SQL AI agents and deploy them responsibly into production environments. </p>

_See the readme file in the main branch for updated instructions and information._

## Local Setup

This local copy is configured to run from WSL with the `sql-agent-ai` conda
environment and local PostgreSQL on `localhost:5432`.

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

Use `host="localhost"` in notebooks and scripts. The original course Docker
setup used `host="postgres"` because `postgres` was a Docker Compose service
name.

### Docker Status

This working copy is now configured as a local WSL/conda project. Docker files
are not required for the current workflow and have been removed from this copy.
If you later want to restore the course's original container workflow, recover
the Docker assets from the upstream repository.

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

## Instructions
This repository has branches for each of the videos in the course. You can use the branch pop up menu in github to switch to a specific branch and take a look at the course at that stage, or you can add `/tree/BRANCH_NAME` to the URL to go to the branch you want to access.

## Branches
The branches are structured to correspond to the videos in the course. The naming convention is `CHAPTER#_MOVIE#`. As an example, the branch named `02_03` corresponds to the second chapter and the third video in that chapter. 
Some branches will have a beginning and an end state. These are marked with the letters `b` for "beginning" and `e` for "end". The `b` branch contains the code as it is at the beginning of the movie. The `e` branch contains the code as it is at the end of the movie. The `main` branch holds the final state of the code when in the course.

When switching from one exercise files branch to the next after making changes to the files, you may get a message like this:

    error: Your local changes to the following files would be overwritten by checkout:        [files]
    Please commit your changes or stash them before you switch branches.
    Aborting

To resolve this issue:
	
    Add changes to git using this command: git add .
	Commit changes using this command: git commit -m "some message"


## Instructor

Rami Krispin

Senior Manager, Data Science and Engineering
                            

Check out my other courses on [LinkedIn Learning](https://www.linkedin.com/learning/instructors/).


[0]: # (Replace these placeholder URLs with actual course URLs)

[lil-course-url]: https://www.linkedin.com/learning/build-with-ai-sql-ai-agents-in-production
[lil-thumbnail-url]: https://media.licdn.com/dms/image/v2/D560DAQEGUp_kqxS8qw/learning-public-crop_675_1200/B56ZxOVEW9IQAY-/0/1770840672587?e=2147483647&v=beta&t=LMvCyFpIJRhmDCJ4HGZ8RSAthm2SHdx0sWoCAFTB6-w
# SQL-AI-Agent-for-Data-Analysis
