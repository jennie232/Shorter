
FROM elixir:1.16.2


WORKDIR /shorter


RUN mix local.hex --force && \
    mix local.rebar --force


RUN apt-get update && \
    apt-get install -y postgresql-client inotify-tools && \
    rm -rf /var/lib/apt/lists/*


COPY mix.exs mix.lock ./
RUN mix deps.get && mix deps.compile


COPY . .

RUN ls -la


RUN chmod +x entrypoint.sh

RUN mix compile


CMD ["/entrypoint.sh"]
