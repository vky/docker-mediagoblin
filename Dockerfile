FROM debian:jessie
MAINTAINER Vijay Korapaty <mediagoblin@korapaty.com>

# Base requirements
RUN apt-get update && \
    apt-get install -y sudo git-core python python-dev \
    python-lxml python-imaging python-virtualenv

# Video and audio requirements
RUN apt-get update && \
    apt-get install -y \
        python-gst-1.0 \
        gstreamer1.0-libav \
        gstreamer1.0-plugins-base \
        gstreamer1.0-plugins-bad \
        gstreamer1.0-plugins-good \
        gstreamer1.0-plugins-ugly \
        gir1.2-gstreamer-1.0 \
        gir1.2-gst-plugins-base-1.0

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
RUN mkdir -p /srv/mediagoblin
WORKDIR /srv/mediagoblin
RUN git clone git://git.savannah.gnu.org/mediagoblin.git -b stable --depth 1
RUN chown -hR mediagoblin:www-data /srv/mediagoblin
WORKDIR /srv/mediagoblin/mediagoblin
RUN git submodule init && git submodule update
RUN (virtualenv --system-site-packages . || virtualenv .) \
    && ./bin/python setup.py develop

# For spectrograms of audio
RUN ./bin/pip install scikits.audiolab

ADD mediagoblin_local.ini /srv/mediagoblin/mediagoblin/mediagoblin_local.ini
ADD entrypoint.sh /srv/mediagoblin/mediagoblin/entrypoint.sh

ENTRYPOINT ["/srv/mediagoblin/mediagoblin/entrypoint.sh"]
CMD ["/bin/bash"]
