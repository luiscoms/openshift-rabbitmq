FROM luiscoms/centos7-erlang

MAINTAINER Luis Fernando Gomes <your@luiscoms.com.br>

ENV RABBITMQ_VERSION 3.6.5
RUN yum install -y http://www.rabbitmq.com/releases/rabbitmq-server/v${RABBITMQ_VERSION}/rabbitmq-server-${RABBITMQ_VERSION}-1.noarch.rpm && yum clean all
RUN echo "[{rabbit,[{loopback_users,[]}]}]." > /etc/rabbitmq/rabbitmq.config
RUN find / -name ".erlang.cookie"
EXPOSE 4369 5671 5672 25672
# RUN rm -rf /var/lib/rabbitmq/mnesia

# get logs to stdout (thanks @dumbbell for pushing this upstream! :D)
ENV RABBITMQ_LOGS=- RABBITMQ_SASL_LOGS=-

RUN /usr/sbin/rabbitmq-plugins enable --offline rabbitmq_management
EXPOSE 15671 15672

# LABEL io.k8s.description="RabbitMQ application" \
#      io.k8s.display-name="builder x.y.z" \
#      io.openshift.expose-services="8080:http" \
#      io.openshift.tags="builder,x.y.z,etc."

# RUN yum install -y ... && yum clean all -y

# COPY ./.s2i/bin/ ${STI_SCRIPTS_PATH}

# ENV RABBITMQ_CONFIG_FILE=/opt/app-root/config/rabbitmq
# RUN mkdir -p /opt/app-root/config && echo "[{rabbit,[{loopback_users,[]}]}]." > $RABBITMQ_CONFIG_FILE
# ENV RABBITMQ_SERVER_ERL_ARGS="-setcookie rabbit"
# ENV RABBITMQ_CTL_ERL_ARGS="-setcookie rabbit"

RUN chown -R rabbitmq:rabbitmq /opt/app-root && \
	chown -R rabbitmq:rabbitmq /var/log/rabbitmq/ && \
	chown -R rabbitmq:rabbitmq /var/lib/rabbitmq && \
	chown -R rabbitmq:rabbitmq /etc/rabbitmq/ && \
	chown -R rabbitmq:rabbitmq /usr/sbin/rabbitmq*

# set home so that any `--user` knows where to put the erlang cookie
ENV HOME /var/lib/rabbitmq

USER "rabbitmq"

COPY ./docker-entrypoint.sh /usr/local/bin/
# CMD "$STI_SCRIPTS_PATH/run"
# CMD "/docker-entrypoint.sh"
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["rabbitmq-server"]
