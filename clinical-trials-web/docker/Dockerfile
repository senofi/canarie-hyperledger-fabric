### Build ###
FROM senofi/ci-build as builder

ARG uiprofile

USER root

COPY . /build
WORKDIR /build

RUN npm install -g @quasar/cli

ENV GRADLE_OPTS "-Dorg.gradle.daemon=false -Xmx512m"
ENV QENV=$uiprofile

RUN echo "Active environment: $QENV"
RUN ./gradlew :bootwar -x test

### Image ###
FROM adoptopenjdk/openjdk11:alpine-jre

RUN adduser -u 1001 -D -s /bin/sh fabric
WORKDIR /home/fabric

COPY --from=builder /build/build/libs/*.war app.war

ARG uiprofile

RUN echo "Active Spring profile: $uiprofile"

ENV SPRING_OUTPUT_ANSI_ENABLED=ALWAYS \
    SPRING_PROFILES_ACTIVE="default,prod,$uiprofile" \
    JHIPSTER_SLEEP=0 \
    JAVA_OPTS=""

ADD ./docker/entrypoint.sh entrypoint.sh
RUN chmod 755 entrypoint.sh && chown fabric:fabric entrypoint.sh
RUN mkdir -p /var/consortia/app && chown fabric:fabric /var/consortia/app 
USER fabric

ENTRYPOINT ["./entrypoint.sh"]

EXPOSE 8088 5701/udp

#HEALTHCHECK --interval=1m --timeout=3s CMD wget -q -S http://localhost:8088/management/health || exit 1

#docker build -f docker/Dockerfile -build-arg 'uiprofile=nova' -t senofi/trials-web:latest .