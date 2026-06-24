FROM python:3.14-slim

WORKDIR /app
COPY . .

RUN pip install -e .

CMD ["streamlit", "run", "app/agent_app.py"]
EXPOSE 8501
