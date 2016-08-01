FROM nginx:latest

ADD res/* /
RUN chmod +x /*.sh

EXPOSE 80
# EXPOSE 443

CMD /entrypoint.sh