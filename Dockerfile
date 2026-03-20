FROM ghcr.io/astral-sh/uv:bookworm AS prepare

WORKDIR /app

RUN apt-get update && \
    apt-get install -y wget

COPY pyproject.toml uv.lock ./
RUN uv sync --locked

COPY . .
RUN uv run main.py

RUN wget -O papermc.jar $(cat latest.txt)

FROM ubuntu:24.04 AS file-creator

WORKDIR /app

RUN cat <<EOF > /app/eula.txt
eula=true
EOF

FROM gcr.io/distroless/java21-debian12

WORKDIR /app

COPY --from=file-creator /app/eula.txt .

COPY server.properties .

COPY --from=prepare /src/papermc.jar .

ENV JAVA_OPTS="XX:-UseContainerSupport"
ENTRYPOINT ["java", "-jar", "/src/papermc.jar", "-nogui"]
