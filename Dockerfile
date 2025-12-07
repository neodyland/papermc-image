FROM ghcr.io/astral-sh/uv:bookworm AS prepare

WORKDIR /app

COPY pyproject.toml uv.lock ./
RUN uv sync --locked

COPY . .
RUN uv run main.py

FROM ubuntu:24.04

WORKDIR /app

RUN apt-get update && \
    apt-get install -y wget openjdk-25-jre && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=prepare /app/latest.txt ./
RUN wget -O papermc.jar $(cat latest.txt)

CMD ["java", "-Xms512M", "-Xmx1024M", "-jar", "papermc.jar", "nogui"]