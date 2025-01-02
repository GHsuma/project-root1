# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the backend and requirements files
COPY src/backend /app/backend
COPY src/backend/requirements.txt /app/

# Install the required Python packages
RUN pip install --no-cache-dir -r /app/requirements.txt

# Expose the port that Flask runs on
EXPOSE 5000

# Set environment variable for Flask
ENV FLASK_APP=backend/app.py

# Run the Flask app when the container starts
CMD ["python", "/app/backend/app.py"]
