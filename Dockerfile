FROM ghcr.io/astral-sh/uv:bookworm AS prepare

WORKDIR /app

RUN apt-get update && \
    apt-get install -y wget

COPY pyproject.toml uv.lock ./
RUN uv sync --locked

RUN wget -O papermc.jar $(cat latest.txt)

COPY . .
RUN uv run main.py

FROM ubuntu:24.04

WORKDIR /app

RUN cat <<EOF > /app/eula.txt
eula=true
EOF

RUN apt-get update && \
    apt-get install -y openjdk-25-jre && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=prepare /app/papermc.jar .

CMD ["java", "-Xms512M", "-Xmx1024M", "-jar", "papermc.jar", "nogui"]