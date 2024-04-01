FROM elixir:1.16.2

WORKDIR /shorter


RUN apt-get update && \
    apt-get install -y postgresql-client inotify-tools wget && \
    rm -rf /var/lib/apt/lists/*


RUN wget -q -O /usr/local/bin/wait-for-it https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && \
    chmod +x /usr/local/bin/wait-for-it


RUN mix local.hex --force && \
    mix local.rebar --force


COPY mix.exs mix.lock ./
RUN mix deps.get && mix deps.compile


COPY . .


COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh


RUN mix compile


CMD ["/entrypoint.sh"]
