
FROM elixir:1.16.2


WORKDIR /shorter


RUN apt-get update && \
    apt-get install -y postgresql-client inotify-tools

COPY . .
COPY entrypoint.sh /entrypoint.sh


RUN chmod +x /entrypoint.sh


RUN mix local.hex --force && \
    mix local.rebar --force


COPY mix.exs mix.lock ./
RUN mix deps.get && \
    mix deps.compile


RUN mix compile


ENTRYPOINT ["/entrypoint.sh"]


CMD ["mix", "phx.server"]
