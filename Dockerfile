FROM debian:jessie
MAINTAINER Vijay Korapaty <mediagoblin@korapaty.com>

# Base requirements
RUN apt-get update && \
    apt-get install -y sudo git-core python python-dev \
    python-lxml python-imaging python-virtualenv

# Video and audio requirements
RUN apt-get update \
    && apt-get install -y python-gst0.10 gstreamer1.0-libav \
    gstreamer0.10-plugins-base \
    gstreamer0.10-plugins-bad \
    gstreamer0.10-plugins-good \
    gstreamer0.10-plugins-ugly

# Additional audio requirements
RUN apt-get update \
    && apt-get install -y libasound2-dev python-numpy python-scipy \
    libsndfile1-dev

# Postgres
RUN apt-get update \
    && apt-get install -y postgresql postgresql-client python-psycopg2

RUN apt-get update && apt-get upgrade -y

# Drop Privileges for MediaGoblin
RUN useradd -c "GNU MediaGoblin system account" -d /var/lib/mediagoblin \
    -m -r -g www-data mediagoblin
RUN groupadd mediagoblin
RUN usermod --append -G mediagoblin mediagoblin

# MediaGoblin code and setup
RUN mkdir -p /srv/mediagoblin.example.org
WORKDIR /srv/mediagoblin.example.org
RUN git clone git://git.savannah.gnu.org/mediagoblin.git -b stable --depth 1
RUN chown -hR mediagoblin:www-data /srv/mediagoblin.example.org
WORKDIR /srv/mediagoblin.example.org/mediagoblin
RUN git submodule init && git submodule update
RUN (virtualenv --system-site-packages . || virtualenv .) \
    && ./bin/python setup.py develop

# For spectrograms of audio
RUN ./bin/pip install scikits.audiolab

ADD mediagoblin_local.ini /srv/mediagoblin.example.org/mediagoblin/mediagoblin_local.ini
ADD entrypoint.sh /srv/mediagoblin.example.org/mediagoblin/entrypoint.sh

ENTRYPOINT ["/srv/mediagoblin.example.org/mediagoblin/entrypoint.sh"]
CMD ["/bin/bash"]
