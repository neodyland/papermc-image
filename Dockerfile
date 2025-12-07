FROM ghcr.io/astral-sh/uv:bookworm AS prepare

WORKDIR /app

RUN apt-get update && \
    apt-get install -y wget

COPY pyproject.toml uv.lock ./
RUN uv sync --locked

COPY . .
RUN uv run main.py

RUN wget -O papermc.jar $(cat latest.txt)

FROM gcr.io/distroless/java21-debian12

WORKDIR /app

RUN cat <<EOF > /app/eula.txt
eula=true
EOF

COPY --from=prepare /app/papermc.jar .

COPY run.sh .

CMD ["/bin/bash", "./run.sh"]