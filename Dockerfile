FROM alpine/curl:latest

ADD https://raw.githubusercontent.com/eficode/wait-for/v2.2.3/wait-for wait-for.sh
RUN chmod +x wait-for.sh

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["./wait-for.sh"]

