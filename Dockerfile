FROM renovate/base@sha256:175e2d040a8dbd7900d815621e386efed1ca9c4f40e5aaf1902d4632f1bf645f

USER root

RUN cd /tmp && \
    curl https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb -o erlang-solutions_1.0_all.deb && \
    dpkg -i erlang-solutions_1.0_all.deb && \
    rm -f erlang-solutions_1.0_all.deb

ARG ERLANG_VERSION=22.0.2-1

RUN apt-get update && \
    apt-cache policy esl-erlang && \
    apt-get install -y esl-erlang=1:$ERLANG_VERSION && \
    apt-get clean

USER ubuntu

# The following is from https://stackoverflow.com/a/34326368/3005034
RUN erl -eval '{ok, Version} = file:read_file(filename:join([code:root_dir(), "releases", erlang:system_info(otp_release), "OTP_VERSION"])), io:fwrite(Version), halt().' -noshell
