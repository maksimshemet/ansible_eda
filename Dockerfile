FROM python:3.10-slim

# Install system deps
RUN apt-get update && apt-get install -y \
    git \
    curl \
    gcc \
    python3-dev \
    default-jdk \
    && apt-get clean

# Set JAVA_HOME because Kafka plugin needs it
ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV PATH="$JAVA_HOME/bin:${PATH}"

# Install Ansible + EDA Engine
RUN pip install --no-cache-dir ansible ansible-rulebook

# Install event source collection
RUN ansible-galaxy collection install ansible.eda

WORKDIR /app
COPY . /app

EXPOSE 5000

CMD ["ansible-rulebook", "-r", "test-rulebook.yml", "-i", "inventory.yml"]
